'use client';

import { useState } from 'react';
import dynamic from 'next/dynamic';
import { PersonaButton, PersonaMarkdown } from '../components/persona';

// 动态导入 Recharts，仅在图表可见时加载
const SchoolPriceChart = dynamic(
  () => import('recharts').then((mod) => {
    const { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } = mod;
    const Chart = ({ data, formatMonth, formatPriceShort, CustomTooltip }: any) => (
      <ResponsiveContainer width="100%" height={200}>
        <LineChart data={data}>
          <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
          <XAxis dataKey="month" tickFormatter={formatMonth} tick={{ fontSize: 11 }} />
          <YAxis tickFormatter={(v: number) => formatPriceShort(v)} tick={{ fontSize: 11 }} width={55} />
          <Tooltip content={<CustomTooltip />} />
          <Line type="monotone" dataKey="median_price" stroke="#3B82F6" strokeWidth={2} dot={{ r: 3 }} activeDot={{ r: 5 }} />
        </LineChart>
      </ResponsiveContainer>
    );
    Chart.displayName = 'SchoolPriceChart';
    return Chart;
  }),
  { ssr: false, loading: () => <div className="h-[200px] flex items-center justify-center text-gray-300"><div className="w-5 h-5 border-2 border-gray-200 border-t-blue-500 rounded-full animate-spin" /></div> }
);

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';

interface Sale {
  address: string;
  suburb: string;
  sold_price: number;
  sold_date: string;
  property_type: string;
  bedrooms: number;
  bathrooms: number;
  land_size: number;
}

interface MonthlyTrend {
  month: string;
  median_price: number;
  total_sales: number;
}

interface RentalData {
  median_house_rent_weekly: number;
  median_unit_rent_weekly: number;
  house_rental_yield_pct: number;
  unit_rental_yield_pct: number;
  vacancy_rate_pct: number;
  days_on_market_house?: number;
  days_on_market_unit?: number;
}

interface CrimeData {
  total_crimes: number;
  categories: Record<string, number>;
}

interface CatchmentAggregated {
  median_price: number;
  total_sales: number;
  recent_sales: Sale[];
  monthly_trends: MonthlyTrend[];
  rental: RentalData;
  crime: CrimeData;
}

interface CatchmentData {
  suburbs_with_data: string[];
  suburbs_without_data: string[];
  aggregated: CatchmentAggregated | null;
}

interface School {
  name: string;
  type: string;
  school_type?: string;
  suburb: string;
  sector: string;
  naplan_score: number;
  naplan_percentile: number;
  enrollment: number;
  rating: number;
  lat: number;
  lng: number;
  catchment_suburbs: string[];
}

interface SchoolDetailPanelProps {
  school: School;
  catchmentData: CatchmentData | null;
  loading: boolean;
  onClose: () => void;
}

function formatPrice(price: number) {
  if (!price) return '-';
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0,
  }).format(price);
}

function formatPriceShort(price: number) {
  if (!price) return '-';
  if (price >= 1000000) return `$${(price / 1000000).toFixed(1)}M`;
  if (price >= 1000) return `$${(price / 1000).toFixed(0)}K`;
  return `$${price}`;
}

function formatMonth(monthStr: string) {
  const [year, month] = monthStr.split('-');
  return `${year?.slice(2)}/${month}`;
}

function CustomTooltip({ active, payload, label }: any) {
  if (active && payload && payload.length) {
    const data = payload[0].payload;
    return (
      <div className="bg-white p-3 border rounded-lg shadow-lg text-sm">
        <p className="font-semibold text-gray-800">{formatMonth(label)}</p>
        <p className="text-blue-600">中位价: {formatPrice(data.median_price)}</p>
        <p className="text-gray-600">成交: {data.total_sales} 套</p>
      </div>
    );
  }
  return null;
}

const crimeLabels: Record<string, string> = {
  'property_crime': '财产犯罪',
  'theft_fraud': '盗窃/诈骗',
  'violent_crime': '暴力犯罪',
  'drug_offences': '毒品犯罪',
  'public_order': '公共秩序',
  'traffic': '交通违法',
  'other': '其他',
};

const typeLabels: Record<string, string> = {
  primary: '小学',
  secondary: '中学',
  combined: '综合',
};

const sectorLabels: Record<string, string> = {
  Government: '公立',
  Catholic: '天主教',
  Independent: '私立',
};

const propertyTypeLabels: Record<string, string> = {
  house: '别墅',
  unit: '公寓',
  townhouse: '联排',
  apartment: '公寓',
  vacant_land: '空地',
};

