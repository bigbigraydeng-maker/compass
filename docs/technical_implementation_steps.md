# Compass 技术实施步骤 (MVP版本)

## 阶段 1：项目初始化（第 1-3 天）

### 1.1 环境搭建

**步骤 1.1.1：创建项目结构**
```bash
# 创建项目根目录
mkdir compass
cd compass

# 创建后端目录结构
mkdir -p backend/{api,models,services,scraper,ml,utils}

# 创建前端目录结构
mkdir -p frontend/{pages,components,utils,styles}

# 创建数据库目录
mkdir -p database

# 创建文档目录
mkdir -p docs

# 创建数据目录
mkdir -p data/{raw,cleaned}
```

**步骤 1.1.2：初始化版本控制**
```bash
git init
echo "node_modules/" > .gitignore
echo "__pycache__/" >> .gitignore
echo "*.pyc" >> .gitignore
echo ".env" >> .gitignore
echo "data/raw/*" >> .gitignore
git add .
git commit -m "Initial commit"
```

### 1.2 后端环境搭建

**步骤 1.2.1：创建虚拟环境**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Linux/Mac
# 或
venv\Scripts\activate  # Windows
```

**步骤 1.2.2：安装依赖**
```bash
pip install fastapi uvicorn psycopg2-binary sqlalchemy pandas scikit-learn xgboost python-dotenv passlib[bcrypt] python-jose[cryptography] python-multipart
pip freeze > requirements.txt
```

**步骤 1.2.3：创建环境变量文件**
```bash
cp .env.example .env
# 编辑 .env 文件，填入实际配置
```

### 1.3 前端环境搭建

**步骤 1.3.1：初始化 Next.js 项目**
```bash
cd frontend
npm create next-app@latest . --typescript --tailwind --app
npm install
```

**步骤 1.3.2：安装前端依赖**
```bash
npm install axios recharts date-fns
npm install @types/node --save-dev
```

### 1.4 数据库搭建

**步骤 1.4.1：安装 PostgreSQL**
```bash
# Ubuntu/Debian
sudo apt-get install postgresql postgresql-contrib

# macOS
brew install postgresql

# Windows
# 下载并安装 PostgreSQL 安装包
```

**步骤 1.4.2：创建数据库**
```bash
# 登录 PostgreSQL
psql -U postgres

# 创建数据库
CREATE DATABASE compass;

# 创建用户
CREATE USER compass_user WITH PASSWORD 'your_password';

# 授权
GRANT ALL PRIVILEGES ON DATABASE compass TO compass_user;

# 退出
\q
```

**步骤 1.4.3：执行数据库 Schema**
```bash
psql -U compass_user -d compass -f database/schema.sql
```

## 阶段 2：数据抓取系统（第 4-7 天）

### 2.1 数据源分析

**步骤 2.1.1：分析 Realestate.com.au**
- 研究网站结构
- 识别数据抓取点
- 确定反爬虫机制

**步骤 2.1.2：分析 Domain.com.au**
- 研究网站结构
- 识别数据抓取点
- 确定反爬虫机制

### 2.2 实现数据抓取器

**步骤 2.2.1：创建基础抓取器类**
```python
# backend/scraper/base_scraper.py
import requests
from bs4 import BeautifulSoup
import time
import random

class BaseScraper:
    def __init__(self):
        self.session = requests.Session()
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
    
    def get_page(self, url):
        response = self.session.get(url, headers=self.headers)
        time.sleep(random.uniform(1, 3))
        return response
```

**步骤 2.2.2：实现 Realestate.com.au 抓取器**
```python
# backend/scraper/realestate_scraper.py
from .base_scraper import BaseScraper
from bs4 import BeautifulSoup
import json

class RealestateScraper(BaseScraper):
    def scrape_sales(self, suburb, postcode):
        url = f"https://www.realestate.com.au/sold/in-{suburb.replace(' ', '-')},{postcode}"
        response = self.get_page(url)
        soup = BeautifulSoup(response.content, 'html.parser')
        
        sales = []
        # 解析页面数据
        # 实现具体抓取逻辑
        
        return sales
```

**步骤 2.2.3：实现 Domain.com.au 抓取器**
```python
# backend/scraper/domain_scraper.py
from .base_scraper import BaseScraper
from bs4 import BeautifulSoup

