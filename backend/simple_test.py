#!/usr/bin/env python3
"""
直接测试 execute_query 函数
"""
import sys
sys.path.insert(0, '.')

from database_mock import execute_query

print("=== 测试 COUNT 查询 ===")
count_query = "SELECT COUNT(*) as total FROM (SELECT s.id, s.property_id, s.sold_price, s.sold_date, p.address, p.suburb, p.property_type, p.land_size, p.bedrooms, p.bathrooms FROM sales s JOIN properties p ON s.property_id = p.id WHERE p.suburb = %s) as subq"
params = ("Sunnybank",)
total_result = execute_query(count_query, params)
print(f"Query: {count_query}")
print(f"Params: {params}")
print(f"total_result: {total_result}")
print(f"type(total_result): {type(total_result)}")
if total_result:
    print(f"total_result[0]: {total_result[0]}")
    print(f"type(total_result[0]): {type(total_result[0])}")

print("\n=== 测试中位数查询 ===")
median_query = """
    SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sold_price) as median_price,
           COUNT(*) as total_sales
    FROM sales s
    JOIN properties p ON s.property_id = p.id
    WHERE p.suburb = %s
"""
median_result = execute_query(median_query, ("Sunnybank",))
print(f"median_result: {median_result}")
if median_result:
    print(f"median_result[0]: {median_result[0]}")
