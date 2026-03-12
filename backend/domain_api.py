"""
Domain.com.au API 客户端
- OAuth2 client_credentials 认证 + token 自动刷新
- 30 分钟响应缓存（免费套餐频率限制保护）
- 线程安全
"""

import os
import time
import hashlib
import threading
from typing import Optional

import httpx

# ====== 配置 ======
AUTH_URL = "https://auth.domain.com.au/v1/connect/token"
API_BASE = "https://api.domain.com.au/v1"
SCOPE = "api_listings_read"
CACHE_TTL = 1800  # 30 分钟缓存

# ====== 模块级状态 ======
_token: Optional[str] = None
_token_expiry: float = 0
_token_lock = threading.Lock()

# 响应缓存: { cache_key: (expiry_timestamp, data) }
_cache: dict[str, tuple[float, any]] = {}
_cache_lock = threading.Lock()

# HTTP 客户端（复用连接池）
_client: Optional[httpx.Client] = None


def _get_client() -> httpx.Client:
    """获取或创建 HTTP 客户端"""
    global _client
    if _client is None:
        _client = httpx.Client(timeout=15.0)
    return _client


def _get_credentials() -> tuple[str, str]:
    """从环境变量获取凭证"""
    client_id = os.getenv("DOMAIN_API_CLIENT_ID", "")
    client_secret = os.getenv("DOMAIN_API_CLIENT_SECRET", "")
    return client_id, client_secret


def _get_token() -> str:
    """获取或刷新 OAuth2 token（线程安全）"""
    global _token, _token_expiry

    # 快速路径：token 有效
    if _token and time.time() < _token_expiry:
        return _token

    with _token_lock:
        # 双重检查
        if _token and time.time() < _token_expiry:
            return _token

        client_id, client_secret = _get_credentials()
        if not client_id or not client_secret:
            raise ValueError("DOMAIN_API_CLIENT_ID 和 DOMAIN_API_CLIENT_SECRET 环境变量未设置")

        try:
            client = _get_client()
            resp = client.post(
                AUTH_URL,
                data={
                    "grant_type": "client_credentials",
                    "client_id": client_id,
                    "client_secret": client_secret,
                    "scope": SCOPE,
                },
                headers={"Content-Type": "application/x-www-form-urlencoded"},
            )
            resp.raise_for_status()
            data = resp.json()

            _token = data["access_token"]
            expires_in = data.get("expires_in", 3600)
            # 在 90% 有效期时刷新
            _token_expiry = time.time() + expires_in * 0.9

            print(f"[Domain API] Token 获取成功，有效期 {expires_in}s")
            return _token

        except Exception as e:
            print(f"[Domain API] Token 获取失败: {e}")
            raise


def _cache_key(prefix: str, **kwargs) -> str:
    """生成缓存 key"""
    raw = f"{prefix}:" + ":".join(f"{k}={v}" for k, v in sorted(kwargs.items()))
    return hashlib.md5(raw.encode()).hexdigest()


def _get_cached(key: str):
    """获取缓存数据（如未过期）"""
    with _cache_lock:
        entry = _cache.get(key)
        if entry and time.time() < entry[0]:
            return entry[1]
    return None


def _set_cached(key: str, data):
    """设置缓存数据"""
    with _cache_lock:
        _cache[key] = (time.time() + CACHE_TTL, data)


def _domain_request(method: str, path: str, json_body=None, params=None, retry_on_401=True):
    """
    发送认证请求到 Domain API
    - 自动附加 Bearer token
    - 401 时刷新 token 重试一次
    """
    try:
        token = _get_token()
        client = _get_client()

        resp = client.request(
            method,
            f"{API_BASE}{path}",
            json=json_body,
            params=params,
            headers={"Authorization": f"Bearer {token}"},
        )

        # 401: token 过期，刷新后重试
        if resp.status_code == 401 and retry_on_401:
            global _token_expiry
            _token_expiry = 0  # 强制刷新
            return _domain_request(method, path, json_body=json_body, params=params, retry_on_401=False)

        # 429: 频率限制
        if resp.status_code == 429:
            print("[Domain API] 频率限制 (429)，返回空数据")
            return None

        resp.raise_for_status()
        return resp.json()

    except httpx.HTTPStatusError as e:
        print(f"[Domain API] HTTP 错误 {e.response.status_code}: {e}")
        return None
    except Exception as e:
        print(f"[Domain API] 请求失败: {e}")
        return None


