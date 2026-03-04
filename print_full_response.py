#!/usr/bin/env python3
"""
直接打印 API 返回的完整 JSON
"""
import requests
import json

API_BASE = "https://compass-r58x.onrender.com"

print("=== 打印完整的 JSON 响应 ===")
print()

sales_url = f"{API_BASE}/api/sales?suburb=Sunnybank&page=1&page_size=3"
response = requests.get(sales_url, timeout=30)

if response.status_code == 200:
    data = response.json()
    print("完整响应:")
    print(json.dumps(data, indent=2, ensure_ascii=False))
    print()
    print("销售记录详情:")
    for i, sale in enumerate(data.get("sales", [])):
        print(f"\n记录 {i+1}:")
        print(f"  address: {sale.get('address', 'N/A')}")
        print(f"  suburb: {sale.get('suburb', 'N/A')}")
        print(f"  sold_price: {sale.get('sold_price', 'N/A')}")
        print(f"  sold_date: {sale.get('sold_date', 'N/A')}")
        print(f"  property_type: {sale.get('property_type', 'N/A')}")
else:
    print(f"错误: {response.status_code}")
    print(response.text)
