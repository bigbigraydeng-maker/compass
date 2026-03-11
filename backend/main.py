"""
Compass MVP FastAPI 主应用
v1.2.0 - 多维度 AI 决策引擎 (Moonshot Kimi 2.5) + 安全加固
"""
from fastapi import FastAPI, HTTPException, Body, Request, Form, File, UploadFile
from fastapi.responses import StreamingResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from typing import List, Optional
from datetime import date, timedelta
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
import os
import json
from dotenv import load_dotenv

# 加载 .env 文件
load_dotenv()

print("Compass API v1.5.0 - Dual AI Engine (OpenAI + Moonshot)")

# ====== Centralized AI Client Factory ======
from openai import OpenAI as _OpenAI_SDK

def _get_ai_client():
    """
    Returns (client, model, temperature) tuple.
    Priority: OpenAI gpt-4o-mini (fast) > Moonshot (fallback).
    """
    openai_key = os.getenv("OPENAI_API_KEY", "")
    moonshot_key = os.getenv("MOONSHOT_API_KEY", "")

    if openai_key:
        return (
            _OpenAI_SDK(api_key=openai_key),
            "gpt-4o-mini",
            0.7,
        )
    elif moonshot_key:
        return (
            _OpenAI_SDK(api_key=moonshot_key, base_url="https://api.moonshot.cn/v1"),
            "moonshot-v1-32k",
            0.7,
        )
    else:
        raise RuntimeError("No AI API key configured. Set OPENAI_API_KEY or MOONSHOT_API_KEY.")

def _get_ai_client_vision():
    """
    Returns (client, model, temperature) for vision-capable tasks.
    Priority: OpenAI gpt-4o-mini (fast + vision) > Kimi K2.5 (vision) > Moonshot (no vision).
    """
    openai_key = os.getenv("OPENAI_API_KEY", "")
    moonshot_key = os.getenv("MOONSHOT_API_KEY", "")

    if openai_key:
        return (
            _OpenAI_SDK(api_key=openai_key),
            "gpt-4o-mini",
            0.7,
        )
    elif moonshot_key:
        return (
            _OpenAI_SDK(api_key=moonshot_key, base_url="https://api.moonshot.cn/v1"),
            "kimi-k2.5",
            1,  # kimi-k2.5 requires temperature=1
        )
    else:
        raise RuntimeError("No AI API key configured.")

# Log which AI provider is active
_ai_provider = "OpenAI" if os.getenv("OPENAI_API_KEY") else "Moonshot" if os.getenv("MOONSHOT_API_KEY") else "NONE"
print(f"[AI] Primary provider: {_ai_provider}")

# 集中化区域配置
from suburbs_config import ALL_SUBURB_NAMES, CORE_SUBURB_NAMES, SUBURBS as SUBURB_CONFIG, get_zoning_scores, get_police_division_map

# DevIntel - Brisbane Development Intelligence RAG
try:
    from devintel import devintel_router, init_devintel_tables
    _DEVINTEL_AVAILABLE = True
    print("[OK] DevIntel module loaded")
except ImportError as e:
    _DEVINTEL_AVAILABLE = False
    print(f"[WARN] DevIntel not available: {e}")

# ====== Rate Limiter ======
limiter = Limiter(key_func=get_remote_address)


# ====== Security Headers Middleware ======
class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["X-Frame-Options"] = "DENY"
        response.headers["X-XSS-Protection"] = "1; mode=block"
        response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
        response.headers["Permissions-Policy"] = "camera=(), microphone=(), geolocation=()"
        return response

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

# ====== 新闻系统数据库表 ======
try:
    execute_query("""
        CREATE TABLE IF NOT EXISTS news_articles (
            id SERIAL PRIMARY KEY,
            url_hash VARCHAR(32) UNIQUE NOT NULL,
            title TEXT NOT NULL,
            source VARCHAR(200),
            summary TEXT,
            link TEXT NOT NULL,
            category VARCHAR(50) DEFAULT '市场动态',
            category_color VARCHAR(60),
            pub_date DATE,
            created_at TIMESTAMP DEFAULT NOW()
        )
    """)
    execute_query("CREATE INDEX IF NOT EXISTS idx_news_articles_pub_date ON news_articles(pub_date DESC)")
    execute_query("CREATE INDEX IF NOT EXISTS idx_news_articles_category ON news_articles(category)")

    execute_query("""
        CREATE TABLE IF NOT EXISTS news_commentaries (
            id SERIAL PRIMARY KEY,
            pub_date DATE NOT NULL,
            period VARCHAR(10) NOT NULL,
            content TEXT NOT NULL,
            article_ids INTEGER[],
            created_at TIMESTAMP DEFAULT NOW(),
            UNIQUE(pub_date, period)
        )
    """)
    execute_query("CREATE INDEX IF NOT EXISTS idx_news_commentaries_date ON news_commentaries(pub_date DESC)")
    print("[OK] News tables ready")
except Exception as e:
    print(f"[WARN] News tables creation: {e}")

# ====== 風水記錄數據庫表 ======
try:
    execute_query("""
        CREATE TABLE IF NOT EXISTS fengshui_records (
            id SERIAL PRIMARY KEY,
            address TEXT NOT NULL,
            suburb VARCHAR(100),
            rating VARCHAR(2) NOT NULL,
            summary TEXT,
            center_elevation REAL,
            has_backing BOOLEAN DEFAULT FALSE,
            backing_direction VARCHAR(10),
            has_water BOOLEAN DEFAULT FALSE,
            negative_count INTEGER DEFAULT 0,
            positive_count INTEGER DEFAULT 0,
            total_crime INTEGER DEFAULT 0,
            has_floor_plan BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT NOW(),
            address_hash VARCHAR(32) UNIQUE NOT NULL
        )
    """)
    execute_query("CREATE INDEX IF NOT EXISTS idx_fengshui_rating ON fengshui_records(rating)")
    execute_query("CREATE INDEX IF NOT EXISTS idx_fengshui_created ON fengshui_records(created_at DESC)")
    # 添加 full_content 列（兼容已有表）
    try:
        execute_query("ALTER TABLE fengshui_records ADD COLUMN IF NOT EXISTS full_content TEXT")
    except Exception:
        pass
    print("[OK] Fengshui records table ready")
except Exception as e:
    print(f"[WARN] Fengshui records table creation: {e}")

# ====== DevIntel 表创建 ======
if _DEVINTEL_AVAILABLE:
    try:
        init_devintel_tables()
    except Exception as e:
        print(f"[WARN] DevIntel tables init: {e}")

# 创建 FastAPI 应用
app = FastAPI(
    title="Compass MVP API",
    description="布里斯班华人房产数据平台 API",
    version="1.0.0"
)

# ====== 安全中间件 ======
# Rate Limiter
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# Security Headers
app.add_middleware(SecurityHeadersMiddleware)

# CORS — 允许所有来源（前端为静态站点，CORS 限制意义不大）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ====== DevIntel Router ======
if _DEVINTEL_AVAILABLE:
    app.include_router(devintel_router)
    print("[OK] DevIntel API routes registered at /api/devintel/*")


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
        suburbs = ALL_SUBURB_NAMES
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
        print(f"[ERROR] 获取首页数据失败: {e}")
        raise HTTPException(status_code=500, detail="获取首页数据失败，请稍后重试")


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
        print(f"[ERROR] 获取成交列表失败: {e}")
        raise HTTPException(status_code=500, detail="获取成交列表失败，请稍后重试")


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
        print(f"[ERROR] 获取郊区详情失败: {e}")
        raise HTTPException(status_code=500, detail="获取郊区详情失败，请稍后重试")


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
        print(f"[ERROR] 获取价格走势失败: {e}")
        raise HTTPException(status_code=500, detail="获取价格走势失败，请稍后重试")


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
        print(f"[ERROR] 获取在售房源列表失败: {e}")
        raise HTTPException(status_code=500, detail="获取在售房源列表失败，请稍后重试")


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
                    # 支持 naplan_score (绝对分 300-700) 和 naplan_percentile (百分位 0-100)
                    naplan = school.get("naplan_percentile", 0) or 0
                    naplan_abs = school.get("naplan_score", 0) or 0
                    if naplan_abs > 0 and naplan == 0:
                        # 将绝对分转换为百分位: 300=0%, 500=50%, 600=80%, 700=100%
                        naplan = max(0, min(100, round((naplan_abs - 300) / 4)))
                    top_naplan = max(top_naplan, naplan)

            if top_naplan > 0:
                school_score = max(1, round((top_naplan / 100) * 25))
    except Exception as e:
        pass
    
    # 3. 土地价值潜力 (20分)
    # MDR+HDR zoning % + 是否有在售土地 + 中位价加成
    # 使用模拟分区数据（与 zoning API 一致）
    land_score = 10  # 默认中等
    
    try:
        zoning_map = get_zoning_scores()  # 从 suburbs_config 动态获取全部区
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
        print(f"[ERROR] 获取捡漏数据失败: {e}")
        raise HTTPException(status_code=500, detail="获取捡漏数据失败，请稍后重试")


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

        suburbs = ALL_SUBURB_NAMES

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
        zoning_map = get_zoning_scores()  # 从 suburbs_config 动态获取全部区

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
                    naplan_abs = school.get("naplan_score", 0) or 0
                    if naplan_abs > 0 and naplan == 0:
                        naplan = max(0, min(100, round((naplan_abs - 300) / 4)))
                    top_naplan = max(top_naplan, naplan)
            if top_naplan > 0:
                school_score = max(1, round((top_naplan / 100) * 25))

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
        print(f"[ERROR] 获取排名数据失败: {e}")
        raise HTTPException(status_code=500, detail="获取排名数据失败，请稍后重试")


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
                suburbs = ALL_SUBURB_NAMES
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
                    naplan_pct = school.get("naplan_percentile", 0) or 0
                    naplan_abs = school.get("naplan_score", 0) or 0
                    if naplan_abs > 0 and naplan_pct == 0:
                        naplan_pct = max(0, min(100, round((naplan_abs - 300) / 4)))
                    suburb_schools.append({
                        "name": school.get("name", ""),
                        "type": school.get("school_type", school.get("type", "")),
                        "naplan_percentile": naplan_pct,
                        "naplan_score": naplan_abs,
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

    # === 10. Development Intelligence (RAG) ===
    devintel_section = ""
    try:
        from devintel.rag import get_devintel_context
        devintel_section = get_devintel_context(suburb)
    except Exception as e:
        print(f"[DevIntel] RAG context error: {e}")
        devintel_section = ""

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

{devintel_section}

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
    """根据分析模式返回不同的系统提示 — 统一 Amanda 人格"""
    amanda_base = (
        "你是 Amanda，Compass 平台的首席房产分析师。"
        "你在布里斯班从事房产投资顾问工作超过 10 年，专注服务华人投资者。"
        "你的风格是：专业但亲切，像朋友聊天一样用大白话讲清楚问题。"
        "你会用数据说话，结合实战经验给出有深度的见解。"
        "你特别关注布里斯班南区华人聚集区（Sunnybank、Calamvale、Eight Mile Plains、Rochedale、Mansfield）"
        "以及北区优质区（Ascot、Hamilton）的市场变化。"
        "始终使用中文回复。"
    )
    mode_extras = {
        "school": "你同时也是学区房投资专家，精通NAPLAN排名、学区划分、家庭友好度评估。请重点分析学区质量对房产投资价值的影响。",
        "first_home": "你同时也是首次置业指导专家，精通昆士兰州首次置业补贴(FHOG $30,000)、印花税减免、首置担保计划(5%首付)。请重点分析适合首次购房者的入门机会。",
        "overseas": "你同时也是海外投资者服务专家，精通FIRB审批流程、额外8%印花税(AFAD)、非居民CGT预扣12.5%、海外人士只能购买新房限制。请重点分析适合海外投资者的投资机会和合规要求。",
    }
    extra = mode_extras.get(mode, "")
    return amanda_base + extra


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
@limiter.limit("10/minute")
def analyze_property(request: Request, address: str = Body(...), url: str = Body(None), mode: str = Body("general")):
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
            known_suburbs = ALL_SUBURB_NAMES
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

        # 3. 调用 AI API
        client, _model, _temp = _get_ai_client()

        system_prompt = _get_mode_system_prompt(mode)

        response = client.chat.completions.create(
            model=_model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt}
            ],
            max_tokens=4096,
            temperature=_temp,
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
        raise HTTPException(status_code=500, detail="AI 分析服务暂时不可用，请稍后重试")


@app.post("/api/analyze/stream")
@limiter.limit("10/minute")
def analyze_property_stream(request: Request, address: str = Body(...), url: str = Body(None), mode: str = Body("general")):
    """
    AI 流式分析接口 - SSE (Server-Sent Events)
    逐字输出分析结果，前端实时渲染。
    """
    # 从地址中提取郊区（自动覆盖 suburbs_config 中所有区域）
    suburb = "Sunnybank"
    if address:
        known_suburbs = ALL_SUBURB_NAMES  # 动态跟随 suburbs_config，无需手动维护
        address_lower = address.lower()
        for s in known_suburbs:
            if s.lower() in address_lower:
                suburb = s
                break
        else:
            parts = address.split(',')
            if len(parts) > 1:
                candidate = parts[-1].strip()
                for s in known_suburbs:
                    if s.lower() in candidate.lower():
                        suburb = s
                        break

    # 聚合数据 + 构建 prompt
    profile = _get_suburb_full_profile(suburb)
    prompt = _build_ai_prompt(address, suburb, profile)
    extra = _get_mode_extra_instructions(mode)
    if extra:
        prompt += extra

    system_prompt = _get_mode_system_prompt(mode)

    # 构建数据维度信息（先发送给前端）
    dimensions = {
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

    def event_generator():
        import json as _json
        try:
            # 先发送元数据
            meta = _json.dumps({"type": "meta", "suburb": suburb, "mode": mode, "data_dimensions": dimensions})
            yield f"data: {meta}\n\n"

            client, _model, _temp = _get_ai_client()

            stream = client.chat.completions.create(
                model=_model,
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": prompt}
                ],
                max_tokens=4096,
                temperature=_temp,
                stream=True,
            )

            for chunk in stream:
                if chunk.choices and chunk.choices[0].delta.content:
                    text = chunk.choices[0].delta.content
                    data = _json.dumps({"type": "content", "text": text})
                    yield f"data: {data}\n\n"

            # 发送完成信号
            yield f"data: {_json.dumps({'type': 'done'})}\n\n"

        except Exception as e:
            error_data = _json.dumps({"type": "error", "message": str(e)})
            yield f"data: {error_data}\n\n"

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        }
    )


