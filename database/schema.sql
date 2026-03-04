# Compass 数据库 Schema (MVP版本)

## 1. properties 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 房产ID |
| address | VARCHAR(255) | NOT NULL | 地址 |
| suburb | VARCHAR(100) | NOT NULL | 郊区 |
| postcode | INTEGER | NOT NULL | 邮编 |
| property_type | VARCHAR(20) | NOT NULL | 房产类型（house/unit/townhouse） |
| land_size | FLOAT | | 土地面积（平方米） |
| building_size | FLOAT | | 建筑面积（平方米） |
| bedrooms | INTEGER | | 卧室数量 |
| bathrooms | INTEGER | | 浴室数量 |
| car_spaces | INTEGER | | 停车位数量 |
| year_built | INTEGER | | 建成年份 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

## 2. listings 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 挂牌ID |
| property_id | INTEGER | REFERENCES properties(id) | 房产ID |
| listing_price | FLOAT | NOT NULL | 挂牌价格 |
| listing_date | DATE | NOT NULL | 挂牌日期 |
| status | VARCHAR(20) | NOT NULL | 状态（active/sold/withdrawn） |
| source | VARCHAR(50) | NOT NULL | 数据来源（realestate/domain/agent） |
| days_on_market | INTEGER | | 挂牌天数 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 更新时间 |

## 3. sales 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 成交ID |
| property_id | INTEGER | REFERENCES properties(id) | 房产ID |
| sold_price | FLOAT | NOT NULL | 成交价格 |
| sold_date | DATE | NOT NULL | 成交日期 |
| days_on_market | INTEGER | | 成交天数 |
| agent_name | VARCHAR(100) | | 中介名称 |
| source | VARCHAR(50) | NOT NULL | 数据来源 |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

## 4. suburb_stats 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 统计ID |
| suburb | VARCHAR(100) | NOT NULL UNIQUE | 郊区名称 |
| median_price | FLOAT | | 中位价 |
| avg_days_on_market | INTEGER | | 平均成交天数 |
| clearance_rate | FLOAT | | 清盘率（%） |
| monthly_growth_rate | FLOAT | | 月增长率（%） |
| heat_score | INTEGER | | 热度评分（1-10） |
| total_sales | INTEGER | DEFAULT 0 | 总成交量 |
| last_updated | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 最后更新时间 |

## 5. users 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 用户ID |
| email | VARCHAR(255) | NOT NULL UNIQUE | 邮箱 |
| password_hash | VARCHAR(255) | NOT NULL | 密码哈希 |
| name | VARCHAR(100) | | 用户姓名 |
| membership_level | VARCHAR(20) | DEFAULT 'free' | 会员等级（free/pro/premium） |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |
| last_login | TIMESTAMP | | 最后登录时间 |

## 6. subscriptions 表

| 字段名 | 数据类型 | 约束 | 描述 |
|-------|---------|------|------|
| id | SERIAL | PRIMARY KEY | 订阅ID |
| user_id | INTEGER | REFERENCES users(id) | 用户ID |
| plan | VARCHAR(20) | NOT NULL | 订阅计划（free/pro/premium） |
| start_date | DATE | NOT NULL | 开始日期 |
| expiry_date | DATE | NOT NULL | 到期日期 |
| status | VARCHAR(20) | DEFAULT 'active' | 状态（active/cancelled/expired） |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | 创建时间 |

## 索引设计

### properties 表
```sql
CREATE INDEX idx_properties_suburb ON properties(suburb);
CREATE INDEX idx_properties_postcode ON properties(postcode);
CREATE INDEX idx_properties_property_type ON properties(property_type);
CREATE INDEX idx_properties_bedrooms ON properties(bedrooms);
CREATE INDEX idx_properties_bathrooms ON properties(bathrooms);
```

### listings 表
```sql
CREATE INDEX idx_listings_property_id ON listings(property_id);
CREATE INDEX idx_listings_status ON listings(status);
CREATE INDEX idx_listings_listing_date ON listings(listing_date);
CREATE INDEX idx_listings_source ON listings(source);
CREATE INDEX idx_listings_suburb ON listings(suburb);
```

### sales 表
```sql
CREATE INDEX idx_sales_property_id ON sales(property_id);
CREATE INDEX idx_sales_sold_date ON sales(sold_date);
CREATE INDEX idx_sales_suburb ON sales(suburb);
CREATE INDEX idx_sales_source ON sales(source);
```

### suburb_stats 表
```sql
CREATE INDEX idx_suburb_stats_heat_score ON suburb_stats(heat_score);
CREATE INDEX idx_suburb_stats_median_price ON suburb_stats(median_price);
```

### users 表
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_membership_level ON users(membership_level);
```

### subscriptions 表
```sql
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_expiry_date ON subscriptions(expiry_date);
```

## 数据初始化

### 初始化 Suburb 数据
```sql
INSERT INTO suburb_stats (suburb, median_price, avg_days_on_market, clearance_rate, monthly_growth_rate, heat_score) VALUES
('Sunnybank', 950000, 35, 85, 5.2, 8),
('Eight Mile Plains', 880000, 38, 82, 4.8, 7),
('Calamvale', 820000, 40, 80, 4.5, 6);
```

## 数据关系图

```mermaid
erDiagram
    properties ||--o{ listings : "has"
    properties ||--o{ sales : "has"
    users ||--o{ subscriptions : "has"
    suburb_stats ||--o{ properties : "contains"
    suburb_stats ||--o{ sales : "contains"
```

## 性能优化建议

1. **分区策略**：对 sales 表按月份分区，提高查询性能
2. **缓存层**：对 suburb_stats 表使用 Redis 缓存，减少数据库查询
3. **定期维护**：每周执行 VACUUM 和 ANALYZE，保持数据库性能
4. **连接池**：使用连接池管理数据库连接，提高并发性能
5. **读写分离**：考虑使用主从复制，分离读写操作

## 数据备份策略

1. **每日备份**：每天凌晨 2 点执行全量备份
2. **增量备份**：每小时执行增量备份
3. **异地备份**：将备份文件同步到异地存储
4. **恢复测试**：每周进行一次恢复测试，确保备份可用性
