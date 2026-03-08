'use client';

import { useRouter } from 'next/navigation';

interface SuburbRanking {
  id: string;
  name: string;
  compass_score: number;
  median_price: number;
  growth_rate: number;
  investment_potential: string;
}

interface TopInvestmentSuburbsProps {
  rankings: SuburbRanking[];
}

export default function TopInvestmentSuburbs({ rankings }: TopInvestmentSuburbsProps) {
  const router = useRouter();

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 模拟数据（API 无数据时使用）
  const mockRankings: SuburbRanking[] = [
    { id: '1', name: 'Sunnybank', compass_score: 82, median_price: 1200000, growth_rate: 8.5, investment_potential: 'High' },
    { id: '2', name: 'Rochedale', compass_score: 79, median_price: 950000, growth_rate: 12.3, investment_potential: 'Very High' },
    { id: '3', name: 'Mansfield', compass_score: 76, median_price: 1050000, growth_rate: 7.2, investment_potential: 'High' },
    { id: '4', name: 'Eight Mile Plains', compass_score: 74, median_price: 880000, growth_rate: 9.1, investment_potential: 'High' },
    { id: '5', name: 'Calamvale', compass_score: 71, median_price: 750000, growth_rate: 6.8, investment_potential: 'Medium-High' },
    { id: '6', name: 'Hamilton', compass_score: 68, median_price: 1500000, growth_rate: 5.2, investment_potential: 'Medium' },
  ];

  const displayRankings = rankings.length > 0 ? rankings : mockRankings;

  // 投资潜力中文映射 + 样式
  const potentialConfig: Record<string, { label: string; style: string }> = {
    'Very High': { label: '极高', style: 'bg-red-100 text-red-700' },
    'High': { label: '高', style: 'bg-orange-100 text-orange-700' },
    'Medium-High': { label: '中高', style: 'bg-yellow-100 text-yellow-700' },
    'Medium': { label: '中等', style: 'bg-blue-100 text-blue-700' },
    'Low': { label: '低', style: 'bg-gray-100 text-gray-700' },
  };

  // 评分颜色
  const getScoreColor = (score: number) => {
    if (score >= 80) return 'from-green-400 to-green-600';
    if (score >= 70) return 'from-blue-400 to-blue-600';
    if (score >= 60) return 'from-yellow-400 to-yellow-600';
    return 'from-gray-400 to-gray-600';
  };

  return (
    <section className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-12">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              投资优选郊区
            </h2>
            <p className="text-lg text-gray-600">
              基于 Compass 多维评分，发现最具投资价值的郊区
            </p>
          </div>
          <button
            className="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors"
            onClick={() => router.push('/rankings')}
          >
            查看完整排名
          </button>
        </div>

        {/* Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {displayRankings.map((ranking) => {
            const potential = potentialConfig[ranking.investment_potential] || potentialConfig['Medium'];

            return (
              <div
                key={ranking.id}
                onClick={() => router.push(`/suburb/${encodeURIComponent(ranking.name)}`)}
                className="bg-white rounded-xl border border-gray-200 p-6 hover:shadow-xl hover:border-blue-400 transition-all cursor-pointer group relative overflow-hidden"
              >
                {/* Score badge */}
                <div className={`absolute top-4 right-4 w-14 h-14 rounded-full bg-gradient-to-br ${getScoreColor(ranking.compass_score)} flex items-center justify-center shadow-lg`}>
                  <span className="text-white font-bold text-lg">{ranking.compass_score}</span>
                </div>

                {/* Suburb name */}
                <h3 className="text-xl font-bold text-gray-900 mb-1 group-hover:text-blue-600 transition-colors pr-16">
                  {ranking.name}
                </h3>

                {/* Investment potential tag */}
                <span className={`inline-block px-3 py-1 rounded-full text-xs font-medium mb-4 ${potential.style}`}>
                  投资潜力: {potential.label}
                </span>

                {/* Data grid */}
                <div className="grid grid-cols-2 gap-3 mb-4">
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-1">中位价</p>
                    <p className="text-sm font-bold text-gray-900">
                      {ranking.median_price ? formatPrice(ranking.median_price) : '加载中'}
                    </p>
                  </div>
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-1">年增长率</p>
                    <p className={`text-sm font-bold ${ranking.growth_rate > 0 ? 'text-green-600' : 'text-red-600'}`}>
                      {ranking.growth_rate ? `+${ranking.growth_rate}%` : '加载中'}
                    </p>
                  </div>
                </div>

                {/* CTA */}
                <div className="flex items-center justify-between pt-3 border-t border-gray-100">
                  <span className="text-xs text-gray-400">Compass 评分</span>
                  <span className="text-blue-500 group-hover:text-blue-700 font-medium text-sm transition-colors">
                    查看详情 →
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
