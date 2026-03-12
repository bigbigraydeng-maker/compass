'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ALL_SUBURBS, CORE_SUBURBS } from '../lib/suburbs';

interface SuburbStat {
  suburb: string;
  median_price: number;
  total_sales: number;
  trend?: number[];
}

interface Props {
  suburbStats: SuburbStat[];
}

/** SVG sparkline — mini stock-style trend line */
function Sparkline({ data, width = 50, height = 18 }: { data: number[]; width?: number; height?: number }) {
  if (!data || data.length < 2) return null;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const points = data.map((v, i) => {
    const x = (i / (data.length - 1)) * width;
    const y = height - ((v - min) / range) * (height - 4) - 2;
    return `${x},${y}`;
  }).join(' ');

  const trending = data[data.length - 1] >= data[0];
  const color = trending ? '#22c55e' : '#ef4444';

  return (
    <svg width={width} height={height} className="block">
      <polyline
        points={points}
        fill="none"
        stroke={color}
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

/** Skeleton sparkline placeholder */
function SparklineSkeleton() {
  return (
    <div className="w-[50px] h-[18px] bg-gray-200 rounded animate-pulse" />
  );
}

export default function TopInvestmentSuburbs({ suburbStats }: Props) {
  const router = useRouter();
  const [showAll, setShowAll] = useState(false);
  const isLoading = suburbStats.length === 0;

  const formatPrice = (price: number) => {
    if (!price) return '-';
    if (price >= 1000000) return `$${(price / 1000000).toFixed(1)}M`;
    if (price >= 1000) return `$${(price / 1000).toFixed(0)}K`;
    return `$${price}`;
  };

  const getStat = (suburb: string): SuburbStat | undefined => {
    return suburbStats.find(
      s => s.suburb.toLowerCase() === suburb.toLowerCase()
    );
  };

  const hasData = (suburb: string): boolean => {
    return CORE_SUBURBS.some(
      s => s.toLowerCase() === suburb.toLowerCase()
    );
  };

  const EXTENDED_SUBURBS = ALL_SUBURBS.slice(7);
  const displaySuburbs = showAll ? ALL_SUBURBS : CORE_SUBURBS;

  return (
    <section className="py-8 md:py-12 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-4 md:mb-6">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-1">
            Brisbane Suburbs
          </h2>
          <p className="text-sm text-gray-500">
            点击查看区域详情和成交数据
          </p>
        </div>

        {/* Core suburbs — compact grid */}
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-7 gap-2 md:gap-3">
          {(showAll ? [...CORE_SUBURBS] : [...CORE_SUBURBS]).map((suburb) => {
            const stat = getStat(suburb);
            const medianPrice = stat?.median_price || 0;
            const trend = stat?.trend || [];

            return (
              <div
                key={suburb}
                onClick={() => router.push(`/suburb/${encodeURIComponent(suburb)}`)}
                className="rounded-xl border border-gray-200 hover:border-blue-400 hover:shadow-md cursor-pointer bg-white p-3 transition-all"
              >
                <div className="flex items-start justify-between gap-1">
                  <div className="min-w-0 flex-1">
                    <h3 className="font-semibold text-xs md:text-sm leading-tight mb-0.5 truncate text-gray-900">
                      {suburb === 'Eight Mile Plains' ? 'EMP' : suburb}
                    </h3>
                    {isLoading ? (
                      <div className="w-10 h-3 bg-gray-200 rounded animate-pulse mt-1" />
                    ) : medianPrice > 0 ? (
                      <p className="text-xs text-blue-600 font-medium">
                        {formatPrice(medianPrice)}
                      </p>
                    ) : (
                      <p className="text-xs text-gray-400">-</p>
                    )}
                  </div>
                  <div className="flex-shrink-0 mt-0.5">
                    {isLoading ? (
                      <SparklineSkeleton />
                    ) : trend.length >= 2 ? (
                      <Sparkline data={trend} />
                    ) : null}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Extended suburbs — collapsible */}
        {showAll && (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 lg:grid-cols-5 gap-2 md:gap-3 mt-3">
            {EXTENDED_SUBURBS.map((suburb) => (
              <div
                key={suburb}
                className="rounded-xl border border-gray-100 bg-gray-50 p-3 opacity-70 cursor-default"
              >
                <div className="flex items-center justify-between">
                  <h3 className="font-medium text-xs text-gray-400 truncate">
                    {suburb}
                  </h3>
                  <span className="text-[9px] font-medium text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded-full border border-amber-200 flex-shrink-0 ml-1">
                    Soon
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Toggle button */}
        <div className="text-center mt-4">
          <button
            onClick={() => setShowAll(!showAll)}
            className="text-sm text-gray-500 hover:text-blue-600 transition-colors"
          >
            {showAll ? '收起 ▲' : `查看全部 ${ALL_SUBURBS.length} 个区域 ▼`}
          </button>
        </div>
      </div>
    </section>
  );
}
