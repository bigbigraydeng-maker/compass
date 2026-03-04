#!/usr/bin/env python3
"""
验证 Render 部署后的 API
"""
import requests
import time

API_BASE = "https://compass-r58x.onrender.com"

print("=== 等待 Render 部署完成... ===")
print("等待 180 秒...")
time.sleep(180)

print()
print("=== 步骤 1: 测试根路由 ===")
root_url = API_BASE + "/"
response = requests.get(root_url, timeout=30)
print(f"URL: {root_url}")
print(f"状态码: {response.status_code}")
if response.status_code == 200:
    data = response.json()
    print(f"响应: {data}")
    db_status = data.get("database", "N/A")
    print(f"database 字段: {db_status}")
    if db_status == "connected":
        print("✅ 成功：database 字段为 'connected'")
    else:
        print(f"❌ 失败：期望 'connected'，实际为 '{db_status}'")

print()
print("=== 步骤 2: 测试 Sunnybank 郊区详情 ===")
suburb_url = API_BASE + "/api/suburb/Sunnybank"
response = requests.get(suburb_url, timeout=30)
print(f"URL: {suburb_url}")
print(f"状态码: {response.status_code}")
if response.status_code == 200:
    data = response.json()
    print(f"total_sales: {data.get('total_sales', 'N/A')}")
    if data.get("total_sales") == 50:
        print("✅ 成功：total_sales 为 50")
    else:
        print(f"❌ 失败：期望 50，实际为 {data.get('total_sales')}")

print()
print("=== 验证完成 ===")
