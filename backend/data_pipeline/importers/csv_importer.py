import os
import csv
from typing import List, Dict
from ..data_processor import DataProcessor

class CSVImporter:
    """CSV 导入器，负责从目录批量读取 CSV 文件"""
    
    @staticmethod
    def import_from_directory(directory: str, source: str) -> Dict[str, int]:
        """从目录批量导入 CSV 文件
        
        Args:
            directory: 包含 CSV 文件的目录路径
            source: 数据来源
            
        Returns:
            导入结果统计信息
        """
        stats = {
            'total_files': 0,
            'processed_files': 0,
            'total_records': 0,
            'valid_records': 0,
            'invalid_records': 0,
            'quarantined_records': 0,
            'updated_records': 0
        }
        
        if not os.path.exists(directory):
            print(f"目录不存在: {directory}")
            return stats
        
        # 获取目录中的所有 CSV 文件
        csv_files = [f for f in os.listdir(directory) if f.endswith('.csv')]
        stats['total_files'] = len(csv_files)
        
        print(f"找到 {len(csv_files)} 个 CSV 文件")
        
        # 处理每个 CSV 文件
        for csv_file in csv_files:
            file_path = os.path.join(directory, csv_file)
            print(f"处理文件: {csv_file}")
            
            # 使用 DataProcessor 处理文件
            file_stats = DataProcessor.process_raw_data(file_path, source)
            
            # 累计统计信息
            stats['processed_files'] += 1
            stats['total_records'] += file_stats.get('total', 0)
            stats['valid_records'] += file_stats.get('valid', 0)
            stats['invalid_records'] += file_stats.get('invalid', 0)
            stats['quarantined_records'] += file_stats.get('quarantined', 0)
            stats['updated_records'] += file_stats.get('updated', 0)
            
        return stats
    
    @staticmethod
    def validate_csv_structure(file_path: str) -> bool:
        """验证 CSV 文件结构
        
        Args:
            file_path: CSV 文件路径
            
        Returns:
            如果文件结构有效则返回 True，否则返回 False
        """
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                headers = reader.fieldnames
                
                # 检查必要字段
                required_fields = ['address', 'suburb', 'sale_price', 'sale_date']
                for field in required_fields:
                    if field not in headers:
                        print(f"缺少必要字段: {field}")
                        return False
                
                # 检查是否有数据行
                next(reader, None) is not None
                
                return True
        except Exception as e:
            print(f"验证 CSV 文件失败: {e}")
            return False