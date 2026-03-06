#!/usr/bin/env python3
"""
验证数据导入是否成功
"""
import requests

API_URL = "https://compass-r58x.onrender.com"

def verify_api():
    print("=" * 50)
    print("验证数据导入")
    print("=" * 50)
    
    # 1. 检查首页数据
    print("\n1. 检查首页数据...")
    try:
        r = requests.get(f"{API_URL}/api/home", timeout=30)
        if r.status_code == 200:
            data = r.json()
            print(f"   ✅ 首页 API 正常")
            print(f"   - 最新成交: {len(data.get('latest_sales', []))} 条")
            print(f"   - 郊区统计: {len(data.get('suburb_stats', []))} 个")
            for stat in data.get('suburb_stats', []):
                print(f"     • {stat['suburb']}: 中位价 ${stat['median_price']:,}, {stat['total_sales']} 条成交")
        else:
            print(f"   ❌ 首页 API 返回错误: {r.status_code}")
    except Exception as e:
        print(f"   ❌ 首页 API 请求失败: {e}")
    
    # 2. 检查各郊区详情
    suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield']
    print("\n2. 检查各郊区详情...")
    for suburb in suburbs:
        try:
            r = requests.get(f"{API_URL}/api/suburb/{suburb}", timeout=30)
            if r.status_code == 200:
                data = r.json()
                print(f"   ✅ {suburb}: 中位价 ${data.get('median_price', 0):,}, {data.get('total_sales', 0)} 条成交")
            else:
                print(f"   ❌ {suburb}: API 返回错误 {r.status_code}")
        except Exception as e:
            print(f"   ❌ {suburb}: 请求失败 - {e}")
    
    # 3. 检查价格走势
    print("\n3. 检查价格走势...")
    for suburb in suburbs[:3]:  # 只检查前3个
        try:
            r = requests.get(f"{API_URL}/api/suburb/{suburb}/trends", timeout=30)
            if r.status_code == 200:
                data = r.json()
                trends = data.get('monthly_trends', [])
                print(f"   ✅ {suburb}: {len(trends)} 个月度数据点")
            else:
                print(f"   ❌ {suburb}: API 返回错误 {r.status_code}")
        except Exception as e:
            print(f"   ❌ {suburb}: 请求失败 - {e}")
    
    print("\n" + "=" * 50)
    print("验证完成")
    print("=" * 50)

if __name__ == "__main__":
    verify_api()
