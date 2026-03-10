'use client';

import { PersonaMarkdown } from './persona';
import type {
  PropertyData,
  EthanScore,
  ComparableSalesData,
  LeoVerdict,
  MetaData,
} from '../lib/streamAnalysis';

// ====== 主组件 ======

interface AnalysisResultsProps {
  isLoading: boolean;
  meta: MetaData | null;
  propertyData: PropertyData | null;
  ethanScore: EthanScore | null;
  comparableSales: ComparableSalesData | null;
  amandaContent: string;
  leoVerdict: LeoVerdict | null;
  error: string | null;
  onClose: () => void;
}

export default function AnalysisResults({
  isLoading,
  meta,
  propertyData,
  ethanScore,
  comparableSales,
  amandaContent,
  leoVerdict,
  error,
  onClose,
}: AnalysisResultsProps) {
  return (
    <section className="py-8 md:py-12 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* 顶部栏 */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <h2 className="text-xl md:text-2xl font-bold text-gray-900">
              分析报告
            </h2>
            {meta && (
              <span className="text-sm text-gray-500">
                {meta.suburb}区 · {meta.mode === 'general' ? '投资分析' : meta.mode === 'school' ? '学区分析' : meta.mode === 'first_home' ? '首置分析' : '海外购房'}
              </span>
            )}
            {isLoading && (
              <span className="flex items-center gap-1.5 text-blue-600 text-sm">
                <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
                分析中...
              </span>
            )}
          </div>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 text-sm px-3 py-1 rounded hover:bg-gray-100 transition"
          >
            关闭
          </button>
        </div>

        {/* 错误提示 */}
        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
            分析出错: {error}
          </div>
        )}

        {/* 房产卡片 */}
        {propertyData && !propertyData.error && (
          <PropertyCard data={propertyData} />
        )}

        {/* 主内容：Amanda + 侧边栏 */}
        <div className="flex flex-col lg:flex-row gap-6">
          {/* Amanda 分析报告 - 主区域 */}
          <div className="flex-1 min-w-0">
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
              <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 flex items-center justify-center text-white text-sm font-bold">
                  A
                </div>
                <div>
                  <h3 className="font-semibold text-gray-900">Amanda 投资分析</h3>
                  <p className="text-xs text-gray-500">首席房产分析师</p>
                </div>
              </div>

              {amandaContent ? (
                <div className="max-h-[600px] overflow-y-auto pr-2">
                  <PersonaMarkdown content={amandaContent} variant="light" />
                  {isLoading && (
                    <span className="inline-block w-2 h-4 bg-blue-500 animate-pulse ml-1" />
                  )}
                </div>
              ) : isLoading ? (
                <div className="space-y-3 animate-pulse">
                  <div className="h-4 bg-gray-200 rounded w-3/4" />
                  <div className="h-4 bg-gray-200 rounded w-1/2" />
                  <div className="h-4 bg-gray-200 rounded w-5/6" />
                  <div className="h-4 bg-gray-200 rounded w-2/3" />
                </div>
              ) : null}

              {!isLoading && amandaContent && (
                <div className="mt-4 pt-3 border-t border-gray-100 text-center">
                  <span className="text-xs text-gray-400">
                    Powered by Compass AI | {new Date().toLocaleString('zh-CN')}
                  </span>
                </div>
              )}
            </div>
          </div>

          {/* 侧边栏 */}
          <div className="lg:w-80 space-y-4">
            {/* Ethan 评分卡 */}
            {ethanScore && <EthanScoreCard score={ethanScore} />}

            {/* Leo 价格判断 */}
            {leoVerdict && <LeoVerdictCard verdict={leoVerdict} />}

            {/* 可比成交 */}
            {comparableSales && (comparableSales.same_suburb.length > 0 || comparableSales.nearby_suburbs.length > 0) && (
              <ComparableSalesCard data={comparableSales} />
            )}
          </div>
        </div>
      </div>
    </section>
  );
}

// ====== 子组件 ======

