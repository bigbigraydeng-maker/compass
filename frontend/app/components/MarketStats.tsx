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
  link?: string;
}

// 备用新闻（API 不可用时显示）
const fallbackNews: NewsItem[] = [
  {
    title: 'Brisbane property market continues steady growth in 2026',
    source: 'Domain',
    date: new Date().toISOString().slice(0, 10),
    summary: 'Brisbane southern suburbs remain popular among Chinese-Australian investors with strong demand across Sunnybank, Calamvale and surrounding areas.',
    tag: '市场动态',
    tagColor: 'bg-blue-100 text-blue-700',
  },
];

export default function MarketStats() {
  const router = useRouter();
  const [recentSales, setRecentSales] = useState<SaleItem[]>([]);
  const [newsItems, setNewsItems] = useState<NewsItem[]>([]);
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
        } else {
          setNewsItems(fallbackNews);
        }
      } catch (e) {
        console.error('Failed to load market data:', e);
        setNewsItems(fallbackNews);
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
              布里斯班房产新闻 · 近期成交
            </p>
          </div>
          <div className="flex bg-gray-100 rounded-lg p-1 mt-3 md:mt-0">
            <button
              className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                activeTab === 'news' ? 'bg-white shadow text-blue-600' : 'text-gray-600'
              }`}
              onClick={() => setActiveTab('news')}
            >
              📰 新闻资讯
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
        {activeTab === 'news' && newsItems.length > 0 && (
          <div>
            {/* 手机端：卡片列表 */}
            <div className="md:hidden space-y-3">
              {newsItems.slice(0, 4).map((news, idx) => (
                <a
                  key={idx}
                  href={news.link || '#'}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="block bg-gray-50 rounded-xl p-4 border border-gray-100 hover:shadow-md transition-shadow"
                >
                  <div className="flex items-center gap-2 mb-2">
                    <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${news.tagColor}`}>
                      {news.tag}
                    </span>
                    <span className="text-[10px] text-gray-400">{news.source} · {news.date}</span>
                  </div>
                  <h3 className="font-bold text-sm text-gray-900 mb-1 leading-snug line-clamp-2">{news.title}</h3>
                  <p className="text-xs text-gray-500 line-clamp-2">{news.summary}</p>
                </a>
              ))}
            </div>

            {/* 桌面端：左大右小布局 */}
            <div className="hidden md:grid grid-cols-2 gap-6">
              {/* 头条新闻 */}
              <a
                href={newsItems[0].link || '#'}
                target="_blank"
                rel="noopener noreferrer"
                className="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-8 border border-blue-200 flex flex-col justify-between hover:shadow-lg transition-shadow"
              >
                <div>
                  <div className="flex items-center gap-2 mb-4">
                    <span className={`px-3 py-1 rounded-full text-xs font-medium ${newsItems[0].tagColor}`}>
                      {newsItems[0].tag}
                    </span>
                    <span className="text-xs text-gray-500">{newsItems[0].source} · {newsItems[0].date}</span>
                  </div>
                  <h3 className="text-xl font-bold text-gray-900 mb-3 leading-tight">{newsItems[0].title}</h3>
                  <p className="text-gray-600 text-sm leading-relaxed line-clamp-4">{newsItems[0].summary}</p>
                </div>
                <p className="text-xs text-gray-400 mt-6">来源: {newsItems[0].source}</p>
              </a>

              {/* 其他新闻列表 */}
              <div className="space-y-4">
                {newsItems.slice(1, 4).map((news, idx) => (
                  <a
                    key={idx}
                    href={news.link || '#'}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="block bg-gray-50 rounded-xl p-5 border border-gray-100 hover:shadow-md transition-shadow"
                  >
                    <div className="flex items-center gap-2 mb-2">
                      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${news.tagColor}`}>
                        {news.tag}
                      </span>
                      <span className="text-xs text-gray-400">{news.source} · {news.date}</span>
                    </div>
                    <h3 className="font-bold text-gray-900 mb-1 line-clamp-2">{news.title}</h3>
                    <p className="text-sm text-gray-500 line-clamp-2">{news.summary}</p>
                  </a>
                ))}
              </div>
            </div>

            <p className="text-center text-xs text-gray-400 mt-6">
              新闻来源: Google News 聚合 (Domain / REA / ABC) | 每小时自动更新
            </p>
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