# ========== 多模态分析 (Multimodal Analysis) ==========

import re as _re_early
import base64 as _b64

def _classify_input(text: str) -> tuple:
    """
    分类用户输入类型。
    返回 (type, value)
    type: 'domain_url' | 'rea_url' | 'address' | 'suburb' | 'freeform'
    """
    if not text:
        return ('freeform', '')
    text = text.strip()
    if 'domain.com.au' in text.lower():
        return ('domain_url', text)
    if 'realestate.com.au' in text.lower():
        return ('rea_url', text)
    text_lower = text.lower()
    # 检查是否是纯suburb名
    for s in ALL_SUBURB_NAMES:
        if text_lower.strip() == s.lower():
            return ('suburb', text)
    # 检查是否包含已知suburb名 + 有其他地址信息
    for s in ALL_SUBURB_NAMES:
        if s.lower() in text_lower:
            return ('address', text)
    # 检查是否匹配地址模式 (数字 + 街道)
    if _re_early.search(r'\d+\s+\w+\s+(st|street|rd|road|ave|avenue|dr|drive|ct|court|pl|place|cr|crescent|way|blvd|lane|ln|tce|terrace|pde|parade|cct|circuit|cl|close)', text_lower):
        return ('address', text)
    # 检查是否可能是suburb名（英文词，首字母大写格式或全小写）
    if _re_early.match(r'^[A-Za-z\s]+$', text.strip()) and len(text.strip().split()) <= 3:
        return ('suburb_candidate', text)
    return ('freeform', text)


def _extract_suburb_from_input(text: str) -> str:
    """从文本中提取已知的 suburb 名称"""
    if not text:
        return ""
    text_lower = text.lower()
    for s in ALL_SUBURB_NAMES:
        if s.lower() in text_lower:
            return s
    # 逗号分割尝试
    parts = text.split(',')
    if len(parts) > 1:
        candidate = parts[-1].strip()
        for s in ALL_SUBURB_NAMES:
            if s.lower() in candidate.lower():
                return s
    return ""


def _geocode_for_multimodal(address: str) -> dict:
    """
    用 Google Geocoding 解析地址，返回 suburb + 格式化地址。
    复用风水模块的 _geocode_address 逻辑，但不依赖其函数（避免循环/顺序问题）。
    """
    gmaps_key = os.getenv("GOOGLE_MAPS_API_KEY") or os.getenv("NEXT_PUBLIC_GOOGLE_MAPS_KEY", "")
    if not gmaps_key:
        return {"error": "GOOGLE_MAPS_API_KEY not configured"}
    try:
        import urllib.request as _ur
        import urllib.parse as _up
        params = _up.urlencode({
            "address": f"{address}, QLD, Australia",
            "key": gmaps_key,
            "region": "au",
            "components": "country:AU",
        })
        url = f"https://maps.googleapis.com/maps/api/geocode/json?{params}"
        req = _ur.Request(url)
        with _ur.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        if data.get("status") != "OK" or not data.get("results"):
            return {"error": f"地址无法识别: {data.get('status', 'NO_RESULTS')}"}
        result = data["results"][0]
        loc = result["geometry"]["location"]
        suburb = ""
        state = ""
        postcode = ""
        street_number = ""
        route = ""
        for comp in result.get("address_components", []):
            types = comp.get("types", [])
            if "locality" in types:
                suburb = comp["long_name"]
            if "administrative_area_level_1" in types:
                state = comp["short_name"]
            if "postal_code" in types:
                postcode = comp["long_name"]
            if "street_number" in types:
                street_number = comp["long_name"]
            if "route" in types:
                route = comp["long_name"]
        # 验证是否在 Queensland
        if state and state.upper() not in ("QLD", "QUEENSLAND"):
            return {"error": f"该地址不在Queensland范围内 ({state})"}
        return {
            "lat": loc["lat"],
            "lng": loc["lng"],
            "formatted_address": result.get("formatted_address", address),
            "suburb": suburb,
            "postcode": postcode,
            "street_number": street_number,
            "route": route,
            "full_street": f"{street_number} {route}".strip() if street_number or route else "",
        }
    except Exception as e:
        return {"error": f"地址解析失败: {str(e)}"}


def _search_address_sales(address: str, suburb: str = None) -> list:
    """
    在 sales 数据库中搜索该地址的历史成交记录。
    支持精确匹配 + 模糊匹配（同一条街道）。
    """
    results = {"exact": [], "same_street": []}
    try:
        # 精确地址匹配
        exact_query = """
            SELECT s.full_address, s.sale_price, s.sale_date, s.property_type,
                   s.bedrooms, s.bathrooms, s.land_size, INITCAP(s.suburb) as suburb,
                   CASE WHEN s.land_size > 0 THEN s.sale_price / s.land_size ELSE 0 END AS price_per_sqm
            FROM sales s
            WHERE LOWER(s.full_address) LIKE %s
            ORDER BY s.sale_date DESC
            LIMIT 10
        """
        addr_lower = address.lower().strip()
        exact_rows = execute_query(exact_query, (f"%{addr_lower}%",))
        for row in (exact_rows or []):
            results["exact"].append({
                "address": row.get("full_address", ""),
                "price": int(float(row.get("sale_price", 0) or 0)),
                "date": str(row.get("sale_date", "")),
                "type": row.get("property_type", ""),
                "beds": row.get("bedrooms", 0),
                "baths": row.get("bathrooms", 0),
                "land_sqm": int(float(row.get("land_size", 0) or 0)),
                "price_per_sqm": int(float(row.get("price_per_sqm", 0) or 0)),
                "suburb": row.get("suburb", ""),
            })

        # 同街道匹配（提取街道名）
        street_match = _re_early.search(
            r'\d+[A-Za-z]?\s+(.+?)(?:,|\s+(?:' + '|'.join(s.lower() for s in ALL_SUBURB_NAMES) + r'))',
            addr_lower
        )
        if not street_match and suburb:
            street_match = _re_early.search(
                r'\d+[A-Za-z]?\s+(.+?)(?:,|\s+' + suburb.lower() + r')',
                addr_lower
            )
        # 更宽松的街道提取
        if not street_match:
            street_match = _re_early.search(r'\d+[A-Za-z]?\s+(.+?\s+(?:st|street|rd|road|ave|avenue|dr|drive|ct|court|pl|place|cr|crescent|way|lane|ln|tce|terrace|pde|parade))', addr_lower)

        if street_match:
            street_name = street_match.group(1).strip()
            street_query = """
                SELECT s.full_address, s.sale_price, s.sale_date, s.property_type,
                       s.bedrooms, s.bathrooms, s.land_size, INITCAP(s.suburb) as suburb,
                       CASE WHEN s.land_size > 0 THEN s.sale_price / s.land_size ELSE 0 END AS price_per_sqm
                FROM sales s
                WHERE LOWER(s.full_address) LIKE %s
            """
            street_params = [f"%{street_name}%"]
            if suburb:
                street_query += " AND UPPER(s.suburb) = UPPER(%s)"
                street_params.append(suburb)
            street_query += " ORDER BY s.sale_date DESC LIMIT 15"
            street_rows = execute_query(street_query, tuple(street_params))
            # 排除已经在 exact 中的
            exact_addrs = {r["address"].lower() for r in results["exact"]}
            for row in (street_rows or []):
                fa = row.get("full_address", "")
                if fa.lower() not in exact_addrs:
                    results["same_street"].append({
                        "address": fa,
                        "price": int(float(row.get("sale_price", 0) or 0)),
                        "date": str(row.get("sale_date", "")),
                        "type": row.get("property_type", ""),
                        "beds": row.get("bedrooms", 0),
                        "baths": row.get("bathrooms", 0),
                        "land_sqm": int(float(row.get("land_size", 0) or 0)),
                        "price_per_sqm": int(float(row.get("price_per_sqm", 0) or 0)),
                        "suburb": row.get("suburb", ""),
                    })
    except Exception as e:
        print(f"Address sales search error: {e}")

    return results


def _get_nearby_suburbs(suburb: str) -> list:
    """返回地理相邻的区域（同 police_division = 地理相邻）"""
    target_info = SUBURB_CONFIG.get(suburb, {})
    target_div = target_info.get('police_division', '')
    if not target_div:
        return []
    return [s for s, info in SUBURB_CONFIG.items()
            if info.get('police_division') == target_div and s != suburb]


def _get_comparable_sales(
    suburb: str,
    property_type: str = None,
    bedrooms: int = None,
    months: int = 12,
    include_nearby: bool = True,
) -> dict:
    """
    查询可比销售数据：同区 + 周边区域的历史成交。
    """
    result = {
        "same_suburb": [],
        "nearby_suburbs": [],
        "stats": {},
    }

    try:
        # 构建同区查询
        conditions = ["UPPER(s.suburb) = UPPER(%s)"]
        params = [suburb]

        if property_type:
            conditions.append("LOWER(s.property_type) = LOWER(%s)")
            params.append(property_type)

        if bedrooms is not None and bedrooms > 0:
            conditions.append("s.bedrooms BETWEEN %s AND %s")
            params.extend([max(1, bedrooms - 1), bedrooms + 1])

        conditions.append(f"s.sale_date >= NOW() - INTERVAL '{months} months'")

        where_clause = " AND ".join(conditions)

        same_query = f"""
            SELECT s.full_address, s.sale_price, s.sale_date, s.property_type,
                   s.bedrooms, s.bathrooms, s.land_size,
                   CASE WHEN s.land_size > 0 THEN s.sale_price / s.land_size ELSE 0 END AS price_per_sqm
            FROM sales s
            WHERE {where_clause}
            ORDER BY s.sale_date DESC
            LIMIT 20
        """
        same_results = execute_query(same_query, tuple(params))
        prices = []
        for row in (same_results or []):
            price = float(row.get('sale_price', 0) or 0)
            prices.append(price)
            result["same_suburb"].append({
                "address": row.get('full_address', ''),
                "price": int(price),
                "date": str(row.get('sale_date', '')),
                "type": row.get('property_type', ''),
                "beds": row.get('bedrooms', 0),
                "baths": row.get('bathrooms', 0),
                "land_sqm": int(float(row.get('land_size', 0) or 0)),
                "price_per_sqm": int(float(row.get('price_per_sqm', 0) or 0)),
            })

        # 统计摘要
        if prices:
            sorted_prices = sorted(prices)
            mid = len(sorted_prices) // 2
            median = sorted_prices[mid] if len(sorted_prices) % 2 else (sorted_prices[mid-1] + sorted_prices[mid]) / 2
            result["stats"]["same_suburb_median"] = int(median)
            result["stats"]["same_suburb_avg"] = int(sum(prices) / len(prices))
            result["stats"]["same_suburb_min"] = int(min(prices))
            result["stats"]["same_suburb_max"] = int(max(prices))
            result["stats"]["same_suburb_count"] = len(prices)

        # 近6个月趋势
        try:
            trend_query = """
                SELECT
                    AVG(CASE WHEN s.sale_date >= NOW() - INTERVAL '6 months' THEN s.sale_price END) as recent_avg,
                    AVG(CASE WHEN s.sale_date < NOW() - INTERVAL '6 months'
                         AND s.sale_date >= NOW() - INTERVAL '12 months' THEN s.sale_price END) as older_avg
                FROM sales s
                WHERE UPPER(s.suburb) = UPPER(%s)
            """
            trend_params = [suburb]
            if property_type:
                trend_query += " AND LOWER(s.property_type) = LOWER(%s)"
                trend_params.append(property_type)
            trend_query += f" AND s.sale_date >= NOW() - INTERVAL '12 months'"

            trend_result = execute_query(trend_query, tuple(trend_params))
            if trend_result and trend_result[0]:
                recent = float(trend_result[0].get('recent_avg', 0) or 0)
                older = float(trend_result[0].get('older_avg', 0) or 0)
                if older > 0 and recent > 0:
                    change = (recent - older) / older * 100
                    result["stats"]["price_trend_6m"] = f"{'+' if change >= 0 else ''}{change:.1f}%"
        except Exception as e:
            print(f"Trend calc error: {e}")

        # 周边区域可比
        if include_nearby:
            nearby = _get_nearby_suburbs(suburb)
            if nearby:
                nearby_conditions = ["UPPER(s.suburb) IN (" + ",".join(["%s"] * len(nearby)) + ")"]
                nearby_params = list(nearby)
                if property_type:
                    nearby_conditions.append("LOWER(s.property_type) = LOWER(%s)")
                    nearby_params.append(property_type)
                if bedrooms is not None and bedrooms > 0:
                    nearby_conditions.append("s.bedrooms BETWEEN %s AND %s")
                    nearby_params.extend([max(1, bedrooms - 1), bedrooms + 1])
                nearby_conditions.append(f"s.sale_date >= NOW() - INTERVAL '{months} months'")

                nearby_where = " AND ".join(nearby_conditions)
                nearby_query = f"""
                    SELECT INITCAP(s.suburb) as suburb, s.full_address, s.sale_price, s.sale_date,
                           s.property_type, s.bedrooms, s.bathrooms, s.land_size
                    FROM sales s
                    WHERE {nearby_where}
                    ORDER BY s.sale_date DESC
                    LIMIT 20
                """
                nearby_results = execute_query(nearby_query, tuple(nearby_params))
                nearby_prices = []
                for row in (nearby_results or []):
                    price = float(row.get('sale_price', 0) or 0)
                    nearby_prices.append(price)
                    result["nearby_suburbs"].append({
                        "suburb": row.get('suburb', ''),
                        "address": row.get('full_address', ''),
                        "price": int(price),
                        "date": str(row.get('sale_date', '')),
                        "type": row.get('property_type', ''),
                        "beds": row.get('bedrooms', 0),
                        "baths": row.get('bathrooms', 0),
                        "land_sqm": int(float(row.get('land_size', 0) or 0)),
                    })

                if nearby_prices:
                    sorted_np = sorted(nearby_prices)
                    mid = len(sorted_np) // 2
                    n_median = sorted_np[mid] if len(sorted_np) % 2 else (sorted_np[mid-1] + sorted_np[mid]) / 2
                    result["stats"]["nearby_median"] = int(n_median)
                    result["stats"]["nearby_count"] = len(nearby_prices)

    except Exception as e:
        print(f"Comparable sales error: {e}")
        import traceback
        traceback.print_exc()

    return result


