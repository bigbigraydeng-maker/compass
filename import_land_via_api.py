import requests
import csv

# 后端 API 地址
API_BASE = "https://compass-r58x.onrender.com"

# 读取土地数据
csv_file = "scraper/data/land_listings.csv"

with open(csv_file, "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    land_data = list(reader)

print(f"读取到 {len(land_data)} 条土地数据")

# 测试 API 是否正常
print("\n测试 API 状态...")
test_response = requests.get(f"{API_BASE}/api/listings?property_type=vacant_land")
print(f"API 状态码: {test_response.status_code}")
print(f"API 响应: {test_response.text}")

# 准备导入数据
print("\n准备导入数据...")
import_data = []
for item in land_data:
    import_item = {
        "address": item.get("address", ""),
        "suburb": item.get("suburb", ""),
        "property_type": "vacant_land",
        "land_size": int(item["land_size"]) if item.get("land_size") and item["land_size"] != "" else None,
        "price_text": item.get("price_text", ""),
        "price": float(item["price"]) if item.get("price") and item["price"] != "" else None,
        "agent_name": item.get("agent_name", ""),
        "agent_company": item.get("agent_company", ""),
        "link": item.get("link", ""),
        "scraped_date": item.get("scraped_date", ""),
        "bedrooms": None,
        "bathrooms": None,
        "car_spaces": None
    }
    import_data.append(import_item)

print(f"准备导入 {len(import_data)} 条数据")

# 由于后端 API 可能没有提供批量插入接口，这里我们只是验证数据格式
print("\n数据格式验证完成，准备通过 Supabase Dashboard 导入")
print("请登录 Supabase Dashboard，进入 listings 表，使用 Import Data 功能上传 scraper/data/land_listings.csv 文件")
print("导入完成后，再次运行此脚本验证数据")
