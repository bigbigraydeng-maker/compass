#!/usr/bin/env python3
"""
调试模拟数据库
"""
import sys
sys.path.insert(0, '.')

from database_mock import execute_query
from mock_data import MOCK_PROPERTIES, MOCK_SALES

print(f"=== 数据统计 ===")
print(f"Total properties: {len(MOCK_PROPERTIES)}")
print(f"Total sales: {len(MOCK_SALES)}")
print()

print("=== 测试 1: 查询所有 sales 数量 ===")
query = "SELECT COUNT(*) as total FROM sales s JOIN properties p ON s.property_id = p.id"
result = execute_query(query)
print(f"Query: {query}")
print(f"Result: {result}")
print()

print("=== 测试 2: 查询 Sunnybank 的 sales 数量 ===")
query = "SELECT COUNT(*) as total FROM sales s JOIN properties p ON s.property_id = p.id WHERE p.suburb = %s"
result = execute_query(query, ("Sunnybank",))
print(f"Query: {query}")
print(f"Params: ('Sunnybank',)")
print(f"Result: {result}")
print()

print("=== 测试 3: 查询 Sunnybank 的中位价 ===")
query = """
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sold_price) as median_price,
           COUNT(*) as total_sales
    FROM sales s
    JOIN properties p ON s.property_id = p.id
    WHERE p.suburb = %s
"""
result = execute_query(query, ("Sunnybank",))
print(f"Result: {result}")
print()
