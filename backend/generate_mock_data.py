#!/usr/bin/env python3
"""
将 CSV 数据转换为模拟数据库格式
"""
import csv
import os

def main():
    """主函数"""
    # 确定项目根目录
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    data_dir = os.path.join(project_root, 'data')
    output_file = os.path.join(project_root, 'backend', 'mock_data.py')
    
    properties = []
    sales = []
    
    # 读取 properties.csv
    with open(os.path.join(data_dir, 'properties.csv'), 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for idx, row in enumerate(reader, 1):
            property_data = {
                'id': idx,
                'address': row['address'],
                'suburb': row['suburb'],
                'property_type': row['property_type'],
                'land_size': int(row['land_size']) if row['land_size'] else None,
                'bedrooms': int(row['bedrooms']) if row['bedrooms'] else None,
                'bathrooms': int(row['bathrooms']) if row['bathrooms'] else None
            }
            properties.append(property_data)
    
    # 读取 raw_sales.csv
    sales_data = []
    with open(os.path.join(data_dir, 'raw_sales.csv'), 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            sales_data.append(row)
    
    # 创建销售记录
    for idx, sale in enumerate(sales_data, 1):
        # 找到对应的 property_id
        address = sale['address']
        prop_id = None
        for prop in properties:
            if prop['address'] == address:
                prop_id = prop['id']
                break
        
        if prop_id:
            # 解析价格
            price_str = sale['sold_price'].replace('$', '').replace(',', '')
            try:
                sold_price = int(float(price_str))
            except:
                sold_price = 0
            
            # 解析日期
            sold_date = sale['sold_date']
            
            sales.append({
                'id': idx,
                'property_id': prop_id,
                'sold_price': sold_price,
                'sold_date': sold_date
            })
    
    # 写入 mock_data.py
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(f"MOCK_PROPERTIES = [\n")
        for prop in properties:
            f.write(f"    {prop},\n")
        f.write(f"]\n\n")
        f.write(f"MOCK_SALES = [\n")
        for sale in sales:
            f.write(f"    {sale},\n")
        f.write(f"]\n")
    
    print(f"Generated: {len(properties)} properties, {len(sales)} sales records")
    print(f"Saved to: {output_file}")

if __name__ == "__main__":
    main()
