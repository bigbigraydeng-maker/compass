#!/usr/bin/env python3
"""
测试土地页面的 propertyType 字段
"""

import requests
import json
import re

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

url = "https://www.domain.com.au/land-for-sale/sunnybank-qld-4109/"
r = requests.get(url, headers=HEADERS)

print(f"Status code: {r.status_code}")

# 解析 __NEXT_DATA__
match = re.search(r'<script id="__NEXT_DATA__"[^>]*>(.*?)</script>', r.text, re.DOTALL)
if match:
    print("\n找到 __NEXT_DATA__")
    try:
        data = json.loads(match.group(1))
        
        # 获取 listings
        component_props = data.get("props", {}).get("pageProps", {}).get("componentProps", {})
        listings_map = component_props.get("listingsMap", {})
        listing_ids = component_props.get("listingSearchResultIds", [])
        
        print(f"\nFound {len(listing_ids)} listings")
        
        # 查看前5条的 propertyType
        for i, listing_id in enumerate(listing_ids[:5]):
            item = listings_map.get(str(listing_id), {})
            model = item.get("listingModel", {})
            features = model.get("features", {})
            property_type = features.get("propertyType", "")
            print(f"\nListing {i+1}:")
            print(f"  propertyType: '{property_type}'")
            print(f"  address: {model.get('address', {}).get('street', '')} {model.get('address', {}).get('suburb', '')}")
            print(f"  price: {model.get('price', '')}")
            print(f"  features: {list(features.keys())[:10]}...")
            
    except json.JSONDecodeError as e:
        print(f"JSON 解析失败: {e}")
else:
    print("未找到 __NEXT_DATA__")
