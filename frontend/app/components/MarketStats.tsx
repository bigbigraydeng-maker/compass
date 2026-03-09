'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { fetcher } from '../lib/api';

interface SaleItem {
  id: string;
  address: string;
  suburb: string;
  property_type: string;
  bedrooms: number;
  bathrooms: number;
  land_size: number;
  sold_price: number;
  sold_date: string;
}

interface NewsItem {
  title: string;
  source: string;
  date: string;
  summary: string;
  tag: string;
  tagColor: string;
}

export default function MarketStats() {
  const router = useRouter();
  const [recentSales, setRecentSales] = useState<SaleItem[]>([]);
  const [newsItems, setNewsItems] = useState<NewsItem[]>([]);
  const [amandaCommentary, setAmandaCommentary] = useState('');
  const [commentaryDate, setCommentaryDate] = useState('');
  const [activeTab, setActiveTab] = useState<'news' | 'sold'>('news');

  useEffect(() => {
    let cancelled = false;

    const loadData = async () => {
      try {
        const [homeData, newsData] = await Promise.all([
          fetcher('/api/home').catch(() => null),
          fetcher('/api/news').catch(() => null),
        ]);

        if (cancelled) return;

        if (homeData?.latest_sales) {
          setRecentSales(homeData.latest_sales.slice(0, 8));
        }

        if (newsData?.news && newsData.news.length > 0) {
          setNewsItems(newsData.news);
        }

        if (newsData?.amanda_commentary) {
          setAmandaCommentary(newsData.amanda_commentary);
          setCommentaryDate(newsData.commentary_date || '');
        }
      } catch (e) {
        console.error('Failed to load market data:', e);
      }
    };

    loadData();
    return () => { cancelled = true; };
  }, []);

  const formatPrice = (price: number) => {
    if (!price) return '-';
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  const formatPriceShort = (price: number) => {
    if (!price) return '-';
    if (price >= 1000000) return `$${(price / 1000000).toFixed(1)}M`;
    if (price >= 1000) return `$${(price / 1000).toFixed(0)}K`;
    return `$${price}`;
  };

  const propertyTypeMap: Record<string, string> = {
    'house': '别墅', 'unit': '公寓', 'townhouse': '联排',
    'apartment': '公寓', 'vacant_land': '空地', 'other': '其他',
  };

  return (
    <section className="py-10 md:py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* 标题 + Tab 切换 */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 md:mb-10">
          <div>
            <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-1 md:mb-2">
              市场动态
            </h2>
            <p className="text-sm md:text-base text-gray-600">
              Amanda 每日解读 · 近期成交
            </p>
          </div>
          <div className="flex bg-gray-100 rounded-lg p-1 mt-3 md:mt-0">
            <button
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                activeTab === 'news' ? 'bg-white shadow text-blue-600' : 'text-gray-600'
              }`}
              onClick={() => setActiveTab('news')}
            >
              📰 今日解读
            </button>
            <button
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                activeTab === 'sold' ? 'bg-white shadow text-blue-600' : 'text-gray-600'
              }`}
              onClick={() => setActiveTab('sold')}
            >
              🏠 近期成交
            </button>
          </div>
        </div>

        {/* ===== 新闻 Tab ===== */}
        {activeTab === 'news' && (
          <div>
            {/* Amanda 每日综合解读 */}
            {amandaCommentary ? (
              <div className="mb-6 bg-gradient-to-br from-indigo-50 via-white to-purple-50 rounded-xl border border-indigo-100 p-5 md:p-8">
                <div className="flex items-start gap-3 md:gap-5">
                  {/* Amanda 头像 */}
                  <div className="flex-shrink-0">
                    <div className="w-14 h-14 md:w-16 md:h-16 rounded-full bg-gradient-to-br from-indigo-400 to-purple-500 flex items-center justify-center text-white font-bold text-xl md:text-2xl shadow-lg">
                      A
                    </div>
                  </div>
                  {/* 点评内容 */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="font-bold text-gray-900 text-base md:text-lg">Amanda</span>
                      <span className="text-[10px] md:text-xs bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full font-medium">Compass 首席分析师</span>
                      <span className="text-[10px] md:text-xs text-gray-400 ml-auto">{commentaryDate}</span>
                    </div>
                    <div className="text-gray-700 text-sm md:text-[15px] leading-relaxed whitespace-pre-line">
                      {amandaCommentary}
                    </div>
                  </div>
                </div>
              </div>
            ) : (
              <div className="mb-6 bg-gray-50 rounded-xl border border-gray-100 p-6 text-center">
                <div className="flex items-center justify-center gap-2 text-gray-400">
                  <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
                  <span className="text-sm">Amanda 正在阅读今日新闻，稍后为您解读...</span>
                </div>
              </div>
            )}

            {/* 今日新闻来源列表 */}
            {newsItems.length > 0 && (
              <div>
                <h3 className="text-sm font-semibold text-gray-500 mb-3 uppercase tracking-wide">今日新闻来源</h3>
                {/* 手机端 */}
                <div className="md:hidden space-y-2">
                  {newsItems.slice(0, 6).map((news, idx) => (
                    <div key={idx} className="bg-gray-50 rounded-lg p-3 border border-gray-100">
                      <div className="flex items-center gap-2 mb-1">
                        <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${news.tagColor}`}>
                          {news.tag}
                        </span>
                        <span className="text-[10px] text-gray-400">{news.source} · {news.date}</span>
                      </div>
                      <p className="text-sm text-gray-800 leading-snug">{news.title}</p>
                    </div>
                  ))}
                </div>
                {/* 桌面端：紧凑两列 */}
                <div className="hidden md:grid grid-cols-2 gap-3">
                  {newsItems.slice(0, 8).map((news, idx) => (
                    <div key={idx} className="bg-gray-50 rounded-lg p-4 border border-gray-100">
                      <div className="flex items-center gap-2 mb-1.5">
                        <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${news.tagColor}`}>
                          {news.tag}
                        </span>
                        <span className="text-xs text-gray-400">{news.source} · {news.date}</span>
                      </div>
                      <p className="text-sm text-gray-800 leading-snug line-clamp-2">{news.title}</p>
                    </div>
                  ))}
                </div>
                <p className="text-center text-xs text-gray-400 mt-4">
                  以上新闻由 Google News 自动聚合 · Amanda 基于新闻内容生成综合解读
                </p>
              </div>
            )}
          </div>
        )}

        {/* ===== 近期成交 Tab ===== */}
        {activeTab === 'sold' && (
          <div>
            {/* 手机端：紧凑列表 */}
            <div className="md:hidden space-y-2">
              {recentSales.map((sale) => (
                <div
                  key={sale.id}
                  className="bg-gray-50 rounded-lg p-3 flex justify-between items-center border border-gray-100"
                  onClick={() => router.push(`/suburb/${encodeURIComponent(sale.suburb)}`)}
                >
                  <div className="flex-1 min-w-0 pr-3">
                    <p className="font-medium text-sm text-gray-900 truncate">{sale.address}</p>
                    <div className="flex items-center gap-2 mt-0.5">
                      <span className="text-[10px] text-gray-500">{sale.suburb}</span>
                      <span className="text-[10px] text-gray-400">
                        {propertyTypeMap[sale.property_type] || sale.property_type}
                        {sale.bedrooms > 0 ? ` · ${sale.bedrooms}卧` : ''}
                      </span>
                    </div>
                  </div>
                  <div className="text-right flex-shrink-0">
                    <p className="font-bold text-green-600 text-sm">{formatPriceShort(sale.sold_price)}</p>
                    <p className="text-[10px] text-gray-400">{sale.sold_date}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* 桌面端：表格样式 */}
            <div className="hidden md:block bg-white rounded-xl border border-gray-200 overflow-hidden">
              <table className="w-full">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="text-left py-3 px-4 text-sm font-medium text-gray-600">地址</th>
                    <th className="text-left py-3 px-4 text-sm font-medium text-gray-600">郊区</th>
                    <th className="text-left py-3 px-4 text-sm font-medium text-gray-600">类型</th>
                    <th className="text-left py-3 px-4 text-sm font-medium text-gray-600">房型</th>
                    <th className="text-right py-3 px-4 text-sm font-medium text-gray-600">成交价</th>
                    <th className="text-right py-3 px-4 text-sm font-medium text-gray-600">日期</th>
                  </tr>
                </thead>
                <tbody>
                  {recentSales.map((sale, i) => (
                    <tr
                      key={sale.id}
                      className={`hover:bg-blue-50 cursor-pointer transition-colors ${i % 2 === 0 ? '' : 'bg-gray-50/50'}`}
                      onClick={() => router.push(`/suburb/${encodeURIComponent(sale.suburb)}`)}
                    >
                      <td className="py-3 px-4 text-sm text-gray-900 font-medium">{sale.address}</td>
                      <td className="py-3 px-4 text-sm text-blue-600">{sale.suburb}</td>
                      <td className="py-3 px-4 text-sm text-gray-600">
                        {propertyTypeMap[sale.property_type] || sale.property_type}
                      </td>
                      <td className="py-3 px-4 text-sm text-gray-600">
                        {sale.bedrooms > 0 ? `${sale.bedrooms}卧${sale.bathrooms > 0 ? `${sale.bathrooms}卫` : ''}` : '-'}
                      </td>
                      <td className="py-3 px-4 text-sm text-green-600 font-bold text-right">{formatPrice(sale.sold_price)}</td>
                      <td className="py-3 px-4 text-sm text-gray-500 text-right">{sale.sold_date}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="text-center mt-6">
              <button
                className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2.5 rounded-lg text-sm font-medium transition-colors"
                onClick={() => router.push('/sales')}
              >
                查看全部成交记录
              </button>
            </div>
          </div>
        )}
      </div>
    </section>
  );
}
