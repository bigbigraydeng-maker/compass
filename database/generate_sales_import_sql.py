#!/usr/bin/env python3
"""
生成销售数据导入SQL脚本
用于在Supabase控制台中直接执行
"""

import csv
import json
import hashlib
from datetime import datetime
import uuid

INPUT_FILE = 'data/raw_sales_new.csv'
OUTPUT_FILE = 'database/import_sales_data.sql'

def generate_property_id(address, suburb):
    """生成property_id (SHA-256 Hash)"""
    key = f"{address.lower().strip()}_{suburb.lower().strip()}"
    return hashlib.sha256(key.encode()).hexdigest()

def generate_sale_id(address, sale_date, sale_price):
    """生成sale_id"""
    key = f"{address}_{sale_date}_{sale_price}"
    return str(uuid.uuid5(uuid.NAMESPACE_DNS, key))

def generate_address_key(address, suburb):
    """生成address_key"""
    return f"{address.lower().strip()}_{suburb.lower().strip()}"

def main():
    print(f"处理文件: {INPUT_FILE}")
    
    with open(INPUT_FILE, 'r', encoding='utf-8') as f, \
         open(OUTPUT_FILE, 'w', encoding='utf-8') as out:
        
        # 写入表头
        out.write('-- 销售数据导入SQL脚本\n')
        out.write('-- 此脚本包含2,417条REA销售记录\n\n')
        
        # 确保表结构存在
        out.write('-- 确保表结构存在\n')
        out.write('CREATE TABLE IF NOT EXISTS sales (\n')
        out.write('    sale_id UUID PRIMARY KEY,\n')
        out.write('    property_id TEXT NOT NULL,\n')
        out.write('    full_address TEXT NOT NULL,\n')
        out.write('    unit_number TEXT,\n')
        out.write('    street_number TEXT,\n')
        out.write('    street_name TEXT,\n')
        out.write('    street_type TEXT,\n')
        out.write('    suburb TEXT NOT NULL,\n')
        out.write('    state TEXT DEFAULT \'QLD\',\n')
        out.write('    postcode TEXT,\n')
        out.write('    sale_price NUMERIC NOT NULL,\n')
        out.write('    sale_date DATE NOT NULL,\n')
        out.write('    property_type TEXT,\n')
        out.write('    bedrooms INTEGER,\n')
        out.write('    bathrooms INTEGER,\n')
        out.write('    car_spaces INTEGER,\n')
        out.write('    land_size NUMERIC,\n')
        out.write('    building_size NUMERIC,\n')
        out.write('    latitude NUMERIC,\n')
        out.write('    longitude NUMERIC,\n')
        out.write('    address_key TEXT NOT NULL,\n')
        out.write('    source TEXT NOT NULL,\n')
        out.write('    created_at TIMESTAMP DEFAULT NOW(),\n')
        out.write('    updated_at TIMESTAMP DEFAULT NOW(),\n')
        out.write('    UNIQUE(address_key, sale_date, sale_price)\n')
        out.write(');\n\n')
        
        out.write('CREATE TABLE IF NOT EXISTS quarantine (\n')
        out.write('    id SERIAL PRIMARY KEY,\n')
        out.write('    raw_data JSONB NOT NULL,\n')
        out.write('    error_message TEXT NOT NULL,\n')
        out.write('    source TEXT,\n')
        out.write('    created_at TIMESTAMP DEFAULT NOW()\n')
        out.write(');\n\n')
        
        reader = csv.DictReader(f)
        total_records = 0
        valid_records = 0
        invalid_records = 0
        
        # 开始批量插入
        out.write('-- 批量插入销售数据\n')
        out.write('INSERT INTO sales (\n')
        out.write('    sale_id, property_id, full_address, unit_number, street_number, street_name, street_type,\n')
        out.write('    suburb, state, postcode, sale_price, sale_date, property_type,\n')
        out.write('    bedrooms, bathrooms, car_spaces, land_size, building_size, latitude, longitude,\n')
        out.write('    address_key, source\n')
        out.write(') VALUES\n')
        
        records = []
        for row in reader:
            total_records += 1
            
            # 提取数据
            address = row.get('address', '').strip()
            suburb = row.get('suburb', '').strip()
            sale_price = row.get('sold_price', row.get('sale_price', '').strip()).strip()
            sale_date = row.get('sold_date', row.get('sale_date', '').strip()).strip()
            
            # 验证必要字段
            if not address or not suburb or not sale_price or not sale_date:
                invalid_records += 1
                continue
            
            # 处理其他字段
            postcode = row.get('postcode', '').strip()
            property_type = row.get('property_type', '').strip()
            bedrooms = row.get('bedrooms', '').strip()
            bathrooms = row.get('bathrooms', '').strip()
            car_spaces = row.get('car_spaces', '').strip()
            land_size = row.get('land_size', '').strip()
            building_size = row.get('building_size', '').strip()
            
            # 生成ID和键
            property_id = generate_property_id(address, suburb)
            sale_id = generate_sale_id(address, sale_date, sale_price)
            address_key = generate_address_key(address, suburb)
            
            # 解析日期
            try:
                sale_date_obj = datetime.strptime(sale_date, '%Y-%m-%d').date()
                sale_date_str = sale_date_obj.isoformat()
            except:
                invalid_records += 1
                continue
            
            # 处理数值字段
            try:
                sale_price = float(sale_price)
            except:
                invalid_records += 1
                continue
            
            bedrooms = int(bedrooms) if bedrooms else 'NULL'
            bathrooms = int(bathrooms) if bathrooms else 'NULL'
            car_spaces = int(car_spaces) if car_spaces else 'NULL'
            land_size = float(land_size) if land_size else 'NULL'
            building_size = float(building_size) if building_size else 'NULL'
            
            # 模拟地理编码数据
            latitude = 'NULL'  # 实际应用中应该使用真实的地理编码
            longitude = 'NULL'
            
            # 构建记录
            record = f"(\n"
            record += f"    '{sale_id}',\n"
            record += f"    '{property_id}',\n"
            record += f"    '{address.replace("'", "''")}',\n"
            record += f"    NULL,\n"  # unit_number
            record += f"    NULL,\n"  # street_number
            record += f"    NULL,\n"  # street_name
            record += f"    NULL,\n"  # street_type
            record += f"    '{suburb.replace("'", "''")}',\n"
            record += f"    'QLD',\n"
            record += f"    '{postcode}' if '{postcode}' != '' else NULL,\n"
            record += f"    {sale_price},\n"
            record += f"    '{sale_date_str}',\n"
            record += f"    '{property_type.replace("'", "''")}' if '{property_type}' != '' else NULL,\n"
            record += f"    {bedrooms},\n"
            record += f"    {bathrooms},\n"
            record += f"    {car_spaces},\n"
            record += f"    {land_size},\n"
            record += f"    {building_size},\n"
            record += f"    {latitude},\n"
            record += f"    {longitude},\n"
            record += f"    '{address_key}',\n"
            record += f"    'REA'\n"
            record += f")"
            
            records.append(record)
            valid_records += 1
            
            # 每100条记录写入一次
            if len(records) >= 100:
                out.write(',\n'.join(records) + ',\n')
                records = []
        
        # 处理剩余记录
        if records:
            out.write(',\n'.join(records))
        
        out.write('\nON CONFLICT (address_key, sale_date, sale_price) DO UPDATE SET\n')
        out.write('    property_id = EXCLUDED.property_id,\n')
        out.write('    full_address = EXCLUDED.full_address,\n')
        out.write('    suburb = EXCLUDED.suburb,\n')
        out.write('    state = EXCLUDED.state,\n')
        out.write('    postcode = EXCLUDED.postcode,\n')
        out.write('    property_type = EXCLUDED.property_type,\n')
        out.write('    bedrooms = EXCLUDED.bedrooms,\n')
        out.write('    bathrooms = EXCLUDED.bathrooms,\n')
        out.write('    car_spaces = EXCLUDED.car_spaces,\n')
        out.write('    land_size = EXCLUDED.land_size,\n')
        out.write('    building_size = EXCLUDED.building_size,\n')
        out.write('    latitude = EXCLUDED.latitude,\n')
        out.write('    longitude = EXCLUDED.longitude,\n')
        out.write('    source = EXCLUDED.source,\n')
        out.write('    updated_at = NOW();\n\n')
        
        # 生成郊区统计数据
        out.write('-- 生成郊区统计数据\n')
        out.write('INSERT INTO suburbs (\n')
        out.write('    suburb, state, postcode, median_price, sales_12m, growth_12m, updated_at\n')
        out.write(') SELECT\n')
        out.write('    s.suburb,\n')
        out.write('    COALESCE(s.state, \'QLD\') as state,\n')
        out.write('    COALESCE(s.postcode, \'4000\') as postcode,\n')
        out.write('    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,\n')
        out.write('    COUNT(*) as sales_12m,\n')
        out.write('    -- 计算 12 个月增长率\n')
        out.write('    (SELECT\n')
        out.write('        CASE\n')
        out.write('            WHEN COUNT(*) > 0 THEN\n')
        out.write('                (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s_current.sale_price) /\n')
        out.write('                 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s_previous.sale_price) - 1) * 100\n')
        out.write('            ELSE NULL\n')
        out.write('        END\n')
        out.write('     FROM sales s_previous\n')
        out.write('     WHERE s_previous.suburb = s.suburb\n')
        out.write('     AND s_previous.sale_date BETWEEN NOW() - INTERVAL \'24 months\' AND NOW() - INTERVAL \'12 months\'\n')
        out.write('    ) as growth_12m,\n')
        out.write('    NOW() as updated_at\n')
        out.write('FROM sales s\n')
        out.write('WHERE s.sale_date >= NOW() - INTERVAL \'12 months\'\n')
        out.write('GROUP BY s.suburb, s.state, s.postcode\n')
        out.write('ON CONFLICT (suburb, postcode) DO UPDATE SET\n')
        out.write('    median_price = EXCLUDED.median_price,\n')
        out.write('    sales_12m = EXCLUDED.sales_12m,\n')
        out.write('    growth_12m = EXCLUDED.growth_12m,\n')
        out.write('    updated_at = NOW();\n\n')
        
        # 查看结果
        out.write('-- 查看导入结果\n')
        out.write('SELECT COUNT(*) AS total_sales FROM sales;\n')
        out.write('SELECT suburb, COUNT(*) AS sales_count FROM sales GROUP BY suburb ORDER BY sales_count DESC;\n')
        out.write('SELECT * FROM suburbs ORDER BY median_price DESC LIMIT 10;\n')
    
    print(f"处理完成: 总记录数={total_records}, 有效记录数={valid_records}, 无效记录数={invalid_records}")
    print(f"SQL脚本已生成: {OUTPUT_FILE}")

if __name__ == '__main__':
    main()
