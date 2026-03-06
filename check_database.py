#!/usr/bin/env python3
"""
检查数据库表结构
"""
import psycopg2
import os

# 尝试连接数据库
DATABASE_URL = os.getenv('DATABASE_URL')
if DATABASE_URL:
    try:
        conn = psycopg2.connect(DATABASE_URL)
        cursor = conn.cursor()
        
        # 获取 properties 表结构
        cursor.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'properties' ORDER BY ordinal_position")
        print('Properties 表结构:')
        print('=' * 40)
        for column in cursor.fetchall():
            print(f'{column[0]:20} {column[1]}')
        
        # 获取 sales 表结构
        print('\nSales 表结构:')
        print('=' * 40)
        cursor.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'sales' ORDER BY ordinal_position")
        for column in cursor.fetchall():
            print(f'{column[0]:20} {column[1]}')
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f'无法连接数据库: {e}')
else:
    print('DATABASE_URL 环境变量未设置')
