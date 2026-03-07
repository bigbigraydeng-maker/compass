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

from models import HomeData, SuburbStats, SalesResponse, Sale, SuburbDetail, SuburbTrends, MonthlyTrend, Listing, ListingsResponse, Zone, ZoningResponse

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
                WHERE LOWER(p.suburb) = LOWER(%s)
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
            where_conditions.append("LOWER(p.property_type) = LOWER(%s)")
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
            WHERE LOWER(p.suburb) = LOWER(%s)
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
            WHERE LOWER(p.suburb) = LOWER(%s)
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
    json_path = os.path.join(script_dir, "data", "qld_schools.json")
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            all_schools = json.load(f)
        # 过滤出属于该郊区的学校
        schools = []
        for school in all_schools:
            # 检查学校是否在该郊区
            if school.get('suburb', '').lower() == suburb_name.lower():
                schools.append(school)
            else:
                # 检查该郊区是否在招生范围内
                catchment = school.get('catchment_suburbs', [])
                if isinstance(catchment, list):
                    # 如果是数组
                    for s in catchment:
                        if isinstance(s, str) and s.strip().lower() == suburb_name.lower():
                            schools.append(school)
                            break
                elif isinstance(catchment, str):
                    # 如果是字符串
                    for s in catchment.split(','):
                        if s.strip().lower() == suburb_name.lower():
                            schools.append(school)
                            break
        return {"suburb": suburb_name, "schools": schools}
    except Exception as e:
        # 如果文件不存在或解析失败，返回空列表
        return {"suburb": suburb_name, "schools": []}


@app.get("/api/listings", response_model=ListingsResponse)
def get_listings(
    suburb: Optional[str] = None,
    property_type: Optional[str] = None,
    bedrooms: Optional[int] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    page: int = 1,
    page_size: int = 20
):
    """
    获取在售房源列表
    
    参数：
    - suburb: 郊区名称（可选）
    - property_type: 房产类型（可选）
    - bedrooms: 卧室数（可选）
    - min_price: 最低价格（可选）
    - max_price: 最高价格（可选）
    - page: 页码（默认1）
    - page_size: 每页数量（默认20）
    """
    try:
        offset = (page - 1) * page_size
        
        # 基础查询
        base_query = """
            SELECT id, address, suburb, property_type, bedrooms, bathrooms, 
                   car_spaces, land_size, price_text, price, sale_method,
                   agent_name, agent_company, link, scraped_date,
                   created_at
            FROM listings
        """
        
        # 添加过滤条件
        params = []
        where_conditions = []
        
        if suburb:
            where_conditions.append("suburb = %s")
            params.append(suburb)
        
        if property_type:
            where_conditions.append("LOWER(property_type) = LOWER(%s)")
            params.append(property_type)
        
        if bedrooms:
            if bedrooms >= 5:
                where_conditions.append("bedrooms >= 5")
            else:
                where_conditions.append("bedrooms = %s")
                params.append(bedrooms)
        
        if min_price:
            where_conditions.append("price >= %s")
            params.append(min_price)
        
        if max_price:
            where_conditions.append("price <= %s")
            params.append(max_price)
        
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
        query = f"{base_query} ORDER BY id DESC LIMIT %s OFFSET %s"
        params.extend([page_size, offset])
        
        # 执行查询
        listings = execute_query(query, tuple(params))
        
        return ListingsResponse(
            listings=[Listing(**listing) for listing in listings],
            total=total,
            page=page,
            page_size=page_size
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取在售房源列表失败: {str(e)}")


@app.get("/api/suburb/{suburb_name}/zoning", response_model=ZoningResponse)
def get_suburb_zoning(suburb_name: str):
    """
    获取郊区的分区信息
    
    参数：
    - suburb_name: 郊区名称
    """
    # 模拟数据，实际应该调用 Brisbane Open Data API
    zone_data = {
        "Sunnybank": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 65},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 20},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 15}
        ],
        "Eight Mile Plains": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 70},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 15},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 15}
        ],
        "Calamvale": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 60},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 25},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 15}
        ],
        "Rochedale": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 75},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 10},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 15}
        ],
        "Mansfield": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 80},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 10},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 10}
        ],
        "Ascot": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 85},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 5},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 10}
        ],
        "Hamilton": [
            {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 70},
            {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 20},
            {"zone_code": "OTHER", "zone_name": "Other", "percentage": 10}
        ]
    }
    
    zones = zone_data.get(suburb_name, [
        {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 60},
        {"zone_code": "MDR", "zone_name": "Medium Density Residential", "percentage": 20},
        {"zone_code": "OTHER", "zone_name": "Other", "percentage": 20}
    ])
    
    return ZoningResponse(
        suburb=suburb_name,
        zones=zones
    )