class DomainScraper(BaseScraper):
    def scrape_sales(self, suburb, postcode):
        url = f"https://www.domain.com.au/sold/?suburb={suburb}&postcode={postcode}"
        response = self.get_page(url)
        soup = BeautifulSoup(response.content, 'html.parser')
        
        sales = []
        # 解析页面数据
        # 实现具体抓取逻辑
        
        return sales
```

### 2.3 数据清洗和验证

**步骤 2.3.1：创建数据清洗模块**
```python
# backend/services/data_cleaner.py
import re
from datetime import datetime

class DataCleaner:
    def clean_price(self, price_str):
        price_str = re.sub(r'[^\d.]', '', price_str)
        return float(price_str) if price_str else None
    
    def clean_address(self, address_str):
        return address_str.strip()
    
    def clean_date(self, date_str):
        try:
            return datetime.strptime(date_str, '%Y-%m-%d')
        except:
            return None
    
    def validate_sale(self, sale_data):
        if not sale_data.get('address'):
            return False
        if not sale_data.get('sold_price'):
            return False
        return True
```

### 2.4 数据入库

**步骤 2.4.1：创建数据库模型**
```python
# backend/models/database.py
from sqlalchemy import create_engine, Column, Integer, String, Float, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship

Base = declarative_base()

class Property(Base):
    __tablename__ = 'properties'
    
    id = Column(Integer, primary_key=True)
    address = Column(String(255), nullable=False)
    suburb = Column(String(100), nullable=False)
    postcode = Column(Integer, nullable=False)
    property_type = Column(String(20), nullable=False)
    land_size = Column(Float)
    building_size = Column(Float)
    bedrooms = Column(Integer)
    bathrooms = Column(Integer)
    car_spaces = Column(Integer)
    year_built = Column(Integer)

class Sale(Base):
    __tablename__ = 'sales'
    
    id = Column(Integer, primary_key=True)
    property_id = Column(Integer, ForeignKey('properties.id'))
    sold_price = Column(Float, nullable=False)
    sold_date = Column(Date, nullable=False)
    days_on_market = Column(Integer)
    agent_name = Column(String(100))
    source = Column(String(50), nullable=False)
    
    property = relationship("Property", backref="sales")
```

**步骤 2.4.2：创建数据入库服务**
```python
# backend/services/data_importer.py
from sqlalchemy.orm import Session
from .database import Property, Sale, engine, SessionLocal

class DataImporter:
    def __init__(self):
        self.Session = SessionLocal
    
    def import_sales(self, sales_data):
        session = self.Session()
        try:
            for sale in sales_data:
                property_data = sale['property']
                
                property_obj = Property(**property_data)
                session.add(property_obj)
                session.flush()
                
                sale_obj = Sale(
                    property_id=property_obj.id,
                    sold_price=sale['sold_price'],
                    sold_date=sale['sold_date'],
                    days_on_market=sale['days_on_market'],
                    agent_name=sale['agent_name'],
                    source=sale['source']
                )
                session.add(sale_obj)
            
            session.commit()
        except Exception as e:
            session.rollback()
            raise e
        finally:
            session.close()
```

### 2.5 定时任务设置

**步骤 2.5.1：创建定时任务脚本**
```python
# backend/scraper/scheduler.py
from apscheduler.schedulers.background import BackgroundScheduler
from .realestate_scraper import RealestateScraper
from .domain_scraper import DomainScraper
from ..services.data_importer import DataImporter

def run_daily_scraping():
    suburbs = [
        {'name': 'Sunnybank', 'postcode': 4109},
        {'name': 'Eight Mile Plains', 'postcode': 4113},
        {'name': 'Calamvale', 'postcode': 4116}
    ]
    
    realestate_scraper = RealestateScraper()
    domain_scraper = DomainScraper()
    importer = DataImporter()
    
    all_sales = []
    
    for suburb in suburbs:
        realestate_sales = realestate_scraper.scrape_sales(suburb['name'], suburb['postcode'])
        domain_sales = domain_scraper.scrape_sales(suburb['name'], suburb['postcode'])
        
        all_sales.extend(realestate_sales)
        all_sales.extend(domain_sales)
    
    importer.import_sales(all_sales)

