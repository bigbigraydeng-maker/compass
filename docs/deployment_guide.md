# Compass MVP 部署步骤清单

## 第一步：数据库部署（Supabase）

### 1.1 创建 Supabase 项目
1. 访问 https://supabase.com
2. 点击 "Start your project"
3. 创建新项目：
   - 名称：compass
   - 数据库密码：设置强密码
   - 区域：选择 Sydney（最接近布里斯班）
4. 等待项目创建完成（约 2 分钟）

### 1.2 获取数据库连接信息
1. 进入项目后，点击左侧 "Settings" → "Database"
2. 复制以下信息：
   - Host: `db.xxxxx.supabase.co`
   - Database name: `postgres`
   - Port: `5432` 或 `6543`（根据显示）
   - User: `postgres`
   - Password: 你设置的密码

### 1.3 执行数据库 Schema
1. 点击左侧 "SQL Editor"
2. 点击 "New query"
3. 复制 `database/schema_mvp.sql` 的内容
4. 点击 "Run" 执行
5. 确认两张表创建成功

### 1.4 导入示例数据
1. 在 SQL Editor 中创建新查询
2. 复制 `database/sample_data.sql` 的内容
3. 点击 "Run" 执行
4. 确认数据插入成功

### 1.5 获取连接字符串
在 Settings → Database 页面，找到 Connection string，选择 "URI" 格式：
```
postgresql://postgres:[YOUR-PASSWORD]@db.xxxxx.supabase.co:5432/postgres
```

---

## 第二步：后端部署（Render）

### 2.1 准备代码
1. 确保 `backend/main.py` 文件存在
2. 确保 `backend/requirements.txt` 文件存在
3. 创建 `backend/runtime.txt` 文件：
   ```
   python-3.11.0
   ```

### 2.2 创建 Render 账户
1. 访问 https://render.com
2. 使用 GitHub 账户登录
3. 授权 Render 访问你的 GitHub 仓库

### 2.3 创建 Web Service
1. 点击 "New" → "Web Service"
2. 连接你的 GitHub 仓库
3. 填写配置：
   - Name: `compass-api`
   - Region: `Sydney`
   - Branch: `main`
   - Root Directory: `backend`
   - Runtime: `Python 3`
   - Build Command: `pip install -r requirements.txt`
   - Start Command: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### 2.4 设置环境变量
在 "Environment Variables" 部分添加：
- Key: `DATABASE_URL`
- Value: 你的 Supabase 连接字符串

### 2.5 部署
1. 点击 "Create Web Service"
2. 等待部署完成（约 5-10 分钟）
3. 部署成功后，你会获得一个 URL，例如：
   ```
   https://compass-api.onrender.com
   ```

### 2.6 测试 API
访问以下 URL 确认 API 正常工作：
- `https://compass-api.onrender.com/`
- `https://compass-api.onrender.com/api/home`
- `https://compass-api.onrender.com/api/sales`

---

## 第三步：前端部署（Vercel）

### 3.1 准备代码
1. 确保 `frontend/app/page.tsx` 文件存在
2. 确保 `frontend/package.json` 文件存在
3. 确保 `frontend/next.config.js` 文件存在

### 3.2 创建 Vercel 账户
1. 访问 https://vercel.com
2. 使用 GitHub 账户登录
3. 授权 Vercel 访问你的 GitHub 仓库

### 3.3 导入项目
1. 点击 "Add New" → "Project"
2. 选择你的 GitHub 仓库
3. 填写配置：
   - Framework Preset: `Next.js`
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Output Directory: `.next`

### 3.4 设置环境变量
在 "Environment Variables" 部分添加：
- Key: `NEXT_PUBLIC_API_URL`
- Value: 你的 Render API URL（例如：`https://compass-api.onrender.com`）

### 3.5 部署
1. 点击 "Deploy"
2. 等待部署完成（约 2-3 分钟）
3. 部署成功后，你会获得一个 URL，例如：
   ```
   https://compass.vercel.app
   ```

### 3.6 测试网站
访问你的 Vercel URL，确认：
- 首页正常显示
- 成交列表页面可以访问
- Suburb 页面可以访问
- 数据正常加载

---

## 第四步：域名配置（可选）

### 4.1 购买域名
1. 选择域名注册商（如 GoDaddy、Namecheap）
2. 购买域名（如 `compass-property.com.au`）

### 4.2 配置 Vercel 域名
1. 在 Vercel 项目中，点击 "Settings" → "Domains"
2. 添加你的域名
3. 按照提示配置 DNS 记录
4. 等待 DNS 生效（最多 48 小时）

### 4.3 配置 SSL
Vercel 会自动为你的域名配置 SSL 证书

---

## 第五步：测试和验证

### 5.1 功能测试
- [ ] 首页可以访问
- [ ] 3 个 Suburb 的数据显示正确
- [ ] 成交列表页面可以访问
- [ ] Suburb 详情页面可以访问
- [ ] 数据正确显示

### 5.2 移动端测试
- [ ] 在手机浏览器中访问
- [ ] 页面布局正常
- [ ] 功能正常使用

### 5.3 微信测试
- [ ] 在微信中打开链接
- [ ] 页面正常显示
- [ ] 分享功能正常

### 5.4 分享测试
- [ ] 复制链接分享
- [ ] 分享到微信
- [ ] 分享到其他平台

---

## 第六步：监控和维护

### 6.1 设置监控
1. Render 提供基本的监控功能
2. Vercel 提供访问日志和分析
3. 可以设置 Uptime 监控（如 UptimeRobot）

### 6.2 定期维护
- 每周检查一次网站是否正常运行
- 每月更新一次数据
- 监控错误日志

---

## 常见问题

### Q1: API 无法连接数据库
**解决方案**：
- 检查 DATABASE_URL 环境变量是否正确
- 确认 Supabase 项目是否正常运行
- 检查 IP 白名单设置

### Q2: 前端无法访问 API
**解决方案**：
- 检查 CORS 配置
- 确认 API URL 是否正确
- 检查网络连接

### Q3: 数据不显示
**解决方案**：
- 检查数据库是否有数据
- 确认 API 返回的数据格式
- 检查前端代码是否正确处理数据

### Q4: 部署失败
**解决方案**：
- 检查构建日志
- 确认依赖版本是否兼容
- 检查环境变量是否设置正确

---

## 部署时间估算

- 数据库部署：30 分钟
- 后端部署：1 小时
- 前端部署：30 分钟
- 测试和验证：1 小时
- **总计：3 小时**

---

## 部署成本估算

- Supabase：免费版（足够 MVP 使用）
- Render：免费版（足够 MVP 使用）
- Vercel：免费版（足够 MVP 使用）
- 域名：$10-20/年（可选）
- **总计：$0-20/年**

---

## 下一步

部署完成后：
1. 在微信中分享链接测试
2. 收集用户反馈
3. 准备下一阶段的功能开发
