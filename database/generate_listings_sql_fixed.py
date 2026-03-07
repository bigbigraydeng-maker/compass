#!/usr/bin/env python3
"""生成修复版 listings 表 SQL 导入语句"""

import csv
import os

def escape_sql(value):
    """转义 SQL 字符串"""
    if value is None:
        return 'NULL'
    if isinstance(value, str):
        # 替换单引号为两个单引号
        value = value.replace("'", "''")
        return f"'{value}'"
    return str(value)

def generate_sql():
    csv_path = '../scraper/data/raw_listings.csv'
    sql_path = 'import_listings_fixed.sql'
    
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rows = list(reader)
    
    print(f"读取到 {len(rows)} 条记录")
    
    with open(sql_path, 'w', encoding='utf-8') as f:
        f.write("-- 清空旧数据\n")
        f.write("DELETE FROM listings;\n")
        f.write("ALTER SEQUENCE listings_id_seq RESTART WITH 1;\n\n")
        f.write("-- 导入在售房源数据\n")
        
        for i, row in enumerate(rows):
            # 处理空值
            address = row.get('address', '')
            suburb = row.get('suburb', '')
            property_type = row.get('property_type', '')
            bedrooms = row.get('bedrooms', '0') or '0'
            bathrooms = row.get('bathrooms', '0') or '0'
            car_spaces = row.get('car_spaces', '0') or '0'
            land_size = row.get('land_size', '0') or '0'
            price_text = row.get('price_text', '')
            price = row.get('price', '0') or '0'
            # 移除 auction_date 字段，因为表中不存在
            sale_method = row.get('sale_method', 'private treaty')
            latitude = row.get('latitude', '0') or '0'
            longitude = row.get('longitude', '0') or '0'
            agent_name = row.get('agent_name', '')
            agent_company = row.get('agent_company', '')
            link = row.get('link', '')
            scraped_date = row.get('scraped_date', '2026-03-06')
            
            # 处理空字符串为 NULL
            agent_name_sql = escape_sql(agent_name) if agent_name else 'NULL'
            agent_company_sql = escape_sql(agent_company) if agent_company else 'NULL'
            
            sql = f"""INSERT INTO listings (address, suburb, property_type, bedrooms, bathrooms, car_spaces, land_size, price_text, price, sale_method, latitude, longitude, agent_name, agent_company, link, scraped_date, created_at) VALUES ({escape_sql(address)}, {escape_sql(suburb)}, {escape_sql(property_type)}, {bedrooms}, {bathrooms}, {car_spaces}, {land_size}, {escape_sql(price_text)}, {price}, {escape_sql(sale_method)}, {latitude}, {longitude}, {agent_name_sql}, {agent_company_sql}, {escape_sql(link)}, {escape_sql(scraped_date)}, NOW());\n"""
            
            f.write(sql)
            
            if (i + 1) % 50 == 0:
                print(f"已处理 {i + 1}/{len(rows)} 条记录")
        
        f.write(f"\n-- 共导入 {len(rows)} 条记录\n")
    
    print(f"SQL 文件已生成: {sql_path}")
    print(f"总记录数: {len(rows)}")

if __name__ == "__main__":
    generate_sql()
