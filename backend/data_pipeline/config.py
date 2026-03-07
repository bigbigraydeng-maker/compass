import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# 环境配置
ENV = os.getenv('ENV', 'local')

# 数据库配置
if ENV == 'supabase':
    DATABASE_URL = os.getenv('DATABASE_URL')
elif ENV == 'local':
    DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/compass')
else:  # mock
    DATABASE_URL = None

# Google Maps API 配置
GOOGLE_MAPS_API_KEY = os.getenv('GOOGLE_MAPS_API_KEY', '')

# 数据存储路径
DATA_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'data')
RAW_DATA_DIR = os.path.join(DATA_DIR, 'raw')
PROCESSED_DATA_DIR = os.path.join(DATA_DIR, 'processed')

# 确保目录存在
os.makedirs(RAW_DATA_DIR, exist_ok=True)
os.makedirs(PROCESSED_DATA_DIR, exist_ok=True)

# 地理编码配置
GEOCODING_RETRY_COUNT = 3
GEOCODING_RETRY_DELAY = 2  # 秒

# 数据质量配置
REQUIRED_FIELDS = ['address', 'suburb', 'sale_price', 'sale_date']

# 土地识别规则
LAND_PROPERTY_TYPES = ['vacant land', 'land', ' vacant_land']
MIN_LAND_SIZE_FOR_LAND_TYPE = 300  # 平方米

# 批量处理配置
BATCH_SIZE = 1000

# 日志配置
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
LOG_FILE = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'logs', 'data_pipeline.log')

# 确保日志目录存在
os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
