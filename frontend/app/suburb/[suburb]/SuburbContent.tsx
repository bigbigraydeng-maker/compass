'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from 'recharts';

interface Sale {
  id: number;
  address: string;
  property_type: string;
  bedrooms: number;
  bathrooms: number;
  land_size: number;
  sold_price: number;
  sold_date: string;
}

interface MonthlyTrend {
  month: string;
  median_price: number;
  total_sales: number;
}

interface SuburbData {
  suburb: string;
  median_price: number;
  total_sales: number;
  recent_sales: Sale[];
}

function formatPrice(price: number) {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0,
  }).format(price);
}

function formatPriceShort(price: number) {
  return `$${(price / 1000000).toFixed(1)}M`;
}

function formatMonth(monthStr: string) {
  const [year, month] = monthStr.split('-');
  return `${year.slice(2)}年${parseInt(month)}月`;
}

function CustomTooltip({ active, payload, label }: any) {
  if (active && payload && payload.length) {
    const data = payload[0].payload;
    return (
      <div className="bg-white p-3 border rounded-lg shadow-lg">
        <p className="font-semibold text-gray-800">{formatMonth(label)}</p>
        <p className="text-blue-600">
          中位价: {formatPrice(data.median_price)}
        </p>
        <p className="text-gray-600">成交: {data.total_sales} 套</p>
      </div>
    );
  }
  return null;
}

export default function SuburbContent({ suburbName }: { suburbName: string }) {
  const [data, setData] = useState<SuburbData | null>(null);
  const [trends, setTrends] = useState<MonthlyTrend[]>([]);
  const [schools, setSchools] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      
      try {
        // 获取郊区详情
        const detailRes = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}`);
        if (!detailRes.ok) {
          setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
        } else {
          const detailData = await detailRes.json();
          // 获取最近成交记录
          const salesRes = await fetch(`${apiUrl}/api/sales?suburb=${encodeURIComponent(suburbName)}&page_size=10`);
          if (salesRes.ok) {
            const salesData = await salesRes.json();
            detailData.recent_sales = salesData.sales || [];
          } else {
            detailData.recent_sales = [];
          }
          setData(detailData);
        }

        // 获取价格走势
        const trendsRes = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}/trends`);
        if (!trendsRes.ok) {
          setTrends([]);
        } else {
          const trendsData = await trendsRes.json();
          setTrends(trendsData.monthly_trends || []);
        }

        // 获取学校数据
        const schoolsRes = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}/schools`);
        if (!schoolsRes.ok) {
          setSchools([]);
        } else {
          const schoolsData = await schoolsRes.json();
          setSchools(schoolsData.schools || []);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
        setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
        setTrends([]);
        setSchools([]);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [suburbName]);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">加载中...</p>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <p className="text-gray-600">未找到数据</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Compass
            </Link>
            <div className="flex space-x-6">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition">首页</Link>
              <Link href="/sales" className="text-gray-600 hover:text-blue-600 transition">成交列表</Link>
              <Link href="/suburb/Sunnybank" className="text-gray-600 hover:text-blue-600 transition">Sunnybank</Link>
              <Link href="/suburb/Eight Mile Plains" className="text-gray-600 hover:text-blue-600 transition">Eight Mile Plains</Link>
              <Link href="/suburb/Calamvale" className="text-gray-600 hover:text-blue-600 transition">Calamvale</Link>
              <Link href="/suburb/Rochedale" className="text-gray-600 hover:text-blue-600 transition">Rochedale</Link>
              <Link href="/suburb/Mansfield" className="text-gray-600 hover:text-blue-600 transition">Mansfield</Link>
              <Link href="/suburb/Ascot" className="text-gray-600 hover:text-blue-600 transition">Ascot</Link>
              <Link href="/suburb/Hamilton" className="text-gray-600 hover:text-blue-600 transition">Hamilton</Link>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <Link href="/" className="text-blue-600 hover:text-blue-700 font-medium">
            ← 返回首页
          </Link>
        </div>

        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl p-8 mb-8">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">{data.suburb}</h1>
          <p className="text-blue-100">布里斯班华人热门区域</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">中位价</h3>
            <p className="text-4xl font-bold text-blue-600">
              {formatPrice(data.median_price)}
            </p>
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">成交数量</h3>
            <p className="text-4xl font-bold text-blue-600">
              {data.total_sales} 套
            </p>
          </div>
        </div>

        {/* 价格走势图 */}
        {trends.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border mb-8">
            <div className="px-6 py-4 border-b">
              <h2 className="text-lg font-semibold text-gray-800">价格走势（过去12个月）</h2>
            </div>
            <div className="p-6">
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={trends}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
                  <XAxis
                    dataKey="month"
                    tickFormatter={formatMonth}
                    stroke="#6b7280"
                    fontSize={12}
                  />
                  <YAxis
                    domain={[dataMin => Math.floor(dataMin * 0.9 / 100000) * 100000, 'auto']}
                    tickFormatter={(value) => `$${(value / 1000000).toFixed(1)}M`}
                    stroke="#6b7280"
                    fontSize={12}
                  />
                  <Tooltip content={<CustomTooltip />} />
                  <Line
                    type="monotone"
                    dataKey="median_price"
                    stroke="#2563eb"
                    strokeWidth={2}
                    dot={{ fill: '#2563eb', strokeWidth: 2, r: 4 }}
                    activeDot={{ r: 6, fill: '#1d4ed8' }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        )}

        <div className="bg-white rounded-xl shadow-sm border">
          <div className="px-6 py-4 border-b">
            <h2 className="text-lg font-semibold text-gray-800">最近成交</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卧室</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卫浴</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">土地面积</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {data.recent_sales.map((sale: any) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bedrooms}🛏</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bathrooms}🚿</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.land_size > 0 ? `${sale.land_size}㎡` : '-'}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* 学校信息 */}
        {schools.length > 0 && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">🏫 对口学校</h2>
            <div className="space-y-3">
              {['primary', 'combined', 'secondary'].map(type => {
                const typeSchools = schools.filter(s => s.type === type);
                if (typeSchools.length === 0) return null;
                const typeLabel = type === 'primary' ? '小学' : type === 'secondary' ? '中学' : '一贯制';
                return (
                  <div key={type}>
                    <p className="text-sm text-gray-500 mb-2">{typeLabel}</p>
                    {typeSchools.map(school => (
                      <div key={school.name} className="flex justify-between items-center py-2 border-b border-gray-100 last:border-0">
                        <div>
                          <span className="font-medium text-gray-800">{school.name}</span>
                          <span className="ml-2 text-xs text-gray-500">{school.sector === 'public' ? '公立' : '天主教'}</span>
                        </div>
                        {school.naplan_score && (
                          <div className="text-right">
                            <span className="text-blue-600 font-bold text-sm">NAPLAN {school.naplan_score}</span>
                            <p className="text-xs text-gray-500">{school.rating}</p>
                          </div>
                        )}
                        {!school.naplan_score && (
                          <span className="text-xs text-gray-500">{school.rating}</span>
                        )}
                      </div>
                    ))}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        <div className="mt-8">
          <Link
            href={`/sales?suburb=${suburbName}`}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition font-medium inline-block"
          >
            查看更多成交 →
          </Link>
        </div>
      </main>

      <footer className="bg-white border-t mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 text-center text-gray-500 text-sm">
          <p>© 2026 Compass - 布里斯班华人房地产数据平台</p>
        </div>
      </footer>
    </div>
  );
}
