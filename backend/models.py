"""
Compass MVP 数据模型
"""
from pydantic import BaseModel
from typing import List, Optional
from datetime import date, datetime


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
    id: str
    property_id: Optional[str] = None
    sold_price: float
    sold_date: date
    address: str
    suburb: str
    property_type: Optional[str] = None
    land_size: Optional[float] = None
    bedrooms: Optional[int] = 0
    bathrooms: Optional[int] = 0

    class Config:
        from_attributes = True


class SuburbStats(BaseModel):
    """郊区统计模型"""
    suburb: str
    median_price: int
    total_sales: int
    trend: List[int] = []


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


class Listing(BaseModel):
    """在售房源模型"""
    id: int
    address: str
    suburb: str
    property_type: Optional[str] = None
    bedrooms: Optional[int] = 0
    bathrooms: Optional[int] = 0
    car_spaces: Optional[int] = 0
    land_size: Optional[int] = 0
    price_text: Optional[str] = None
    price: Optional[float] = 0
    sale_method: Optional[str] = None
    agent_name: Optional[str] = None
    agent_company: Optional[str] = None
    link: Optional[str] = None
    scraped_date: Optional[date] = None
    created_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True


class ListingsResponse(BaseModel):
    """在售房源列表响应模型"""
    listings: List[Listing]
    total: int
    page: int
    page_size: int


class Zone(BaseModel):
    """分区信息模型"""
    zone_code: str
    zone_name: str
    percentage: int


class ZoningResponse(BaseModel):
    """分区信息响应模型"""
    suburb: str
    zones: List[Zone]



