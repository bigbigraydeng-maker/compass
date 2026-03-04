-- Compass MVP 数据库 schema
-- 创建 properties 表
CREATE TABLE IF NOT EXISTS properties (
    id SERIAL PRIMARY KEY,
    address TEXT NOT NULL,
    suburb TEXT NOT NULL,
    property_type TEXT,
    land_size INTEGER,
    building_size INTEGER DEFAULT 0,
    bedrooms INTEGER DEFAULT 0,
    bathrooms INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建 sales 表
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    property_id INTEGER REFERENCES properties(id),
    sold_price INTEGER NOT NULL,
    sold_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_properties_suburb ON properties(suburb);
CREATE INDEX IF NOT EXISTS idx_sales_property_id ON sales(property_id);
CREATE INDEX IF NOT EXISTS idx_sales_sold_price ON sales(sold_price);
CREATE INDEX IF NOT EXISTS idx_sales_sold_date ON sales(sold_date);

-- 创建导入函数
CREATE OR REPLACE FUNCTION import_sales_data()
RETURNS INTEGER AS $$
DECLARE
    total_count INTEGER := 0;
BEGIN
    -- 导入数据逻辑将在 import_from_csv.sql 中实现
    RETURN total_count;
END;
$$ LANGUAGE plpgsql;
