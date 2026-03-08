"""
Compass MVP FastAPI 主应用
v1.1.0 - 多维度 AI 决策引擎 (Moonshot Kimi 2.5)
"""
from fastapi import FastAPI, HTTPException, Body
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from datetime import date, timedelta
import os
import json
from dotenv import load_dotenv

# 加载 .env 文件
load_dotenv()

print("Compass API v1.1.0 - Multi-dimensional AI Engine")

from models import HomeData, SuburbStats, SalesResponse, Sale, SuburbDetail, SuburbTrends, MonthlyTrend, Listing, ListingsResponse, Zone, ZoningResponse

# 检查是否有真实数据库连接
DATABASE_URL = os.getenv("DATABASE_URL", "")

# 跟踪当前使用的数据库类型
USING_REAL_DB = False
execute_query = None

if DATABASE_URL:
    try:
        print("[INFO] Connecting to Supabase...")
        from database import execute_query as real_execute_query
        real_execute_query("SELECT 1")
        print("[OK] Connected to Supabase")
        print(f"   DB: {DATABASE_URL[:30]}...")
        USING_REAL_DB = True
        execute_query = real_execute_query
    except Exception as e:
        print(f"[ERROR] DB connection failed: {e}")
        raise SystemExit(1)
else:
    print("[ERROR] DATABASE_URL not configured")
    raise SystemExit(1)

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
            SELECT s.sale_id AS id, s.property_id, s.sale_price AS sold_price, s.sale_date AS sold_date,
                   s.full_address AS address, INITCAP(s.suburb) AS suburb, s.property_type, s.land_size, s.bedrooms, s.bathrooms
            FROM sales s
            ORDER BY s.sale_date DESC
            LIMIT 10
        """
        latest_sales = execute_query(latest_sales_query)
        
        # 获取3个郊区的统计信息
        suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
        suburb_stats = []
        
        for suburb in suburbs:
            # 获取中位价
            median_query = """
                SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                       COUNT(*) as total_sales
                FROM sales s
                WHERE UPPER(s.suburb) = UPPER(%s)
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
            SELECT s.sale_id AS id, s.property_id, s.sale_price AS sold_price, s.sale_date AS sold_date,
                   s.full_address AS address, INITCAP(s.suburb) AS suburb, s.property_type, s.land_size, s.bedrooms, s.bathrooms
            FROM sales s
        """
        
        # 添加过滤条件
        params = []
        where_conditions = []
        
        if suburb:
            where_conditions.append("UPPER(s.suburb) = UPPER(%s)")
            params.append(suburb)

        if property_type:
            where_conditions.append("LOWER(s.property_type) = LOWER(%s)")
            params.append(property_type)

        if bedrooms:
            if bedrooms >= 5:
                where_conditions.append("s.bedrooms >= 5")
            else:
                where_conditions.append("s.bedrooms = %s")
                params.append(bedrooms)

        if min_price:
            where_conditions.append("s.sale_price >= %s")
            params.append(min_price)

        if max_price:
            where_conditions.append("s.sale_price <= %s")
            params.append(max_price)

        if min_date:
            where_conditions.append("s.sale_date >= %s")
            params.append(min_date)

        if max_date:
            where_conditions.append("s.sale_date <= %s")
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
        query = f"{base_query} ORDER BY s.sale_date DESC LIMIT %s OFFSET %s"
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
            SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                   COUNT(*) as total_sales
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
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
            SELECT s.sale_id AS id, s.property_id, s.sale_price AS sold_price, s.sale_date AS sold_date,
                   s.full_address AS address, INITCAP(s.suburb) AS suburb, s.property_type, s.land_size, s.bedrooms, s.bathrooms
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
            ORDER BY s.sale_date DESC
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
                TO_CHAR(DATE_TRUNC('month', s.sale_date), 'YYYY-MM') as month,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                COUNT(*) as total_sales
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
              AND s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '12 months')
            GROUP BY DATE_TRUNC('month', s.sale_date)
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
                        AVG(CASE WHEN s.sale_date >= NOW() - INTERVAL '12 months' THEN s.sale_price END) as recent,
                        AVG(CASE WHEN s.sale_date BETWEEN NOW() - INTERVAL '24 months' AND NOW() - INTERVAL '12 months' THEN s.sale_price END) as prev
                    FROM sales s
                    WHERE UPPER(s.suburb) = UPPER(%s)
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
                cur.execute("SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price FROM sales s WHERE UPPER(s.suburb) = UPPER(%s)", (suburb_name,))
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
                cur.execute("SELECT COUNT(*) as cnt FROM sales s WHERE UPPER(s.suburb) = UPPER(%s) AND s.sale_date >= NOW() - INTERVAL '12 months'", (suburb_name,))
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


@app.get("/api/deals")
def get_deals():
    """
    获取捡漏雷达数据
    
    找出成交价低于郊区同类型中位价10%以上的记录
    """
    try:
        # 先计算每个郊区每种房产类型+卧室数的中位价
        median_query = """
            SELECT
                s.suburb,
                s.property_type,
                s.bedrooms,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price
            FROM sales s
            GROUP BY s.suburb, s.property_type, s.bedrooms
        """
        median_results = execute_query(median_query)
        
        # 构建中位价映射
        median_map = {}
        for row in median_results:
            # 处理元组格式的结果
            if isinstance(row, tuple):
                # 对于模拟数据库的情况，返回的是 (median_price, total_sales)
                # 这里我们需要跳过，因为模拟数据库不支持复杂的分组查询
                continue
            # 处理字典格式的结果
            suburb = row.get('suburb')
            prop_type = row.get('property_type')
            bedrooms = row.get('bedrooms')
            median_price = row.get('median_price')
            if suburb and prop_type and bedrooms and median_price:
                key = f"{suburb.lower()}_{prop_type.lower()}_{bedrooms}"
                median_map[key] = float(median_price)
        
        # 如果没有精确匹配，尝试只按郊区+房型匹配
        fallback_median_query = """
            SELECT
                s.suburb,
                s.property_type,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price
            FROM sales s
            GROUP BY s.suburb, s.property_type
        """
        fallback_results = execute_query(fallback_median_query)
        
        for row in fallback_results:
            # 处理元组格式的结果
            if isinstance(row, tuple):
                # 对于模拟数据库的情况，返回的是 (median_price, total_sales)
                # 这里我们需要跳过，因为模拟数据库不支持复杂的分组查询
                continue
            # 处理字典格式的结果
            suburb = row.get('suburb')
            prop_type = row.get('property_type')
            median_price = row.get('median_price')
            if suburb and prop_type and median_price:
                key = f"{suburb.lower()}_{prop_type.lower()}_fallback"
                if key not in median_map:
                    median_map[key] = float(median_price)
        
        # 找出低于中位价10%的成交记录
        deals_query = """
            SELECT
                s.sale_id AS id, s.property_id, s.sale_price AS sold_price, s.sale_date AS sold_date,
                s.full_address AS address, INITCAP(s.suburb) AS suburb, s.property_type, s.land_size, s.bedrooms, s.bathrooms
            FROM sales s
            ORDER BY s.sale_date DESC
        """
        sales = execute_query(deals_query)
        
        # 筛选捡漏记录
        deals = []
        
        # 检查是否使用模拟数据库（median_map 为空）
        if not median_map and sales:
            # 对于模拟数据库，使用简单的方法生成捡漏记录
            # 假设中位价为销售价的 110%
            for sale in sales:
                # 处理元组格式的结果
                if isinstance(sale, tuple):
                    # 对于模拟数据库的情况，返回的是完整的销售记录
                    # 这里我们需要手动构建字典
                    sale_dict = {
                        "id": sale[0],
                        "property_id": sale[1],
                        "sold_price": sale[2],
                        "sold_date": sale[3],
                        "address": sale[4],
                        "suburb": sale[5],
                        "property_type": sale[6],
                        "land_size": sale[7],
                        "bedrooms": sale[8],
                        "bathrooms": sale[9]
                    }
                else:
                    # 处理字典格式的结果
                    sale_dict = sale
                
                suburb = sale_dict.get('suburb')
                sold_price = sale_dict.get('sold_price')
                
                if suburb and sold_price:
                    # 假设中位价为销售价的 110%
                    median_price = sold_price * 1.1
                    discount_percent = 10.0  # 固定 10% 的折扣
                    
                    deal = {
                        **sale_dict,
                        "median_price": median_price,
                        "discount_percent": discount_percent
                    }
                    deals.append(deal)
        else:
            # 对于真实数据库，使用正常的筛选逻辑
            for sale in sales:
                # 处理元组格式的结果
                if isinstance(sale, tuple):
                    # 对于模拟数据库的情况，返回的是完整的销售记录
                    # 这里我们需要手动构建字典
                    sale_dict = {
                        "id": sale[0],
                        "property_id": sale[1],
                        "sold_price": sale[2],
                        "sold_date": sale[3],
                        "address": sale[4],
                        "suburb": sale[5],
                        "property_type": sale[6],
                        "land_size": sale[7],
                        "bedrooms": sale[8],
                        "bathrooms": sale[9]
                    }
                else:
                    # 处理字典格式的结果
                    sale_dict = sale
                
                suburb = sale_dict.get('suburb')
                prop_type = sale_dict.get('property_type')
                bedrooms = sale_dict.get('bedrooms')
                sold_price = sale_dict.get('sold_price')
                
                if suburb and prop_type and sold_price:
                    # 优先使用郊区+房型+卧室数的精确匹配
                    key = f"{suburb.lower()}_{prop_type.lower()}_{bedrooms}"
                    if key not in median_map:
                        # 如果没有精确匹配，使用郊区+房型的 fallback
                        key = f"{suburb.lower()}_{prop_type.lower()}_fallback"
                    
                    if key in median_map:
                        median_price = float(median_map[key])
                        sold_price_f = float(sold_price)
                        if median_price > 0:
                            discount_percent = (median_price - sold_price_f) / median_price * 100
                            if discount_percent >= 10:  # 至少10%的折扣
                                deal = {
                                    **sale_dict,
                                    "median_price": median_price,
                                    "discount_percent": round(discount_percent, 1)
                                }
                                deals.append(deal)
        
        # 限制返回数量
        return {
            "deals": deals[:10],  # 最多返回10条
            "total": len(deals)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取捡漏数据失败: {str(e)}")


@app.get("/api/rankings")
def get_rankings():
    """
    获取郊区 Compass Score 排名
    
    返回7个郊区按总分排序的总榜
    """
    try:
        suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
        rankings = []
        
        # 为每个郊区计算得分
        for suburb in suburbs:
            score_data = get_suburb_score(suburb)
            rankings.append(score_data)
        
        # 按总分排序
        rankings.sort(key=lambda x: x['total_score'], reverse=True)
        
        # 添加排名
        for i, ranking in enumerate(rankings, 1):
            ranking['rank'] = i
        
        return {
            "rankings": rankings,
            "updated_at": "2026-03"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取排名数据失败: {str(e)}")


@app.get("/api/market-pulse")
def get_market_pulse():
    """
    获取市场快报数据
    
    返回：
    - 本月最热区域（成交量最高）
    - 本月涨幅最高（价格增长最快）
    - 性价比最高（价格与价值比最好）
    """
    try:
        from database import get_db_connection, get_db_cursor
        
        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                # 1. 本月最热区域（成交量最高）
                hottest_query = """
                    SELECT
                        INITCAP(s.suburb) AS suburb,
                        COUNT(*) as sales_count
                    FROM sales s
                    WHERE s.sale_date >= DATE_TRUNC('month', CURRENT_DATE)
                    GROUP BY s.suburb
                    ORDER BY sales_count DESC
                    LIMIT 1
                """
                cur.execute(hottest_query)
                hottest_result = cur.fetchone()
                hottest_suburb = hottest_result.get('suburb') if hottest_result else 'Sunnybank'
                
                # 2. 本月涨幅最高（与上月相比）
                growth_query = """
                    SELECT
                        INITCAP(s.suburb) AS suburb,
                        AVG(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) THEN s.sale_price END) as current_month,
                        AVG(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
                                 AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
                            THEN s.sale_price END) as last_month,
                        COUNT(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) THEN 1 END) as recent_count,
                        COUNT(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
                                 AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
                            THEN 1 END) as prev_count
                    FROM sales s
                    GROUP BY s.suburb
                    HAVING AVG(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) THEN s.sale_price END) IS NOT NULL
                       AND AVG(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
                                AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
                           THEN s.sale_price END) IS NOT NULL
                       AND COUNT(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE) THEN 1 END) >= 3
                       AND COUNT(CASE WHEN s.sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
                                AND s.sale_date < DATE_TRUNC('month', CURRENT_DATE)
                           THEN 1 END) >= 3
                """
                cur.execute(growth_query)
                growth_results = cur.fetchall()
                
                highest_growth_suburb = 'Rochedale'
                highest_growth_rate = 0
                
                for row in growth_results:
                    current = row.get('current_month')
                    last = row.get('last_month')
                    if current and last and last > 0:
                        growth_rate = (current - last) / last * 100
                        if growth_rate > highest_growth_rate:
                            highest_growth_rate = growth_rate
                            highest_growth_suburb = row.get('suburb')
                
                # 3. 性价比最高（使用 Compass Score 与中位价的比值）
                suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
                best_value_suburb = 'Eight Mile Plains'
                best_value_ratio = 0
                
                for suburb in suburbs:
                    # 获取 Compass Score
                    score_data = get_suburb_score(suburb)
                    score = score_data.get('total_score', 0)
                    
                    # 获取中位价
                    cur.execute("SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price FROM sales s WHERE UPPER(s.suburb) = UPPER(%s)", (suburb,))
                    median_result = cur.fetchone()
                    median_price = median_result.get('median_price', 1) if median_result else 1
                    
                    # 计算性价比（得分/价格）
                    if median_price > 0:
                        value_ratio = score / (median_price / 100000)
                        if value_ratio > best_value_ratio:
                            best_value_ratio = value_ratio
                            best_value_suburb = suburb
                
                return {
                    "hottest_suburb": hottest_suburb,
                    "highest_growth_suburb": highest_growth_suburb,
                    "highest_growth_rate": round(highest_growth_rate, 1),
                    "best_value_suburb": best_value_suburb,
                    "updated_at": "2026-03"
                }
    except Exception as e:
        # 如果数据库查询失败，返回默认值
        return {
            "hottest_suburb": "Sunnybank",
            "highest_growth_suburb": "Rochedale",
            "highest_growth_rate": 8.3,
            "best_value_suburb": "Eight Mile Plains",
            "updated_at": "2026-03"
        }


@app.get("/api/suburb/{suburb_name}/poi")
def get_suburb_poi(suburb_name: str):
    """
    获取郊区的华人POI数据（从 poi_data 表查询）

    参数：
    - suburb_name: 郊区名称
    """
    try:
        # 从真实数据库查询 POI 数据
        poi_query = """
            SELECT id, suburb, category, name, address, rating, lat, lng
            FROM poi_data
            WHERE LOWER(suburb) = LOWER(%s)
            ORDER BY category, rating DESC
        """
        poi_results = execute_query(poi_query, (suburb_name,))

        # 按类别分组
        poi_by_category = {}
        category_counts = {}

        for poi in poi_results:
            category = poi.get('category', 'other')
            if category not in poi_by_category:
                poi_by_category[category] = []
                category_counts[category] = 0
            poi_by_category[category].append(poi)
            category_counts[category] += 1

        total_poi = sum(category_counts.values())

        return {
            "suburb": suburb_name,
            "poi_by_category": poi_by_category,
            "category_counts": category_counts,
            "total_poi": total_poi
        }
    except Exception as e:
        return {
            "suburb": suburb_name,
            "poi_by_category": {},
            "category_counts": {},
            "total_poi": 0
        }


def _get_suburb_full_profile(suburb_name: str) -> dict:
    """
    聚合所有维度数据，构建郊区完整 profile。
    用于喂给 AI 引擎做投资决策分析。
    """
    profile = {
        "suburb": suburb_name,
        "price": {},
        "poi": {},
        "crime": {},
        "transport": {},
        "schools": [],
        "zoning": {},
        "compass_score": {},
    }

    try:
        # 1. 价格数据
        price_query = """
            SELECT
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                COUNT(*) as total_sales,
                AVG(s.sale_price) as avg_price,
                MIN(s.sale_price) as min_price,
                MAX(s.sale_price) as max_price
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
        """
        price_result = execute_query(price_query, (suburb_name,))
        if price_result and len(price_result) > 0:
            row = price_result[0]
            profile["price"] = {
                "median_price": int(row.get('median_price', 0) or 0),
                "total_sales": int(row.get('total_sales', 0) or 0),
                "avg_price": int(row.get('avg_price', 0) or 0),
                "min_price": int(row.get('min_price', 0) or 0),
                "max_price": int(row.get('max_price', 0) or 0),
            }

        # Listings count
        listings_query = """
            SELECT COUNT(*) as cnt FROM listings WHERE LOWER(suburb) = LOWER(%s)
        """
        listings_result = execute_query(listings_query, (suburb_name,))
        if listings_result and len(listings_result) > 0:
            profile["price"]["active_listings"] = int(listings_result[0].get('cnt', 0) or 0)

    except Exception as e:
        print(f"Price data error for {suburb_name}: {e}")

    try:
        # 2. POI 数据
        poi_query = """
            SELECT category, COUNT(*) as cnt, ROUND(AVG(rating)::numeric, 1) as avg_rating
            FROM poi_data
            WHERE LOWER(suburb) = LOWER(%s)
            GROUP BY category
        """
        poi_results = execute_query(poi_query, (suburb_name,))
        poi_summary = {}
        for row in poi_results:
            cat = row.get('category', 'other')
            poi_summary[cat] = {
                "count": int(row.get('cnt', 0)),
                "avg_rating": float(row.get('avg_rating', 0) or 0)
            }
        profile["poi"] = poi_summary

    except Exception as e:
        print(f"POI data error for {suburb_name}: {e}")

    try:
        # 3. 治安数据（最近12个月汇总）
        crime_query = """
            SELECT category, SUM(count) as total
            FROM crime_stats
            WHERE LOWER(suburb) = LOWER(%s)
              AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM')
            GROUP BY category
            ORDER BY total DESC
        """
        crime_results = execute_query(crime_query, (suburb_name,))
        crime_summary = {}
        for row in crime_results:
            crime_summary[row.get('category', 'unknown')] = int(row.get('total', 0))
        profile["crime"] = crime_summary

    except Exception as e:
        print(f"Crime data error for {suburb_name}: {e}")

    try:
        # 4. 交通数据
        transport_query = """
            SELECT type, COUNT(*) as cnt
            FROM transport_data
            WHERE LOWER(suburb) = LOWER(%s)
            GROUP BY type
        """
        transport_results = execute_query(transport_query, (suburb_name,))
        transport_summary = {}
        for row in transport_results:
            transport_summary[row.get('type', 'unknown')] = int(row.get('cnt', 0))
        profile["transport"] = transport_summary

    except Exception as e:
        print(f"Transport data error for {suburb_name}: {e}")

    try:
        # 5. 学校数据
        schools_path = os.path.join(os.path.dirname(__file__), "data/qld_schools.json")
        if os.path.exists(schools_path):
            with open(schools_path) as f:
                schools_data = json.load(f)
            suburb_schools = []
            for school in schools_data:
                catchments = school.get("catchment_suburbs", [])
                if isinstance(catchments, str):
                    catchments = [catchments]
                if suburb_name.upper() in [c.upper() for c in catchments]:
                    suburb_schools.append({
                        "name": school.get("name", ""),
                        "type": school.get("school_type", ""),
                        "naplan_percentile": school.get("naplan_percentile", 0),
                    })
            profile["schools"] = suburb_schools

    except Exception as e:
        print(f"School data error for {suburb_name}: {e}")

    try:
        # 6. Compass Score
        score_data = get_suburb_score(suburb_name)
        profile["compass_score"] = {
            "total": score_data.get("total_score", 0),
            "grade": score_data.get("grade", "C"),
            "breakdown": score_data.get("breakdown", {}),
        }

    except Exception as e:
        print(f"Score data error for {suburb_name}: {e}")

    try:
        # 7. Zoning 数据（复用现有 endpoint 逻辑）
        zoning_data = get_suburb_zoning(suburb_name)
        profile["zoning"] = {
            "zones": [{"code": z.zone_code, "name": z.zone_name, "pct": z.percentage} for z in zoning_data.zones]
        }

    except Exception as e:
        print(f"Zoning data error for {suburb_name}: {e}")

    return profile


def _build_ai_prompt(address: str, suburb: str, profile: dict) -> str:
    """
    构建多维度结构化 prompt，喂给 Kimi 2.5。
    """
    # Category name mapping for crime
    crime_label = {
        "violent_crime": "Violent Crime",
        "property_crime": "Property Crime (Break-in)",
        "theft_fraud": "Theft & Fraud",
        "drug_offences": "Drug Offences",
        "public_order": "Public Order",
    }

    # Category name mapping for POI
    poi_label = {
        "chinese_restaurant": "Chinese Restaurants",
        "asian_grocery": "Asian Grocery Stores",
        "chinese_school": "Chinese Schools",
        "chinese_church": "Chinese Churches",
        "chinese_clinic": "Chinese Clinics",
        "chinese_hair_salon": "Chinese Hair Salons",
    }

    # Build price section
    price = profile.get("price", {})
    price_section = f"""## Price Data
