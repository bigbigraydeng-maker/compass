#!/usr/bin/env python3
"""
抓取 Domain.com.au 在售土地数据
"""

import requests
import json
import csv
from datetime import date
import re
import os

def parse_price(price_text):
    """
    解析价格文本为整数
    支持格式：$3.99m, $1,500,000, $750000 等
    """
    if not price_text:
        return None
    # 处理 $1.5m / $1,500,000 等格式
    text = price_text.lower().replace(',', '').replace('$', '')
    m = re.search(r'(\d+\.?\d*)\s*m', text)
    if m:
        try:
            return int(float(m.group(1)) * 1_000_000)
        except:
            pass
    m = re.search(r'(\d+)', text)
    if m:
        val = int(m.group(1))
        return val if val > 10000 else None
    return None

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

SUBURBS = {
    "Sunnybank": "sunnybank-qld-4109",
    "Eight Mile Plains": "eight-mile-plains-qld-4113",
    "Calamvale": "calamvale-qld-4116",
    "Rochedale": "rochedale-qld-4123",
    "Mansfield": "mansfield-qld-4122",
    "Ascot": "ascot-qld-4007",
    "Hamilton": "hamilton-qld-4007"
}

all_land = []

for suburb_name, slug in SUBURBS.items():
    print(f"\n开始抓取 {suburb_name}...")
    suburb_count = 0
    
    for page in range(1, 4):  # 3页
        url = f"https://www.domain.com.au/sale/{slug}/?property-types=land&page={page}"
        print(f"  抓取第 {page} 页: {url}")
        
        r = requests.get(url, headers=HEADERS)
        if r.status_code != 200:
            print(f"  ❌ 页面请求失败: {r.status_code}")
            break
        
        # 解析 __NEXT_DATA__
        match = re.search(r'<script id="__NEXT_DATA__"[^>]*>(.*?)</script>', r.text, re.DOTALL)
        if not match:
            print(f"  ❌ 未找到 __NEXT_DATA__")
            break
            
        try:
            data = json.loads(match.group(1))
            
            # 找 listings（正确的路径：listingsMap）
            component_props = data.get("props", {}).get("pageProps", {}).get("componentProps", {})
            listings_map = component_props.get("listingsMap", {})
            listing_ids = component_props.get("listingSearchResultIds", [])
            
            print(f"  debug: listing_ids length = {len(listing_ids)}")
            print(f"  debug: listings_map keys = {list(listings_map.keys())[:5]}...")
            
            if not listing_ids:
                print(f"  ✅ 没有更多数据")
                break
                
            print(f"  ✅ 找到 {len(listing_ids)} 条记录")
            suburb_count += len(listing_ids)
            
            for listing_id in listing_ids:
                item = listings_map.get(str(listing_id), {})
                if not item:
                    print(f"  debug: listing_id {listing_id} not found in listings_map")
                    continue
                
                model = item.get("listingModel", {})
                if not model:
                    print(f"  debug: no listingModel for {listing_id}")
                    continue
                
                address = model.get("address", {})
                features = model.get("features", {})
                
                # 获取真实的 property type
                features = model.get("features", {})
                property_type = features.get("propertyType", "")
                
                # 打印 propertyType 用于调试
                if len(all_land) < 5:
                    print(f"  debug: propertyType = '{property_type}'")
                
                # 只保留土地类型
                if property_type.lower() not in ["vacantland", "land", "vacant land"]:
                    continue  # 跳过非土地
                
                # 提取价格数值
                price_text = model.get("price", "")
                price = parse_price(price_text)
                
                land = {
                    "address": f"{address.get('street', '')} {address.get('suburb', '')}".strip(),
                    "suburb": suburb_name,
                    "property_type": "vacant_land",
                    "land_size": features.get("landSize"),
                    "price_text": price_text,
                    "price": price,
                    "agent_name": model.get("branding", {}).get("agents", [{}])[0].get("agentName", "") if model.get("branding", {}).get("agents") else "",
                    "agent_company": model.get("branding", {}).get("brandName", ""),
                    "link": "https://www.domain.com.au" + model.get("url", ""),
                    "scraped_date": date.today().isoformat()
                }
                
                # 打印第一条记录
                if len(all_land) == 0:
                    print(f"  debug: first land record: {land}")
                
                all_land.append(land)
                
        except json.JSONDecodeError as e:
            print(f"  ❌ JSON 解析失败: {e}")
            break
    
    print(f"{suburb_name}: 总计 {suburb_count} 条")

print(f"\n=== 抓取结果 ===")
print(f"总计: {len(all_land)} 条土地数据")

# 保存 CSV
os.makedirs('data', exist_ok=True)
csv_file = 'data/land_listings.csv'

if all_land:
    with open(csv_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=all_land[0].keys())
        writer.writeheader()
        writer.writerows(all_land)
    print(f"\n数据已保存到: {csv_file}")
    
    # 打印第一条记录示例
    print(f"\n第一条记录示例:")
    for key, value in all_land[0].items():
        print(f"{key}: {value}")
else:
    print("\n❌ 没有抓取到任何数据")
