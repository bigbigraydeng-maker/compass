#!/usr/bin/env python3
"""
验证 Render 连接 Supabase 的诊断脚本
"""
import requests
import time

API_BASE = "https://compass-r58x.onrender.com"

print("=" * 60)
print("Render 连接 Supabase 诊断工具")
print("=" * 60)

print("\n📋 操作步骤：")
print("\n1️⃣  检查 Render 环境变量：")
print("   - 打开 Render Dashboard")
print("   - 选择你的 compass 服务")
print("   - 点击 Environment 标签")
print("   - 查看 DATABASE_URL 的值")
print("   - 格式应该是：postgresql://postgres.xxxx:[密码]@aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres")
print("   - 注意：端口应该是 6543（Transaction pooler），不是 5432")

print("\n2️⃣  获取 Supabase 连接字符串：")
print("   - 打开 Supabase Dashboard")
print("   - 选择你的项目")
print("   - 点击 Settings → Database")
print("   - 找到 Connection string 部分")
print("   - 选择 'URI' 格式")
print("   - 复制 Transaction pooler 的连接字符串（端口 6543）")
print("   - 格式：postgresql://postgres.[项目ID]:[密码]@aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres")

print("\n3️⃣  更新 Render 环境变量：")
print("   - 在 Render Dashboard → Environment")
print("   - 更新 DATABASE_URL 为新的连接字符串")
print("   - 保存后 Render 会自动重新部署")

print("\n4️⃣  等待部署完成（约 2-3 分钟）")

print("\n5️⃣  运行验证脚本：")
print("   - python verify_supabase_connection.py")

print("\n" + "=" * 60)
print("开始验证...")
print("=" * 60)

print("\n🔍 步骤 1: 测试根路由")
try:
    response = requests.get(f"{API_BASE}/", timeout=30)
    print(f"✅ 状态码: {response.status_code}")
    data = response.json()
    print(f"📊 响应数据: {data}")
    
    db_status = data.get("database", "N/A")
    print(f"\n🎯 数据库状态: {db_status}")
    
    if db_status == "connected":
        print("✅✅✅ 成功！已连接到真实 Supabase 数据库！")
    elif db_status == "mock":
        print("⚠️  当前使用 mock 数据库（未连接到真实数据库）")
    else:
        print(f"❌ 未知的数据库状态: {db_status}")
        
except Exception as e:
    print(f"❌ 请求失败: {e}")

print("\n🔍 步骤 2: 测试 Sunnybank 数据")
try:
    response = requests.get(f"{API_BASE}/api/suburb/Sunnybank", timeout=30)
    print(f"✅ 状态码: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"📊 total_sales: {data.get('total_sales', 'N/A')}")
        print(f"📊 median_price: {data.get('median_price', 'N/A')}")
        
        if data.get('recent_sales'):
            sample = data['recent_sales'][0]
            print(f"\n📝 示例数据:")
            print(f"   地址: {sample.get('address', 'N/A')}")
            print(f"   成交价: {sample.get('sold_price', 'N/A')}")
            print(f"   成交日期: {sample.get('sold_date', 'N/A')}")
    else:
        print(f"❌ 错误响应: {response.text}")
        
except Exception as e:
    print(f"❌ 请求失败: {e}")

print("\n" + "=" * 60)
print("诊断完成")
print("=" * 60)

print("\n💡 提示：")
print("如果 database 状态仍然是 'mock'，请检查：")
print("1. DATABASE_URL 是否正确更新")
print("2. 端口是否为 6543（Transaction pooler）")
print("3. 密码是否正确")
print("4. Render 是否已完成重新部署")
