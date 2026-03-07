# 数据采集与处理系统实施计划

## 1. 项目概述

本项目旨在构建一个完整的房地产数据采集、处理和存储系统，以支持 Compass 平台的数据分析和展示需求。系统将包含四条数据管线：Sales Pipeline、Land Pipeline、Spatial Pipeline 和 Market Pipeline，采用五层结构：Raw Data、Cleaning、Normalization、Warehouse 和 API。

## 2. 关键缺口解决方案

### 2.1 `sale_id` 的生成规则
- **方案**：使用 UUID v4 生成唯一 ID
- **理由**：源数据可能没有唯一标识符，UUID 可以确保全球唯一性，避免冲突
- **实现**：`import uuid; sale_id = str(uuid.uuid4())`

### 2.2 地址标准化的规范表
- **方案**：创建地址标准化映射表，包含常见缩写和格式规则
- **内容**：
  - 街道类型映射：St → Street, Ave → Avenue, Rd → Road 等
  - 单元类型映射：Unit → U, Apartment → Apt
  - 大小写规则：首字母大写，其余小写
  - 标点规则：统一使用空格分隔，移除多余标点
- **实现**：创建 `address_normalization.py` 模块

### 2.3 Geocoding 的数据源与配额
- **方案**：使用 Google Maps Geocoding API
- **配额**：利用 Google Cloud Platform 的免费额度（每月 $200）
- **失败重试与缓存**：
  - 失败重试：最多 3 次，每次间隔 2 秒
  - 缓存策略：使用 SQLite 本地缓存，避免重复请求
- **实现**：创建 `geocoding.py` 模块

### 2.4 数据质量规则
- **必填字段**：`address`, `suburb`, `sale_price`, `sale_date`
- **允许为空**：`bedrooms`, `bathrooms`, `land_size`, `latitude`, `longitude`
- **处理策略**：
  - 缺失必填字段：进入 `quarantine` 表
  - 部分字段缺失：保留记录，后续补充
- **实现**：在数据清洗阶段添加质量检查

### 2.5 更新策略
- **增量更新**：按 `sale_date` 进行月度增量更新
- **历史更正**：当源数据提供历史更正时，更新现有记录（保留变更历史）
- **实现**：创建 `update_strategy.py` 模块

### 2.6 表的唯一约束与冲突策略
- **唯一约束**：`address + sale_date` 组合
- **冲突策略**：
  - 完全匹配：更新现有记录
  - 部分匹配：保留多条记录（标记为同日多笔交易）
- **实现**：在数据库层面设置唯一索引，在应用层处理冲突

## 3. 数据库表结构设计

### 3.1 核心表：`sales`
```sql
CREATE TABLE sales (
    sale_id UUID PRIMARY KEY,
    address TEXT NOT NULL,
    suburb TEXT NOT NULL,
    postcode TEXT,
    sale_price NUMERIC NOT NULL,
    sale_date DATE NOT NULL,
    property_type TEXT,
    bedrooms INTEGER,
    bathrooms INTEGER,
    land_size NUMERIC,
    latitude NUMERIC,
    longitude NUMERIC,
    source TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(address, sale_date)
);

-- 索引
CREATE INDEX idx_sales_suburb ON sales(suburb);
CREATE INDEX idx_sales_sale_date ON sales(sale_date);
CREATE INDEX idx_sales_property_type ON sales(property_type);
```

### 3.2 派生表：`land_sales`
```sql
CREATE TABLE land_sales (
    land_sale_id UUID PRIMARY KEY,
    sale_id UUID REFERENCES sales(sale_id),
    address TEXT NOT NULL,
    suburb TEXT NOT NULL,
    sale_price NUMERIC NOT NULL,
    sale_date DATE NOT NULL,
    land_size NUMERIC,
    zoning TEXT,
    development_score NUMERIC,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_land_sales_suburb ON land_sales(suburb);
CREATE INDEX idx_land_sales_sale_date ON land_sales(sale_date);
```

### 3.3 支撑表：`address_normalization`
```sql
CREATE TABLE address_normalization (
    id SERIAL PRIMARY KEY,
    original TEXT NOT NULL,
    normalized TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_address_original ON address_normalization(original);
```

### 3.4 支撑表：`geocoding_cache`
```sql
CREATE TABLE geocoding_cache (
    id SERIAL PRIMARY KEY,
    address TEXT NOT NULL,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_geocoding_address ON geocoding_cache(address);
```

### 3.5 支撑表：`quarantine`
```sql
CREATE TABLE quarantine (
    id SERIAL PRIMARY KEY,
    raw_data JSONB NOT NULL,
    error_message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);
```

