# Compass MVP 部署指南

## 📋 部署概述

本项目使用以下技术栈部署：
- **后端**: Render (FastAPI)
- **数据库**: Supabase (PostgreSQL)
- **前端**: Vercel (Next.js) - 待开发

---

## 🚀 后端部署到 Render

### 第一步：准备 GitHub 仓库

1. **初始化 Git 仓库**（如果还没有）
```bash
git init
git add .
git commit -m "Initial commit: Compass MVP backend"
```

2. **推送到 GitHub**
```bash
git remote add origin https://github.com/YOUR_USERNAME/compass.git
git branch -M main
git push -u origin main
```

### 第二步：在 Render 创建 Web Service

1. **登录 Render**
   - 访问 [render.com](https://render.com)
   - 使用 GitHub 账号登录

2. **创建新的 Web Service**
   - 点击 **New** → **Web Service**
   - 选择你的 GitHub 仓库
   - 选择 `backend` 目录作为根目录

3. **配置服务**
   - **Name**: `compass-backend`
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Instance Type**: Free

### 第三步：配置环境变量

在 Render 的 **Environment** 标签页添加以下环境变量：

```bash
DATABASE_URL=postgresql://postgres:Francis501!@db.evzkrexygwdnoqhyjylf.supabase.co:5432/postgres
APP_NAME=Compass MVP
APP_VERSION=1.0.0
CORS_ORIGINS=["*"]
```

**重要提示**：
- `DATABASE_URL` 使用你的 Supabase 连接字符串
- `CORS_ORIGINS` 在生产环境应该设置为你的前端域名

### 第四步：部署

1. 点击 **Create Web Service**
2. 等待构建和部署完成（约 3-5 分钟）
3. 部署成功后会获得一个 URL，例如：`https://compass-backend.onrender.com`

### 第五步：验证部署

访问以下 URL 验证部署成功：

1. **根路径**: `https://compass-backend.onrender.com/`
   ```json
   {
     "message": "Compass MVP API",
     "version": "1.0.0",
     "status": "running"
   }
   ```

2. **API 文档**: `https://compass-backend.onrender.com/docs`

3. **首页数据**: `https://compass-backend.onrender.com/api/home`

4. **成交列表**: `https://compass-backend.onrender.com/api/sales?suburb=Sunnybank`

5. **郊区详情**: `https://compass-backend.onrender.com/api/suburb/Sunnybank`

---

## 🔧 故障排除

### 问题 1：数据库连接失败

**症状**: API 返回 500 错误，日志显示数据库连接失败

**解决方案**:
1. 检查 `DATABASE_URL` 环境变量是否正确
2. 确认 Supabase 项目正在运行
3. 检查 Supabase 防火墙设置
4. 尝试使用连接池端口 6543

### 问题 2：构建失败

**症状**: Render 构建过程中出错

**解决方案**:
1. 检查 `requirements.txt` 中的依赖版本
2. 确保 `runtime.txt` 中的 Python 版本正确
3. 查看 Render 构建日志获取详细错误信息

### 问题 3：CORS 错误

**症状**: 前端无法访问 API

**解决方案**:
1. 更新 `CORS_ORIGINS` 环境变量为前端域名
2. 例如：`["https://compass-frontend.vercel.app"]`

---

## 📊 环境变量说明

| 变量名 | 说明 | 示例值 |
|--------|------|--------|
| `DATABASE_URL` | Supabase 数据库连接字符串 | `postgresql://postgres:password@db.xxx.supabase.co:5432/postgres` |
| `APP_NAME` | 应用名称 | `Compass MVP` |
| `APP_VERSION` | 应用版本 | `1.0.0` |
| `CORS_ORIGINS` | 允许的跨域来源 | `["https://your-frontend.vercel.app"]` |

---

## 🔄 更新部署

每次推送到 GitHub 的 `main` 分支，Render 会自动重新部署：

```bash
git add .
git commit -m "Update feature"
git push origin main
```

---

## 📝 部署检查清单

- [ ] GitHub 仓库已创建并推送代码
- [ ] Render Web Service 已创建
- [ ] 环境变量已正确配置
- [ ] 数据库连接成功
- [ ] API 端点可访问
- [ ] API 文档可访问
- [ ] CORS 配置正确

---

## 🎯 下一步

部署成功后：

1. **测试 API**: 使用 Postman 或 curl 测试所有端点
2. **开发前端**: 创建 Next.js 前端项目
3. **配置 CORS**: 更新 CORS 设置为前端域名
4. **添加监控**: 配置日志和性能监控
5. **设置域名**: 配置自定义域名（可选）

---

## 💡 提示

- Render 免费版本会在 15 分钟无活动后休眠，首次访问可能需要等待唤醒
- 建议在生产环境使用付费版本以获得更好的性能
- 定期检查 Supabase 数据库使用情况
- 保持依赖包更新以确保安全性

---

## 📞 支持

如有问题，请检查：
1. Render 部署日志
2. Supabase 项目状态
3. API 响应和错误信息
4. GitHub 仓库代码