@app.get("/api/suburb/{suburb_name}/score")
def get_suburb_score(suburb_name: str):
    """
    获取郊区的 Compass Score
    
    参数：
    - suburb_name: 郊区名称
    """
    import json, os
    from database import get_db_connection, get_db_cursor
    
    # 读取配置
    config_path = os.path.join(os.path.dirname(__file__), "suburb_scores_config.json")
    with open(config_path) as f:
        config = json.load(f)
    
    # 1. 房价增长潜力 (25分)
    # 近12个月 vs 前12个月中位价涨幅
    growth_score = 12  # 默认中等
    
    try:
        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                cur.execute("""
                    SELECT 
                        AVG(CASE WHEN sold_date >= NOW() - INTERVAL '12 months' THEN sold_price END) as recent,
                        AVG(CASE WHEN sold_date BETWEEN NOW() - INTERVAL '24 months' AND NOW() - INTERVAL '12 months' THEN sold_price END) as prev
                    FROM sales s
                    JOIN properties p ON s.property_id = p.id
                    WHERE LOWER(p.suburb) = LOWER(%s)
                """, (suburb_name,))
                row = cur.fetchone()
                
                if row:
                    recent = row.get('recent')
                    prev = row.get('prev')
                    
                    if recent and prev and prev > 0:
                        growth_rate = (recent - prev) / prev
                        if growth_rate >= 0.15: growth_score = 25
                        elif growth_rate >= 0.10: growth_score = 20
                        elif growth_rate >= 0.05: growth_score = 15
                        elif growth_rate >= 0: growth_score = 10
                        else: growth_score = 5
    except Exception as e:
        pass
    
    # 2. 学区质量 (25分)
    # 取对口学校最高 NAPLAN percentile
    school_score = 12  # 默认中等
    
    try:
        schools_path = os.path.join(os.path.dirname(__file__), "data/qld_schools.json")
        if os.path.exists(schools_path):
            with open(schools_path) as f:
                schools_data = json.load(f)
            
            top_naplan = 0
            for school in schools_data:
                catchments = school.get("catchment_suburbs", [])
                if isinstance(catchments, str):
                    catchments = [catchments]
                if suburb_name.upper() in [c.upper() for c in catchments]:
                    naplan = school.get("naplan_percentile", 0) or 0
                    top_naplan = max(top_naplan, naplan)
            
            school_score = round((top_naplan / 100) * 25)
    except Exception as e:
        pass
    
    # 3. 土地价值潜力 (20分)
    # MDR+HDR zoning % + 是否有在售土地 + 中位价加成
    # 使用模拟分区数据（与 zoning API 一致）
    land_score = 10  # 默认中等
    
    try:
        zoning_map = {
            "Sunnybank": {"MDR": 20, "HDR": 0},
            "Eight Mile Plains": {"MDR": 25, "HDR": 5},
            "Calamvale": {"MDR": 15, "HDR": 0},
            "Rochedale": {"MDR": 20, "HDR": 0},
            "Mansfield": {"MDR": 15, "HDR": 0},
            "Ascot": {"MDR": 10, "HDR": 5},
            "Hamilton": {"MDR": 15, "HDR": 10},
        }
        zm = zoning_map.get(suburb_name, {"MDR": 10, "HDR": 0})
        mdr_hdr_pct = zm["MDR"] + zm["HDR"]
        
        # 获取中位价用于加成
        median_price = 0
        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                cur.execute("SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sold_price) as median_price FROM sales s JOIN properties p ON s.property_id = p.id WHERE LOWER(p.suburb) = LOWER(%s)", (suburb_name,))
                row = cur.fetchone()
                if row:
                    median_price = row.get('median_price', 0) or 0
                
                cur.execute("SELECT COUNT(*) as cnt FROM listings WHERE LOWER(suburb) = LOWER(%s) AND property_type = 'vacant_land'", (suburb_name,))
                row = cur.fetchone()
                has_land = row.get('cnt', 0) > 0
        
        # 中位价加成：每30万加1分，最多5分
        median_bonus = min(5, int(median_price / 300000))
        
        land_score = min(20, round(mdr_hdr_pct / 100 * 12) + (3 if has_land else 0) + median_bonus)
    except Exception as e:
        pass
    
    # 4. 市场活跃度 (15分)
    # 成交率 = 年成交量 / 在售数量
    activity_score = 7  # 默认中等
    
    try:
        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                cur.execute("SELECT COUNT(*) as cnt FROM sales s JOIN properties p ON s.property_id = p.id WHERE LOWER(p.suburb) = LOWER(%s) AND sold_date >= NOW() - INTERVAL '12 months'", (suburb_name,))
                row = cur.fetchone()
                annual_sales = row.get('cnt', 0)
                
                cur.execute("SELECT COUNT(*) as cnt FROM listings WHERE LOWER(suburb) = LOWER(%s)", (suburb_name,))
                row = cur.fetchone()
                active_listings = max(row.get('cnt', 0), 1)
        
        activity_ratio = annual_sales / active_listings
        activity_score = min(15, round(activity_ratio * 5))
    except Exception as e:
        pass
    
    # 5. 华人友好度 (15分)
    chinese_score = config["chinese_friendly"].get(suburb_name, 8)
    
    total = growth_score + school_score + land_score + activity_score + chinese_score
    
    # 等级
    if total >= 85: grade = "S"
    elif total >= 75: grade = "A"
    elif total >= 65: grade = "B"
    else: grade = "C"
    
    return {
        "suburb": suburb_name,
        "total_score": total,
        "grade": grade,
        "breakdown": {
            "growth": {"score": growth_score, "max": 25, "label": "房价增长潜力"},
            "school": {"score": school_score, "max": 25, "label": "学区质量"},
            "land": {"score": land_score, "max": 20, "label": "土地价值潜力"},
            "activity": {"score": activity_score, "max": 15, "label": "市场活跃度"},
            "chinese": {"score": chinese_score, "max": 15, "label": "华人友好度"}
        },
        "data_sources": ["QLD Sales Records", "NAPLAN ACARA", "ABS Census 2021"],
        "updated_at": "2026-03"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8888)
