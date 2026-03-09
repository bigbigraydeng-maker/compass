#!/usr/bin/env python3
"""
Compass MVP 在售房源抓取脚本
用于从 Domain.com.au 抓取布里斯班在售房源数据

使用方法:
1. 安装依赖: pip install playwright pandas
2. 安装浏览器: playwright install chromium
3. 运行: python scraper/scrape_listings.py
4. 输出: data/raw_listings.csv
"""

import csv
import time
import random
import json
import re
from datetime import datetime
from typing import List, Dict, Optional
from playwright.sync_api import sync_playwright
import pandas as pd
import os

# 从集中配置加载
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from suburbs_config import SUBURBS as _SC
SUBURBS = [{"name": n, "slug": i["domain_slug"]} for n, i in _SC.items()]

MAX_PAGES = 3

TARGET_URLS = {
    s["name"]: f"https://www.domain.com.au/sale/{s['slug']}/"
    for s in SUBURBS
}


def parse_price(price_text: str) -> Optional[int]:
    if not price_text:
        return None
    
    price_text = price_text.replace("$", "").replace(",", "").replace("\n", " ").strip()
    
    if "m" in price_text.lower():
        match = re.search(r'(\d+(?:\.\d+)?)\s*m', price_text.lower())
        if match:
            return int(float(match.group(1)) * 1000000)
    
    if "k" in price_text.lower():
        match = re.search(r'(\d+(?:\.\d+)?)\s*k', price_text.lower())
        if match:
            return int(float(match.group(1)) * 1000)
    
    match = re.search(r'\d+(?:\.\d+)?', price_text)
    if match:
        try:
            price = float(match.group())
            if price < 100:
                return int(price * 1000000)
            return int(price)
        except:
            pass
    
    return None


