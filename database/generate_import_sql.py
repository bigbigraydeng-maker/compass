#!/usr/bin/env python3
"""
生成 Supabase 导入 SQL 语句
"""
import pandas as pd

def generate_sql():
    # 读取 CSV
    df = pd.read_csv('data/raw_sales_new.csv')
    
    print(f"总共 {len(df)} 条记录")
    
    # 生成 properties 插入语句
    properties_sql = []
    sales_sql = []
    
    # 用于生成 property_id
    property_id = 1
    address_to_id = {}
    
    # 按郊区统计
    suburb_count = {}
    
    for idx, row in df.iterrows():
        address = row['address']
        suburb = row['suburb']
        
        # 规范化 suburb 名称
        suburb_normalized = suburb.strip()
        if suburb_normalized.upper() == 'MANSFIELD':
            suburb_normalized = 'Mansfield'
        elif suburb_normalized.upper() == 'ROCHEDALE':
            suburb_normalized = 'Rochedale'
        
        # 统计
        if suburb_normalized not in suburb_count:
            suburb_count[suburb_normalized] = 0
        suburb_count[suburb_normalized] += 1
        
        # 如果地址不存在，创建新的 property
        if address not in address_to_id:
            address_to_id[address] = property_id
            
            # 处理 postcode
            postcode_map = {
                'Sunnybank': 4109,
                'Eight Mile Plains': 4113,
                'Calamvale': 4116,
                'Rochedale': 4123,
                'Mansfield': 4122,
                'Ascot': 4007,
                'Hamilton': 4007
            }
            postcode = postcode_map.get(suburb_normalized, 4000)
            
            # properties 插入语句
            prop_sql = f"""INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES ({property_id}, '{address.replace("'", "''")}', '{suburb_normalized}', '{row['property_type']}', {row['land_size'] or 'NULL'}, {row['building_size'] or 'NULL'}, {row['bedrooms'] or 'NULL'}, {row['bathrooms'] or 'NULL'}, {row['car_spaces'] or 'NULL'});"""
            properties_sql.append(prop_sql)
            
            property_id += 1
        
        # sales 插入语句
        pid = address_to_id[address]
        sold_price = row['sold_price'] if pd.notna(row['sold_price']) else 'NULL'
        sold_date = row['sold_date'] if pd.notna(row['sold_date']) else 'NULL'
        
        if sold_date != 'NULL':
            sale_sql = f"""INSERT INTO sales (property_id, sold_price, sold_date)
VALUES ({pid}, {sold_price}, '{sold_date}');"""
            sales_sql.append(sale_sql)
    
    # 保存 SQL 文件
    with open('database/import_new_data.sql', 'w', encoding='utf-8') as f:
        f.write("-- 清空旧数据\n")
        f.write("DELETE FROM sales;\n")
        f.write("DELETE FROM properties;\n")
        f.write("ALTER SEQUENCE properties_id_seq RESTART WITH 1;\n")
        f.write("ALTER SEQUENCE sales_id_seq RESTART WITH 1;\n\n")
        
        f.write("-- 插入 properties\n")
        for sql in properties_sql:
            f.write(sql + "\n")
        
        f.write("\n-- 插入 sales\n")
        for sql in sales_sql:
            f.write(sql + "\n")
    
    print(f"生成了 {len(properties_sql)} 条 properties 插入语句")
    print(f"生成了 {len(sales_sql)} 条 sales 插入语句")
    print("SQL 文件已保存到: database/import_new_data.sql")
    
    # 打印统计
    print("\n按郊区统计:")
    for suburb, count in suburb_count.items():
        print(f"  {suburb}: {count}条")

if __name__ == "__main__":
    generate_sql()
