import psycopg2
import os

# 数据库连接信息
DATABASE_URL = "postgresql://postgres:Francis501!@db.evzkrexygwdnoqhyjylf.supabase.co:5432/postgres"

try:
    # 连接数据库
    conn = psycopg2.connect(DATABASE_URL)
    print("✅ 成功连接到数据库")
    
    # 检查 listings 表结构
    cur = conn.cursor()
    cur.execute("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'listings' 
        ORDER BY ordinal_position
    """)
    columns = cur.fetchall()
    print("\n📋 listings 表结构:")
    for col in columns:
        print(f"  {col[0]}: {col[1]}")
    
    # 检查当前数据
    cur.execute("SELECT property_type, COUNT(*) FROM listings GROUP BY property_type")
    data = cur.fetchall()
    print("\n📊 当前数据统计:")
    for row in data:
        print(f"  {row[0]}: {row[1]} 条")
    
    # 检查 vacant_land 数据
    cur.execute("SELECT * FROM listings WHERE property_type = 'vacant_land' LIMIT 5")
    land_data = cur.fetchall()
    print("\n🏞️ 土地数据示例:")
    if land_data:
        for row in land_data:
            print(f"  ID: {row[0]}, Address: {row[1]}, Suburb: {row[2]}")
    else:
        print("  暂无土地数据")
    
    # 关闭连接
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"❌ 数据库操作失败: {e}")
    import traceback
    traceback.print_exc()
