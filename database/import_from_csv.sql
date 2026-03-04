-- Compass MVP 数据导入脚本
-- 从 data/raw_sales.csv 导入数据到数据库

-- 开始事务
BEGIN;

-- 创建临时表存储 CSV 数据
CREATE TEMP TABLE temp_sales (
    address TEXT,
    suburb TEXT,
    property_type TEXT,
    bedrooms INTEGER,
    bathrooms INTEGER,
    land_size INTEGER,
    sold_price INTEGER,
    sold_date DATE
);

-- 导入 CSV 数据
COPY temp_sales(address, suburb, property_type, bedrooms, bathrooms, land_size, sold_price, sold_date)
FROM 'c:\Users\Zhong\Documents\trae_projects\Compass\data\raw_sales.csv'
DELIMITER ','
CSV HEADER;

-- 插入数据到 properties 表
INSERT INTO properties(address, suburb, property_type, land_size, bedrooms, bathrooms)
SELECT DISTINCT address, suburb, property_type, land_size, bedrooms, bathrooms
FROM temp_sales
ON CONFLICT (address, suburb) DO NOTHING;

-- 插入数据到 sales 表
INSERT INTO sales(property_id, sold_price, sold_date)
SELECT p.id, t.sold_price, t.sold_date
FROM temp_sales t
JOIN properties p ON t.address = p.address AND t.suburb = p.suburb
ON CONFLICT DO NOTHING;

-- 清理临时表
DROP TABLE temp_sales;

-- 提交事务
COMMIT;

-- 查看导入结果
SELECT 
    (SELECT COUNT(*) FROM properties) AS total_properties,
    (SELECT COUNT(*) FROM sales) AS total_sales;
