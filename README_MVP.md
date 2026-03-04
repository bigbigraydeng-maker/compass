# Compass MVP - 布里斯班华人房地产数据平台

## 🎯 项目目标

14 天内上线可访问版本，严格遵守 MVP 原则。

## ✅ 上线标准

1. 可以访问首页
2. 可以查看 3 个 Suburb 的真实成交数据
3. 可以查看成交列表
4. 可以分享页面链接
5. 无需登录
6. 无需会员系统
7. 无需 AI 估价

## 🏗 技术架构

### 数据库
- **平台**：Supabase (PostgreSQL)
- **表结构**：2 张表（properties, sales）
- **文件**：[database/schema_mvp.sql](database/schema_mvp.sql)

### 后端
- **框架**：FastAPI
- **API**：3 个端点
  - GET /api/home - 首页数据
  - GET /api/sales - 成交列表
  - GET /api/suburb/{name} - Suburb 详情
- **文件**：[backend/main.py](backend/main.py)

### 前端
- **框架**：Next.js + Tailwind CSS
- **页面**：3 个页面
  - 首页 - 展示 3 个 Suburb 和最新成交
  - 成交列表页 - 表格展示所有成交
  - Suburb 页面 - 显示中位价和最近成交
- **文件**：[frontend/app/page.tsx](frontend/app/page.tsx)

## 📅 14 天执行计划

详细计划请查看：[docs/14_day_plan.md](docs/14_day_plan.md)

### 第 1-3 天：数据准备
- 抓取 200 条真实成交数据
- 创建数据库表
- 导入数据

### 第 4-6 天：后端开发
- 实现 FastAPI 后端
- 创建 3 个 API 端点
- 测试 API 功能

### 第 7-11 天：前端开发
- 创建 Next.js 项目
- 实现 3 个页面
- 样式美化

### 第 12-13 天：部署
- 部署数据库到 Supabase
- 部署后端到 Render
- 部署前端到 Vercel

### 第 14 天：测试上线
- 全面测试
- 微信分享测试
- 正式上线

## 🚀 快速开始

### 1. 数据库设置
```bash
# 在 Supabase 中执行
psql -f database/schema_mvp.sql
psql -f database/sample_data.sql
```

### 2. 后端启动
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
```

### 3. 前端启动
```bash
cd frontend
npm install
npm run dev
```

## 📊 数据范围

聚焦 3 个华人重点 Suburb：
- Sunnybank
- Eight Mile Plains
- Calamvale

## 🎨 UI 设计原则

- 中文为主
- 数据突出
- 简洁金融风
- 不做复杂动画
- 移动端优先

## 🚫 严格禁止

- AI 估价
- 会员系统
- 登录注册
- 高级分析
- 自动化爬虫系统优化
- 复杂架构设计

## 📖 文档

- [数据库 Schema](database/schema_mvp.sql)
- [示例数据](database/sample_data.sql)
- [后端代码](backend/main.py)
- [前端代码](frontend/app/page.tsx)
- [部署指南](docs/deployment_guide.md)
- [14 天计划](docs/14_day_plan.md)

## 📞 支持

如有问题，请查看文档或联系开发团队。

## 📄 许可证

MIT License
