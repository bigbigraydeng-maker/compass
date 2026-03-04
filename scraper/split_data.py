#!/usr/bin/env python3
"""
Compass MVP 数据拆分脚本
将 raw_sales.csv 拆分成 properties.csv 和 sales.csv
分别对应 Supabase 的两个表
"""

import pandas as pd
import os

# 读取原始 CSV
csv_path = "data/raw_sales.csv"
df = pd.read_csv(csv_path)

print(f"📊 原始数据: {len(df)} 条记录")
print(f"📋 字段: {list(df.columns)}")

# 1. 创建 properties.csv
properties_df = df[['address', 'suburb', 'property_type', 'land_size', 'bedrooms', 'bathrooms']].copy()
properties_df = properties_df.drop_duplicates(subset=['address', 'suburb'])

properties_path = "data/properties.csv"
properties_df.to_csv(properties_path, index=False)

print(f"\n✅ 已创建 properties.csv")
print(f"   记录数: {len(properties_df)}")
print(f"   字段: {list(properties_df.columns)}")

# 2. 创建 sales.csv
# 需要获取 property_id，先保存临时文件
sales_temp_df = df[['address', 'suburb', 'sold_price', 'sold_date']].copy()

sales_temp_path = "data/sales_temp.csv"
sales_temp_df.to_csv(sales_temp_path, index=False)

print(f"\n✅ 已创建 sales_temp.csv")
print(f"   记录数: {len(sales_temp_df)}")
print(f"   字段: {list(sales_temp_df.columns)}")

# 3. 显示导入步骤
print(f"\n📋 Supabase 导入步骤:")
print(f"   第一步：导入 properties.csv 到 properties 表")
print(f"   第二步：导入 sales_temp.csv 到 sales 表（需要通过 SQL 关联 property_id）")

# 4. 提供完整的 SQL 导入脚本
sql_script = """
-- Compass MVP 数据导入脚本（完整版）
-- 分步导入 properties 和 sales 数据

-- 第一步：导入 properties 表
CREATE TEMP TABLE temp_properties (
    address TEXT,
    suburb TEXT,
    property_type TEXT,
    land_size INTEGER,
    bedrooms INTEGER,
    bathrooms INTEGER
);

-- 导入 CSV 数据（需要在 Supabase SQL Editor 中手动粘贴 CSV 数据或使用文件上传）
-- 这里假设 CSV 文件已经上传到服务器

INSERT INTO properties(address, suburb, property_type, land_size, bedrooms, bathrooms)
SELECT DISTINCT address, suburb, property_type, land_size, bedrooms, bathrooms
FROM temp_properties;

-- 第二步：导入 sales 表
CREATE TEMP TABLE temp_sales (
    address TEXT,
    suburb TEXT,
    sold_price INTEGER,
    sold_date DATE
);

-- 导入 CSV 数据

INSERT INTO sales(property_id, sold_price, sold_date)
SELECT p.id, t.sold_price, t.sold_date
FROM temp_sales t
JOIN properties p ON t.address = p.address AND t.suburb = p.suburb;

-- 清理临时表
DROP TABLE temp_properties;
DROP TABLE temp_sales;

-- 验证导入结果
SELECT 
    (SELECT COUNT(*) FROM properties) AS total_properties,
    (SELECT COUNT(*) FROM sales) AS total_sales;
"""

sql_path = "database/import_split_data.sql"
with open(sql_path, 'w', encoding='utf-8') as f:
    f.write(sql_script)

print(f"\n💾 已创建 SQL 导入脚本: {sql_path}")

print(f"\n✅ 数据拆分完成！")
print(f"   properties.csv: {len(properties_df)} 条记录")
print(f"   sales_temp.csv: {len(sales_temp_df)} 条记录")
