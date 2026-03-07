#!/usr/bin/env python3
"""
Compass MVP REA 数据抓取脚本
用于从 Realestate.com.au 抓取布里斯班房产成交数据

使用方法:
1. 安装依赖: pip install playwright pandas
2. 安装浏览器: playwright install chromium
3. 运行: python scraper/scrape_rea_sales.py
4. 输出: data/raw_rea_sales.csv
"""

import csv
import time
import random
import json
from datetime import datetime
from typing import List, Dict
from playwright.sync_api import sync_playwright
import pandas as pd
import os

# 目标 Suburbs 配置
SUBURBS = [
    ("sunnybank", "4109"),
    ("eight-mile-plains", "4113"),
    ("calamvale", "4116"),
    ("rochedale", "4123"),
    ("mansfield", "4122"),
    ("ascot", "4007"),
    ("hamilton", "4007"),
]

# 最大抓取页数
MAX_PAGES = 20

# 构建目标 URL 字典
TARGET_URLS = {
    suburb: f"https://www.realestate.com.au/sold/in-{suburb},+qld+{postcode}"
    for suburb, postcode in SUBURBS
}


def get_rea_sold_listings(suburb_slug: str, url: str) -> List[Dict]:
    """从 Realestate.com.au 抓取成交列表"""
    suburb_name = suburb_slug.replace('-', ' ').title()
    print(f"\n{'='*50}")
    print(f"🏘  开始抓取 REA：{suburb_name}")
    print(f"{'='*50}")
    
    all_listings = []
    page_num = 1
    max_pages = MAX_PAGES
    
    with sync_playwright() as p:
        # 启动浏览器，添加反反爬设置
        browser = p.chromium.launch(
            headless=True,
            args=[
                '--disable-blink-features=AutomationControlled',
                '--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
            ]
        )
        
        page = browser.new_page()
        
        # 设置反反爬
        page.evaluate('() => {\n            Object.defineProperty(navigator, "webdriver", { get: () => undefined });\n            Object.defineProperty(navigator, "userAgent", { get: () => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" });\n        }')
        
        try:
            # 先访问首页建立会话
            print("  🌐 访问 REA 首页...")
            page.goto("https://www.realestate.com.au", wait_until="domcontentloaded", timeout=60000)
            time.sleep(random.uniform(2, 4))
            
            while page_num <= max_pages:
                try:
                    # 构建带分页的 URL
                    page_url = f"{url}/list-{page_num}"
                    print(f"\n  📄 第 {page_num} 页：{page_url}")
                    
                    # 访问页面
                    page.goto(page_url, wait_until="domcontentloaded", timeout=60000)
                    
                    # 等待页面加载完成
                    time.sleep(random.uniform(4, 6))
                    
                    # 滚动页面以加载更多内容
                    for i in range(3):
                        page.mouse.wheel(0, random.randint(500, 1000))
                        time.sleep(random.uniform(1, 2))
                    
                    # 获取页面 HTML
                    page_content = page.content()
                    
                    # 保存调试信息
                    debug_file = f"data/debug_{suburb_name.replace(' ', '_')}_page{page_num}.html"
                    with open(debug_file, 'w', encoding='utf-8') as f:
                        f.write(page_content)
                    print(f"  💾 已保存页面到 {debug_file}")
                    
                    # 尝试从 __NEXT_DATA__ 中提取数据
                    print("  🔍 从 __NEXT_DATA__ 提取数据...")
                    try:
                        # 提取 __NEXT_DATA__ 脚本
                        next_data_script = page.query_selector('#__NEXT_DATA__')
                        if next_data_script:
                            next_data = json.loads(next_data_script.inner_text())
                            
                            # 保存 __NEXT_DATA__ 到文件
                            next_data_file = f"data/next_data_{suburb_name.replace(' ', '_')}_page{page_num}.json"
                            with open(next_data_file, 'w', encoding='utf-8') as f:
                                json.dump(next_data, f, indent=2, ensure_ascii=False)
                            print(f"  💾 已保存 __NEXT_DATA__ 到 {next_data_file}")
                            
                            # 解析数据结构
                            if 'props' in next_data and 'pageProps' in next_data['props']:
                                page_props = next_data['props']['pageProps']
                                print(f"  ✅ 找到 pageProps，包含键: {list(page_props.keys())}")
                                
                                # 查找房源数据
                                if 'searchResults' in page_props and 'results' in page_props['searchResults']:
                                    listings_data = page_props['searchResults']['results']
                                    print(f"  ✅ 找到 {len(listings_data)} 个房源")
                                    
                                    for idx, listing in enumerate(listings_data):
                                        try:
                                            # 提取地址
                                            address = ""
                                            if 'address' in listing:
                                                address = listing['address']
                                            elif 'displayAddress' in listing:
                                                address = listing['displayAddress']
                                            
                                            # 提取价格
                                            sold_price = 0
                                            if 'price' in listing:
                                                price_text = listing['price']
                                                # 清理价格文本
                                                price_text = price_text.replace("$", "").replace(",", "").replace("\n", "").strip()
                                                # 提取数字部分
                                                import re
                                                match = re.search(r'\d+(?:\.\d+)?', price_text)
                                                if match:
                                                    try:
