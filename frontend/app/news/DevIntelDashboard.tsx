'use client';

import { PersonaAvatar } from '../components/persona';

// ---- Types ----

interface InfraProject {
  project_name: string;
  authority: string | null;
  stage: string | null;
  affected_suburbs: string[];
  last_update: string | null;
  document_count: number;
}

interface MonthlyTrend {
  month: string;
  doc_type: string;
  count: number;
}

interface RecentDevDoc {
  id: number;
  title: string;
  source_name: string;
  doc_type: string | null;
  suburb: string | null;
  created_at: string | null;
  url: string;
}

interface ActiveSuburb {
  suburb: string;
  document_count: number;
}

export interface TrendsData {
  projects: InfraProject[];
  monthly_trends: MonthlyTrend[];
  recent_documents: RecentDevDoc[];
  active_suburbs: ActiveSuburb[];
}

interface DashboardProps {
  data: TrendsData | null;
  loading: boolean;
}

// ---- Constants ----

const STAGE_STYLES: Record<string, { label: string; bg: string; text: string }> = {
  proposed: { label: '规划中', bg: 'bg-yellow-100', text: 'text-yellow-700' },
  approved: { label: '已批准', bg: 'bg-green-100', text: 'text-green-700' },
  under_construction: { label: '建设中', bg: 'bg-blue-100', text: 'text-blue-700' },
  completed: { label: '已完工', bg: 'bg-emerald-100', text: 'text-emerald-700' },
  cancelled: { label: '已取消', bg: 'bg-gray-100', text: 'text-gray-500' },
};

const DOC_TYPE_COLORS: Record<string, string> = {
  development_scheme: 'bg-blue-400',
  infrastructure_plan: 'bg-purple-400',
  precinct_plan: 'bg-indigo-400',
  context_plan: 'bg-cyan-400',
  master_plan: 'bg-violet-400',
  gazette_notice: 'bg-orange-400',
  submissions_report: 'bg-teal-400',
  environment_report: 'bg-emerald-400',
  fact_sheet: 'bg-amber-400',
  government_pdf: 'bg-slate-400',
  web_page: 'bg-gray-400',
  council_minutes: 'bg-rose-400',
  transport_plan: 'bg-sky-400',
};

const DOC_TYPE_LABELS: Record<string, string> = {
  development_scheme: '开发规划',
  infrastructure_plan: '基建规划',
  precinct_plan: '片区规划',
  context_plan: '上下文规划',
  master_plan: '总体规划',
  gazette_notice: '公报通知',
  submissions_report: '意见报告',
  environment_report: '环境报告',
  fact_sheet: '概况表',
  government_pdf: '政府文件',
  web_page: '网页',
  council_minutes: '议会纪要',
  transport_plan: '交通规划',
};

function formatDocType(dt: string): string {
  return DOC_TYPE_LABELS[dt] || dt.replace(/_/g, ' ');
}

function formatMonth(m: string): string {
  const parts = m.split('-');
  if (parts.length === 2) return `${parts[1]}月`;
  return m;
}

function formatTimeAgo(dateStr: string | null): string {
  if (!dateStr) return '';
  try {
    const d = new Date(dateStr);
    const now = new Date();
    const diffMs = now.getTime() - d.getTime();
    const days = Math.floor(diffMs / 86400000);
    if (days === 0) return '今天';
    if (days === 1) return '昨天';
    if (days < 7) return `${days}天前`;
    if (days < 30) return `${Math.floor(days / 7)}周前`;
    return `${Math.floor(days / 30)}月前`;
  } catch {
    return '';
  }
}

// ---- Component ----

