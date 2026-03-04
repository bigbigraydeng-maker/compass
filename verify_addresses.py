#!/usr/bin/env python3
"""
验证 API 返回的地址是否为真实数据
"""
import requests

API_BASE = "https://compass-r58x.onrender.com"

print("=== 验证 API 返回的地址字段 ===")
print()

# 测试首页数据
print("1. 测试首页数据 (最新成交)...")
home_url = f"{API_BASE}/api/home"
response = requests.get(home_url, timeout=30)
if response.status_code == 200:
    data = response.json()
    latest_sales = data.get("latest_sales", [])
    print(f"   找到 {len(latest_sales)} 条最新成交记录")
    print()
    for i, sale in enumerate(latest_sales[:5]):  # 只显示前5条
        address = sale.get("address", "")
        suburb = sale.get("suburb", "")
        print(f"   [{i+1}] {address}")
else:
    print(f"   ❌ 错误: {response.status_code}")

print()
print("2. 测试 Sunnybank 的成交列表...")
sales_url = f"{API_BASE}/api/sales?suburb=Sunnybank&page=1&page_size=5"
response = requests.get(sales_url, timeout=30)
if response.status_code == 200:
    data = response.json()
    sales = data.get("sales", [])
    print(f"   找到 {len(sales)} 条记录")
    print()
    for i, sale in enumerate(sales):
        address = sale.get("address", "")
        suburb = sale.get("suburb", "")
        print(f"   [{i+1}] {address}")
else:
    print(f"   ❌ 错误: {response.status_code}")

print()
print("=== 验证完成 ===")
