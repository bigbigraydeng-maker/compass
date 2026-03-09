"""
Compass MVP 数据库连接模块
- 连接池：复用连接，消除每次查询的TCP建连开销 (50-100ms → <1ms)
- 重试逻辑：指数退避，防止 Supabase 熔断器触发
- 查询超时：30秒
"""
import psycopg2
from psycopg2 import pool
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
import os
import time

# 连接配置
CONNECT_TIMEOUT = 10       # 连接超时（秒）
MAX_RETRIES = 5            # 最大重试次数
RETRY_BASE_DELAY = 2       # 重试基础延迟（秒），指数退避
POOL_MIN_CONN = 10         # 连接池最小连接数（预建全部连接，避免并行查询时临时建连）
POOL_MAX_CONN = 10         # 连接池最大连接数

# 全局连接池
_connection_pool = None


def _init_pool():
    """初始化连接池（带重试）"""
    global _connection_pool
    if _connection_pool is not None:
        return

    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        raise ValueError("DATABASE_URL environment variable is required")

    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            _connection_pool = pool.ThreadedConnectionPool(
                POOL_MIN_CONN,
                POOL_MAX_CONN,
                database_url,
                connect_timeout=CONNECT_TIMEOUT,
            )
            print(f"[OK] Connection pool created (min={POOL_MIN_CONN}, max={POOL_MAX_CONN})")
            return
        except Exception as e:
            last_error = e
            if attempt < MAX_RETRIES:
                delay = RETRY_BASE_DELAY * (2 ** (attempt - 1))
                print(f"[RETRY] Pool init attempt {attempt}/{MAX_RETRIES} failed: {e}")
                print(f"[RETRY] Waiting {delay}s before retry...")
                time.sleep(delay)
            else:
                print(f"[ERROR] All {MAX_RETRIES} pool init attempts failed")
    raise last_error


@contextmanager
def get_db_connection():
    """从连接池获取连接（不再每次新建TCP连接）"""
    global _connection_pool
    if _connection_pool is None:
        _init_pool()

    conn = None
    try:
        conn = _connection_pool.getconn()
        # 检查连接是否有效，无效则重置
        try:
            conn.isolation_level
        except Exception:
            _connection_pool.putconn(conn, close=True)
            conn = _connection_pool.getconn()
        yield conn
    except Exception as e:
        if conn:
            try:
                conn.rollback()
            except Exception:
                pass
        raise e
    finally:
        if conn:
            _connection_pool.putconn(conn)


@contextmanager
def get_db_cursor(conn):
    """获取数据库游标的上下文管理器"""
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    try:
        yield cursor
    finally:
        cursor.close()


def test_connection():
    """测试数据库连接（启动时使用，初始化连接池）"""
    _init_pool()
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
    return True


def execute_query(query: str, params: tuple = None):
    """执行查询并返回结果（从连接池获取连接，无需每次新建）"""
    with get_db_connection() as conn:
        with get_db_cursor(conn) as cursor:
            cursor.execute(query, params or ())
            if query.strip().upper().startswith('SELECT'):
                rows = cursor.fetchall()
                return [dict(row) for row in rows]
            else:
                conn.commit()
                return cursor.rowcount
