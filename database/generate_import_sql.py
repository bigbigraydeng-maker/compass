#!/usr/bin/env python3
"""
生成可以直接导入 Supabase 的 SQL 脚本
"""

import csv
from datetime import datetime


def generate_sql():
    print("="*60)
    print("生成 SQL 导入脚本")
    print("="*60)
    
    csv_file = 'data/raw_sales_new.csv'
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        data = list(reader)
    
    print(f"\n📄 读取了 {len(data)} 条记录")
    
    # 生成 SQL
    sql_lines = []
    sql_lines.append("-- 清空现有数据")
    sql_lines.append("TRUNCATE TABLE sales CASCADE;")
    sql_lines.append("TRUNCATE TABLE properties CASCADE;")
    sql_lines.append("")
    
    # 插入 properties
    sql_lines.append("-- 插入 properties")
    for i, row in enumerate(data, 1):
        address = row['address'].replace("'", "''")
        suburb = row['suburb'].replace("'", "''")
        property_type = row['property_type'] if row['property_type'] else 'house'
        land_size = int(row['land_size']) if row['land_size'] else 0
        building_size = int(row['building_size']) if row['building_size'] else 0
        bedrooms = int(row['bedrooms']) if row['bedrooms'] else 0
        bathrooms = int(row['bathrooms']) if row['bathrooms'] else 0
        car_spaces = int(row['car_spaces']) if row['car_spaces'] else 0
        
        sql_lines.append(
            f"INSERT INTO properties (address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces) "
            f"VALUES ('{address}', '{suburb}', '{property_type}', {land_size}, {building_size}, {bedrooms}, {bathrooms}, {car_spaces});"
        )
    
    sql_lines.append("")
    sql_lines.append("-- 插入 sales")
    
    # 插入 sales（使用子查询获取 property_id）
    for row in data:
        address = row['address'].replace("'", "''")
        sold_price = int(row['sold_price']) if row['sold_price'] else 0
        sold_date = row['sold_date']
        
        sql_lines.append(
            f"INSERT INTO sales (property_id, sold_price, sold_date) "
            f"VALUES ((SELECT id FROM properties WHERE address = '{address}'), {sold_price}, '{sold_date}');"
        )
    
    sql_lines.append("")
    sql_lines.append("-- 验证数据")
    sql_lines.append("SELECT COUNT(*) as total_properties FROM properties;")
    sql_lines.append("SELECT COUNT(*) as total_sales FROM sales;")
    sql_lines.append("SELECT COUNT(*) as properties_with_beds FROM properties WHERE bedrooms > 0;")
    sql_lines.append("SELECT suburb, COUNT(*) as count FROM properties GROUP BY suburb ORDER BY count DESC;")
    
    # 保存到文件
    output_file = 'database/import_complete.sql'
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sql_lines))
    
    print(f"✅ 已生成 SQL 脚本: {output_file}")
    print(f"   - {len(data)} 条 properties 记录")
    print(f"   - {len(data)} 条 sales 记录")
    print("\n📋 下一步:")
    print("1. 打开 Supabase Dashboard")
    print("2. 点击 SQL Editor")
    print("3. 复制 database/import_complete.sql 的内容")
    print("4. 粘贴并运行")
    print("="*60)


if __name__ == "__main__":
    generate_sql()
