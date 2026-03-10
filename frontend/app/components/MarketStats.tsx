'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { fetcher } from '../lib/api';
import { PersonaAvatar } from './persona';

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

interface MarketStatsProps {
  homeData?: any; // 从父组件传入，避免重复调用 /api/home
}

export default function MarketStats({ homeData: parentHomeData }: MarketStatsProps) {
  const router = useRouter();
  const [recentSales, setRecentSales] = useState<SaleItem[]>([]);
  const [oliviaCommentary, setOliviaCommentary] = useState('');
  const [commentaryDate, setCommentaryDate] = useState('');
  const [activeTab, setActiveTab] = useState<'news' | 'sold'>('news');

  // 父组件传入 homeData 时直接使用，不重复请求
  useEffect(() => {
    if (parentHomeData?.latest_sales) {
      setRecentSales(parentHomeData.latest_sales.slice(0, 8));
    }
  }, [parentHomeData]);

  useEffect(() => {
    let cancelled = false;
    let retryTimer: ReturnType<typeof setTimeout>;

    const loadNews = async (): Promise<any> => {
      return fetcher('/api/news').catch(() => null);
    };

    const loadData = async () => {
      try {
        // 仅在父组件未提供 homeData 时才请求
        const [homeRes, newsData] = await Promise.all([
          parentHomeData ? Promise.resolve(null) : fetcher('/api/home').catch(() => null),
          loadNews(),
        ]);

        if (cancelled) return;

        if (homeRes?.latest_sales) {
          setRecentSales(homeRes.latest_sales.slice(0, 8));
        }

        if (newsData?.olivia_commentary) {
          setOliviaCommentary(newsData.olivia_commentary);
          setCommentaryDate(newsData.commentary_date || '');
        } else if (newsData?.news && newsData.news.length > 0) {
          retryTimer = setTimeout(async () => {
            if (cancelled) return;
            const retry = await loadNews();
            if (retry?.olivia_commentary && !cancelled) {
              setOliviaCommentary(retry.olivia_commentary);
              setCommentaryDate(retry.commentary_date || '');
            }
          }, 8000);
        }
      } catch (e) {
        console.error('Failed to load market data:', e);
      }
    };

    loadData();
    return () => { cancelled = true; clearTimeout(retryTimer); };
  }, [parentHomeData]);

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
              Olivia 每日解读 · 近期成交
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
            {/* Olivia 每日综合解读 */}
            {oliviaCommentary ? (
              <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5 md:p-8">
                <div className="flex items-start gap-3 md:gap-5">
                  <div className="flex-shrink-0">
                    <PersonaAvatar persona="olivia" size="lg" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-3">
                      <span className="font-bold text-gray-900 text-base md:text-lg">Olivia</span>
                      <span className="text-[10px] md:text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-medium">Compass 市场经济学家</span>
                      <span className="text-[10px] md:text-xs text-gray-400 ml-auto">{commentaryDate}</span>
                    </div>
                    <div className="text-gray-700 text-sm md:text-[15px] leading-relaxed whitespace-pre-line">
                      {oliviaCommentary}
                    </div>
                  </div>
                </div>
              </div>
            ) : (
              <div className="bg-gray-50 rounded-xl border border-gray-100 p-6 text-center">
                <div className="flex items-center justify-center gap-2 text-gray-400">
                  <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
                  <span className="text-sm">Olivia 正在阅读今日新闻，稍后为您解读...</span>
                </div>
              </div>
            )}

            {/* 查看全部新闻链接 */}
            <div className="text-center mt-5">
              <Link
                href="/news"
                className="inline-flex items-center gap-1.5 bg-purple-600 hover:bg-purple-700 text-white px-5 py-2 rounded-lg text-sm font-medium transition-colors"
              >
                查看全部新闻与翻译 →
              </Link>
            </div>
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
