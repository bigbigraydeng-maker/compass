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
  const [poiData, setPoiData] = useState<any>(null);
  const [crimeData, setCrimeData] = useState<any>(null);
  const [transportData, setTransportData] = useState<any>(null);
  const [rentalData, setRentalData] = useState<any>(null);
  const [floodData, setFloodData] = useState<any>(null);
  const [developmentData, setDevelopmentData] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [aiLoading, setAiLoading] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);
  const [aiError, setAiError] = useState<string | null>(null);
  const [aiAddress, setAiAddress] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const encodedName = encodeURIComponent(suburbName);

      // 安全 fetch 封装：失败不抛异常
      const safeFetch = async (url: string) => {
        try {
          const res = await fetch(url);
          if (!res.ok) return null;
          return await res.json();
        } catch {
          return null;
        }
      };

      try {
        // === 所有 9 个请求并行执行（原来串行 ~900ms → 并行 ~100-150ms） ===
        const [
          detailData, salesData, trendsData, schoolsData,
          zoningData, landData, scoreData, poiResult, crimeResult, transportResult,
          rentalResult, floodResult, developmentResult
        ] = await Promise.all([
          safeFetch(`${apiUrl}/api/suburb/${encodedName}`),
          safeFetch(`${apiUrl}/api/sales?suburb=${encodedName}&page_size=10`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/trends`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/schools`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/zoning`),
          safeFetch(`${apiUrl}/api/listings?suburb=${encodedName}&property_type=vacant_land&page_size=20`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/score`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/poi`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/crime`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/transport`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/rental`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/flood`),
          safeFetch(`${apiUrl}/api/suburb/${encodedName}/development`),
        ]);

        // 合并详情 + 成交记录
        if (detailData) {
          detailData.recent_sales = salesData?.sales || [];
          setData(detailData);
        } else {
          setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
        }

        setTrends(trendsData?.monthly_trends || []);
        setSchools(schoolsData?.schools || []);
        setZoning(zoningData || null);
        setLandListings(landData?.listings || []);
        setScore(scoreData || null);
        if (poiResult) setPoiData(poiResult);
        if (crimeResult) setCrimeData(crimeResult);
        if (transportResult) setTransportData(transportResult);
        if (rentalResult && !rentalResult.error) setRentalData(rentalResult);
        if (floodResult && !floodResult.error) setFloodData(floodResult);
        if (developmentResult && !developmentResult.error) setDevelopmentData(developmentResult);
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
    const addressToAnalyze = aiAddress.trim() || `${suburbName}, Brisbane`;
    setAiLoading(true);
    setAiError(null);
    setAiReport(null);

    const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';

    try {
      const res = await fetch(`${apiUrl}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address: addressToAnalyze }),
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

        {/* POI / Crime / Transport 三栏数据 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {/* 华人生活配套 */}
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4 flex items-center gap-2">
              <span className="text-2xl">🏪</span> 华人生活配套
            </h3>
            {poiData && poiData.total_poi > 0 ? (
              <>
                <p className="text-3xl font-bold text-orange-500 mb-3">{poiData.total_poi} <span className="text-base font-normal text-gray-500">家商户</span></p>
                <div className="space-y-2">
                  {Object.entries(poiData.category_counts || {}).sort(([,a]: any, [,b]: any) => b - a).map(([cat, count]: any) => {
                    const labelMap: Record<string, string> = {
                      chinese_restaurant: '中餐厅', asian_grocery: '亚洲超市',
                      chinese_hair_salon: '华人理发', chinese_church: '华人教会',
                      chinese_clinic: '华人诊所', chinese_school: '中文学校',
                    };
                    const iconMap: Record<string, string> = {
                      chinese_restaurant: '🍜', asian_grocery: '🛒',
                      chinese_hair_salon: '💇', chinese_church: '⛪',
                      chinese_clinic: '🏥', chinese_school: '📚',
                    };
                    return (
                      <div key={cat} className="flex justify-between items-center text-sm">
                        <span className="text-gray-600">{iconMap[cat] || '📍'} {labelMap[cat] || cat}</span>
                        <span className="font-semibold text-gray-800">{count}</span>
                      </div>
                    );
                  })}
                </div>
              </>
            ) : (
              <p className="text-gray-400 text-sm">暂无数据</p>
            )}
          </div>

          {/* 治安数据 */}
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4 flex items-center gap-2">
              <span className="text-2xl">🛡️</span> 治安数据
            </h3>
            {crimeData && crimeData.total_crimes > 0 ? (
              <>
                <p className="text-3xl font-bold text-red-500 mb-1">{crimeData.total_crimes.toLocaleString()} <span className="text-base font-normal text-gray-500">起</span></p>
                <p className="text-xs text-gray-400 mb-3">近12个月犯罪记录</p>
                <div className="space-y-2">
                  {Object.entries(crimeData.categories || {}).sort(([,a]: any, [,b]: any) => b - a).map(([cat, count]: any) => {
                    const labelMap: Record<string, string> = {
                      violent_crime: '暴力犯罪', property_crime: '入室盗窃',
                      theft_fraud: '盗窃诈骗', drug_offences: '毒品犯罪',
                      public_order: '公共秩序',
                    };
                    const colorMap: Record<string, string> = {
                      violent_crime: 'bg-red-100 text-red-700',
                      property_crime: 'bg-orange-100 text-orange-700',
                      theft_fraud: 'bg-yellow-100 text-yellow-700',
                      drug_offences: 'bg-purple-100 text-purple-700',
                      public_order: 'bg-gray-100 text-gray-700',
                    };
                    const pct = crimeData.total_crimes > 0 ? Math.round(count / crimeData.total_crimes * 100) : 0;
                    return (
                      <div key={cat}>
                        <div className="flex justify-between items-center text-sm mb-1">
                          <span className={`px-2 py-0.5 rounded text-xs font-medium ${colorMap[cat] || 'bg-gray-100 text-gray-700'}`}>
                            {labelMap[cat] || cat}
                          </span>
                          <span className="text-gray-600">{count.toLocaleString()} ({pct}%)</span>
                        </div>
                        <div className="w-full bg-gray-100 rounded-full h-1.5">
                          <div className="bg-red-400 h-1.5 rounded-full" style={{ width: `${pct}%` }} />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </>
            ) : (
              <p className="text-gray-400 text-sm">暂无数据</p>
            )}
          </div>

          {/* 公共交通 */}
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4 flex items-center gap-2">
              <span className="text-2xl">🚉</span> 公共交通
            </h3>
            {transportData && transportData.total_stations > 0 ? (
              <>
                <p className="text-3xl font-bold text-green-500 mb-1">{transportData.total_stations} <span className="text-base font-normal text-gray-500">个站点</span></p>
                <p className="text-xs text-gray-400 mb-3">5公里范围内</p>
                <div className="space-y-2">
                  {Object.entries(transportData.by_type || {}).sort(([,a]: any, [,b]: any) => b - a).map(([type, count]: any) => {
                    const labelMap: Record<string, string> = {
                      train_station: '火车站', bus_station: '公交站',
                      transit_station: '交通枢纽', light_rail_station: '轻轨站',
                    };
                    const iconMap: Record<string, string> = {
                      train_station: '🚂', bus_station: '🚌',
                      transit_station: '🚏', light_rail_station: '🚊',
                    };
                    return (
                      <div key={type} className="flex justify-between items-center text-sm">
                        <span className="text-gray-600">{iconMap[type] || '🚉'} {labelMap[type] || type}</span>
                        <span className="font-semibold text-gray-800">{count} 个</span>
                      </div>
                    );
                  })}
                </div>
                {/* 显示部分站点名称 */}
                {transportData.stations_by_type?.train_station && (
                  <div className="mt-3 pt-3 border-t">
                    <p className="text-xs text-gray-400 mb-1">附近火车站：</p>
                    <p className="text-xs text-gray-500">
                      {transportData.stations_by_type.train_station.slice(0, 3).map((s: any) => s.name).join('、')}
                      {transportData.stations_by_type.train_station.length > 3 && '...'}
                    </p>
                  </div>
                )}
              </>
            ) : (
              <p className="text-gray-400 text-sm">暂无数据</p>
            )}
          </div>
        </div>

        {/* AI Investment Analysis Section */}
        <div className="bg-gradient-to-r from-blue-900 to-indigo-800 rounded-xl p-6 mb-8 text-white">
          <div className="mb-4">
            <h3 className="text-xl font-bold mb-1">AI 投资分析</h3>
            <p className="text-blue-200 text-sm">
              基于 POI、治安、交通、学区、分区等多维数据，AI 生成专业投资建议
            </p>
          </div>

          {/* 地址输入 + 分析按钮 */}
          <div className="flex flex-col sm:flex-row gap-3 mb-4">
            <div className="flex-1 relative">
              <input
                type="text"
                value={aiAddress}
                onChange={(e) => setAiAddress(e.target.value)}
                placeholder={`输入具体地址，如：10 Main St, ${suburbName}`}
                className="w-full px-4 py-3 rounded-lg bg-white/10 border border-white/20 text-white placeholder-blue-300 focus:outline-none focus:ring-2 focus:ring-white/40 focus:border-transparent"
                onKeyDown={(e) => { if (e.key === 'Enter' && !aiLoading) handleAiAnalysis(); }}
              />
              {aiAddress && (
                <button
                  onClick={() => setAiAddress('')}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-blue-300 hover:text-white"
                >
                  x
                </button>
              )}
            </div>
            <button
              onClick={handleAiAnalysis}
              disabled={aiLoading}
              className="bg-white text-blue-900 px-8 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 whitespace-nowrap"
            >
              {aiLoading ? (
                <>
                  <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                  </svg>
                  分析中...
                </>
              ) : (
                'AI 分析'
              )}
            </button>
          </div>
          <p className="text-blue-300 text-xs mb-2">
            不输入地址则分析整个 {suburbName} 区 | 数据维度：价格走势 + 房型分类 + 华人配套 + 治安 + 交通 + 学区 + 分区
          </p>

          {aiLoading && (
            <div className="bg-white/10 rounded-lg p-6 backdrop-blur-sm">
              <div className="flex items-center gap-3 mb-3">
                <svg className="animate-spin h-5 w-5 text-blue-200" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                <span className="text-blue-100">正在聚合多维数据并生成 AI 分析报告...</span>
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                {[
                  { name: '价格走势', icon: '📈' },
                  { name: '华人配套', icon: '🏪' },
                  { name: '治安数据', icon: '🛡️' },
                  { name: '公共交通', icon: '🚉' },
                  { name: '学区质量', icon: '🏫' },
                  { name: '土地分区', icon: '🏘️' },
                  { name: '市场活跃度', icon: '📊' },
                  { name: 'AI 推理', icon: '🤖' },
                ].map((dim, i) => (
                  <div key={dim.name} className="flex items-center gap-2 bg-white/5 rounded px-2 py-1">
                    <span>{dim.icon}</span>
                    <span className="text-xs text-blue-200">{dim.name}</span>
                    {i < 6 ? (
                      <span className="text-green-400 text-xs ml-auto">OK</span>
                    ) : (
                      <span className="text-blue-300 text-xs ml-auto animate-pulse">...</span>
                    )}
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
            <div className="bg-white rounded-xl p-6 mt-4 text-gray-800 max-h-[700px] overflow-y-auto">
              <div className="prose prose-sm max-w-none">
                {aiReport.split('\n').map((line, i) => {
                  if (line.startsWith('## ')) {
                    return <h3 key={i} className="text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1">{line.replace(/^##\s*/, '').replace(/\*\*/g, '')}</h3>;
                  }
                  if (line.startsWith('### ')) {
                    return <h4 key={i} className="text-base font-semibold text-blue-800 mt-3 mb-1">{line.replace(/^###\s*/, '').replace(/\*\*/g, '')}</h4>;
                  }
                  if (line.match(/^[-•]\s/)) {
                    const content = line.replace(/^[-•]\s*/, '');
                    // 处理加粗文本
                    const parts = content.split(/(\*\*[^*]+\*\*)/g);
                    return (
                      <li key={i} className="ml-4 text-gray-700 mb-1">
                        {parts.map((part, j) =>
                          part.startsWith('**') && part.endsWith('**')
                            ? <strong key={j} className="text-gray-900">{part.replace(/\*\*/g, '')}</strong>
                            : <span key={j}>{part}</span>
                        )}
                      </li>
                    );
                  }
                  if (line.trim() === '') {
                    return <div key={i} className="h-2" />;
                  }
                  // 处理行内加粗
                  const parts = line.split(/(\*\*[^*]+\*\*)/g);
                  return (
                    <p key={i} className="text-gray-700 mb-1">
                      {parts.map((part, j) =>
                        part.startsWith('**') && part.endsWith('**')
                          ? <strong key={j} className="text-gray-900">{part.replace(/\*\*/g, '')}</strong>
                          : <span key={j}>{part}</span>
                      )}
                    </p>
                  );
                })}
              </div>
              <div className="mt-4 pt-3 border-t border-gray-200 flex justify-between items-center">
                <span className="text-xs text-gray-400">Powered by Compass AI + Kimi K2.5</span>
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
              {['primary', 'combined', 'secondary'].map(stype => {
                const typeSchools = schools.filter((s: any) => (s.type || s.school_type) === stype);
                if (typeSchools.length === 0) return null;
                const typeLabel = stype === 'primary' ? '小学' : stype === 'secondary' ? '中学' : '一贯制';
                return (
                  <div key={stype}>
                    <p className="text-sm text-gray-500 mb-2">{typeLabel}</p>
                    {typeSchools.map((school: any) => {
                      const sectorMap: Record<string, string> = { Government: '公立', Catholic: '天主教', Independent: '私立' };
                      const sectorLabel = sectorMap[school.sector] || school.sector || '公立';
                      return (
                        <div key={school.name} className="flex justify-between items-center py-2 border-b border-gray-100 last:border-0">
                          <div>
                            <span className="font-medium text-gray-800">{school.name}</span>
                            <span className={`ml-2 text-xs px-1.5 py-0.5 rounded ${school.sector === 'Government' ? 'bg-green-100 text-green-700' : school.sector === 'Catholic' ? 'bg-purple-100 text-purple-700' : 'bg-blue-100 text-blue-700'}`}>{sectorLabel}</span>
                            {school.enrollment && <span className="ml-2 text-xs text-gray-400">{school.enrollment}人</span>}
                          </div>
                          <div className="text-right">
                            {(school.naplan_score || school.naplan_percentile) && (
                              <span className="text-blue-600 font-bold text-sm">NAPLAN {school.naplan_score || school.naplan_percentile}</span>
                            )}
                            {school.rating && (
                              <p className="text-xs text-gray-500">评分: {school.rating}/10</p>
                            )}
                          </div>
                        </div>
                      );
                    })}
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

        {/* 📊 租赁回报 */}
        {rentalData && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">📊 租赁回报</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b-2 border-gray-200">
                    <th className="text-left py-2 text-gray-500">指标</th>
                    <th className="text-right py-2 text-blue-600">🏠 别墅 House</th>
                    <th className="text-right py-2 text-purple-600">🏢 公寓 Unit</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  <tr>
                    <td className="py-2 text-gray-700">中位价</td>
                    <td className="py-2 text-right font-bold text-gray-800">{formatPrice(rentalData.median_house_price)}</td>
                    <td className="py-2 text-right font-bold text-gray-800">{formatPrice(rentalData.median_unit_price)}</td>
                  </tr>
                  <tr>
                    <td className="py-2 text-gray-700">周租金</td>
                    <td className="py-2 text-right">${rentalData.median_house_rent_weekly}/周</td>
                    <td className="py-2 text-right">${rentalData.median_unit_rent_weekly}/周</td>
                  </tr>
                  <tr>
                    <td className="py-2 text-gray-700">年回报率</td>
                    <td className={`py-2 text-right font-bold ${rentalData.house_rental_yield_pct >= 3 ? 'text-green-600' : 'text-orange-600'}`}>
                      {rentalData.house_rental_yield_pct}%
                    </td>
                    <td className={`py-2 text-right font-bold ${rentalData.unit_rental_yield_pct >= 4 ? 'text-green-600' : 'text-orange-600'}`}>
                      {rentalData.unit_rental_yield_pct}%
                    </td>
                  </tr>
                  <tr>
                    <td className="py-2 text-gray-700">年增长率</td>
                    <td className={`py-2 text-right font-semibold ${rentalData.annual_growth_house_pct >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                      {rentalData.annual_growth_house_pct > 0 ? '+' : ''}{rentalData.annual_growth_house_pct}%
                    </td>
                    <td className={`py-2 text-right font-semibold ${rentalData.annual_growth_unit_pct >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                      {rentalData.annual_growth_unit_pct > 0 ? '+' : ''}{rentalData.annual_growth_unit_pct}%
                    </td>
                  </tr>
                  <tr>
                    <td className="py-2 text-gray-700">上市天数</td>
                    <td className="py-2 text-right">{rentalData.days_on_market_house} 天</td>
                    <td className="py-2 text-right">{rentalData.days_on_market_unit} 天</td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div className="mt-3 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-xs text-gray-400">空置率</span>
                <span className={`text-sm font-bold ${rentalData.vacancy_rate_pct < 2 ? 'text-green-600' : 'text-orange-600'}`}>
                  {rentalData.vacancy_rate_pct}%
                </span>
                {rentalData.vacancy_rate_pct < 2 && <span className="text-xs bg-green-100 text-green-700 px-1.5 py-0.5 rounded">供不应求</span>}
              </div>
              <span className="text-xs text-gray-400">数据来源: CoreLogic {rentalData.last_updated}</span>
            </div>
          </div>
        )}

        {/* 🌊 洪水风险 */}
        {floodData && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">🌊 洪水风险评估</h2>
            <div className="flex items-center gap-4 mb-4">
              <div className={`px-4 py-2 rounded-lg font-bold text-lg ${
                floodData.risk_level === 'low' ? 'bg-green-100 text-green-700' :
                floodData.risk_level === 'moderate' ? 'bg-yellow-100 text-yellow-700' :
                floodData.risk_level === 'high' ? 'bg-red-100 text-red-700' :
                'bg-red-200 text-red-800'
              }`}>
                {floodData.risk_level === 'low' ? '低风险' :
                 floodData.risk_level === 'moderate' ? '中风险' :
                 floodData.risk_level === 'high' ? '高风险' : '极高风险'}
              </div>
              <div className="text-sm text-gray-600">
                约 <span className="font-bold">{floodData.affected_percentage}%</span> 区域受洪水覆盖影响
              </div>
            </div>
            <div className="flex flex-wrap gap-2 mb-3">
              {floodData.flood_types?.map((ft: string) => {
                const ftMap: Record<string, string> = {
                  riverine: '河流洪水', creek: '溪流洪水',
                  overland_flow: '地表径流', storm_tide: '风暴潮'
                };
                return (
                  <span key={ft} className="text-xs bg-blue-50 text-blue-600 px-2 py-1 rounded-full">
                    {ftMap[ft] || ft}
                  </span>
                );
              })}
            </div>
            <p className="text-sm text-gray-600 mb-2">
              <span className="font-medium">最近重大洪水:</span> {floodData.last_major_flood}
            </p>
            <p className="text-xs text-gray-500 mb-3">{floodData.notes}</p>
            <a
              href={floodData.map_url}
              target="_blank"
              rel="noopener noreferrer"
              className="text-sm text-blue-600 hover:text-blue-800 underline"
            >
              查看 BCC 洪水地图 →
            </a>
          </div>
        )}

        {/* 🏗️ 政府发展规划 */}
        {developmentData && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">🏗️ 政府发展规划</h2>
            <div className="flex items-center gap-3 mb-4">
              <span className="text-sm text-gray-500">议会优先级:</span>
              <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                developmentData.council_priority === 'high' ? 'bg-green-100 text-green-700' :
                developmentData.council_priority === 'medium' ? 'bg-yellow-100 text-yellow-700' :
                'bg-gray-100 text-gray-600'
              }`}>
                {developmentData.council_priority === 'high' ? '🔥 高优先' :
                 developmentData.council_priority === 'medium' ? '⚡ 中优先' : '📋 低优先'}
              </span>
            </div>
            <p className="text-sm text-gray-600 mb-4">{developmentData.zoning_summary}</p>
            {developmentData.key_projects?.length > 0 && (
              <div className="mb-4">
                <h3 className="text-sm font-semibold text-gray-700 mb-2">重点项目</h3>
                <div className="space-y-3">
                  {developmentData.key_projects.map((proj: any, i: number) => {
                    const statusMap: Record<string, { label: string; color: string }> = {
                      completed: { label: '已完成', color: 'bg-green-100 text-green-700' },
                      under_construction: { label: '建设中', color: 'bg-blue-100 text-blue-700' },
                      approved: { label: '已批准', color: 'bg-yellow-100 text-yellow-700' },
                      proposed: { label: '规划中', color: 'bg-gray-100 text-gray-600' },
                    };
                    const status = statusMap[proj.status] || { label: proj.status, color: 'bg-gray-100 text-gray-600' };
                    return (
                      <div key={i} className="border border-gray-100 rounded-lg p-3">
                        <div className="flex items-start justify-between mb-1">
                          <span className="font-medium text-gray-800 text-sm">{proj.name}</span>
                          <span className={`text-xs px-2 py-0.5 rounded-full whitespace-nowrap ml-2 ${status.color}`}>
                            {status.label}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500">{proj.description}</p>
                        {proj.estimated_completion && proj.estimated_completion !== 'TBD' && (
                          <p className="text-xs text-gray-400 mt-1">预计完成: {proj.estimated_completion}</p>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
            {developmentData.infrastructure?.length > 0 && (
              <div>
                <h3 className="text-sm font-semibold text-gray-700 mb-2">基础设施</h3>
                <ul className="space-y-1">
                  {developmentData.infrastructure.map((item: string, i: number) => (
                    <li key={i} className="text-xs text-gray-600 flex items-start gap-2">
                      <span className="text-green-500 mt-0.5">✓</span>
                      {item}
                    </li>
                  ))}
                </ul>
              </div>
            )}
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
