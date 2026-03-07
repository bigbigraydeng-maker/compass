interface DealData {
  id: string;
  address: string;
  suburb: string;
  listing_price: number;
  estimated_value: number;
  discount_percent: number;
  compass_score: number;
  why_deal: string;
  update_time: string;
  comparable_sales: number;
  risk_level: string;
}

interface TodayDealsProps {
  deals: DealData[];
}

export default function TodayDeals({ deals }: TodayDealsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 模拟数据 - 使用更真实的地址
  const mockDeals: DealData[] = [
    {
      id: '1',
      address: '18 Karingal Street',
      suburb: 'Sunnybank',
      listing_price: 850000,
      estimated_value: 980000,
      discount_percent: 13,
      compass_score: 82,
      why_deal: '低于区域中位价13%，附近有优质学校和华人超市',
      update_time: '2026-03-08 10:30',
      comparable_sales: 5,
      risk_level: '低'
    },
    {
      id: '2',
      address: '45 Appleby Road',
      suburb: 'Rochedale',
      listing_price: 720000,
      estimated_value: 850000,
      discount_percent: 15,
      compass_score: 79,
      why_deal: '新区发展潜力大，未来规划有地铁站',
      update_time: '2026-03-08 09:15',
      comparable_sales: 3,
      risk_level: '中'
    },
    {
      id: '3',
      address: '72 Ham Road',
      suburb: 'Mansfield',
      listing_price: 920000,
      estimated_value: 1050000,
      discount_percent: 12,
      compass_score: 76,
      why_deal: '学区房，靠近Mansfield State High School',
      update_time: '2026-03-07 16:45',
      comparable_sales: 4,
      risk_level: '低'
    }
  ];

  const displayDeals = deals.length > 0 ? deals : mockDeals;

  // 风险等级样式映射
  const riskLevelStyles: Record<string, string> = {
    '低': 'bg-green-100 text-green-800',
    '中': 'bg-yellow-100 text-yellow-800',
    '高': 'bg-red-100 text-red-800'
  };

  return (
    <section className="py-20 bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-12">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              今日捡漏
            </h2>
            <p className="text-lg text-gray-600">
              精心挑选的低于市场价值的投资机会
            </p>
          </div>
          <button className="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
            查看全部捡漏
          </button>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {displayDeals.map((deal) => (
            <div key={deal.id} className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow overflow-hidden border border-gray-200">
              <div className="p-6">
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h3 className="font-bold text-lg text-gray-900 mb-1">{deal.address}</h3>
                    <p className="text-sm text-gray-500">{deal.suburb}</p>
                  </div>
                  <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
                    省 {deal.discount_percent}%
                  </div>
                </div>
                
                {/* Why it's a deal */}
                <div className="mb-4">
                  <h4 className="text-sm font-medium text-gray-700 mb-2">为什么是捡漏</h4>
                  <p className="text-sm text-gray-600">{deal.why_deal}</p>
                </div>
                
                <div className="space-y-3 mb-6">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">挂牌价</span>
                    <span className="font-semibold text-gray-900">{formatPrice(deal.listing_price)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">估计价值</span>
                    <span className="font-semibold text-blue-600">{formatPrice(deal.estimated_value)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Compass 评分</span>
                    <span className="font-semibold text-orange-600">{deal.compass_score}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">可比成交</span>
                    <span className="font-semibold text-gray-700">{deal.comparable_sales} 套</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">风险等级</span>
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${riskLevelStyles[deal.risk_level] || 'bg-gray-100 text-gray-800'}`}>
                      {deal.risk_level}
                    </span>
                  </div>
                </div>
                
                <div className="flex gap-3 mb-4">
                  <button className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-medium transition-colors">
                    🤖 分析
                  </button>
                  <button className="bg-gray-100 hover:bg-gray-200 text-gray-800 py-3 px-4 rounded-lg font-medium transition-colors">
                    查看
                  </button>
                </div>
                
                {/* 数据更新时间 */}
                <div className="text-xs text-gray-400">
                  数据更新时间: {deal.update_time} | 来源: Compass AI 分析
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