- Median Price: ${price.get('median_price', 0):,}
- Average Price: ${price.get('avg_price', 0):,}
- Price Range: ${price.get('min_price', 0):,} ~ ${price.get('max_price', 0):,}
- Total Historical Sales: {price.get('total_sales', 0)}
- Active Listings: {price.get('active_listings', 0)}"""

    # Build POI section
    poi = profile.get("poi", {})
    poi_lines = []
    for cat, info in poi.items():
        label = poi_label.get(cat, cat)
        poi_lines.append(f"- {label}: {info.get('count', 0)} (avg rating: {info.get('avg_rating', 0)})")
    poi_section = "## Chinese Community Amenities (POI)\n" + ("\n".join(poi_lines) if poi_lines else "- No data")

    # Build crime section
    crime = profile.get("crime", {})
    crime_lines = []
    for cat, count in crime.items():
        label = crime_label.get(cat, cat)
        crime_lines.append(f"- {label}: {count} (last 12 months)")
    crime_section = "## Safety / Crime Statistics\n" + ("\n".join(crime_lines) if crime_lines else "- No data")

    # Build transport section
    transport = profile.get("transport", {})
    transport_lines = []
    for t, cnt in transport.items():
        transport_lines.append(f"- {t.replace('_', ' ').title()}: {cnt} within 5km")
    transport_section = "## Transport Access\n" + ("\n".join(transport_lines) if transport_lines else "- No data")

    # Build schools section
    schools = profile.get("schools", [])
    school_lines = []
    for s in schools:
        school_lines.append(f"- {s.get('name', '')} ({s.get('type', '')}) - NAPLAN: {s.get('naplan_percentile', 'N/A')}")
    schools_section = "## School Quality\n" + ("\n".join(school_lines) if school_lines else "- No data")

    # Build Compass Score section
    cs = profile.get("compass_score", {})
    breakdown = cs.get("breakdown", {})
    score_lines = []
    for key, item in breakdown.items():
        if isinstance(item, dict):
            score_lines.append(f"- {item.get('label', key)}: {item.get('score', 0)}/{item.get('max', 0)}")
    score_section = f"""## Compass Score: {cs.get('total', 0)} (Grade: {cs.get('grade', 'N/A')})
{chr(10).join(score_lines)}"""

    # Build zoning section
    zoning = profile.get("zoning", {})
    zones = zoning.get("zones", [])
    zoning_lines = [f"- {z.get('name', '')}: {z.get('pct', 0)}%" for z in zones]
    zoning_section = "## Land Zoning\n" + ("\n".join(zoning_lines) if zoning_lines else "- No data")

    prompt = f"""You are a senior real estate investment analyst specializing in the Brisbane (Australia) property market, with expertise in Chinese investor needs.

