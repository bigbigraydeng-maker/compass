"""
Compass 区域集中配置
所有区域列表统一在此维护，新增区域只需修改此文件。
添加新区仅需在 SUBURBS 中增加一条记录，无需改动任何业务代码。

字段说明：
  postcode            - 邮编
  domain_slug         - Domain.com.au URL slug（爬虫用）
  lat / lng           - 中心坐标（Google Maps / POI 爬虫用）
  police_division     - 所属警区（治安数据按人口加权分配）
  population          - ABS Census 2021 人口数
  chinese_friendly_score - 华人友好度评分 (1-15)
  zoning_mdr          - 中密度开发潜力评估 (0-100)，基于 suburb_zoning.json 推导
  zoning_hdr          - 高密度开发潜力评估 (0-100)，基于 suburb_zoning.json 推导
"""

# ====== 核心区域定义 ======
SUBURBS = {
    # === 原有 7 个核心区 ===
    "Sunnybank": {
        "postcode": "4109",
        "domain_slug": "sunnybank-qld-4109",
        "lat": -27.5916, "lng": 153.0622,
        "police_division": "Upper Mount Gravatt",
        "population": 14200,
        "chinese_friendly_score": 15,
        "zoning_mdr": 20, "zoning_hdr": 0,    # LMDR 13% + NC 10%
    },
    "Eight Mile Plains": {
        "postcode": "4113",
        "domain_slug": "eight-mile-plains-qld-4113",
        "lat": -27.5808, "lng": 153.0968,
        "police_division": "Upper Mount Gravatt",
        "population": 12800,
        "chinese_friendly_score": 13,
        "zoning_mdr": 25, "zoning_hdr": 5,    # LMDR 15% + EC 12% + MU 5%; PC 6%
    },
    "Calamvale": {
        "postcode": "4116",
        "domain_slug": "calamvale-qld-4116",
        "lat": -27.6169, "lng": 153.0467,
        "police_division": "Calamvale",
        "population": 18500,
        "chinese_friendly_score": 13,
        "zoning_mdr": 15, "zoning_hdr": 0,    # LMDR 22% + NC 6%
    },
    "Rochedale": {
        "postcode": "4123",
        "domain_slug": "rochedale-qld-4123",
        "lat": -27.5710, "lng": 153.1260,
        "police_division": "Upper Mount Gravatt",
        "population": 12000,
        "chinese_friendly_score": 12,
        "zoning_mdr": 20, "zoning_hdr": 0,    # LMDR 23% + EC 32% + MU 10%（大量新开发）
    },
    "Mansfield": {
        "postcode": "4122",
        "domain_slug": "mansfield-qld-4122",
        "lat": -27.5327, "lng": 153.1009,
        "police_division": "Holland Park",
        "population": 11500,
        "chinese_friendly_score": 11,
        "zoning_mdr": 15, "zoning_hdr": 0,    # LMDR 2% + NC 3%（成熟低密度社区）
    },
    "Ascot": {
        "postcode": "4007",
        "domain_slug": "ascot-qld-4007",
        "lat": -27.4325, "lng": 153.0622,
        "police_division": "Hendra",
        "population": 5000,
        "chinese_friendly_score": 6,
        "zoning_mdr": 10, "zoning_hdr": 5,    # LMDR 10%; DC 8%
    },
    "Hamilton": {
        "postcode": "4007",
        "domain_slug": "hamilton-qld-4007",
        "lat": -27.4375, "lng": 153.0597,
        "police_division": "Hendra",
        "population": 7200,
        "chinese_friendly_score": 7,
        "zoning_mdr": 15, "zoning_hdr": 10,   # MDR 12% + MU 8%; PDA 42% + DC 10%
    },

    # === 扩展 10 个区 ===
    "Runcorn": {
        "postcode": "4113",
        "domain_slug": "runcorn-qld-4113",
        "lat": -27.5970, "lng": 153.0790,
        "police_division": "Upper Mount Gravatt",
        "population": 13500,
        "chinese_friendly_score": 12,
        "zoning_mdr": 15, "zoning_hdr": 0,    # LMDR 15% + NC 8%
    },
    "Wishart": {
        "postcode": "4122",
        "domain_slug": "wishart-qld-4122",
        "lat": -27.5529, "lng": 153.1040,
        "police_division": "Holland Park",
        "population": 10200,
        "chinese_friendly_score": 10,
        "zoning_mdr": 12, "zoning_hdr": 0,    # LMDR 12%
    },
    "Upper Mount Gravatt": {
        "postcode": "4122",
        "domain_slug": "upper-mount-gravatt-qld-4122",
        "lat": -27.5581, "lng": 153.0808,
        "police_division": "Upper Mount Gravatt",
        "population": 9800,
        "chinese_friendly_score": 10,
        "zoning_mdr": 20, "zoning_hdr": 5,    # LMDR 20% + NC 15% + MU 10%
    },
    "Macgregor": {
        "postcode": "4109",
        "domain_slug": "macgregor-qld-4109",
        "lat": -27.5647, "lng": 153.0755,
        "police_division": "Upper Mount Gravatt",
        "population": 12800,
        "chinese_friendly_score": 13,
        "zoning_mdr": 15, "zoning_hdr": 0,    # LMDR 15% + NC 10%
    },
    "Robertson": {
        "postcode": "4109",
        "domain_slug": "robertson-qld-4109",
        "lat": -27.5678, "lng": 153.0610,
        "police_division": "Upper Mount Gravatt",
        "population": 6800,
        "chinese_friendly_score": 11,
        "zoning_mdr": 18, "zoning_hdr": 0,    # LMDR 18% + NC 5%
    },
    "Stretton": {
        "postcode": "4116",
        "domain_slug": "stretton-qld-4116",
        "lat": -27.6247, "lng": 153.0630,
        "police_division": "Calamvale",
        "population": 10500,
        "chinese_friendly_score": 11,
        "zoning_mdr": 15, "zoning_hdr": 0,    # LMDR 15% + NC 4%
    },
    "Kuraby": {
        "postcode": "4112",
        "domain_slug": "kuraby-qld-4112",
        "lat": -27.6090, "lng": 153.0850,
        "police_division": "Upper Mount Gravatt",
        "population": 8200,
        "chinese_friendly_score": 10,
        "zoning_mdr": 13, "zoning_hdr": 0,    # LMDR 13%
    },
    "Coopers Plains": {
        "postcode": "4108",
        "domain_slug": "coopers-plains-qld-4108",
        "lat": -27.5692, "lng": 153.0352,
        "police_division": "Upper Mount Gravatt",
        "population": 7600,
        "chinese_friendly_score": 9,
        "zoning_mdr": 20, "zoning_hdr": 5,    # LMDR 15% + MU 10%; I 25%（工业转型潜力）
    },
    "Algester": {
        "postcode": "4115",
        "domain_slug": "algester-qld-4115",
        "lat": -27.6117, "lng": 153.0398,
        "police_division": "Calamvale",
        "population": 10800,
        "chinese_friendly_score": 9,
        "zoning_mdr": 18, "zoning_hdr": 0,    # LMDR 18% + NC 5%
    },
    "Parkinson": {
        "postcode": "4115",
        "domain_slug": "parkinson-qld-4115",
        "lat": -27.6348, "lng": 153.0285,
        "police_division": "Calamvale",
        "population": 8900,
        "chinese_friendly_score": 9,
        "zoning_mdr": 20, "zoning_hdr": 0,    # LMDR 20% + NC 5%
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

def get_zoning_scores():
    """返回 {name: {"MDR": int, "HDR": int}} 评分映射，用于 Compass Score 土地价值维度"""
    return {
        name: {
            "MDR": info.get("zoning_mdr", 10),   # 默认中等
            "HDR": info.get("zoning_hdr", 0),
        }
        for name, info in SUBURBS.items()
    }
