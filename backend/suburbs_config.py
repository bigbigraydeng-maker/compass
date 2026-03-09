"""
Compass 区域集中配置
所有区域列表统一在此维护，新增区域只需修改此文件
"""

# ====== 核心区域定义 ======
# 每个区域包含：名称、邮编、Domain slug、中心坐标、所属警区、人口
SUBURBS = {
    # === 原有 7 个核心区 ===
    "Sunnybank": {
        "postcode": "4109",
        "domain_slug": "sunnybank-qld-4109",
        "lat": -27.5916, "lng": 153.0622,
        "police_division": "Upper Mount Gravatt",
        "population": 14200,
        "chinese_friendly_score": 15,
    },
    "Eight Mile Plains": {
        "postcode": "4113",
        "domain_slug": "eight-mile-plains-qld-4113",
        "lat": -27.5808, "lng": 153.0968,
        "police_division": "Upper Mount Gravatt",
        "population": 12800,
        "chinese_friendly_score": 13,
    },
    "Calamvale": {
        "postcode": "4116",
        "domain_slug": "calamvale-qld-4116",
        "lat": -27.6169, "lng": 153.0467,
        "police_division": "Calamvale",
        "population": 18500,
        "chinese_friendly_score": 13,
    },
    "Rochedale": {
        "postcode": "4123",
        "domain_slug": "rochedale-qld-4123",
        "lat": -27.5710, "lng": 153.1260,
        "police_division": "Upper Mount Gravatt",
        "population": 12000,
        "chinese_friendly_score": 12,
    },
    "Mansfield": {
        "postcode": "4122",
        "domain_slug": "mansfield-qld-4122",
        "lat": -27.5327, "lng": 153.1009,
        "police_division": "Holland Park",
        "population": 11500,
        "chinese_friendly_score": 11,
    },
    "Ascot": {
        "postcode": "4007",
        "domain_slug": "ascot-qld-4007",
        "lat": -27.4325, "lng": 153.0622,
        "police_division": "Hendra",
        "population": 5000,
        "chinese_friendly_score": 6,
    },
    "Hamilton": {
        "postcode": "4007",
        "domain_slug": "hamilton-qld-4007",
        "lat": -27.4375, "lng": 153.0597,
        "police_division": "Hendra",
        "population": 7200,
        "chinese_friendly_score": 7,
    },

    # === 新增 10 个扩展区 ===
    "Runcorn": {
        "postcode": "4113",
        "domain_slug": "runcorn-qld-4113",
        "lat": -27.5970, "lng": 153.0790,
        "police_division": "Upper Mount Gravatt",
        "population": 13500,
        "chinese_friendly_score": 12,
    },
    "Wishart": {
        "postcode": "4122",
        "domain_slug": "wishart-qld-4122",
        "lat": -27.5529, "lng": 153.1040,
        "police_division": "Holland Park",
        "population": 10200,
        "chinese_friendly_score": 10,
    },
    "Upper Mount Gravatt": {
        "postcode": "4122",
        "domain_slug": "upper-mount-gravatt-qld-4122",
        "lat": -27.5581, "lng": 153.0808,
        "police_division": "Upper Mount Gravatt",
        "population": 9800,
        "chinese_friendly_score": 10,
    },
    "Macgregor": {
        "postcode": "4109",
        "domain_slug": "macgregor-qld-4109",
        "lat": -27.5647, "lng": 153.0755,
        "police_division": "Upper Mount Gravatt",
        "population": 12800,
        "chinese_friendly_score": 13,
    },
    "Robertson": {
        "postcode": "4109",
        "domain_slug": "robertson-qld-4109",
        "lat": -27.5678, "lng": 153.0610,
        "police_division": "Upper Mount Gravatt",
        "population": 6800,
        "chinese_friendly_score": 11,
    },
    "Stretton": {
        "postcode": "4116",
        "domain_slug": "stretton-qld-4116",
        "lat": -27.6247, "lng": 153.0630,
        "police_division": "Calamvale",
        "population": 10500,
        "chinese_friendly_score": 11,
    },
    "Kuraby": {
        "postcode": "4112",
        "domain_slug": "kuraby-qld-4112",
        "lat": -27.6090, "lng": 153.0850,
        "police_division": "Upper Mount Gravatt",
        "population": 8200,
        "chinese_friendly_score": 10,
    },
    "Coopers Plains": {
        "postcode": "4108",
        "domain_slug": "coopers-plains-qld-4108",
        "lat": -27.5692, "lng": 153.0352,
        "police_division": "Upper Mount Gravatt",
        "population": 7600,
        "chinese_friendly_score": 9,
    },
    "Algester": {
        "postcode": "4115",
        "domain_slug": "algester-qld-4115",
        "lat": -27.6117, "lng": 153.0398,
        "police_division": "Calamvale",
        "population": 10800,
        "chinese_friendly_score": 9,
    },
    "Parkinson": {
        "postcode": "4115",
        "domain_slug": "parkinson-qld-4115",
        "lat": -27.6348, "lng": 153.0285,
        "police_division": "Calamvale",
        "population": 8900,
        "chinese_friendly_score": 9,
    },
}

# ====== 便捷访问 ======
ALL_SUBURB_NAMES = list(SUBURBS.keys())
CORE_SUBURB_NAMES = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton']
EXPANDED_SUBURB_NAMES = [s for s in ALL_SUBURB_NAMES if s not in CORE_SUBURB_NAMES]

def get_domain_slugs():
    """返回 {name: slug} 映射"""
    return {name: info["domain_slug"] for name, info in SUBURBS.items()}

def get_suburb_coords():
    """返回 {name: {lat, lng}} 映射"""
    return {name: {"lat": info["lat"], "lng": info["lng"]} for name, info in SUBURBS.items()}

def get_police_division_map():
    """返回 {division: [{suburb, population}]} 映射"""
    divisions = {}
    for name, info in SUBURBS.items():
        div = info["police_division"]
        if div not in divisions:
            divisions[div] = []
        divisions[div].append({"suburb": name, "population": info["population"]})
    return divisions
