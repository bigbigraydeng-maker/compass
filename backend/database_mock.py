"""
Compass MVP 数据库连接模块（模拟数据版本）
"""
from contextlib import contextmanager
from mock_data import MOCK_PROPERTIES, MOCK_SALES

# 生成模拟在售房源数据
MOCK_LISTINGS = []
for i, prop in enumerate(MOCK_PROPERTIES[:50], 1):
    MOCK_LISTINGS.append({
        "id": i,
        "address": prop["address"],
        "suburb": prop["suburb"],
        "property_type": prop["property_type"],
        "bedrooms": prop["bedrooms"],
        "bathrooms": prop["bathrooms"],
        "car_spaces": 2 if prop["bedrooms"] >= 3 else 1,
        "land_size": prop["land_size"],
        "price_text": f"${prop['bedrooms'] * 300000 + prop['bathrooms'] * 100000}",
        "price": prop['bedrooms'] * 300000 + prop['bathrooms'] * 100000,
        "sale_method": "Private Treaty",
        "agent_name": "John Smith",
        "agent_company": "Compass Realty",
        "link": f"https://example.com/listing/{i}",
        "scraped_date": "2026-03-01",
        "created_at": "2026-03-01"
    })


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
            
            # 预合并所有数据
            all_joined = []
            for sale in MOCK_SALES:
                prop = next((p for p in MOCK_PROPERTIES if p["id"] == sale["property_id"]), None)
                if prop:
                    all_joined.append({
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
            
            # 从 params 中提取 suburb
            target_suburb = None
            if params:
                for param in params:
                    if isinstance(param, str) and param in ['Sunnybank', 'Eight Mile Plains', 'Calamvale']:
                        target_suburb = param
                        break
            
            # 优先处理中位数查询
            if "percentile_cont" in query_lower:
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
            
            # 然后处理 COUNT 查询
            elif "count(*)" in query_lower and "from (" in query_lower:
                filtered = all_joined
                if target_suburb:
                    filtered = [r for r in filtered if r["suburb"] == target_suburb]
                
                self.description = [("total",)]
                self._result = [(len(filtered),)]
                self.rowcount = 1
            

            
            # 处理 listings 查询
            elif "from listings" in query_lower:
                filtered = MOCK_LISTINGS
                
                # 应用过滤条件
                if target_suburb:
                    filtered = [r for r in filtered if r["suburb"] == target_suburb]
                
                # 排序
                if "order by id desc" in query_lower:
                    filtered.sort(key=lambda x: x["id"], reverse=True)
                
                # 限制数量
                limit = 20
                offset = 0
                if "limit" in query_lower and params:
                    for i, param in enumerate(params):
                        if isinstance(param, int) and i == len(params) - 2:
                            limit = param
                        elif isinstance(param, int) and i == len(params) - 1:
                            offset = param
                
                # 应用分页
                filtered = filtered[offset:offset + limit]
                
                self.description = [
                    ("id",), ("address",), ("suburb",), ("property_type",),
                    ("bedrooms",), ("bathrooms",), ("car_spaces",), ("land_size",),
                    ("price_text",), ("price",), ("sale_method",), ("agent_name",),
                    ("agent_company",), ("link",), ("scraped_date",), ("created_at",)
                ]
                self._result = filtered
                self.rowcount = len(filtered)
            
            # 最后处理 JOIN 查询（返回销售记录）
            elif "from sales s" in query_lower and "join properties p" in query_lower:
                filtered = all_joined
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