def _build_comparable_section(comparables: dict, property_type: str = None, bedrooms: int = None) -> str:
    """构建可比成交 prompt 段落"""
    stats = comparables.get("stats", {})
    same = comparables.get("same_suburb", [])
    nearby = comparables.get("nearby_suburbs", [])

    if not same and not nearby:
        return "## 10. 可比成交分析\n- 暂无足够可比成交数据"

    type_label = property_type or "所有类型"
    beds_label = f"{bedrooms}房" if bedrooms else "所有户型"

    lines = [f"## 10. 可比成交分析（近12个月，{type_label} {beds_label}）"]

    if same:
        lines.append(f"同区成交 {stats.get('same_suburb_count', len(same))} 套:")
        lines.append(f"- 中位价: ${stats.get('same_suburb_median', 0):,} | 均价: ${stats.get('same_suburb_avg', 0):,}")
        lines.append(f"- 区间: ${stats.get('same_suburb_min', 0):,} ~ ${stats.get('same_suburb_max', 0):,}")
        trend = stats.get("price_trend_6m", "")
        if trend:
            lines.append(f"- 近6个月趋势: {trend}")
        lines.append("- 最近成交:")
        for i, s in enumerate(same[:5]):
            sqm_str = f" | ${s['price_per_sqm']:,}/sqm" if s.get('price_per_sqm') else ""
            lines.append(f"  {i+1}. {s['address']} | ${s['price']:,} | {s['date']} | {s['type']} {s.get('beds',0)}房{s.get('baths',0)}卫 | {s.get('land_sqm',0)}sqm{sqm_str}")

    if nearby:
        nearby_suburbs = list(set(n.get('suburb', '') for n in nearby))
        lines.append(f"\n周边可比（{', '.join(nearby_suburbs[:3])}）成交 {stats.get('nearby_count', len(nearby))} 套:")
        lines.append(f"- 中位价: ${stats.get('nearby_median', 0):,}")
        for i, n in enumerate(nearby[:3]):
            lines.append(f"  {i+1}. {n.get('suburb','')} {n['address']} | ${n['price']:,} | {n['date']}")

    return "\n".join(lines)


def _build_multimodal_prompt(
    input_type: str,
    text_input: str,
    property_data: dict,
    suburb: str,
    profile: dict,
    mode: str,
    comparables: dict = None,
    geocode_info: dict = None,
    address_sales: dict = None,
) -> str:
    """
    构建多模态分析的 prompt。复用 _build_ai_prompt 的数据段落逻辑，
    增加房产具体信息 + 可比成交 + 地址专属数据 + Leo 判断指令。
    """
    # 复用已有的 9 段数据
    base_prompt = _build_ai_prompt(text_input or suburb, suburb, profile)

    # 在基础 prompt 末尾加入可比成交
    comparable_section = ""
    if comparables:
        comparable_section = "\n\n" + _build_comparable_section(
            comparables,
            property_data.get("property_type") if property_data else None,
            property_data.get("bedrooms") if property_data else None,
        )

    # 房产具体信息段（URL 抓取成功时）
    property_section = ""
    if property_data and not property_data.get("error"):
        addr = property_data.get("address", "")
        price = property_data.get("price", "")
        beds = property_data.get("bedrooms", 0)
        baths = property_data.get("bathrooms", 0)
        parking = property_data.get("parking", 0)
        land = property_data.get("land_size", 0)
        ptype = property_data.get("property_type", "")
        desc = property_data.get("description", "")[:500]

        property_section = f"""

## 目标房产详情
- 地址: {addr}
- 挂牌价: {price}
- 户型: {beds}房{baths}卫{parking}车位
- 土地面积: {land}sqm
- 房型: {ptype}
- 描述: {desc}
"""

    # 地址专属数据段（用户输入地址但未提供URL时）
    address_specific_section = ""
    if geocode_info and not geocode_info.get("error"):
        formatted = geocode_info.get("formatted_address", "")
        geo_suburb = geocode_info.get("suburb", "")
        postcode = geocode_info.get("postcode", "")
        full_street = geocode_info.get("full_street", "")
        address_specific_section = f"""

## 目标地址信息（Google Geocoding 解析）
- 输入地址: {text_input}
- 标准化地址: {formatted}
- 所属区域: {geo_suburb} {postcode}
"""
        if full_street:
            address_specific_section += f"- 街道: {full_street}\n"

    # 地址历史成交段
    address_history_section = ""
    if address_sales:
        exact = address_sales.get("exact", [])
        same_street = address_sales.get("same_street", [])
        if exact or same_street:
            lines = ["\n## 该地址 / 同街道历史成交"]
            if exact:
                lines.append(f"\n**该地址历史成交 ({len(exact)} 条):**")
                for i, s in enumerate(exact[:5]):
                    lines.append(f"  {i+1}. {s['address']} | ${s['price']:,} | {s['date']} | {s['type']} {s.get('beds',0)}房{s.get('baths',0)}卫 | {s.get('land_sqm',0)}sqm")
            if same_street:
                lines.append(f"\n**同街道近期成交 ({len(same_street)} 条):**")
                for i, s in enumerate(same_street[:8]):
                    sqm_str = f" | ${s['price_per_sqm']:,}/sqm" if s.get('price_per_sqm') else ""
                    lines.append(f"  {i+1}. {s['address']} | ${s['price']:,} | {s['date']} | {s['type']} {s.get('beds',0)}房{s.get('baths',0)}卫{sqm_str}")
            address_history_section = "\n".join(lines)

    # 增强的分析要求 — 根据是否有具体房产信息调整
    has_specific_property = bool(property_data and not property_data.get("error"))
    has_address_info = bool(geocode_info and not geocode_info.get("error"))

    if has_specific_property or has_address_info:
        target_desc = "该具体房产" if has_specific_property else f"该地址 ({text_input})"
        analysis_instructions = f"""
---

请基于以上**全部真实数据**，针对 **{target_desc}** 输出投资分析报告：

## 1. 投资评级 (X/10)
给出评级并用2-3句话解释。必须引用具体数据支撑评分。
**重要：必须针对这套具体房产/地址分析，而不是泛泛地分析整个区域。**

## 2. 核心优势 (3-4条)
每条必须引用具体数字，优先引用该地址/同街道的历史成交数据。

## 3. 风险警示 (2-3条)
必须引用具体数据。

## 4. 价格评估
- 对比该地址历史成交价（若有）和同街道成交价
- 对比同区中位价和近期可比成交
- 合理估价区间

## 5. 投资建议
- 推荐操作：买入 / 观望 / 不建议
- 议价策略（必须给出具体价格区间）
- 持有策略：短期/长期

**输出要求：**
- 全中文回复
- 每个数据引用必须来自上面提供的数据，禁止编造
- 必须提及该地址的具体特征（位置、街道、历史成交等），不能只做区域泛论
- 控制在1500字以内
- 语言风格：专业、直接、实用

**最后一行必须输出（隐藏标记，用户不可见）：**
<!-- LEO_VERDICT: {{"verdict":"值得买/观望/不建议","confidence":"高/中/低","fair_price_range":"XX-XX万","reason":"一句话理由"}} -->
"""
    else:
        analysis_instructions = """
---

请基于以上**全部真实数据**（含可比成交和目标房产信息），输出投资分析报告：

## 1. 投资评级 (X/10)
给出评级并用2-3句话解释。必须引用具体数据支撑评分。

## 2. 核心优势 (3-4条)
每条必须引用具体数字。

## 3. 风险警示 (2-3条)
必须引用具体数据。

## 4. 价格评估
- 当前挂牌价是否合理（对比同区中位价和近期可比成交）
- 合理估价区间

## 5. 投资建议
- 推荐操作：买入 / 观望 / 不建议
- 议价策略
- 持有策略：短期/长期

**输出要求：**
- 全中文回复
- 每个数据引用必须来自上面提供的数据，禁止编造
- 控制在1200字以内
- 语言风格：专业、直接、实用

**最后一行必须输出（隐藏标记，用户不可见）：**
<!-- LEO_VERDICT: {"verdict":"值得买/观望/不建议","confidence":"高/中/低","fair_price_range":"XX-XX万","reason":"一句话理由"} -->
"""

    # 组合最终 prompt
    # 替换基础 prompt 中的分析指引部分
    # 找到 "---" 分隔线位置，用增强版替换
    if "请基于以上**全部真实数据**" in base_prompt:
        # 截断到数据段结束
        idx = base_prompt.index("---\n\n请基于以上")
        base_prompt = base_prompt[:idx]

    final_prompt = base_prompt + property_section + address_specific_section + address_history_section + comparable_section + analysis_instructions

    # 添加模式额外指引
    extra = _get_mode_extra_instructions(mode)
    if extra:
        final_prompt += extra

    return final_prompt


