#!/usr/bin/env python3
"""
验证数据导入是否成功
"""
import requests
import json

try:
    # 发送请求
    response = requests.get('https://compass-r58x.onrender.com/api/home', timeout=30)
    response.raise_for_status()  # 检查请求是否成功
    
    # 解析 JSON 数据
    data = response.json()
    
    # 打印各区成交数量
    print('各区成交数量：')
    total = 0
    for suburb in data['suburb_stats']:
        print(f"  {suburb['suburb']}: {suburb['total_sales']}条")
        total += suburb['total_sales']
    print(f"总计: {total}条")
    
    # 验证数据是否完整
    if total > 2000:
        print("✅ 数据导入成功！")
    else:
        print("⚠️  数据可能不完整，请检查导入过程")
        
except Exception as e:
    print(f"❌ 验证失败: {e}")
