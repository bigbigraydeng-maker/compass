"""
Compass MVP FastAPI 主应用
v1.1.1 - 多维度 AI 决策引擎 (Moonshot Kimi 2.5) + DB Connection Resilience
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
        print("[INFO] Connecting to Supabase (with retry)...")
        from database import test_connection, execute_query as real_execute_query
        test_connection()
        print("[OK] Connected to Supabase")
        print(f"   DB: {DATABASE_URL[:30]}...")
        USING_REAL_DB = True
        execute_query = real_execute_query
    except Exception as e:
        print(f"[ERROR] DB connection failed after all retries: {e}")
        print(f"[ERROR] Please check DATABASE_URL and Supabase status")
        raise SystemExit(1)
else:
    print("[ERROR] DATABASE_URL not configured")
    print("[ERROR] Set DATABASE_URL environment variable in Render dashboard")
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


@app.get("/api/suburb/{suburb_name}/rental")
def get_suburb_rental(suburb_name: str):
    """获取郊区租赁回报数据"""
    import os
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "data", "suburb_rental_yields.json")
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            all_data = json.load(f)
        # 匹配郊区名（不区分大小写）
        for key, val in all_data.items():
            if key.lower() == suburb_name.lower():
                return {"suburb": key, **val}
        return {"suburb": suburb_name, "error": "No rental data found"}
    except Exception as e:
        return {"suburb": suburb_name, "error": str(e)}


@app.get("/api/suburb/{suburb_name}/flood")
def get_suburb_flood(suburb_name: str):
    """获取郊区洪水风险数据"""
    import os
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "data", "suburb_flood_risk.json")
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            all_data = json.load(f)
        for key, val in all_data.items():
            if key.lower() == suburb_name.lower():
                return {"suburb": key, **val}
        return {"suburb": suburb_name, "error": "No flood data found"}
    except Exception as e:
        return {"suburb": suburb_name, "error": str(e)}


@app.get("/api/suburb/{suburb_name}/development")
def get_suburb_development(suburb_name: str):
    """获取郊区政府发展规划数据"""
    import os
    script_dir = os.path.dirname(os.path.abspath(__file__))
    json_path = os.path.join(script_dir, "data", "suburb_development.json")
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            all_data = json.load(f)
        for key, val in all_data.items():
            if key.lower() == suburb_name.lower():
                return {"suburb": key, **val}
        return {"suburb": suburb_name, "error": "No development data found"}
    except Exception as e:
        return {"suburb": suburb_name, "error": str(e)}


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
    获取郊区的分区信息（基于 Brisbane City Plan 2014 真实数据）
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    zoning_path = os.path.join(script_dir, "data", "suburb_zoning.json")
    try:
        with open(zoning_path, "r", encoding="utf-8") as f:
            all_zoning = json.load(f)
        # Case-insensitive match
        for key, zones in all_zoning.items():
            if key.lower() == suburb_name.lower():
                return ZoningResponse(suburb=suburb_name, zones=zones)
    except Exception as e:
        print(f"Error loading zoning data: {e}")

    # Fallback
    return ZoningResponse(suburb=suburb_name, zones=[
        {"zone_code": "LDR", "zone_name": "Low Density Residential", "percentage": 60},
        {"zone_code": "OTHER", "zone_name": "Other", "percentage": 40}
    ])


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
    获取捡漏雷达数据（优化版：单次SQL完成，数据库端过滤）

    原：3次全表扫描 + Python端循环筛选
    优化后：1次窗口函数查询，数据库直接返回捡漏结果
    """
    try:
        from database import get_db_connection, get_db_cursor

        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                # 一次查询完成：窗口函数计算中位价 → 直接筛选低估10%以上
                cur.execute("""
                    WITH median_prices AS (
                        SELECT
                            suburb,
                            property_type,
                            bedrooms,
                            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sale_price) as median_price
                        FROM sales
                        GROUP BY suburb, property_type, bedrooms
                    ),
                    fallback_medians AS (
                        SELECT
                            suburb,
                            property_type,
                            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sale_price) as median_price
                        FROM sales
                        GROUP BY suburb, property_type
                    )
                    SELECT
                        s.sale_id AS id, s.property_id,
                        s.sale_price AS sold_price, s.sale_date AS sold_date,
                        s.full_address AS address, INITCAP(s.suburb) AS suburb,
                        s.property_type, s.land_size, s.bedrooms, s.bathrooms,
                        COALESCE(mp.median_price, fm.median_price) as median_price,
                        ROUND(
                            ((COALESCE(mp.median_price, fm.median_price) - s.sale_price)
                             / NULLIF(COALESCE(mp.median_price, fm.median_price), 0) * 100)::numeric,
                            1
                        ) as discount_percent
                    FROM sales s
                    LEFT JOIN median_prices mp
                        ON LOWER(s.suburb) = LOWER(mp.suburb)
                        AND LOWER(s.property_type) = LOWER(mp.property_type)
                        AND s.bedrooms = mp.bedrooms
                    LEFT JOIN fallback_medians fm
                        ON LOWER(s.suburb) = LOWER(fm.suburb)
                        AND LOWER(s.property_type) = LOWER(fm.property_type)
                    WHERE COALESCE(mp.median_price, fm.median_price) > 0
                      AND s.sale_price < COALESCE(mp.median_price, fm.median_price) * 0.9
                    ORDER BY discount_percent DESC
                    LIMIT 10
                """)
                deals = [dict(row) for row in cur.fetchall()]

                # 转换 Decimal 类型
                for deal in deals:
                    for k in ['sold_price', 'median_price', 'discount_percent', 'land_size']:
                        if deal.get(k) is not None:
                            deal[k] = float(deal[k])

        return {
            "deals": deals,
            "total": len(deals)
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"获取捡漏数据失败: {str(e)}")