scheduler = BackgroundScheduler()
scheduler.add_job(run_daily_scraping, 'interval', hours=24)
scheduler.start()
```

## 阶段 3：后端 API 开发（第 8-12 天）

### 3.1 创建 FastAPI 应用

**步骤 3.1.1：创建主应用文件**
```python
# backend/main.py
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer

app = FastAPI(title="Compass API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

@app.get("/")
async def root():
    return {"message": "Compass API v1.0.0"}
```

### 3.2 实现认证 API

**步骤 3.2.1：创建认证路由**
```python
# backend/api/auth.py
from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from ..models.database import User
from ..services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["认证"])

@router.post("/register")
async def register(user_data: dict):
    auth_service = AuthService()
    user = auth_service.create_user(user_data)
    return {"success": True, "user_id": user.id}

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    auth_service = AuthService()
    token = auth_service.authenticate_user(form_data.username, form_data.password)
    return {"access_token": token, "token_type": "bearer"}
```

### 3.3 实现成交数据库 API

**步骤 3.3.1：创建成交路由**
```python
# backend/api/sales.py
from fastapi import APIRouter, Depends, Query
from typing import Optional
from ..models.database import Sale
from ..services.sales_service import SalesService

router = APIRouter(prefix="/sales", tags=["成交数据"])

@router.get("/")
async def get_sales(
    suburb: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    limit: int = Query(20, le=100),
    offset: int = 0
):
    sales_service = SalesService()
    sales = sales_service.get_sales(
        suburb=suburb,
        min_price=min_price,
        max_price=max_price,
        limit=limit,
        offset=offset
    )
    return {"success": True, "data": sales}

@router.get("/{sale_id}")
async def get_sale_detail(sale_id: int):
    sales_service = SalesService()
    sale = sales_service.get_sale_by_id(sale_id)
    if not sale:
        raise HTTPException(status_code=404, detail="Sale not found")
    return {"success": True, "data": sale}
```

### 3.4 实现 Suburb 分析 API

**步骤 3.4.1：创建 Suburb 路由**
```python
# backend/api/suburbs.py
from fastapi import APIRouter
from ..services.suburb_service import SuburbService

router = APIRouter(prefix="/suburbs", tags=["Suburb分析"])

@router.get("/")
async def get_suburbs(limit: int = 10):
    suburb_service = SuburbService()
    suburbs = suburb_service.get_all_suburbs(limit=limit)
    return {"success": True, "data": suburbs}

@router.get("/{suburb_id}")
async def get_suburb_detail(suburb_id: int):
    suburb_service = SuburbService()
    suburb = suburb_service.get_suburb_by_id(suburb_id)
    if not suburb:
        raise HTTPException(status_code=404, detail="Suburb not found")
    return {"success": True, "data": suburb}
```

### 3.5 实现 AI 估价 API

**步骤 3.5.1：创建估价路由**
```python
# backend/api/valuation.py
from fastapi import APIRouter
from ..services.valuation_service import ValuationService

router = APIRouter(prefix="/valuation", tags=["AI估价"])

@router.post("/")
async def get_valuation(property_data: dict):
    valuation_service = ValuationService()
    valuation = valuation_service.estimate_price(property_data)
    return {"success": True, "data": valuation}
```

## 阶段 4：前端开发（第 13-20 天）

### 4.1 创建基础组件

**步骤 4.1.1：创建导航组件**
```tsx
// frontend/components/Navbar.tsx
import Link from 'next/link';

export default function Navbar() {
  return (
    <nav className="bg-white shadow-md">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          <Link href="/" className="text-2xl font-bold text-blue-600">
            Compass
          </Link>
          <div className="flex space-x-4">
            <Link href="/sales" className="text-gray-700 hover:text-blue-600">
              成交数据
            </Link>
            <Link href="/suburbs" className="text-gray-700 hover:text-blue-600">
              区域分析
            </Link>
            <Link href="/valuation" className="text-gray-700 hover:text-blue-600">
              AI估价
            </Link>
          </div>
        </div>
      </div>
    </nav>
  );
}
```

### 4.2 创建首页

**步骤 4.2.1：创建首页组件**
```tsx
// frontend/app/page.tsx
import Navbar from '@/components/Navbar';
import { useEffect, useState } from 'react';