function PropertyCard({ data }: { data: PropertyData }) {
  return (
    <div className="mb-6 bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div className="flex flex-col md:flex-row">
        {/* 图片 */}
        {data.images.length > 0 && (
          <div className="md:w-72 h-48 md:h-auto flex-shrink-0">
            <img
              src={data.images[0]}
              alt={data.address}
              className="w-full h-full object-cover"
              onError={(e) => { (e.target as HTMLImageElement).style.display = 'none'; }}
            />
          </div>
        )}
        {/* 信息 */}
        <div className="p-5 flex-1">
          <h3 className="text-lg font-bold text-gray-900 mb-2">{data.address}</h3>
          <div className="flex flex-wrap gap-4 text-sm text-gray-600 mb-3">
            {data.bedrooms > 0 && <span>🛏 {data.bedrooms} 房</span>}
            {data.bathrooms > 0 && <span>🚿 {data.bathrooms} 卫</span>}
            {data.parking > 0 && <span>🚗 {data.parking} 车位</span>}
            {data.land_size > 0 && <span>📐 {data.land_size} sqm</span>}
            {data.property_type && <span className="text-gray-500">{data.property_type}</span>}
          </div>
          {data.price && (
            <p className="text-2xl font-bold text-blue-600">{data.price}</p>
          )}
          {data.description && (
            <p className="text-xs text-gray-500 mt-2 line-clamp-2">{data.description}</p>
          )}
          <div className="mt-2 flex items-center gap-2 text-xs text-gray-400">
            <span className="px-2 py-0.5 bg-gray-100 rounded">{data.source.toUpperCase()}</span>
            {data.suburb && <span>{data.suburb}</span>}
          </div>
        </div>
      </div>
    </div>
  );
}


