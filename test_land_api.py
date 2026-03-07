import requests

# 测试土地数据 API
url = "https://compass-r58x.onrender.com/api/listings"
params = {
    "property_type": "vacant_land",
    "page_size": 5
}

response = requests.get(url, params=params)
print(f"Status code: {response.status_code}")
print(f"Response: {response.text}")
