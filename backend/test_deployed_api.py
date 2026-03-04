#!/usr/bin/env python3
"""
测试已部署的 Compass API
"""
import requests
import json
import time

BASE_URL = "https://compass-r58x.onrender.com"

def test_endpoint(name, url, expected_keys=None):
    """测试 API 端点"""
    print(f"\n🧪 测试 {name}...")
    print(f"   URL: {url}")
    
    try:
        start_time = time.time()
        response = requests.get(url, timeout=30)
        elapsed_time = round(time.time() - start_time, 2)
        
        print(f"   状态码: {response.status_code}")
        print(f"   响应时间: {elapsed_time} 秒")
        
        if response.status_code == 200:
            data = response.json()
            print(f"   ✅ 成功！")
            
            if expected_keys:
                missing_keys = [key for key in expected_keys if key not in data]
                if missing_keys:
                    print(f"   ⚠️  缺少字段: {missing_keys}")
                else:
                    print(f"   ✅ 包含所有预期字段: {expected_keys}")
            
            # 显示部分数据
            if isinstance(data, dict):
                for key, value in data.items():
                    if isinstance(value, list):
                        print(f"   📊 {key}: {len(value)} 条记录")
                    elif isinstance(value, (int, float)):
                        print(f"   📊 {key}: {value}")
                    elif isinstance(value, str):
                        preview = value[:80] + "..." if len(value) > 80 else value
                        print(f"   📊 {key}: {preview}")
            
            return True
        else:
            print(f"   ❌ 失败: {response.text}")
            return False
            
    except requests.exceptions.Timeout:
        print(f"   ⏰ 超时 (30秒)")
        return False
    except Exception as e:
        print(f"   ❌ 错误: {e}")
        return False

def main():
    print("🚀 Compass 已部署 API 测试")
    print("=" * 60)
    print(f"服务地址: {BASE_URL}")
    print()
    print("💡 提示: 免费版本可能需要 10-30 秒唤醒")
    print()
    
    results = []
    
    # 测试根路径
    results.append(test_endpoint("根路径", f"{BASE_URL}/"))
    
    # 等待一下让服务完全唤醒
    if len(results) > 0 and results[0]:
        print("\n⏳ 等待服务完全启动...")
        time.sleep(5)
    
    # 测试首页数据
    results.append(test_endpoint(
        "首页数据", 
        f"{BASE_URL}/api/home",
        expected_keys=["latest_sales", "suburb_stats"]
    ))
    
    # 测试成交列表
    results.append(test_endpoint(
        "成交列表（Sunnybank）", 
        f"{BASE_URL}/api/sales?suburb=Sunnybank",
        expected_keys=["sales", "total", "page", "page_size"]
    ))
    
    # 测试成交列表（无过滤）
    results.append(test_endpoint(
        "成交列表（全部）", 
        f"{BASE_URL}/api/sales",
        expected_keys=["sales", "total", "page", "page_size"]
    ))
    
    # 测试郊区详情
    results.append(test_endpoint(
        "郊区详情（Sunnybank）", 
        f"{BASE_URL}/api/suburb/Sunnybank",
        expected_keys=["suburb", "median_price", "total_sales", "recent_sales"]
    ))
    
    # 测试郊区详情（Calamvale）
    results.append(test_endpoint(
        "郊区详情（Calamvale）", 
        f"{BASE_URL}/api/suburb/Calamvale",
        expected_keys=["suburb", "median_price", "total_sales", "recent_sales"]
    ))
    
    # 总结
    print("\n" + "=" * 60)
    print("📊 测试总结:")
    passed = sum(1 for r in results if r)
    total = len(results)
    print(f"   通过: {passed}/{total}")
    print(f"   失败: {total - passed}/{total}")
    
    if passed == total:
        print(f"\n🎉 所有测试通过！API 部署成功！")
        print(f"\n📚 API 文档: {BASE_URL}/docs")
        print(f"🏠 首页数据: {BASE_URL}/api/home")
    elif passed > 0:
        print(f"\n✅ 部分测试通过！")
        print(f"📚 API 文档: {BASE_URL}/docs")
    else:
        print(f"\n❌ 所有测试失败，请检查:")
        print(f"   1. Render 服务状态")
        print(f"   2. 环境变量配置（特别是 DATABASE_URL）")
        print(f"   3. Render 部署日志")

if __name__ == "__main__":
    main()