@app.post("/api/analyze/multimodal")
@limiter.limit("10/minute")
async def analyze_multimodal(
    request: Request,
    text_input: str = Form(None),
    images: list[UploadFile] = File(None),
    mode: str = Form("general"),
):
    """
    多模态 AI 分析端点。
    支持: Domain/REA 链接、地址、图片、自由文本。
    返回 SSE 多事件流。
    """
    import json as _json

    # 验证输入
    if not text_input and not images:
        raise HTTPException(status_code=400, detail="请提供文本输入或图片")

    # 处理图片
    image_b64_list = []
    if images:
        for img in images[:3]:
            if img.size and img.size > 5 * 1024 * 1024:
                continue
            content_type = img.content_type or "image/jpeg"
            if content_type not in ("image/jpeg", "image/png", "image/webp"):
                continue
            raw = await img.read()
            b64 = _b64.b64encode(raw).decode("utf-8")
            image_b64_list.append(f"data:{content_type};base64,{b64}")

    # 分类输入
    input_type, input_value = _classify_input(text_input or "")

    # Bug 1 修复: 输入校验 — freeform 文本在无图片时拒绝
    if input_type == 'freeform' and not image_b64_list:
        error_msg = "请输入有效的澳洲房产地址、Domain/REA链接，或上传房产图片。\n\n支持的格式：\n• 具体地址：如 10 Smith St, Sunnybank\n• Domain链接：domain.com.au/...\n• REA链接：realestate.com.au/...\n• 区域名称：如 Sunnybank, Calamvale\n• 上传房产截图进行分析"
        async def _error_gen():
            yield f"data: {_json.dumps({'type': 'error', 'message': error_msg})}\n\n"
        return StreamingResponse(_error_gen(), media_type="text/event-stream",
                                 headers={"Cache-Control": "no-cache", "Connection": "keep-alive", "X-Accel-Buffering": "no"})

    def event_generator():
        try:
            # 1. 处理 URL → 抓取房产数据
            property_data = None
            if input_type in ('domain_url', 'rea_url'):
                try:
                    from property_scraper import scrape_property_listing
                    property_data = scrape_property_listing(input_value)
                except Exception as e:
                    print(f"Scraper error: {e}")
                    property_data = {"error": str(e)}

            # 2. 确定 suburb — 使用 Google Geocoding 解析任意地址
            suburb = ""
            geocode_info = None
            address_sales = None

            if property_data and not property_data.get("error"):
                # URL 抓取成功 → 从 property_data 提取 suburb
                suburb_from_data = property_data.get("suburb", "")
                if suburb_from_data:
                    for s in ALL_SUBURB_NAMES:
                        if s.lower() == suburb_from_data.lower():
                            suburb = s
                            break
                    else:
                        for s in ALL_SUBURB_NAMES:
                            if s.lower() in suburb_from_data.lower() or suburb_from_data.lower() in s.lower():
                                suburb = s
                                break
                        if not suburb:
                            suburb = suburb_from_data  # 使用原始suburb名
                if not suburb and property_data.get("address"):
                    suburb = _extract_suburb_from_input(property_data["address"])

            elif text_input and input_type in ('address', 'suburb', 'suburb_candidate'):
                # 先尝试从已知列表匹配
                suburb = _extract_suburb_from_input(text_input)
                suburb_from_text = suburb  # 记住文本匹配结果

                # Bug 2 修复: 如果匹配不到已知suburb，用 Google Geocoding 解析
                if not suburb:
                    print(f"[Multimodal] Geocoding address (no known suburb): {text_input}")
                    geocode_info = _geocode_for_multimodal(text_input)
                    if geocode_info and not geocode_info.get("error"):
                        geo_suburb = geocode_info.get("suburb", "")
                        if geo_suburb:
                            # 看是否匹配已知suburb
                            for s in ALL_SUBURB_NAMES:
                                if s.lower() == geo_suburb.lower():
                                    suburb = s
                                    break
                            if not suburb:
                                suburb = geo_suburb  # 使用geocoding返回的suburb
                            print(f"[Multimodal] Geocoded suburb: {suburb}")
                        else:
                            # Geocoding 成功但没有找到具体suburb（太泛了，如 "Queensland"）
                            if input_type == 'suburb_candidate':
                                yield f"data: {_json.dumps({'type': 'error', 'message': '无法识别该区域名称。请输入完整的澳洲房产地址，例如: 10 Smith St, Sunnybank'})}\n\n"
                                return
                    elif geocode_info and geocode_info.get("error"):
                        # geocoding失败
                        if input_type == 'suburb_candidate':
                            err_msg = geocode_info["error"]
                            yield f"data: {_json.dumps({'type': 'error', 'message': f'无法识别该地址: {err_msg}。请输入更完整的地址。'})}\n\n"
                            return
                elif input_type == 'address':
                    # 已知suburb匹配成功，但仍然geocode获取精确地址信息（用于报告）
                    print(f"[Multimodal] Geocoding for address details: {text_input}")
                    geocode_info = _geocode_for_multimodal(text_input)
                    # 不用geocoding的suburb覆盖已知suburb
                    if geocode_info and not geocode_info.get("error"):
                        print(f"[Multimodal] Geocoded address: {geocode_info.get('formatted_address', '')}, keeping suburb: {suburb}")

                # Bug 3 修复: 搜索该地址的历史成交
                if text_input and input_type == 'address':
                    address_sales = _search_address_sales(text_input, suburb)
                    if address_sales:
                        exact_count = len(address_sales.get("exact", []))
                        street_count = len(address_sales.get("same_street", []))
                        print(f"[Multimodal] Address sales: {exact_count} exact, {street_count} same street")

            # 最终 fallback
            if not suburb:
                suburb = "Sunnybank"

            # 发送 meta 事件
            meta = _json.dumps({
                "type": "meta",
                "input_type": input_type,
                "suburb": suburb,
                "mode": mode,
                "has_images": len(image_b64_list) > 0,
                "geocoded": bool(geocode_info and not geocode_info.get("error")),
                "formatted_address": geocode_info.get("formatted_address", "") if geocode_info else "",
            })
            yield f"data: {meta}\n\n"

            # 发送 property_data 事件
            if property_data and not property_data.get("error"):
                pd_event = _json.dumps({
                    "type": "property_data",
                    "data": property_data,
                })
                yield f"data: {pd_event}\n\n"

            # 3. 聚合 suburb 数据
            profile = _get_suburb_full_profile(suburb)

            # 4. Compass Score (Ethan)
            try:
                score_data = profile.get("compass_score", {})
                ethan_event = _json.dumps({
                    "type": "ethan_score",
                    "data": score_data,
                })
                yield f"data: {ethan_event}\n\n"
            except Exception as e:
                print(f"Ethan score error: {e}")

            # 5. 可比成交
            comparables = {}
            try:
                comp_ptype = None
                comp_beds = None
                if property_data and not property_data.get("error"):
                    comp_ptype = property_data.get("property_type")
                    comp_beds = property_data.get("bedrooms")
                    if isinstance(comp_beds, str):
                        try:
                            comp_beds = int(comp_beds)
                        except (ValueError, TypeError):
                            comp_beds = None

                comparables = _get_comparable_sales(
                    suburb=suburb,
                    property_type=comp_ptype,
                    bedrooms=comp_beds,
                )
                comp_event = _json.dumps({
                    "type": "comparable_sales",
                    "data": comparables,
                })
                yield f"data: {comp_event}\n\n"
            except Exception as e:
                print(f"Comparable sales error: {e}")

            # 6. 构建 prompt + 流式 AI 分析
            client, _model, _temp = _get_ai_client_vision() if image_b64_list else _get_ai_client()

            system_prompt = _get_mode_system_prompt(mode)

            # 构建 messages
            if image_b64_list:
                # 图片模式 → Vision
                user_content = []
                img_prompt = f"请分析这些房产相关图片，提取你能识别的信息（地址、价格、户型、特征等），并结合以下{suburb}区的数据给出投资分析。\n\n"
                prompt_text = _build_multimodal_prompt(
                    input_type, text_input, property_data, suburb, profile, mode, comparables,
                    geocode_info=geocode_info, address_sales=address_sales,
                )
                user_content.append({"type": "text", "text": img_prompt + prompt_text})
                for img_b64 in image_b64_list:
                    user_content.append({
                        "type": "image_url",
                        "image_url": {"url": img_b64}
                    })
                messages = [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_content}
                ]
            else:
                # 文本模式
                prompt_text = _build_multimodal_prompt(
                    input_type, text_input, property_data, suburb, profile, mode, comparables,
                    geocode_info=geocode_info, address_sales=address_sales,
                )
                messages = [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": prompt_text}
                ]

            # 流式输出
            stream = client.chat.completions.create(
                model=_model,
                messages=messages,
                max_tokens=4096,
                temperature=_temp,
                stream=True,
            )

            accumulated = ""
            leo_extracted = False
            for chunk in stream:
                if chunk.choices and chunk.choices[0].delta.content:
                    text = chunk.choices[0].delta.content
                    accumulated += text

                    # 检测并提取 Leo 判断标记
                    if "<!-- LEO_VERDICT:" in accumulated and not leo_extracted:
                        match = _re_early.search(
                            r'<!-- LEO_VERDICT:\s*(\{.*?\})\s*-->',
                            accumulated,
                            _re_early.DOTALL,
                        )
                        if match:
                            try:
                                leo_data = _json.loads(match.group(1))
                                leo_event = _json.dumps({
                                    "type": "leo_verdict",
                                    "data": leo_data,
                                })
                                yield f"data: {leo_event}\n\n"
                                leo_extracted = True
                                # 从输出中移除标记
                                text = text.replace(match.group(0), "")
                            except _json.JSONDecodeError:
                                pass

                    # 过滤 LEO 标记行再发送内容
                    clean_text = text
                    if "<!-- LEO" in clean_text or "LEO_VERDICT" in clean_text:
                        clean_text = _re_early.sub(r'<!-- LEO_VERDICT:.*?-->', '', clean_text)
                    if clean_text.strip():
                        data = _json.dumps({"type": "amanda_content", "text": clean_text})
                        yield f"data: {data}\n\n"

            # 最后检查是否漏掉 Leo 标记
            if not leo_extracted and "<!-- LEO_VERDICT:" in accumulated:
                match = _re_early.search(
                    r'<!-- LEO_VERDICT:\s*(\{.*?\})\s*-->',
                    accumulated,
                    _re_early.DOTALL,
                )
                if match:
                    try:
                        leo_data = _json.loads(match.group(1))
                        leo_event = _json.dumps({
                            "type": "leo_verdict",
                            "data": leo_data,
                        })
                        yield f"data: {leo_event}\n\n"
                    except _json.JSONDecodeError:
                        pass

            yield f"data: {_json.dumps({'type': 'done'})}\n\n"

        except Exception as e:
            import traceback
            traceback.print_exc()
            error_data = _json.dumps({"type": "error", "message": str(e)})
            yield f"data: {error_data}\n\n"

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        }
    )


# ========== 天機堂 · 风水堪輿分析 ==========
import math as _math
import urllib.request as _urllib_req
import urllib.parse as _urllib_parse

_GMAPS_KEY = os.getenv("GOOGLE_MAPS_API_KEY") or os.getenv("NEXT_PUBLIC_GOOGLE_MAPS_KEY", "")

# Simple in-memory cache for feng shui results (address → {data, ts})
_fengshui_cache: dict = {}
_FENGSHUI_CACHE_TTL = 3600  # 1 hour

_DIRECTION_NAMES = ["北", "东北", "东", "东南", "南", "西南", "西", "西北"]
_DIRECTION_OFFSETS = [
    (0, 1), (1, 1), (1, 0), (1, -1),
    (0, -1), (-1, -1), (-1, 0), (-1, 1),
]


def _geocode_address(address: str) -> dict:
    """Google Geocoding API: address -> {lat, lng, formatted_address, suburb}"""
    if not _GMAPS_KEY:
        return {"error": "GOOGLE_MAPS_API_KEY not configured"}
    try:
        params = _urllib_parse.urlencode({
            "address": f"{address}, Brisbane, QLD, Australia",
            "key": _GMAPS_KEY,
            "region": "au",
        })
        url = f"https://maps.googleapis.com/maps/api/geocode/json?{params}"
        req = _urllib_req.Request(url)
        with _urllib_req.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        if data.get("status") != "OK" or not data.get("results"):
            return {"error": f"Geocoding failed: {data.get('status', 'NO_RESULTS')}"}
        result = data["results"][0]
        loc = result["geometry"]["location"]
        # extract suburb from address_components
        suburb = ""
        for comp in result.get("address_components", []):
            if "locality" in comp.get("types", []):
                suburb = comp["long_name"]
                break
        return {
            "lat": loc["lat"],
            "lng": loc["lng"],
            "formatted_address": result.get("formatted_address", address),
            "suburb": suburb,
        }
    except Exception as e:
        return {"error": f"Geocoding error: {str(e)}"}


def _get_elevation_grid(lat: float, lng: float, radius_m: int = 200) -> dict:
    """Google Elevation API: 9-point grid around center for terrain analysis."""
    if not _GMAPS_KEY:
        return {"error": "API key not configured"}
    try:
        # 1 degree lat ~ 111320m
        dlat = radius_m / 111320.0
        dlng = radius_m / (111320.0 * _math.cos(_math.radians(lat)))

        points = [(lat, lng)]  # center
        for dx, dy in _DIRECTION_OFFSETS:
            points.append((lat + dy * dlat, lng + dx * dlng))

        locations_str = "|".join(f"{p[0]},{p[1]}" for p in points)
        params = _urllib_parse.urlencode({
            "locations": locations_str,
            "key": _GMAPS_KEY,
        })
        url = f"https://maps.googleapis.com/maps/api/elevation/json?{params}"
        req = _urllib_req.Request(url)
        with _urllib_req.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode("utf-8"))

        if data.get("status") != "OK":
            return {"error": f"Elevation API: {data.get('status')}"}

        results = data.get("results", [])
        if len(results) < 9:
            return {"error": "Insufficient elevation data"}

        center_elev = results[0]["elevation"]
        elevations = {}
        relative = {}
        max_diff = 0
        backing_dir = ""

        for i, name in enumerate(_DIRECTION_NAMES):
            elev = results[i + 1]["elevation"]
            elevations[name] = round(elev, 1)
            diff = round(elev - center_elev, 1)
            relative[name] = diff
            if diff > max_diff:
                max_diff = diff
                backing_dir = name

        return {
            "center_elevation": round(center_elev, 1),
            "elevations": elevations,
            "relative_to_center": relative,
            "backing_direction": backing_dir if max_diff > 2 else "",
            "has_backing": max_diff > 2,
            "max_height_diff": round(max_diff, 1),
            "terrain_flat": max_diff < 1.5,
        }
    except Exception as e:
        return {"error": f"Elevation error: {str(e)}"}


