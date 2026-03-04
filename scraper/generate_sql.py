#!/usr/bin/env python3
"""
Compass MVP 数据导入脚本（修复版）
直接生成可执行的 SQL 文件，避免 CSV 格式问题
"""

import pandas as pd
import os

# 读取原始 CSV
csv_path = "data/raw_sales.csv"
df = pd.read_csv(csv_path)

print(f"📊 原始数据: {len(df)} 条记录")

# 1. 生成 properties INSERT 语句
properties_df = df[['address', 'suburb', 'property_type', 'land_size', 'bedrooms', 'bathrooms']].copy()
properties_df = properties_df.drop_duplicates(subset=['address', 'suburb'])

properties_sql = "-- Compass MVP Properties 数据导入\n"
properties_sql += "-- 直接在 Supabase SQL Editor 中执行此脚本\n\n"
properties_sql += "INSERT INTO properties(address, suburb, property_type, land_size, bedrooms, bathrooms) VALUES\n"

values_list = []
for idx, row in properties_df.iterrows():
    address = str(row['address']).replace("'", "''")
    suburb = str(row['suburb'])
    property_type = str(row['property_type']) if pd.notna(row['property_type']) and row['property_type'] else 'house'
    land_size = int(row['land_size']) if pd.notna(row['land_size']) else 0
    bedrooms = int(row['bedrooms']) if pd.notna(row['bedrooms']) else 0
    bathrooms = int(row['bathrooms']) if pd.notna(row['bathrooms']) else 0
    
    values_list.append(f"('{address}', '{suburb}', '{property_type}', {land_size}, {bedrooms}, {bathrooms})")

properties_sql += ',\n'.join(values_list) + ';\n'

properties_sql_path = "database/import_properties.sql"
with open(properties_sql_path, 'w', encoding='utf-8') as f:
    f.write(properties_sql)

print(f"\n✅ 已生成 properties 导入脚本: {properties_sql_path}")
print(f"   记录数: {len(properties_df)}")

# 2. 生成 sales INSERT 语句
sales_df = df[['address', 'suburb', 'sold_price', 'sold_date']].copy()

sales_sql = "-- Compass MVP Sales 数据导入\n"
sales_sql += "-- 注意：需要先导入 properties 数据\n"
sales_sql += "-- 此脚本使用子查询自动关联 property_id\n\n"

# 使用 WITH 子句创建临时数据
sales_sql += "WITH sales_data AS (\n"

values_list = []
for idx, row in sales_df.iterrows():
    address = str(row['address']).replace("'", "''")
    suburb = str(row['suburb'])
    sold_price = int(row['sold_price'])
    sold_date = str(row['sold_date'])
    
    values_list.append(f"    SELECT '{address}' AS address, '{suburb}' AS suburb, {sold_price} AS sold_price, '{sold_date}'::date AS sold_date")

sales_sql += ' UNION ALL\n'.join(values_list)
sales_sql += "\n)\n"

# 关联 property_id
sales_sql += "INSERT INTO sales(property_id, sold_price, sold_date)\n"
sales_sql += "SELECT p.id, t.sold_price, t.sold_date\n"
sales_sql += "FROM sales_data t\n"
sales_sql += "JOIN properties p ON t.address = p.address AND t.suburb = p.suburb;\n"

sales_sql_path = "database/import_sales.sql"
with open(sales_sql_path, 'w', encoding='utf-8') as f:
    f.write(sales_sql)

print(f"✅ 已生成 sales 导入脚本: {sales_sql_path}")
print(f"   记录数: {len(sales_df)}")

# 3. 创建完整的导入脚本
full_sql = properties_sql + "\n\n" + sales_sql + "\n\n"
full_sql += "-- 验证导入结果\n"
full_sql += "SELECT \n"
full_sql += "    (SELECT COUNT(*) FROM properties) AS total_properties,\n"
full_sql += "    (SELECT COUNT(*) FROM sales) AS total_sales;"

full_sql_path = "database/import_all.sql"
with open(full_sql_path, 'w', encoding='utf-8') as f:
    f.write(full_sql)

print(f"\n✅ 已生成完整导入脚本: {full_sql_path}")

print(f"\n📋 Supabase 导入步骤:")
print(f"   1. 打开 Supabase SQL Editor")
print(f"   2. 复制 database/import_all.sql 的内容")
print(f"   3. 粘贴到 SQL Editor 并执行")
print(f"   4. 验证结果应该显示：total_properties=155, total_sales=155")

print(f"\n✅ SQL 脚本生成完成！")
print(f"   不需要担心 CSV 格式问题，直接执行 SQL 即可")
