"""
Compass MVP 数据库连接模块（模拟数据版本）
"""
from contextlib import contextmanager
from config import settings
import re


# 模拟数据
MOCK_PROPERTIES = [
    {
        "id": 1,
        "address": "93 Dunedin Street, SUNNYBANK",
        "suburb": "Sunnybank",
        "property_type": "house",
        "land_size": 638,
        "bedrooms": 0,
        "bathrooms": 0
    },
    {
        "id": 2,
        "address": "31 Shelley Street, SUNNYBANK",
        "suburb": "Sunnybank",
        "property_type": "house",
        "land_size": 540,
        "bedrooms": 0,
        "bathrooms": 0
    },
    {
        "id": 3,
        "address": "21/25 Buckingham Place, EIGHT MILE PLAINS",
        "suburb": "Eight Mile Plains",
        "property_type": "house",
        "land_size": 0,
        "bedrooms": 0,
        "bathrooms": 0
    },
    {
        "id": 4,
        "address": "30 Tuberose Place, CALAMVALE",
        "suburb": "Calamvale",
        "property_type": "house",
        "land_size": 639,
        "bedrooms": 0,
        "bathrooms": 0
    }
]

MOCK_SALES = [
    {
        "id": 1,
        "property_id": 1,
        "sold_price": 1358000,
        "sold_date": "2025-11-05"
    },
    {
        "id": 2,
        "property_id": 2,
        "sold_price": 1780000,
        "sold_date": "2025-10-25"
    },
    {
        "id": 3,
        "property_id": 3,
        "sold_price": 910000,
        "sold_date": "2026-01-05"
    },
    {
        "id": 4,
        "property_id": 4,
        "sold_price": 1270000,
        "sold_date": "2026-02-25"
    }
]


@contextmanager
def get_db_connection():
    """获取数据库连接的上下文管理器（模拟版本）"""
    class MockConnection:
        def __init__(self):
            self.committed = False
        
        def commit(self):
            self.committed = True
        
        def close(self):
            pass
    
    conn = MockConnection()
    try:
        yield conn
    finally:
        conn.close()


@contextmanager
def get_db_cursor(conn):
    """获取数据库游标的上下文管理器（模拟版本）"""
    class MockCursor:
        def __init__(self):
            self.description = None
            self.rowcount = 0
        
        def execute(self, query, params=None):
            self.rowcount = 0
            self.description = None
            
            # 解析查询并返回模拟数据
            query_lower = query.lower()
            
            elif "select count(*) from" in query_lower and "from (" in query_lower:
                # 子查询计数
                self.description = [("total",)]
                self._result = [{"total": 4}]  # 返回总数
                self.rowcount = 1
            
            elif "from sales s" in query_lower and "join properties p" in query_lower:
                # 复杂查询：返回销售记录和房产信息
                self.description = [
                    ("id",), ("property_id",), ("sold_price",), ("sold_date",),
                    ("address",), ("suburb",), ("property_type",), ("land_size",),
                    ("bedrooms",), ("bathrooms",)
                ]
                
                results = []
                for sale in MOCK_SALES:
                    prop = next((p for p in MOCK_PROPERTIES if p["id"] == sale["property_id"]), None)
                    if prop:
                        results.append({
                            "id": sale["id"],
                            "property_id": sale["property_id"],
                            "sold_price": sale["sold_price"],
                            "sold_date": sale["sold_date"],
                            "address": prop["address"],
                            "suburb": prop["suburb"],
                            "property_type": prop["property_type"],
                            "land_size": prop["land_size"],
                            "bedrooms": prop["bedrooms"],
                            "bathrooms": prop["bathrooms"]
                        })
                
                # 应用过滤
                if "where" in query_lower and "suburb" in query_lower:
                    suburb = params[0] if params else None
                    if suburb:
                        results = [r for r in results if r["suburb"] == suburb]
                
                # 应用排序和限制
                if "order by s.sold_date desc" in query_lower:
                    results.sort(key=lambda x: x["sold_date"], reverse=True)
                
                if "limit" in query_lower:
                    limit = 10
                    if params:
                        for param in params[-2:]:
                            if isinstance(param, int):
                                limit = param
                    results = results[:limit]
                
                self._result = results
                self.rowcount = len(results)
            
            elif "percentile_cont" in query_lower:
                # 中位价查询
                self.description = [("median_price",), ("total_sales",)]
                
                suburb = params[0] if params else None
                if suburb:
                    sales = [s for s in MOCK_SALES if MOCK_PROPERTIES[s["property_id"]-1]["suburb"] == suburb]
                else:
                    sales = MOCK_SALES
                
                if sales:
                    prices = [s["sold_price"] for s in sales]
                    prices_sorted = sorted(prices)
                    median = prices_sorted[len(prices_sorted)//2]
                    self._result = [(median, len(sales))]
                else:
                    self._result = [(0, 0)]
                
                self.rowcount = 1
        
        def fetchone(self):
            if hasattr(self, '_result') and self._result:
                return self._result[0]
            return None
        
        def fetchall(self):
            if hasattr(self, '_result'):
                return self._result
            return []
        
        def close(self):
            pass
    
    cursor = MockCursor()
    try:
        yield cursor
    finally:
        cursor.close()


def execute_query(query: str, params: tuple = None):
    """执行查询并返回结果（模拟版本）"""
    with get_db_connection() as conn:
        with get_db_cursor(conn) as cursor:
            cursor.execute(query, params or ())
            if query.strip().upper().startswith('SELECT'):
                return cursor.fetchall()
            else:
                conn.commit()
                return cursor.rowcount
