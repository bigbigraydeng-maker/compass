'use client';

import Link from 'next/link';
import { useState, useEffect } from 'react';
import dynamic from 'next/dynamic';
import Navbar from '../../components/Navbar';

// 动态导入 Recharts（~372KB），仅在图表可见时加载
const RechartsChart = dynamic(
  () => import('recharts').then((mod) => {
    const { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } = mod;
    // 返回一个包装组件
    const Chart = ({ data, formatMonth, CustomTooltip }: any) => (
      <ResponsiveContainer width="100%" height={300}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="month" tickFormatter={formatMonth} stroke="#6b7280" fontSize={12} />
          <YAxis
            domain={[(dataMin: number) => Math.floor(dataMin * 0.9 / 100000) * 100000, 'auto']}
            tickFormatter={(value: number) => `$${(value / 1000000).toFixed(1)}M`}
            stroke="#6b7280"
            fontSize={12}
          />
          <Tooltip content={<CustomTooltip />} />
          <Line type="monotone" dataKey="median_price" stroke="#2563eb" strokeWidth={2} dot={{ fill: '#2563eb', strokeWidth: 2, r: 4 }} activeDot={{ r: 6, fill: '#1d4ed8' }} />
        </LineChart>
      </ResponsiveContainer>
    );
    Chart.displayName = 'PriceChart';
    return Chart;
  }),
  { ssr: false, loading: () => <div className="h-[300px] flex items-center justify-center text-gray-300"><div className="w-6 h-6 border-2 border-gray-200 border-t-blue-500 rounded-full animate-spin" /></div> }
);

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

// 华人宜居指数计算
function calcLivabilityScores(poi: any, crime: any, transport: any) {
  // POI score: 0=0, 1-10=30, 10-30=50, 30-60=70, 60-100=85, 100+=100
  let poiTotal = 0;
  if (poi) for (const v of Object.values(poi.category_counts || {})) poiTotal += (v as number);
  const poiScore = poiTotal === 0 ? 0 : poiTotal < 10 ? 30 : poiTotal < 30 ? 50 : poiTotal < 60 ? 70 : poiTotal < 100 ? 85 : 100;

  // Safety score: inverse of crime. <200=95, 200-500=80, 500-1000=65, 1000-2000=45, 2000+=25
  const crimeTotal = crime?.total_crimes || 0;
  const safetyScore = crimeTotal === 0 ? 50 : crimeTotal < 200 ? 95 : crimeTotal < 500 ? 80 : crimeTotal < 1000 ? 65 : crimeTotal < 2000 ? 45 : 25;

  // Transport score: 0=0, 1-10=30, 10-30=50, 30-60=70, 60-100=85, 100+=100
  const transTotal = transport?.total_stations || 0;
  const transScore = transTotal === 0 ? 0 : transTotal < 10 ? 30 : transTotal < 30 ? 50 : transTotal < 60 ? 70 : transTotal < 100 ? 85 : 100;

  const overall = Math.round((poiScore + safetyScore + transScore) / 3);
  return { overall, poiScore, safetyScore, transScore, poiTotal, crimeTotal, transTotal };
}

function getScoreColor(score: number) {
  if (score >= 80) return 'text-green-600';
  if (score >= 60) return 'text-blue-600';
  if (score >= 40) return 'text-yellow-600';
  return 'text-red-500';
}

