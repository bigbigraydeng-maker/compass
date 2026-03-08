import csv
import json
import uuid
import os
from datetime import datetime, timedelta
from typing import List, Dict, Optional
from .database import db
from .address_processor import AddressProcessor
from .geocoder import Geocoder
from .data_validator import DataValidator
from .config import BATCH_SIZE, LAND_PROPERTY_TYPES, MIN_LAND_SIZE_FOR_LAND_TYPE

class DataProcessor:
    """数据处理类，负责整个数据处理流程"""
    
    @staticmethod
    def process_raw_data(file_path: str, source: str) -> Dict[str, int]:
        """处理原始数据文件
        
        Args:
            file_path: 原始数据文件路径
            source: 数据来源
            
        Returns:
            处理结果统计信息
        """
        stats = {
            'total': 0,
            'valid': 0,
            'invalid': 0,
            'quarantined': 0,
            'updated': 0
        }
        
        try:
            db.connect()
            
            # 首先导入到 raw_sales 表
            raw_stats = DataProcessor._import_to_raw_sales(file_path, source)
            stats['total'] = raw_stats['total']
            stats['invalid'] = raw_stats['invalid']
            stats['quarantined'] = raw_stats['quarantined']
            
            # 从文件直接读取数据（模拟模式下）
            batch_data = []
            
            # 直接从 CSV 文件读取数据进行处理
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                for i, row in enumerate(reader):
                    stats['total'] += 1
                    
                    # 处理数据
                    processed_data = DataProcessor._process_row(row, source)
                    
                    if processed_data:
                        batch_data.append(processed_data)
                        stats['valid'] += 1
                    else:
                        stats['invalid'] += 1
                    
                    # 批量处理
                    if len(batch_data) >= BATCH_SIZE:
                        updated_count = DataProcessor._upsert_batch(batch_data)
                        stats['updated'] += updated_count
                        batch_data = []
            
            # 处理剩余数据
            if batch_data:
                updated_count = DataProcessor._upsert_batch(batch_data)
                stats['updated'] += updated_count
                
            # 生成土地销售数据
            DataProcessor._generate_land_sales()
            
        except Exception as e:
            print(f"处理数据失败: {e}")
        finally:
            db.disconnect()
        
        return stats
    
    @staticmethod
    def _import_to_raw_sales(file_path: str, source: str) -> Dict[str, int]:
        """导入原始数据到 raw_sales 表
        
        Args:
            file_path: 原始数据文件路径
            source: 数据来源
            
        Returns:
            导入结果统计信息
        """
        stats = {
            'total': 0,
            'invalid': 0,
            'quarantined': 0
        }
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                batch_data = []
                
                for row in reader:
                    stats['total'] += 1
                    
                    # 验证必要字段
                    sale_price = row.get('sale_price', row.get('sold_price', '').strip()).strip()
                    sale_date = row.get('sale_date', row.get('sold_date', '').strip()).strip()
                    if not row.get('address') or not row.get('suburb') or not sale_price or not sale_date:
                        DataProcessor._quarantine_data(row, "缺少必要字段", source)
                        stats['invalid'] += 1
                        stats['quarantined'] += 1
                        continue
                    
                    # 准备原始数据
                    raw_data = {
                        'source': source,
                        'source_record_id': row.get('id') or str(uuid.uuid4()),
                        'raw_address': row.get('address', '').strip(),
                        'raw_suburb': row.get('suburb', '').strip(),
                        'raw_price': sale_price,
                        'raw_sale_date': sale_date,
                        'raw_payload': row
                    }
                    
                    batch_data.append(raw_data)
                    
                    # 批量插入
                    if len(batch_data) >= BATCH_SIZE:
                        DataProcessor._insert_raw_batch(batch_data)
                        batch_data = []
                
                # 处理剩余数据
                if batch_data:
                    DataProcessor._insert_raw_batch(batch_data)
                    
        except Exception as e:
            print(f"导入原始数据失败: {e}")
        
        return stats
    
    @staticmethod
    def _insert_raw_batch(batch_data: List[Dict]):
        """批量插入原始数据
        
        Args:
            batch_data: 批量数据列表
        """
        if not batch_data:
            return
        
        try:
            query = """
                INSERT INTO raw_sales (
                    source, source_record_id, raw_address, raw_suburb, raw_price, raw_sale_date, raw_payload
                ) VALUES (
                    %s, %s, %s, %s, %s, %s, %s
                )
            """
            
            params = [
                (
                    data['source'], data['source_record_id'], data['raw_address'],
                    data['raw_suburb'], data['raw_price'], data['raw_sale_date'],
                    json.dumps(data['raw_payload'])
                )
                for data in batch_data
            ]
            
            db.execute_many(query, params)
            db.commit()
            print(f"成功导入 {len(batch_data)} 条原始记录")
            
        except Exception as e:
            print(f"批量插入原始数据失败: {e}")
            db.commit()
    
    @staticmethod
    def _process_row(row: Dict, source: str) -> Optional[Dict]:
        """处理单行数据
        
        Args:
            row: 原始数据行
            source: 数据来源
            
        Returns:
            处理后的数据字典，如果无效则返回 None
        """
        # 标准化字段名
        data = {
            'address': row.get('address', '').strip(),
            'suburb': row.get('suburb', '').strip(),
            'postcode': row.get('postcode', '').strip(),
            'sale_price': row.get('sale_price', row.get('sold_price', '').strip()).strip(),
            'sale_date': row.get('sale_date', row.get('sold_date', '').strip()).strip(),
            'property_type': row.get('property_type', '').strip(),
            'bedrooms': row.get('bedrooms', '').strip(),
            'bathrooms': row.get('bathrooms', '').strip(),
            'car_spaces': row.get('car_spaces', '').strip(),
            'land_size': row.get('land_size', '').strip(),
            'building_size': row.get('building_size', '').strip()
        }
        
        # 验证数据
        if not DataValidator.is_valid(data):
            # 将无效数据放入隔离表
            DataProcessor._quarantine_data(row, "数据验证失败", source)
            return None
        
        # 标准化地址
        full_address = AddressProcessor.standardize_address(data['address'])
        
        # 拆分地址
        address_parts = AddressProcessor.split_address(full_address)
        
        # 生成 address_key
        address_key = AddressProcessor.generate_address_key(full_address, data['suburb'])
        
        # 生成 sale_id
        sale_id = AddressProcessor.generate_sale_id(full_address, data['sale_date'], data['sale_price'])
        
        # 生成 property_id (SHA-256 Hash)
        property_id = AddressProcessor.generate_property_id(full_address, data['suburb'])
        
        # 地理编码
        lat_lng, status = Geocoder.geocode_address(f"{full_address}, {data['suburb']}")
        if lat_lng:
            latitude, longitude = lat_lng
        else:
            latitude, longitude = None, None
        
        # 准备处理后的数据
        return {
            'sale_id': sale_id,
            'property_id': property_id,
            'full_address': full_address,
            'unit_number': address_parts.get('unit_number'),
            'street_number': address_parts.get('street_number'),
            'street_name': address_parts.get('street_name'),
            'street_type': address_parts.get('street_type'),
            'suburb': data['suburb'],
            'state': 'QLD',  # 默认 QLD
            'postcode': data['postcode'] or '4000',  # 默认 Brisbane 邮编
            'sale_price': float(data['sale_price']),
            'sale_date': datetime.strptime(data['sale_date'], '%Y-%m-%d').date(),
            'property_type': data['property_type'],
            'bedrooms': int(data['bedrooms']) if data['bedrooms'] else None,
            'bathrooms': int(data['bathrooms']) if data['bathrooms'] else None,
            'car_spaces': int(data['car_spaces']) if data['car_spaces'] else None,
            'land_size': float(data['land_size']) if data['land_size'] else None,
            'building_size': float(data['building_size']) if data['building_size'] else None,
            'latitude': latitude,
            'longitude': longitude,
            'address_key': address_key,
            'source': source
        }
    
    @staticmethod
    def _upsert_batch(batch_data: List[Dict]) -> int:
        """批量 upsert 数据
        
        Args:
            batch_data: 批量数据列表
            
        Returns:
            更新的记录数
        """
        if not batch_data:
            return 0
        
        try:
            # 构建 upsert 语句
            query = """
                INSERT INTO sales (
                    sale_id, property_id, full_address, unit_number, street_number, street_name, street_type,
                    suburb, state, postcode, sale_price, sale_date, property_type,
                    bedrooms, bathrooms, car_spaces, land_size, building_size, latitude, longitude,
                    address_key, source, created_at, updated_at
                ) VALUES (
                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW()
                ) ON CONFLICT (address_key, sale_date, sale_price) DO UPDATE SET
                    property_id = EXCLUDED.property_id,
                    full_address = EXCLUDED.full_address,
                    unit_number = EXCLUDED.unit_number,
                    street_number = EXCLUDED.street_number,
                    street_name = EXCLUDED.street_name,
                    street_type = EXCLUDED.street_type,
                    suburb = EXCLUDED.suburb,
                    state = EXCLUDED.state,
                    postcode = EXCLUDED.postcode,
                    property_type = EXCLUDED.property_type,
                    bedrooms = EXCLUDED.bedrooms,
                    bathrooms = EXCLUDED.bathrooms,
                    car_spaces = EXCLUDED.car_spaces,
                    land_size = EXCLUDED.land_size,
                    building_size = EXCLUDED.building_size,
                    latitude = EXCLUDED.latitude,
                    longitude = EXCLUDED.longitude,
                    source = EXCLUDED.source,
                    updated_at = NOW()
            """
            
            # 准备参数
            params = [
                (
                    data['sale_id'], data['property_id'], data['full_address'], data['unit_number'], data['street_number'],
                    data['street_name'], data['street_type'], data['suburb'], data['state'],
                    data['postcode'], data['sale_price'], data['sale_date'], data['property_type'],
                    data['bedrooms'], data['bathrooms'], data['car_spaces'], data['land_size'],
                    data['building_size'], data['latitude'], data['longitude'], data['address_key'],
                    data['source']
                )
                for data in batch_data
            ]
            
            # 执行批量 upsert
            db.execute_many(query, params)
            db.commit()
            print(f"成功 upsert {len(batch_data)} 条记录")
            return len(batch_data)
            
        except Exception as e:
            print(f"批量 upsert 失败: {e}")
            db.commit()
            return 0
    
    @staticmethod
    def _quarantine_data(raw_data: Dict, error_message: str, source: str = None):
        """将无效数据放入隔离表
        
        Args:
            raw_data: 原始数据
            error_message: 错误信息
            source: 数据来源
        """
        try:
            query = "INSERT INTO quarantine (raw_data, error_message, source) VALUES (%s, %s, %s)"
            db.execute(query, (json.dumps(raw_data), error_message, source))
            db.commit()
        except Exception as e:
            print(f"放入隔离表失败: {e}")
            db.commit()
    
    @staticmethod
    def _generate_land_sales():
        """生成土地销售数据
        
        根据销售数据生成土地销售记录
        """
        try:
            # 插入土地销售数据
            query = '''
                INSERT INTO land_sales (
                    land_sale_id, sale_id, address, suburb, sale_price, sale_date, land_size
                ) SELECT
                    gen_random_uuid(), 
                    sale_id, 
                    full_address, 
                    suburb, 
                    sale_price, 
                    sale_date, 
                    land_size
                FROM sales
                WHERE (
                    property_type IN %s OR
                    bedrooms = 0 OR
                    (land_size > %s AND property_type = 'land')
                ) AND sale_id NOT IN (
                    SELECT sale_id FROM land_sales
                )
            '''
            
            db.execute(query, (tuple(LAND_PROPERTY_TYPES), MIN_LAND_SIZE_FOR_LAND_TYPE))
            db.commit()
            print("土地销售数据生成完成")
            
        except Exception as e:
            print(f"生成土地销售数据失败: {e}")
            db.commit()
    
    @staticmethod
    def aggregate_suburbs():
        """聚合郊区数据
        
        生成郊区级别的统计数据
        """
        try:
            db.connect()
            
            # 计算每个郊区的统计数据
            query = """
                INSERT INTO suburbs (
                    suburb, state, postcode, median_price, sales_12m, growth_12m, updated_at
                ) SELECT
                    s.suburb,
                    COALESCE(s.state, 'QLD') as state,
                    COALESCE(s.postcode, '4000') as postcode,
                    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
                    COUNT(*) as sales_12m,
                    -- 计算 12 个月增长率
                    (SELECT
                        CASE
                            WHEN COUNT(*) > 0 THEN
                                (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s_current.sale_price) /
                                 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s_previous.sale_price) - 1) * 100
                            ELSE NULL
                        END
                     FROM sales s_previous
                     WHERE s_previous.suburb = s.suburb
                     AND s_previous.sale_date BETWEEN NOW() - INTERVAL '24 months' AND NOW() - INTERVAL '12 months'
                    ) as growth_12m,
                    NOW() as updated_at
                FROM sales s
                WHERE s.sale_date >= NOW() - INTERVAL '12 months'
                GROUP BY s.suburb, s.state, s.postcode
                ON CONFLICT (suburb, postcode) DO UPDATE SET
                    median_price = EXCLUDED.median_price,
                    sales_12m = EXCLUDED.sales_12m,
                    growth_12m = EXCLUDED.growth_12m,
                    updated_at = NOW()
            """
            
            db.execute(query)
            db.commit()
            print("郊区数据聚合完成")
            
        except Exception as e:
            print(f"聚合郊区数据失败: {e}")
            db.commit()
        finally:
            db.disconnect()