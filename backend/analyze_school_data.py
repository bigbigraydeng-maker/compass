import json

# 读取生成的学校数据
with open('data/qld_schools.json', 'r', encoding='utf-8') as f:
    schools = json.load(f)

# 显示数据结构
if schools:
    # 显示字段名称
    fields = list(schools[0].keys())
    print("Columns:")
    print(fields)
    print()
    
    # 显示前 3 条记录
    print("First 3 rows:")
    for i, school in enumerate(schools[:3]):
        print(f"Row {i+1}:")
        for field, value in school.items():
            print(f"  {field}: {value}")
        print()
else:
    print("No data found")
