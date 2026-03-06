import os
from config import settings
from database import execute_query

# 设置环境变量
os.environ['DATABASE_URL'] = settings.DATABASE_URL

try:
    # 创建 schools 表
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS schools (
        id SERIAL PRIMARY KEY,
        name TEXT,
        school_type TEXT,  -- primary / secondary
        suburb TEXT,
        naplan_percentile INT,  -- 全国百分位排名
        catchment_suburbs TEXT[]  -- 覆盖的suburb列表
    );
    """
    result = execute_query(create_table_sql)
    print(f'Create table result: {result}')
    
    # 插入数据
    insert_data_sql = """
    INSERT INTO schools (id, name, school_type, suburb, naplan_percentile, catchment_suburbs) VALUES
    (1, 'Sunnybank State School', 'primary', 'Sunnybank', 72, ARRAY['Sunnybank']),
    (2, 'Sunnybank Hills State School', 'primary', 'Sunnybank Hills', 68, ARRAY['Sunnybank Hills']),
    (3, 'Macgregor State School', 'primary', 'Macgregor', 81, ARRAY['Macgregor', 'Eight Mile Plains']),
    (4, 'Calamvale Community College', 'secondary', 'Calamvale', 65, ARRAY['Calamvale', 'Algester']),
    (5, 'Sunnybank State High School', 'secondary', 'Sunnybank', 70, ARRAY['Sunnybank', 'Sunnybank Hills'])
    ON CONFLICT (id) DO NOTHING;
    """
    result = execute_query(insert_data_sql)
    print(f'Insert data result: {result}')
    
    # 验证数据
    verify_sql = "SELECT * FROM schools LIMIT 5;"
    schools = execute_query(verify_sql)
    print(f'Verified schools: {len(schools)}')
    for school in schools:
        print(f"  - {school['name']} ({school['school_type']})")
    
    print('Schools table created and data inserted successfully!')
    
except Exception as e:
    print(f'Error: {e}')