@app.get("/api/rankings")
def get_rankings():
    """
    获取郊区 Compass Score 排名（优化版：批量查询代替 N+1）

    原：7个郊区 × 6-7条SQL = 42-49次查询
    优化后：3次批量查询 + 内存计算
    """
    try:
        import json as json_mod
        from database import get_db_connection, get_db_cursor

        suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']

        # 读取配置（1次文件读取）
        config_path = os.path.join(os.path.dirname(__file__), "suburb_scores_config.json")
        with open(config_path) as f:
            config = json_mod.load(f)

        # 读取学校数据（1次文件读取）
        schools_data = []
        schools_path = os.path.join(os.path.dirname(__file__), "data/qld_schools.json")
        if os.path.exists(schools_path):
            with open(schools_path) as f:
                schools_data = json_mod.load(f)

        # === 批量查询 1：所有郊区的增长率 + 中位价 + 年成交量 ===
        with get_db_connection() as conn:
            with get_db_cursor(conn) as cur:
                cur.execute("""
                    SELECT
                        INITCAP(s.suburb) AS suburb,
                        AVG(CASE WHEN s.sale_date >= NOW() - INTERVAL '12 months' THEN s.sale_price END) as recent_avg,
                        AVG(CASE WHEN s.sale_date BETWEEN NOW() - INTERVAL '24 months' AND NOW() - INTERVAL '12 months' THEN s.sale_price END) as prev_avg,
                        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                        COUNT(CASE WHEN s.sale_date >= NOW() - INTERVAL '12 months' THEN 1 END) as annual_sales
                    FROM sales s
                    WHERE UPPER(s.suburb) IN (SELECT UPPER(unnest) FROM unnest(%s::text[]))
                    GROUP BY INITCAP(s.suburb)
                """, (suburbs,))
                sales_stats = {row['suburb']: row for row in cur.fetchall()}

                # === 批量查询 2：所有郊区的活跃房源数 ===
                cur.execute("""
                    SELECT INITCAP(suburb) AS suburb, COUNT(*) as cnt
                    FROM listings
                    WHERE UPPER(suburb) IN (SELECT UPPER(unnest) FROM unnest(%s::text[]))
                    GROUP BY INITCAP(suburb)
                """, (suburbs,))
                listings_counts = {row['suburb']: row['cnt'] for row in cur.fetchall()}

                # === 批量查询 3：所有郊区的空地数量 ===
                cur.execute("""
                    SELECT INITCAP(suburb) AS suburb, COUNT(*) as cnt
                    FROM listings
                    WHERE UPPER(suburb) IN (SELECT UPPER(unnest) FROM unnest(%s::text[]))
                      AND property_type = 'vacant_land'
                    GROUP BY INITCAP(suburb)
                """, (suburbs,))
                land_counts = {row['suburb']: row['cnt'] for row in cur.fetchall()}

        # === 内存计算所有评分 ===
        zoning_map = {
            "Sunnybank": {"MDR": 20, "HDR": 0}, "Eight Mile Plains": {"MDR": 25, "HDR": 5},
            "Calamvale": {"MDR": 15, "HDR": 0}, "Rochedale": {"MDR": 20, "HDR": 0},
            "Mansfield": {"MDR": 15, "HDR": 0}, "Ascot": {"MDR": 10, "HDR": 5},
            "Hamilton": {"MDR": 15, "HDR": 10},
        }

        rankings = []
        for suburb in suburbs:
            stats = sales_stats.get(suburb, {})

            # 1. 增长潜力 (25分)
            growth_score = 12
            recent = stats.get('recent_avg')
            prev = stats.get('prev_avg')
            if recent and prev and float(prev) > 0:
                growth_rate = (float(recent) - float(prev)) / float(prev)
                if growth_rate >= 0.15: growth_score = 25
                elif growth_rate >= 0.10: growth_score = 20
                elif growth_rate >= 0.05: growth_score = 15
                elif growth_rate >= 0: growth_score = 10
                else: growth_score = 5

            # 2. 学区质量 (25分)
            school_score = 12
            top_naplan = 0
            for school in schools_data:
                catchments = school.get("catchment_suburbs", [])
                if isinstance(catchments, str):
                    catchments = [catchments]
                if suburb.upper() in [c.upper() for c in catchments]:
                    naplan = school.get("naplan_percentile", 0) or 0
                    top_naplan = max(top_naplan, naplan)
            if top_naplan > 0:
                school_score = round((top_naplan / 100) * 25)

            # 3. 土地价值 (20分)
            zm = zoning_map.get(suburb, {"MDR": 10, "HDR": 0})
            mdr_hdr_pct = zm["MDR"] + zm["HDR"]
            median_price = float(stats.get('median_price', 0) or 0)
            has_land = land_counts.get(suburb, 0) > 0
            median_bonus = min(5, int(median_price / 300000))
            land_score = min(20, round(mdr_hdr_pct / 100 * 12) + (3 if has_land else 0) + median_bonus)

            # 4. 市场活跃度 (15分)
            annual_sales = int(stats.get('annual_sales', 0) or 0)
            active_listings = max(listings_counts.get(suburb, 0), 1)
            activity_ratio = annual_sales / active_listings
            activity_score = min(15, round(activity_ratio * 5))

            # 5. 华人友好度 (15分)
            chinese_score = config["chinese_friendly"].get(suburb, 8)

            total = growth_score + school_score + land_score + activity_score + chinese_score
            grade = "S" if total >= 85 else "A" if total >= 75 else "B" if total >= 65 else "C"

            rankings.append({
                "suburb": suburb,
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
            })

        rankings.sort(key=lambda x: x['total_score'], reverse=True)
        for i, ranking in enumerate(rankings, 1):
            ranking['rank'] = i

        return {"rankings": rankings, "updated_at": "2026-03"}
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


