#!/usr/bin/env python3
"""
测试土地页面的数据结构
"""

import requests
import json
import re

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
}

url = "https://www.domain.com.au/sale/sunnybank-qld-4109/?property-types=land"
r = requests.get(url, headers=HEADERS)

print(f"Status code: {r.status_code}")

# 解析 __NEXT_DATA__
match = re.search(r'<script id="__NEXT_DATA__"[^>]*>(.*?)</script>', r.text, re.DOTALL)
if match:
    print("\n找到 __NEXT_DATA__")
    try:
        data = json.loads(match.group(1))
        
        # 尝试不同的数据路径
        print("\n=== 尝试不同的数据路径 ===")
        
        # 路径1: componentProps.listings
        path1 = data.get("props", {}).get("pageProps", {}).get("componentProps", {}).get("listings", [])
        print(f"路径1 (componentProps.listings): {len(path1)} 条")
        
        # 路径2: searchResults.listings
        path2 = data.get("props", {}).get("pageProps", {}).get("searchResults", {}).get("listings", [])
        print(f"路径2 (searchResults.listings): {len(path2)} 条")
        
        # 路径3: ssrListings
        path3 = data.get("props", {}).get("pageProps", {}).get("ssrListings", [])
        print(f"路径3 (ssrListings): {len(path3)} 条")
        
        # 路径4: initialState
        path4 = data.get("props", {}).get("initialState", {}).get("search", {}).get("results", {}).get("listings", [])
        print(f"路径4 (initialState.search.results.listings): {len(path4)} 条")
        
        # 打印数据结构的键
        print("\n=== 数据结构 ===")
        print("props.keys:", list(data.get("props", {}).keys()))
        print("pageProps.keys:", list(data.get("props", {}).get("pageProps", {}).keys()))
        
        # 检查 componentProps 结构
        component_props = data.get("props", {}).get("pageProps", {}).get("componentProps", {})
        print("componentProps.keys:", list(component_props.keys()))
        
        # 检查是否有 search 相关的数据
        if 'search' in component_props:
            print("\nsearch.keys:", list(component_props.get("search", {}).keys()))
            search_data = component_props.get("search", {})
            if 'results' in search_data:
                print("results.keys:", list(search_data.get("results", {}).keys()))
                results_data = search_data.get("results", {})
                if 'listings' in results_data:
                    print("listings count:", len(results_data.get("listings", [])))
        
        # 打印 componentProps 的前 1000 个字符，看看结构
        print("\n=== componentProps 结构 ===")
        print(json.dumps(component_props, indent=2, ensure_ascii=False)[:1000])
            
    except json.JSONDecodeError as e:
        print(f"JSON 解析失败: {e}")
else:
    print("未找到 __NEXT_DATA__")
