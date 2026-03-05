-- 修复 suburb 名称大小写不一致
UPDATE properties SET suburb = 'Ascot' WHERE suburb = 'ASCOT';
UPDATE properties SET suburb = 'Hamilton' WHERE suburb = 'HAMILTON';

-- 验证 bedrooms 字段
SELECT 
    suburb,
    COUNT(*) as total,
    SUM(CASE WHEN bedrooms > 0 THEN 1 ELSE 0 END) as has_bedrooms
FROM properties
GROUP BY suburb
ORDER BY suburb;
