import argparse
import os
from .database import db
from .data_processor import DataProcessor
from .deal_engine import DealEngine


def main():
    """主函数"""
    parser = argparse.ArgumentParser(description='数据处理管道')
    parser.add_argument('--init', action='store_true', help='初始化数据库表结构')
    parser.add_argument('--process', type=str, help='处理原始数据文件')
    parser.add_argument('--source', type=str, default='QLD Government', help='数据来源')
    parser.add_argument('--aggregate-suburbs', action='store_true', help='聚合郊区数据')
    parser.add_argument('--run-deal-engine', action='store_true', help='运行 Deal Engine')
    parser.add_argument('--get-top-deals', type=int, default=10, help='获取 Top Deals')
    
    args = parser.parse_args()
    
    if args.init:
        print("初始化数据库表结构...")
        try:
            db.connect()
            db.create_tables()
            print("数据库表结构初始化成功")
        except Exception as e:
            print(f"初始化失败: {e}")
        finally:
            db.disconnect()
    
    elif args.process:
        file_path = args.process
        if not os.path.exists(file_path):
            print(f"文件不存在: {file_path}")
            return
        
        print(f"处理数据文件: {file_path}")
        print(f"数据来源: {args.source}")
        
        stats = DataProcessor.process_raw_data(file_path, args.source)
        
        print("\n处理结果:")
        print(f"总记录数: {stats['total']}")
        print(f"有效记录数: {stats['valid']}")
        print(f"无效记录数: {stats['invalid']}")
        print(f"隔离记录数: {stats['quarantined']}")
        print(f"更新记录数: {stats.get('updated', 0)}")
    
    elif args.aggregate_suburbs:
        print("聚合郊区数据...")
        DataProcessor.aggregate_suburbs()
    
    elif args.run_deal_engine:
        print("运行 Deal Engine...")
        # 模拟房源数据
        sample_listings = [
            {
                'address': '123 Main St',
                'suburb': 'Rochedale',
                'listing_price': '850000',
                'land_size': '600',
                'zoning': 'MDR',
                'annual_rent': '42500'
            },
            {
                'address': '456 George St',
                'suburb': 'Brisbane City',
                'listing_price': '1200000',
                'land_size': '200',
                'zoning': 'HDR',
                'annual_rent': '54000'
            },
            {
                'address': '789 Park Ave',
                'suburb': 'Mansfield',
                'listing_price': '950000',
                'land_size': '800',
                'zoning': 'LDR',
                'annual_rent': '47500'
            },
            {
                'address': '321 Market Rd',
                'suburb': 'Sunnybank',
                'listing_price': '750000',
                'land_size': '500',
                'zoning': 'MDR',
                'annual_rent': '45000'
            },
            {
                'address': '654 Oak Ave',
                'suburb': 'Eight Mile Plains',
                'listing_price': '800000',
                'land_size': '700',
                'zoning': 'LDR',
                'annual_rent': '48000'
            }
        ]
        
        # 处理房源
        deals = DealEngine.process_listings(sample_listings)
        
        # 保存 Deal
        DealEngine.save_deals(deals)
        
        # 打印结果
        print("\nTop Deals:")
        for i, deal in enumerate(deals[:5]):
            print(f"\n{i+1}. {deal['address']}, {deal['suburb']}")
            print(f"   价格: ${deal['listing_price']:,}")
            print(f"   Deal Score: {deal['deal_score']}")
            print(f"   分类: {deal['category']}")
            print(f"   低估比例: {round(deal['undervalue_ratio'] * 100, 1)}%")
            print(f"   AI 解释: {deal['explanation']}")
    
    elif args.get_top_deals:
        print(f"获取 Top {args.get_top_deals} Deals...")
        deals = DealEngine.get_top_deals(args.get_top_deals)
        
        print("\nTop Deals:")
        for i, deal in enumerate(deals):
            print(f"\n{i+1}. {deal['address']}, {deal['suburb']}")
            print(f"   价格: ${deal['listing_price']:,}")
            print(f"   Deal Score: {deal['deal_score']}")
            print(f"   分类: {deal['category']}")
    
    else:
        parser.print_help()


if __name__ == '__main__':
    main()