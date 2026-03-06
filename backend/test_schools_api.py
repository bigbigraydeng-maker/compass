import json

# 模拟 API 端点的功能
def get_suburb_schools(suburb_name: str):
    with open("schools_data.json", "r", encoding="utf-8") as f:
        all_schools = json.load(f)
    schools = all_schools.get(suburb_name, [])
    return {"suburb": suburb_name, "schools": schools}

# 测试 Sunnybank 郊区的学校数据
print("Testing Sunnybank schools:")
result = get_suburb_schools("Sunnybank")
print(f"Status: Success")
print(f"Suburb: {result['suburb']}")
print(f"Number of schools: {len(result['schools'])}")
print("Schools:")
for school in result['schools']:
    print(f"- {school['name']} ({school['type']}) - {school['rating']}")

# 测试其他郊区的学校数据
print("\nTesting other suburbs:")
suburbs = ["Sunnybank Hills", "Eight Mile Plains", "Macgregor", "Calamvale"]
for suburb in suburbs:
    result = get_suburb_schools(suburb)
    print(f"\n{suburb}: {len(result['schools'])} schools")
    for school in result['schools']:
        print(f"- {school['name']} ({school['type']})")
