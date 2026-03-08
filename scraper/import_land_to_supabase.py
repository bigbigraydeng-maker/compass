#!/usr/bin/env python3
"""
将土地数据导入到 Supabase listings 表
"""

import csv
import os
from supabase import create_client
import json

# Supabase 项目信息（从环境变量读取）
from dotenv import load_dotenv
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL", "https://evzkrexygwdnoqhyjylf.supabase.co")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "")

if not SUPABASE_SERVICE_KEY:
    print("❌ 请在 .env 文件中设置 SUPABASE_SERVICE_KEY")
    exit(1)

# 创建 Supabase 客户端
supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

# 读取土地数据
csv_file = "data/land_listings.csv"
if not os.path.exists(csv_file):
    print(f"❌ 未找到文件: {csv_file}")
    exit(1)

print(f"读取土地数据文件: {csv_file}")
with open(csv_file, "r", encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(f"共 {len(rows)} 条土地数据")

# 处理数据
processed_rows = []
for row in rows:
    # 数字字段转换
    processed_row = {
        "address": row.get("address", ""),
        "suburb": row.get("suburb", ""),
        "property_type": "vacant_land",
        "land_size": int(row["land_size"]) if row.get("land_size") and row["land_size"] != "" else None,
        "price_text": row.get("price_text", ""),
        "price": float(row["price"]) if row.get("price") and row["price"] != "" else None,
        "agent_name": row.get("agent_name", ""),
        "agent_company": row.get("agent_company", ""),
        "link": row.get("link", ""),
        "scraped_date": row.get("scraped_date", ""),
        "bedrooms": None,
        "bathrooms": None,
        "car_spaces": None
    }
    processed_rows.append(processed_row)

print("处理完成，准备入库...")

# 先清空旧的 vacant_land 数据
print("清空旧的土地数据...")
try:
    result = supabase.table("listings").delete().eq("property_type", "vacant_land").execute()
    print(f"已清空旧数据")
except Exception as e:
    print(f"清空旧数据失败: {e}")

# 批量插入
print("开始插入新数据...")
try:
    # 批量插入，每次最多 100 条
    batch_size = 100
    for i in range(0, len(processed_rows), batch_size):
        batch = processed_rows[i:i+batch_size]
        result = supabase.table("listings").insert(batch).execute()
        print(f"已插入 {len(result.data)} 条数据")
    
    print(f"\n✅ 入库完成: 共 {len(processed_rows)} 条土地数据")
    
except Exception as e:
    print(f"❌ 插入数据失败: {e}")
    import traceback
    traceback.print_exc()
