-- 清空现有数据
TRUNCATE TABLE sales CASCADE;
TRUNCATE TABLE properties CASCADE;

-- 从 CSV 导入数据
-- 注意：需要在 Supabase SQL Editor 中执行，或者使用 psql 命令

-- 方法 1: 使用 Supabase Dashboard 的表编辑器导入 CSV
-- 1. 打开 Supabase Dashboard
-- 2. 选择你的项目
-- 3. 点击 Table Editor
-- 4. 选择 properties 表
-- 5. 点击 "Import data from CSV"
-- 6. 选择 data/raw_sales_new.csv 文件
-- 7. 映射字段

-- 方法 2: 使用 psql 命令（如果本地安装了 PostgreSQL）
-- psql -h db.evzkrexygwdnoqhyjylf.supabase.co -U postgres -d postgres -c "\COPY properties(address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces) FROM 'data/raw_sales_new.csv' WITH (FORMAT csv, HEADER true);"

-- 方法 3: 使用 Python 脚本导入（推荐）
-- 见下面的 Python 代码