@app.get("/api/suburb/{suburb_name}/crime")
def get_suburb_crime(suburb_name: str):
    """
    获取郊区治安数据（近12个月犯罪统计）
    """
    try:
        # 按类别汇总
        summary_query = """
            SELECT category, SUM(count) as total
            FROM crime_stats
            WHERE LOWER(suburb) = LOWER(%s)
              AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM')
            GROUP BY category
            ORDER BY total DESC
        """
        summary_results = execute_query(summary_query, (suburb_name,))

        categories = {}
        grand_total = 0
        for row in summary_results:
            cat = row.get('category', 'unknown')
            total = int(row.get('total', 0))
            categories[cat] = total
            grand_total += total

        # 月度趋势
        trend_query = """
            SELECT month_year, SUM(count) as total
            FROM crime_stats
            WHERE LOWER(suburb) = LOWER(%s)
              AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM')
            GROUP BY month_year
            ORDER BY month_year
        """
        trend_results = execute_query(trend_query, (suburb_name,))
        monthly_trend = []
        for row in trend_results:
            monthly_trend.append({
                "month": row.get('month_year', ''),
                "total": int(row.get('total', 0)),
            })

        return {
            "suburb": suburb_name,
            "categories": categories,
            "total_crimes": grand_total,
            "monthly_trend": monthly_trend,
            "period": "last 12 months"
        }
    except Exception as e:
        return {
            "suburb": suburb_name,
            "categories": {},
            "total_crimes": 0,
            "monthly_trend": [],
            "period": "last 12 months"
        }


@app.get("/api/suburb/{suburb_name}/transport")
def get_suburb_transport(suburb_name: str):
    """
    获取郊区公共交通数据（5km范围内站点）
    """
    try:
        # 按类型汇总
        summary_query = """
            SELECT type, COUNT(*) as cnt
            FROM transport_data
            WHERE LOWER(suburb) = LOWER(%s)
            GROUP BY type
            ORDER BY cnt DESC
        """
        summary_results = execute_query(summary_query, (suburb_name,))

        by_type = {}
        total_stations = 0
        for row in summary_results:
            t = row.get('type', 'unknown')
            cnt = int(row.get('cnt', 0))
            by_type[t] = cnt
            total_stations += cnt

        # 站点列表（按类型分组，每类取前5个）
        stations_query = """
            SELECT type, name, address, lat, lng
            FROM transport_data
            WHERE LOWER(suburb) = LOWER(%s)
            ORDER BY type, name
        """
        stations_results = execute_query(stations_query, (suburb_name,))

        stations_by_type = {}
        for row in stations_results:
            t = row.get('type', 'unknown')
            if t not in stations_by_type:
                stations_by_type[t] = []
            if len(stations_by_type[t]) < 5:
                stations_by_type[t].append({
                    "name": row.get('name', ''),
                    "address": row.get('address', ''),
                })

        return {
            "suburb": suburb_name,
            "by_type": by_type,
            "total_stations": total_stations,
            "stations_by_type": stations_by_type,
            "radius": "5km"
        }
    except Exception as e:
        return {
            "suburb": suburb_name,
            "by_type": {},
            "total_stations": 0,
            "stations_by_type": {},
            "radius": "5km"
        }


