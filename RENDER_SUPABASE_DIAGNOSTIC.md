# Render 连接 Supabase 诊断指南

## 问题分析

当前 Render 无法连接 Supabase 的可能原因：
1. **端口错误**：使用了 5432 而不是 6543（Transaction pooler）
2. **连接字符串格式错误**：缺少项目 ID 或密码不正确
3. **SSL 配置问题**：Supabase 需要特定的 SSL 配置

## 操作步骤

### 步骤 1: 获取正确的 Supabase 连接字符串

1. 打开 Supabase Dashboard: https://supabase.com/dashboard
2. 选择你的项目
3. 点击左侧菜单 **Settings** → **Database**
4. 找到 **Connection string** 部分
5. 选择 **URI** 格式
6. 复制 **Transaction pooler** 的连接字符串（端口 6543）

**正确的格式应该是：**
```
postgresql://postgres.[项目ID]:[你的密码]@aws-0-ap-southeast-2.pooler.supabase.com:6543/postgres
```

**注意：**
- 使用 **Transaction pooler**（端口 6543），不是 Session pooler（端口 5432）
- 项目 ID 通常格式为 `postgres.xxxxxxxxxxxx`
- 密码需要替换 `[你的密码]` 部分

### 步骤 2: 更新 Render 环境变量

1. 打开 Render Dashboard: https://dashboard.render.com
2. 选择你的 **compass** 服务
3. 点击 **Environment** 标签
4. 找到 `DATABASE_URL` 变量
5. 更新值为新的连接字符串
6. 点击 **Save Changes**
7. Render 会自动触发重新部署

### 步骤 3: 等待部署完成

- 部署通常需要 2-3 分钟
- 可以在 Render Dashboard 的 **Events** 标签查看部署进度
- 等待状态变为 **Live**

### 步骤 4: 验证连接

运行验证脚本：
```bash
python quick_check.py
```

期望结果：
```json
{
  "message": "Compass MVP API",
  "version": "1.0.0",
  "status": "running",
  "database": "connected"  // ✅ 应该是 "connected"
}
```

## 常见问题排查

### 问题 1: 仍然返回 "database": "mock"

**可能原因：**
- DATABASE_URL 格式不正确
- 端口仍然是 5432 而不是 6543
- 密码包含特殊字符需要 URL 编码

**解决方案：**
1. 检查 DATABASE_URL 是否包含 `:6543`
2. 确认密码中的特殊字符已正确编码
3. 查看 Render 日志中的错误信息

### 问题 2: 部署失败

**可能原因：**
- requirements.txt 缺少依赖
- 代码语法错误

**解决方案：**
1. 查看 Render 的构建日志
2. 确认所有依赖都在 requirements.txt 中

### 问题 3: SSL 连接错误

**可能原因：**
- Supabase 需要 SSL 连接
- 当前代码已禁用 SSL 验证（仅用于测试）

**解决方案：**
- 当前代码已配置 `ssl_context={'check_hostname': False, 'verify_mode': False}`
- 如果仍有问题，可能需要更新 SSL 配置

## 验证命令

### 快速验证
```bash
curl https://compass-r58x.onrender.com/
```

### 详细验证
```bash
python verify_supabase_connection.py
```

### 测试数据接口
```bash
curl https://compass-r58x.onrender.com/api/suburb/Sunnybank
```

期望返回：
```json
{
  "suburb": "Sunnybank",
  "median_price": 1125000,
  "total_sales": 50,
  "recent_sales": [...]
}
```

## 成功标志

✅ 根路由返回 `"database": "connected"`
✅ Sunnybank 接口返回 `total_sales: 50`
✅ 数据包含真实地址（如 "38 Samara Street, SUNNYBANK"）

## 下一步

连接成功后，你可以：
1. 继续前端开发
2. 添加更多 API 端点
3. 实现数据可视化功能