def _get_fengshui_places(lat: float, lng: float) -> dict:
    """Google Places Nearby Search: feng shui relevant facilities. Parallelized."""
    from concurrent.futures import ThreadPoolExecutor, as_completed
    if not _GMAPS_KEY:
        return {"error": "API key not configured"}

    def _search_nearby(keyword_or_type: str, radius: int, is_type: bool = True) -> list:
        try:
            params = {
                "location": f"{lat},{lng}",
                "radius": str(radius),
                "key": _GMAPS_KEY,
            }
            if is_type:
                params["type"] = keyword_or_type
            else:
                params["keyword"] = keyword_or_type
            qs = _urllib_parse.urlencode(params)
            url = f"https://maps.googleapis.com/maps/api/place/nearbysearch/json?{qs}"
            req = _urllib_req.Request(url)
            with _urllib_req.urlopen(req, timeout=10) as resp:
                data = json.loads(resp.read().decode("utf-8"))
            places = []
            for p in data.get("results", [])[:5]:
                ploc = p.get("geometry", {}).get("location", {})
                dist = _haversine(lat, lng, ploc.get("lat", lat), ploc.get("lng", lng))
                places.append({
                    "name": p.get("name", ""),
                    "distance_m": round(dist),
                    "vicinity": p.get("vicinity", ""),
                })
            return places
        except Exception:
            return []

    # All search tasks: (key, type_or_kw, radius, is_type, result_group)
    tasks = [
        ("cemetery",         "cemetery",         500,  True,  "negative"),
        ("funeral_home",     "funeral_home",     500,  True,  "negative"),
        ("hospital",         "hospital",         500,  True,  "negative"),
        ("park",             "park",             1000, True,  "positive"),
        ("school",           "school",           1000, True,  "positive"),
        ("place_of_worship", "place_of_worship", 1000, True,  "positive"),
        ("water",            "lake river creek", 1500, False, "water_features"),
    ]

    result = {"negative": [], "positive": [], "water_features": []}

    # Run all searches in parallel (7 threads instead of 10 serial calls)
    with ThreadPoolExecutor(max_workers=7) as pool:
        futures = {}
        for cat, kw, radius, is_type, group in tasks:
            f = pool.submit(_search_nearby, kw, radius, is_type)
            futures[f] = (cat, group)

        for f in as_completed(futures):
            cat, group = futures[f]
            try:
                found = f.result()
                for item in found:
                    item["category"] = cat
                    result[group].append(item)
            except Exception:
                pass

    return result


def _haversine(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """Calculate distance in meters between two points."""
    R = 6371000
    phi1, phi2 = _math.radians(lat1), _math.radians(lat2)
    dphi = _math.radians(lat2 - lat1)
    dlam = _math.radians(lng2 - lng1)
    a = _math.sin(dphi / 2) ** 2 + _math.cos(phi1) * _math.cos(phi2) * _math.sin(dlam / 2) ** 2
    return R * 2 * _math.atan2(_math.sqrt(a), _math.sqrt(1 - a))


def _get_fengshui_crime(suburb_name: str) -> dict:
    """Query crime stats for feng shui safety assessment."""
    try:
        if not execute_query:
            return {"error": "Database not available"}

        rows = execute_query("""
            SELECT category, SUM(count) as total
            FROM crime_stats
            WHERE LOWER(suburb) = LOWER(%s)
              AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM')
            GROUP BY category
            ORDER BY total DESC
            LIMIT 10
        """, (suburb_name,))

        categories = {}
        total = 0
        for row in rows:
            cat = row.get("category", "unknown")
            cnt = int(row.get("total", 0))
            categories[cat] = cnt
            total += cnt

        return {
            "suburb": suburb_name,
            "total_incidents": total,
            "categories": categories,
        }
    except Exception as e:
        return {"error": f"Crime data error: {str(e)}"}


def _get_fengshui_system_prompt() -> str:
    return """你是胡師傅，天機堂堪輿師，居布里斯班，精研巒頭形勢二十年。

南半球修正：布里斯班南緯27°，北面朝陽=傳統「南」陽氣，南面背陰=傳統「北」陰氣。坐南朝北=吉。分析中須說明此修正。

風格：通俗解讀風水，基於數據，不臆測，中文回覆。

如附有平面圖，額外分析門向、廚廁位、主臥方位。

輸出格式（每節2-3句，全文600字內）：
## 總體評級（A-E）
## 巒頭形勢（地形靠山·南半球修正）
## 水法與環境（水體+吉地+煞氣）
## 道路與治安
## 胡師傅總評與化解"""


def _build_fengshui_prompt(address: str, elevation: dict, places: dict, crime: dict) -> str:
    lines = [f"地址: {address}"]

    # Elevation — compact one-liner per direction
    if not elevation.get("error"):
        dirs = " | ".join(
            f"{d}:{elevation['relative_to_center'].get(d, 0):+.1f}m"
            for d in _DIRECTION_NAMES
        )
        lines.append(f"地形(海拔{elevation['center_elevation']}m): {dirs}")
        if elevation.get("has_backing"):
            lines.append(f"靠山: {elevation['backing_direction']}方 高差{elevation['max_height_diff']}m")
        else:
            lines.append("靠山: 無")
    else:
        lines.append("地形: 無數據")

    # Places — compact, max 3 per category
    if not places.get("error"):
        neg = places.get("negative", [])
        pos = places.get("positive", [])
        water = places.get("water_features", [])
        if neg:
            items = ", ".join(f"{p['name']}({p['distance_m']}m)" for p in neg[:3])
            lines.append(f"煞氣({len(neg)}): {items}")
        else:
            lines.append("煞氣: 500m內無")
        if pos:
            items = ", ".join(f"{p['name']}({p['distance_m']}m)" for p in pos[:4])
            lines.append(f"吉地({len(pos)}): {items}")
        if water:
            # Deduplicate by name
            seen = set()
            unique_water = []
            for w in water:
                if w["name"] not in seen:
                    seen.add(w["name"])
                    unique_water.append(w)
            items = ", ".join(f"{p['name']}({p['distance_m']}m)" for p in unique_water[:3])
            lines.append(f"水體({len(unique_water)}): {items}")
        else:
            lines.append("水體: 1500m內無")

    # Crime — one liner
    if not crime.get("error") and crime.get("total_incidents"):
        top3 = ", ".join(f"{k}:{v}" for k, v in list(crime["categories"].items())[:3])
        lines.append(f"治安({crime['suburb']}): 年{crime['total_incidents']}件 | {top3}")
    elif not crime.get("error"):
        lines.append(f"治安({crime.get('suburb','')}): 無記錄")

    # Road hint
    al = address.lower()
    if any(x in al for x in [" ct", " court", " close", " cl", " place", " pl"]):
        lines.append("道路: 死路(Cul-de-sac)")
    elif any(x in al for x in [" cres", " crescent"]):
        lines.append("道路: 弧形路(Crescent)")
    elif any(x in al for x in [" st", " street", " rd", " road", " ave", " avenue"]):
        lines.append("道路: 直路")

    return "\n".join(lines)


@app.post("/api/fengshui/analyze")
@limiter.limit("10/minute")
async def fengshui_analyze(
    request: Request,
    address: str = Form(...),
    floor_plan: Optional[UploadFile] = File(None),
):
    """
    天機堂 · 风水堪輿分析 SSE 端点
    输入地址 + 可选平面图，返回 SSE 多事件流（地形/设施/治安/胡師傅分析）
    """
    import json as _json
    import base64 as _b64

    if not address or not address.strip():
        raise HTTPException(status_code=400, detail="请提供地址")

    # Pre-read floor plan image if provided
    floor_plan_b64 = None
    if floor_plan and floor_plan.filename:
        ct = floor_plan.content_type or "image/jpeg"
        if ct in ("image/jpeg", "image/png", "image/webp"):
            raw = await floor_plan.read()
            if len(raw) <= 5 * 1024 * 1024:
                floor_plan_b64 = f"data:{ct};base64,{_b64.b64encode(raw).decode('utf-8')}"

    def event_generator():
        from concurrent.futures import ThreadPoolExecutor
        import time as _t
        try:
            addr_key = address.strip().lower()

            # 1. Geocode (check cache first)
            cached = _fengshui_cache.get(addr_key)
            if cached and (_t.time() - cached["ts"]) < _FENGSHUI_CACHE_TTL:
                geo = cached["geo"]
                elevation = cached["elevation"]
                places = cached["places"]
                crime = cached["crime"]
                print(f"[FengShui] Cache hit: {addr_key}")
            else:
                geo = _geocode_address(address.strip())
                if geo.get("error"):
                    yield f"data: {_json.dumps({'type': 'error', 'message': geo['error']}, ensure_ascii=False)}\n\n"
                    return
                elevation, places, crime = None, None, None

            lat, lng = geo["lat"], geo["lng"]
            suburb = geo.get("suburb", "")

            meta_payload = {
                'type': 'meta',
                'address': geo['formatted_address'],
                'suburb': suburb,
                'lat': lat,
                'lng': lng,
                'has_floor_plan': floor_plan_b64 is not None,
            }
            yield f"data: {_json.dumps(meta_payload, ensure_ascii=False)}\n\n"

            # 2. Collect feng shui data — all 3 in parallel
            if elevation is None:
                t0 = _t.time()
                with ThreadPoolExecutor(max_workers=3) as pool:
                    f_elev = pool.submit(_get_elevation_grid, lat, lng)
                    f_places = pool.submit(_get_fengshui_places, lat, lng)
                    f_crime = pool.submit(_get_fengshui_crime, suburb) if suburb else None

                    elevation = f_elev.result()
                    places = f_places.result()
                    crime = f_crime.result() if f_crime else {"error": "No suburb detected"}

                # Cache results
                _fengshui_cache[addr_key] = {
                    "geo": geo, "elevation": elevation,
                    "places": places, "crime": crime,
                    "ts": _t.time(),
                }
                print(f"[FengShui] Data collected in {_t.time()-t0:.1f}s (parallel)")

            yield f"data: {_json.dumps({'type': 'fengshui_data', 'category': 'elevation', 'data': elevation}, ensure_ascii=False)}\n\n"
            yield f"data: {_json.dumps({'type': 'fengshui_data', 'category': 'places', 'data': places}, ensure_ascii=False)}\n\n"
            yield f"data: {_json.dumps({'type': 'fengshui_data', 'category': 'crime', 'data': crime}, ensure_ascii=False)}\n\n"

            # 3. Build prompt & stream from Kimi
            system_prompt = _get_fengshui_system_prompt()
            user_prompt = _build_fengshui_prompt(
                geo["formatted_address"], elevation, places, crime
            )

            if floor_plan_b64:
                user_prompt += "\n\n# 室內平面圖\n用戶已提供室內平面圖（見附圖），請額外分析大門朝向、廚廁位置、主臥方位、動線格局等室內風水要素。"

            client, _fs_model, _fs_temp = _get_ai_client_vision() if floor_plan_b64 else _get_ai_client()
            print(f"[FengShui] Using model: {_fs_model}, temp: {_fs_temp}")

            # Build messages - include floor plan image if provided
            messages = [
                {"role": "system", "content": system_prompt},
            ]
            if floor_plan_b64:
                messages.append({
                    "role": "user",
                    "content": [
                        {"type": "text", "text": user_prompt},
                        {"type": "image_url", "image_url": {"url": floor_plan_b64}},
                    ],
                })
            else:
                messages.append({"role": "user", "content": user_prompt})

            stream = client.chat.completions.create(
                model=_fs_model,
                messages=messages,
                temperature=_fs_temp,
                max_tokens=2500,
                stream=True,
            )

            full_content = ""
            for chunk in stream:
                delta = chunk.choices[0].delta if chunk.choices else None
                if delta and delta.content:
                    full_content += delta.content
                    yield f"data: {_json.dumps({'type': 'master_hu_content', 'text': delta.content}, ensure_ascii=False)}\n\n"

            # ---- 保存風水記錄到資料庫（在 done 之前，確保執行）----
            try:
                import re as _re_fs
                import hashlib as _hl
                rating_match = _re_fs.search(r'總體評級[^A-E]*([A-E])', full_content)
                rating = rating_match.group(1) if rating_match else '?'
                if rating != '?':
                    # 提取摘要（取第一段非標題文字，最多150字）
                    summary_lines = []
                    for ln in full_content.split('\n'):
                        ln = ln.strip()
                        if ln and not ln.startswith('#') and not ln.startswith('##'):
                            summary_lines.append(ln)
                            if len(''.join(summary_lines)) > 150:
                                break
                    summary_text = ''.join(summary_lines)[:200]

                    addr_hash = _hl.md5(geo['formatted_address'].lower().encode()).hexdigest()

                    execute_query("""
                        INSERT INTO fengshui_records
                            (address, suburb, rating, summary, full_content, center_elevation, has_backing,
                             backing_direction, has_water, negative_count, positive_count,
                             total_crime, has_floor_plan, address_hash)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT (address_hash) DO UPDATE SET
                            rating = EXCLUDED.rating,
                            summary = EXCLUDED.summary,
                            full_content = EXCLUDED.full_content,
                            has_floor_plan = EXCLUDED.has_floor_plan,
                            created_at = NOW()
                    """, (
                        geo['formatted_address'],
                        suburb,
                        rating,
                        summary_text,
                        full_content,
                        elevation.get('center_elevation') if not elevation.get('error') else None,
                        elevation.get('has_backing', False) if not elevation.get('error') else False,
                        elevation.get('backing_direction', '') if not elevation.get('error') else '',
                        bool(places.get('water_features')) if not places.get('error') else False,
                        len(places.get('negative', [])) if not places.get('error') else 0,
                        len(places.get('positive', [])) if not places.get('error') else 0,
                        crime.get('total_incidents', 0) if not crime.get('error') else 0,
                        floor_plan_b64 is not None,
                        addr_hash,
                    ))
                    print(f"[FengShui] Record saved: {geo['formatted_address']} -> {rating}")
            except Exception as save_err:
                print(f"[FengShui] Failed to save record: {save_err}")

            yield f"data: {_json.dumps({'type': 'done'})}\n\n"

        except Exception as e:
            print(f"[FengShui ERROR] {e}")
            yield f"data: {_json.dumps({'type': 'error', 'message': str(e)}, ensure_ascii=False)}\n\n"

    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
            "X-Accel-Buffering": "no",
        }
    )


