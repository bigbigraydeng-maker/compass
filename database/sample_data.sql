-- Compass MVP 示例数据
-- 用于测试

-- 插入 properties 示例数据
INSERT INTO properties (address, suburb, property_type, land_size, building_size, bedrooms, bathrooms) VALUES
('123 Main Street', 'Sunnybank', 'house', 500, 200, 3, 2),
('456 Oak Avenue', 'Sunnybank', 'house', 600, 250, 4, 2),
('789 Pine Road', 'Sunnybank', 'unit', 0, 120, 2, 1),
('321 Elm Street', 'Eight Mile Plains', 'house', 550, 220, 3, 2),
('654 Maple Drive', 'Eight Mile Plains', 'house', 700, 280, 4, 3),
('987 Cedar Lane', 'Eight Mile Plains', 'townhouse', 300, 180, 3, 2),
('159 Birch Court', 'Calamvale', 'house', 450, 190, 3, 2),
('753 Willow Way', 'Calamvale', 'house', 520, 210, 3, 2),
('951 Spruce Street', 'Calamvale', 'unit', 0, 100, 1, 1);

-- 插入 sales 示例数据
INSERT INTO sales (property_id, sold_price, sold_date) VALUES
(1, 950000, '2026-02-15'),
(2, 1100000, '2026-02-20'),
(3, 550000, '2026-02-18'),
(4, 880000, '2026-02-22'),
(5, 1050000, '2026-02-25'),
(6, 720000, '2026-02-28'),
(7, 820000, '2026-03-01'),
(8, 890000, '2026-03-02'),
(9, 480000, '2026-03-03');