def _get_suburb_full_profile(suburb_name: str) -> dict:
    """
    聚合所有维度数据，构建郊区完整 profile。
    用于喂给 AI 引擎做投资决策分析。
    """
    profile = {
        "suburb": suburb_name,
        "price": {},
        "price_by_type": {},
        "price_trends": [],
        "recent_sales": [],
        "poi": {},
        "crime": {},
        "transport": {},
        "schools": [],
        "zoning": {},
        "compass_score": {},
    }

    try:
        # 1. 价格总览
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

        # Listings count + absorption rate
        listings_query = """
            SELECT COUNT(*) as cnt FROM listings WHERE LOWER(suburb) = LOWER(%s)
        """
        listings_result = execute_query(listings_query, (suburb_name,))
        if listings_result and len(listings_result) > 0:
            active = int(listings_result[0].get('cnt', 0) or 0)
            profile["price"]["active_listings"] = active

        # 1b. 按房型分类的中位价
        type_query = """
            SELECT
                s.property_type,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                COUNT(*) as cnt,
                AVG(CASE WHEN s.land_size > 0 THEN s.sale_price / s.land_size END) as avg_price_per_sqm
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
            GROUP BY s.property_type
            ORDER BY cnt DESC
        """
        type_results = execute_query(type_query, (suburb_name,))
        for row in type_results:
            pt = row.get('property_type', 'unknown')
            profile["price_by_type"][pt] = {
                "median_price": int(float(row.get('median_price', 0) or 0)),
                "count": int(row.get('cnt', 0)),
                "avg_price_per_sqm": int(float(row.get('avg_price_per_sqm', 0) or 0)),
            }

        # 1c. 月度价格趋势（最近12个月）
        trends_query = """
            SELECT
                TO_CHAR(s.sale_date, 'YYYY-MM') as month,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                COUNT(*) as sales_count
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
              AND s.sale_date >= NOW() - INTERVAL '12 months'
            GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM')
            ORDER BY month
        """
        trends_results = execute_query(trends_query, (suburb_name,))
        for row in trends_results:
            profile["price_trends"].append({
                "month": row.get('month', ''),
                "median_price": int(float(row.get('median_price', 0) or 0)),
                "sales_count": int(row.get('sales_count', 0)),
            })

        # 1d. 最近5笔成交（含户型、面积、单价）
        recent_query = """
            SELECT
                s.full_address AS address, s.sale_price, s.sale_date,
                s.property_type, s.bedrooms, s.bathrooms, s.land_size
            FROM sales s
            WHERE UPPER(s.suburb) = UPPER(%s)
            ORDER BY s.sale_date DESC
            LIMIT 5
        """
        recent_results = execute_query(recent_query, (suburb_name,))
        for row in recent_results:
            price = float(row.get('sale_price', 0) or 0)
            land = float(row.get('land_size', 0) or 0)
            profile["recent_sales"].append({
                "address": row.get('address', ''),
                "price": int(price),
                "date": str(row.get('sale_date', '')),
                "type": row.get('property_type', ''),
                "beds": row.get('bedrooms', 0),
                "baths": row.get('bathrooms', 0),
                "land_sqm": int(land),
                "price_per_sqm": int(price / land) if land > 0 else 0,
            })

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