def _mask_address(address: str, suburb: str) -> str:
    """隱藏具體門牌號，只保留街道首字母 + 郊區"""
    import re as _re_m
    # "10 Doreen St, Geebung QLD 4034, Australia" → "D***n St, Geebung"
    # Remove suburb/state/postcode/country suffix for cleaner display
    parts = address.split(',')
    street_part = parts[0].strip() if parts else address
    # Try to extract street name (skip number)
    m = _re_m.match(r'^[\d/\-A-Za-z]*\s+(.+)$', street_part)
    if m:
        street_name = m.group(1).strip()
        # Mask: keep first char, last char, mask middle
        words = street_name.split()
        masked_words = []
        for w in words:
            if len(w) <= 2:
                masked_words.append(w)
            else:
                masked_words.append(w[0] + '*' * (len(w) - 2) + w[-1])
        return ' '.join(masked_words) + f', {suburb}'
    return f'{suburb}區'


@app.get("/api/fengshui/records")
async def fengshui_records(
    request: Request,
    limit: int = 20,
    rating: str = "",
):
    """
    天機堂 · 風水記錄公開排行
    返回近期分析記錄，按評級排序（A > B > C > D > E）
    地址已脫敏處理，保護用戶隱私
    """
    try:
        where_clause = ""
        params: list = []
        if rating and rating in ('A', 'B', 'C', 'D', 'E'):
            where_clause = "WHERE rating = %s"
            params.append(rating)

        safe_limit = min(max(limit, 1), 50)
        params.append(safe_limit)

        rows = execute_query(f"""
            SELECT id, address, suburb, rating, summary, full_content,
                   center_elevation, has_backing, backing_direction, has_water,
                   negative_count, positive_count, total_crime, has_floor_plan, created_at
            FROM fengshui_records
            {where_clause}
            ORDER BY
                CASE rating
                    WHEN 'A' THEN 1 WHEN 'B' THEN 2 WHEN 'C' THEN 3
                    WHEN 'D' THEN 4 WHEN 'E' THEN 5 ELSE 6
                END,
                created_at DESC
            LIMIT %s
        """, tuple(params))

        records = []
        for r in (rows or []):
            suburb = r.get("suburb", "")
            records.append({
                "id": r["id"],
                "masked_address": _mask_address(r["address"], suburb),
                "suburb": suburb,
                "rating": r["rating"],
                "summary": r.get("summary", ""),
                "full_content": r.get("full_content", ""),
                "center_elevation": r.get("center_elevation"),
                "has_backing": r.get("has_backing", False),
                "backing_direction": r.get("backing_direction", ""),
                "has_water": r.get("has_water", False),
                "negative_count": r.get("negative_count", 0),
                "positive_count": r.get("positive_count", 0),
                "total_crime": r.get("total_crime", 0),
                "has_floor_plan": r.get("has_floor_plan", False),
                "created_at": r["created_at"].isoformat() if r.get("created_at") else None,
            })

        # 統計各等級數量
        count_rows = execute_query("""
            SELECT rating, COUNT(*) as cnt FROM fengshui_records GROUP BY rating ORDER BY rating
        """)
        stats = {r["rating"]: r["cnt"] for r in (count_rows or [])}

        return {
            "records": records,
            "total": sum(stats.values()),
            "stats": stats,
        }
    except Exception as e:
        print(f"[FengShui Records] Error: {e}")
        return {"records": [], "total": 0, "stats": {}}


# ========== 新闻 RSS 聚合 (Olivia 每日资讯系统) ==========
import urllib.request
import xml.etree.ElementTree as ET
from datetime import datetime
import time as _time
import re as _re
import html as _html
import hashlib as _hashlib
import threading

# ---- 内存缓存层（快速读取，DB 为持久层）----
_news_cache: dict = {"items": [], "ts": 0}
_NEWS_TTL = 3600  # 1 小时

_commentary_cache: dict = {"text": "", "date": "", "period": "", "ts": 0}
_COMMENTARY_TTL = 14400  # 4 小时

# ---- 四大新闻源 ----
_RSS_SOURCES = [
    # REA (realestate.com.au) — 官方 RSS
    {"url": "https://www.realestate.com.au/news/feed/", "name": "REA"},
    # Google News — 多关键词组合
    {"url": "https://news.google.com/rss/search?q=brisbane+property+market&hl=en-AU&gl=AU&ceid=AU:en", "name": "Google News"},
    {"url": "https://news.google.com/rss/search?q=brisbane+auction+clearance+rate&hl=en-AU&gl=AU&ceid=AU:en", "name": "Google News"},
    {"url": "https://news.google.com/rss/search?q=brisbane+rental+vacancy+yield&hl=en-AU&gl=AU&ceid=AU:en", "name": "Google News"},
    {"url": "https://news.google.com/rss/search?q=brisbane+2032+olympics+infrastructure&hl=en-AU&gl=AU&ceid=AU:en", "name": "Google News"},
    {"url": "https://news.google.com/rss/search?q=RBA+interest+rate+property+australia&hl=en-AU&gl=AU&ceid=AU:en", "name": "Google News"},
    # Domain.com.au/news — 行业新闻（排除 listings），用 Google News site: 过滤 domain.com.au/news
    {"url": "https://news.google.com/rss/search?q=site:domain.com.au/news+brisbane+property+market&hl=en-AU&gl=AU&ceid=AU:en", "name": "Domain"},
    {"url": "https://news.google.com/rss/search?q=site:domain.com.au/news+auction+rental+investment&hl=en-AU&gl=AU&ceid=AU:en", "name": "Domain"},
    # 后花园澳洲 — 无 RSS，用 Google News 中文搜索代替
    {"url": "https://news.google.com/rss/search?q=%E6%BE%B3%E6%B4%B2+%E6%88%BF%E4%BA%A7+%E5%B8%83%E9%87%8C%E6%96%AF%E7%8F%AD&hl=zh-CN&gl=AU&ceid=AU:zh-Hans", "name": "后花园"},
    {"url": "https://news.google.com/rss/search?q=%E6%BE%B3%E6%B4%B2+%E6%88%BF%E4%BB%B7+%E6%8A%95%E8%B5%84+%E7%A7%BB%E6%B0%91&hl=zh-CN&gl=AU&ceid=AU:zh-Hans", "name": "后花园"},
]

# ---- 分类规则（5 类）----
_TAG_RULES = [
    (["auction", "clearance", "bidding", "sold", "拍卖", "清盘"], "拍卖数据", "bg-orange-100 text-orange-700"),
    (["olympics", "2032", "infrastructure", "venue", "stadium", "奥运", "基建"], "奥运概念", "bg-red-100 text-red-700"),
    (["investor", "overseas", "chinese", "foreign", "immigration", "投资", "海外", "移民"], "投资趋势", "bg-purple-100 text-purple-700"),
    (["rent", "rental", "vacancy", "tenant", "yield", "租赁", "空置", "租金"], "租赁市场", "bg-teal-100 text-teal-700"),
    (["price", "median", "growth", "surge", "rise", "fall", "drop", "market", "房价", "涨", "跌", "市场"], "市场动态", "bg-blue-100 text-blue-700"),
]


def _classify_news(title: str, summary: str) -> tuple:
    text = (title + " " + summary).lower()
    for keywords, tag, color in _TAG_RULES:
        if any(kw in text for kw in keywords):
            return tag, color
    return "市场动态", "bg-blue-100 text-blue-700"


def _extract_source(title: str, feed_name: str) -> str:
    """Extract source. For Google News / Domain / 后花园: parse 'Headline - Source'."""
    if feed_name in ("Google News", "Domain", "后花园"):
        if " - " in title:
            return title.rsplit(" - ", 1)[-1].strip()
    return feed_name


def _clean_headline(title: str, feed_name: str) -> str:
    """Remove source suffix from Google News style titles."""
    if feed_name in ("Google News", "Domain", "后花园"):
        if " - " in title:
            return title.rsplit(" - ", 1)[0].strip()
    return title


def _fetch_rss_news() -> list:
    """Fetch and parse all RSS feeds, return news items. Uses in-memory cache + DB."""
    now = _time.time()
    if _news_cache["items"] and (now - _news_cache["ts"]) < _NEWS_TTL:
        return _news_cache["items"]

    items = []
    seen_hashes = set()

    for src in _RSS_SOURCES:
        try:
            req = urllib.request.Request(
                src["url"],
                headers={"User-Agent": "Compass/2.0 (Brisbane Property Platform)"}
            )
            with urllib.request.urlopen(req, timeout=15) as resp:
                xml_data = resp.read()

            root = ET.fromstring(xml_data)
            for item_el in root.findall(".//item"):
                raw_title = item_el.findtext("title", "")
                source = _extract_source(raw_title, src["name"])
                headline = _clean_headline(raw_title, src["name"])

                link = item_el.findtext("link", "")
                url_hash = _hashlib.md5(link.encode()).hexdigest() if link else ""
                if not url_hash or url_hash in seen_hashes:
                    continue
                seen_hashes.add(url_hash)

                desc_raw = item_el.findtext("description", "")
                summary = _re.sub(r'<[^>]+>', '', _html.unescape(desc_raw)).strip()[:200]

                pub_date = item_el.findtext("pubDate", "")
                date_str = ""
                if pub_date:
                    try:
                        dt = datetime.strptime(pub_date[:25].strip(), "%a, %d %b %Y %H:%M:%S")
                        date_str = dt.strftime("%Y-%m-%d")
                    except Exception:
                        date_str = pub_date[:10]

                tag, tagColor = _classify_news(headline, summary)

                items.append({
                    "title": headline,
                    "source": source,
                    "date": date_str,
                    "summary": summary if summary else headline,
                    "tag": tag,
                    "tagColor": tagColor,
                    "link": link,
                    "url_hash": url_hash,
                })

        except Exception as e:
            print(f"[WARN] RSS fetch failed for {src['name']} ({src['url'][:60]}...): {e}")

    items.sort(key=lambda x: x.get("date", ""), reverse=True)
    items = items[:50]

    _news_cache["items"] = items
    _news_cache["ts"] = now
    return items


def _persist_news_to_db(items: list):
    """Save fetched news items to DB (upsert, skip duplicates)."""
    if not execute_query or not items:
        return
    for item in items:
        try:
            execute_query(
                """INSERT INTO news_articles (url_hash, title, source, summary, link, category, category_color, pub_date)
                   VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                   ON CONFLICT (url_hash) DO NOTHING""",
                (item.get("url_hash", ""), item["title"], item.get("source", ""),
                 item.get("summary", ""), item.get("link", ""),
                 item.get("tag", "市场动态"), item.get("tagColor", ""),
                 item.get("date") or None)
            )
        except Exception as e:
            print(f"[WARN] DB insert news failed: {e}")


def _scheduled_fetch_news():
    """Scheduled job: fetch RSS + persist to DB."""
    print("[Scheduler] Fetching news from 4 sources...")
    _news_cache["ts"] = 0  # force refresh
    items = _fetch_rss_news()
    _persist_news_to_db(items)
    print(f"[Scheduler] Fetched {len(items)} news items")


def _generate_olivia_commentary(news_items: list) -> str:
    """让 Olivia 基于当日新闻生成综合点评。"""
    if not news_items:
        return ""

    today = datetime.now().strftime("%Y-%m-%d")
    news_digest = "\n".join(
        f"- [{item.get('source', '')}] {item['title']}"
        for item in news_items[:10]
    )

    system_prompt = (
        "你是 Olivia，Compass 平台的市场经济学家。"
        "你从宏观经济视角解读布里斯班房产市场，擅长分析利率政策、移民趋势、基建规划和供需数据。"
        "你的风格是：专业但亲切，像朋友聊天一样用大白话讲清楚市场动态。"
        "你会用数据说话，结合宏观经济分析给出有深度的见解。"
        "你特别关注布里斯班南区华人聚集区（Sunnybank、Calamvale、Eight Mile Plains、Rochedale、Mansfield）"
        "以及北区优质区（Ascot、Hamilton）的市场变化。"
        "始终使用中文回复。"
    )

    user_prompt = (
        f"今天是 {today}，以下是今日布里斯班房产相关新闻标题（来自 Google News、Domain、REA、后花园澳洲等源）：\n\n"
        f"{news_digest}\n\n"
        "请你作为 Olivia 写一篇今日市场综合解读（300-500字），要求：\n"
        "1. 先用一句话概括今天的市场信号\n"
        "2. 挑出 2-3 条最重要的新闻，用你的专业视角解读它们对布里斯班房产市场意味着什么\n"
        "3. 分析这些新闻对华人投资者的具体影响（买房时机、区域选择、资产配置等）\n"
        "4. 最后给出 Olivia 的今日建议（1-2 句话）\n"
        "5. 用自然的聊天口吻，但要有专业深度，不要泛泛而谈\n"
        "6. 开头直接切入正题，不要问候语\n"
        "7. 适当使用换行分段，让阅读更舒适\n"
        "8. 不要使用任何 markdown 格式符号（如 ** 或 * 或 # 或 - ），直接用纯文本表达，用换行和空行来分段"
    )

    try:
        client, _model, _temp = _get_ai_client()
        response = client.chat.completions.create(
            model=_model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            max_tokens=4096,
            temperature=_temp,
        )
        commentary = response.choices[0].message.content.strip()
        commentary = commentary.replace('**', '').replace('*', '')
        return commentary
    except Exception as e:
        print(f"[WARN] Olivia commentary generation failed: {e}")
        import traceback
        traceback.print_exc()
        return ""