## 4. 数据处理流程

### 4.1 Sales Pipeline 流程
1. **数据获取**：从 QLD Government 下载月度 CSV 数据
2. **原始数据存储**：将原始数据存储到 `raw_sales` 表
3. **数据清洗**：
   - 移除重复记录
   - 处理缺失值
   - 标准化数据格式
4. **地址处理**：
   - 地址标准化
   - 地址拆分（生成 street_number, street_name, street_type）
   - 地理编码（生成 latitude, longitude）
5. **数据验证**：
   - 检查必填字段
   - 验证数据合理性
6. **数据入库**：将处理后的数据插入 `sales` 表
7. **土地数据派生**：根据规则从 `sales` 表派生 `land_sales` 表

### 4.2 Land Pipeline 流程
1. **数据识别**：从 `sales` 表识别土地交易
2. **数据处理**：
   - 提取相关字段
   - 计算开发潜力评分
3. **数据入库**：将处理后的数据插入 `land_sales` 表

## 5. 技术实现

### 5.1 核心模块
1. **`data_collector.py`**：负责从数据源获取数据
2. **`data_cleaner.py`**：负责数据清洗和标准化
3. **`address_processor.py`**：负责地址处理和地理编码
4. **`data_validator.py`**：负责数据验证
5. **`data_importer.py`**：负责数据入库
6. **`land_processor.py`**：负责土地数据处理
7. **`update_manager.py`**：负责数据更新管理

### 5.2 工具模块
1. **`config.py`**：配置管理
2. **`database.py`**：数据库连接管理
3. **`utils.py`**：通用工具函数
4. **`logger.py`**：日志管理

### 5.3 工作流模块
1. **`run_sales_pipeline.py`**：运行 Sales Pipeline
2. **`run_land_pipeline.py`**：运行 Land Pipeline
3. **`run_monthly_update.py`**：运行月度更新

## 6. 部署与运行

### 6.1 部署环境
- **操作系统**：Ubuntu 20.04
- **Python 版本**：3.9+
- **依赖项**：
  - `pandas`：数据处理
  - `psycopg2-binary`：PostgreSQL 连接
  - `googlemaps`：地理编码
  - `uuid`：生成唯一ID
  - `python-dotenv`：环境变量管理

### 6.2 运行计划
1. **初始化**：创建数据库表结构
2. **首次运行**：导入历史数据
3. **定期运行**：每月运行增量更新
4. **监控**：设置运行日志和错误通知

## 7. 质量保证

### 7.1 数据质量检查
- 完整性检查：确保必填字段完整
- 一致性检查：确保数据格式一致
- 准确性检查：验证地理编码结果
- 唯一性检查：确保没有重复记录

### 7.2 性能优化
- 数据库索引优化
- 批量处理数据
- 缓存地理编码结果
- 并行处理数据

## 8. 未来扩展

### 8.1 Spatial Pipeline
- 集成 QLD Cadastral Data
- 实现 parcel 边界匹配
- 添加 PostGIS 支持

### 8.2 Zoning 数据
- 集成 Brisbane City Plan 数据
- 实现 zoning 类型分析

### 8.3 聚合层
- 实现 `suburb_metrics` 表
- 实现 `market_stats` 表
- 支持实时数据聚合

## 9. 实施时间表

| 阶段 | 任务 | 预计时间 |
|------|------|----------|
| 阶段 1 | 环境搭建与配置 | 1 天 |
| 阶段 2 | 数据库表结构创建 | 1 天 |
| 阶段 3 | 核心模块开发 | 3 天 |
| 阶段 4 | 数据处理流程实现 | 2 天 |
| 阶段 5 | 首次数据导入 | 1 天 |
| 阶段 6 | 测试与优化 | 2 天 |
| 阶段 7 | 部署与运行 | 1 天 |

**总计**：约 11 天

## 10. 风险评估

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| 数据源不可用 | 数据更新中断 | 建立备用数据源 |
| 地理编码配额不足 | 地理编码失败 | 实现缓存和批量处理 |
| 数据质量问题 | 分析结果不准确 | 建立严格的数据验证流程 |
| 数据库性能问题 | 系统响应缓慢 | 优化数据库索引和查询 |

## 11. 结论

本实施计划提供了一个完整的数据采集和处理系统架构，涵盖了从数据获取到最终存储的全过程。通过遵循本计划，可以构建一个可靠、高效的房地产数据系统，为 Compass 平台提供准确、及时的数据分析支持。