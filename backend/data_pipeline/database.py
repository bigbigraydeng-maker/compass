from .config import DATABASE_URL, ENV

class MockCursor:
    """模拟游标类"""
    def __init__(self):
        self.results = []
    
    def execute(self, query, params=None):
        print(f"执行SQL: {query}")
        if params:
            print(f"参数: {params}")
    
    def executemany(self, query, params_list):
        print(f"批量执行SQL: {query}")
        print(f"参数数量: {len(params_list)}")
    
    def fetchall(self):
        return self.results
    
    def fetchone(self):
        return self.results[0] if self.results else None
    
    def close(self):
        pass

class Database:
    def __init__(self):
        self.connection = None
        self.cursor = None
        self.use_mock = ENV == 'mock'  # 根据环境变量决定是否使用模拟模式
    
    def connect(self):
        """建立数据库连接"""
        if self.use_mock:
            print("使用模拟数据库连接")
            self.cursor = MockCursor()
            return
        
        if not DATABASE_URL:
            raise ValueError("DATABASE_URL is not set. Please check your environment configuration.")
        
        try:
            import psycopg2
            from psycopg2.extras import DictCursor
            self.connection = psycopg2.connect(DATABASE_URL)
            self.cursor = self.connection.cursor(cursor_factory=DictCursor)
            print("数据库连接成功")
        except Exception as e:
            print(f"数据库连接失败: {e}")
            raise
    
    def disconnect(self):
        """关闭数据库连接"""
        if not self.use_mock and self.cursor:
            self.cursor.close()
        if not self.use_mock and self.connection:
            self.connection.close()
        print("数据库连接已关闭")
    
    def execute(self, query, params=None):
        """执行SQL查询"""
        try:
            if self.use_mock:
                print(f"模拟执行SQL: {query}")
                if params:
                    print(f"参数: {params}")
                return self.cursor
            else:
                if params:
                    self.cursor.execute(query, params)
                else:
                    self.cursor.execute(query)
                return self.cursor
        except Exception as e:
            print(f"SQL执行失败: {e}")
            if not self.use_mock:
                self.connection.rollback()
            raise
    
    def commit(self):
        """提交事务"""
        try:
            if not self.use_mock:
                self.connection.commit()
            print("事务提交成功")
        except Exception as e:
            print(f"事务提交失败: {e}")
            if not self.use_mock:
                self.connection.rollback()
            raise
    
    def fetch_all(self, query, params=None):
        """获取所有查询结果"""
        cursor = self.execute(query, params)
        return cursor.fetchall()
    
    def fetch_one(self, query, params=None):
        """获取单个查询结果"""
        cursor = self.execute(query, params)
        return cursor.fetchone()
    
    def execute_many(self, query, params_list):
        """批量执行SQL查询"""
        try:
            if self.use_mock:
                print(f"模拟批量执行SQL: {query}")
                print(f"参数数量: {len(params_list)}")
                return self.cursor
            else:
                self.cursor.executemany(query, params_list)
                return self.cursor
        except Exception as e:
            print(f"批量SQL执行失败: {e}")
            if not self.use_mock:
                self.connection.rollback()
            raise
    
    def create_tables(self):
        """创建数据库表结构"""
        try:
            # 创建 raw_sales 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS raw_sales (
                    id SERIAL PRIMARY KEY,
                    source TEXT NOT NULL,
                    source_record_id TEXT,
                    raw_address TEXT NOT NULL,
                    raw_suburb TEXT NOT NULL,
                    raw_price TEXT NOT NULL,
                    raw_sale_date TEXT NOT NULL,
                    raw_payload JSONB,
                    imported_at TIMESTAMP DEFAULT NOW()
                )
            ''')
            
            # 创建 sales 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS sales (
                    sale_id UUID PRIMARY KEY,
                    property_id TEXT NOT NULL,
                    full_address TEXT NOT NULL,
                    unit_number TEXT,
                    street_number TEXT,
                    street_name TEXT,
                    street_type TEXT,
                    suburb TEXT NOT NULL,
                    state TEXT DEFAULT 'QLD',
                    postcode TEXT,
                    sale_price NUMERIC NOT NULL,
                    sale_date DATE NOT NULL,
                    property_type TEXT,
                    bedrooms INTEGER,
                    bathrooms INTEGER,
                    car_spaces INTEGER,
                    land_size NUMERIC,
                    building_size NUMERIC,
                    latitude NUMERIC,
                    longitude NUMERIC,
                    address_key TEXT NOT NULL,
                    source TEXT NOT NULL,
                    created_at TIMESTAMP DEFAULT NOW(),
                    updated_at TIMESTAMP DEFAULT NOW(),
                    UNIQUE(address_key, sale_date, sale_price)
                )
            ''')
            
            # 创建 suburbs 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS suburbs (
                    id SERIAL PRIMARY KEY,
                    suburb TEXT NOT NULL,
                    state TEXT DEFAULT 'QLD',
                    postcode TEXT NOT NULL,
                    median_price NUMERIC,
                    sales_12m INTEGER,
                    growth_12m NUMERIC,
                    yield_estimate NUMERIC,
                    days_on_market_estimate INTEGER,
                    updated_at TIMESTAMP DEFAULT NOW(),
                    UNIQUE(suburb, postcode)
                )
            ''')
            
            # 创建 listings 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS listings (
                    listing_id UUID PRIMARY KEY,
                    address TEXT NOT NULL,
                    suburb TEXT NOT NULL,
                    listing_price NUMERIC,
                    listing_date DATE,
                    property_type TEXT,
                    bedrooms INTEGER,
                    bathrooms INTEGER,
                    land_size NUMERIC,
                    url TEXT,
                    source TEXT NOT NULL,
                    status TEXT DEFAULT 'active',
                    created_at TIMESTAMP DEFAULT NOW(),
                    updated_at TIMESTAMP DEFAULT NOW()
                )
            ''')
            
            # 创建 land_sales 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS land_sales (
                    land_sale_id UUID PRIMARY KEY,
                    sale_id UUID REFERENCES sales(sale_id),
                    address TEXT NOT NULL,
                    suburb TEXT NOT NULL,
                    sale_price NUMERIC NOT NULL,
                    sale_date DATE NOT NULL,
                    land_size NUMERIC,
                    zoning TEXT,
                    development_score NUMERIC,
                    created_at TIMESTAMP DEFAULT NOW()
                )
            ''')
            
            # 创建 geocoding_cache 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS geocoding_cache (
                    id SERIAL PRIMARY KEY,
                    address TEXT NOT NULL,
                    latitude NUMERIC NOT NULL,
                    longitude NUMERIC NOT NULL,
                    status TEXT DEFAULT 'success',
                    created_at TIMESTAMP DEFAULT NOW(),
                    UNIQUE(address)
                )
            ''')
            
            # 创建 quarantine 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS quarantine (
                    id SERIAL PRIMARY KEY,
                    raw_data JSONB NOT NULL,
                    error_message TEXT NOT NULL,
                    source TEXT,
                    created_at TIMESTAMP DEFAULT NOW()
                )
            ''')
            
            # 创建 deals 表
            self.execute('''
                CREATE TABLE IF NOT EXISTS deals (
                    deal_id UUID PRIMARY KEY,
                    property_id TEXT,
                    address TEXT NOT NULL,
                    suburb TEXT NOT NULL,
                    listing_price NUMERIC NOT NULL,
                    deal_score INTEGER NOT NULL,
                    undervalue_ratio NUMERIC,
                    land_score INTEGER,
                    suburb_score INTEGER,
                    liquidity_score INTEGER,
                    rental_score INTEGER,
                    category TEXT,
                    land_size NUMERIC,
                    zoning TEXT,
                    rental_yield NUMERIC,
                    created_at TIMESTAMP DEFAULT NOW(),
                    updated_at TIMESTAMP DEFAULT NOW()
                )
            ''')
            
            # 创建索引
            self.execute('CREATE INDEX IF NOT EXISTS idx_raw_sales_source ON raw_sales(source)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_raw_sales_imported_at ON raw_sales(imported_at)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_sales_suburb ON sales(suburb)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_sales_sale_date ON sales(sale_date)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_sales_address_key ON sales(address_key)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_sales_property_type ON sales(property_type)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_suburbs_suburb ON suburbs(suburb)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_suburbs_postcode ON suburbs(postcode)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_listings_suburb ON listings(suburb)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_land_sales_suburb ON land_sales(suburb)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_land_sales_sale_date ON land_sales(sale_date)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_geocoding_address ON geocoding_cache(address)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_deals_score ON deals(deal_score DESC)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_deals_category ON deals(category)')
            self.execute('CREATE INDEX IF NOT EXISTS idx_deals_suburb ON deals(suburb)')
            
            self.commit()
            print("数据库表结构创建成功")
        except Exception as e:
            print(f"创建表结构失败: {e}")
            if not self.use_mock:
                self.connection.rollback()
            raise

# 全局数据库实例
db = Database()
