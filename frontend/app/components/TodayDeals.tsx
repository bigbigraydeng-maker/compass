import { useState, useEffect, useRef } from 'react';
import { fetcher } from '../lib/api';

interface DealData {
  deal_id: string;
  address: string;
  suburb: string;
  listing_price: number;
  deal_score: number;
  undervalue_ratio: number;
  category: string;
  explanation: string;
  land_size?: number;
  zoning?: string;
  rental_yield?: number;
}

export default function TodayDeals() {
  const [deals, setDeals] = useState<DealData[]>([]);
  const [loading, setLoading] = useState(true);
  const hasLoaded = useRef(false);

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  useEffect(() => {
    if (hasLoaded.current) return;
    hasLoaded.current = true;

    let cancelled = false;

    const loadDeals = async () => {
      try {
        const data = await fetcher('/api/deals');
        if (cancelled) return;
        if (data?.deals) {
          setDeals(data.deals);
        }
      } catch (error) {
        console.error('Failed to load deals:', error);
      } finally {
        if (!cancelled) setLoading(false);
      }
    };

    loadDeals();

    return () => { cancelled = true; };
  }, []);

  // 分类样式映射
  const categoryStyles: Record<string, string> = {
    '捡漏房源': 'bg-red-100 text-red-800',
    '投资机会': 'bg-blue-100 text-blue-800',
    '土地开发机会': 'bg-green-100 text-green-800',
    '高租金房源': 'bg-purple-100 text-purple-800',
    '普通房源': 'bg-gray-100 text-gray-800'
  };

  if (loading) {
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
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[1, 2, 3].map((i) => (
              <div key={i} className="bg-white rounded-xl shadow-lg p-6 animate-pulse">
                <div className="h-6 bg-gray-200 rounded mb-4"></div>
                <div className="h-4 bg-gray-200 rounded mb-2"></div>
                <div className="h-4 bg-gray-200 rounded mb-6"></div>
                <div className="space-y-3 mb-6">
                  {[1, 2, 3, 4].map((j) => (
                    <div key={j} className="h-4 bg-gray-200 rounded"></div>
                  ))}
                </div>
                <div className="h-10 bg-gray-200 rounded mb-4"></div>
                <div className="h-4 bg-gray-200 rounded"></div>
              </div>
            ))}
          </div>
        </div>
      </section>
    );
  }

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
          {deals.map((deal) => (
            <div key={deal.deal_id} className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow overflow-hidden border border-gray-200">
              <div className="p-6">
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h3 className="font-bold text-lg text-gray-900 mb-1">{deal.address}</h3>
                    <p className="text-sm text-gray-500">{deal.suburb}</p>
                  </div>
                  <div className={`px-3 py-1 rounded-full text-sm font-medium ${categoryStyles[deal.category] || 'bg-gray-100 text-gray-800'}`}>
                    {deal.category}
                  </div>
                </div>

                {/* Why it's a deal */}
                <div className="mb-4">
                  <h4 className="text-sm font-medium text-gray-700 mb-2">为什么是捡漏</h4>
                  <p className="text-sm text-gray-600">{deal.explanation}</p>
                </div>

                <div className="space-y-3 mb-6">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">挂牌价</span>
                    <span className="font-semibold text-gray-900">{formatPrice(deal.listing_price)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Deal Score</span>
                    <span className="font-semibold text-orange-600">{deal.deal_score}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">低估比例</span>
                    <span className="font-semibold text-green-600">{Math.round(deal.undervalue_ratio * 100)}%</span>
                  </div>
                  {deal.land_size && (
                    <div className="flex justify-between">
                      <span className="text-sm text-gray-600">土地面积</span>
                      <span className="font-semibold text-gray-700">{deal.land_size} m²</span>
                    </div>
                  )}
                  {deal.rental_yield && (
                    <div className="flex justify-between">
                      <span className="text-sm text-gray-600">租金回报</span>
                      <span className="font-semibold text-purple-600">{deal.rental_yield}%</span>
                    </div>
                  )}
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
                  数据更新时间: {new Date().toLocaleString('zh-CN')} | 来源: Compass AI 分析
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