export default function SchoolDetailPanel({
  school,
  catchmentData,
  loading,
  onClose,
}: SchoolDetailPanelProps) {
  const [aiLoading, setAiLoading] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);

  const handleAiAnalysis = async () => {
    setAiLoading(true);
    setAiReport(null);

    try {
      const res = await fetch(`${API_BASE}/api/analyze/stream`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          address: `${school.name}, ${school.suburb}`,
          mode: 'school',
        }),
      });

      if (!res.ok) throw new Error('AI analysis failed');

      const reader = res.body?.getReader();
      if (!reader) throw new Error('No stream');

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
            }
          } catch {
            continue;
          }
        }
      }
    } catch {
      setAiReport('AI 分析暂时不可用，请稍后重试。');
    } finally {
      setAiLoading(false);
    }
  };

  const naplanPct = school.naplan_percentile || 0;
  const agg = catchmentData?.aggregated;

  return (
    <div className="p-4 md:p-6 space-y-5">
      {/* Close + Back */}
      <button
        onClick={onClose}
        className="text-sm text-gray-500 hover:text-blue-600 flex items-center gap-1"
      >
        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 19l-7-7 7-7" />
        </svg>
        返回学校列表
      </button>

      {/* 1. School Info */}
      <div className="bg-white rounded-xl shadow-sm border p-5">
        <div className="flex items-start justify-between mb-3">
          <h2 className="text-lg font-bold text-gray-900 leading-tight flex-1 mr-3">
            {school.name}
          </h2>
          <div className="flex gap-1.5 flex-shrink-0">
            <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
              school.type === 'primary' ? 'bg-blue-100 text-blue-700' :
              school.type === 'secondary' ? 'bg-purple-100 text-purple-700' :
              'bg-orange-100 text-orange-700'
            }`}>
              {typeLabels[school.type] || school.type}
            </span>
            <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
              school.sector === 'Government' ? 'bg-green-100 text-green-700' :
              school.sector === 'Catholic' ? 'bg-yellow-100 text-yellow-700' :
              'bg-pink-100 text-pink-700'
            }`}>
              {sectorLabels[school.sector] || school.sector}
            </span>
          </div>
        </div>

        {/* NAPLAN */}
        <div className="mb-3">
          <div className="flex items-center justify-between text-sm mb-1">
            <span className="text-gray-600">NAPLAN</span>
            <span className={`font-bold ${naplanPct >= 80 ? 'text-green-600' : naplanPct >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>
              {naplanPct}%
              {naplanPct >= 80 ? ' 优秀' : naplanPct >= 60 ? ' 良好' : ' 一般'}
            </span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2.5">
            <div
              className={`h-2.5 rounded-full transition-all ${naplanPct >= 80 ? 'bg-green-500' : naplanPct >= 60 ? 'bg-yellow-500' : 'bg-red-500'}`}
              style={{ width: `${Math.min(100, naplanPct)}%` }}
            />
          </div>
        </div>

        {/* Stats Row */}
        <div className="flex gap-4 text-sm text-gray-600 mb-3">
          <span>在读 {school.enrollment || '-'} 人</span>
          <span>评分 {school.rating || '-'}/10</span>
          <span>{school.suburb}</span>
        </div>

        {/* Catchment Suburbs */}
        <div>
          <p className="text-xs text-gray-500 mb-1.5">学区覆盖：</p>
          <div className="flex flex-wrap gap-1.5">
            {school.catchment_suburbs.map((s, i) => {
              const hasData = catchmentData?.suburbs_with_data?.includes(s);
              return (
                <span
                  key={i}
                  className={`text-xs px-2 py-0.5 rounded-full ${
                    hasData ? 'bg-blue-100 text-blue-700' : 'bg-gray-100 text-gray-500'
                  }`}
                >
                  {hasData && '●'} {s}
                </span>
              );
            })}
          </div>
          {catchmentData?.suburbs_without_data && catchmentData.suburbs_without_data.length > 0 && (
            <p className="text-[10px] text-gray-400 mt-1.5">
              ● 标记的 Suburb 有详细市场数据
            </p>
          )}
        </div>
      </div>

      {/* Loading state */}
      {loading && (
        <div className="flex items-center justify-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          <span className="ml-3 text-gray-500 text-sm">正在加载学区数据...</span>
        </div>
      )}

      {/* No data state */}
      {!loading && !agg && (
        <div className="bg-yellow-50 rounded-xl border border-yellow-200 p-5 text-center">
          <p className="text-yellow-800 text-sm mb-1">暂无该学区的房产市场数据</p>
          <p className="text-yellow-600 text-xs">
            目前仅支持: Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton
          </p>
        </div>
      )}

      {/* 2. Price Trends Chart */}
      {agg && agg.monthly_trends.length > 0 && (
        <div className="bg-white rounded-xl shadow-sm border p-5">
          <h3 className="text-sm font-semibold text-gray-900 mb-1">
            学区房价走势
          </h3>
          <p className="text-xs text-gray-400 mb-3">
            学区中位价: {formatPrice(agg.median_price)} | 总成交: {agg.total_sales} 套
          </p>
          <SchoolPriceChart data={agg.monthly_trends} formatMonth={formatMonth} formatPriceShort={formatPriceShort} CustomTooltip={CustomTooltip} />
        </div>
      )}

      {/* 3. Recent Sales */}
      {agg && agg.recent_sales.length > 0 && (
        <div className="bg-white rounded-xl shadow-sm border p-5">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">
            近期成交 ({agg.recent_sales.length})
          </h3>
          <div className="space-y-2">
            {agg.recent_sales.map((sale, i) => (
              <div
                key={i}
                className="flex justify-between items-center py-2 border-b border-gray-50 last:border-b-0"
              >
                <div className="flex-1 min-w-0 pr-3">
                  <p className="text-sm text-gray-900 truncate">{sale.address}</p>
                  <div className="flex items-center gap-2 mt-0.5">
                    <span className="text-[10px] text-blue-600">{sale.suburb}</span>
                    <span className="text-[10px] text-gray-400">
                      {propertyTypeLabels[sale.property_type] || sale.property_type}
                      {sale.bedrooms > 0 ? ` ${sale.bedrooms}卧` : ''}
                      {sale.bathrooms > 0 ? `${sale.bathrooms}卫` : ''}
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
        </div>
      )}

      {/* 4. Rental Yields */}
      {agg && agg.rental && Object.keys(agg.rental).length > 0 && (
        <div className="bg-white rounded-xl shadow-sm border p-5">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">
            租赁回报
          </h3>
          <div className="grid grid-cols-2 gap-3">
            {/* House */}
            <div className="bg-blue-50 rounded-lg p-3">
              <p className="text-xs text-blue-600 font-medium mb-2">House</p>
              <p className="text-lg font-bold text-blue-800">
                {agg.rental.house_rental_yield_pct ? `${agg.rental.house_rental_yield_pct}%` : '-'}
              </p>
              <p className="text-[10px] text-blue-500">
                租金 ${agg.rental.median_house_rent_weekly || '-'}/周
              </p>
            </div>
            {/* Unit */}
            <div className="bg-purple-50 rounded-lg p-3">
              <p className="text-xs text-purple-600 font-medium mb-2">Unit</p>
              <p className="text-lg font-bold text-purple-800">
                {agg.rental.unit_rental_yield_pct ? `${agg.rental.unit_rental_yield_pct}%` : '-'}
              </p>
              <p className="text-[10px] text-purple-500">
                租金 ${agg.rental.median_unit_rent_weekly || '-'}/周
              </p>
            </div>
          </div>
          {agg.rental.vacancy_rate_pct > 0 && (
            <p className="text-xs text-gray-500 mt-2 text-center">
              空置率 {agg.rental.vacancy_rate_pct}%
              {agg.rental.days_on_market_house ? ` | House 上市 ${agg.rental.days_on_market_house} 天` : ''}
            </p>
          )}
        </div>
      )}

      {/* 5. Crime / Safety */}
      {agg && agg.crime && agg.crime.total_crimes > 0 && (
        <div className="bg-white rounded-xl shadow-sm border p-5">
          <h3 className="text-sm font-semibold text-gray-900 mb-1">
            安全指数
          </h3>
          <p className="text-xs text-gray-400 mb-3">
            学区范围过去 12 个月犯罪统计（总计 {agg.crime.total_crimes} 起）
          </p>
          <div className="space-y-2">
            {Object.entries(agg.crime.categories)
              .sort((a, b) => b[1] - a[1])
              .slice(0, 5)
              .map(([cat, count]) => {
                const pct = Math.round((count / agg.crime.total_crimes) * 100);
                return (
                  <div key={cat} className="flex items-center gap-2">
                    <span className="text-xs text-gray-600 w-20 text-right truncate">
                      {crimeLabels[cat] || cat}
                    </span>
                    <div className="flex-1 bg-gray-100 rounded-full h-3 overflow-hidden">
                      <div
                        className="h-full bg-red-400 rounded-full"
                        style={{ width: `${pct}%` }}
                      />
                    </div>
                    <span className="text-xs text-gray-500 w-10">{count}</span>
                  </div>
                );
              })}
          </div>
        </div>
      )}

      {/* 6. AI Analysis */}
      <div className="bg-white rounded-xl shadow-sm border p-5">
        <h3 className="text-sm font-semibold text-gray-900 mb-3">
          Amanda 学区投资分析
        </h3>
        {!aiReport && (
          <PersonaButton
            persona="amanda"
            loading={aiLoading}
            onClick={handleAiAnalysis}
            label="生成学区投资报告"
            fullWidth
            size="sm"
          />
        )}
        {aiReport && (
          <div className="bg-gray-50 rounded-lg p-4 border border-gray-100 max-h-[400px] overflow-y-auto">
            {aiLoading && (
              <div className="flex items-center gap-2 mb-3 text-blue-600">
                <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                <span className="text-sm">Amanda 正在生成中...</span>
              </div>
            )}
            <PersonaMarkdown content={aiReport} variant="compact" />
          </div>
        )}
      </div>
    </div>
  );
}