function EthanScoreCard({ score }: { score: EthanScore }) {
  const gradeColors: Record<string, string> = {
    'A+': 'text-emerald-600', 'A': 'text-emerald-600', 'A-': 'text-emerald-600',
    'B+': 'text-blue-600', 'B': 'text-blue-600', 'B-': 'text-blue-600',
    'C+': 'text-yellow-600', 'C': 'text-yellow-600', 'C-': 'text-yellow-600',
    'D': 'text-red-600', 'F': 'text-red-600',
  };
  const gradeColor = gradeColors[score.grade] || 'text-gray-600';

  const dimensionLabels: Record<string, string> = {
    growth: '增长潜力',
    school: '学区质量',
    land: '土地价值',
    activity: '市场活跃',
    chinese: '华人友好',
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-emerald-200 p-5">
      <div className="flex items-center gap-2 mb-4">
        <div className="w-7 h-7 rounded-full bg-gradient-to-br from-emerald-500 to-teal-500 flex items-center justify-center text-white text-xs font-bold">
          E
        </div>
        <h4 className="font-semibold text-gray-900 text-sm">Ethan 评分卡</h4>
      </div>

      {/* 总分 */}
      <div className="text-center mb-4">
        <span className="text-3xl font-bold text-gray-900">{score.total}</span>
        <span className="text-gray-400 text-lg"> / 100</span>
        <span className={`ml-2 text-xl font-bold ${gradeColor}`}>{score.grade}</span>
      </div>

      {/* 维度条 */}
      <div className="space-y-2.5">
        {Object.entries(score.breakdown || {}).map(([key, item]) => {
          if (!item || typeof item !== 'object') return null;
          const pct = item.max > 0 ? (item.score / item.max) * 100 : 0;
          return (
            <div key={key}>
              <div className="flex justify-between text-xs mb-0.5">
                <span className="text-gray-600">{dimensionLabels[key] || key}</span>
                <span className="text-gray-900 font-medium">{item.score}/{item.max}</span>
              </div>
              <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-emerald-400 to-teal-500 rounded-full transition-all duration-500"
                  style={{ width: `${pct}%` }}
                />
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}


function LeoVerdictCard({ verdict }: { verdict: LeoVerdict }) {
  const verdictConfig: Record<string, { bg: string; border: string; icon: string; textColor: string }> = {
    '值得买': { bg: 'bg-green-50', border: 'border-green-300', icon: '🟢', textColor: 'text-green-700' },
    '观望': { bg: 'bg-yellow-50', border: 'border-yellow-300', icon: '🟡', textColor: 'text-yellow-700' },
    '不建议': { bg: 'bg-red-50', border: 'border-red-300', icon: '🔴', textColor: 'text-red-700' },
  };
  const config = verdictConfig[verdict.verdict] || verdictConfig['观望'];

  return (
    <div className={`rounded-xl shadow-sm border ${config.border} ${config.bg} p-5`}>
      <div className="flex items-center gap-2 mb-3">
        <div className="w-7 h-7 rounded-full bg-gradient-to-br from-orange-500 to-red-500 flex items-center justify-center text-white text-xs font-bold">
          L
        </div>
        <h4 className="font-semibold text-gray-900 text-sm">Leo 价格判断</h4>
      </div>

      <div className="text-center mb-3">
        <span className="text-2xl mr-2">{config.icon}</span>
        <span className={`text-xl font-bold ${config.textColor}`}>{verdict.verdict}</span>
      </div>

      <div className="space-y-2 text-sm">
        {verdict.fair_price_range && (
          <div className="flex justify-between">
            <span className="text-gray-500">合理价格</span>
            <span className="font-medium text-gray-900">{verdict.fair_price_range}</span>
          </div>
        )}
        {verdict.confidence && (
          <div className="flex justify-between">
            <span className="text-gray-500">置信度</span>
            <span className="font-medium text-gray-900">{verdict.confidence}</span>
          </div>
        )}
        {verdict.reason && (
          <p className="text-xs text-gray-600 mt-2 pt-2 border-t border-gray-200/50">
            {verdict.reason}
          </p>
        )}
      </div>
    </div>
  );
}


function ComparableSalesCard({ data }: { data: ComparableSalesData }) {
  const stats = data.stats;
  const same = data.same_suburb;
  const nearby = data.nearby_suburbs;

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5">
      <h4 className="font-semibold text-gray-900 text-sm mb-3 flex items-center gap-2">
        <span className="text-base">📊</span>
        可比成交
      </h4>

      {/* 统计摘要 */}
      {stats.same_suburb_count && stats.same_suburb_count > 0 && (
        <div className="mb-3 p-3 bg-blue-50 rounded-lg">
          <div className="text-xs text-blue-600 mb-1">同区 {stats.same_suburb_count} 套成交</div>
          <div className="text-lg font-bold text-gray-900">
            ${(stats.same_suburb_median || 0).toLocaleString()}
          </div>
          <div className="text-xs text-gray-500">
            区间 ${(stats.same_suburb_min || 0).toLocaleString()} ~ ${(stats.same_suburb_max || 0).toLocaleString()}
          </div>
          {stats.price_trend_6m && (
            <div className={`text-xs mt-1 font-medium ${
              stats.price_trend_6m.startsWith('+') ? 'text-green-600' : 'text-red-600'
            }`}>
              近6月趋势: {stats.price_trend_6m}
            </div>
          )}
        </div>
      )}

      {/* 最近成交列表 */}
      {same.length > 0 && (
        <div className="space-y-2">
          <p className="text-xs text-gray-500 font-medium">最近成交</p>
          {same.slice(0, 3).map((s, i) => (
            <div key={i} className="text-xs text-gray-600 py-1.5 border-b border-gray-100 last:border-0">
              <div className="font-medium text-gray-800">${s.price.toLocaleString()}</div>
              <div className="text-gray-500 truncate">{s.address}</div>
              <div className="text-gray-400">{s.date} · {s.type} {s.beds}房{s.baths}卫</div>
            </div>
          ))}
        </div>
      )}

      {/* 周边可比 */}
      {nearby.length > 0 && stats.nearby_median && (
        <div className="mt-3 pt-3 border-t border-gray-100">
          <div className="text-xs text-gray-500 mb-1">
            周边 {stats.nearby_count || nearby.length} 套 · 中位价 ${stats.nearby_median.toLocaleString()}
          </div>
        </div>
      )}
    </div>
  );
}
