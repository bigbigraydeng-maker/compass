"""
Compass MVP FastAPI 主应用
v1.0.1 - 使用 psycopg2-binary 连接 Supabase
"""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from datetime import date, timedelta
import os
import json

print("🚀 Compass API 版本 v1.0.1 - 使用 psycopg2-binary")

from models import (
    HomeData, SuburbStats, Sale, 
    SalesResponse, SuburbDetail, Property,
    SuburbTrends, MonthlyTrend
)

# 检查是否有真实数据库连接
DATABASE_URL = os.getenv("DATABASE_URL", "")

# 跟踪当前使用的数据库类型
USING_REAL_DB = False
execute_query = None

if DATABASE_URL:
    try:
        # 先尝试真实数据库
        print("🔍 尝试使用真实数据库（Supabase）...")
        from database import execute_query as real_execute_query
        # 测试连接
        real_execute_query("SELECT 1")
        print("✅ 成功连接到真实数据库（Supabase）")
        print(f"   数据库连接: {DATABASE_URL[:30]}...")
        USING_REAL_DB = True
        execute_query = real_execute_query
    except Exception as e:
        print(f"⚠️  真实数据库连接失败: {e}")
        print("✅ 回退到模拟数据库")
        from database_mock import execute_query as mock_execute_query
        USING_REAL_DB = False
        execute_query = mock_execute_query
else:
    print("✅ 使用模拟数据库（完整 155 条真实数据）")
    from database_mock import execute_query as mock_execute_query
    USING_REAL_DB = False
    execute_query = mock_execute_query

# 创建 FastAPI 应用
app = FastAPI(
    title="Compass MVP API",
    description="布里斯班华人房产数据平台 API",
    version="1.0.0"
)

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境请修改为具体域名
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
        "status": "running",
        "database": "connected" if USING_REAL_DB else "mock"
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
        suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
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
                    median_price = int(row.get('median_price', 0) or 0)
                    total_sales = int(row.get('total_sales', 0) or 0)
                else:
                    median_price = int(row[0] or 0)
                    total_sales = int(row[1] or 0)
                
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
    property_type: Optional[str] = None,
    bedrooms: Optional[int] = None,
    min_price: Optional[int] = None,
    max_price: Optional[int] = None,
    min_date: Optional[str] = None,
    max_date: Optional[str] = None,
    page: int = 1,
    page_size: int = 20
):
    """
    获取成交列表
    
    参数：
    - suburb: 郊区名称（可选）
    - property_type: 房产类型（可选）
    - bedrooms: 卧室数（可选）
    - min_price: 最低价格（可选）
    - max_price: 最高价格（可选）
    - min_date: 开始日期（可选，格式：YYYY-MM-DD）
    - max_date: 结束日期（可选，格式：YYYY-MM-DD）
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    """
    try:
        offset = (page - 1) * page_size
        
        # 基础查询
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
        
        if property_type:
            where_conditions.append("p.property_type = %s")
            params.append(property_type)
        
        if bedrooms:
            if bedrooms >= 5:
                where_conditions.append("p.bedrooms >= 5")
            else:
                where_conditions.append("p.bedrooms = %s")
                params.append(bedrooms)
        
        if min_price:
            where_conditions.append("s.sold_price >= %s")
            params.append(min_price)
        
        if max_price:
            where_conditions.append("s.sold_price <= %s")
            params.append(max_price)
        
        if min_date:
            where_conditions.append("s.sold_date >= %s")
            params.append(min_date)
        
        if max_date:
            where_conditions.append("s.sold_date <= %s")
            params.append(max_date)
        
        if where_conditions:
            base_query += " WHERE " + " AND ".join(where_conditions)
        
        # 获取总数
        count_query = f"SELECT COUNT(*) as total FROM ({base_query}) as subq"
        total_result = execute_query(count_query, tuple(params))
        
        # 处理结果格式
        if total_result and len(total_result) > 0:
            row = total_result[0]
            if isinstance(row, dict):
                total = row.get('total', 0)
            else:
                total = row[0]
        else:
            total = 0
        
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
        
        # 处理结果格式
        if stats_result and len(stats_result) > 0:
            row = stats_result[0]
            if isinstance(row, dict):
                median_price = int(row.get('median_price', 0) or 0)
                total_sales = int(row.get('total_sales', 0) or 0)
            else:
                median_price = int(row[0] or 0)
                total_sales = int(row[1] or 0)
        else:
            median_price = 0
            total_sales = 0
        
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
            median_price=median_price,
            total_sales=total_sales,
            recent_sales=[Sale(**sale) for sale in recent_sales]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取郊区详情失败: {str(e)}")


@app.get("/api/suburb/{suburb_name}/trends", response_model=SuburbTrends)
def get_suburb_trends(suburb_name: str):
    """
    获取郊区价格走势
    
    参数：
    - suburb_name: 郊区名称
    
    返回：
    - 过去12个月的月度中位价和成交量
    - 只包含有3条以上成交记录的月份
    """
    try:
        # 获取过去12个月的月度趋势数据
        trends_query = """
            SELECT 
                TO_CHAR(DATE_TRUNC('month', s.sold_date), 'YYYY-MM') as month,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sold_price) as median_price,
                COUNT(*) as total_sales
            FROM sales s
            JOIN properties p ON s.property_id = p.id
            WHERE p.suburb = %s
              AND s.sold_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '12 months')
            GROUP BY DATE_TRUNC('month', s.sold_date)
            HAVING COUNT(*) >= 3
            ORDER BY month ASC
        """
        trends_result = execute_query(trends_query, (suburb_name,))
        
        # 处理结果
        monthly_trends = []
        if trends_result:
            for row in trends_result:
                if isinstance(row, dict):
                    monthly_trends.append(MonthlyTrend(
                        month=row.get('month', ''),
                        median_price=int(row.get('median_price', 0) or 0),
                        total_sales=int(row.get('total_sales', 0) or 0)
                    ))
                else:
                    monthly_trends.append(MonthlyTrend(
                        month=row[0] if row[0] else '',
                        median_price=int(row[1] or 0),
                        total_sales=int(row[2] or 0)
                    ))
        
        return SuburbTrends(
            suburb=suburb_name,
            monthly_trends=monthly_trends
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取价格走势失败: {str(e)}")


@app.get("/api/suburb/{suburb_name}/schools")
def get_suburb_schools(suburb_name: str):
    import os
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "schools_data.json")
    with open(json_path, "r", encoding="utf-8") as f:
        all_schools = json.load(f)
    schools = all_schools.get(suburb_name, [])
    return {"suburb": suburb_name, "schools": schools}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8888)
