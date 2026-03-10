"""
Compass 房产详情页抓取器
从 Domain.com.au / realestate.com.au 单个房源页面提取房产数据
"""

import urllib.request
import json
import re
import html as _html

_BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/131.0.0.0 Safari/537.36"
)


def scrape_property_listing(url: str) -> dict:
    """
    统一入口：自动识别 Domain/REA，返回标准化房产数据。
    抓取失败返回 {"error": "reason"}，不阻断流程。
    """
    try:
        url = url.strip()
        if "domain.com.au" in url:
            return _scrape_domain(url)
        elif "realestate.com.au" in url:
            return _scrape_rea(url)
        else:
            return {"error": f"不支持的链接: 仅支持 domain.com.au 和 realestate.com.au"}
    except Exception as e:
        print(f"[WARN] scrape_property_listing failed: {e}")
        return {"error": str(e)}


def _fetch_html(url: str) -> str:
    """Chrome UA + 20s timeout 获取网页 HTML"""
    req = urllib.request.Request(url, headers={
        "User-Agent": _BROWSER_UA,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-AU,en;q=0.9",
    })
    with urllib.request.urlopen(req, timeout=20) as resp:
        raw = resp.read()
        charset = resp.headers.get_content_charset() or "utf-8"
        return raw.decode(charset, errors="replace")


def _extract_next_data(html_text: str) -> dict:
    """从 Next.js 页面提取 __NEXT_DATA__ JSON"""
    match = re.search(
        r'<script\s+id="__NEXT_DATA__"\s+type="application/json"[^>]*>(.*?)</script>',
        html_text, re.DOTALL
    )
    if match:
        return json.loads(match.group(1))
    return {}


def _extract_suburb_from_address(address: str) -> str:
    """从地址字符串中尝试提取 suburb"""
    if not address:
        return ""
    # 典型格式: "10 Main St, Sunnybank QLD 4109"
    parts = address.split(",")
    if len(parts) >= 2:
        # 取最后一个逗号后面的部分，去掉州名和邮编
        tail = parts[-1].strip()
        # 移除 QLD/NSW 等 + 邮编
        tail = re.sub(r'\b(QLD|NSW|VIC|SA|WA|TAS|NT|ACT)\b', '', tail, flags=re.IGNORECASE)
        tail = re.sub(r'\b\d{4}\b', '', tail)
        return tail.strip()
    return ""


def _scrape_domain(url: str) -> dict:
    """
    Domain.com.au: 尝试 __NEXT_DATA__ → 备用 HTML 元数据解析
    """
    html_text = _fetch_html(url)
    result = {
        "source": "domain",
        "url": url,
        "address": "",
        "suburb": "",
        "price": "",
        "bedrooms": 0,
        "bathrooms": 0,
        "parking": 0,
        "land_size": 0,
        "property_type": "",
        "description": "",
        "images": [],
    }

    # 策略 1: __NEXT_DATA__
    next_data = _extract_next_data(html_text)
    if next_data:
        props = next_data.get("props", {}).get("pageProps", {})
        listing = props.get("listingDetails", {}) or props.get("listing", {}) or props.get("listingSummary", {})
        if listing:
            result["address"] = listing.get("displayAddress", "") or listing.get("address", "")
            result["price"] = listing.get("price", "") or listing.get("priceDetails", {}).get("displayPrice", "")
            result["bedrooms"] = listing.get("bedrooms", 0) or listing.get("beds", 0)
            result["bathrooms"] = listing.get("bathrooms", 0) or listing.get("baths", 0)
            result["parking"] = listing.get("carspaces", 0) or listing.get("parking", 0)
            result["land_size"] = listing.get("areaSize", 0) or listing.get("landSize", 0) or listing.get("landAreaSqm", 0)
            result["property_type"] = listing.get("propertyType", "") or listing.get("type", "")
            result["description"] = listing.get("description", "")[:1000]

            # 图片
            media = listing.get("media", []) or listing.get("photos", [])
            for m in media[:5]:
                img_url = ""
                if isinstance(m, dict):
                    img_url = m.get("url", "") or m.get("fullUrl", "") or m.get("image", {}).get("url", "")
                elif isinstance(m, str):
                    img_url = m
                if img_url:
                    result["images"].append(img_url)

            # suburb
            addr_parts = listing.get("addressParts", {}) or {}
            result["suburb"] = addr_parts.get("suburb", "") or _extract_suburb_from_address(result["address"])

            if result["address"]:
                return result

    # 策略 2: HTML meta / OG tags + 结构化数据
    _parse_html_meta(html_text, result)
    _parse_ld_json(html_text, result)

    if not result["suburb"]:
        result["suburb"] = _extract_suburb_from_address(result["address"])

    return result


