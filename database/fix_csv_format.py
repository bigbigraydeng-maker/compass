#!/usr/bin/env python3
"""修复 CSV 文件格式，确保标准格式"""

import csv
import os

def fix_csv_format():
    input_path = '../scraper/data/raw_listings.csv'
    output_path = '../scraper/data/raw_listings_fixed.csv'
    
    with open(input_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rows = list(reader)
    
    print(f"读取到 {len(rows)} 条记录")
    
    # 标准字段顺序
    fieldnames = [
        'address', 'suburb', 'property_type', 'bedrooms', 'bathrooms',
        'car_spaces', 'land_size', 'price_text', 'price', 'auction_date',
        'sale_method', 'latitude', 'longitude', 'agent_name', 'agent_company',
        'link', 'scraped_date'
    ]
    
    with open(output_path, 'w', encoding='utf-8', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        
        for i, row in enumerate(rows):
            # 确保所有字段都存在
            clean_row = {}
            for field in fieldnames:
                clean_row[field] = row.get(field, '')
            
            # 处理空值
            if not clean_row['auction_date']:
                clean_row['auction_date'] = ''
            
            writer.writerow(clean_row)
            
            if (i + 1) % 50 == 0:
                print(f"已处理 {i + 1}/{len(rows)} 条记录")
    
    print(f"\n修复完成！生成文件：{output_path}")
    print(f"总记录数：{len(rows)}")

if __name__ == "__main__":
    fix_csv_format()
