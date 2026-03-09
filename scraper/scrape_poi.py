#!/usr/bin/env python3
"""
抓取布里斯班华人相关POI数据
使用Google Maps Places API
"""

import requests
import os
import psycopg2
from dotenv import load_dotenv

# 加载环境变量 (从 backend/.env)
env_path = os.path.join(os.path.dirname(__file__), '..', 'backend', '.env')
load_dotenv(env_path)

# Google Maps API Key (需要用户提供)
API_KEY = os.getenv('GOOGLE_MAPS_API_KEY', 'YOUR_API_KEY_HERE')

# 数据库连接信息
DATABASE_URL = os.getenv('DATABASE_URL')

# 从集中配置加载坐标
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from suburbs_config import get_suburb_coords
SUBURBS = get_suburb_coords()

# POI类别和关键词
POI_CATEGORIES = [
    {
        'category': 'chinese_restaurant',
        'types': ['restaurant'],
        'keywords': ['chinese', '中餐', '火锅', '粤菜']
    },
    {
        'category': 'asian_grocery',
        'types': ['supermarket'],
        'keywords': ['asian grocery', '万家', '东方']
    },
    {
        'category': 'chinese_school',
        'types': ['school'],
        'keywords': ['chinese school', '中文学校']
    },
    {
        'category': 'chinese_church',
        'types': ['church'],
        'keywords': ['chinese church', '华人教会']
    },
    {
        'category': 'chinese_clinic',
        'types': ['doctor'],
        'keywords': ['chinese doctor', '中医']
    },
    {
        'category': 'chinese_hair_salon',
        'types': ['hair_care'],
        'keywords': ['chinese hair salon', '中式理发']
    }
]

def get_place_details(place_id):
    """获取地点详细信息"""
    url = f"https://maps.googleapis.com/maps/api/place/details/json"
    params = {
        'place_id': place_id,
        'key': API_KEY
    }
    response = requests.get(url, params=params)
    return response.json()

def search_places(suburb, lat, lng, category, types, keywords):
    """搜索POI"""
    places = []
    
    for keyword in keywords:
        url = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        params = {
            'location': f"{lat},{lng}",
            'radius': 5000,  # 5公里半径
            'type': types[0],
            'keyword': keyword,
            'key': API_KEY
        }
        
        response = requests.get(url, params=params)
        data = response.json()
        
        if 'results' in data:
            for result in data['results']:
                # 获取详细信息
                details = get_place_details(result['place_id'])
                if 'result' in details:
                    place = {
                        'suburb': suburb,
                        'category': category,
                        'name': result.get('name', ''),
                        'address': details['result'].get('formatted_address', ''),
                        'rating': result.get('rating', 0),
                        'lat': result['geometry']['location']['lat'],
                        'lng': result['geometry']['location']['lng']
                    }
                    places.append(place)
        
        # 处理分页
        while 'next_page_token' in data:
            params['pagetoken'] = data['next_page_token']
            response = requests.get(url, params=params)
            data = response.json()
            if 'results' in data:
                for result in data['results']:
                    details = get_place_details(result['place_id'])
                    if 'result' in details:
                        place = {
                            'suburb': suburb,
                            'category': category,
                            'name': result.get('name', ''),
                            'address': details['result'].get('formatted_address', ''),
                            'rating': result.get('rating', 0),
                            'lat': result['geometry']['location']['lat'],
                            'lng': result['geometry']['location']['lng']
                        }
                        places.append(place)
    
    # 去重
    unique_places = []
    seen = set()
    for place in places:
        key = (place['name'], place['lat'], place['lng'])
        if key not in seen:
            seen.add(key)
            unique_places.append(place)
    
    return unique_places

def save_to_database(places):
    """保存POI数据到数据库"""
    if not DATABASE_URL:
        print("数据库连接信息未配置")
        return
    
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cur = conn.cursor()
        
        # 清空现有数据
        cur.execute("DELETE FROM poi_data")
        
        # 插入新数据
        for place in places:
            cur.execute(
                """
                INSERT INTO poi_data (suburb, category, name, address, rating, lat, lng)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                """,
                (place['suburb'], place['category'], place['name'], 
                 place['address'], place['rating'], place['lat'], place['lng'])
            )
        
        conn.commit()
        print(f"成功保存 {len(places)} 条POI数据")
        
    except Exception as e:
        print(f"数据库操作失败: {e}")
    finally:
        if 'conn' in locals():
            conn.close()

def main():
    """主函数"""
    if API_KEY == 'YOUR_API_KEY_HERE':
        print("请在.env文件中配置GOOGLE_MAPS_API_KEY")
        return
    
    all_places = []
    
    for suburb, coords in SUBURBS.items():
        print(f"正在抓取 {suburb} 的POI数据...")
        
        for category_info in POI_CATEGORIES:
            category = category_info['category']
            types = category_info['types']
            keywords = category_info['keywords']
            
            print(f"  - 抓取 {category} 数据...")
            places = search_places(suburb, coords['lat'], coords['lng'], category, types, keywords)
            all_places.extend(places)
            print(f"    找到 {len(places)} 个地点")
    
    print(f"\n总共找到 {len(all_places)} 个POI")
    save_to_database(all_places)

if __name__ == "__main__":
    main()
