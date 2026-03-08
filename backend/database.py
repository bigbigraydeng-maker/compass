"""
Compass MVP 数据库连接模块
支持重试逻辑和连接超时，防止 Supabase 熔断器触发时应用崩溃
"""
import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
import os
import time

# 连接配置
CONNECT_TIMEOUT = 10       # 连接超时（秒）
MAX_RETRIES = 5            # 最大重试次数
RETRY_BASE_DELAY = 2       # 重试基础延迟（秒），指数退避


def _connect_with_retry(database_url: str, max_retries: int = MAX_RETRIES):
    """带重试逻辑的数据库连接"""
    last_error = None
    for attempt in range(1, max_retries + 1):
        try:
            conn = psycopg2.connect(
                database_url,
                connect_timeout=CONNECT_TIMEOUT,
                options="-c statement_timeout=30000"  # 查询超时 30 秒
            )
            return conn
        except Exception as e:
            last_error = e
            if attempt < max_retries:
                delay = RETRY_BASE_DELAY * (2 ** (attempt - 1))  # 指数退避: 2, 4, 8, 16s
                print(f"[RETRY] DB connection attempt {attempt}/{max_retries} failed: {e}")
                print(f"[RETRY] Waiting {delay}s before retry...")
                time.sleep(delay)
            else:
                print(f"[ERROR] All {max_retries} connection attempts failed")
    raise last_error


@contextmanager
def get_db_connection():
    """获取数据库连接的上下文管理器（带重试）"""
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        raise ValueError("DATABASE_URL environment variable is required")

    conn = _connect_with_retry(database_url, max_retries=3)
    try:
        yield conn
    finally:
        conn.close()


@contextmanager
def get_db_cursor(conn):
    """获取数据库游标的上下文管理器"""
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    try:
        yield cursor
    finally:
        cursor.close()


def test_connection():
    """测试数据库连接（启动时使用，带完整重试）"""
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        raise ValueError("DATABASE_URL environment variable is required")

    conn = _connect_with_retry(database_url, max_retries=MAX_RETRIES)
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
        return True
    finally:
        conn.close()


def execute_query(query: str, params: tuple = None):
    """执行查询并返回结果（带自动重试）"""
    with get_db_connection() as conn:
        with get_db_cursor(conn) as cursor:
            cursor.execute(query, params or ())
            if query.strip().upper().startswith('SELECT'):
                rows = cursor.fetchall()
                return [dict(row) for row in rows]
            else:
                conn.commit()
                return cursor.rowcount
