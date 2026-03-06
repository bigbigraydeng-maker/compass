import json
import random

# 布里斯班南区主要郊区
brisbane_south_suburbs = [
    'Sunnybank', 'Sunnybank Hills', 'Macgregor', 'Eight Mile Plains',
    'Calamvale', 'Algester', 'Robertson', 'Runcorn',
    'Stretton', 'Wishart', 'Carindale', 'Mount Gravatt'
]

# 学校类型
school_types = ['primary', 'secondary', 'combined']

# 生成模拟学校数据
schools = []
id_counter = 1

for suburb in brisbane_south_suburbs:
    # 每个郊区生成 1-3 所学校
    num_schools = random.randint(1, 3)
    
    for _ in range(num_schools):
        school_type = random.choice(school_types)
        # 生成 50-95 之间的 NAPLAN 百分位
        naplan_percentile = random.randint(50, 95)
        
        # 生成招生范围（当前郊区 + 0-2 个相邻郊区）
        catchment_suburbs = [suburb]
        # 随机选择 0-2 个相邻郊区
        num_catchment = random.randint(0, 2)
        if num_catchment > 0:
            # 从其他郊区中随机选择
            other_suburbs = [s for s in brisbane_south_suburbs if s != suburb]
            catchment_suburbs.extend(random.sample(other_suburbs, min(num_catchment, len(other_suburbs))))
        
        # 生成学校名称
        if school_type == 'primary':
            school_name = f"{suburb} State School"
        elif school_type == 'secondary':
            school_name = f"{suburb} State High School"
        else:
            school_name = f"{suburb} Community College"
        
        # 添加到学校列表
        schools.append({
            'id': id_counter,
            'name': school_name,
            'school_type': school_type,
            'suburb': suburb,
            'naplan_percentile': naplan_percentile,
            'catchment_suburbs': catchment_suburbs
        })
        
        id_counter += 1

# 保存为 JSON 文件
with open('data/qld_schools.json', 'w', encoding='utf-8') as f:
    json.dump(schools, f, ensure_ascii=False, indent=2)

print(f"Generated {len(schools)} schools data and saved to data/qld_schools.json")
print("Sample schools:")
for school in schools[:3]:
    print(f"- {school['name']} ({school['school_type']}) in {school['suburb']}")
    print(f"  NAPLAN Percentile: {school['naplan_percentile']}")
    print(f"  Catchment Suburbs: {', '.join(school['catchment_suburbs'])}")
    print()
