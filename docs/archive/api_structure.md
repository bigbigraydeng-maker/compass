# Compass API 结构 (MVP版本)

## 基础信息

- **API版本**：v1
- **基础URL**：`https://api.compass.com.au/v1`
- **认证方式**：API Key + JWT Token
- **响应格式**：JSON
- **错误处理**：统一错误响应格式

## 认证API

### 1. 用户注册

**POST /auth/register**

**请求参数**：
```json
{
  "email": "user@example.com",
  "password": "your_password",
  "name": "张三"
}
```

**响应**：
```json
{
  "success": true,
  "user_id": 1,
  "message": "注册成功"
}
```

### 2. 用户登录

**POST /auth/login**

**请求参数**：
```json
{
  "email": "user@example.com",
  "password": "your_password"
}
```

**响应**：
```json
{
  "success": true,
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "张三",
    "membership_level": "free"
  }
}
```

### 3. 获取用户信息

**GET /auth/me**

**请求头**：
```
Authorization: Bearer jwt_token_here
```

**响应**：
```json
{
  "success": true,
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "张三",
    "membership_level": "pro",
    "subscription": {
      "plan": "pro",
      "expiry_date": "2026-04-04"
    }
  }
}
```

## 成交数据库API

### 1. 查询成交记录

**GET /sales**

**查询参数**：
- `suburb`：郊区名称（可选）
- `min_price`：最低价格（可选）
- `max_price`：最高价格（可选）
- `bedrooms`：卧室数量（可选）
- `bathrooms`：浴室数量（可选）
- `property_type`：房产类型（可选）
- `limit`：返回数量（默认20，最大100）
- `offset`：偏移量（默认0）

**响应**：
```json
{
  "success": true,
  "total": 150,
  "data": [
    {
      "id": 1,
      "address": "123 Main St, Sunnybank",
      "suburb": "Sunnybank",
      "postcode": 4109,
      "property_type": "house",
      "land_size": 500,
      "building_size": 200,
      "bedrooms": 3,
      "bathrooms": 2,
      "car_spaces": 2,
      "sold_price": 950000,
      "sold_date": "2026-02-15",
      "days_on_market": 30,
      "agent_name": "John Smith",
      "source": "realestate.com.au"
    }
  ]
}
```

### 2. 获取房产详情

**GET /sales/{id}**

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 1,
    "address": "123 Main St, Sunnybank",
    "suburb": "Sunnybank",
    "postcode": 4109,
    "property_type": "house",
    "land_size": 500,
    "building_size": 200,
    "bedrooms": 3,
    "bathrooms": 2,
    "car_spaces": 2,
    "year_built": 2005,
    "sold_price": 950000,
    "sold_date": "2026-02-15",
    "days_on_market": 30,
    "agent_name": "John Smith",
    "source": "realestate.com.au"
  }
}
```

### 3. 导出成交数据

**GET /sales/export**

**查询参数**：
- `format`：导出格式（csv/json/excel）
- `suburb`：郊区名称（可选）
- `start_date`：开始日期（可选）
- `end_date`：结束日期（可选）

**响应**：
- CSV/JSON/Excel文件下载

## Suburb分析API

### 1. 获取Suburb列表

**GET /suburbs**

**查询参数**：
- `limit`：返回数量（默认10，最大50）

**响应**：
```json
{
  "success": true,
  "total": 3,
  "data": [
    {
      "id": 1,
      "suburb": "Sunnybank",
      "postcode": 4109,
      "median_price": 950000,
      "avg_days_on_market": 35,
      "clearance_rate": 85,
      "monthly_growth_rate": 5.2,
      "heat_score": 8,
      "total_sales": 150
    },
    {
      "id": 2,
      "suburb": "Eight Mile Plains",
      "postcode": 4113,
      "median_price": 880000,
      "avg_days_on_market": 38,
      "clearance_rate": 82,
      "monthly_growth_rate": 4.8,
      "heat_score": 7,
      "total_sales": 120
    },
    {
      "id": 3,
      "suburb": "Calamvale",
      "postcode": 4116,
      "median_price": 820000,
      "avg_days_on_market": 40,
      "clearance_rate": 80,
      "monthly_growth_rate": 4.5,
      "heat_score": 6,
      "total_sales": 100
    }
  ]
}
```

### 2. 获取Suburb详情

**GET /suburbs/{id}**

**响应**：
```json
{
  "success": true,
  "data": {
    "id": 1,
    "suburb": "Sunnybank",
    "postcode": 4109,
    "median_price": 950000,
    "avg_days_on_market": 35,
    "clearance_rate": 85,
    "monthly_growth_rate": 5.2,
    "heat_score": 8,
    "total_sales": 150,
    "price_history": [
      {
        "month": "2026-02",
        "median_price": 950000,
        "sales_count": 25
      },
      {
        "month": "2026-01",
        "median_price": 930000,
        "sales_count": 22
      }
    ],
    "recent_sales": [
      {
        "address": "123 Main St, Sunnybank",
        "sold_price": 950000,
        "sold_date": "2026-02-15",
        "property_type": "house"
      }
    ],
    "chinese_summary": "Sunnybank作为布里斯班华人聚集的核心区域，房价持续稳定上涨。过去6个月中位价上涨5.2%，市场热度评分8分，属于高热度区域。该区域交通便利，华人配套完善，是华人投资的首选区域之一。"
  }
}
```

### 3. 获取Suburb对比

**POST /suburbs/compare**

**请求参数**：
```json
{
  "suburb_ids": [1, 2, 3]
}
```

**响应**：
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "suburb": "Sunnybank",
      "median_price": 950000,
      "avg_days_on_market": 35,
      "clearance_rate": 85,
      "monthly_growth_rate": 5.2,
      "heat_score": 8
    },
    {
      "id": 2,
      "suburb": "Eight Mile Plains",
      "median_price": 880000,
      "avg_days_on_market": 38,
      "clearance_rate": 82,
      "monthly_growth_rate": 4.8,
      "heat_score": 7
    },
    {
      "id": 3,
      "suburb": "Calamvale",
      "median_price": 820000,
      "avg_days_on_market": 40,
      "clearance_rate": 80,
      "monthly_growth_rate": 4.5,
      "heat_score": 6
    }
  ]
}
```

