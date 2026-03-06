-- ============================================
-- Compass 数据导入脚本
-- 包含 7 个 suburbs，共 2,417 条成交记录
-- ============================================

-- 第一步：清空旧数据
DELETE FROM sales;
DELETE FROM properties;
ALTER SEQUENCE IF EXISTS properties_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS sales_id_seq RESTART WITH 1;

-- 第二步：导入 properties 数据
-- (请从 import_new_data.sql 文件复制 properties 插入语句)

-- 第三步：导入 sales 数据
-- (请从 import_new_data.sql 文件复制 sales 插入语句)

-- ============================================
-- 数据摘要：
-- - Ascot: 365条
-- - Calamvale: 366条
-- - Eight Mile Plains: 371条
-- - Hamilton: 357条
-- - Mansfield: 227条
-- - Rochedale: 368条
-- - Sunnybank: 363条
-- - 总计: 2,417条
-- ============================================