def _normalize_listing(raw: dict) -> dict:
    """将 Domain API 返回的嵌套 listing 标准化为扁平 dict"""
    listing = raw.get("listing", raw)  # v1 search 结果在 listing 字段下

    prop = listing.get("propertyDetails", {})
    price = listing.get("priceDetails", {})
    advertiser = listing.get("advertiser", {})
    media = listing.get("media", [])

    # 构建 Domain URL
    listing_slug = listing.get("listingSlug", "")
    listing_id = listing.get("id", 0)
    domain_url = f"https://www.domain.com.au/{listing_slug}" if listing_slug else ""

    # 首张图片
    image_url = ""
    if media:
        image_url = media[0].get("url", "")

    # 价格
    price_text = price.get("displayPrice", "")
    price_from = price.get("priceFrom", 0)
    price_to = price.get("priceTo", 0)

    return {
        "id": listing_id,
        "address": prop.get("displayableAddress", ""),
        "suburb": prop.get("suburb", ""),
        "property_type": (prop.get("propertyType", "") or "").lower(),
        "bedrooms": prop.get("bedrooms", 0) or 0,
        "bathrooms": prop.get("bathrooms", 0) or 0,
        "car_spaces": prop.get("carspaces", 0) or 0,
        "land_size": prop.get("landArea", 0) or 0,
        "price_text": price_text,
        "price_from": price_from or 0,
        "price_to": price_to or 0,
        "image_url": image_url,
        "domain_url": domain_url,
        "agent_name": advertiser.get("name", ""),
        "agency_name": (advertiser.get("agency") or ""),
        "headline": listing.get("headline", ""),
    }


def search_residential_listings(
    suburb: str,
    postcode: str,
    state: str = "QLD",
    listing_type: str = "Sale",
    page_size: int = 20,
) -> list[dict]:
    """
    搜索在售住宅房源
    POST /v1/listings/residential/_search

    返回标准化的 listing 字典列表。
    失败时返回空列表（不抛异常）。
    """
    # 检查缓存
    ck = _cache_key("search", suburb=suburb, postcode=postcode, listing_type=listing_type, page_size=page_size)
    cached = _get_cached(ck)
    if cached is not None:
        print(f"[Domain API] 缓存命中: {suburb} ({len(cached)} listings)")
        return cached

    body = {
        "listingType": listing_type,
        "locations": [
            {
                "state": state,
                "suburb": suburb,
                "postCode": postcode,
            }
        ],
        "pageSize": page_size,
    }

    data = _domain_request("POST", "/listings/residential/_search", json_body=body)

    if not data or not isinstance(data, list):
        print(f"[Domain API] 搜索返回空或异常: {suburb}")
        # 缓存空结果 5 分钟（避免频繁请求失败端点）
        _set_cached(ck, [])
        return []

    listings = [_normalize_listing(item) for item in data]
    # 过滤掉无地址的无效结果
    listings = [l for l in listings if l.get("address")]

    _set_cached(ck, listings)
    print(f"[Domain API] 搜索完成: {suburb} → {len(listings)} listings")
    return listings


def get_listing_detail(listing_id: int) -> Optional[dict]:
    """
    获取单个房源详情
    GET /v1/listings/{id}
    """
    ck = _cache_key("detail", listing_id=listing_id)
    cached = _get_cached(ck)
    if cached is not None:
        return cached

    data = _domain_request("GET", f"/listings/{listing_id}")
    if not data:
        return None

    result = _normalize_listing(data)
    _set_cached(ck, result)
    return result


def get_sales_results(city: str = "Brisbane") -> Optional[list]:
    """
    获取拍卖/成交结果
    GET /v1/salesResults/{city}
    """
    ck = _cache_key("sales_results", city=city)
    cached = _get_cached(ck)
    if cached is not None:
        return cached

    data = _domain_request("GET", f"/salesResults/{city}")
    if data:
        _set_cached(ck, data)
    return data


def check_api_status() -> dict:
    """检查 Domain API 连通性和凭证状态"""
    client_id, client_secret = _get_credentials()
    if not client_id or not client_secret:
        return {"status": "error", "message": "凭证未配置"}

    try:
        _get_token()
        return {"status": "ok", "message": "Domain API 连接正常"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