def _scrape_rea(url: str) -> dict:
    """
    realestate.com.au: 尝试 __NEXT_DATA__ → 备用 HTML 元数据解析
    """
    html_text = _fetch_html(url)
    result = {
        "source": "rea",
        "url": url,
        "address": "",
        "suburb": "",
        "price": "",
        "bedrooms": 0,
        "bathrooms": 0,
        "parking": 0,
        "land_size": 0,
        "property_type": "",
        "description": "",
        "images": [],
    }

    # 策略 1: __NEXT_DATA__
    next_data = _extract_next_data(html_text)
    if next_data:
        props = next_data.get("props", {}).get("pageProps", {})
        # REA 可能在多处嵌套
        listing = (
            props.get("property", {}) or
            props.get("listing", {}) or
            props.get("details", {}) or
            {}
        )
        if listing:
            # 地址
            addr = listing.get("address", {})
            if isinstance(addr, dict):
                display = addr.get("display", {})
                if isinstance(display, dict):
                    result["address"] = display.get("fullAddress", "") or display.get("shortAddress", "")
                elif isinstance(display, str):
                    result["address"] = display
                result["suburb"] = addr.get("suburb", "")
            elif isinstance(addr, str):
                result["address"] = addr

            # 价格
            result["price"] = (
                listing.get("price", {}).get("display", "") if isinstance(listing.get("price"), dict)
                else str(listing.get("price", ""))
            )

            # 户型
            features = listing.get("features", {}) or listing.get("propertyFeatures", {})
            if isinstance(features, dict):
                general = features.get("general", {}) or features
                result["bedrooms"] = general.get("bedrooms", 0) or general.get("beds", 0)
                result["bathrooms"] = general.get("bathrooms", 0) or general.get("baths", 0)
                result["parking"] = general.get("parkingSpaces", 0) or general.get("carSpaces", 0)

            result["land_size"] = listing.get("landSize", 0) or listing.get("landAreaSqm", 0)
            result["property_type"] = listing.get("propertyType", "") or listing.get("type", "")
            result["description"] = (listing.get("description", "") or "")[:1000]

            # 图片
            images = listing.get("images", []) or listing.get("media", []) or listing.get("photos", [])
            for img in images[:5]:
                img_url = ""
                if isinstance(img, dict):
                    img_url = img.get("url", "") or img.get("uri", "") or img.get("server", "")
                elif isinstance(img, str):
                    img_url = img
                if img_url:
                    result["images"].append(img_url)

            if result["address"]:
                return result

    # 策略 2: HTML meta / OG tags + JSON-LD
    _parse_html_meta(html_text, result)
    _parse_ld_json(html_text, result)

    if not result["suburb"]:
        result["suburb"] = _extract_suburb_from_address(result["address"])

    return result


def _parse_html_meta(html_text: str, result: dict):
    """从 HTML meta/OG tags 提取基础信息（备用方案）"""
    # og:title → 通常包含地址
    og_title = re.search(r'<meta\s+property="og:title"\s+content="([^"]*)"', html_text, re.IGNORECASE)
    if og_title and not result["address"]:
        result["address"] = _html.unescape(og_title.group(1))

    # og:description → 通常包含价格 + 户型描述
    og_desc = re.search(r'<meta\s+property="og:description"\s+content="([^"]*)"', html_text, re.IGNORECASE)
    if og_desc:
        desc_text = _html.unescape(og_desc.group(1))
        if not result["description"]:
            result["description"] = desc_text[:1000]
        # 尝试提取价格
        if not result["price"]:
            price_match = re.search(r'\$[\d,]+(?:\.\d+)?', desc_text)
            if price_match:
                result["price"] = price_match.group(0)

    # og:image
    og_img = re.search(r'<meta\s+property="og:image"\s+content="([^"]*)"', html_text, re.IGNORECASE)
    if og_img and not result["images"]:
        result["images"].append(_html.unescape(og_img.group(1)))

    # title tag
    title_tag = re.search(r'<title[^>]*>(.*?)</title>', html_text, re.DOTALL | re.IGNORECASE)
    if title_tag and not result["address"]:
        title_text = re.sub(r'<[^>]+>', '', title_tag.group(1)).strip()
        title_text = _html.unescape(title_text)
        # 清理网站名称后缀
        for suffix in [" - Domain", " - realestate.com.au", "| Domain", "| realestate.com.au"]:
            title_text = title_text.replace(suffix, "").strip()
        result["address"] = title_text


def _parse_ld_json(html_text: str, result: dict):
    """从 JSON-LD 结构化数据提取信息"""
    ld_matches = re.findall(
        r'<script\s+type="application/ld\+json"[^>]*>(.*?)</script>',
        html_text, re.DOTALL
    )
    for ld_text in ld_matches:
        try:
            ld = json.loads(ld_text)
            if isinstance(ld, list):
                ld = ld[0] if ld else {}

            ld_type = ld.get("@type", "")
            if ld_type in ("RealEstateListing", "Product", "Residence", "SingleFamilyResidence", "Apartment"):
                if not result["address"]:
                    addr = ld.get("address", {})
                    if isinstance(addr, dict):
                        result["address"] = addr.get("streetAddress", "")
                        if not result["suburb"]:
                            result["suburb"] = addr.get("addressLocality", "")

                if not result["price"]:
                    offers = ld.get("offers", {})
                    if isinstance(offers, dict):
                        price_val = offers.get("price", "")
                        if price_val:
                            result["price"] = f"${int(float(price_val)):,}" if str(price_val).replace('.', '').isdigit() else str(price_val)

                if not result["description"]:
                    result["description"] = (ld.get("description", "") or "")[:1000]

                # 图片
                if not result["images"]:
                    imgs = ld.get("image", [])
                    if isinstance(imgs, str):
                        imgs = [imgs]
                    for img in imgs[:5]:
                        if isinstance(img, str):
                            result["images"].append(img)
                        elif isinstance(img, dict):
                            result["images"].append(img.get("url", ""))
        except (json.JSONDecodeError, Exception):
            continue
