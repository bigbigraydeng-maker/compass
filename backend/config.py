"""
Compass MVP 数据库配置
"""
from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    """应用配置"""
    
    # 数据库配置
    DATABASE_URL: str = "postgresql://postgres:password@localhost:5432/compass"
    
    # 应用配置
    APP_NAME: str = "Compass MVP"
    APP_VERSION: str = "1.0.0"
    
    # CORS 配置
    CORS_ORIGINS: list = ["*"]
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