@app.get("/api/suburb/{suburb_name}/all")
def get_suburb_all(suburb_name: str):
    """
    聚合端点：一次性返回郊区所有维度数据。
    使用线程池并行执行全部 DB 查询（~0.8s 代替串行 ~3s）。
    """
    import os as _os
    from concurrent.futures import ThreadPoolExecutor, as_completed
    script_dir = _os.path.dirname(_os.path.abspath(__file__))
    profile = {"suburb": suburb_name}

    # --- 各独立查询函数 ---
    def q_detail():
        rows = execute_query("SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price, COUNT(*) as total_sales FROM sales s WHERE UPPER(s.suburb) = UPPER(%s)", (suburb_name,))
        return {"median_price": float(rows[0].get('median_price',0) or 0), "total_sales": int(rows[0].get('total_sales',0))} if rows else {}

    def q_sales():
        rows = execute_query("SELECT s.full_address as address, s.sale_price as sold_price, s.sale_date as sold_date, s.property_type, s.bedrooms, s.bathrooms, s.land_size FROM sales s WHERE UPPER(s.suburb) = UPPER(%s) ORDER BY s.sale_date DESC LIMIT 10", (suburb_name,))
        return [dict(r) for r in rows] if rows else []

    def q_trends():
        rows = execute_query("SELECT TO_CHAR(s.sale_date, 'YYYY-MM') as month, PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price, COUNT(*) as total_sales FROM sales s WHERE UPPER(s.suburb) = UPPER(%s) AND s.sale_date >= NOW() - INTERVAL '12 months' GROUP BY TO_CHAR(s.sale_date, 'YYYY-MM') ORDER BY month", (suburb_name,))
        return [{"month": r.get("month",""), "median_price": float(r.get("median_price",0) or 0), "total_sales": int(r.get("total_sales",0))} for r in (rows or [])]

    def q_poi():
        rows = execute_query("SELECT category, COUNT(*) as cnt, ROUND(AVG(rating)::numeric, 1) as avg_rating FROM poi_data WHERE LOWER(suburb) = LOWER(%s) GROUP BY category", (suburb_name,))
        return {r.get('category','other'): {"count": int(r.get('cnt',0)), "avg_rating": float(r.get('avg_rating',0) or 0)} for r in (rows or [])}

    def q_crime():
        rows = execute_query("SELECT category, SUM(count) as total FROM crime_stats WHERE LOWER(suburb) = LOWER(%s) AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM') GROUP BY category ORDER BY total DESC", (suburb_name,))
        return {r.get('category','unknown'): int(r.get('total',0)) for r in (rows or [])}

    def q_transport():
        rows = execute_query("SELECT type, COUNT(*) as cnt FROM transport_data WHERE LOWER(suburb) = LOWER(%s) GROUP BY type", (suburb_name,))
        return {r.get('type','unknown'): int(r.get('cnt',0)) for r in (rows or [])}

    def q_land():
        rows = execute_query("SELECT l.address, l.price, l.price_text, l.land_size, l.link FROM listings l WHERE UPPER(l.suburb) = UPPER(%s) AND LOWER(l.property_type) = 'vacant_land' LIMIT 20", (suburb_name,))
        return [dict(r) for r in rows] if rows else []

    def q_score():
        return get_suburb_score(suburb_name)

    def q_zoning():
        try:
            z = get_suburb_zoning(suburb_name)
            return {"zones": [{"code": zi.zone_code, "name": zi.zone_name, "pct": zi.percentage} for zi in z.zones]}
        except Exception:
            return {}

    def q_schools():
        try:
            path = _os.path.join(script_dir, "data", "qld_schools.json")
            with open(path, "r", encoding="utf-8") as f:
                all_schools = json.load(f)
            matched = []
            for school in all_schools:
                if school.get('suburb','').lower() == suburb_name.lower():
                    matched.append(school)
                else:
                    catchment = school.get('catchment_suburbs', [])
                    if isinstance(catchment, list) and any(s.strip().lower() == suburb_name.lower() for s in catchment if isinstance(s, str)):
                        matched.append(school)
            return matched
        except Exception:
            return []

    # --- 并行执行全部查询 ---
    tasks = {"detail": q_detail, "recent_sales_list": q_sales, "monthly_trends": q_trends,
             "poi": q_poi, "crime": q_crime, "transport": q_transport,
             "land_listings": q_land, "score_raw": q_score, "zoning": q_zoning, "schools_full": q_schools}

    results = {}
    with ThreadPoolExecutor(max_workers=10) as pool:
        future_map = {pool.submit(fn): key for key, fn in tasks.items()}
        for future in as_completed(future_map):
            key = future_map[future]
            try:
                results[key] = future.result()
            except Exception as e:
                print(f"/all error [{key}]: {e}")
                results[key] = None

    # --- 组装 ---
    d = results.get("detail") or {}
    profile["median_price"] = d.get("median_price", 0)
    profile["total_sales"] = d.get("total_sales", 0)
    profile["recent_sales_list"] = results.get("recent_sales_list") or []
    profile["monthly_trends"] = results.get("monthly_trends") or []
    profile["poi"] = results.get("poi") or {}
    profile["crime"] = results.get("crime") or {}
    profile["transport"] = results.get("transport") or {}
    profile["land_listings"] = results.get("land_listings") or []
    profile["zoning"] = results.get("zoning") or {}
    profile["schools_full"] = results.get("schools_full") or []
    sc = results.get("score_raw") or {}
    profile["compass_score"] = {"total": sc.get("total_score",0), "grade": sc.get("grade","C"), "breakdown": sc.get("breakdown",{})}

    # JSON 文件（极快，无需线程）
    def _load_json(fn):
        try:
            with open(_os.path.join(script_dir, "data", fn), "r", encoding="utf-8") as f:
                data = json.load(f)
            for k, v in data.items():
                if k.lower() == suburb_name.lower():
                    return v
        except Exception:
            pass
        return None
    profile["rental"] = _load_json("suburb_rental_yields.json")
    profile["flood"] = _load_json("suburb_flood_risk.json")
    profile["development"] = _load_json("suburb_development.json")

    return profile


