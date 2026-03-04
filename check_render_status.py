#!/usr/bin/env python3
"""
检查 Render 部署日志中的错误信息
"""
import requests

API_BASE = "https://compass-r58x.onrender.com"

print("🔍 检查 API 状态和错误信息...\n")

# 测试根路由
try:
    response = requests.get(f"{API_BASE}/", timeout=30)
    data = response.json()
    print(f"📊 根路由响应: {data}\n")
    
    if data.get("database") == "mock":
        print("❌ 当前使用 mock 数据库")
        print("\n可能的原因：")
        print("1. DATABASE_URL 环境变量未设置或格式错误")
        print("2. 连接字符串使用了错误的端口（应该是 6543）")
        print("3. Supabase 连接字符串格式不正确")
        print("4. 密码包含特殊字符需要 URL 编码")
        print("\n请检查 Render Dashboard 中的环境变量设置：")
        print("- DATABASE_URL 格式应该是：")
        print("  postgresql://postgres.[项目ID]:[密码]@aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres")
        print("\n⚠️  注意：端口必须是 6543（Transaction pooler）")
        
except Exception as e:
    print(f"❌ 请求失败: {e}")

# 测试数据接口
print("\n" + "="*60)
print("测试数据接口...")
print("="*60 + "\n")

try:
    response = requests.get(f"{API_BASE}/api/suburb/Sunnybank", timeout=30)
    if response.status_code == 200:
        data = response.json()
        print(f"✅ 数据接口正常")
        print(f"📊 total_sales: {data.get('total_sales')}")
        print(f"📊 median_price: {data.get('median_price')}")
        
        if data.get('recent_sales'):
            sample = data['recent_sales'][0]
            print(f"\n📝 示例数据:")
            print(f"   地址: {sample.get('address')}")
            print(f"   成交价: {sample.get('sold_price')}")
    else:
        print(f"❌ 数据接口错误: {response.status_code}")
        print(f"   响应: {response.text}")
        
except Exception as e:
    print(f"❌ 请求失败: {e}")