def _scheduled_commentary(period: str):
    """Scheduled job: generate Olivia commentary and persist to DB."""
    print(f"[Scheduler] Generating Olivia {period} commentary...")
    today = datetime.now().strftime("%Y-%m-%d")

    # 检查 DB 中是否已有今日该时段点评
    if execute_query:
        existing = execute_query(
            "SELECT id FROM news_commentaries WHERE pub_date = %s AND period = %s",
            (today, period)
        )
        if existing:
            print(f"[Scheduler] {period} commentary already exists for {today}, skipping")
            return

    # 获取今天的新闻
    items = _fetch_rss_news()
    if not items:
        print("[Scheduler] No news items available for commentary")
        return

    commentary = _generate_olivia_commentary(items)
    if not commentary:
        print("[Scheduler] Commentary generation returned empty")
        return

    # 持久化到 DB
    if execute_query:
        try:
            execute_query(
                """INSERT INTO news_commentaries (pub_date, period, content, article_ids)
                   VALUES (%s, %s, %s, %s)
                   ON CONFLICT (pub_date, period) DO UPDATE SET content = EXCLUDED.content""",
                (today, period, commentary, [])
            )
            print(f"[Scheduler] {period} commentary saved to DB")
        except Exception as e:
            print(f"[WARN] Failed to save commentary to DB: {e}")

    # 更新内存缓存
    _commentary_cache["text"] = commentary
    _commentary_cache["date"] = today
    _commentary_cache["period"] = period
    _commentary_cache["ts"] = _time.time()


# ---- 后台线程生成 Olivia 点评（不阻塞 API 响应）----
_olivia_lock = threading.Lock()
_olivia_generating = False

def _trigger_olivia_background(news_items: list):
    """在后台线程中生成 Olivia 点评。"""
    global _olivia_generating
    with _olivia_lock:
        if _olivia_generating:
            return
        _olivia_generating = True

    def _run():
        global _olivia_generating
        try:
            today = datetime.now().strftime("%Y-%m-%d")
            commentary = _generate_olivia_commentary(news_items)
            if commentary:
                _commentary_cache["text"] = commentary
                _commentary_cache["date"] = today
                _commentary_cache["period"] = "on_demand"
                _commentary_cache["ts"] = _time.time()
                # 也存 DB
                if execute_query:
                    try:
                        execute_query(
                            """INSERT INTO news_commentaries (pub_date, period, content)
                               VALUES (%s, 'on_demand', %s)
                               ON CONFLICT (pub_date, period) DO UPDATE SET content = EXCLUDED.content""",
                            (today, commentary)
                        )
                    except Exception:
                        pass
        finally:
            with _olivia_lock:
                _olivia_generating = False

    t = threading.Thread(target=_run, daemon=True)
    t.start()


# ---- APScheduler 定时任务 ----
try:
    from apscheduler.schedulers.background import BackgroundScheduler
    from apscheduler.triggers.cron import CronTrigger
    import pytz

    _AEST = pytz.timezone("Australia/Brisbane")
    _scheduler = BackgroundScheduler(timezone=_AEST)

    # 每小时 :05 抓取新闻
    _scheduler.add_job(_scheduled_fetch_news, CronTrigger(minute=5), id="hourly_news", replace_existing=True)
    # 每天 8:00 AM AEST 生成晨报
    _scheduler.add_job(lambda: _scheduled_commentary("morning"), CronTrigger(hour=8, minute=0), id="morning_commentary", replace_existing=True)
    # 每天 6:00 PM AEST 生成晚报
    _scheduler.add_job(lambda: _scheduled_commentary("evening"), CronTrigger(hour=18, minute=0), id="evening_commentary", replace_existing=True)

    # DevIntel: 每日 3:00AM AEST 抓取开发情报
    try:
        from devintel.scheduler_jobs import scheduled_devintel_crawl
        _scheduler.add_job(scheduled_devintel_crawl, CronTrigger(hour=3, minute=0),
                           id="daily_devintel", replace_existing=True)
        print("[OK] DevIntel daily crawl job registered (3:00 AM)")
    except Exception as e:
        print(f"[WARN] DevIntel scheduler job failed: {e}")

    _scheduler.start()
    print("[OK] APScheduler started: hourly news + 8AM/6PM Olivia + 3AM DevIntel")
except Exception as e:
    print(f"[WARN] APScheduler init failed: {e}. News will still work on-demand.")


# ---- 新闻全文抓取 + 中文翻译 ----

def _fetch_article_content(url: str) -> str:
    """抓取新闻原文正文。支持 Google News 重定向 + 多种网站结构。"""
    _BROWSER_UA = (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/131.0.0.0 Safari/537.36"
    )
    try:
        req = urllib.request.Request(url, headers={
            "User-Agent": _BROWSER_UA,
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-AU,en;q=0.9,zh-CN;q=0.8",
        })
        with urllib.request.urlopen(req, timeout=20) as resp:
            raw = resp.read()
            charset = resp.headers.get_content_charset() or "utf-8"
            html_text = raw.decode(charset, errors="replace")
            final_url = resp.url
            print(f"[INFO] Article fetched from: {final_url} ({len(html_text)} chars)")

        clean_paras = []

        # 策略1：<article> 标签
        article_match = _re.search(
            r"<article[^>]*>(.*?)</article>", html_text, _re.DOTALL | _re.IGNORECASE
        )
        if article_match:
            paras = _re.findall(r"<p[^>]*>(.*?)</p>", article_match.group(1), _re.DOTALL | _re.IGNORECASE)
            for p in paras:
                text = _re.sub(r"<[^>]+>", "", p).strip()
                text = _html.unescape(text)
                if len(text) > 20:
                    clean_paras.append(text)

        # 策略2：全页 <p>
        if len(clean_paras) < 3:
            all_paras = _re.findall(r"<p[^>]*>(.*?)</p>", html_text, _re.DOTALL | _re.IGNORECASE)
            seen = set(clean_paras)
            for p in all_paras:
                text = _re.sub(r"<[^>]+>", "", p).strip()
                text = _html.unescape(text)
                if len(text) > 20 and text not in seen:
                    lower = text.lower()
                    if any(skip in lower for skip in [
                        "cookie", "subscribe", "sign up", "log in", "copyright",
                        "privacy policy", "terms of", "advertisement", "all rights",
                        "javascript", "browser"
                    ]):
                        continue
                    clean_paras.append(text)
                    seen.add(text)

        # 策略3：content/body div
        if len(clean_paras) < 3:
            div_texts = _re.findall(
                r'<div[^>]*class="[^"]*(?:content|body|text|story|article)[^"]*"[^>]*>(.*?)</div>',
                html_text, _re.DOTALL | _re.IGNORECASE
            )
            seen = set(clean_paras)
            for div_html in div_texts:
                texts = _re.findall(r"<p[^>]*>(.*?)</p>", div_html, _re.DOTALL | _re.IGNORECASE)
                for p in texts:
                    text = _re.sub(r"<[^>]+>", "", p).strip()
                    text = _html.unescape(text)
                    if len(text) > 20 and text not in seen:
                        clean_paras.append(text)
                        seen.add(text)

        result = "\n\n".join(clean_paras[:30])
        print(f"[INFO] Extracted {len(clean_paras)} paragraphs ({len(result)} chars)")
        return result

    except Exception as e:
        print(f"[WARN] Article fetch failed for {url}: {e}")
        return ""


def _translate_article(text: str) -> str:
    """调用 AI 将英文文章翻译为中文。"""
    if not text:
        return ""
    if len(text) > 5000:
        text = text[:5000] + "\n\n[... 原文过长，已截断 ...]"

    try:
        client, _model, _temp = _get_ai_client()
        response = client.chat.completions.create(
            model=_model,
            messages=[
                {"role": "system", "content": (
                    "你是一位专业的英中翻译。请将以下英文房产新闻完整翻译成中文。"
                    "要求：保持专业但通俗易懂，适合华人投资者阅读。"
                    "保留原文的段落结构。不要添加任何额外评论。"
                    "必须全部使用中文输出，不要保留任何英文。"
                    "不要使用 markdown 格式符号（如 ** 或 *）。用纯文本。"
                )},
                {"role": "user", "content": f"请将以下英文新闻文章翻译成中文：\n\n{text}"}
            ],
            max_tokens=4096,
            temperature=0.3,
        )
        translated = response.choices[0].message.content.strip()
        return translated.replace('**', '').replace('*', '')
    except Exception as e:
        print(f"[WARN] Article translation failed: {e}")
        return ""


def _ai_expand_summary(title: str, summary: str) -> str:
    """当无法抓取原文时，用 AI 基于标题和摘要生成中文解读。"""
    try:
        client, _model, _temp = _get_ai_client()
        response = client.chat.completions.create(
            model=_model,
            messages=[
                {"role": "system", "content": (
                    "你是 Olivia，Compass 平台的市场经济学家。"
                    "你的任务是根据新闻标题和摘要，撰写一段中文详细解读（200-400字）。"
                    "分析这条新闻对布里斯班房产市场和华人投资者的影响。"
                    "你必须始终使用中文回复，即使新闻原文是英文。"
                    "不要使用任何 markdown 格式符号（如 ** 或 *）。用纯文本，用换行分段。"
                )},
                {"role": "user", "content": f"以下是一条房产新闻，请用中文撰写详细解读：\n\n标题：{title}\n\n摘要：{summary}\n\n请用中文撰写 Olivia 的专业解读。"}
            ],
            max_tokens=2048,
            temperature=_temp,
        )
        result = response.choices[0].message.content.strip()
        return result.replace('**', '').replace('*', '')
    except Exception as e:
        print(f"[WARN] AI expand summary failed: {e}")
        return ""


# ---- API 端点 ----

@app.get("/api/news/detail")
def get_news_detail(url: str, title: str = "", summary: str = ""):
    """Olivia AI 解读 + 尝试抓取原文。"""
    if not url:
        return {"error": "url parameter required"}

    url_hash = _hashlib.md5(url.encode()).hexdigest()

    # 检查 DB 缓存（如果可用）
    if execute_query:
        try:
            cached = execute_query(
                "SELECT original_text, translated_text FROM news_article_details WHERE url_hash = %s",
                (url_hash,)
            )
            if cached:
                return {
                    "original_text": cached[0].get("original_text", ""),
                    "translated_text": cached[0].get("translated_text", ""),
                    "url": url,
                    "cached": True,
                }
        except Exception:
            pass  # Table may not exist yet, fall through to in-memory

    original = ""
    translated = ""

    # 步骤 1：尝试抓取原文（限时 5 秒，缩短等待）
    try:
        import concurrent.futures
        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(_fetch_article_content, url)
            try:
                original = future.result(timeout=5)
            except concurrent.futures.TimeoutError:
                original = ""
    except Exception:
        original = ""

    # 步骤 2：翻译
    if original:
        translated = _translate_article(original)

    if not translated and (title or summary):
        translated = _ai_expand_summary(title, summary)

    if not original and not translated:
        if title:
            translated = f"新闻概要：{title}\n\n{summary}" if summary else f"新闻概要：{title}"

    return {
        "original_text": original,
        "translated_text": translated,
        "url": url,
        "cached": False,
    }


@app.get("/api/news")
def get_news():
    """获取当日新闻 + Olivia 最新点评"""
    items = _fetch_rss_news()
    # 持久化到 DB（异步不阻塞）
    t = threading.Thread(target=_persist_news_to_db, args=(items,), daemon=True)
    t.start()

    today = datetime.now().strftime("%Y-%m-%d")

    # 1. 先查内存缓存
    commentary = ""
    commentary_period = ""
    if _commentary_cache["text"] and _commentary_cache["date"] == today:
        commentary = _commentary_cache["text"]
        commentary_period = _commentary_cache.get("period", "")

    # 2. 再查 DB
    if not commentary and execute_query:
        try:
            db_commentary = execute_query(
                "SELECT content, period FROM news_commentaries WHERE pub_date = %s ORDER BY created_at DESC LIMIT 1",
                (today,)
            )
            if db_commentary:
                commentary = db_commentary[0]["content"]
                commentary_period = db_commentary[0]["period"]
                _commentary_cache["text"] = commentary
                _commentary_cache["date"] = today
                _commentary_cache["period"] = commentary_period
                _commentary_cache["ts"] = _time.time()
        except Exception:
            pass

    # 3. 无点评则后台生成
    if not commentary and items:
        _trigger_olivia_background(items)

    return {
        "news": items or [],
        "olivia_commentary": commentary,
        "commentary_date": today,
        "commentary_period": commentary_period,
    }


