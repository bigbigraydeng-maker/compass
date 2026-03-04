"""
Compass MVP 数据库连接模块
"""
import pg8000
from contextlib import contextmanager
import os
from urllib.parse import urlparse, unquote


@contextmanager
def get_db_connection():
    """获取数据库连接的上下文管理器"""
    # 直接从环境变量读取 DATABASE_URL
    database_url = os.getenv("DATABASE_URL")
    if not database_url:
        raise ValueError("DATABASE_URL environment variable is required")
    
    # 解析 DATABASE_URL
    url = urlparse(database_url)
    
    user = url.username
    password = unquote(url.password) if url.password else None
    host = url.hostname
    port = url.port or 5432
    database = url.path.lstrip('/')
    
    conn = pg8000.connect(
        user=user,
        password=password,
        host=host,
        port=int(port),
        database=database,
        ssl_context={'check_hostname': False, 'verify_mode': False}
    )
    try:
        yield conn
    finally:
        conn.close()


@contextmanager
def get_db_cursor(conn):
    """获取数据库游标的上下文管理器"""
    cursor = conn.cursor()
    try:
        yield cursor
    finally:
        cursor.close()


def execute_query(query: str, params: tuple = None):
    """执行查询并返回结果"""
    with get_db_connection() as conn:
        with get_db_cursor(conn) as cursor:
            cursor.execute(query, params or ())
            if query.strip().upper().startswith('SELECT'):
                columns = [desc[0] for desc in cursor.description]
                rows = cursor.fetchall()
                return [dict(zip(columns, row)) for row in rows]
            else:
                conn.commit()
                return cursor.rowcount