A Chinese investor is considering the property at: **{address}** in **{suburb}**, Brisbane.

Below is the comprehensive multi-dimensional data for {suburb}:

{price_section}

{poi_section}

{crime_section}

{transport_section}

{schools_section}

{score_section}

{zoning_section}

---

Based on ALL the data above, please provide a detailed investment analysis report in **Chinese** with the following 5 sections:

## 1. Investment Rating (Overall assessment with a score out of 10)
Give an overall investment rating and briefly explain why.

## 2. Core Advantages (What makes this area attractive)
List 3-5 key advantages based on data evidence. Reference specific data points.

## 3. Risk Alerts (What the investor should watch out for)
List 2-4 risk factors. Be specific and honest.

## 4. Investment Recommendation (Actionable advice)
Provide specific, actionable advice: buy/hold/avoid? What type of property? Short-term vs long-term strategy?

## 5. Comparative Reference (How does this suburb compare)
Compare this suburb to other Brisbane suburbs in our coverage (Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton) based on the data you see.

IMPORTANT:
- Use CHINESE for the entire response
- Be data-driven, reference specific numbers
- Be practical and actionable, not generic
- Limit to 800 words total
"""
    return prompt


@app.post("/api/analyze")
def analyze_property(address: str = Body(...), url: str = Body(None)):
    """
    AI 多维度投资分析接口

    聚合 POI、治安、交通、学区、分区等多维数据，
    通过 Moonshot Kimi 2.5 生成结构化投资决策报告。
    """
    try:
        # 从地址中提取郊区
        suburb = "Sunnybank"  # 默认郊区
        if address:
            # 尝试匹配已知郊区
            known_suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale',
                             'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
            address_lower = address.lower()
            for s in known_suburbs:
                if s.lower() in address_lower:
                    suburb = s
                    break
            else:
                # 简单的逗号分割提取
                parts = address.split(',')
                if len(parts) > 1:
                    candidate = parts[-1].strip()
                    # Check if the candidate matches any known suburb
                    for s in known_suburbs:
                        if s.lower() in candidate.lower():
                            suburb = s
                            break

        # 1. 聚合全量数据
        profile = _get_suburb_full_profile(suburb)

        # 2. 构建 AI prompt
        prompt = _build_ai_prompt(address, suburb, profile)

        # 3. 调用 Moonshot Kimi 2.5 API
        moonshot_key = os.getenv("MOONSHOT_API_KEY", "")
        if not moonshot_key:
            raise HTTPException(status_code=500, detail="MOONSHOT_API_KEY not configured")

        from openai import OpenAI
        client = OpenAI(
            api_key=moonshot_key,
            base_url="https://api.moonshot.cn/v1"
        )

        response = client.chat.completions.create(
            model="kimi-2.5",
            messages=[
                {"role": "system", "content": "You are a senior Brisbane real estate investment analyst. Respond in Chinese."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=2048,
            temperature=0.7,
        )

        analysis = response.choices[0].message.content

        return {
            "analysis": analysis,
            "suburb": suburb,
            "data_dimensions": {
                "price": bool(profile.get("price")),
                "poi": bool(profile.get("poi")),
                "crime": bool(profile.get("crime")),
                "transport": bool(profile.get("transport")),
                "schools": bool(profile.get("schools")),
                "compass_score": bool(profile.get("compass_score")),
                "zoning": bool(profile.get("zoning")),
            }
        }
    except HTTPException:
        raise
    except Exception as e:
        print(f"AI Analysis error: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"AI analysis failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8888)
