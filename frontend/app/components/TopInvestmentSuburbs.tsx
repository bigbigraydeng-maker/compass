'use client';

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
function Sparkline({ data, width = 60, height = 20 }: { data: number[]; width?: number; height?: number }) {
  if (!data || data.length < 2) return null;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const points = data.map((v, i) => {
    const x = (i / (data.length - 1)) * width;
    const y = height - ((v - min) / range) * (height - 4) - 2;
    return `${x},${y}`;
  }).join(' ');

  // Green if trending up, red if down
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

export default function TopInvestmentSuburbs({ suburbStats }: Props) {
  const router = useRouter();

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

  return (
    <section className="py-10 md:py-16 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="mb-6 md:mb-10">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-1">
            Brisbane Suburbs
          </h2>
          <p className="text-sm text-gray-500">
            点击查看区域详情和成交数据
          </p>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-2 md:gap-3">
          {ALL_SUBURBS.map((suburb) => {
            const stat = getStat(suburb);
            const active = hasData(suburb);
            const medianPrice = stat?.median_price || 0;
            const trend = stat?.trend || [];

            return (
              <div
                key={suburb}
                onClick={() => active && router.push(`/suburb/${encodeURIComponent(suburb)}`)}
                className={`relative rounded-xl border p-3 md:p-4 transition-all ${
                  active
                    ? 'border-gray-200 hover:border-blue-400 hover:shadow-md cursor-pointer bg-white'
                    : 'border-gray-100 bg-gray-50 cursor-default opacity-70'
                }`}
              >
                {!active && (
                  <span className="absolute top-1.5 right-1.5 text-[9px] md:text-[10px] font-medium text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded-full border border-amber-200">
                    Soon
                  </span>
                )}
                <div className="flex items-start justify-between gap-1">
                  <div className="min-w-0 flex-1">
                    <h3 className={`font-semibold text-xs md:text-sm leading-tight mb-0.5 truncate ${
                      active ? 'text-gray-900' : 'text-gray-400'
                    }`}>
                      {suburb}
                    </h3>
                    {active && medianPrice > 0 ? (
                      <p className="text-xs text-blue-600 font-medium">
                        {formatPrice(medianPrice)}
                      </p>
                    ) : active ? (
                      <p className="text-xs text-gray-400">-</p>
                    ) : null}
                  </div>
                  {active && trend.length >= 2 && (
                    <div className="flex-shrink-0 mt-0.5">
                      <Sparkline data={trend} width={50} height={18} />
                    </div>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
