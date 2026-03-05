#!/usr/bin/env python3
"""
导入新数据到 Supabase
"""

import csv
import os
import psycopg2
from psycopg2.extras import execute_values


def import_data():
    print("="*60)
    print("导入数据到 Supabase")
    print("="*60)
    
    # 读取环境变量
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("❌ 未找到 DATABASE_URL 环境变量")
        print("请设置: export DATABASE_URL='postgresql://...'")
        return
    
    # 读取 CSV 数据
    csv_file = 'data/raw_sales_new.csv'
    if not os.path.exists(csv_file):
        print(f"❌ 未找到 CSV 文件: {csv_file}")
        return
    
    print(f"\n📄 读取 CSV 文件: {csv_file}")
    
    properties = []
    sales = []
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            properties.append((
                row['address'],
                row['suburb'],
                row['property_type'],
                int(row['land_size']) if row['land_size'] else 0,
                int(row['building_size']) if row['building_size'] else 0,
                int(row['bedrooms']) if row['bedrooms'] else 0,
                int(row['bathrooms']) if row['bathrooms'] else 0,
                int(row['car_spaces']) if row['car_spaces'] else 0,
            ))
            sales.append((
                int(row['sold_price']) if row['sold_price'] else 0,
                row['sold_date'],
            ))
    
    print(f"✅ 读取了 {len(properties)} 条记录")
    
    # 连接数据库
    print("\n🔌 连接 Supabase...")
    try:
        conn = psycopg2.connect(database_url)
        cur = conn.cursor()
        print("✅ 连接成功")
        
        # 清空现有数据
        print("\n🗑️  清空现有数据...")
        cur.execute("TRUNCATE TABLE sales CASCADE;")
        cur.execute("TRUNCATE TABLE properties CASCADE;")
        print("✅ 已清空")
        
        # 导入 properties
        print(f"\n📥 导入 {len(properties)} 条 properties 记录...")
        execute_values(
            cur,
            """
            INSERT INTO properties (address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
            VALUES %s
            RETURNING id
            """,
            properties
        )
        
        # 获取插入的 property IDs
        property_ids = [row[0] for row in cur.fetchall()]
        print(f"✅ 已导入 {len(property_ids)} 条 properties 记录")
        
        # 导入 sales
        print(f"\n📥 导入 {len(sales)} 条 sales 记录...")
        
        # 组合 property_id 和 sales 数据
        sales_with_property_id = [
            (property_ids[i], sales[i][0], sales[i][1])
            for i in range(len(sales))
        ]
        
        execute_values(
            cur,
            """
            INSERT INTO sales (property_id, sold_price, sold_date)
            VALUES %s
            """,
            sales_with_property_id
        )
        print(f"✅ 已导入 {len(sales)} 条 sales 记录")
        
        # 提交事务
        conn.commit()
        print("\n✅ 所有数据已成功导入！")
        
        # 验证数据
        print("\n📊 验证数据...")
        cur.execute("SELECT COUNT(*) FROM properties;")
        prop_count = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM sales;")
        sale_count = cur.fetchone()[0]
        
        print(f"  - properties 表: {prop_count} 条")
        print(f"  - sales 表: {sale_count} 条")
        
        # 验证 bedrooms 不为 0 的记录数
        cur.execute("SELECT COUNT(*) FROM properties WHERE bedrooms > 0;")
        beds_count = cur.fetchone()[0]
        print(f"  - bedrooms > 0 的记录: {beds_count} 条")
        
        # 按郊区统计
        cur.execute("""
            SELECT suburb, COUNT(*) as count
            FROM properties
            GROUP BY suburb
            ORDER BY count DESC;
        """)
        print("\n按郊区统计:")
        for row in cur.fetchall():
            print(f"  - {row[0]}: {row[1]} 条")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ 导入失败: {e}")
        import traceback
        traceback.print_exc()
    
    print("\n" + "="*60)


if __name__ == "__main__":
    import_data()
