import re
import json
import uuid
from typing import Dict, Tuple, Optional

class AddressProcessor:
    """地址处理类，负责地址标准化和拆分"""
    
    # 街道类型映射表
    STREET_TYPE_MAP = {
        'St': 'Street',
        'St.': 'Street',
        'Ave': 'Avenue',
        'Ave.': 'Avenue',
        'Rd': 'Road',
        'Rd.': 'Road',
        'Blvd': 'Boulevard',
        'Blvd.': 'Boulevard',
        'Cres': 'Crescent',
        'Cres.': 'Crescent',
        'Dr': 'Drive',
        'Dr.': 'Drive',
        'Ln': 'Lane',
        'Ln.': 'Lane',
        'Pl': 'Place',
        'Pl.': 'Place',
        'Ter': 'Terrace',
        'Ter.': 'Terrace',
        'Way': 'Way',
        'Way.': 'Way',
        'Cir': 'Circle',
        'Cir.': 'Circle',
        'Ct': 'Court',
        'Ct.': 'Court',
        'Grv': 'Grove',
        'Grv.': 'Grove',
        'Pde': 'Parade',
        'Pde.': 'Parade',
        'Qy': 'Quay',
        'Qy.': 'Quay',
        'Sq': 'Square',
        'Sq.': 'Square',
        'Str': 'Street',
        'Str.': 'Street'
    }
    
    # 单元类型映射表
    UNIT_TYPE_MAP = {
        'Unit': 'Unit',
        'U': 'Unit',
        'Unit No': 'Unit',
        'Unit Number': 'Unit',
        'Apt': 'Apartment',
        'Apt.': 'Apartment',
        'Apartment': 'Apartment',
        'Flat': 'Flat',
        'Fl': 'Flat',
        'Fl.': 'Flat',
        'Suite': 'Suite',
        'Ste': 'Suite',
        'Ste.': 'Suite',
        'Lot': 'Lot',
        'Lt': 'Lot',
        'Lt.': 'Lot'
    }
    
    @classmethod
    def standardize_address(cls, address: str) -> str:
        """标准化地址格式"""
        if not address:
            return address
        
        # 转换为大写
        address = address.upper()
        
        # 移除多余的空格
        address = re.sub(r'\s+', ' ', address.strip())
        
        # 标准化单元号格式
        # 处理 Unit 3/12 格式
        address = re.sub(r'(UNIT|APT|FLAT|SUITE|LOT)\s*(\d+)/\s*(\d+)', r'\1 \2/\3', address, flags=re.IGNORECASE)
        # 处理 3/12 格式
        address = re.sub(r'(^|\s)(\d+)/\s*(\d+)\s+', r'UNIT \2/\3 ', address)
        # 处理 Apt 3, 12 格式
        address = re.sub(r'(UNIT|APT|FLAT|SUITE|LOT)\s*(\d+),\s*(\d+)', r'\1 \2, \3', address, flags=re.IGNORECASE)
        
        # 标准化街道类型
        for abbr, full in cls.STREET_TYPE_MAP.items():
            # 确保匹配完整的单词
            pattern = r'\\b' + re.escape(abbr.upper()) + r'\\b'
            address = re.sub(pattern, full.upper(), address)
        
        # 标准化单元类型
        for abbr, full in cls.UNIT_TYPE_MAP.items():
            pattern = r'\\b' + re.escape(abbr.upper()) + r'\\b'
            address = re.sub(pattern, full.upper(), address)
        
        # 移除标点符号（除了必要的）
        address = re.sub(r'[;,\'\"]', '', address)
        
        # 标准化数字格式
        address = re.sub(r'(\d+)-(\d+)', r'\1-\2', address)
        
        return address
    
    @classmethod
    def split_address(cls, address: str) -> Dict[str, Optional[str]]:
        """拆分地址为街道号、街道名和街道类型"""
        result = {
            'street_number': None,
            'street_name': None,
            'street_type': None,
            'unit_number': None
        }
        
        if not address:
            return result
        
        # 首先提取单元号
        # 匹配 Unit 3/12 格式
        unit_pattern = r'(?:UNIT|APT|FLAT|SUITE|LOT)\s*(\d+[/,\s]?\d*)'
        unit_match = re.search(unit_pattern, address, re.IGNORECASE)
        if unit_match:
            result['unit_number'] = unit_match.group(1)
            address = address[:unit_match.start()] + address[unit_match.end():]
        
        # 移除多余空格
        address = re.sub(r'\s+', ' ', address.strip())
        
        # 提取街道号和街道名称
        # 匹配数字开头的部分作为街道号
        number_pattern = r'^(\d+[A-Z]?)\s+'
        number_match = re.search(number_pattern, address)
        if number_match:
            result['street_number'] = number_match.group(1)
            street_part = address[number_match.end():]
            
            # 提取街道类型（最后一个单词）
            parts = street_part.split()
            if parts:
                last_part = parts[-1]
                # 检查是否是街道类型
                for abbr, full in cls.STREET_TYPE_MAP.items():
                    if last_part.upper() in [abbr.upper(), full.upper()]:
                        result['street_type'] = last_part
                        result['street_name'] = ' '.join(parts[:-1])
                        break
                else:
                    # 如果没有找到街道类型，整个部分作为街道名
                    result['street_name'] = street_part
        
        return result
    
    @classmethod
    def generate_address_key(cls, address: str, suburb: str) -> str:
        """生成地址键，用于去重和匹配
        
        Args:
            address: 标准化后的地址
            suburb: 郊区名称
            
        Returns:
            地址键字符串
        """
        # 拆分地址
        parts = cls.split_address(address)
        
        # 构建地址键
        key_parts = []
        
        # 添加单元号（如果有）
        if parts.get('unit_number'):
            key_parts.append(parts['unit_number'])
        
        # 添加街道号
        if parts.get('street_number'):
            key_parts.append(parts['street_number'])
        
        # 添加街道名
        if parts.get('street_name'):
            key_parts.append(parts['street_name'].replace(' ', ''))
        
        # 添加街道类型
        if parts.get('street_type'):
            key_parts.append(parts['street_type'].replace(' ', ''))
        
        # 添加郊区
        if suburb:
            key_parts.append(suburb.replace(' ', ''))
        
        # 组合成地址键
        address_key = '_'.join([part.upper() for part in key_parts if part])
        
        return address_key
    
    @classmethod
    def generate_sale_id(cls, address: str, sale_date: str, sale_price: str) -> str:
        """生成唯一的 sale_id
        使用 address + sale_date + sale_price 的组合生成 UUID
        """
        unique_string = f"{address}_{sale_date}_{sale_price}"
        return str(uuid.uuid5(uuid.NAMESPACE_DNS, unique_string))