export default function DevIntelDashboard({ data, loading }: DashboardProps) {
  if (loading || !data) {
    return (
      <div className="space-y-6">
        {[1, 2, 3, 4].map(i => (
          <div key={i} className="bg-white rounded-xl border p-6 animate-pulse">
            <div className="h-4 bg-gray-200 rounded w-1/3 mb-4" />
            <div className="h-20 bg-gray-100 rounded" />
          </div>
        ))}
      </div>
    );
  }

  const { projects, monthly_trends, recent_documents, active_suburbs } = data;

  // Compute monthly chart data
  const monthSet = Array.from(new Set(monthly_trends.map(t => t.month))).sort();
  const docTypes = Array.from(new Set(monthly_trends.map(t => t.doc_type)));
  const monthTotals: Record<string, number> = {};
  for (const m of monthSet) {
    monthTotals[m] = monthly_trends.filter(t => t.month === m).reduce((s, t) => s + t.count, 0);
  }
  const maxMonthTotal = Math.max(...Object.values(monthTotals), 1);
  const maxSuburbCount = active_suburbs.length > 0 ? active_suburbs[0].document_count : 1;

  return (
    <div className="space-y-8">
      {/* Section Header */}
      <div className="flex items-center gap-3">
        <PersonaAvatar persona="olivia" size="sm" />
        <div>
          <h2 className="text-lg font-bold text-gray-900">开发情报</h2>
          <p className="text-xs text-purple-600">布里斯班开发规划 · 基建项目 · 审批文件追踪</p>
        </div>
      </div>

      {/* A. Infrastructure Project Tracker */}
      {projects.length > 0 && (
        <section>
          <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
            <span>🏗️</span> 基建项目追踪
            <span className="text-xs font-normal text-gray-400 ml-1">({projects.length})</span>
          </h3>
          <div className="grid md:grid-cols-2 gap-3">
            {projects.slice(0, 8).map(p => {
              const stageInfo = STAGE_STYLES[p.stage || ''] || { label: p.stage || '未知', bg: 'bg-gray-100', text: 'text-gray-600' };
              return (
                <div
                  key={p.project_name}
                  className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-4"
                >
                  <div className="flex items-start justify-between mb-2">
                    <h4 className="text-sm font-bold text-gray-900 flex-1 min-w-0 mr-2">{p.project_name}</h4>
                    <span className={`flex-shrink-0 px-2 py-0.5 rounded-full text-[10px] font-medium ${stageInfo.bg} ${stageInfo.text}`}>
                      {stageInfo.label}
                    </span>
                  </div>
                  {p.authority && (
                    <p className="text-[10px] text-gray-500 mb-2">{p.authority}</p>
                  )}
                  <div className="flex items-center gap-2 flex-wrap mb-2">
                    {p.affected_suburbs.slice(0, 3).map(s => (
                      <span key={s} className="px-1.5 py-0.5 rounded text-[10px] bg-purple-100 text-purple-700">{s}</span>
                    ))}
                    {p.affected_suburbs.length > 3 && (
                      <span className="text-[10px] text-gray-400">+{p.affected_suburbs.length - 3}</span>
                    )}
                  </div>
                  <div className="flex items-center justify-between text-[10px] text-gray-400">
                    <span>{p.document_count} 份文档</span>
                    <span>{formatTimeAgo(p.last_update)} 更新</span>
                  </div>
                </div>
              );
            })}
          </div>
        </section>
      )}

      {/* B. Monthly Approval Trends */}
      {monthSet.length > 0 && (
        <section className="bg-white rounded-xl border border-gray-200 p-5">
          <h3 className="text-sm font-semibold text-gray-800 mb-4 flex items-center gap-1.5">
            <span>📊</span> 审批趋势（近6个月）
          </h3>
          <div className="space-y-2.5">
            {monthSet.map(month => {
              const items = monthly_trends.filter(t => t.month === month);
              const total = monthTotals[month];
              return (
                <div key={month} className="flex items-center gap-3">
                  <span className="text-xs text-gray-500 w-10 flex-shrink-0 text-right">{formatMonth(month)}</span>
                  <div className="flex-1 flex gap-px h-5 rounded-md overflow-hidden bg-gray-100">
                    {items.map(item => (
                      <div
                        key={item.doc_type}
                        className={`${DOC_TYPE_COLORS[item.doc_type] || 'bg-gray-300'} transition-all`}
                        style={{ width: `${Math.max(2, (item.count / maxMonthTotal) * 100)}%` }}
                        title={`${formatDocType(item.doc_type)}: ${item.count}`}
                      />
                    ))}
                  </div>
                  <span className="text-xs text-gray-400 w-8 text-right font-medium">{total}</span>
                </div>
              );
            })}
          </div>
          {/* Legend */}
          <div className="mt-4 pt-3 border-t border-gray-100 flex flex-wrap gap-3">
            {docTypes.slice(0, 8).map(dt => (
              <div key={dt} className="flex items-center gap-1">
                <div className={`w-2.5 h-2.5 rounded-sm ${DOC_TYPE_COLORS[dt] || 'bg-gray-300'}`} />
                <span className="text-[10px] text-gray-500">{formatDocType(dt)}</span>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* C + D side by side */}
      <div className="grid md:grid-cols-5 gap-6">
        {/* C. Recent Planning Documents */}
        <section className="md:col-span-3">
          <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
            <span>📄</span> 最新规划文件
          </h3>
          <div className="space-y-2">
            {recent_documents.length === 0 ? (
              <div className="bg-white rounded-xl border p-6 text-center text-gray-400 text-sm">暂无文档数据</div>
            ) : (
              recent_documents.map(doc => (
                <div
                  key={doc.id}
                  className="bg-white rounded-xl border border-gray-200 hover:border-purple-200 transition-colors p-3.5"
                >
                  <div className="flex items-start justify-between gap-2">
                    <div className="flex-1 min-w-0">
                      <a
                        href={doc.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-sm font-medium text-gray-900 hover:text-purple-600 line-clamp-1 transition-colors"
                      >
                        {doc.title}
                      </a>
                      <div className="flex items-center gap-1.5 mt-1 flex-wrap">
                        {doc.doc_type && (
                          <span className="px-1.5 py-0.5 rounded text-[10px] font-medium bg-blue-50 text-blue-600">
                            {formatDocType(doc.doc_type)}
                          </span>
                        )}
                        {doc.suburb && (
                          <span className="px-1.5 py-0.5 rounded text-[10px] font-medium bg-purple-50 text-purple-600">
                            {doc.suburb}
                          </span>
                        )}
                        <span className="text-[10px] text-gray-400">{doc.source_name}</span>
                      </div>
                    </div>
                    <span className="text-[10px] text-gray-400 flex-shrink-0">{formatTimeAgo(doc.created_at)}</span>
                  </div>
                </div>
              ))
            )}
          </div>
        </section>

        {/* D. Active Suburbs */}
        <section className="md:col-span-2">
          <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
            <span>🔥</span> 热点区域
          </h3>
          <div className="bg-white rounded-xl border border-gray-200 p-4 space-y-2.5">
            {active_suburbs.length === 0 ? (
              <p className="text-center text-gray-400 text-sm py-4">暂无数据</p>
            ) : (
              active_suburbs.slice(0, 10).map((s, i) => (
                <div key={s.suburb} className="flex items-center gap-2.5">
                  <span className="text-[10px] text-gray-400 w-4 text-right font-medium">{i + 1}</span>
                  <span className="text-xs text-gray-700 w-28 truncate">{s.suburb}</span>
                  <div className="flex-1 bg-gray-100 rounded-full h-2">
                    <div
                      className="bg-gradient-to-r from-purple-400 to-pink-400 h-2 rounded-full transition-all"
                      style={{ width: `${Math.max(8, (s.document_count / maxSuburbCount) * 100)}%` }}
                    />
                  </div>
                  <span className="text-[10px] text-gray-500 font-medium w-6 text-right">{s.document_count}</span>
                </div>
              ))
            )}
          </div>
        </section>
      </div>
    </div>
  );
}
