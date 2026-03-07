from typing import Dict, List, Optional
from .config import REQUIRED_FIELDS

class DataValidator:
    """数据验证类，负责验证数据质量"""
    
    @staticmethod
    def validate_sale_data(data: Dict) -> Dict[str, List[str]]:
        """验证销售数据的质量
        
        Args:
            data: 销售数据字典
            
        Returns:
            包含错误信息的字典，键为字段名，值为错误信息列表
        """
        errors = {}
        
        # 验证必填字段
        for field in REQUIRED_FIELDS:
            if field not in data or not data[field]:
                errors[field] = ["此字段为必填项"]
        
        # 验证销售价格
        if "sale_price" in data and data["sale_price"]:
            try:
                price = float(data["sale_price"])
                if price <= 0:
                    errors["sale_price"] = ["销售价格必须大于0"]
            except ValueError:
                errors["sale_price"] = ["销售价格必须是数字"]
        
        # 验证销售日期
        if "sale_date" in data and data["sale_date"]:
            # 这里可以添加日期格式验证
            pass
        
        # 验证卧室数量
        if "bedrooms" in data and data["bedrooms"]:
            try:
                bedrooms = int(data["bedrooms"])
                if bedrooms < 0:
                    errors["bedrooms"] = ["卧室数量不能为负数"]
            except ValueError:
                errors["bedrooms"] = ["卧室数量必须是整数"]
        
        # 验证浴室数量
        if "bathrooms" in data and data["bathrooms"]:
            try:
                bathrooms = int(data["bathrooms"])
                if bathrooms < 0:
                    errors["bathrooms"] = ["浴室数量不能为负数"]
            except ValueError:
                errors["bathrooms"] = ["浴室数量必须是整数"]
        
        # 验证土地面积
        if "land_size" in data and data["land_size"]:
            try:
                land_size = float(data["land_size"])
                if land_size < 0:
                    errors["land_size"] = ["土地面积不能为负数"]
            except ValueError:
                errors["land_size"] = ["土地面积必须是数字"]
        
        return errors
    
    @staticmethod
    def is_valid(data: Dict) -> bool:
        """检查数据是否有效
        
        Args:
            data: 销售数据字典
            
        Returns:
            如果数据有效则返回 True，否则返回 False
        """
        errors = DataValidator.validate_sale_data(data)
        return len(errors) == 0