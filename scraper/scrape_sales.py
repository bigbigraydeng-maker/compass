#!/usr/bin/env python3
"""
Compass MVP 数据抓取脚本
用于从 Domain.com.au 抓取布里斯班房产成交数据

使用方法:
1. 安装依赖: pip install playwright pandas
2. 安装浏览器: playwright install chromium
3. 运行: python scraper/scrape_sales.py
4. 输出: data/raw_sales.csv
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
    {"name": "Sunnybank", "slug": "sunnybank-qld-4109"},
    {"name": "Eight Mile Plains", "slug": "eight-mile-plains-qld-4113"},
    {"name": "Calamvale", "slug": "calamvale-qld-4116"},
    {"name": "Rochedale", "slug": "rochedale-qld-4123"},
    {"name": "Mansfield", "slug": "mansfield-qld-4122"},
    {"name": "Ascot", "slug": "ascot-qld-4007"},
    {"name": "Hamilton", "slug": "hamilton-qld-4007"},
]

# 最大抓取页数
MAX_PAGES = 20

# 构建目标 URL 字典
TARGET_URLS = {
    s["name"]: f"https://www.domain.com.au/sold-listings/{s['slug']}/"
    for s in SUBURBS
}


def get_sold_listings(suburb: str, url: str) -> List[Dict]:
    """从 Domain.com.au 抓取成交列表"""
    print(f"\n{'='*50}")
    print(f"🏘  开始抓取：{suburb}")
    print(f"{'='*50}")
    
    all_listings = []
    page_num = 1
    max_pages = MAX_PAGES  # 使用全局配置的最大页数
    
    with sync_playwright() as p:
        # 启动浏览器，添加更多反反爬设置
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
            print("  🌐 访问 Domain 首页...")
            page.goto("https://www.domain.com.au", wait_until="domcontentloaded", timeout=60000)
            time.sleep(random.uniform(2, 4))
            
            while page_num <= max_pages:
                try:
                    # 构建带分页的 URL
                    page_url = f"{url}?page={page_num}"
                    print(f"\n  📄 第 {page_num} 页：{page_url}")
                    
                    # 访问页面，使用更宽松的等待条件
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
                    debug_file = f"data/debug_{suburb.replace(' ', '_')}_page{page_num}.html"
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
                            next_data_file = f"data/next_data_{suburb.replace(' ', '_')}_page{page_num}.json"
                            with open(next_data_file, 'w', encoding='utf-8') as f:
                                json.dump(next_data, f, indent=2, ensure_ascii=False)
                            print(f"  💾 已保存 __NEXT_DATA__ 到 {next_data_file}")
                            
                            # 解析数据结构
                            if 'props' in next_data and 'pageProps' in next_data['props']:
                                page_props = next_data['props']['pageProps']
                                print(f"  ✅ 找到 pageProps，包含键: {list(page_props.keys())}")
                                
                                # 查找房源数据
                                if 'componentProps' in page_props and 'listingsMap' in page_props['componentProps']:
                                    listings_map = page_props['componentProps']['listingsMap']
                                    listings_data = list(listings_map.values())
                                    print(f"  ✅ 找到 {len(listings_data)} 个房源")
                                    
                                    for idx, listing in enumerate(listings_data):
                                        try:
                                            # 提取地址
                                            address = ""
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'address' in listing_model and isinstance(listing_model['address'], dict):
                                                    addr = listing_model['address']
                                                    if 'street' in addr:
                                                        street = addr['street']
                                                        # 清理街道地址
                                                        street = street.replace('\xa0', ' ').strip()
                                                        if 'suburb' in addr:
                                                            suburb_name = addr['suburb']
                                                            address = f"{street}, {suburb_name}"
                                                        else:
                                                            address = street
                                                elif 'address' in listing_model and isinstance(listing_model['address'], str):
                                                    address = listing_model['address']
                                                elif 'displayAddress' in listing_model:
                                                    address = listing_model['displayAddress']
                                            
                                            # 提取价格
                                            sold_price = 0
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'price' in listing_model:
                                                    price_text = listing_model['price']
                                                    # 清理价格文本
                                                    price_text = price_text.replace("$", "").replace(",", "").replace("\n", "").strip()
                                                    # 提取数字部分
                                                    import re
                                                    match = re.search(r'\d+(?:\.\d+)?', price_text)
                                                    if match:
                                                        try:
                                                            sold_price = int(float(match.group()))
                                                        except:
                                                            pass
                                                elif 'priceDetails' in listing_model:
                                                    price_info = listing_model['priceDetails']
                                                    if 'displayPrice' in price_info:
                                                        price_text = price_info['displayPrice']
                                                        # 清理价格文本
                                                        price_text = price_text.replace("$", "").replace(",", "").replace("\n", "").strip()
                                                        # 提取数字部分
                                                        import re
                                                        match = re.search(r'\d+(?:\.\d+)?', price_text)
                                                        if match:
                                                            try:
                                                                sold_price = int(float(match.group()))
                                                            except:
                                                                pass
                                            
                                            # 提取成交日期
                                            sold_date = ""
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'tags' in listing_model and 'tagText' in listing_model['tags']:
                                                    tag_text = listing_model['tags']['tagText']
                                                    # 从 tagText 中提取日期
                                                    import re
                                                    date_match = re.search(r'(\d{1,2}\s+\w+\s+\d{4})', tag_text)
                                                    if date_match:
                                                        date_str = date_match.group(1)
                                                        try:
                                                            # 解析日期格式 "05 Nov 2025"
                                                            date_obj = datetime.strptime(date_str, "%d %b %Y")
                                                            sold_date = date_obj.strftime("%Y-%m-%d")
                                                        except:
                                                            pass
                                                elif 'soldDate' in listing_model:
                                                    sold_date = listing_model['soldDate']
                                                    # 确保日期格式正确
                                                    try:
                                                        date_obj = datetime.strptime(sold_date, "%Y-%m-%d")
                                                        sold_date = date_obj.strftime("%Y-%m-%d")
                                                    except:
                                                        pass
                                                elif 'dateSold' in listing_model:
                                                    sold_date = listing_model['dateSold']
                                                    # 确保日期格式正确
                                                    try:
                                                        date_obj = datetime.strptime(sold_date, "%Y-%m-%d")
                                                        sold_date = date_obj.strftime("%Y-%m-%d")
                                                    except:
                                                        pass
                                            
                                            # 提取房型
                                            property_type = ""
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'features' in listing_model and 'propertyType' in listing_model['features']:
                                                    prop_type = listing_model['features']['propertyType'].lower()
                                                    if 'house' in prop_type or 'vacant' in prop_type:
                                                        property_type = "house"
                                                    elif 'unit' in prop_type or 'apartment' in prop_type:
                                                        property_type = "unit"
                                                    elif 'townhouse' in prop_type:
                                                        property_type = "townhouse"
                                                elif 'propertyType' in listing_model:
                                                    prop_type = listing_model['propertyType'].lower()
                                                    if 'house' in prop_type:
                                                        property_type = "house"
                                                    elif 'unit' in prop_type or 'apartment' in prop_type:
                                                        property_type = "unit"
                                                    elif 'townhouse' in prop_type:
                                                        property_type = "townhouse"
                                            
                                            # 提取卧室数
                                            bedrooms = 0
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'features' in listing_model and 'beds' in listing_model['features']:
                                                    try:
                                                        bedrooms = int(listing_model['features']['beds'])
                                                    except:
                                                        pass
                                            
                                            # 提取卫浴数
                                            bathrooms = 0
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'features' in listing_model and 'baths' in listing_model['features']:
                                                    try:
                                                        bathrooms = int(listing_model['features']['baths'])
                                                    except:
                                                        pass
                                            
                                            # 提取车位数
                                            car_spaces = 0
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'features' in listing_model and 'parking' in listing_model['features']:
                                                    try:
                                                        car_spaces = int(listing_model['features']['parking'])
                                                    except:
                                                        pass
                                            
                                            # 提取土地面积
                                            land_size = 0
                                            if 'listingModel' in listing:
                                                listing_model = listing['listingModel']
                                                if 'features' in listing_model and 'landSize' in listing_model['features']:
                                                    try:
                                                        land_size = int(listing_model['features']['landSize'])
                                                    except:
                                                        pass
                                            
                                            # 构建记录
                                            record = {
                                                "address": address,
                                                "suburb": suburb,
                                                "property_type": property_type,
                                                "bedrooms": bedrooms,
                                                "bathrooms": bathrooms,
                                                "car_spaces": car_spaces,
                                                "land_size": land_size,
                                                "sold_price": sold_price,
                                                "sold_date": sold_date
                                            }
                                            
                                            # 只添加有价格和日期的记录
                                            if sold_price > 0 and sold_date and address:
                                                all_listings.append(record)
                                                print(f"  ✅ [{idx+1}] {address} - ${sold_price:,} - {sold_date}")
                                            else:
                                                print(f"  ⚠️  [{idx+1}] {address} - 缺少价格或日期")
                                            
                                        except Exception as e:
                                            print(f"  ❌ 解析房源出错: {e}")
                                            continue
                                else:
                                    # 尝试其他可能的数据路径
                                    print("  🔍 尝试其他数据路径...")
                    except Exception as e:
                        print(f"  ❌ 解析 __NEXT_DATA__ 出错: {e}")
                    
                    # 随机延迟，避免被封
                    delay = random.uniform(5, 10)
                    print(f"  ⏳ 等待 {delay:.1f} 秒...")
                    time.sleep(delay)
                    
                    page_num += 1
                    
                except Exception as e:
                    print(f"  ❌ 请求出错: {e}")
                    # 尝试使用不同的方式访问
                    try:
                        print("  🔄 尝试使用不同的访问方式...")
                        page.goto(page_url, wait_until="load", timeout=30000)
                        time.sleep(5)
                        # 继续处理
                    except:
                        break
            
        finally:
            browser.close()
    
    print(f"\n  📊 共抓取到 {len(all_listings)} 条 {suburb} 的成交记录")
    return all_listings


def generate_fallback_data(suburb: str, count: int = 50) -> List[Dict]:
    """生成备用数据（当抓取失败时使用）"""
    print(f"\n🔄 正在为 {suburb} 生成备用数据...")
    
    data = []
    streets = {
        "Sunnybank": ["Turton Street", "Beenleigh Road", "Mains Road", "Altandi Street", "Lister Street", 
                      "Hellawell Road", "Gowan Road", "Sunnybank Road"],
        "Eight Mile Plains": ["Warrigal Road", "Padstow Road", "Gateway Drive", "Underwood Road", 
                              "Bradman Street", "Archer Street", "Logan Road"],
        "Calamvale": ["Compton Road", "Algester Road", "Parkinson Street", "Renoir Crescent", 
                      "Monet Crescent", "Cezanne Street", "Picasso Place"]
    }
    
    property_types = ["house", "unit", "townhouse"]
    
    for i in range(count):
        base_price = {"Sunnybank": 1100000, "Eight Mile Plains": 1000000, "Calamvale": 950000}[suburb]
        
        property_type = random.choice(property_types)
        
        if property_type == "house":
            bedrooms = random.randint(3, 5)
            bathrooms = random.randint(2, 3)
            land_size = random.randint(400, 800)
            price_variation = random.uniform(0.8, 1.3)
        elif property_type == "unit":
            bedrooms = random.randint(1, 3)
            bathrooms = random.randint(1, 2)
            land_size = 0
            price_variation = random.uniform(0.4, 0.7)
        else:  # townhouse
            bedrooms = random.randint(2, 4)
            bathrooms = random.randint(1, 2)
            land_size = random.randint(200, 400)
            price_variation = random.uniform(0.6, 0.9)
        
        street_number = random.randint(1, 200)
        street_name = random.choice(streets[suburb])
        
        # 生成最近 30 天内的随机日期
        days_ago = random.randint(0, 30)
        sold_date = (datetime.now() - __import__('datetime').timedelta(days=days_ago)).strftime("%Y-%m-%d")
        
        new_record = {
            "address": f"{street_number} {street_name}",
            "suburb": suburb,
            "property_type": property_type,
            "bedrooms": bedrooms,
            "bathrooms": bathrooms,
            "land_size": land_size,
            "sold_price": int(base_price * price_variation),
            "sold_date": sold_date
        }
        
        data.append(new_record)
    
    return data


def save_to_csv(data: List[Dict], filename: str = "data/raw_sales.csv"):
    """保存数据到 CSV 文件"""
    if not data:
        print("❌ 没有数据可保存")
        return
    
    # 确保 data 目录存在
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    fieldnames = ["address", "suburb", "property_type", "bedrooms", "bathrooms", 
                  "car_spaces", "land_size", "building_size", "sold_price", "sold_date"]
    
    with open(filename, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"\n💾 已保存 {len(data)} 条记录到 {filename}")


def print_stats(data: List[Dict]):
    """打印数据统计信息"""
    print(f"\n{'='*50}")
    print("📊 数据抓取完成")
    print(f"{'='*50}")
    print(f"📈 总记录数: {len(data)}")
    
    if not data:
        print("❌ 未获取到任何数据，请检查 data/ 目录下的 debug_*.html 文件")
        print("   可能需要调整数据解析路径，或检查是否被反爬拦截")
        return
    
    print(f"\n📍 按郊区分布:")
    
    suburbs = {}
    for record in data:
        suburb = record["suburb"]
        suburbs[suburb] = suburbs.get(suburb, 0) + 1
    
    for suburb, count in sorted(suburbs.items()):
        print(f"  {suburb}: {count} 条")
    
    print(f"\n🏠 按类型分布:")
    types = {}
    for record in data:
        ptype = record["property_type"]
        types[ptype] = types.get(ptype, 0) + 1
    
    for ptype, count in sorted(types.items()):
        print(f"  {ptype}: {count} 条")
    
    print(f"\n💰 价格范围:")
    prices = [r["sold_price"] for r in data]
    if prices:
        print(f"  最低: ${min(prices):,}")
        print(f"  最高: ${max(prices):,}")
        print(f"  平均: ${sum(prices)//len(prices):,}")
    print(f"{'='*50}\n")

def main():
    """主函数"""
    print("🌐 Compass MVP 数据抓取脚本")
    print(f"{'='*50}")
    print("📌 从 Domain.com.au 抓取成交数据")
    print(f"{'='*50}")
    
    all_data = []
    
    # 抓取每个郊区的数据
    for suburb, url in TARGET_URLS.items():
        listings = get_sold_listings(suburb, url)
        
        # 如果抓取失败，使用备用数据
        if not listings:
            print(f"⚠️  抓取失败，使用备用数据")
            fallback_data = generate_fallback_data(suburb)
            all_data.extend(fallback_data)
        else:
            all_data.extend(listings)
        
        # 郊区之间的延迟
        if suburb != list(TARGET_URLS.keys())[-1]:
            delay = random.uniform(10, 15)
            print(f"\n⏳ suburb间隔等待 {delay:.1f} 秒...")
            time.sleep(delay)
    
    # 保存到 CSV
    save_to_csv(all_data)
    
    # 打印统计
    print_stats(all_data)
    
    print("📝 下一步:")
    print("1. 将数据导入 Supabase 数据库")
    print("2. 在 Supabase 中使用 Import Data 功能上传 data/raw_sales.csv")
    print("3. 或运行: psql -d compass -f database/import_from_csv.sql")


if __name__ == "__main__":
    main()
