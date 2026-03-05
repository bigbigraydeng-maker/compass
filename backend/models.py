"""
Compass MVP 数据模型
"""
from pydantic import BaseModel
from typing import List, Optional
from datetime import date


class Property(BaseModel):
    """房产模型"""
    id: int
    address: str
    suburb: str
    property_type: Optional[str] = None
    land_size: Optional[int] = None
    bedrooms: int = 0
    bathrooms: int = 0
    
    class Config:
        from_attributes = True


class Sale(BaseModel):
    """成交记录模型"""
    id: int
    property_id: int
    sold_price: int
    sold_date: date
    address: str
    suburb: str
    property_type: Optional[str] = None
    land_size: Optional[int] = None
    bedrooms: Optional[int] = 0
    bathrooms: Optional[int] = 0
    
    class Config:
        from_attributes = True


class SuburbStats(BaseModel):
    """郊区统计模型"""
    suburb: str
    median_price: int
    total_sales: int


class HomeData(BaseModel):
    """首页数据模型"""
    latest_sales: List[Sale]
    suburb_stats: List[SuburbStats]


class SalesResponse(BaseModel):
    """成交列表响应模型"""
    sales: List[Sale]
    total: int
    page: int
    page_size: int


class SuburbDetail(BaseModel):
    """郊区详情模型"""
    suburb: str
    median_price: int
    total_sales: int
    recent_sales: List[Sale]


class MonthlyTrend(BaseModel):
    """月度趋势数据模型"""
    month: str
    median_price: int
    total_sales: int


class SuburbTrends(BaseModel):
    """郊区价格走势模型"""
    suburb: str
    monthly_trends: List[MonthlyTrend]



