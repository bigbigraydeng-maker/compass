import uuid
import json
from datetime import datetime
from typing import Dict, List, Optional
from .database import db

class DealEngine:
    """Compass Deal Engine，负责发现值得关注的房地产机会"""
    
    @staticmethod
    def calculate_deal_score(listing: Dict, suburb_metrics: Dict = None, ai_estimated_price: float = None) -> Dict:
        """计算房源的 Deal Score
        
        Args:
            listing: 房源信息
            suburb_metrics: 郊区指标
            ai_estimated_price: AI 估价
            
        Returns:
            包含 Deal Score 和各维度评分的字典
        """
        # 计算各维度评分
        undervalue_score = DealEngine._calculate_undervalue_score(listing, ai_estimated_price)
        suburb_score = DealEngine._calculate_suburb_score(suburb_metrics)
        land_score = DealEngine._calculate_land_score(listing)
        liquidity_score = DealEngine._calculate_liquidity_score(suburb_metrics)
        rental_score = DealEngine._calculate_rental_score(listing)
        
        # 计算总分
        deal_score = sum([
            undervalue_score,
            suburb_score,
            land_score,
            liquidity_score,
            rental_score
        ])
        
        # 计算低估比例
        undervalue_ratio = None
        if ai_estimated_price and listing.get('listing_price'):
            listing_price = float(listing['listing_price'])
            if ai_estimated_price > 0:
                undervalue_ratio = (ai_estimated_price - listing_price) / ai_estimated_price
        
        # 分类
        category = DealEngine._classify_deal(undervalue_ratio, deal_score, land_score, rental_score)
        
        return {
            'deal_score': deal_score,
            'undervalue_score': undervalue_score,
            'suburb_score': suburb_score,
            'land_score': land_score,
            'liquidity_score': liquidity_score,
            'rental_score': rental_score,
            'undervalue_ratio': undervalue_ratio,
            'category': category
        }
    
    @staticmethod
    def _calculate_undervalue_score(listing: Dict, ai_estimated_price: float = None) -> int:
        """计算价格低估度评分
        
        Args:
            listing: 房源信息
            ai_estimated_price: AI 估价
            
        Returns:
            价格低估度评分 (0-30)
        """
        if not ai_estimated_price or not listing.get('listing_price'):
            return 0
        
        listing_price = float(listing['listing_price'])
        if ai_estimated_price <= 0:
            return 0
        
        undervalue_ratio = (ai_estimated_price - listing_price) / ai_estimated_price
        
        if undervalue_ratio > 0.2:
            return 30
        elif undervalue_ratio > 0.15:
            return 25
        elif undervalue_ratio > 0.1:
            return 20
        elif undervalue_ratio > 0.05:
            return 10
        else:
            return 0
    
    @staticmethod
    def _calculate_suburb_score(suburb_metrics: Dict = None) -> int:
        """计算区域潜力评分
        
        Args:
            suburb_metrics: 郊区指标
            
        Returns:
            区域潜力评分 (0-20)
        """
        if not suburb_metrics:
            return 0
        
        score = 0
        
        # 房价增长 (0-10)
        growth = suburb_metrics.get('growth_12m', 0)
        if growth > 10:
            score += 10
        elif growth > 8:
            score += 8
        elif growth > 5:
            score += 6
        elif growth > 3:
            score += 4
        elif growth > 0:
            score += 2
        
        # 学校评分 (0-5)
        school_score = suburb_metrics.get('school_score', 0)
        if school_score > 90:
            score += 5
        elif school_score > 80:
            score += 4
        elif school_score > 70:
            score += 3
        elif school_score > 60:
            score += 2
        elif school_score > 50:
            score += 1
        
        # 华人友好度 (0-5)
        chinese_score = suburb_metrics.get('chinese_score', 0)
        if chinese_score > 80:
            score += 5
        elif chinese_score > 60:
            score += 4
        elif chinese_score > 40:
            score += 3
        elif chinese_score > 20:
            score += 2
        elif chinese_score > 0:
            score += 1
        
        return min(score, 20)
    
    @staticmethod
    def _calculate_land_score(listing: Dict) -> int:
        """计算土地潜力评分
        
        Args:
            listing: 房源信息
            
        Returns:
            土地潜力评分 (0-20)
        """
        land_size = listing.get('land_size', 0)
        if isinstance(land_size, str):
            try:
                land_size = float(land_size)
            except:
                land_size = 0
        
        if land_size <= 400:
            return 0
        
        score = 0
        
        # Zoning 评分 (0-20)
        zoning = listing.get('zoning', '').upper()
        if 'HDR' in zoning:
            score += 20
        elif 'MDR' in zoning:
            score += 15
        elif 'LDR' in zoning:
            score += 5
        
        # Corner block (0-5)
        is_corner = listing.get('is_corner', False)
        if is_corner:
            score += 5
        
        # Large land (0-5)
        if land_size > 800:
            score += 5
        
        return min(score, 20)
    
    @staticmethod
    def _calculate_liquidity_score(suburb_metrics: Dict = None) -> int:
        """计算市场流动性评分
        
        Args:
            suburb_metrics: 郊区指标
            
        Returns:
            市场流动性评分 (0-15)
        """
        if not suburb_metrics:
            return 0
        
        sales_volume = suburb_metrics.get('sales_12m', 0)
        listing_count = suburb_metrics.get('listing_count', 1)
        
        if listing_count == 0:
            return 0
        
        liquidity = sales_volume / listing_count
        
        if liquidity > 0.8:
            return 15
        elif liquidity > 0.6:
            return 10
        elif liquidity > 0.4:
            return 5
        else:
            return 0
    
    @staticmethod
    def _calculate_rental_score(listing: Dict) -> int:
        """计算租金回报评分
        
        Args:
            listing: 房源信息
            
        Returns:
            租金回报评分 (0-15)
        """
        listing_price = listing.get('listing_price')
        annual_rent = listing.get('annual_rent')
        
        if not listing_price or not annual_rent:
            return 0
        
        try:
            listing_price = float(listing_price)
            annual_rent = float(annual_rent)
        except:
            return 0
        
        if listing_price <= 0:
            return 0
        
        rental_yield = annual_rent / listing_price * 100
        
        if rental_yield > 6:
            return 15
        elif rental_yield > 5:
            return 10
        elif rental_yield > 4:
            return 5
        else:
            return 0
    
    @staticmethod
    def _classify_deal(undervalue_ratio: float, deal_score: int, land_score: int, rental_score: int) -> str:
        """分类 Deal
        
        Args:
            undervalue_ratio: 低估比例
            deal_score: Deal Score
            land_score: 土地评分
            rental_score: 租金评分
            
        Returns:
            Deal 分类
        """
        # 捡漏房源
        if undervalue_ratio and undervalue_ratio > 0.1 and deal_score > 60:
            return '捡漏房源'
        
        # 投资机会
        if deal_score > 65:
            return '投资机会'
        
        # 土地开发机会
        if land_score > 15:
            return '土地开发机会'
        
        # 高租金房源
        if rental_score > 10:
            return '高租金房源'
        
        return '普通房源'
    
    @staticmethod
    def generate_ai_explanation(deal: Dict) -> str:
        """生成 AI 解释
        
        Args:
            deal: Deal 信息
            
        Returns:
            AI 解释文本
        """
        address = deal.get('address', '')
        suburb = deal.get('suburb', '')
        undervalue_ratio = deal.get('undervalue_ratio', 0)
        suburb_score = deal.get('suburb_score', 0)
        land_score = deal.get('land_score', 0)
        rental_score = deal.get('rental_score', 0)
        
        explanation = f"这套房源位于{suburb}，"
        
        if undervalue_ratio and undervalue_ratio > 0:
            percentage = round(undervalue_ratio * 100, 1)
            explanation += f"挂牌价比AI估价低约{percentage}%，"
        
        if suburb_score > 15:
            explanation += "所在区域发展潜力强劲，"
        
        if land_score > 10:
            explanation += "土地面积较大，具备一定开发潜力，"
        
        if rental_score > 10:
            explanation += "租金回报率较高，"
        
        # 移除最后的逗号
        if explanation.endswith('，'):
            explanation = explanation[:-1]
        
        explanation += "。"
        
        return explanation
    
    @staticmethod
    def process_listings(listings: List[Dict]) -> List[Dict]:
        """处理多个房源
        
        Args:
            listings: 房源列表
            
        Returns:
            处理后的 Deal 列表
        """
        deals = []
        
        for listing in listings:
            # 模拟 AI 估价（实际应该使用真实的 AI 模型）
            listing_price = float(listing.get('listing_price', 0))
            ai_estimated_price = listing_price * 1.1  # 假设 AI 估价比挂牌价高 10%
            
            # 模拟郊区指标
            suburb_metrics = {
                'growth_12m': 8.5,
                'school_score': 90,
                'chinese_score': 85,
                'sales_12m': 100,
                'listing_count': 120
            }
            
            # 计算 Deal Score
            deal_info = DealEngine.calculate_deal_score(listing, suburb_metrics, ai_estimated_price)
            
            # 生成 AI 解释
            deal_info['explanation'] = DealEngine.generate_ai_explanation(deal_info)
            
            # 构建完整的 Deal 信息
            deal = {
                'deal_id': str(uuid.uuid4()),
                'property_id': listing.get('property_id', ''),
                'address': listing.get('address', ''),
                'suburb': listing.get('suburb', ''),
                'listing_price': listing_price,
                'land_size': listing.get('land_size'),
                'zoning': listing.get('zoning'),
                'rental_yield': listing.get('rental_yield'),
                **deal_info
            }
            
            deals.append(deal)
        
        # 按 Deal Score 排序
        deals.sort(key=lambda x: x['deal_score'], reverse=True)
        
        return deals
    
    @staticmethod
    def save_deals(deals: List[Dict]):
        """保存 Deal 到数据库
        
        Args:
            deals: Deal 列表
        """
        try:
            db.connect()
            
            batch_data = []
            for deal in deals:
                batch_data.append({
                    'deal_id': deal['deal_id'],
                    'property_id': deal.get('property_id'),
                    'address': deal['address'],
                    'suburb': deal['suburb'],
                    'listing_price': deal['listing_price'],
                    'deal_score': deal['deal_score'],
                    'undervalue_ratio': deal.get('undervalue_ratio'),
                    'land_score': deal.get('land_score'),
                    'suburb_score': deal.get('suburb_score'),
                    'liquidity_score': deal.get('liquidity_score'),
                    'rental_score': deal.get('rental_score'),
                    'category': deal.get('category'),
                    'land_size': deal.get('land_size'),
                    'zoning': deal.get('zoning'),
                    'rental_yield': deal.get('rental_yield')
                })
            
            # 批量插入
            if batch_data:
                query = """
                    INSERT INTO deals (
                        deal_id, property_id, address, suburb, listing_price, deal_score,
                        undervalue_ratio, land_score, suburb_score, liquidity_score, rental_score,
                        category, land_size, zoning, rental_yield, created_at, updated_at
                    ) VALUES (
                        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW(), NOW()
                    ) ON CONFLICT (deal_id) DO UPDATE SET
                        property_id = EXCLUDED.property_id,
                        address = EXCLUDED.address,
                        suburb = EXCLUDED.suburb,
                        listing_price = EXCLUDED.listing_price,
                        deal_score = EXCLUDED.deal_score,
                        undervalue_ratio = EXCLUDED.undervalue_ratio,
                        land_score = EXCLUDED.land_score,
                        suburb_score = EXCLUDED.suburb_score,
                        liquidity_score = EXCLUDED.liquidity_score,
                        rental_score = EXCLUDED.rental_score,
                        category = EXCLUDED.category,
                        land_size = EXCLUDED.land_size,
                        zoning = EXCLUDED.zoning,
                        rental_yield = EXCLUDED.rental_yield,
                        updated_at = NOW()
                """
                
                params = [
                    (
                        data['deal_id'], data['property_id'], data['address'], data['suburb'],
                        data['listing_price'], data['deal_score'], data['undervalue_ratio'],
                        data['land_score'], data['suburb_score'], data['liquidity_score'],
                        data['rental_score'], data['category'], data['land_size'],
                        data['zoning'], data['rental_yield']
                    )
                    for data in batch_data
                ]
                
                db.execute_many(query, params)
                db.commit()
                print(f"成功保存 {len(batch_data)} 条 Deal")
                
        except Exception as e:
            print(f"保存 Deal 失败: {e}")
            db.commit()
        finally:
            db.disconnect()
    
    @staticmethod
    def get_top_deals(limit: int = 10, category: str = None) -> List[Dict]:
        """获取 Top Deals
        
        Args:
            limit: 返回数量
            category: 分类
            
        Returns:
            Top Deals 列表
        """
        try:
            db.connect()
            
            if category:
                query = """
                    SELECT * FROM deals
                    WHERE category = %s
                    ORDER BY deal_score DESC
                    LIMIT %s
                """
                params = (category, limit)
            else:
                query = """
                    SELECT * FROM deals
                    ORDER BY deal_score DESC
                    LIMIT %s
                """
                params = (limit,)
            
            results = db.fetch_all(query, params)
            
            # 转换为字典列表
            deals = []
            for row in results:
                deal = {
                    'deal_id': row[0],
                    'property_id': row[1],
                    'address': row[2],
                    'suburb': row[3],
                    'listing_price': row[4],
                    'deal_score': row[5],
                    'undervalue_ratio': row[6],
                    'land_score': row[7],
                    'suburb_score': row[8],
                    'liquidity_score': row[9],
                    'rental_score': row[10],
                    'category': row[11],
                    'land_size': row[12],
                    'zoning': row[13],
                    'rental_yield': row[14],
                    'created_at': row[15],
                    'updated_at': row[16]
                }
                deals.append(deal)
            
            return deals
            
        except Exception as e:
            print(f"获取 Top Deals 失败: {e}")
            return []
        finally:
            db.disconnect()