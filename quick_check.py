#!/usr/bin/env python3
"""
快速验证 Render 是否连接到 Supabase
"""
import requests

API_BASE = "https://compass-r58x.onrender.com"

print("🔍 快速验证 Render 连接状态...\n")

try:
    response = requests.get(f"{API_BASE}/", timeout=30)
    data = response.json()
    
    db_status = data.get("database", "N/A")
    
    if db_status == "connected":
        print("✅✅✅ 成功！已连接到真实 Supabase 数据库！")
        print(f"📊 响应: {data}")
    elif db_status == "mock":
        print("⚠️  当前使用 mock 数据库")
        print(f"📊 响应: {data}")
        print("\n请检查：")
        print("1. DATABASE_URL 是否使用端口 6543（Transaction pooler）")
        print("2. Render 是否已完成重新部署")
    else:
        print(f"❌ 未知的数据库状态: {db_status}")
        print(f"📊 响应: {data}")
        
except Exception as e:
    print(f"❌ 请求失败: {e}")
