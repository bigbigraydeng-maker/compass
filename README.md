# Compass - Brisbane Chinese Property Intelligence Platform

布里斯班华人房产数据平台 MVP 版本

## 📋 项目概述

Compass 是一个面向华人投资者的布里斯班房地产数据平台，提供真实的房产成交数据和分析功能。

### 🎯 MVP 功能

- ✅ 真实成交数据（155 条记录）
- ✅ 3 个重点郊区：Sunnybank、Eight Mile Plains、Calamvale
- ✅ RESTful API 接口
- ✅ 数据统计和分析
- ✅ 云端部署

## 🏗️ 技术栈

### 后端
- **FastAPI** - Python Web 框架
- **PostgreSQL** - 数据库（Supabase）
- **pg8000** - PostgreSQL 驱动
- **Pydantic** - 数据验证

### 数据抓取
- **Playwright** - 网页抓取
- **Python** - 数据处理

### 部署
- **Render** - 后端托管
- **Supabase** - 数据库托管
- **GitHub** - 代码仓库

## 📊 数据统计

- **总记录数**: 155 条
- **覆盖郊区**: 3 个
- **价格范围**: $638,888 - $2,880,800
- **平均价格**: $1,365,325

### 各郊区数据分布

| 郊区 | 记录数 | 中位价 |
|------|--------|--------|
| Sunnybank | 50 | ~$1,365,000 |
| Eight Mile Plains | 53 | ~$1,500,000 |
| Calamvale | 52 | ~$1,270,000 |

## 🚀 快速开始

### 本地开发

1. **克隆仓库**
```bash
git clone https://github.com/YOUR_USERNAME/compass.git
cd compass
```

2. **安装依赖**
```bash
cd backend
pip install -r requirements.txt
```

3. **配置环境变量**
```bash
cp .env.example .env
# 编辑 .env 文件，填入数据库连接信息
```

4. **启动服务器**
```bash
uvicorn main:app --reload
```

5. **访问 API 文档**
```
http://localhost:8000/docs
```

### 部署到 Render

详细部署步骤请查看 [DEPLOYMENT.md](./DEPLOYMENT.md)

## 📡 API 端点

### 1. 根路径
```
GET /
```
返回 API 基本信息

### 2. 首页数据
```
GET /api/home
```
返回最新成交记录和郊区统计

### 3. 成交列表
```
GET /api/sales?suburb=Sunnybank&page=1&page_size=20
```
返回分页的成交记录

### 4. 郊区详情
```
GET /api/suburb/{suburb_name}
```
返回指定郊区的统计和成交记录

## 📁 项目结构

```
Compass/
├── backend/                 # FastAPI 后端
│   ├── main.py             # 主应用
│   ├── config.py           # 配置
│   ├── database.py         # 数据库连接
│   ├── models.py           # 数据模型
│   └── requirements.txt    # 依赖
├── database/               # 数据库相关
│   ├── schema_mvp.sql      # 数据库 schema
│   └── import_all.sql      # 数据导入脚本
├── scraper/                # 数据抓取
│   ├── scrape_sales.py     # 抓取脚本
│   └── clean_data.py       # 数据清洗
├── data/                   # 数据文件
│   └── raw_sales.csv       # 原始数据
├── render.yaml             # Render 配置
├── .gitignore             # Git 忽略文件
├── README.md              # 项目说明
└── DEPLOYMENT.md          # 部署指南
```

## 🔧 开发指南

### 添加新的 API 端点

1. 在 `backend/models.py` 中定义数据模型
2. 在 `backend/main.py` 中添加路由函数
3. 使用 `execute_query()` 执行数据库查询

### 数据抓取

```bash
cd scraper
python scrape_sales.py
```

### 数据导入

```bash
# 使用 SQL 导入
cd database
# 在 Supabase SQL Editor 中执行 import_all.sql
```

## 📝 环境变量

| 变量名 | 说明 | 必需 |
|--------|------|------|
| `DATABASE_URL` | 数据库连接字符串 | ✅ |
| `APP_NAME` | 应用名称 | ❌ |
| `APP_VERSION` | 应用版本 | ❌ |
| `CORS_ORIGINS` | CORS 配置 | ❌ |

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 📞 联系方式

如有问题，请创建 GitHub Issue

---

**注意**: 这是一个 MVP 版本，后续会添加更多功能：
- 前端界面（Next.js）
- 用户认证
- 高级分析功能
- 数据可视化
- 微信分享功能
