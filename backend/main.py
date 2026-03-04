"""
Compass MVP FastAPI 主应用
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from datetime import date, timedelta

from models import (
    HomeData, SuburbStats, Sale, 
    SalesResponse, SuburbDetail, Property
)
from database import execute_query

# 创建 FastAPI 应用
app = FastAPI(
    title="Compass MVP API",
    description="布里斯班华人房产数据平台 API",
    version="1.0.0"
)

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root():
    """根路径"""
    return {
        "message": "Compass MVP API",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/api/home", response_model=HomeData)
def get_home_data():
    """
    获取首页数据
    
    返回：
    - 最新10条成交记录
    - 3个郊区的统计信息
    """
    try:
        # 获取最新10条成交记录
        latest_sales_query = """
            SELECT s.id, s.property_id, s.sold_price, s.sold_date,
                   p.address, p.suburb, p.property_type, p.land_size, p.bedrooms, p.bathrooms
            FROM sales s
            JOIN properties p ON s.property_id = p.id
            ORDER BY s.sold_date DESC
            LIMIT 10
        """
        latest_sales = execute_query(latest_sales_query)
        
        # 获取3个郊区的统计信息
        suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale']
        suburb_stats = []
        
        for suburb in suburbs:
            # 获取中位价
            median_query = """
                SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sold_price) as median_price,
                       COUNT(*) as total_sales
                FROM sales s
                JOIN properties p ON s.property_id = p.id
                WHERE p.suburb = %s
            """
            result = execute_query(median_query, (suburb,))
            
            if result and len(result) > 0:
                row = result[0]
                if isinstance(row, dict):
                    median_price = int(row.get('median_price', 0))
                    total_sales = int(row.get('total_sales', 0))
                else:
                    median_price = int(row[0])
                    total_sales = int(row[1])
                
                suburb_stats.append(SuburbStats(
                    suburb=suburb,
                    median_price=median_price,
                    total_sales=total_sales
                ))
        
        return HomeData(
            latest_sales=[Sale(**sale) for sale in latest_sales],
            suburb_stats=suburb_stats
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取首页数据失败: {str(e)}")


@app.get("/api/sales", response_model=SalesResponse)
def get_sales(
    suburb: Optional[str] = None,
    page: int = 1,
    page_size: int = 20
):
    """
    获取成交列表
    
    参数：
    - suburb: 郊区名称（可选）
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    """
    try:
        offset = (page - 1) * page_size
        
        # 构建基础查询
        base_query = """
            SELECT s.id, s.property_id, s.sold_price, s.sold_date,
                   p.address, p.suburb, p.property_type, p.land_size, p.bedrooms, p.bathrooms
            FROM sales s
            JOIN properties p ON s.property_id = p.id
        """
        
        # 添加过滤条件
        params = []
        where_conditions = []
        
        if suburb:
            where_conditions.append("p.suburb = %s")
            params.append(suburb)
        
        if where_conditions:
            base_query += " WHERE " + " AND ".join(where_conditions)
        
        # 获取总数
        count_query = f"SELECT COUNT(*) as total FROM ({base_query}) as subq"
        total_result = execute_query(count_query, tuple(params))
        total = total_result[0]['total'] if total_result else 0
        
        # 添加排序和分页
        query = f"{base_query} ORDER BY s.sold_date DESC LIMIT %s OFFSET %s"
        params.extend([page_size, offset])
        
        # 执行查询
        sales = execute_query(query, tuple(params))
        
        return SalesResponse(
            sales=[Sale(**sale) for sale in sales],
            total=total,
            page=page,
            page_size=page_size
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取成交列表失败: {str(e)}")


@app.get("/api/suburb/{suburb_name}", response_model=SuburbDetail)
def get_suburb_detail(suburb_name: str):
    """
    获取郊区详情
    
    参数：
    - suburb_name: 郊区名称
    """
    try:
        # 获取中位价和总成交数
        stats_query = """
            SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sold_price) as median_price,
                   COUNT(*) as total_sales
            FROM sales s
            JOIN properties p ON s.property_id = p.id
            WHERE p.suburb = %s
        """
        stats_result = execute_query(stats_query, (suburb_name,))
        
        if not stats_result:
            raise HTTPException(status_code=404, detail=f"未找到郊区: {suburb_name}")
        
        # 获取最近10条成交记录
        recent_sales_query = """
            SELECT s.id, s.property_id, s.sold_price, s.sold_date,
                   p.address, p.suburb, p.property_type, p.land_size, p.bedrooms, p.bathrooms
            FROM sales s
            JOIN properties p ON s.property_id = p.id
            WHERE p.suburb = %s
            ORDER BY s.sold_date DESC
            LIMIT 10
        """
        recent_sales = execute_query(recent_sales_query, (suburb_name,))
        
        return SuburbDetail(
            suburb=suburb_name,
            median_price=int(stats_result[0]['median_price'] or 0),
            total_sales=stats_result[0]['total_sales'],
            recent_sales=[Sale(**sale) for sale in recent_sales]
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取郊区详情失败: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
