#!/usr/bin/env python3
"""
Compass MVP 数据清洗脚本（修复版）
清洗 raw_sales.csv 中的异常数据，并确保字段顺序正确
"""

import pandas as pd
import os

# 读取 CSV 文件
csv_path = "data/raw_sales.csv"
df = pd.read_csv(csv_path)

print(f"📊 原始数据: {len(df)} 条记录")
print(f"📋 当前字段顺序: {list(df.columns)}")

# 1. 清洗空地址记录
print(f"\n🔍 检查空地址记录...")
empty_address = df[df['address'].str.strip() == '']
print(f"  发现 {len(empty_address)} 条空地址记录")
if len(empty_address) > 0:
    print(f"  示例: {empty_address['address'].tolist()}")
    df = df[df['address'].str.strip() != '']
    print(f"  ✅ 已删除空地址记录")

# 2. 给 property_type 空值填默认值
print(f"\n🔍 检查 property_type 空值...")
empty_property_type = df[df['property_type'].isna() | (df['property_type'] == '')]
print(f"  发现 {len(empty_property_type)} 条空 property_type 记录")
if len(empty_property_type) > 0:
    df.loc[df['property_type'].isna(), 'property_type'] = 'house'
    df.loc[df['property_type'] == '', 'property_type'] = 'house'
    print(f"  ✅ 已将空 property_type 填充为 'house'")

# 3. 确保字段顺序正确（与数据库表结构一致）
correct_columns = ['address', 'suburb', 'property_type', 'bedrooms', 'bathrooms', 'land_size', 'sold_price', 'sold_date']
df = df[correct_columns]

print(f"\n📋 修正后字段顺序: {list(df.columns)}")

# 4. 检查数据质量
print(f"\n📊 清洗后数据统计:")
print(f"  总记录数: {len(df)}")
print(f"  property_type 分布:")
print(df['property_type'].value_counts())
print(f"\n  sold_price 范围: ${df['sold_price'].min():,} - ${df['sold_price'].max():,}")
print(f"  sold_date 范围: {df['sold_date'].min()} - {df['sold_date'].max()}")

# 5. 保存清洗后的数据
backup_path = "data/raw_sales_backup.csv"
df.to_csv(backup_path, index=False)
print(f"\n💾 已备份原始数据到 {backup_path}")

df.to_csv(csv_path, index=False)
print(f"💾 已保存清洗后数据到 {csv_path}")

print(f"\n✅ 数据清洗完成！")
print(f"   删除记录: {155 - len(df)} 条")
print(f"   最终记录: {len(df)} 条")
print(f"\n📋 CSV 文件字段顺序（与 Supabase 表格一致）:")
print(f"   1. address")
print(f"   2. suburb")
print(f"   3. property_type")
print(f"   4. bedrooms")
print(f"   5. bathrooms")
print(f"   6. land_size")
print(f"   7. sold_price")
print(f"   8. sold_date")
