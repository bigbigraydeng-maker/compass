"""
Compass MVP 数据库连接模块（模拟数据版本）
"""
from contextlib import contextmanager
from mock_data import MOCK_PROPERTIES, MOCK_SALES


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
            self._result = []
        
        def execute(self, query, params=None):
            self.rowcount = 0
            self.description = None
            self._result = []
            
            query_lower = query.lower()
            
            # 获取所有 sales 和 properties 的组合数据
            all_results = []
            for sale in MOCK_SALES:
                prop = next((p for p in MOCK_PROPERTIES if p["id"] == sale["property_id"]), None)
                if prop:
                    all_results.append({
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
            
            # 确定 suburb 过滤条件
            target_suburb = None
            if params and len(params) > 0:
                if isinstance(params[0], str):
                    target_suburb = params[0]
            
            # 处理 COUNT 查询
            if "select count(*) from" in query_lower:
                filtered_sales = MOCK_SALES
                if target_suburb:
                    filtered_sales = []
                    for sale in MOCK_SALES:
                        prop = next((p for p in MOCK_PROPERTIES if p["id"] == sale["property_id"]), None)
                        if prop and prop["suburb"] == target_suburb:
                            filtered_sales.append(sale)
                
                self.description = [("total",)]
                self._result = [{"total": len(filtered_sales)}]
                self.rowcount = 1
            
            # 处理 JOIN 查询（返回销售记录和房产信息）
            elif "from sales s" in query_lower and "join properties p" in query_lower:
                filtered = all_results
                if target_suburb:
                    filtered = [r for r in filtered if r["suburb"] == target_suburb]
                
                # 排序
                if "order by s.sold_date desc" in query_lower:
                    filtered.sort(key=lambda x: x["sold_date"], reverse=True)
                
                # 限制数量
                if "limit" in query_lower:
                    limit = 10
                    if params:
                        for param in params:
                            if isinstance(param, int) and param > 0:
                                limit = param
                    filtered = filtered[:limit]
                
                self.description = [
                    ("id",), ("property_id",), ("sold_price",), ("sold_date",),
                    ("address",), ("suburb",), ("property_type",), ("land_size",),
                    ("bedrooms",), ("bathrooms",)
                ]
                self._result = filtered
                self.rowcount = len(filtered)
            
            # 处理中位价查询
            elif "percentile_cont" in query_lower:
                filtered_sales = MOCK_SALES
                if target_suburb:
                    filtered_sales = []
                    for sale in MOCK_SALES:
                        prop = next((p for p in MOCK_PROPERTIES if p["id"] == sale["property_id"]), None)
                        if prop and prop["suburb"] == target_suburb:
                            filtered_sales.append(sale)
                
                if filtered_sales:
                    prices = [s["sold_price"] for s in filtered_sales]
                    prices_sorted = sorted(prices)
                    median = prices_sorted[len(prices_sorted) // 2]
                    self._result = [(median, len(filtered_sales))]
                else:
                    self._result = [(0, 0)]
                
                self.description = [("median_price",), ("total_sales",)]
                self.rowcount = 1
        
        def fetchone(self):
            if self._result:
                return self._result[0]
            return None
        
        def fetchall(self):
            return self._result
        
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
