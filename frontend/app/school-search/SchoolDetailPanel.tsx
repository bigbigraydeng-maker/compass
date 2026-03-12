'use client';

import { useState, useMemo, useEffect } from 'react';
import dynamic from 'next/dynamic';
import { PersonaButton, PersonaMarkdown } from '../components/persona';
import { buildDomainSearchUrl } from '../lib/postcodes';

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

/** Mini budget calculator for catchment area */
function CatchmentBudget({ medianPrice }: { medianPrice: number }) {
  const deposits = [5, 10, 20];
  const rate = 6.5;
  const term = 30;

  const calc = (depositPct: number) => {
    const deposit = medianPrice * (depositPct / 100);
    const loan = medianPrice - deposit;
    const mr = rate / 100 / 12;
    const tm = term * 12;
    const monthly = mr > 0
      ? loan * (mr * Math.pow(1 + mr, tm)) / (Math.pow(1 + mr, tm) - 1)
      : loan / tm;
    return {
      deposit: Math.round(deposit),
      loan: Math.round(loan),
      monthly: Math.round(monthly),
      weekly: Math.round(monthly * 12 / 52),
    };
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border p-5">
      <h3 className="text-sm font-semibold text-gray-900 mb-1">
        学区购房预算
      </h3>
      <p className="text-xs text-gray-400 mb-3">
        基于学区中位价 {formatPrice(medianPrice)}，利率 {rate}%，{term}年贷款
      </p>
      <div className="grid grid-cols-3 gap-2">
        {deposits.map((pct) => {
          const r = calc(pct);
          return (
            <div key={pct} className={`rounded-lg p-3 text-center border ${pct === 20 ? 'border-blue-300 bg-blue-50' : 'border-gray-200 bg-gray-50'}`}>
              <p className="text-[10px] text-gray-500 mb-1">{pct}% 首付</p>
              <p className="text-xs font-bold text-gray-900">{formatPriceShort(r.deposit)}</p>
              <div className="border-t border-gray-200 my-1.5" />
              <p className="text-[10px] text-gray-500">月供</p>
              <p className="text-sm font-bold text-blue-600">{formatPriceShort(r.monthly)}</p>
              <p className="text-[10px] text-gray-400">周供 {formatPriceShort(r.weekly)}</p>
            </div>
          );
        })}
      </div>
      {medianPrice <= 750000 && (
        <p className="text-[10px] text-green-600 mt-2 text-center">
          * 首次购房者可能符合 $30,000 FHOG 补贴
        </p>
      )}
    </div>
  );
}

export default function SchoolDetailPanel({
  school,
  catchmentData,
  loading,
  onClose,
}: SchoolDetailPanelProps) {
  const [aiLoading, setAiLoading] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);
  const [suburbListings, setSuburbListings] = useState<Record<string, any[]>>({});
  const [listingsLoading, setListingsLoading] = useState(false);
  const [expandedSuburb, setExpandedSuburb] = useState<string | null>(null);

  // 获取每个学区 suburb 的在售房源
  useEffect(() => {
    if (!school.catchment_suburbs?.length) return;
    setListingsLoading(true);
    setSuburbListings({});

    Promise.all(
      school.catchment_suburbs.map(async (suburb) => {
        try {
          const res = await fetch(`${API_BASE}/api/domain/listings?suburb=${encodeURIComponent(suburb)}&page_size=5`);
          if (!res.ok) return [suburb, []] as const;
          const data = await res.json();
          return [suburb, data.listings || []] as const;
        } catch {
          return [suburb, []] as const;
        }
      })
    ).then((results) => {
      const map: Record<string, any[]> = {};
      for (const [suburb, listings] of results) {
        map[suburb] = listings;
      }
      setSuburbListings(map);
      setListingsLoading(false);
    });
  }, [school.name]);

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

      {/* 6. Catchment Budget Mini-Calculator */}
      {agg && agg.median_price > 0 && (
        <CatchmentBudget medianPrice={agg.median_price} />
      )}

      {/* 7. AI Analysis */}
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

      {/* 8. Domain Listing Links — 升级为内嵌房源 */}
      <div className="bg-white rounded-xl shadow-sm border p-5">
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-sm font-semibold text-gray-900">
            学区在售房源
          </h3>
          {listingsLoading && (
            <div className="w-4 h-4 border-2 border-gray-200 border-t-blue-500 rounded-full animate-spin" />
          )}
        </div>
        <div className="space-y-2">
          {school.catchment_suburbs.map((suburb) => {
            const listings = suburbListings[suburb] || [];
            const isExpanded = expandedSuburb === suburb;
            const totalCount = listings.length;

            return (
              <div key={suburb} className="rounded-lg border border-gray-200 overflow-hidden">
                {/* Suburb header */}
                <div
                  className="flex items-center justify-between p-3 hover:bg-gray-50 cursor-pointer transition-colors"
                  onClick={() => setExpandedSuburb(isExpanded ? null : suburb)}
                >
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-medium text-gray-900">{suburb}</span>
                    {totalCount > 0 && (
                      <span className="text-[10px] bg-blue-100 text-blue-700 px-1.5 py-0.5 rounded-full font-medium">
                        {totalCount} 套在售
                      </span>
                    )}
                    {!listingsLoading && totalCount === 0 && (
                      <span className="text-[10px] text-gray-400">暂无数据</span>
                    )}
                  </div>
                  <div className="flex items-center gap-2">
                    <a
                      href={buildDomainSearchUrl(suburb)}
                      target="_blank"
                      rel="noopener noreferrer"
                      onClick={(e) => e.stopPropagation()}
                      className="text-[10px] text-gray-400 hover:text-blue-600 transition-colors"
                    >
                      Domain →
                    </a>
                    {totalCount > 0 && (
                      <svg className={`w-3 h-3 text-gray-400 transition-transform ${isExpanded ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                      </svg>
                    )}
                  </div>
                </div>

                {/* Expanded listing cards */}
                {isExpanded && totalCount > 0 && (
                  <div className="border-t border-gray-100 px-3 py-2 space-y-2 bg-gray-50/50">
                    {listings.slice(0, 5).map((l: any, idx: number) => (
                      <div key={l.id || idx} className="flex gap-2 items-start">
                        {l.image_url && (
                          <img src={l.image_url} alt="" className="w-16 h-12 object-cover rounded flex-shrink-0" loading="lazy" />
                        )}
                        <div className="flex-1 min-w-0">
                          <p className="text-xs text-gray-900 truncate">{l.headline || l.address}</p>
                          <p className="text-[10px] text-gray-400">
                            {l.bedrooms > 0 && `${l.bedrooms}卧 `}
                            {l.bathrooms > 0 && `${l.bathrooms}卫 `}
                            {l.car_spaces > 0 && `${l.car_spaces}车位`}
                          </p>
                        </div>
                        <div className="text-right flex-shrink-0">
                          <p className="text-xs font-bold text-blue-600">{l.price_text || '面议'}</p>
                          {l.domain_url && (
                            <a href={l.domain_url} target="_blank" rel="noopener noreferrer" className="text-[10px] text-gray-400 hover:text-blue-500">详情</a>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            );
          })}
        </div>
        <p className="text-[10px] text-gray-300 text-center mt-3">数据来源: Domain.com.au</p>
      </div>
    </div>
  );
}
