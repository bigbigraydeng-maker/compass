import requests
import time
from typing import Optional, Tuple, Dict
from .config import GOOGLE_MAPS_API_KEY, GEOCODING_RETRY_COUNT, GEOCODING_RETRY_DELAY
from .database import db

class Geocoder:
    """地理编码类，负责将地址转换为经纬度"""
    
    # 地理编码服务提供商
    PROVIDERS = {
        'google': 'https://maps.googleapis.com/maps/api/geocode/json',
        'mock': None,
        'disabled': None
    }
    
    @classmethod
    def geocode_address(cls, address: str, provider: str = 'google') -> Tuple[Optional[Tuple[float, float]], str]:
        """使用指定服务提供商进行地理编码
        
        Args:
            address: 标准化后的地址字符串
            provider: 地理编码服务提供商
            
        Returns:
            ((latitude, longitude), status) 元组，status 可能是 'success', 'failed', 'partial', 'cached'
        """
        if not address:
            return None, 'failed'
        
        # 检查缓存
        cached_result = cls._get_from_cache(address)
        if cached_result:
            return cached_result, 'cached'
        
        # 如果禁用地理编码
        if provider == 'disabled':
            return None, 'failed'
        
        # 如果使用模拟模式
        if provider == 'mock':
            # 返回模拟数据
            mock_lat = 27.4698  # Brisbane 大致纬度
            mock_lng = 153.0251  # Brisbane 大致经度
            cls._save_to_cache(address, mock_lat, mock_lng, 'success')
            return (mock_lat, mock_lng), 'success'
        
        # 使用 Google Maps API
        if provider == 'google':
            if not GOOGLE_MAPS_API_KEY:
                return None, 'failed'
            
            url = cls.PROVIDERS['google']
            params = {
                "address": address,
                "key": GOOGLE_MAPS_API_KEY
            }
            
            for attempt in range(GEOCODING_RETRY_COUNT):
                try:
                    response = requests.get(url, params=params, timeout=10)
                    response.raise_for_status()
                    
                    data = response.json()
                    if data.get("status") == "OK" and data.get("results"):
                        location = data["results"][0]["geometry"]["location"]
                        lat, lng = location["lat"], location["lng"]
                        cls._save_to_cache(address, lat, lng, 'success')
                        return (lat, lng), 'success'
                    elif data.get("status") in ["OVER_QUERY_LIMIT", "REQUEST_DENIED"]:
                        print(f"地理编码 API 错误: {data.get('status')}")
                        cls._save_to_cache(address, None, None, 'failed')
                        return None, 'failed'
                    else:
                        print(f"地理编码失败: {data.get('status')}")
                        cls._save_to_cache(address, None, None, 'failed')
                        return None, 'failed'
                except Exception as e:
                    print(f"地理编码失败 (尝试 {attempt + 1}/{GEOCODING_RETRY_COUNT}): {e}")
                    if attempt < GEOCODING_RETRY_COUNT - 1:
                        time.sleep(GEOCODING_RETRY_DELAY)
                    else:
                        cls._save_to_cache(address, None, None, 'failed')
                        return None, 'failed'
        
        return None, 'failed'
    
    @classmethod
    def _get_from_cache(cls, address: str) -> Optional[Tuple[float, float]]:
        """从缓存中获取地理编码结果
        
        Args:
            address: 标准化后的地址字符串
            
        Returns:
            (latitude, longitude) 元组，如果缓存中没有则返回 None
        """
        try:
            query = "SELECT latitude, longitude FROM geocoding_cache WHERE address = %s"
            result = db.fetch_one(query, (address,))
            if result:
                return (result[0], result[1])
        except Exception as e:
            print(f"从缓存获取地理编码失败: {e}")
        return None
    
    @classmethod
    def _save_to_cache(cls, address: str, latitude: Optional[float], longitude: Optional[float], status: str):
        """保存地理编码结果到缓存
        
        Args:
            address: 标准化后的地址字符串
            latitude: 纬度
            longitude: 经度
            status: 状态
        """
        try:
            # 如果已经存在则更新
            query = """
                INSERT INTO geocoding_cache (address, latitude, longitude, status)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT (address) DO UPDATE
                SET latitude = %s, longitude = %s, status = %s, created_at = NOW()
            """
            db.execute(query, (address, latitude, longitude, status, latitude, longitude, status))
            db.commit()
        except Exception as e:
            print(f"保存地理编码到缓存失败: {e}")
            db.commit()