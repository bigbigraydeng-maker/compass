'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import Navbar from '../../components/Navbar';
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

interface Zone {
  zone_code: string;
  zone_name: string;
  percentage: number;
}

interface ZoningData {
  suburb: string;
  zones: Zone[];
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
  const [zoning, setZoning] = useState<ZoningData | null>(null);
  const [landListings, setLandListings] = useState<any[]>([]);
  const [score, setScore] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [aiLoading, setAiLoading] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);
  const [aiError, setAiError] = useState<string | null>(null);

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

        // 获取分区数据
        const zoningRes = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}/zoning`);
        if (!zoningRes.ok) {
          setZoning(null);
        } else {
          const zoningData = await zoningRes.json();
          setZoning(zoningData);
        }

        // 获取在售土地数据
        const landRes = await fetch(`${apiUrl}/api/listings?suburb=${encodeURIComponent(suburbName)}&property_type=vacant_land&page_size=20`);
        if (!landRes.ok) {
          setLandListings([]);
        } else {
          const landData = await landRes.json();
          setLandListings(landData.listings || []);
        }

        // 获取 Compass Score 数据
        const scoreRes = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}/score`);
        if (!scoreRes.ok) {
          setScore(null);
        } else {
          const scoreData = await scoreRes.json();
          setScore(scoreData);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
        setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
        setTrends([]);
        setSchools([]);
        setZoning(null);
        setLandListings([]);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [suburbName]);

  const handleAiAnalysis = async () => {
    setAiLoading(true);
    setAiError(null);
    setAiReport(null);

    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';

    try {
      const res = await fetch(`${apiUrl}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address: `${suburbName}, Brisbane` }),
      });

      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.detail || 'AI analysis request failed');
      }

      const result = await res.json();
      setAiReport(result.analysis);
    } catch (err) {
      setAiError(err instanceof Error ? err.message : 'AI analysis failed');
    } finally {
      setAiLoading(false);
    }
  };

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
      {/* 导航栏 */}
      <Navbar />

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

        {/* Compass Score 卡片 */}
        {score && (
          <div className="bg-white rounded-xl shadow-sm border p-6 mb-8">
            <div className="flex justify-between items-center mb-6">
              <div>
                <h3 className="text-lg font-semibold text-gray-700 mb-1">Compass Score</h3>
                <p className="text-5xl font-bold text-blue-600">{score.total_score}</p>
              </div>
              <div>
                <span className={`px-4 py-2 rounded-full text-lg font-bold ${
                  score.grade === 'S' ? 'bg-yellow-100 text-yellow-600' :
                  score.grade === 'A' ? 'bg-blue-100 text-blue-600' :
                  score.grade === 'B' ? 'bg-green-100 text-green-600' :
                  'bg-gray-100 text-gray-600'
                }`}>
                  {score.grade} 级
                </span>
              </div>
            </div>
            
            {/* 维度进度条 */}
            <div className="space-y-4 mb-6">
              {Object.entries(score.breakdown).map(([key, item]) => {
                const breakdownItem = item as { score: number; max: number; label: string };
                return (
                  <div key={key}>
                    <div className="flex justify-between mb-1">
                      <span className="text-sm font-medium text-gray-700">{breakdownItem.label}</span>
                      <span className="text-sm text-gray-500">{breakdownItem.score}/{breakdownItem.max}</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div 
                        className="bg-blue-600 h-2 rounded-full" 
                        style={{ width: `${(breakdownItem.score / breakdownItem.max) * 100}%` }}
                      />
                    </div>
                  </div>
                );
              })}
            </div>
            
            <div className="flex justify-between items-center pt-4 border-t">
              <p className="text-xs text-gray-500">数据来源：QLD Gov / NAPLAN / ABS</p>
              <p className="text-sm font-semibold text-blue-600">Compass</p>
            </div>
          </div>
        )}

        {/* AI Investment Analysis Section */}
        <div className="bg-gradient-to-r from-blue-900 to-indigo-800 rounded-xl p-6 mb-8 text-white">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h3 className="text-xl font-bold">AI Investment Analysis</h3>
              <p className="text-blue-200 text-sm mt-1">
                Multi-dimensional data analysis powered by AI
              </p>
            </div>
            <button
              onClick={handleAiAnalysis}
              disabled={aiLoading}
              className="bg-white text-blue-900 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
            >
              {aiLoading ? (
                <>
                  <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  Analyzing...
                </>
              ) : (
                'AI Analysis'
              )}
            </button>
          </div>

          {aiLoading && (
            <div className="bg-white/10 rounded-lg p-6 backdrop-blur-sm">
              <div className="flex items-center gap-3 mb-3">
                <svg className="animate-spin h-5 w-5 text-blue-200" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                <span className="text-blue-100">Analyzing POI, crime, transport, school, zoning data...</span>
              </div>
              <div className="space-y-2">
                {['POI', 'Crime Stats', 'Transport', 'Schools', 'Zoning', 'Market Data'].map((dim, i) => (
                  <div key={dim} className="flex items-center gap-2">
                    <div className={`w-2 h-2 rounded-full ${i < 3 ? 'bg-green-400' : 'bg-blue-300 animate-pulse'}`} />
                    <span className="text-sm text-blue-200">{dim}</span>
                  </div>
                ))}
              </div>
            </div>
          )}

          {aiError && (
            <div className="bg-red-500/20 border border-red-400/30 rounded-lg p-4 mt-4">
              <p className="text-red-200">{aiError}</p>
            </div>
          )}

          {aiReport && (
            <div className="bg-white rounded-xl p-6 mt-4 text-gray-800 max-h-[600px] overflow-y-auto">
              <div className="prose prose-sm max-w-none">
                {aiReport.split('\n').map((line, i) => {
                  if (line.startsWith('## ')) {
                    return <h3 key={i} className="text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1">{line.replace('## ', '')}</h3>;
                  }
                  if (line.startsWith('### ')) {
                    return <h4 key={i} className="text-base font-semibold text-blue-800 mt-3 mb-1">{line.replace('### ', '')}</h4>;
                  }
                  if (line.startsWith('- ')) {
                    return <li key={i} className="ml-4 text-gray-700 mb-1">{line.replace('- ', '')}</li>;
                  }
                  if (line.startsWith('**') && line.endsWith('**')) {
                    return <p key={i} className="font-semibold text-gray-900 mt-2">{line.replace(/\*\*/g, '')}</p>;
                  }
                  if (line.trim() === '') {
                    return <br key={i} />;
                  }
                  return <p key={i} className="text-gray-700 mb-1">{line}</p>;
                })}
              </div>
              <div className="mt-4 pt-3 border-t border-gray-200 flex justify-between items-center">
                <span className="text-xs text-gray-400">Powered by Compass AI Engine</span>
                <span className="text-xs text-gray-400">{new Date().toLocaleString('zh-CN')}</span>
              </div>
            </div>
          )}
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
                const typeSchools = schools.filter(s => s.school_type === type);
                if (typeSchools.length === 0) return null;
                const typeLabel = type === 'primary' ? '小学' : type === 'secondary' ? '中学' : '一贯制';
                return (
                  <div key={type}>
                    <p className="text-sm text-gray-500 mb-2">{typeLabel}</p>
                    {typeSchools.map(school => (
                      <div key={school.name} className="flex justify-between items-center py-2 border-b border-gray-100 last:border-0">
                        <div>
                          <span className="font-medium text-gray-800">{school.name}</span>
                          <span className="ml-2 text-xs text-gray-500">公立</span>
                        </div>
                        {school.naplan_percentile && (
                          <div className="text-right">
                            <span className="text-blue-600 font-bold text-sm">NAPLAN {school.naplan_percentile}</span>
                            <p className="text-xs text-gray-500">评级: {Math.round(school.naplan_percentile / 10) * 10}%</p>
                          </div>
                        )}
                      </div>
                    ))}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* 在售土地 */}
        {landListings.length > 0 && (
          <div className="bg-white rounded-lg p-6 shadow-sm mb-6">
            <h3 className="text-lg font-semibold mb-4">🌍 在售土地 ({landListings.length} 块)</h3>
            <div className="space-y-3">
              {landListings.slice(0, 5).map((land, i) => (
                <div key={i} className="flex justify-between items-center border-b pb-2">
                  <div>
                    <p className="font-medium text-sm">{land.address}</p>
                    <p className="text-gray-500 text-xs">{land.land_size ? `${land.land_size}㎡` : "面积待询"}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-blue-600 text-sm">
                      {land.price ? `$${(land.price/10000).toFixed(0)}万` : land.price_text}
                    </p>
                    <a href={land.link} target="_blank" rel="noopener noreferrer" className="text-xs text-gray-400 hover:text-blue-500">
                      查看详情 →
                    </a>
                  </div>
                </div>
              ))}
            </div>
            {landListings.length > 5 && (
              <p className="text-center text-sm text-gray-400 mt-3">
                还有 {landListings.length - 5} 块土地，前往在售房源页面查看
              </p>
            )}
          </div>
        )}

        {/* 土地分区 */}
        {zoning && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">🏘️ 土地分区</h2>
            <div className="space-y-2">
              {zoning.zones.map((zone, index) => {
                const zoneNameMap: Record<string, string> = {
                  'Low Density Residential': '低密度住宅区',
                  'Medium Density Residential': '中密度住宅区',
                  'High Density Residential': '高密度住宅区',
                  'Mixed Use': '混合用途区',
                  'Other': '其他'
                };
                const zoneNameCN = zoneNameMap[zone.zone_name] || zone.zone_name;
                return (
                  <div key={index} className="flex justify-between items-center">
                    <span className="text-gray-700">{zone.percentage}% {zoneNameCN} ({zone.zone_code})</span>
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
