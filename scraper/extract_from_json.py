#!/usr/bin/env python3
"""
从已保存的 __NEXT_DATA__ JSON 文件中提取房产数据
"""

import json
import csv
import os
import re
from datetime import datetime
from glob import glob


def extract_listings_from_json(json_file: str) -> list:
    """从 JSON 文件中提取房源数据"""
    print(f"\n📄 处理文件: {json_file}")
    
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    listings = []
    
    try:
        # 导航到 listingsMap
        page_props = data.get('props', {}).get('pageProps', {})
        component_props = page_props.get('componentProps', {})
        listings_map = component_props.get('listingsMap', {})
        
        if not listings_map:
            print(f"  ⚠️  未找到 listingsMap")
            return listings
        
        print(f"  ✅ 找到 {len(listings_map)} 个房源")
        
        for listing_id, listing in listings_map.items():
            try:
                listing_model = listing.get('listingModel', {})
                if not listing_model:
                    continue
                
                # 提取地址
                address = ""
                addr_obj = listing_model.get('address', {})
                if isinstance(addr_obj, dict):
                    street = addr_obj.get('street', '')
                    suburb_name = addr_obj.get('suburb', '')
                    if street and suburb_name:
                        address = f"{street}, {suburb_name}"
                    elif street:
                        address = street
                
                if not address:
                    continue
                
                # 从文件名提取 suburb
                filename = os.path.basename(json_file)
                if 'Sunnybank' in filename:
                    suburb = 'Sunnybank'
                elif 'Eight_Mile_Plains' in filename or 'Eight Mile Plains' in filename:
                    suburb = 'Eight Mile Plains'
                elif 'Calamvale' in filename:
                    suburb = 'Calamvale'
                else:
                    suburb = suburb_name if suburb_name else 'Unknown'
                
                # 提取价格
                sold_price = 0
                price_text = listing_model.get('price', '')
                if price_text:
                    price_text = price_text.replace('$', '').replace(',', '').strip()
                    match = re.search(r'\d+', price_text)
                    if match:
                        sold_price = int(match.group())
                
                # 提取成交日期
                sold_date = ""
                tags = listing_model.get('tags', {})
                tag_text = tags.get('tagText', '')
                if tag_text:
                    date_match = re.search(r'(\d{1,2}\s+\w+\s+\d{4})', tag_text)
                    if date_match:
                        date_str = date_match.group(1)
                        try:
                            date_obj = datetime.strptime(date_str, "%d %b %Y")
                            sold_date = date_obj.strftime("%Y-%m-%d")
                        except:
                            pass
                
                # 提取房型
                property_type = ""
                features = listing_model.get('features', {})
                prop_type = features.get('propertyType', '').lower()
                if 'house' in prop_type:
                    property_type = 'house'
                elif 'unit' in prop_type or 'apartment' in prop_type:
                    property_type = 'unit'
                elif 'townhouse' in prop_type:
                    property_type = 'townhouse'
                elif 'vacant' in prop_type:
                    property_type = 'vacant_land'
                else:
                    property_type = 'other'
                
                # 提取卧室数
                bedrooms = features.get('beds', 0)
                
                # 提取卫浴数
                bathrooms = features.get('baths', 0)
                
                # 提取车位数
                car_spaces = features.get('parking', 0)
                
                # 提取土地面积
                land_size = features.get('landSize', 0)
                
                # 只添加有价格和日期的记录
                if sold_price > 0 and sold_date and address:
                    record = {
                        "address": address,
                        "suburb": suburb,
                        "property_type": property_type,
                        "bedrooms": bedrooms,
                        "bathrooms": bathrooms,
                        "car_spaces": car_spaces,
                        "land_size": land_size,
                        "building_size": 0,  # Domain 数据中没有这个字段
                        "sold_price": sold_price,
                        "sold_date": sold_date
                    }
                    listings.append(record)
                    print(f"  ✅ {address} - {bedrooms}床{bathrooms}浴{car_spaces}车 - ${sold_price:,} - {sold_date}")
                
            except Exception as e:
                print(f"  ❌ 解析房源出错: {e}")
                continue
        
    except Exception as e:
        print(f"  ❌ 处理文件出错: {e}")
    
    return listings


def main():
    print("="*60)
    print("从 JSON 文件提取房产数据")
    print("="*60)
    
    # 查找所有 JSON 文件
    json_files = glob("data/next_data_*.json")
    
    if not json_files:
        print("\n❌ 未找到 JSON 文件")
        return
    
    print(f"\n找到 {len(json_files)} 个 JSON 文件:")
    for f in json_files:
        print(f"  - {f}")
    
    # 提取所有数据
    all_listings = []
    for json_file in json_files:
        listings = extract_listings_from_json(json_file)
        all_listings.extend(listings)
    
    # 去重（基于地址）
    unique_listings = {}
    for listing in all_listings:
        key = listing['address']
        if key not in unique_listings:
            unique_listings[key] = listing
    
    final_listings = list(unique_listings.values())
    
    print(f"\n{'='*60}")
    print(f"📊 数据统计:")
    print(f"  - 总记录数: {len(all_listings)}")
    print(f"  - 去重后: {len(final_listings)}")
    
    # 按郊区统计
    suburb_stats = {}
    for listing in final_listings:
        suburb = listing['suburb']
        if suburb not in suburb_stats:
            suburb_stats[suburb] = 0
        suburb_stats[suburb] += 1
    
    print(f"\n按郊区统计:")
    for suburb, count in sorted(suburb_stats.items()):
        print(f"  - {suburb}: {count} 条")
    
    # 保存到 CSV
    output_file = "data/raw_sales_new.csv"
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        fieldnames = ['address', 'suburb', 'property_type', 'bedrooms', 'bathrooms', 
                      'car_spaces', 'land_size', 'building_size', 'sold_price', 'sold_date']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(final_listings)
    
    print(f"\n✅ 已保存到 {output_file}")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