def get_listings(suburb: str, url: str) -> List[Dict]:
    print(f"\n{'='*50}")
    print(f"🏘  开始抓取：{suburb}")
    print(f"{'='*50}")
    
    all_listings = []
    page_num = 1
    
    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            args=[
                '--disable-blink-features=AutomationControlled',
                '--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
            ]
        )
        
        page = browser.new_page()
        
        page.evaluate('() => { Object.defineProperty(navigator, "webdriver", { get: () => undefined }); }')
        
        try:
            print("  🌐 访问 Domain 首页...")
            page.goto("https://www.domain.com.au", wait_until="domcontentloaded", timeout=60000)
            time.sleep(random.uniform(2, 4))
            
            while page_num <= MAX_PAGES:
                try:
                    page_url = f"{url}?page={page_num}"
                    print(f"\n  📄 第 {page_num} 页：{page_url}")
                    
                    page.goto(page_url, wait_until="domcontentloaded", timeout=60000)
                    time.sleep(random.uniform(4, 6))
                    
                    for i in range(3):
                        page.mouse.wheel(0, random.randint(500, 1000))
                        time.sleep(random.uniform(1, 2))
                    
                    print("  🔍 从 __NEXT_DATA__ 提取数据...")
                    try:
                        next_data_script = page.query_selector('#__NEXT_DATA__')
                        if next_data_script:
                            next_data = json.loads(next_data_script.inner_text())
                            
                            next_data_file = f"data/listings_next_data_{suburb.replace(' ', '_')}_page{page_num}.json"
                            os.makedirs("data", exist_ok=True)
                            with open(next_data_file, 'w', encoding='utf-8') as f:
                                json.dump(next_data, f, indent=2, ensure_ascii=False)
                            print(f"  💾 已保存 __NEXT_DATA__ 到 {next_data_file}")
                            
                            if 'props' in next_data and 'pageProps' in next_data['props']:
                                page_props = next_data['props']['pageProps']
                                print(f"  ✅ 找到 pageProps，包含键: {list(page_props.keys())}")
                                
                                listings_data = []
                                
                                if 'componentProps' in page_props and 'listingsMap' in page_props['componentProps']:
                                    listings_map = page_props['componentProps']['listingsMap']
                                    listings_data = list(listings_map.values())
                                    print(f"  ✅ 从 listingsMap 找到 {len(listings_data)} 个房源")
                                
                                if len(listings_data) == 0:
                                    print(f"  🔍 DEBUG: listingsMap 为空，检查其他路径...")
                                    print(f"  🔍 DEBUG: componentProps keys: {list(page_props.get('componentProps', {}).keys())}")
                                    
                                    if 'upvSearchListingsV2' in page_props.get('componentProps', {}):
                                        upv_data = page_props['componentProps']['upvSearchListingsV2']
                                        print(f"  🔍 DEBUG: 找到 upvSearchListingsV2，keys: {list(upv_data.keys())}")
                                        if 'searchResults' in upv_data:
                                            listings_data = upv_data['searchResults']
                                            print(f"  ✅ 从 upvSearchListingsV2.searchResults 找到 {len(listings_data)} 个房源")
                                
                                for idx, listing in enumerate(listings_data):
                                    try:
                                        listing_model = listing.get('listingModel', {})
                                        
                                        if not listing_model:
                                            listing_model = listing
                                        
                                        addr = listing_model.get('address', {})
                                        if isinstance(addr, dict):
                                            street = addr.get('street', '').replace('\xa0', ' ').strip()
                                            suburb_name = addr.get('suburb', '')
                                            if street and suburb_name:
                                                address = f"{street}, {suburb_name}"
                                            elif street:
                                                address = street
                                            else:
                                                address = ""
                                        else:
                                            address = str(addr) if addr else ""
                                        
                                        features = listing_model.get('features', {})
                                        
                                        property_type = features.get('propertyType', '') if features else ''
                                        if not property_type:
                                            prop_type = listing_model.get('propertyType', '')
                                            if prop_type:
                                                property_type = prop_type
                                        
                                        property_type = property_type.lower() if property_type else ''
                                        if 'house' in property_type:
                                            property_type = "house"
                                        elif 'unit' in property_type or 'apartment' in property_type:
                                            property_type = "unit"
                                        elif 'townhouse' in property_type:
                                            property_type = "townhouse"
                                        elif 'land' in property_type or 'vacant' in property_type or 'newhouseland' in property_type:
                                            property_type = "land"
                                        
                                        bedrooms = features.get('beds', 0) if features else 0
                                        bathrooms = features.get('baths', 0) if features else 0
                                        car_spaces = features.get('parking', 0) if features else 0
                                        land_size = features.get('landSize', 0) if features else 0
                                        
                                        latitude = addr.get('lat', 0) if isinstance(addr, dict) else 0
                                        longitude = addr.get('lng', 0) if isinstance(addr, dict) else 0
                                        
                                        branding = listing_model.get('branding', {})
                                        agent_name = ""
                                        agent_company = ""
                                        
                                        if branding:
                                            agents = branding.get('agents', [])
                                            if agents and len(agents) > 0:
                                                agent_name = agents[0].get('agentName', '')
                                            agent_company = branding.get('brandName', '')
                                        
                                        price_text = listing_model.get('price', '')
                                        price = parse_price(price_text)
                                        
                                        auction_date = ""
                                        sale_method = "private treaty"
                                        
                                        auction_info = listing_model.get('auction', {})
                                        if auction_info:
                                            sale_method = "auction"
                                            auction_date = auction_info.get('date', '')
                                        
                                        tags = listing_model.get('tags', {})
                                        if tags:
                                            tag_text = tags.get('tagText', '')
                                            if 'auction' in tag_text.lower():
                                                sale_method = "auction"
                                        
                                        listing_id = listing.get('id', '')
                                        link = f"https://www.domain.com.au/{listing_id}" if listing_id else ""
                                        
                                        record = {
                                            "address": address,
                                            "suburb": suburb,
                                            "property_type": property_type,
                                            "bedrooms": int(bedrooms) if bedrooms else 0,
                                            "bathrooms": int(bathrooms) if bathrooms else 0,
                                            "car_spaces": int(car_spaces) if car_spaces else 0,
                                            "land_size": int(land_size) if land_size else 0,
                                            "price_text": price_text,
                                            "price": price or 0,
                                            "auction_date": auction_date,
                                            "sale_method": sale_method,
                                            "latitude": float(latitude) if latitude else 0,
                                            "longitude": float(longitude) if longitude else 0,
                                            "agent_name": agent_name,
                                            "agent_company": agent_company,
                                            "link": link,
                                            "scraped_date": datetime.now().strftime("%Y-%m-%d"),
                                        }
                                        
                                        if address and (price or price_text):
                                            all_listings.append(record)
                                            print(f"  ✅ [{idx+1}] {address} - {price_text} - {property_type}")
                                        else:
                                            print(f"  ⚠️  [{idx+1}] {address} - 缺少地址或价格")
                                        
                                    except Exception as e:
                                        print(f"  ❌ 解析房源出错: {e}")
                                        continue
                            else:
                                print("  ⚠️  未找到 pageProps")
                        else:
                            print("  ⚠️  未找到 __NEXT_DATA__")
                    except Exception as e:
                        print(f"  ❌ 解析 __NEXT_DATA__ 出错: {e}")
                    
                    delay = random.uniform(5, 10)
                    print(f"  ⏳ 等待 {delay:.1f} 秒...")
                    time.sleep(delay)
                    
                    page_num += 1
                    
                except Exception as e:
                    print(f"  ❌ 请求出错: {e}")
                    break
            
        finally:
            browser.close()
    
    print(f"\n  📊 共抓取到 {len(all_listings)} 条 {suburb} 的在售房源")
    return all_listings


def save_to_csv(all_data: List[Dict], filename: str):
    if not all_data:
        print("⚠️  没有数据可保存")
        return
    
    os.makedirs("data", exist_ok=True)
    
    df = pd.DataFrame(all_data)
    df.to_csv(filename, index=False, encoding='utf-8')
    print(f"\n✅ 已保存 {len(all_data)} 条记录到 {filename}")


def main():
    print("="*60)
    print("🏠 Compass 在售房源数据抓取")
    print("="*60)
    print(f"📅 开始时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"🎯 目标 Suburbs: {len(SUBURBS)} 个")
    print(f"📄 每个 Suburb 抓取: {MAX_PAGES} 页")
    print("="*60)
    
    all_data = []
    stats = {}
    
    for suburb_name, url in TARGET_URLS.items():
        listings = get_listings(suburb_name, url)
        all_data.extend(listings)
        stats[suburb_name] = len(listings)
    
    print("\n" + "="*60)
    print("📊 抓取统计")
    print("="*60)
    for suburb_name, count in stats.items():
        print(f"  {suburb_name}: {count} 条")
    print(f"\n  总计: {len(all_data)} 条")
    print("="*60)
    
    save_to_csv(all_data, "data/raw_listings.csv")
    
    if all_data:
        print("\n" + "="*60)
        print("📋 样本数据（第一条记录）")
        print("="*60)
        sample = all_data[0]
        for key, value in sample.items():
            print(f"  {key}: {value}")
        print("="*60)
    
    print(f"\n📅 结束时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


if __name__ == "__main__":
    main()
