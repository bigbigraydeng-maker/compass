'use client';

import { useRouter } from 'next/navigation';

// ✅ 匹配 /api/rankings 实际返回的字段
interface ScoreBreakdown {
  score: number;
  max: number;
  label: string;
}

interface RankingData {
  suburb: string;
  total_score: number;
  grade: string;
  rank: number;
  breakdown: Record<string, ScoreBreakdown>;
}

// 来自 /api/home 的 suburb_stats
interface SuburbStat {
  suburb: string;
  median_price: number;
  total_sales: number;
}

interface TopInvestmentSuburbsProps {
  rankings: RankingData[];
  suburbStats: SuburbStat[];
}

export default function TopInvestmentSuburbs({ rankings, suburbStats }: TopInvestmentSuburbsProps) {
  const router = useRouter();

  const formatPrice = (price: number) => {
    if (!price) return '-';
    if (price >= 1000000) return `$${(price / 1000000).toFixed(1)}M`;
    if (price >= 1000) return `$${(price / 1000).toFixed(0)}K`;
    return `$${price}`;
  };

  const formatPriceFull = (price: number) => {
    if (!price) return '-';
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 通过郊区名找到中位价
  const getMedianPrice = (suburb: string): number => {
    const stat = suburbStats.find(
      s => s.suburb.toLowerCase() === suburb.toLowerCase()
    );
    return stat?.median_price || 0;
  };

  // 通过郊区名找到成交量
  const getSalesCount = (suburb: string): number => {
    const stat = suburbStats.find(
      s => s.suburb.toLowerCase() === suburb.toLowerCase()
    );
    return stat?.total_sales || 0;
  };

  // 评分等级 → 投资潜力
  const gradeConfig: Record<string, { label: string; style: string }> = {
    'S': { label: '极高', style: 'bg-red-100 text-red-700' },
    'A': { label: '高', style: 'bg-orange-100 text-orange-700' },
    'B': { label: '中高', style: 'bg-yellow-100 text-yellow-700' },
    'C': { label: '中等', style: 'bg-blue-100 text-blue-700' },
    'D': { label: '一般', style: 'bg-gray-100 text-gray-700' },
  };

  // 评分颜色
  const getScoreColor = (score: number) => {
    if (score >= 80) return 'from-green-400 to-green-600';
    if (score >= 70) return 'from-blue-400 to-blue-600';
    if (score >= 60) return 'from-yellow-400 to-yellow-600';
    return 'from-gray-400 to-gray-600';
  };

  // 维度名称中文映射
  const dimensionLabels: Record<string, string> = {
    'growth': '增长',
    'school': '学区',
    'land': '土地',
    'activity': '活跃度',
    'chinese': '华人',
  };

  const dimensionColors: Record<string, string> = {
    'growth': 'bg-red-500',
    'school': 'bg-yellow-500',
    'land': 'bg-green-500',
    'activity': 'bg-blue-500',
    'chinese': 'bg-purple-500',
  };

  // 没有排名数据时显示提示
  if (!rankings || rankings.length === 0) {
    return (
      <section className="py-10 md:py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-4">投资优选 Suburbs</h2>
          <p className="text-sm md:text-lg text-gray-600 mb-6">基于 Compass 多维评分</p>
          <div className="text-center py-8 text-gray-400">排名数据加载中...</div>
        </div>
      </section>
    );
  }

  return (
    <section className="py-10 md:py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex justify-between items-center mb-6 md:mb-12">
          <div>
            <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-1 md:mb-4">
              投资优选 Suburbs
            </h2>
            <p className="text-sm md:text-lg text-gray-600">
              基于 Compass 多维评分
            </p>
          </div>
          <button
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 md:px-6 md:py-3 rounded-lg text-sm md:text-base font-medium transition-colors whitespace-nowrap"
            onClick={() => router.push('/rankings')}
          >
            完整排名
          </button>
        </div>

        {/* ===== 手机端：2列紧凑网格，只显示4个 ===== */}
        <div className="grid grid-cols-2 gap-3 md:hidden">
          {rankings.slice(0, 4).map((ranking) => {
            const potential = gradeConfig[ranking.grade] || gradeConfig['C'];
            const medianPrice = getMedianPrice(ranking.suburb);

            return (
              <div
                key={ranking.suburb}
                onClick={() => router.push(`/suburb/${encodeURIComponent(ranking.suburb)}`)}
                className="bg-white rounded-xl border border-gray-200 p-3 active:bg-gray-50 transition-colors cursor-pointer relative overflow-hidden"
              >
                {/* Score badge - 小号 */}
                <div className={`absolute top-2 right-2 w-10 h-10 rounded-full bg-gradient-to-br ${getScoreColor(ranking.total_score)} flex items-center justify-center shadow`}>
                  <span className="text-white font-bold text-sm">{ranking.total_score}</span>
                </div>

                {/* Suburb name */}
                <h3 className="font-bold text-sm text-gray-900 mb-1 pr-12 leading-tight">
                  {ranking.suburb}
                </h3>

                {/* Grade tag - 精简 */}
                <span className={`inline-block px-2 py-0.5 rounded-full text-[10px] font-medium mb-2 ${potential.style}`}>
                  {ranking.grade}级·{potential.label}
                </span>

                {/* 中位价 */}
                <div className="bg-gray-50 rounded-lg p-2 mb-2">
                  <p className="text-[10px] text-gray-500">中位价</p>
                  <p className="text-xs font-bold text-gray-900">
                    {medianPrice ? formatPrice(medianPrice) : '-'}
                  </p>
                </div>

                {/* 迷你维度条 - 只显示前2个 */}
                {ranking.breakdown && (
                  <div className="space-y-1">
                    {Object.entries(ranking.breakdown).slice(0, 2).map(([key, dim]) => (
                      <div key={key} className="flex items-center gap-1">
                        <span className="text-[9px] text-gray-400 w-8 text-right truncate">
                          {dimensionLabels[key] || key}
                        </span>
                        <div className="flex-1 bg-gray-100 rounded-full h-1 overflow-hidden">
                          <div
                            className={`h-full rounded-full ${dimensionColors[key] || 'bg-blue-500'}`}
                            style={{ width: `${(dim.score / dim.max) * 100}%` }}
                          ></div>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                {/* CTA */}
                <div className="mt-2 text-right">
                  <span className="text-blue-500 font-medium text-xs">详情 →</span>
                </div>
              </div>
            );
          })}
        </div>

        {/* ===== 桌面端：3列网格，显示6个 ===== */}
        <div className="hidden md:grid grid-cols-2 lg:grid-cols-3 gap-6">
          {rankings.slice(0, 6).map((ranking) => {
            const potential = gradeConfig[ranking.grade] || gradeConfig['C'];
            const medianPrice = getMedianPrice(ranking.suburb);
            const salesCount = getSalesCount(ranking.suburb);

            return (
              <div
                key={ranking.suburb}
                onClick={() => router.push(`/suburb/${encodeURIComponent(ranking.suburb)}`)}
                className="bg-white rounded-xl border border-gray-200 p-6 hover:shadow-xl hover:border-blue-400 transition-all cursor-pointer group relative overflow-hidden"
              >
                {/* Score badge */}
                <div className={`absolute top-4 right-4 w-14 h-14 rounded-full bg-gradient-to-br ${getScoreColor(ranking.total_score)} flex items-center justify-center shadow-lg`}>
                  <span className="text-white font-bold text-lg">{ranking.total_score}</span>
                </div>

                {/* Suburb name */}
                <h3 className="text-xl font-bold text-gray-900 mb-1 group-hover:text-blue-600 transition-colors pr-16">
                  {ranking.suburb}
                </h3>

                {/* Grade + potential tag */}
                <div className="flex items-center gap-2 mb-4">
                  <span className={`inline-block px-3 py-1 rounded-full text-xs font-medium ${potential.style}`}>
                    {ranking.grade} 级 · 投资潜力{potential.label}
                  </span>
                </div>

                {/* Data grid */}
                <div className="grid grid-cols-2 gap-3 mb-4">
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-1">中位价</p>
                    <p className="text-sm font-bold text-gray-900">
                      {medianPrice ? formatPriceFull(medianPrice) : '-'}
                    </p>
                  </div>
                  <div className="bg-gray-50 rounded-lg p-3">
                    <p className="text-xs text-gray-500 mb-1">成交量</p>
                    <p className="text-sm font-bold text-blue-600">
                      {salesCount > 0 ? `${salesCount} 套` : '-'}
                    </p>
                  </div>
                </div>

                {/* Mini dimension bars */}
                {ranking.breakdown && (
                  <div className="space-y-1.5 mb-4">
                    {Object.entries(ranking.breakdown).slice(0, 3).map(([key, dim]) => (
                      <div key={key} className="flex items-center gap-2">
                        <span className="text-xs text-gray-400 w-16 text-right truncate">
                          {dimensionLabels[key] || dim.label}
                        </span>
                        <div className="flex-1 bg-gray-100 rounded-full h-1.5 overflow-hidden">
                          <div
                            className={`h-full rounded-full ${dimensionColors[key] || 'bg-blue-500'}`}
                            style={{ width: `${(dim.score / dim.max) * 100}%` }}
                          ></div>
                        </div>
                        <span className="text-xs text-gray-500 w-8">
                          {dim.score}
                        </span>
                      </div>
                    ))}
                  </div>
                )}

                {/* CTA */}
                <div className="flex items-center justify-between pt-3 border-t border-gray-100">
                  <span className="text-xs text-gray-400">Compass 评分 {ranking.total_score}/100</span>
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
