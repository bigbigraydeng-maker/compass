# Compass MVP 后端 API

布里斯班华人房产数据平台后端 API

## 📁 项目结构

```
backend/
├── main.py              # FastAPI 主应用
├── config.py            # 配置管理
├── database.py          # 数据库连接
├── models.py            # 数据模型
├── requirements.txt      # Python 依赖
├── .env.example         # 环境变量示例
└── start.py            # 启动脚本
```

## 🚀 快速开始

### 1. 安装依赖

```bash
cd backend
pip install -r requirements.txt
```

### 2. 配置环境变量

```bash
cp .env.example .env
```

编辑 `.env` 文件，修改数据库连接信息：

```
DATABASE_URL=postgresql://user:password@host:port/database
```

### 3. 启动服务器

```bash
python start.py
```

或者直接使用 uvicorn：

```bash
uvicorn main:app --reload
```

服务器将在 `http://localhost:8000` 启动

## 📚 API 文档

启动服务器后，访问以下地址查看 API 文档：

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## 🔌 API 端点

### 1. 根路径
```
GET /
```
返回 API 基本信息

### 2. 首页数据
```
GET /api/home
```
返回：
- 最新10条成交记录
- 3个郊区的统计信息（中位价、成交数）

### 3. 成交列表
```
GET /api/sales?suburb=Sunnybank&page=1&page_size=20
```
参数：
- `suburb`: 郊区名称（可选）
- `page`: 页码（默认1）
- `page_size`: 每页数量（默认20）

返回分页的成交记录

### 4. 郊区详情
```
GET /api/suburb/{suburb_name}
```
返回指定郊区的：
- 中位价
- 总成交数
- 最近10条成交记录

## 🧪 测试 API

使用 curl 测试：

```bash
# 测试根路径
curl http://localhost:8000/

# 获取首页数据
curl http://localhost:8000/api/home

# 获取成交列表
curl http://localhost:8000/api/sales?suburb=Sunnybank

# 获取郊区详情
curl http://localhost:8000/api/suburb/Sunnybank
```

## 📊 数据库要求

确保数据库已创建并包含以下表：

- `properties`: 房产信息表
- `sales`: 成交记录表

表结构请参考 `database/schema_mvp.sql`

## 🔧 开发说明

### 添加新端点

1. 在 `models.py` 中定义数据模型
2. 在 `main.py` 中添加路由函数
3. 使用 `execute_query()` 执行数据库查询

### 数据库查询

```python
from database import execute_query

# 执行查询
results = execute_query("SELECT * FROM properties WHERE suburb = %s", ('Sunnybank',))

# 执行插入/更新
execute_query("INSERT INTO properties (...) VALUES (...)", (...))
```

## 🚢 部署

### Render 部署

1. 创建 `Procfile`:
```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

2. 推送代码到 GitHub

3. 在 Render 中连接仓库并部署

### Railway 部署

1. 安装 Railway CLI
2. 登录并创建项目
3. 部署应用

## 📝 注意事项

- 生产环境请修改 `.env` 中的数据库密码
- 配置 CORS 允许的域名
- 使用 HTTPS 保护 API 端点
- 添加适当的错误处理和日志记录

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License