def _build_ai_prompt(address: str, suburb: str, profile: dict) -> str:
    """
    构建多维度结构化 prompt，喂给 Kimi K2.5。
    数据驱动，要求 AI 仅基于提供的数据做分析，不编造。
    """

    # === 1. Price Overview ===
    price = profile.get("price", {})
    active = price.get('active_listings', 0)
    total_12m = 0
    trends = profile.get("price_trends", [])
    for t in trends:
        total_12m += t.get("sales_count", 0)
    # absorption months = active / (monthly avg sales)
    monthly_avg = total_12m / max(len(trends), 1)
    absorption = round(active / monthly_avg, 1) if monthly_avg > 0 else 0

    price_section = f"""## 1. 价格总览
- 历史中位价: ${price.get('median_price', 0):,}
- 均价: ${price.get('avg_price', 0):,}
- 价格区间: ${price.get('min_price', 0):,} ~ ${price.get('max_price', 0):,}
- 历史总成交: {price.get('total_sales', 0)} 套
- 当前在售: {active} 套
- 近12个月成交: {total_12m} 套
- 库存去化周期: {absorption} 个月"""

    # === 2. Price by property type ===
    pbt = profile.get("price_by_type", {})
    type_label = {"house": "House独立屋", "unit": "Unit公寓", "townhouse": "Townhouse联排",
                  "vacant_land": "Vacant Land空地"}
    type_lines = []
    for pt, info in pbt.items():
        label = type_label.get(pt, pt)
        sqm_str = f", 土地均价${info['avg_price_per_sqm']:,}/sqm" if info.get('avg_price_per_sqm') else ""
        type_lines.append(f"- {label}: 中位价 ${info['median_price']:,} ({info['count']}套{sqm_str})")
    type_section = "## 2. 按房型分类\n" + ("\n".join(type_lines) if type_lines else "- 无数据")

    # === 3. Monthly trends ===
    trend_lines = []
    prev_price = None
    for t in trends:
        mp = t["median_price"]
        if prev_price and prev_price > 0:
            chg = (mp - prev_price) / prev_price * 100
            arrow = "+" if chg >= 0 else ""
            trend_lines.append(f"- {t['month']}: ${mp:,} ({arrow}{chg:.1f}%) | {t['sales_count']}套")
        else:
            trend_lines.append(f"- {t['month']}: ${mp:,} | {t['sales_count']}套")
        prev_price = mp
    # compute YoY if enough data
    yoy_str = ""
    if len(trends) >= 6:
        first_half = [t["median_price"] for t in trends[:len(trends)//2]]
        second_half = [t["median_price"] for t in trends[len(trends)//2:]]
        avg_first = sum(first_half) / len(first_half)
        avg_second = sum(second_half) / len(second_half)
        if avg_first > 0:
            yoy = (avg_second - avg_first) / avg_first * 100
            yoy_str = f"\n- 半年趋势: {'上涨' if yoy > 0 else '下跌'}{abs(yoy):.1f}%"
    trend_section = "## 3. 月度价格走势（近12月）\n" + ("\n".join(trend_lines) if trend_lines else "- 无数据") + yoy_str

    # === 4. Recent comparable sales ===
    recent = profile.get("recent_sales", [])
    recent_lines = []
    for s in recent:
        sqm_str = f" | ${s['price_per_sqm']:,}/sqm" if s.get('price_per_sqm') else ""
        recent_lines.append(
            f"- {s['date']} | ${s['price']:,} | {s['type']} {s['beds']}bed/{s['baths']}bath | {s['land_sqm']}sqm{sqm_str}"
        )
    recent_section = "## 4. 最近成交记录\n" + ("\n".join(recent_lines) if recent_lines else "- 无数据")

    # === 5. POI (Chinese community) ===
    poi_label_map = {
        "chinese_restaurant": "中餐厅", "asian_grocery": "亚洲超市",
        "chinese_school": "中文学校", "chinese_church": "华人教会",
        "chinese_clinic": "华人诊所", "chinese_hair_salon": "华人理发店",
    }
    poi = profile.get("poi", {})
    poi_lines = []
    total_poi = 0
    for cat, info in poi.items():
        label = poi_label_map.get(cat, cat)
        cnt = info.get('count', 0)
        total_poi += cnt
        poi_lines.append(f"- {label}: {cnt}家 (均分{info.get('avg_rating', 0)})")
    poi_section = f"## 5. 华人生活配套 (共{total_poi}家)\n" + ("\n".join(poi_lines) if poi_lines else "- 无数据")

    # === 6. Crime ===
    crime_label_map = {
        "violent_crime": "暴力犯罪", "property_crime": "入室盗窃",
        "theft_fraud": "盗窃诈骗", "drug_offences": "毒品犯罪",
        "public_order": "公共秩序",
    }
    crime = profile.get("crime", {})
    crime_lines = []
    crime_total = sum(crime.values()) if crime else 0
    for cat, count in crime.items():
        label = crime_label_map.get(cat, cat)
        crime_lines.append(f"- {label}: {count:,}起")
    crime_section = f"## 6. 治安数据 (近12月共{crime_total:,}起)\n" + ("\n".join(crime_lines) if crime_lines else "- 无数据")

    # === 7. Transport ===
    transport = profile.get("transport", {})
    transport_label = {"train_station": "火车站", "bus_station": "公交站",
                       "transit_station": "交通枢纽", "light_rail_station": "轻轨站"}
    transport_lines = []
    total_transport = sum(transport.values()) if transport else 0
    for t, cnt in transport.items():
        label = transport_label.get(t, t)
        transport_lines.append(f"- {label}: {cnt}个")
    transport_section = f"## 7. 公共交通 (5km内共{total_transport}个站点)\n" + ("\n".join(transport_lines) if transport_lines else "- 无数据")

    # === 8. Compass Score ===
    cs = profile.get("compass_score", {})
    breakdown = cs.get("breakdown", {})
    score_label_map = {
        "growth": "房价增长潜力", "school": "学区质量",
        "land": "土地价值潜力", "activity": "市场活跃度", "chinese": "华人友好度",
    }
    score_lines = []
    for key, item in breakdown.items():
        if isinstance(item, dict):
            label = score_label_map.get(key, key)
            score_lines.append(f"- {label}: {item.get('score', 0)}/{item.get('max', 0)}")
    score_section = f"## 8. Compass评分: {cs.get('total', 0)}/100 (等级: {cs.get('grade', 'N/A')})\n" + "\n".join(score_lines)

    # === 9. Zoning ===
    zoning = profile.get("zoning", {})
    zones = zoning.get("zones", [])
    zoning_lines = [f"- {z.get('name', '')}: {z.get('pct', 0)}%" for z in zones]
    zoning_section = "## 9. 土地规划\n" + ("\n".join(zoning_lines) if zoning_lines else "- 无数据")

    prompt = f"""你是一位专注布里斯班房产市场的资深投资分析师，精通华人投资者需求。

投资者正在考虑: **{address}** ({suburb}区)

以下是{suburb}区的【真实数据】，请**严格基于数据**进行分析，不要编造任何数据或假设：

{price_section}

{type_section}

{trend_section}

{recent_section}

{poi_section}

{crime_section}

{transport_section}

{score_section}

{zoning_section}

---

请基于以上**全部真实数据**，输出投资分析报告。严格要求：

## 1. 投资评级 (X/10)
给出评级并用2-3句话解释。必须引用具体数据支撑评分。

## 2. 核心优势 (3-4条)
每条必须引用具体数字。例如"中位价$XX万，近12月成交XX套"。

## 3. 风险警示 (2-3条)
必须引用具体数据。例如"近12月发生XX起盗窃案"。

## 4. 投资建议
- 推荐房型：基于按房型价格数据，明确推荐house/unit/townhouse
- 合理预算区间：基于中位价和最近成交
- 持有策略：短期/长期，给出具体理由
- 议价建议：基于库存去化周期和市场活跃度

## 5. 对比参考
与覆盖的其他6个区(Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton)做简要对比。

**输出要求：**
- 全中文回复
- 每个数据引用必须来自上面提供的数据，禁止编造
- 控制在1000字以内
- 语言风格：专业、直接、实用
"""
    return prompt


def _get_mode_system_prompt(mode: str) -> str:
    """根据分析模式返回不同的系统提示"""
    prompts = {
        "school": "你是一位专注布里斯班学区房投资的资深顾问，精通NAPLAN排名、学区划分、家庭友好度评估。请重点分析学区质量对房产投资价值的影响。全中文回复。",
        "first_home": "你是一位帮助首次置业者的布里斯班房产顾问，精通昆士兰州首次置业补贴(FHOG $30,000)、印花税减免、首置担保计划(5%首付)。请重点分析适合首次购房者的入门机会。全中文回复。",
        "overseas": "你是一位专注服务海外投资者的布里斯班房产顾问，精通FIRB审批流程、额外8%印花税(AFAD)、非居民CGT预扣12.5%、海外人士只能购买新房限制。请重点分析适合海外投资者的投资机会和合规要求。全中文回复。",
    }
    return prompts.get(mode, "You are a senior Brisbane real estate investment analyst. Respond in Chinese.")


def _get_mode_extra_instructions(mode: str) -> str:
    """根据分析模式返回额外的分析指引"""
    instructions = {
        "school": """
**额外分析重点（学区模式）：**
- NAPLAN 排名在全州的百分位，对学区房价的溢价效应
- 学区覆盖范围内的房源性价比
- 公立 vs 私立学校的选择建议
- 对有学龄儿童的华人家庭的具体推荐
""",
        "first_home": """
**额外分析重点（首次置业模式）：**
- 昆士兰首次置业补贴 FHOG $30,000（仅限新房/大翻新，房价≤$750,000）
- 印花税减免（首置新房≤$500,000全免，$500k-$550k递减）
- 首置担保计划（仅需5%首付，无需LMI）
- 推荐适合首次购房者的入门户型和预算区间
- 月供估算（按当前利率约6.5%）
""",
        "overseas": """
**额外分析重点（海外人士模式）：**
- FIRB 审批要求和费用（房价<$75万约$14,100，$75万-$100万约$28,200）
- AFAD 额外印花税 8%（昆士兰州附加）
- 海外人士只能购买全新住宅或空地（不能购买二手房）
- CGT 预扣税 12.5%（出售时）
- 非居民租金收入预扣税
- 推荐适合海外投资者的新房项目和开发区
""",
    }
    return instructions.get(mode, "")


@app.post("/api/analyze")
def analyze_property(address: str = Body(...), url: str = Body(None), mode: str = Body("general")):
    """
    AI 多维度投资分析接口

    聚合 POI、治安、交通、学区、分区等多维数据，
    通过 Moonshot Kimi 2.5 生成结构化投资决策报告。

    mode: "general" | "school" | "first_home" | "overseas"
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

        # 2. 构建 AI prompt（基础 + 模式额外指引）
        prompt = _build_ai_prompt(address, suburb, profile)
        extra = _get_mode_extra_instructions(mode)
        if extra:
            prompt += extra

        # 3. 调用 Moonshot Kimi 2.5 API
        moonshot_key = os.getenv("MOONSHOT_API_KEY", "")
        if not moonshot_key:
            raise HTTPException(status_code=500, detail="MOONSHOT_API_KEY not configured")

        from openai import OpenAI
        client = OpenAI(
            api_key=moonshot_key,
            base_url="https://api.moonshot.cn/v1"
        )

        system_prompt = _get_mode_system_prompt(mode)

        response = client.chat.completions.create(
            model="kimi-k2.5",
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            max_tokens=4096,
            temperature=1.0,
        )

        analysis = response.choices[0].message.content

        return {
            "analysis": analysis,
            "suburb": suburb,
            "mode": mode,
            "data_dimensions": {
                "price": bool(profile.get("price")),
                "price_by_type": bool(profile.get("price_by_type")),
                "price_trends": bool(profile.get("price_trends")),
                "recent_sales": bool(profile.get("recent_sales")),
                "poi": bool(profile.get("poi")),
                "crime": bool(profile.get("crime")),
                "transport": bool(profile.get("transport")),
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


@app.get("/api/schools")
def get_all_schools(suburb: Optional[str] = None, school_type: Optional[str] = None):
    """
    获取学校列表，按 NAPLAN 分数排序

    参数：
    - suburb: 按郊区过滤（可选）
    - school_type: 按学校类型过滤 primary/secondary/combined（可选）
    """
    try:
        schools_path = os.path.join(os.path.dirname(__file__), "data/qld_schools.json")
        with open(schools_path, "r", encoding="utf-8") as f:
            all_schools = json.load(f)

        # 过滤
        filtered = all_schools
        if suburb:
            filtered = [s for s in filtered if (
                s.get('suburb', '').lower() == suburb.lower() or
                suburb.lower() in [c.lower() for c in (s.get('catchment_suburbs', []) if isinstance(s.get('catchment_suburbs', []), list) else [s.get('catchment_suburbs', '')])]
            )]
        if school_type:
            filtered = [s for s in filtered if s.get('school_type', '').lower() == school_type.lower()]

        # 按 NAPLAN 分数排序
        filtered.sort(key=lambda x: x.get('naplan_percentile', 0) or 0, reverse=True)

        return {"schools": filtered, "total": len(filtered)}
    except Exception as e:
        return {"schools": [], "total": 0}


@app.post("/api/chat")
def chat_with_advisor(
    message: str = Body(...),
    context: str = Body("general"),
    history: list = Body([])
):
    """
    AI 聊天顾问接口

    参数：
    - message: 用户消息
    - context: 场景 "first_home" | "overseas" | "general"
    - history: 对话历史 [{"role": "user"|"assistant", "content": "..."}]
    """
    try:
        moonshot_key = os.getenv("MOONSHOT_API_KEY", "")
        if not moonshot_key:
            raise HTTPException(status_code=500, detail="MOONSHOT_API_KEY not configured")

        from openai import OpenAI
        client = OpenAI(
            api_key=moonshot_key,
            base_url="https://api.moonshot.cn/v1"
        )

        system_prompts = {
            "first_home": """你是 Compass AI 首次置业顾问，专注帮助在布里斯班首次购房的华人买家。你精通：
- 昆士兰首次置业补贴 (FHOG $30,000，仅限新房，房价≤$750,000)
- 印花税减免政策（首置新房≤$500,000全免）
- 首置担保计划（5%首付，免LMI）
- 布里斯班各郊区适合首次购房的入门区域
- 贷款预批、验房、交割流程
请用通俗易懂的中文回答，给出实用建议。每次回答控制在200字以内。""",
            "overseas": """你是 Compass AI 海外投资顾问，专注帮助海外华人投资者在布里斯班购房。你精通：
- FIRB 审批流程和费用（<$75万约$14,100）
- AFAD 额外印花税 8%（昆士兰附加费）
- 海外人士只能购买全新住宅或空地
- CGT 预扣税 12.5%
- 非居民租金收入税务处理
- 布里斯班新楼盘和开发区推荐
请用专业但通俗的中文回答，给出实用建议。每次回答控制在200字以内。""",
        }

        system_content = system_prompts.get(context, "你是 Compass AI 布里斯班房产投资顾问，帮助华人投资者做出明智的房产投资决策。用中文回答，每次回答控制在200字以内。")

        # 构建消息列表
        messages = [{"role": "system", "content": system_content}]

        # 添加历史对话（限制最近10轮）
        for h in history[-20:]:
            if h.get("role") in ["user", "assistant"] and h.get("content"):
                messages.append({"role": h["role"], "content": h["content"]})

        messages.append({"role": "user", "content": message})

        response = client.chat.completions.create(
            model="kimi-k2.5",
            messages=messages,
            max_tokens=1024,
            temperature=1.0,
        )

        reply = response.choices[0].message.content

        # 生成建议后续问题
        suggestions_map = {
            "first_home": [
                "首次置业补贴具体怎么申请？",
                "哪些郊区适合首次购房？",
                "50万预算能买什么样的房？",
                "贷款预批需要什么材料？",
            ],
            "overseas": [
                "FIRB申请需要多长时间？",
                "布里斯班有哪些新楼盘推荐？",
                "海外人士贷款能贷多少？",
                "购房后如何管理出租？",
            ],
        }
        suggestions = suggestions_map.get(context, [
            "哪个郊区投资回报最高？",
            "现在是买房的好时机吗？",
            "布里斯班房价还会涨吗？",
        ])

        return {
            "reply": reply,
            "suggestions": suggestions,
        }
    except HTTPException:
        raise
    except Exception as e:
        print(f"Chat error: {e}")
        raise HTTPException(status_code=500, detail=f"Chat failed: {str(e)}")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8888)
