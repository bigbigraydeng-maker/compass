-- 创建POI数据表
CREATE TABLE IF NOT EXISTS poi_data (
  id SERIAL PRIMARY KEY,
  suburb VARCHAR(100),
  category VARCHAR(50),    -- 'chinese_restaurant', 'asian_grocery' 等
  name VARCHAR(200),
  address TEXT,
  rating FLOAT,
  lat FLOAT,
  lng FLOAT
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_poi_suburb ON poi_data(suburb);
CREATE INDEX IF NOT EXISTS idx_poi_category ON poi_data(category);
