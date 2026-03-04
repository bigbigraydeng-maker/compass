"""
Compass MVP 数据库连接模块
"""
import pg8000
from contextlib import contextmanager
from config import settings
import re


@contextmanager
def get_db_connection():
    """获取数据库连接的上下文管理器"""
    # 解析 DATABASE_URL
    # 格式: postgresql://user:password@host:port/database
    match = re.match(r'postgresql://([^:]+):([^@]+)@([^:]+):(\d+)/(.+)', settings.DATABASE_URL)
    if not match:
        raise ValueError(f"Invalid DATABASE_URL format: {settings.DATABASE_URL}")
    
    user, password, host, port, database = match.groups()
    
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