export default function Home() {
  const [homeData, setHomeData] = useState(null);
  
  useEffect(() => {
    fetch('/api/home')
      .then(res => res.json())
      .then(data => setHomeData(data.data));
  }, []);

  return (
    <div>
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 py-8">
        <h1 className="text-4xl font-bold mb-8">布里斯班华人房地产智能平台</h1>
        
        {homeData && (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-xl font-semibold mb-4">今日成交</h2>
              <p className="text-3xl font-bold text-blue-600">
                {homeData.today_sales.count} 套
              </p>
              <p className="text-gray-600 mt-2">
                总价值: ${homeData.today_sales.total_value.toLocaleString()}
              </p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-xl font-semibold mb-4">热门区域</h2>
              {homeData.hot_suburbs.map((suburb: any) => (
                <div key={suburb.suburb} className="mb-2">
                  <p className="font-semibold">{suburb.suburb}</p>
                  <p className="text-sm text-gray-600">
                    热度: {suburb.heat_score}/10
                  </p>
                </div>
              ))}
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-xl font-semibold mb-4">价格上涨区域</h2>
              {homeData.rising_areas.map((area: any) => (
                <div key={area.suburb} className="mb-2">
                  <p className="font-semibold">{area.suburb}</p>
                  <p className="text-sm text-green-600">
                    +{area.growth_rate}%
                  </p>
                </div>
              ))}
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-xl font-semibold mb-4">热门成交</h2>
              {homeData.top_sales.map((sale: any) => (
                <div key={sale.address} className="mb-2">
                  <p className="font-semibold text-sm">{sale.address}</p>
                  <p className="text-sm text-blue-600">
                    ${sale.sold_price.toLocaleString()}
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
```

### 4.3 创建成交数据页面

**步骤 4.3.1：创建成交数据页面**
```tsx
// frontend/app/sales/page.tsx
import Navbar from '@/components/Navbar';
import { useEffect, useState } from 'react';

export default function SalesPage() {
  const [sales, setSales] = useState([]);
  const [filters, setFilters] = useState({
    suburb: '',
    min_price: '',
    max_price: ''
  });
  
  useEffect(() => {
    fetchSales();
  }, [filters]);
  
  const fetchSales = async () => {
    const params = new URLSearchParams();
    if (filters.suburb) params.append('suburb', filters.suburb);
    if (filters.min_price) params.append('min_price', filters.min_price);
    if (filters.max_price) params.append('max_price', filters.max_price);
    
    const response = await fetch(`/api/sales?${params}`);
    const data = await response.json();
    setSales(data.data);
  };
  
  return (
    <div>
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">成交数据库</h1>
        
        <div className="bg-white p-6 rounded-lg shadow-md mb-8">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <input
              type="text"
              placeholder="郊区"
              value={filters.suburb}
              onChange={(e) => setFilters({...filters, suburb: e.target.value})}
              className="border rounded px-4 py-2"
            />
            <input
              type="number"
              placeholder="最低价格"
              value={filters.min_price}
              onChange={(e) => setFilters({...filters, min_price: e.target.value})}
              className="border rounded px-4 py-2"
            />
            <input
              type="number"
              placeholder="最高价格"
              value={filters.max_price}
              onChange={(e) => setFilters({...filters, max_price: e.target.value})}
              className="border rounded px-4 py-2"
            />
          </div>
        </div>
        
        <div className="bg-white rounded-lg shadow-md overflow-hidden">
          <table className="min-w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  地址
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  郊区
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  成交价
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  成交日期
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  成交天数
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {sales.map((sale: any) => (
                <tr key={sale.id}>
                  <td className="px-6 py-4 whitespace-nowrap">{sale.address}</td>
                  <td className="px-6 py-4 whitespace-nowrap">{sale.suburb}</td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    ${sale.sold_price.toLocaleString()}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">{sale.sold_date}</td>
                  <td className="px-6 py-4 whitespace-nowrap">{sale.days_on_market} 天</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </main>
    </div>
  );
}
```

### 4.4 创建 Suburb 分析页面

**步骤 4.4.1：创建 Suburb 分析页面**
```tsx
// frontend/app/suburbs/page.tsx
import Navbar from '@/components/Navbar';
import { useEffect, useState } from 'react';
import Link from 'next/link';

export default function SuburbsPage() {
  const [suburbs, setSuburbs] = useState([]);
  
  useEffect(() => {
    fetch('/api/suburbs')
      .then(res => res.json())
      .then(data => setSuburbs(data.data));
  }, []);
  
  return (
    <div>
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">Suburb 分析</h1>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {suburbs.map((suburb: any) => (
            <Link key={suburb.id} href={`/suburbs/${suburb.id}`}>
              <div className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer">
                <h2 className="text-2xl font-bold mb-4">{suburb.suburb}</h2>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-gray-600">中位价:</span>
                    <span className="font-semibold">
                      ${suburb.median_price.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">成交天数:</span>
                    <span className="font-semibold">{suburb.avg_days_on_market} 天</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">清盘率:</span>
                    <span className="font-semibold">{suburb.clearance_rate}%</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">月增长率:</span>
                    <span className="font-semibold text-green-600">
                      +{suburb.monthly_growth_rate}%
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">热度评分:</span>
                    <span className="font-semibold">{suburb.heat_score}/10</span>
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      </main>
    </div>
  );
}
```

### 4.5 创建 AI 估价页面

**步骤 4.5.1：创建 AI 估价页面**
```tsx
// frontend/app/valuation/page.tsx
import Navbar from '@/components/Navbar';
import { useState } from 'react';

export default function ValuationPage() {
  const [formData, setFormData] = useState({
    suburb: 'Sunnybank',
    land_size: '',
    building_size: '',
    bedrooms: '',
    bathrooms: '',
    car_spaces: '',
    property_type: 'house'
  });
  const [valuation, setValuation] = useState(null);
  const [loading, setLoading] = useState(false);
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    
    try {
      const response = await fetch('/api/valuation', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      const data = await response.json();
      setValuation(data.data);
    } catch (error) {
      console.error('Valuation error:', error);
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <div>
      <Navbar />
      <main className="max-w-7xl mx-auto px-4 py-8">
        <h1 className="text-3xl font-bold mb-8">AI 房产估价</h1>
        
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div className="bg-white p-6 rounded-lg shadow-md">
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  郊区
                </label>
                <select
                  value={formData.suburb}
                  onChange={(e) => setFormData({...formData, suburb: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                >
                  <option value="Sunnybank">Sunnybank</option>
                  <option value="Eight Mile Plains">Eight Mile Plains</option>
                  <option value="Calamvale">Calamvale</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  土地面积 (平方米)
                </label>
                <input
                  type="number"
                  value={formData.land_size}
                  onChange={(e) => setFormData({...formData, land_size: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  建筑面积 (平方米)
                </label>
                <input
                  type="number"
                  value={formData.building_size}
                  onChange={(e) => setFormData({...formData, building_size: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  卧室数量
                </label>
                <input
                  type="number"
                  value={formData.bedrooms}
                  onChange={(e) => setFormData({...formData, bedrooms: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  浴室数量
                </label>
                <input
                  type="number"
                  value={formData.bathrooms}
                  onChange={(e) => setFormData({...formData, bathrooms: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  停车位数量
                </label>
                <input
                  type="number"
                  value={formData.car_spaces}
                  onChange={(e) => setFormData({...formData, car_spaces: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  房产类型
                </label>
                <select
                  value={formData.property_type}
                  onChange={(e) => setFormData({...formData, property_type: e.target.value})}
                  className="w-full border rounded px-4 py-2"
                >
                  <option value="house">House</option>
                  <option value="unit">Unit</option>
                  <option value="townhouse">Townhouse</option>
                </select>
              </div>
              
              <button
                type="submit"
                disabled={loading}
                className="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700 disabled:bg-gray-400"
              >
                {loading ? '估价中...' : '开始估价'}
              </button>
            </form>
          </div>
          
          {valuation && (
            <div className="bg-white p-6 rounded-lg shadow-md">
              <h2 className="text-2xl font-bold mb-6">估价结果</h2>
              
              <div className="space-y-4">
                <div className="bg-blue-50 p-4 rounded">
                  <p className="text-sm text-gray-600 mb-2">估值区间</p>
                  <p className="text-2xl font-bold text-blue-600">
                    ${valuation.estimates.low.toLocaleString()} - ${valuation.estimates.high.toLocaleString()}
                  </p>
                  <p className="text-lg text-gray-700 mt-2">
                    中间估值: ${valuation.estimates.mid.toLocaleString()}
                  </p>
                </div>
                
                <div className="bg-green-50 p-4 rounded">
                  <p className="text-sm text-gray-600 mb-2">置信度</p>
                  <p className="text-xl font-bold text-green-600">
                    {(valuation.confidence * 100).toFixed(0)}%
                  </p>
                </div>
                
                <div className="bg-gray-50 p-4 rounded">
                  <p className="text-sm text-gray-600 mb-2">相似成交</p>
                  <div className="space-y-2">
                    {valuation.comparable_properties.map((prop: any, index: number) => (
                      <div key={index} className="text-sm">
                        <p className="font-semibold">{prop.address}</p>
                        <p className="text-gray-600">
                          ${prop.sold_price.toLocaleString()} ({prop.sold_date})
                        </p>
                      </div>
                    ))}
                  </div>
                </div>
                
                <div className="bg-yellow-50 p-4 rounded">
                  <p className="text-sm text-gray-600 mb-2">市场分析</p>
                  <p className="text-sm">{valuation.chinese_commentary}</p>
                </div>
              </div>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
```

## 阶段 5：AI 估价模型开发（第 16-22 天）

### 5.1 数据准备

**步骤 5.1.1：创建特征工程模块**
```python
# backend/ml/feature_engineering.py
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder

class FeatureEngineer:
    def __init__(self):
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()
    
    def prepare_features(self, df):
        df = df.copy()
        
        # 创建特征
        df['price_per_sqm'] = df['sold_price'] / df['land_size']
        df['building_ratio'] = df['building_size'] / df['land_size']
        df['room_ratio'] = df['bedrooms'] / df['bathrooms']
        
        # 编码分类变量
        df['property_type_encoded'] = self.label_encoder.fit_transform(df['property_type'])
        df['suburb_encoded'] = self.label_encoder.fit_transform(df['suburb'])
        
        # 标准化数值变量
        numerical_features = ['land_size', 'building_size', 'bedrooms', 'bathrooms', 'car_spaces']
        df[numerical_features] = self.scaler.fit_transform(df[numerical_features])
        
        return df
```

### 5.2 模型训练

**步骤 5.2.1：创建模型训练模块**
```python
# backend/ml/model_trainer.py
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import joblib
import pandas as pd

class ModelTrainer:
    def __init__(self):
        self.model = RandomForestRegressor(n_estimators=100, random_state=42)
    
    def train(self, X_train, y_train):
        self.model.fit(X_train, y_train)
        return self.model
    
    def evaluate(self, X_test, y_test):
        predictions = self.model.predict(X_test)
        mse = mean_squared_error(y_test, predictions)
        rmse = np.sqrt(mse)
        r2 = r2_score(y_test, predictions)
        
        return {
            'mse': mse,
            'rmse': rmse,
            'r2': r2
        }
    
    def save_model(self, filepath):
        joblib.dump(self.model, filepath)
    
    def load_model(self, filepath):
        self.model = joblib.load(filepath)
        return self.model
```

### 5.3 模型服务

**步骤 5.3.1：创建估价服务**
```python
# backend/services/valuation_service.py
from ..ml.feature_engineering import FeatureEngineer
from ..ml.model_trainer import ModelTrainer
import numpy as np

class ValuationService:
    def __init__(self):
        self.feature_engineer = FeatureEngineer()
        self.model_trainer = ModelTrainer()
        self.model_trainer.load_model('models/valuation_model.pkl')
    
    def estimate_price(self, property_data):
        features = self._prepare_features(property_data)
        prediction = self.model_trainer.model.predict([features])[0]
        
        confidence = self._calculate_confidence(property_data)
        comparable_properties = self._find_comparable_properties(property_data)
        
        low_estimate = prediction * 0.9
        high_estimate = prediction * 1.1
        
        return {
            'estimates': {
                'low': round(low_estimate),
                'mid': round(prediction),
                'high': round(high_estimate)
            },
            'confidence': confidence,
            'comparable_properties': comparable_properties,
            'chinese_commentary': self._generate_commentary(property_data, prediction)
        }
    
    def _prepare_features(self, property_data):
        features = [
            property_data['land_size'],
            property_data['building_size'],
            property_data['bedrooms'],
            property_data['bathrooms'],
            property_data.get('car_spaces', 0),
            1 if property_data['property_type'] == 'house' else 0
        ]
        return features
    
    def _calculate_confidence(self, property_data):
        base_confidence = 0.85
        
        if property_data['suburb'] in ['Sunnybank', 'Eight Mile Plains', 'Calamvale']:
            base_confidence += 0.05
        
        if property_data['land_size'] > 400 and property_data['land_size'] < 600:
            base_confidence += 0.03
        
        return min(base_confidence, 0.95)
    
    def _find_comparable_properties(self, property_data):
        from ..models.database import Sale, SessionLocal
        from sqlalchemy import and_
        
        session = SessionLocal()
        
        comparable = session.query(Sale).filter(
            Sale.suburb == property_data['suburb'],
            Sale.sold_price >= property_data.get('min_price', 0) * 0.8,
            Sale.sold_price <= property_data.get('max_price', 1000000) * 1.2
        ).order_by(Sale.sold_date.desc()).limit(5).all()
        
        session.close()
        
        return [
            {
                'address': sale.property.address,
                'sold_price': sale.sold_price,
                'sold_date': sale.sold_date.strftime('%Y-%m-%d'),
                'land_size': sale.property.land_size,
                'building_size': sale.property.building_size,
                'similarity': 0.9
            }
            for sale in comparable
        ]
    
    def _generate_commentary(self, property_data, prediction):
        suburb = property_data['suburb']
        price_range = f"${int(prediction * 0.9):,} - ${int(prediction * 1.1):,}"
        
        commentary = f"根据该房产的特征和近期市场数据，预计估值区间为{price_range}。"
        
        if suburb == 'Sunnybank':
            commentary += "Sunnybank作为布里斯班华人聚集的核心区域，房价持续稳定上涨。"
        elif suburb == 'Eight Mile Plains':
            commentary += "Eight Mile Plains交通便利，配套完善，是投资的热门区域。"
        elif suburb == 'Calamvale':
            commentary += "Calamvale发展迅速，性价比高，适合首次购房者。"
        
        commentary += "建议关注市场动态，把握投资时机。"
        
        return commentary
```

## 阶段 6：测试和部署（第 23-30 天）

### 6.1 测试

**步骤 6.1.1：创建测试脚本**
```python
# tests/test_api.py
import pytest
from fastapi.testclient import TestClient
from backend.main import app

client = TestClient(app)

def test_get_sales():
    response = client.get("/api/sales")
    assert response.status_code == 200
    assert "data" in response.json()

def test_get_suburbs():
    response = client.get("/api/suburbs")
    assert response.status_code == 200
    assert "data" in response.json()

def test_valuation():
    response = client.post("/api/valuation", json={
        "suburb": "Sunnybank",
        "land_size": 500,
        "building_size": 200,
        "bedrooms": 3,
        "bathrooms": 2,
        "property_type": "house"
    })
    assert response.status_code == 200
    assert "estimates" in response.json()["data"]
```

### 6.2 部署

**步骤 6.2.1：部署后端**
```bash
# 使用 Docker 部署
cd backend
docker build -t compass-backend .
docker run -p 8000:8000 compass-backend
```

**步骤 6.2.2：部署前端**
```bash
# 使用 Vercel 部署
cd frontend
vercel
```

**步骤 6.2.3：配置域名和 SSL**
- 购买域名
- 配置 DNS
- 设置 SSL 证书

### 6.3 监控和维护

**步骤 6.3.1：设置监控**
- 使用 Prometheus 监控系统性能
- 使用 Grafana 可视化监控数据
- 设置告警规则

**步骤 6.3.2：定期维护**
- 每周备份数据库
- 每月更新模型
- 定期检查系统日志
