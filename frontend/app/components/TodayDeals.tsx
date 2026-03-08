import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { fetcher } from '../lib/api';

// ✅ 匹配 API /api/deals 实际返回的字段
interface DealData {
  id: string;
  property_id: string;
  sold_price: number;
  sold_date: string;
  address: string;
  suburb: string;
  property_type: string;
  land_size: number;
  bedrooms: number;
  bathrooms: number;
  median_price: number;
  discount_percent: number;
}

export default function TodayDeals() {
  const router = useRouter();
  const [deals, setDeals] = useState<DealData[]>([]);
  const [loading, setLoading] = useState(true);
  const [analyzingId, setAnalyzingId] = useState<string | null>(null);
  const [aiReport, setAiReport] = useState<Record<string, string>>({});
  const [aiError, setAiError] = useState<Record<string, string>>({});
  const hasLoaded = useRef(false);
  const scrollRef = useRef<HTMLDivElement>(null);

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

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '-';
    const d = new Date(dateStr);
    return d.toLocaleDateString('zh-CN', { year: 'numeric', month: 'short', day: 'numeric' });
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

  // 根据折扣比例自动分类
  const getCategory = (deal: DealData) => {
    if (deal.discount_percent >= 50) return { label: '超级捡漏', style: 'bg-red-100 text-red-800' };
    if (deal.discount_percent >= 30) return { label: '捡漏房源', style: 'bg-orange-100 text-orange-800' };
    if (deal.land_size >= 500) return { label: '土地价值', style: 'bg-green-100 text-green-800' };
    return { label: '投资机会', style: 'bg-blue-100 text-blue-800' };
  };

  // 房产类型中文映射
  const propertyTypeMap: Record<string, string> = {
    'house': '别墅',
    'unit': '公寓',
    'townhouse': '联排',
    'apartment': '公寓',
    'vacant_land': '空地',
    'other': '其他',
  };

  // AI 分析（内嵌，不跳转）
  const handleAnalyze = async (deal: DealData) => {
    if (analyzingId === deal.id) return;
    setAnalyzingId(deal.id);
    setAiError(prev => ({ ...prev, [deal.id]: '' }));

    try {
      const apiBase = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const res = await fetch(`${apiBase}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address: deal.address }),
      });

      if (!res.ok) throw new Error(`API error: ${res.status}`);
      const data = await res.json();
      setAiReport(prev => ({ ...prev, [deal.id]: data.analysis || data.report || '分析完成' }));
    } catch (error: any) {
      setAiError(prev => ({ ...prev, [deal.id]: error.message || '分析失败' }));
    } finally {
      setAnalyzingId(null);
    }
  };

  // 简单 markdown 渲染
  const renderMarkdown = (text: string) => {
    return text
      .split('\n')
      .filter(line => line.trim())
      .map((line, i) => {
        if (line.startsWith('## ')) return <h4 key={i} className="text-sm font-bold mt-3 mb-1 text-gray-900">{line.replace('## ', '')}</h4>;
        if (line.startsWith('**') && line.endsWith('**')) return <p key={i} className="font-bold text-gray-800 text-xs mt-1">{line.replace(/\*\*/g, '')}</p>;
        const formatted = line.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        return <p key={i} className="text-gray-600 text-xs leading-relaxed" dangerouslySetInnerHTML={{ __html: formatted }} />;
      });
  };

  // 截断地址（手机端用短地址）
  const shortAddress = (addr: string) => {
    if (addr.length <= 25) return addr;
    // 取街道号 + 街道名
    const parts = addr.split(',');
    return parts[0].length > 25 ? parts[0].substring(0, 22) + '...' : parts[0];
  };

  if (loading) {
    return (
      <section className="py-10 md:py-20 bg-gradient-to-br from-gray-50 to-gray-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-4">今日捡漏</h2>
          <p className="text-sm md:text-lg text-gray-600 mb-6">低于市场中位价的成交记录</p>
          {/* Mobile: horizontal scroll skeleton */}
          <div className="flex md:hidden gap-4 overflow-x-auto pb-4">
            {[1, 2, 3].map((i) => (
              <div key={i} className="flex-shrink-0 w-[280px] bg-white rounded-xl shadow p-4 animate-pulse">
                <div className="h-5 bg-gray-200 rounded mb-3"></div>
                <div className="h-4 bg-gray-200 rounded mb-4 w-2/3"></div>
                <div className="h-16 bg-gray-200 rounded mb-3"></div>
                <div className="h-8 bg-gray-200 rounded"></div>
              </div>
            ))}
          </div>
          {/* Desktop skeleton */}
          <div className="hidden md:grid grid-cols-2 lg:grid-cols-3 gap-8">
            {[1, 2, 3].map((i) => (
              <div key={i} className="bg-white rounded-xl shadow-lg p-6 animate-pulse">
                <div className="h-6 bg-gray-200 rounded mb-4"></div>
                <div className="h-4 bg-gray-200 rounded mb-6"></div>
                <div className="space-y-3 mb-6">
                  {[1, 2, 3].map((j) => (
                    <div key={j} className="h-4 bg-gray-200 rounded"></div>
                  ))}
                </div>
                <div className="h-10 bg-gray-200 rounded"></div>
              </div>
            ))}
          </div>
        </div>
      </section>
    );
  }

  return (
    <section className="py-10 md:py-20 bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex justify-between items-center mb-6 md:mb-12">
          <div>
            <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-1 md:mb-4">
              今日捡漏
            </h2>
            <p className="text-sm md:text-lg text-gray-600">
              低于市场中位价的成交记录
            </p>
          </div>
          <button
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 md:px-6 md:py-3 rounded-lg text-sm md:text-base font-medium transition-colors whitespace-nowrap"
            onClick={() => router.push('/sales')}
          >
            查看全部
          </button>
        </div>

        {/* ===== 手机端：横向滑动卡片 ===== */}
        <div className="md:hidden">
          <div
            ref={scrollRef}
            className="flex gap-3 overflow-x-auto pb-4 snap-x snap-mandatory scrollbar-hide"
            style={{ WebkitOverflowScrolling: 'touch', scrollbarWidth: 'none', msOverflowStyle: 'none' }}
          >
            {deals.slice(0, 6).map((deal) => {
              const category = getCategory(deal);
              const isAnalyzing = analyzingId === deal.id;
              const report = aiReport[deal.id];
              const error = aiError[deal.id];

              return (
                <div
                  key={deal.id}
                  className="flex-shrink-0 w-[280px] snap-start bg-white rounded-xl shadow-md border border-gray-100 overflow-hidden"
                >
                  <div className="p-4">
                    {/* 标签 + 折扣 */}
                    <div className="flex items-center justify-between mb-2">
                      <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${category.style}`}>
                        {category.label}
                      </span>
                      <span className="text-lg font-bold text-red-600">-{deal.discount_percent}%</span>
                    </div>

                    {/* 地址 */}
                    <h3 className="font-bold text-sm text-gray-900 mb-1 leading-snug">
                      {shortAddress(deal.address)}
                    </h3>
                    <p
                      className="text-xs text-blue-600 mb-3 font-medium"
                      onClick={() => router.push(`/suburb/${encodeURIComponent(deal.suburb)}`)}
                    >
                      {deal.suburb} →
                    </p>

                    {/* 价格对比 */}
                    <div className="bg-gray-50 rounded-lg p-2.5 mb-3">
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-[11px] text-gray-500">成交价</span>
                        <span className="font-bold text-green-600 text-sm">{formatPrice(deal.sold_price)}</span>
                      </div>
                      <div className="flex justify-between items-center">
                        <span className="text-[11px] text-gray-500">中位价</span>
                        <span className="text-xs text-gray-500 line-through">{formatPrice(deal.median_price)}</span>
                      </div>
                    </div>

                    {/* 标签行 */}
                    <div className="flex flex-wrap gap-1 mb-3">
                      <span className="bg-gray-100 text-gray-600 px-1.5 py-0.5 rounded text-[10px]">
                        {propertyTypeMap[deal.property_type] || deal.property_type}
                      </span>
                      {deal.bedrooms > 0 && (
                        <span className="bg-gray-100 text-gray-600 px-1.5 py-0.5 rounded text-[10px]">
                          {deal.bedrooms}卧{deal.bathrooms > 0 ? `${deal.bathrooms}卫` : ''}
                        </span>
                      )}
                      {deal.land_size > 0 && (
                        <span className="bg-gray-100 text-gray-600 px-1.5 py-0.5 rounded text-[10px]">
                          {deal.land_size}m²
                        </span>
                      )}
                    </div>

                    {/* 按钮 */}
                    <div className="flex gap-2">
                      <button
                        className="flex-1 bg-blue-600 text-white py-2 rounded-lg text-xs font-medium disabled:opacity-50 flex items-center justify-center gap-1"
                        onClick={() => handleAnalyze(deal)}
                        disabled={isAnalyzing}
                      >
                        {isAnalyzing ? '分析中...' : '🤖 AI分析'}
                      </button>
                      <button
                        className="bg-gray-100 text-gray-700 py-2 px-3 rounded-lg text-xs font-medium"
                        onClick={() => router.push(`/suburb/${encodeURIComponent(deal.suburb)}`)}
                      >
                        查看
                      </button>
                    </div>

                    {/* AI 结果 */}
                    {(report || error) && (
                      <div className={`rounded-lg p-3 mt-2 ${error ? 'bg-red-50' : 'bg-blue-50'}`}>
                        <div className="flex justify-between items-center mb-1">
                          <span className="text-[10px] font-bold text-gray-600">🤖 AI分析</span>
                          <button
                            onClick={() => {
                              setAiReport(prev => { const n = { ...prev }; delete n[deal.id]; return n; });
                              setAiError(prev => { const n = { ...prev }; delete n[deal.id]; return n; });
                            }}
                            className="text-gray-400 text-[10px]"
                          >✕</button>
                        </div>
                        {error ? (
                          <p className="text-red-600 text-[10px]">失败：{error}</p>
                        ) : (
                          <div className="max-h-32 overflow-y-auto">
                            {renderMarkdown(report)}
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
          {/* 滑动提示 */}
          <p className="text-center text-xs text-gray-400 mt-2">← 左右滑动查看更多 →</p>
        </div>

        {/* ===== 桌面端：网格布局 ===== */}
        <div className="hidden md:grid grid-cols-2 lg:grid-cols-3 gap-8">
          {deals.map((deal) => {
            const category = getCategory(deal);
            const isAnalyzing = analyzingId === deal.id;
            const report = aiReport[deal.id];
            const error = aiError[deal.id];

            return (
              <div key={deal.id} className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow overflow-hidden border border-gray-200">
                <div className="p-6">
                  {/* 头部：地址 + 分类标签 */}
                  <div className="flex justify-between items-start mb-3">
                    <div className="flex-1 pr-3">
                      <h3 className="font-bold text-lg text-gray-900 mb-1 leading-tight">{deal.address}</h3>
                      <p
                        className="text-sm text-blue-600 hover:text-blue-800 cursor-pointer font-medium"
                        onClick={() => router.push(`/suburb/${encodeURIComponent(deal.suburb)}`)}
                      >
                        {deal.suburb} →
                      </p>
                    </div>
                    <div className={`px-3 py-1 rounded-full text-xs font-medium whitespace-nowrap ${category.style}`}>
                      {category.label}
                    </div>
                  </div>

                  {/* 折扣高亮 */}
                  <div className="bg-red-50 border border-red-100 rounded-lg p-3 mb-4">
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-red-700 font-medium">低于中位价</span>
                      <span className="text-2xl font-bold text-red-600">{deal.discount_percent}%</span>
                    </div>
                    <div className="mt-1 bg-red-100 rounded-full h-2 overflow-hidden">
                      <div
                        className="h-full bg-red-500 rounded-full transition-all"
                        style={{ width: `${Math.min(deal.discount_percent, 100)}%` }}
                      ></div>
                    </div>
                  </div>

                  {/* 数据详情 */}
                  <div className="space-y-2 mb-4">
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-gray-500">成交价</span>
                      <span className="font-bold text-green-600 text-lg">{formatPriceFull(deal.sold_price)}</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-gray-500">同类中位价</span>
                      <span className="font-semibold text-gray-700">{formatPriceFull(deal.median_price)}</span>
                    </div>
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-gray-500">成交日期</span>
                      <span className="text-sm text-gray-700">{formatDate(deal.sold_date)}</span>
                    </div>
                    <div className="border-t border-gray-100 pt-2 flex flex-wrap gap-2">
                      <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                        {propertyTypeMap[deal.property_type] || deal.property_type}
                      </span>
                      {deal.bedrooms > 0 && (
                        <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                          {deal.bedrooms} 卧
                        </span>
                      )}
                      {deal.bathrooms > 0 && (
                        <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                          {deal.bathrooms} 卫
                        </span>
                      )}
                      {deal.land_size > 0 && (
                        <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                          {deal.land_size} m²
                        </span>
                      )}
                    </div>
                  </div>

                  {/* 操作按钮 */}
                  <div className="flex gap-3 mb-3">
                    <button
                      className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-medium transition-colors flex items-center justify-center gap-2 disabled:opacity-50"
                      onClick={() => handleAnalyze(deal)}
                      disabled={isAnalyzing}
                    >
                      {isAnalyzing ? (
                        <>
                          <svg className="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
                            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                          </svg>
                          分析中...
                        </>
                      ) : '🤖 AI 分析'}
                    </button>
                    <button
                      className="bg-gray-100 hover:bg-gray-200 text-gray-800 py-3 px-5 rounded-lg font-medium transition-colors"
                      onClick={() => router.push(`/suburb/${encodeURIComponent(deal.suburb)}`)}
                    >
                      查看区域
                    </button>
                  </div>

                  {/* AI 分析结果（内嵌显示） */}
                  {(report || error) && (
                    <div className={`rounded-lg p-4 mt-2 ${error ? 'bg-red-50 border border-red-100' : 'bg-blue-50 border border-blue-100'}`}>
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-xs font-bold text-gray-700">🤖 AI 投资分析</span>
                        <button
                          onClick={() => {
                            setAiReport(prev => { const n = { ...prev }; delete n[deal.id]; return n; });
                            setAiError(prev => { const n = { ...prev }; delete n[deal.id]; return n; });
                          }}
                          className="text-gray-400 hover:text-gray-600 text-xs"
                        >
                          ✕ 关闭
                        </button>
                      </div>
                      {error ? (
                        <p className="text-red-600 text-xs">分析失败：{error}</p>
                      ) : (
                        <div className="max-h-48 overflow-y-auto">
                          {renderMarkdown(report)}
                        </div>
                      )}
                    </div>
                  )}

                  {/* 数据来源 */}
                  <div className="text-xs text-gray-400 mt-3">
                    来源: Compass 成交数据分析
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
