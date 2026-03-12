# Compass - 布里斯班华人房产智能平台

> aucompass.com.au | 数据驱动的房产投资决策工具

## 平台功能

### 核心模块
- **AI 房产分析** — Amanda 多维度投资分析（价格走势、学区、治安、交通、开发潜力）
- **Suburb 详情** — 17 个布里斯班核心区域全景数据（Compass Score、租赁回报、华人宜居指数）
- **校区找房** — QLD 学校搜索 + 学区范围 + 在售房源联动
- **首次置业** — 首置资格速查、预算计算、印花税/月供工具
- **天机堂** — 胡师傅 AI 风水分析（地势、朝向、环境、道路）
- **DevIntel** — 开发情报：DA 审批、规划变更、市场新闻
- **海外购房** — 海外买家流程指南

### 数据维度（Suburb 详情页）
| 维度 | 数据源 |
|------|--------|
| 中位价 + 成交走势 | Supabase sales 表 |
| Compass Score（6维评分） | 综合算法 |
| 租赁回报（House/Unit） | CoreLogic |
| 华人宜居指数 | POI + 治安 + 交通 |
| 学区覆盖 | QLD 学校数据 |
| 土地分区 | Brisbane City Plan 2014 |
| 在售土地 + 在售房源 | DB listings + Domain API |
| 洪水风险 | BCC Flood Data |
| 开发情报 | DevIntel 爬虫 |

## 技术架构

### 后端
- **FastAPI** — Python Web 框架（同步 + ThreadPoolExecutor 并行查询）
- **PostgreSQL** — Supabase 托管，psycopg2 连接池（10 连接）
- **OpenAI / Moonshot** — 双 AI 引擎（GPT-4o-mini 主力，Kimi 2.5 备用）
- **Domain API** — 房源数据（OAuth2 + 30 分钟缓存）
- **Google Maps API** — 地理编码 + POI + 海拔

### 前端
- **Next.js 16** — App Router + TypeScript
- **Tailwind CSS** — 响应式 UI
- **Recharts** — 数据可视化图表
- **React Lazy/Suspense** — 首屏性能优化

### 部署
- **Render** — 前后端托管
- **Supabase** — PostgreSQL 数据库
- **GitHub** — 代码仓库 + CI/CD

## 项目结构

```
Compass/
├── backend/
│   ├── main.py                 # FastAPI 主应用（47+ 端点）
│   ├── database.py             # 连接池 + 查询封装
│   ├── models.py               # Pydantic 数据模型
│   ├── domain_api.py           # Domain.com.au API 客户端
│   ├── suburbs_config.py       # 17 区域配置（坐标/邮编/slug）
│   ├── devintel/               # 开发情报模块（RAG + 爬虫）
│   ├── data/                   # JSON 数据文件
│   ├── requirements.txt
│   └── .env.example
├── frontend/
│   ├── app/
│   │   ├── page.tsx            # 首页
│   │   ├── components/         # 共享组件
│   │   ├── suburb/[suburb]/    # Suburb 详情页
│   │   ├── school-search/      # 校区找房
│   │   ├── first-home/         # 首次置业
│   │   ├── feng-shui/          # 天机堂
│   │   ├── devintel/           # DevIntel
│   │   ├── overseas-buyer/     # 海外购房
│   │   └── lib/                # 工具函数
│   ├── next.config.ts
│   ├── tailwind.config.ts
│   └── package.json
├── render.yaml                 # Render 部署配置
└── README.md
```

## 快速开始

### 1. 克隆 & 安装

```bash
git clone https://github.com/bigbigraydeng-maker/compass.git
cd compass

# 后端
cd backend
pip install -r requirements.txt

# 前端
cd ../frontend
npm install
```

### 2. 配置环境变量

```bash
cp backend/.env.example backend/.env
# 编辑 .env 填入：
```

| 变量 | 说明 | 必需 |
|------|------|------|
| `DATABASE_URL` | Supabase PostgreSQL 连接串 | ✅ |
| `OPENAI_API_KEY` | OpenAI API Key（AI 分析） | ✅ |
| `GOOGLE_MAPS_API_KEY` | Google Maps（风水/POI） | ✅ |
| `MOONSHOT_API_KEY` | Moonshot Kimi（备用 AI） | ❌ |
| `DOMAIN_API_CLIENT_ID` | Domain.com.au API | ❌ |
| `DOMAIN_API_CLIENT_SECRET` | Domain.com.au API | ❌ |

### 3. 启动开发服务器

```bash
# 后端 (http://localhost:8000/docs)
cd backend && uvicorn main:app --reload

# 前端 (http://localhost:3000)
cd frontend && npm run dev
```

## 主要 API 端点

| 端点 | 说明 |
|------|------|
| `GET /api/home` | 首页数据 |
| `GET /api/suburb/{name}/all` | Suburb 全量数据（并行聚合） |
| `GET /api/domain/listings?suburb=X` | Domain 在售房源 |
| `POST /api/analyze/stream` | AI 投资分析（流式） |
| `POST /api/fengshui/analyze` | 风水分析（流式） |
| `GET /api/schools` | QLD 学校列表 |
| `GET /api/rankings` | Suburb 排名 |
| `GET /api/news` | 房产新闻 |
| `GET /api/devintel/*` | 开发情报系列 |

## 覆盖区域（17 个 Suburb）

Sunnybank · Eight Mile Plains · Calamvale · Rochedale · Mansfield · Ascot · Hamilton · Runcorn · Wishart · Upper Mount Gravatt · Macgregor · Robertson · Stretton · Kuraby · Coopers Plains · Algester · Parkinson

---

MIT License | Built with Claude Code