function getScoreLabel(score: number) {
  if (score >= 80) return '优秀';
  if (score >= 60) return '良好';
  if (score >= 40) return '一般';
  if (score > 0) return '较弱';
  return '暂无';
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
  const [expandedProject, setExpandedProject] = useState<number | null>(null);
  const [showLivabilityDetail, setShowLivabilityDetail] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const encodedName = encodeURIComponent(suburbName);

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
        const allData = await safeFetch(`${apiUrl}/api/suburb/${encodedName}/all`);

        if (allData) {
          // Detail + sales
          const recentSales = (allData.recent_sales_list || []).map((r: any) => ({
            address: r.address || r.full_address || '',
            property_type: r.property_type || '',
            bedrooms: r.bedrooms || 0,
            bathrooms: r.bathrooms || 0,
            land_size: r.land_size || 0,
            sold_price: parseFloat(r.sold_price || r.sale_price || 0),
            sold_date: r.sold_date || r.sale_date || '',
          }));
          setData({
            suburb: allData.suburb || suburbName,
            median_price: allData.median_price || 0,
            total_sales: allData.total_sales || 0,
            recent_sales: recentSales,
          });

          // Trends
          setTrends(allData.monthly_trends || []);

          // Schools
          setSchools(allData.schools_full || allData.schools || []);

          // Zoning
          if (allData.zoning?.zones) {
            setZoning({ suburb: suburbName, zones: allData.zoning.zones.map((z: any) => ({
              zone_code: z.code || z.zone_code, zone_name: z.name || z.zone_name, percentage: z.pct || z.percentage
            }))});
          }

          // Land listings
          setLandListings(allData.land_listings || []);

          // Compass Score
          if (allData.compass_score) {
            setScore({
              total_score: allData.compass_score.total,
              grade: allData.compass_score.grade,
              breakdown: allData.compass_score.breakdown,
            });
          }

          // === FIX: POI data mapping ===
          if (allData.poi && Object.keys(allData.poi).length > 0) {
            const categoryCounts: Record<string, number> = {};
            let totalPoi = 0;
            for (const [cat, info] of Object.entries(allData.poi as Record<string, any>)) {
              const count = typeof info === 'object' ? (info.count || 0) : (typeof info === 'number' ? info : 0);
              categoryCounts[cat] = count;
              totalPoi += count;
            }
            setPoiData({ suburb: suburbName, total_poi: totalPoi, category_counts: categoryCounts, raw: allData.poi });
          }

          // === FIX: Crime data mapping ===
          if (allData.crime && Object.keys(allData.crime).length > 0) {
            let totalCrimes = 0;
            for (const v of Object.values(allData.crime as Record<string, number>)) {
              totalCrimes += typeof v === 'number' ? v : 0;
            }
            setCrimeData({ suburb: suburbName, total_crimes: totalCrimes, categories: allData.crime });
          }

          // === FIX: Transport data mapping ===
          if (allData.transport && Object.keys(allData.transport).length > 0) {
            let totalStations = 0;
            for (const v of Object.values(allData.transport as Record<string, number>)) {
              totalStations += typeof v === 'number' ? v : 0;
            }
            setTransportData({ suburb: suburbName, total_stations: totalStations, by_type: allData.transport });
          }

          // New dimensions
          if (allData.rental) setRentalData({ suburb: suburbName, ...allData.rental });
          if (allData.flood) setFloodData({ suburb: suburbName, ...allData.flood });
          if (allData.development) setDevelopmentData({ suburb: suburbName, ...allData.development });
        } else {
          setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
        }
      } catch (error) {
        console.error('Error fetching data:', error);
        setData({ suburb: suburbName, median_price: 0, total_sales: 0, recent_sales: [] });
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
      const res = await fetch(`${apiUrl}/api/analyze/stream`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address: addressToAnalyze }),
      });

      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.detail || 'AI analysis request failed');
      }

      const reader = res.body?.getReader();
      if (!reader) throw new Error('Stream not supported');

      const decoder = new TextDecoder();
      let accumulated = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        const chunk = decoder.decode(value, { stream: true });
        const lines = chunk.split('\n');

        for (const line of lines) {
          if (!line.startsWith('data: ')) continue;
          try {
            const payload = JSON.parse(line.slice(6));
            if (payload.type === 'content') {
              accumulated += payload.text;
              setAiReport(accumulated);
            } else if (payload.type === 'error') {
              throw new Error(payload.message);
            } else if (payload.type === 'done') {
              // 流式完成
            }
          } catch (e) {
            if (e instanceof SyntaxError) continue; // 忽略不完整的 JSON
            throw e;
          }
        }
      }

      if (!accumulated) {
        throw new Error('AI 未返回任何内容');
      }
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

  const livability = calcLivabilityScores(poiData, crimeData, transportData);

  return (
    <div className="min-h-screen bg-gray-50">
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

        {/* ===== 1. Compass Score ===== */}
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
                      <div className="bg-blue-600 h-2 rounded-full" style={{ width: `${(breakdownItem.score / breakdownItem.max) * 100}%` }} />
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

        {/* ===== 2. AI Investment Analysis (moved up) ===== */}
        <div className="bg-gradient-to-r from-blue-900 to-indigo-800 rounded-xl p-6 mb-8 text-white">
          <div className="mb-4">
            <h3 className="text-xl font-bold mb-1">Amanda 投资分析</h3>
            <p className="text-blue-200 text-sm">
              基于 POI、治安、交通、学区、分区等多维数据，AI 生成专业投资建议
            </p>
          </div>

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
                <button onClick={() => setAiAddress('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-blue-300 hover:text-white">x</button>
              )}
            </div>
            <button
              onClick={handleAiAnalysis}
              disabled={aiLoading}
              className="bg-white text-blue-900 px-8 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 whitespace-nowrap"
            >
              {aiLoading ? (
                <>
                  <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
                  分析中...
                </>
              ) : 'Amanda 分析'}
            </button>
          </div>
          <p className="text-blue-300 text-xs mb-2">
            不输入地址则分析整个 {suburbName} 区 | 数据维度：价格走势 + 房型分类 + 华人配套 + 治安 + 交通 + 学区 + 分区
          </p>

          {aiLoading && !aiReport && (
            <div className="bg-white/10 rounded-lg p-6 backdrop-blur-sm">
              <div className="flex items-center gap-3 mb-3">
                <svg className="animate-spin h-5 w-5 text-blue-200" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
                <span className="text-blue-100">Amanda 正在聚合多维数据生成分析报告...</span>
              </div>
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                {[
                  { name: '价格走势', icon: '📈' }, { name: '华人配套', icon: '🏪' },
                  { name: '治安数据', icon: '🛡️' }, { name: '公共交通', icon: '🚉' },
                  { name: '学区质量', icon: '🏫' }, { name: '土地分区', icon: '🏘️' },
                  { name: '市场活跃度', icon: '📊' }, { name: 'AI 推理', icon: '🤖' },
                ].map((dim, i) => (
                  <div key={dim.name} className="flex items-center gap-2 bg-white/5 rounded px-2 py-1">
                    <span>{dim.icon}</span>
                    <span className="text-xs text-blue-200">{dim.name}</span>
                    {i < 6 ? <span className="text-green-400 text-xs ml-auto">OK</span> : <span className="text-blue-300 text-xs ml-auto animate-pulse">...</span>}
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
              {aiLoading && (
                <div className="flex items-center gap-2 mb-3 text-blue-600">
                  <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
                  <span className="text-sm">AI 正在生成中...</span>
                </div>
              )}
              <div className="prose prose-sm max-w-none">
                {aiReport.split('\n').map((line, i) => {
                  if (line.startsWith('## ')) return <h3 key={i} className="text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1">{line.replace(/^##\s*/, '').replace(/\*\*/g, '')}</h3>;
                  if (line.startsWith('### ')) return <h4 key={i} className="text-base font-semibold text-blue-800 mt-3 mb-1">{line.replace(/^###\s*/, '').replace(/\*\*/g, '')}</h4>;
                  if (line.match(/^[-•]\s/)) {
                    const content = line.replace(/^[-•]\s*/, '');
                    const parts = content.split(/(\*\*[^*]+\*\*)/g);
                    return (
                      <li key={i} className="ml-4 text-gray-700 mb-1">
                        {parts.map((part, j) => part.startsWith('**') && part.endsWith('**') ? <strong key={j} className="text-gray-900">{part.replace(/\*\*/g, '')}</strong> : <span key={j}>{part}</span>)}
                      </li>
                    );
                  }
                  if (line.trim() === '') return <div key={i} className="h-2" />;
                  const parts = line.split(/(\*\*[^*]+\*\*)/g);
                  return (
                    <p key={i} className="text-gray-700 mb-1">
                      {parts.map((part, j) => part.startsWith('**') && part.endsWith('**') ? <strong key={j} className="text-gray-900">{part.replace(/\*\*/g, '')}</strong> : <span key={j}>{part}</span>)}
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

        {/* ===== 3. Rental Yields (moved right after AI) ===== */}
        {rentalData && (
          <div className="bg-white rounded-lg shadow p-6 mb-8">
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

        {/* ===== 4. 华人宜居指数 (Integrated POI + Crime + Transport) ===== */}
        {(poiData || crimeData || transportData) && (
          <div className="bg-white rounded-xl shadow-sm border p-6 mb-8">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-bold text-gray-800">华人宜居指数</h2>
              <div className="flex items-center gap-2">
                <span className={`text-3xl font-bold ${getScoreColor(livability.overall)}`}>{livability.overall}</span>
                <span className={`text-sm font-medium ${getScoreColor(livability.overall)}`}>{getScoreLabel(livability.overall)}</span>
              </div>
            </div>

            {/* 3 sub-scores */}
            <div className="grid grid-cols-3 gap-4 mb-4">
              <div className="text-center p-3 bg-orange-50 rounded-lg">
                <p className="text-2xl mb-1">🏪</p>
                <p className={`text-xl font-bold ${getScoreColor(livability.poiScore)}`}>{livability.poiScore}</p>
                <p className="text-xs text-gray-500 mt-1">华人配套</p>
                <p className="text-xs text-gray-400">{livability.poiTotal} 家商户</p>
              </div>
              <div className="text-center p-3 bg-blue-50 rounded-lg">
                <p className="text-2xl mb-1">🛡️</p>
                <p className={`text-xl font-bold ${getScoreColor(livability.safetyScore)}`}>{livability.safetyScore}</p>
                <p className="text-xs text-gray-500 mt-1">社区安全</p>
                <p className="text-xs text-gray-400">{livability.crimeTotal > 0 ? `${livability.crimeTotal.toLocaleString()} 起/年` : '暂无数据'}</p>
              </div>
              <div className="text-center p-3 bg-green-50 rounded-lg">
                <p className="text-2xl mb-1">🚉</p>
                <p className={`text-xl font-bold ${getScoreColor(livability.transScore)}`}>{livability.transScore}</p>
                <p className="text-xs text-gray-500 mt-1">交通便利</p>
                <p className="text-xs text-gray-400">{livability.transTotal} 个站点</p>
              </div>
            </div>

            {/* Progress bars */}
            <div className="space-y-2 mb-4">
              {[
                { label: '华人配套', score: livability.poiScore, color: 'bg-orange-500' },
                { label: '社区安全', score: livability.safetyScore, color: 'bg-blue-500' },
                { label: '交通便利', score: livability.transScore, color: 'bg-green-500' },
              ].map(item => (
                <div key={item.label}>
                  <div className="flex justify-between text-xs text-gray-500 mb-0.5">
                    <span>{item.label}</span>
                    <span>{item.score}/100</span>
                  </div>
                  <div className="w-full bg-gray-100 rounded-full h-2">
                    <div className={`${item.color} h-2 rounded-full transition-all duration-500`} style={{ width: `${item.score}%` }} />
                  </div>
                </div>
              ))}
            </div>

            {/* Toggle detail */}
            <button
              onClick={() => setShowLivabilityDetail(!showLivabilityDetail)}
              className="text-sm text-blue-600 hover:text-blue-800 font-medium"
            >
              {showLivabilityDetail ? '收起详情 ▲' : '查看详细数据 ▼'}
            </button>

            {showLivabilityDetail && (
              <div className="mt-4 pt-4 border-t grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* POI detail */}
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-2">🏪 华人配套明细</h4>
                  {poiData && poiData.total_poi > 0 ? (
                    <div className="space-y-1.5">
                      {Object.entries(poiData.category_counts || {}).sort(([,a]: any, [,b]: any) => b - a).map(([cat, count]: any) => {
                        const labelMap: Record<string, string> = {
                          chinese_restaurant: '🍜 中餐厅', asian_grocery: '🛒 亚洲超市',
                          chinese_hair_salon: '💇 华人理发', chinese_church: '⛪ 华人教会',
                          chinese_clinic: '🏥 华人诊所', chinese_school: '📚 中文学校',
                        };
                        return (
                          <div key={cat} className="flex justify-between items-center text-sm">
                            <span className="text-gray-600">{labelMap[cat] || `📍 ${cat}`}</span>
                            <span className="font-semibold text-gray-800">{count}</span>
                          </div>
                        );
                      })}
                    </div>
                  ) : <p className="text-gray-400 text-xs">暂无数据</p>}
                </div>

                {/* Crime detail */}
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-2">🛡️ 治安明细（近12月）</h4>
                  {crimeData && crimeData.total_crimes > 0 ? (
                    <div className="space-y-1.5">
                      {Object.entries(crimeData.categories || {}).sort(([,a]: any, [,b]: any) => b - a).map(([cat, count]: any) => {
                        const labelMap: Record<string, string> = {
                          violent_crime: '暴力犯罪', property_crime: '入室盗窃',
                          theft_fraud: '盗窃诈骗', drug_offences: '毒品犯罪',
                          public_order: '公共秩序',
                        };
                        const pct = Math.round(count / crimeData.total_crimes * 100);
                        return (
                          <div key={cat}>
                            <div className="flex justify-between items-center text-sm">
                              <span className="text-gray-600">{labelMap[cat] || cat}</span>
                              <span className="text-gray-600">{count.toLocaleString()} ({pct}%)</span>
                            </div>
                            <div className="w-full bg-gray-100 rounded-full h-1 mt-0.5">
                              <div className="bg-red-400 h-1 rounded-full" style={{ width: `${pct}%` }} />
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  ) : <p className="text-gray-400 text-xs">暂无数据</p>}
                </div>

                {/* Transport detail */}
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-2">🚉 交通站点明细</h4>
                  {transportData && transportData.total_stations > 0 ? (
                    <div className="space-y-1.5">
                      {Object.entries(transportData.by_type || {}).sort(([,a]: any, [,b]: any) => b - a).map(([type, count]: any) => {
                        const labelMap: Record<string, string> = {
                          train_station: '🚂 火车站', bus_station: '🚌 公交站',
                          transit_station: '🚏 交通枢纽', light_rail_station: '🚊 轻轨站',
                        };
                        return (
                          <div key={type} className="flex justify-between items-center text-sm">
                            <span className="text-gray-600">{labelMap[type] || `🚉 ${type}`}</span>
                            <span className="font-semibold text-gray-800">{count} 个</span>
                          </div>
                        );
                      })}
                    </div>
                  ) : <p className="text-gray-400 text-xs">暂无数据</p>}
                </div>
              </div>
            )}
          </div>
        )}

        {/* ===== 5. Price Overview ===== */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">中位价</h3>
            <p className="text-4xl font-bold text-blue-600">{formatPrice(data.median_price)}</p>
          </div>
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">成交数量</h3>
            <p className="text-4xl font-bold text-blue-600">{data.total_sales} 套</p>
          </div>
        </div>

        {/* ===== 6. Price Trend Chart ===== */}
        {trends.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border mb-8">
            <div className="px-6 py-4 border-b">
              <h2 className="text-lg font-semibold text-gray-800">价格走势（过去12个月）</h2>
            </div>
            <div className="p-6">
              <RechartsChart data={trends} formatMonth={formatMonth} CustomTooltip={CustomTooltip} />
            </div>
          </div>
        )}

        {/* ===== 7. Recent Sales ===== */}
        {data.recent_sales.length > 0 && (
          <div className="bg-white rounded-xl shadow-sm border mb-8">
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
                  {data.recent_sales.map((sale: any, idx: number) => (
                    <tr key={idx} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bedrooms}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bathrooms}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.land_size > 0 ? `${sale.land_size}㎡` : '-'}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* ===== 8. Schools ===== */}
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

        {/* ===== 9. Land Listings ===== */}
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
                    <a href={land.link} target="_blank" rel="noopener noreferrer" className="text-xs text-gray-400 hover:text-blue-500">查看详情 →</a>
                  </div>
                </div>
              ))}
            </div>
            {landListings.length > 5 && (
              <p className="text-center text-sm text-gray-400 mt-3">还有 {landListings.length - 5} 块土地</p>
            )}
          </div>
        )}

        {/* ===== 10. Land Zoning ===== */}
        {zoning && (
          <div className="bg-white rounded-lg shadow p-6 mb-6">
            <h2 className="text-lg font-bold text-gray-800 mb-4">🏘️ 土地分区</h2>
            <div className="space-y-2">
              {zoning.zones.map((zone, index) => {
                const zoneNameMap: Record<string, string> = {
                  'Low Density Residential': '低密度住宅区',
                  'Low-Medium Density Residential': '低中密度住宅区',
                  'Medium Density Residential': '中密度住宅区',
                  'High Density Residential': '高密度住宅区',
                  'Mixed Use': '混合用途区',
                  'Emerging Community': '新兴社区区',
                  'Neighbourhood Centre': '邻里中心',
                  'District Centre': '区级中心',
                  'Principal Centre': '主要中心',
                  'Priority Development Area': '优先开发区',
                  'Character Residential': '特色住宅区',
                  'Community Facilities': '社区设施',
                  'Sport and Recreation': '体育休闲',
                  'Open Space': '开放空间',
                  'Other': '其他'
                };
                const zoneNameCN = zoneNameMap[zone.zone_name] || zone.zone_name;
                const barColors = ['bg-blue-500', 'bg-green-500', 'bg-yellow-500', 'bg-purple-500', 'bg-orange-500', 'bg-pink-500', 'bg-teal-500'];
                return (
                  <div key={index}>
                    <div className="flex justify-between text-sm mb-0.5">
                      <span className="text-gray-700">{zoneNameCN} ({zone.zone_code})</span>
                      <span className="text-gray-500 font-medium">{zone.percentage}%</span>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2">
                      <div className={`${barColors[index % barColors.length]} h-2 rounded-full`} style={{ width: `${zone.percentage}%` }} />
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* ===== 11. Flood Risk (Chinese) ===== */}
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
              <span className="font-medium">最近重大洪水:</span> {floodData.last_major_flood_cn || floodData.last_major_flood}
            </p>
            <p className="text-sm text-gray-600 mb-3">{floodData.notes_cn || floodData.notes}</p>
            {floodData.risk_level === 'high' && (
              <div className="bg-red-50 border border-red-200 rounded-lg p-3 mb-3">
                <p className="text-sm text-red-700 font-medium">⚠️ 购房提示：该区域洪水风险较高，建议购房前务必查阅洪水覆盖图，选择高地段物业，并了解洪水保险费用。</p>
              </div>
            )}
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

        {/* ===== 12. Government Development (Chinese, expandable) ===== */}
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
            <p className="text-sm text-gray-600 mb-4">{developmentData.zoning_summary_cn || developmentData.zoning_summary}</p>

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
                    const isExpanded = expandedProject === i;
                    return (
                      <div key={i} className="border border-gray-100 rounded-lg p-3 hover:border-blue-200 transition-colors">
                        <div
                          className="flex items-start justify-between mb-1 cursor-pointer"
                          onClick={() => setExpandedProject(isExpanded ? null : i)}
                        >
                          <div className="flex-1">
                            <span className="font-medium text-gray-800 text-sm">{proj.name_cn || proj.name}</span>
                            {proj.name_cn && <p className="text-xs text-gray-400 mt-0.5">{proj.name}</p>}
                          </div>
                          <div className="flex items-center gap-2 ml-2">
                            <span className={`text-xs px-2 py-0.5 rounded-full whitespace-nowrap ${status.color}`}>
                              {status.label}
                            </span>
                            <span className="text-gray-400 text-xs">{isExpanded ? '▲' : '▼'}</span>
                          </div>
                        </div>
                        {!isExpanded && (
                          <p className="text-xs text-gray-500 line-clamp-2">{proj.description_cn ? proj.description_cn.slice(0, 60) + '...' : proj.description}</p>
                        )}
                        {isExpanded && (
                          <div className="mt-2 pt-2 border-t border-gray-100">
                            <p className="text-sm text-gray-700 leading-relaxed">{proj.description_cn || proj.description}</p>
                            {proj.estimated_completion && proj.estimated_completion !== 'TBD' && (
                              <p className="text-xs text-gray-400 mt-2">预计完成: {proj.estimated_completion}</p>
                            )}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {(developmentData.infrastructure_cn || developmentData.infrastructure)?.length > 0 && (
              <div>
                <h3 className="text-sm font-semibold text-gray-700 mb-2">基础设施</h3>
                <ul className="space-y-1">
                  {(developmentData.infrastructure_cn || developmentData.infrastructure).map((item: string, i: number) => (
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
