# Compass MVP 快速启动指南

## 🚀 立即开始（30 分钟内运行）

### 第一步：数据库（10 分钟）

#### 选项 A：使用 Supabase（推荐）
1. 访问 https://supabase.com
2. 创建新项目
3. 在 SQL Editor 中执行：
   ```sql
   -- 复制 database/schema_mvp.sql 的内容
   -- 复制 database/sample_data.sql 的内容
   ```
4. 获取连接字符串：Settings → Database → Connection string

#### 选项 B：使用本地 PostgreSQL
```bash
# 创建数据库
createdb compass

# 执行 schema
psql -d compass -f database/schema_mvp.sql

# 导入示例数据
psql -d compass -f database/sample_data.sql
```

---

### 第二步：后端（10 分钟）

```bash
# 进入后端目录
cd backend

# 创建虚拟环境
python -m venv venv

# 激活虚拟环境
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 创建 .env 文件
echo DATABASE_URL=postgresql://postgres:password@localhost:5432/compass > .env

# 启动后端
uvicorn main:app --reload
```

**测试 API**：
- 访问 http://localhost:8000
- 访问 http://localhost:8000/api/home
- 访问 http://localhost:8000/api/sales

---

### 第三步：前端（10 分钟）

```bash
# 打开新终端，进入前端目录
cd frontend

# 安装依赖
npm install

# 启动前端
npm run dev
```

**访问网站**：
- 打开浏览器访问 http://localhost:3000

---

## ✅ 验证清单

- [ ] 后端 API 可以访问
- [ ] 首页可以显示
- [ ] 成交列表页面可以访问
- [ ] Suburb 页面可以访问
- [ ] 数据正确显示

---

## 🐛 常见问题

### Q1: 后端无法连接数据库
```bash
# 检查 .env 文件中的 DATABASE_URL
# 确保格式正确：
# postgresql://用户名:密码@主机:端口/数据库名
```

### Q2: 前端无法访问后端 API
```bash
# 检查后端是否正在运行
# 确认后端 URL 正确（默认 http://localhost:8000）
```

### Q3: 数据不显示
```bash
# 检查数据库是否有数据
psql -d compass -c "SELECT COUNT(*) FROM sales;"

# 如果没有数据，重新导入
psql -d compass -f database/sample_data.sql
```

---

## 📱 测试移动端

1. 确保电脑和手机在同一 WiFi 网络
2. 找到电脑的 IP 地址：
   ```bash
   # Windows
   ipconfig
   
   # Mac/Linux
   ifconfig
   ```
3. 在手机浏览器中访问：
   ```
   http://你的IP地址:3000
   ```

---

## 🎯 下一步

完成本地测试后：
1. 查看 [部署指南](docs/deployment_guide.md)
2. 按照 [14 天计划](docs/14_day_plan.md) 继续开发
3. 准备真实数据

---

## 💡 提示

- 优先完成核心功能
- 不要过度优化
- 保持简单
- 快速迭代

---

## 📞 需要帮助？

- 查看 [README_MVP.md](README_MVP.md)
- 查看 [部署指南](docs/deployment_guide.md)
- 查看 [14 天计划](docs/14_day_plan.md)
