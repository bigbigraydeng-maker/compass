#!/usr/bin/env python3
"""
Compass MVP 后端启动脚本
"""
import subprocess
import sys
import os

def main():
    print("🚀 Compass MVP 后端启动中...")
    
    # 检查虚拟环境
    if not os.path.exists("venv"):
        print("❌ 虚拟环境不存在，请先创建虚拟环境")
        print("   运行: python -m venv venv")
        sys.exit(1)
    
    # 检查依赖
    try:
        import fastapi
        import uvicorn
        import psycopg2
    except ImportError as e:
        print(f"❌ 缺少依赖: {e}")
        print("   运行: pip install -r requirements.txt")
        sys.exit(1)
    
    # 检查环境变量文件
    if not os.path.exists(".env"):
        print("⚠️  .env 文件不存在，使用默认配置")
        print("   建议复制 .env.example 到 .env 并修改数据库配置")
    
    # 启动服务器
    print("✅ 启动 FastAPI 服务器...")
    print("📡 API 地址: http://localhost:8000")
    print("📚 API 文档: http://localhost:8000/docs")
    print()
    
    try:
        subprocess.run([
            sys.executable, "-m", "uvicorn", "main:app",
            "--host", "0.0.0.0",
            "--port", "8000",
            "--reload"
        ])
    except KeyboardInterrupt:
        print("\n👋 服务器已停止")
    except Exception as e:
        print(f"❌ 启动失败: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
