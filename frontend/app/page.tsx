'use client';
import Link from 'next/link';
import Navbar from './components/Navbar';
import { useState, useEffect } from 'react';

const API_BASE = 'https://compass-r58x.onrender.com';

function formatPrice(price: number) {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

export default function Home() {
  const [rankings, setRankings] = useState<any[]>([]);
  const [deals, setDeals] = useState<any[]>([]);
  const [totalDeals, setTotalDeals] = useState(0);
  const [pulse, setPulse] = useState<any>(null);
  const [recentSales, setRecentSales] = useState<any[]>([]);
  const [poi, setPoi] = useState<any>({
    suburb: "Sunnybank",
    category_counts: {},
    total_poi: 0
  });
  const [suburbs, setSuburbs] = useState<any[]>([]);

  useEffect(() => {
    // 获取排名数据
    fetch(`${API_BASE}/api/rankings`)
      .then(r => r.json())
      .then(d => setRankings(d.rankings || []));
    
    // 获取捡漏数据
    fetch(`${API_BASE}/api/deals`)
      .then(r => r.json())
      .then(d => {
        setDeals(d.deals || []);
        setTotalDeals(d.total || 0);
      });
    
    // 获取市场快报数据
    fetch(`${API_BASE}/api/market-pulse`)
      .then(r => r.json())
      .then(d => setPulse(d));
    
    // 获取最新成交数据
    fetch(`${API_BASE}/api/sales?page_size=10`)
      .then(r => r.json())
      .then(d => setRecentSales(d.sales || []));
    
    // 获取POI数据
    fetch(`${API_BASE}/api/suburb/Sunnybank/poi`)
      .then(r => r.json())
      .then(d => setPoi(d));
    
    // 获取郊区数据
    fetch(`${API_BASE}/api/home`)
      .then(r => r.json())
      .then(d => setSuburbs(d.suburb_stats || []));
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 导航栏 */}
      <Navbar activePage="home" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* 主标题区 */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl p-8 mb-8">
          <h1 className="text-3xl md:text-4xl font-bold mb-4">
            布里斯班华人房地产数据平台
          </h1>
          <p className="text-blue-100 text-lg">
            专注于 Sunnybank、Eight Mile Plains、Calamvale、Rochedale、Mansfield、Ascot、Hamilton 七个区域
          </p>
        </div>

        {/* 市场快报横幅 */}
        <div className="bg-gradient-to-r from-orange-500 to-red-500 text-white rounded-xl p-6 mb-8">
          <h2 className="text-xl font-bold mb-4">本月布里斯班市场快报</h2>
          {pulse ? (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="text-center">
                <p className="text-orange-100 text-sm mb-1">🔥 最热区域</p>
                <p className="text-2xl font-bold">{pulse.hottest_suburb}</p>
              </div>
              <div className="text-center">
                <p className="text-orange-100 text-sm mb-1">📈 本月涨幅最高</p>
                <p className="text-2xl font-bold">{pulse.highest_growth_suburb}</p>
                <p className="text-orange-100 text-sm">+{pulse.highest_growth_rate?.toFixed(1)}%</p>
              </div>
              <div className="text-center">
                <p className="text-orange-100 text-sm mb-1">🏆 性价比最高</p>
                <p className="text-2xl font-bold">{pulse.best_value_suburb}</p>
              </div>
            </div>
          ) : (
            <div className="text-center py-4">
              <p>加载中...</p>
            </div>
          )}
        </div>

        {/* Suburb 统计卡片 */}
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 mb-8">
          {suburbs.map((suburb: any) => (
            <Link
              key={suburb.name}
              href={`/suburb/${encodeURIComponent(suburb.name)}`}
              className="bg-white rounded-xl shadow-sm border hover:shadow-md transition-shadow p-6"
            >
              <h3 className="text-lg font-semibold text-gray-800 mb-4">{suburb.name}</h3>
              <div className="space-y-2">
                <div>
                  <p className="text-sm text-gray-500">中位价</p>
                  <p className="text-2xl font-bold text-blue-600">{formatPrice(suburb.median_price)}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">成交数量</p>
                  <p className="text-lg font-semibold text-gray-800">{suburb.total_sales} 套</p>
                </div>
              </div>
              <div className="mt-4 text-blue-600 text-sm font-medium">
                查看详情 →
              </div>
            </Link>
          ))}
        </div>

        {/* Compass Score 总榜 */}
        <div className="bg-white rounded-xl shadow-sm border mb-8">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <div className="flex items-center gap-2">
              <span className="text-blue-500 text-xl">🏆</span>
              <h2 className="text-lg font-semibold text-gray-800">布里斯班华人购房区域综合排名</h2>
            </div>
          </div>
          <div className="p-6">
            {rankings.length > 0 ? (
              <div className="space-y-4">
                {rankings.map((ranking: any) => (
                  <div key={ranking.suburb} className="border-b pb-4 last:border-b-0 last:pb-0">
                    <div className="flex items-center gap-4">
                      <div className="text-2xl font-bold text-gray-800 w-8 text-center">
                        #{ranking.rank}
                      </div>
                      <div className="flex-1">
                        <div className="flex justify-between items-center mb-1">
                          <h3 className="font-semibold text-gray-800">{ranking.suburb}</h3>
                          <div className="flex items-center gap-2">
                            <span className="text-2xl font-bold text-blue-600">{ranking.total_score}</span>
                            <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                              ranking.grade === 'S' ? 'bg-yellow-100 text-yellow-600' :
                              ranking.grade === 'A' ? 'bg-blue-100 text-blue-600' :
                              ranking.grade === 'B' ? 'bg-green-100 text-green-600' :
                              'bg-gray-100 text-gray-600'
                            }`}>
                              {ranking.grade}级
                            </span>
                          </div>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className="bg-blue-600 h-2 rounded-full" 
                            style={{ width: `${(ranking.total_score / 100) * 100}%` }}
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8">
                <p className="text-gray-500">排名数据加载中...</p>
              </div>
            )}
          </div>
        </div>

        {/* 捡漏雷达 */}
        <div className="bg-white rounded-xl shadow-sm border mb-8">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <div className="flex items-center gap-2">
              <span className="text-yellow-500 text-xl">🔍</span>
              <h2 className="text-lg font-semibold text-gray-800">近期捡漏信号</h2>
            </div>
            {totalDeals > 0 && (
              <span className="text-sm text-gray-600">共 {totalDeals} 个机会</span>
            )}
          </div>
          <div className="p-6">
            {deals.length > 0 ? (
              <div className="space-y-4">
                {deals.map((deal: any) => (
                  <div key={deal.id} className="border-b pb-4 last:border-b-0 last:pb-0">
                    <div className="flex flex-col md:flex-row md:justify-between md:items-start gap-4">
                      <div>
                        <h3 className="font-semibold text-gray-800">{deal.suburb} {deal.address}</h3>
                        <p className="text-gray-600 text-sm mt-1">
                          {deal.bedrooms}床 {deal.bathrooms}卫 · {deal.property_type}
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="font-bold text-green-600">{formatPrice(deal.sold_price)}</p>
                        <p className="text-red-500 text-sm font-medium">
                          低于区域中位价 {deal.discount_percent}% ↓
                        </p>
                        <Link 
                          href={`/suburb/${encodeURIComponent(deal.suburb)}`}
                          className="text-blue-600 text-sm hover:underline mt-1 inline-block"
                        >
                          查看详情 →
                        </Link>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8">
                <p className="text-gray-500">暂无捡漏机会</p>
              </div>
            )}
          </div>
        </div>

        {/* 华人生活圈 POI */}
        <div className="bg-white rounded-xl shadow-sm border mb-8">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <div className="flex items-center gap-2">
              <span className="text-red-500 text-xl">🍜</span>
              <h2 className="text-lg font-semibold text-gray-800">华人生活配套</h2>
            </div>
            <div>
              <select className="border border-gray-300 rounded-lg px-3 py-1 text-sm">
                <option value="Sunnybank">Sunnybank</option>
                <option value="Eight Mile Plains">Eight Mile Plains</option>
                <option value="Calamvale">Calamvale</option>
                <option value="Rochedale">Rochedale</option>
                <option value="Mansfield">Mansfield</option>
                <option value="Ascot">Ascot</option>
                <option value="Hamilton">Hamilton</option>
              </select>
            </div>
          </div>
          <div className="p-6">
            <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mb-6">
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">📍 中餐厅</p>
                <p className="text-2xl font-bold text-red-600">
                  {poi.category_counts?.chinese_restaurant || 0}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">🛒 华人超市</p>
                <p className="text-2xl font-bold text-green-600">
                  {poi.category_counts?.asian_grocery || 0}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">🏫 中文学校</p>
                <p className="text-2xl font-bold text-blue-600">
                  {poi.category_counts?.chinese_school || 0}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">🙏 华人教会</p>
                <p className="text-2xl font-bold text-purple-600">
                  {poi.category_counts?.chinese_church || 0}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">🏥 华人诊所</p>
                <p className="text-2xl font-bold text-orange-600">
                  {poi.category_counts?.chinese_clinic || 0}
                </p>
              </div>
              <div className="bg-gray-50 rounded-lg p-4 text-center">
                <p className="text-sm text-gray-600 mb-1">💈 中式理发</p>
                <p className="text-2xl font-bold text-yellow-600">
                  {poi.category_counts?.chinese_hair_salon || 0}
                </p>
              </div>
            </div>
            <div className="bg-gray-100 rounded-lg p-4 text-center">
              <p className="text-gray-600">华人生活圈地图</p>
              <p className="text-sm text-gray-500 mt-2">数据来源于 Google Maps Places API</p>
            </div>
          </div>
        </div>

        {/* 最新成交 */}
        <div className="bg-white rounded-xl shadow-sm border">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <h2 className="text-lg font-semibold text-gray-800">最新成交</h2>
            <Link href="/sales" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              查看全部 →
            </Link>
          </div>
          <div className="overflow-x-auto w-full">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">郊区</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {recentSales.map((sale: any) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.suburb}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="px-6 py-4 text-center text-sm text-gray-500">© 2026 Compass - 布里斯班华人房地产数据平台</p>
        </div>
      </main>
    </div>
  );
}