## AI估价API

### 1. 获取房产估价

**POST /valuation**

**请求参数**：
```json
{
  "suburb": "Sunnybank",
  "land_size": 500,
  "building_size": 200,
  "bedrooms": 3,
  "bathrooms": 2,
  "car_spaces": 2,
  "property_type": "house"
}
```

**响应**：
```json
{
  "success": true,
  "data": {
    "valuation_date": "2026-03-04",
    "estimates": {
      "low": 850000,
      "mid": 925000,
      "high": 1000000
    },
    "confidence": 0.85,
    "comparable_properties": [
      {
        "address": "123 Main St, Sunnybank",
        "sold_price": 950000,
        "sold_date": "2026-02-15",
        "land_size": 510,
        "building_size": 205,
        "similarity": 0.95
      },
      {
        "address": "125 Main St, Sunnybank",
        "sold_price": 900000,
        "sold_date": "2026-02-10",
        "land_size": 490,
        "building_size": 195,
        "similarity": 0.92
      }
    ],
    "chinese_commentary": "根据该房产的特征和近期市场数据，预计估值区间为$850,000 - $1,000,000。该区域房价呈上升趋势，过去6个月上涨5.2%，建议关注市场动态。"
  }
}
```

## 会员订阅API

### 1. 创建订阅

**POST /subscriptions**

**请求头**：
```
Authorization: Bearer jwt_token_here
```

**请求参数**：
```json
{
  "plan": "pro"
}
```

**响应**：
```json
{
  "success": true,
  "subscription": {
    "id": 1,
    "user_id": 1,
    "plan": "pro",
    "start_date": "2026-03-04",
    "expiry_date": "2026-04-04",
    "status": "active"
  }
}
```

### 2. 获取订阅信息

**GET /subscriptions**

**请求头**：
```
Authorization: Bearer jwt_token_here
```

**响应**：
```json
{
  "success": true,
  "subscription": {
    "id": 1,
    "plan": "pro",
    "start_date": "2026-03-04",
    "expiry_date": "2026-04-04",
    "status": "active",
    "features": [
      "查看所有 suburb",
      "查看完整成交数据库",
      "使用 AI 估价",
      "下载 PDF 分析报告"
    ]
  }
}
```

### 3. 取消订阅

**DELETE /subscriptions**

**请求头**：
```
Authorization: Bearer jwt_token_here
```

**响应**：
```json
{
  "success": true,
  "message": "订阅已取消"
}
```

## 首页数据API

### 1. 获取首页数据

**GET /home**

**响应**：
```json
{
  "success": true,
  "data": {
    "today_sales": {
      "count": 5,
      "total_value": 4500000,
      "avg_price": 900000
    },
    "hot_suburbs": [
      {
        "suburb": "Sunnybank",
        "heat_score": 8,
        "median_price": 950000,
        "monthly_growth_rate": 5.2
      }
    ],
    "rising_areas": [
      {
        "suburb": "Eight Mile Plains",
        "growth_rate": 4.8,
        "median_price": 880000
      }
    ],
    "top_sales": [
      {
        "address": "123 Main St, Sunnybank",
        "sold_price": 1200000,
        "sold_date": "2026-03-04"
      }
    ]
  }
}
```

## 错误响应格式

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMETER",
    "message": "Invalid parameter: suburb is required",
    "details": {
      "parameter": "suburb",
      "required": true
    }
  }
}
```

## 速率限制

- **免费用户**：60次/分钟
- **Pro用户**：600次/分钟
- **Premium用户**：6000次/分钟

## API状态码

| 状态码 | 描述 |
|-------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 资源不存在 |
| 429 | 请求过于频繁 |
| 500 | 服务器内部错误 |
| 503 | 服务不可用 |

## 会员权限控制

### Free用户
- 查看基础成交数据（限制20条）
- 查看1个suburb分析
- 无法使用AI估价
- 无法导出数据

### Pro用户
- 查看所有suburb
- 查看完整成交数据库
- 使用AI估价
- 下载PDF分析报告
- 导出数据（CSV/JSON）

### Premium用户
- 所有Pro用户权限
- 投资雷达功能
- 新成交预警
- Suburb热度趋势提前推送
- 每月市场总结报告
