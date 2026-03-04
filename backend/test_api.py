#!/usr/bin/env python3
"""
测试 Compass MVP API 端点
"""
import requests
import json

BASE_URL = "http://localhost:8080"

def test_endpoint(name, url, expected_keys=None):
    """测试 API 端点"""
    print(f"\n🧪 测试 {name}...")
    print(f"   URL: {url}")
    
    try:
        response = requests.get(url)
        print(f"   状态码: {response.status_code}")
        
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
                        print(f"   📊 {key}: {value[:50]}...")
            
            return True
        else:
            print(f"   ❌ 失败: {response.text}")
            return False
            
    except Exception as e:
        print(f"   ❌ 错误: {e}")
        return False

def main():
    print("🚀 Compass MVP API 测试")
    print("=" * 50)
    
    results = []
    
    # 测试根路径
    results.append(test_endpoint("根路径", f"{BASE_URL}/"))
    
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
    print("\n" + "=" * 50)
    print("📊 测试总结:")
    passed = sum(results)
    total = len(results)
    print(f"   通过: {passed}/{total}")
    print(f"   失败: {total - passed}/{total}")
    
    if passed == total:
        print(f"\n🎉 所有测试通过！API 工作正常！")
    else:
        print(f"\n⚠️  有 {total - passed} 个测试失败，请检查")

if __name__ == "__main__":
    main()
