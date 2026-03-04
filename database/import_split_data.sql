-- Compass MVP 数据导入脚本（完整版）
-- 使用 Supabase SQL Editor 执行此脚本
-- 需要先上传 data/properties.csv 和 data/sales_temp.csv 到 Supabase

-- 第一步：导入 properties 表
CREATE TEMP TABLE temp_properties (
    address TEXT,
    suburb TEXT,
    property_type TEXT,
    land_size INTEGER,
    bedrooms INTEGER,
    bathrooms INTEGER
);

-- 在 Supabase SQL Editor 中，使用以下方式导入 properties.csv
-- 方法1：使用 COPY 命令（需要文件在服务器上）
-- COPY temp_properties(address, suburb, property_type, land_size, bedrooms, bathrooms)
-- FROM 'properties.csv'
-- DELIMITER ','
-- CSV HEADER;

-- 方法2：直接在 SQL Editor 中粘贴 CSV 数据（推荐）
-- 将 properties.csv 的内容粘贴到 VALUES 子句中
-- 或者使用 Supabase 的 Table Editor 导入功能

-- 导入 properties 数据
INSERT INTO properties(address, suburb, property_type, land_size, bedrooms, bathrooms)
SELECT DISTINCT address, suburb, property_type, land_size, bedrooms, bathrooms
FROM temp_properties;

-- 第二步：导入 sales 表
CREATE TEMP TABLE temp_sales (
    address TEXT,
    suburb TEXT,
    sold_price INTEGER,
    sold_date DATE
);

-- 同样方式导入 sales_temp.csv
-- COPY temp_sales(address, suburb, sold_price, sold_date)
-- FROM 'sales_temp.csv'
-- DELIMITER ','
-- CSV HEADER;

-- 导入 sales 数据（通过 address 和 suburb 关联 property_id）
INSERT INTO sales(property_id, sold_price, sold_date)
SELECT p.id, t.sold_price, t.sold_date
FROM temp_sales t
JOIN properties p ON t.address = p.address AND t.suburb = p.suburb;

-- 清理临时表
DROP TABLE temp_properties;
DROP TABLE temp_sales;

-- 验证导入结果
SELECT 
    (SELECT COUNT(*) FROM properties) AS total_properties,
    (SELECT COUNT(*) FROM sales) AS total_sales;