@app.get("/api/news/commentaries")
def get_news_commentaries(page: int = 1, page_size: int = 10):
    """获取 Olivia 过往点评列表（分页）"""
    if not execute_query:
        return {"commentaries": [], "total": 0, "page": page, "page_size": page_size}

    offset = (page - 1) * page_size

    try:
        total_result = execute_query("SELECT COUNT(*) as cnt FROM news_commentaries")
        total = total_result[0]["cnt"] if total_result else 0

        rows = execute_query(
            """SELECT id, pub_date, period, content, created_at
               FROM news_commentaries
               ORDER BY pub_date DESC, created_at DESC
               LIMIT %s OFFSET %s""",
            (page_size, offset)
        )

        commentaries = []
        for r in (rows or []):
            commentaries.append({
                "id": r["id"],
                "pub_date": str(r["pub_date"]) if r.get("pub_date") else "",
                "period": r.get("period", ""),
                "content": r.get("content", ""),
                "created_at": str(r["created_at"]) if r.get("created_at") else "",
            })

        return {
            "commentaries": commentaries,
            "total": total,
            "page": page,
            "page_size": page_size,
        }
    except Exception as e:
        print(f"[WARN] Get commentaries failed: {e}")
        return {"commentaries": [], "total": 0, "page": page, "page_size": page_size}


@app.get("/api/news/by-date")
def get_news_by_date(days: int = 7, category: Optional[str] = None):
    """获取按日期分组的新闻"""
    if not execute_query:
        # Fallback: 用内存缓存的新闻按日期分组
        items = _fetch_rss_news()
        if category:
            items = [i for i in items if i.get("tag") == category]
        grouped: dict = {}
        for item in items:
            d = item.get("date", "未知")
            if d not in grouped:
                grouped[d] = []
            grouped[d].append(item)
        return {"dates": [{"date": k, "articles": v} for k, v in grouped.items()]}

    try:
        params: list = [days]
        query = """SELECT id, title, source, summary, link, category, category_color, pub_date
                   FROM news_articles
                   WHERE pub_date >= CURRENT_DATE - INTERVAL '%s days'"""
        if category:
            query += " AND category = %s"
            params.append(category)
        query += " ORDER BY pub_date DESC, created_at DESC"

        rows = execute_query(query, tuple(params))

        grouped: dict = {}
        for r in (rows or []):
            d = str(r.get("pub_date", "未知"))
            if d not in grouped:
                grouped[d] = []
            grouped[d].append({
                "id": r.get("id"),
                "title": r.get("title", ""),
                "source": r.get("source", ""),
                "summary": r.get("summary", ""),
                "link": r.get("link", ""),
                "tag": r.get("category", "市场动态"),
                "tagColor": r.get("category_color", "bg-blue-100 text-blue-700"),
                "date": d,
            })

        return {"dates": [{"date": k, "articles": v} for k, v in grouped.items()]}
    except Exception as e:
        print(f"[WARN] Get news by date failed: {e}")
        return {"dates": []}


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

        # 统一字段名 + 计算百分位
        for s in all_schools:
            # 兼容 type / school_type
            if 'school_type' not in s and 'type' in s:
                s['school_type'] = s['type']
            if 'type' not in s and 'school_type' in s:
                s['type'] = s['school_type']
            # 计算 naplan_percentile
            if not s.get('naplan_percentile') and s.get('naplan_score'):
                s['naplan_percentile'] = max(0, min(100, round((s['naplan_score'] - 300) / 4)))

        # 过滤
        filtered = all_schools
        if suburb:
            filtered = [s for s in filtered if (
                s.get('suburb', '').lower() == suburb.lower() or
                suburb.lower() in [c.lower() for c in (s.get('catchment_suburbs', []) if isinstance(s.get('catchment_suburbs', []), list) else [s.get('catchment_suburbs', '')])]
            )]
        if school_type:
            filtered = [s for s in filtered if (
                s.get('school_type', '').lower() == school_type.lower() or
                s.get('type', '').lower() == school_type.lower()
            )]

        # 按 NAPLAN 百分位排序
        filtered.sort(key=lambda x: x.get('naplan_percentile', 0) or 0, reverse=True)

        return {"schools": filtered, "total": len(filtered)}
    except Exception as e:
        return {"schools": [], "total": 0}


@app.get("/api/school/{school_name}/catchment-data")
def get_school_catchment_data(school_name: str):
    """
    获取学校学区聚合数据：合并所有 catchment suburbs 的 sales/trends/crime/rental
    """
    from concurrent.futures import ThreadPoolExecutor, as_completed

    CORE_SUBURBS = ALL_SUBURB_NAMES

    # 1. 加载学校数据
    try:
        schools_path = os.path.join(os.path.dirname(__file__), "data/qld_schools.json")
        with open(schools_path, "r", encoding="utf-8") as f:
            all_schools = json.load(f)
    except Exception:
        raise HTTPException(status_code=500, detail="无法加载学校数据")

    # 查找学校（URL decode 后匹配）
    school = None
    for s in all_schools:
        if s['name'].lower() == school_name.lower():
            school = s
            break
    if not school:
        raise HTTPException(status_code=404, detail=f"未找到学校: {school_name}")

    # 统一字段
    if school.get('naplan_score') and not school.get('naplan_percentile'):
        school['naplan_percentile'] = max(0, min(100, round((school['naplan_score'] - 300) / 4)))
    if 'school_type' not in school and 'type' in school:
        school['school_type'] = school['type']

    catchment = school.get('catchment_suburbs', [])
    data_suburbs = [s for s in catchment if s in CORE_SUBURBS]
    no_data_suburbs = [s for s in catchment if s not in CORE_SUBURBS]

    if not data_suburbs:
        return {
            "school": school,
            "catchment_data": {
                "suburbs_with_data": [],
                "suburbs_without_data": no_data_suburbs,
                "aggregated": None
            }
        }

    # 2. 并行查询每个有数据的郊区
    def query_suburb(suburb_name_inner):
        result = {"suburb": suburb_name_inner}
        try:
            # 中位价 + 总销量
            stats = execute_query(
                "SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sale_price) as median_price, "
                "COUNT(*) as total_sales FROM sales WHERE UPPER(suburb) = UPPER(%s)",
                (suburb_name_inner,)
            )
            if stats and len(stats) > 0:
                row = stats[0]
                result["median_price"] = float(row.get('median_price', 0) or 0)
                result["total_sales"] = int(row.get('total_sales', 0) or 0)
            else:
                result["median_price"] = 0
                result["total_sales"] = 0

            # 近期成交 (每个郊区取 5 条)
            sales_rows = execute_query(
                "SELECT full_address as address, sale_price as sold_price, "
                "sale_date as sold_date, property_type, bedrooms, bathrooms, land_size, "
                "INITCAP(suburb) as suburb FROM sales "
                "WHERE UPPER(suburb) = UPPER(%s) ORDER BY sale_date DESC LIMIT 5",
                (suburb_name_inner,)
            )
            result["recent_sales"] = []
            for r in (sales_rows or []):
                result["recent_sales"].append({
                    "address": r.get("address", ""),
                    "suburb": r.get("suburb", suburb_name_inner),
                    "sold_price": int(r.get("sold_price", 0) or 0),
                    "sold_date": str(r.get("sold_date", "")),
                    "property_type": r.get("property_type", ""),
                    "bedrooms": int(r.get("bedrooms", 0) or 0),
                    "bathrooms": int(r.get("bathrooms", 0) or 0),
                    "land_size": int(r.get("land_size", 0) or 0),
                })

            # 月度走势 (12 个月)
            trend_rows = execute_query(
                "SELECT TO_CHAR(DATE_TRUNC('month', sale_date), 'YYYY-MM') as month, "
                "PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sale_price) as median_price, "
                "COUNT(*) as total_sales FROM sales "
                "WHERE UPPER(suburb) = UPPER(%s) AND sale_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '12 months') "
                "GROUP BY DATE_TRUNC('month', sale_date) ORDER BY month",
                (suburb_name_inner,)
            )
            result["monthly_trends"] = [
                {"month": r["month"], "median_price": float(r.get("median_price", 0) or 0),
                 "total_sales": int(r.get("total_sales", 0))}
                for r in (trend_rows or [])
            ]

            # 犯罪统计
            crime_rows = execute_query(
                "SELECT category, SUM(count) as total FROM crime_stats "
                "WHERE LOWER(suburb) = LOWER(%s) AND month_year >= TO_CHAR(NOW() - INTERVAL '12 months', 'YYYY-MM') "
                "GROUP BY category ORDER BY total DESC",
                (suburb_name_inner,)
            )
            result["crime"] = {r['category']: int(r['total']) for r in (crime_rows or [])}

        except Exception as e:
            result["error"] = str(e)
        return result

    # 3. ThreadPoolExecutor 并行查询
    suburb_results = {}
    with ThreadPoolExecutor(max_workers=7) as pool:
        futures = {pool.submit(query_suburb, s): s for s in data_suburbs}
        for future in as_completed(futures):
            suburb = futures[future]
            try:
                suburb_results[suburb] = future.result()
            except Exception as e:
                suburb_results[suburb] = {"suburb": suburb, "error": str(e)}

    # 4. 聚合结果
    all_sales = []
    all_trends = {}
    total_sales_sum = 0
    weighted_price_sum = 0
    crime_agg = {}

    for suburb, data in suburb_results.items():
        ts = data.get("total_sales", 0)
        mp = data.get("median_price", 0)
        total_sales_sum += ts
        weighted_price_sum += mp * ts

        all_sales.extend(data.get("recent_sales", []))

        for trend in data.get("monthly_trends", []):
            month = trend["month"]
            if month not in all_trends:
                all_trends[month] = []
            all_trends[month].append(trend)

        for cat, count in data.get("crime", {}).items():
            crime_agg[cat] = crime_agg.get(cat, 0) + count

    # 排序 + 截取近期成交
    all_sales.sort(key=lambda x: x.get("sold_date", ""), reverse=True)
    all_sales = all_sales[:10]

    # 聚合月度走势
    agg_trends = []
    for month in sorted(all_trends.keys()):
        entries = all_trends[month]
        total_count = sum(e["total_sales"] for e in entries)
        if total_count > 0:
            weighted_median = sum(e["median_price"] * e["total_sales"] for e in entries) / total_count
        else:
            weighted_median = 0
        agg_trends.append({
            "month": month,
            "median_price": round(weighted_median),
            "total_sales": total_count
        })

    # 租赁数据 (从 JSON 文件平均)
    rental_agg = {}
    try:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        with open(os.path.join(script_dir, "data", "suburb_rental_yields.json"), "r", encoding="utf-8") as f:
            rental_all = json.load(f)
        rental_entries = [rental_all[s] for s in data_suburbs if s in rental_all]
        if rental_entries:
            for key in ["median_house_rent_weekly", "median_unit_rent_weekly",
                        "house_rental_yield_pct", "unit_rental_yield_pct", "vacancy_rate_pct",
                        "days_on_market_house", "days_on_market_unit"]:
                vals = [e.get(key, 0) for e in rental_entries if e.get(key)]
                rental_agg[key] = round(sum(vals) / len(vals), 2) if vals else 0
    except Exception:
        pass

    aggregated_median = round(weighted_price_sum / max(total_sales_sum, 1))

    return {
        "school": school,
        "catchment_data": {
            "suburbs_with_data": data_suburbs,
            "suburbs_without_data": no_data_suburbs,
            "aggregated": {
                "median_price": aggregated_median,
                "total_sales": total_sales_sum,
                "recent_sales": all_sales,
                "monthly_trends": agg_trends,
                "rental": rental_agg,
                "crime": {
                    "total_crimes": sum(crime_agg.values()),
                    "categories": crime_agg
                }
            }
        }
    }


@app.post("/api/chat")
@limiter.limit("20/minute")
def chat_with_advisor(
    request: Request,
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
        client, _model, _temp = _get_ai_client()

        amanda_chat_base = (
            "你是 Amanda，Compass 平台的首席房产分析师，也是用户的专属 AI 顾问。"
            "你在布里斯班从事房产投资顾问工作超过 10 年，专注服务华人投资者。"
            "你的风格是：专业但亲切，像朋友聊天一样用大白话讲清楚问题。"
            "请用中文回答，每次回答控制在200字以内。\n\n"
        )
        context_extras = {
            "first_home": """你当前正在帮助首次置业者，你精通：
- 昆士兰首次置业补贴 (FHOG $30,000，仅限新房，房价≤$750,000)
- 印花税减免政策（首置新房≤$500,000全免）
- 首置担保计划（5%首付，免LMI）
- 布里斯班各郊区适合首次购房的入门区域
- 贷款预批、验房、交割流程""",
            "overseas": """你当前正在帮助海外投资者，你精通：
- FIRB 审批流程和费用（<$75万约$14,100）
- AFAD 额外印花税 8%（昆士兰附加费）
- 海外人士只能购买全新住宅或空地
- CGT 预扣税 12.5%
- 非居民租金收入税务处理
- 布里斯班新楼盘和开发区推荐""",
        }

        system_content = amanda_chat_base + context_extras.get(context, "你帮助华人投资者做出明智的房产投资决策。")

        # 构建消息列表
        messages = [{"role": "system", "content": system_content}]

        # 添加历史对话（限制最近10轮）
        for h in history[-20:]:
            if h.get("role") in ["user", "assistant"] and h.get("content"):
                messages.append({"role": h["role"], "content": h["content"]})

        messages.append({"role": "user", "content": message})

        response = client.chat.completions.create(
            model=_model,
            messages=messages,
            max_tokens=1024,
            temperature=_temp,
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
        print(f"[ERROR] Chat failed: {e}")
        raise HTTPException(status_code=500, detail="AI 聊天服务暂时不可用，请稍后重试")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8888)
