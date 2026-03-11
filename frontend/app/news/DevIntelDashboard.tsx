'use client';

import { useState, useCallback } from 'react';
import Link from 'next/link';
import { PersonaAvatar } from '../components/persona';
import { fetcher } from '../lib/api';

// ---- Types ----

interface InfraProject {
  project_name: string;
  authority: string | null;
  stage: string | null;
  affected_suburbs: string[];
  last_update: string | null;
  document_count: number;
  analysis?: string;
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
  const [expandedProject, setExpandedProject] = useState<string | null>(null);
  const [projectAnalysisCache, setProjectAnalysisCache] = useState<Record<string, string>>({});
  const [loadingAnalysis, setLoadingAnalysis] = useState<Set<string>>(new Set());

  const handleProjectAnalysis = useCallback(async (projectName: string) => {
    if (projectAnalysisCache[projectName] || loadingAnalysis.has(projectName)) return;
    setLoadingAnalysis(prev => new Set(prev).add(projectName));
    try {
      const data = await fetcher(`/api/devintel/project-analysis?project_name=${encodeURIComponent(projectName)}`);
      if (data?.analysis) {
        setProjectAnalysisCache(prev => ({ ...prev, [projectName]: data.analysis }));
      }
    } catch {
      setProjectAnalysisCache(prev => ({ ...prev, [projectName]: '分析生成失败，请稍后再试' }));
    } finally {
      setLoadingAnalysis(prev => {
        const next = new Set(prev);
        next.delete(projectName);
        return next;
      });
    }
  }, [projectAnalysisCache, loadingAnalysis]);

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
  const totalDocs = Object.values(monthTotals).reduce((s, v) => s + v, 0);

  // 计算趋势
  const lastTwo = monthSet.slice(-2);
  let trendText = '';
  let trendIcon = '';
  if (lastTwo.length === 2) {
    const prev = monthTotals[lastTwo[0]] || 0;
    const curr = monthTotals[lastTwo[1]] || 0;
    if (prev > 0) {
      const pct = Math.round(((curr - prev) / prev) * 100);
      if (pct > 0) {
        trendIcon = '↑';
        trendText = `较上月增长 ${pct}%`;
      } else if (pct < 0) {
        trendIcon = '↓';
        trendText = `较上月减少 ${Math.abs(pct)}%`;
      } else {
        trendIcon = '→';
        trendText = '与上月持平';
      }
    }
  }

  // 主要文档类型
  const topDocTypes = docTypes.slice(0, 3).map(dt => formatDocType(dt));

  // Olivia 洞察总结
  const insightText = `近${monthSet.length}个月共追踪 ${totalDocs} 份审批文件，覆盖 ${active_suburbs.length} 个区域，${projects.length} 个基建项目。${trendText ? `审批文件${trendText}，` : ''}${topDocTypes.length > 0 ? `以${topDocTypes.join('、')}类文件为主。` : ''}`;

  return (
    <div className="space-y-6">
      {/* Header + Olivia Insight */}
      <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5">
        <div className="flex items-start gap-3">
          <PersonaAvatar persona="olivia" size="md" />
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-1">
              <h2 className="text-lg font-bold text-gray-900">开发情报中心</h2>
              <span className="text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-medium">Data Center</span>
            </div>
            <p className="text-sm text-gray-600 leading-relaxed">{insightText}</p>
          </div>
        </div>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        <div className="bg-white rounded-xl border p-4 text-center">
          <p className="text-2xl font-bold text-purple-600 font-mono">{totalDocs}</p>
          <p className="text-xs text-gray-500 mt-1">审批文件</p>
        </div>
        <div className="bg-white rounded-xl border p-4 text-center">
          <p className="text-2xl font-bold text-blue-600 font-mono">{projects.length}</p>
          <p className="text-xs text-gray-500 mt-1">基建项目</p>
        </div>
        <div className="bg-white rounded-xl border p-4 text-center">
          <p className="text-2xl font-bold text-emerald-600 font-mono">{active_suburbs.length}</p>
          <p className="text-xs text-gray-500 mt-1">覆盖区域</p>
        </div>
        <div className="bg-white rounded-xl border p-4 text-center">
          <p className="text-2xl font-bold text-amber-600 font-mono">{docTypes.length}</p>
          <p className="text-xs text-gray-500 mt-1">文档类型</p>
        </div>
      </div>

      {/* A. Infrastructure Project Tracker with AI Analysis */}
      {projects.length > 0 && (
        <section>
          <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
            <span>🏗️</span> 基建项目追踪
            <span className="text-xs font-normal text-gray-400 ml-1">({projects.length})</span>
          </h3>
          <div className="grid md:grid-cols-2 gap-3">
            {projects.slice(0, 8).map(p => {
              const stageInfo = STAGE_STYLES[p.stage || ''] || { label: p.stage || '未知', bg: 'bg-gray-100', text: 'text-gray-600' };
              const isExpanded = expandedProject === p.project_name;
              const analysis = projectAnalysisCache[p.project_name] || p.analysis;
              const isAnalysisLoading = loadingAnalysis.has(p.project_name);

              return (
                <div
                  key={p.project_name}
                  className={`rounded-xl border transition-all ${
                    isExpanded
                      ? 'bg-gradient-to-br from-purple-50 via-white to-pink-50 border-purple-200 shadow-sm'
                      : 'bg-gradient-to-br from-purple-50 via-white to-pink-50 border-purple-100'
                  }`}
                >
                  <div
                    className="p-4 cursor-pointer"
                    onClick={() => {
                      const next = isExpanded ? null : p.project_name;
                      setExpandedProject(next);
                      if (next && !analysis && !isAnalysisLoading) {
                        handleProjectAnalysis(p.project_name);
                      }
                    }}
                  >
                    <div className="flex items-start justify-between mb-2">
                      <h4 className="text-sm font-bold text-gray-900 flex-1 min-w-0 mr-2">{p.project_name}</h4>
                      <div className="flex items-center gap-1.5 flex-shrink-0">
                        <span className={`px-2 py-0.5 rounded-full text-[10px] font-medium ${stageInfo.bg} ${stageInfo.text}`}>
                          {stageInfo.label}
                        </span>
                        <span className={`text-xs text-gray-400 transition-transform ${isExpanded ? 'rotate-180' : ''}`}>▼</span>
                      </div>
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

                  {/* Expanded AI Analysis */}
                  {isExpanded && (
                    <div className="px-4 pb-4 border-t border-purple-100">
                      <div className="mt-3">
                        <div className="flex items-center gap-2 mb-2">
                          <PersonaAvatar persona="olivia" size="sm" />
                          <span className="text-xs font-semibold text-purple-700">Olivia 投资分析</span>
                        </div>
                        {isAnalysisLoading && !analysis ? (
                          <div className="flex items-center gap-2 py-3">
                            <svg className="animate-spin h-4 w-4 text-purple-500" viewBox="0 0 24 24">
                              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                            </svg>
                            <span className="text-xs text-purple-600">正在生成分析...</span>
                          </div>
                        ) : analysis ? (
                          <p className="text-sm text-gray-700 leading-relaxed bg-white/60 rounded-lg p-3 border border-purple-50">
                            {analysis}
                          </p>
                        ) : (
                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleProjectAnalysis(p.project_name);
                            }}
                            className="text-xs text-purple-600 hover:text-purple-700 font-medium"
                          >
                            点击生成 AI 分析
                          </button>
                        )}
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </section>
      )}

      {/* B. Monthly Approval Trends - Redesigned */}
      {monthSet.length > 0 && (
        <section className="bg-white rounded-xl border border-gray-200 p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-semibold text-gray-800 flex items-center gap-1.5">
              <span>📊</span> 审批趋势（近{monthSet.length}个月）
            </h3>
            {trendText && (
              <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${
                trendIcon === '↑' ? 'bg-green-100 text-green-700' :
                trendIcon === '↓' ? 'bg-red-100 text-red-700' :
                'bg-gray-100 text-gray-600'
              }`}>
                {trendIcon} {trendText}
              </span>
            )}
          </div>

          {/* Vertical Bar Chart */}
          <div className="flex items-end gap-2 h-32 mb-3">
            {monthSet.map(month => {
              const total = monthTotals[month];
              const heightPct = Math.max(8, (total / maxMonthTotal) * 100);
              return (
                <div key={month} className="flex-1 flex flex-col items-center gap-1">
                  <span className="text-[10px] font-mono text-gray-600 font-medium">{total}</span>
                  <div className="w-full flex flex-col justify-end" style={{ height: '100px' }}>
                    <div
                      className="w-full bg-gradient-to-t from-purple-500 to-purple-300 rounded-t-md transition-all"
                      style={{ height: `${heightPct}%` }}
                    />
                  </div>
                  <span className="text-[10px] text-gray-500">{formatMonth(month)}</span>
                </div>
              );
            })}
          </div>

          {/* Top Doc Types Legend */}
          <div className="pt-3 border-t border-gray-100 flex flex-wrap gap-3">
            {docTypes.slice(0, 5).map(dt => (
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
                          <Link
                            href={`/devintel/suburb/${encodeURIComponent(doc.suburb)}`}
                            className="px-1.5 py-0.5 rounded text-[10px] font-medium bg-purple-50 text-purple-600 hover:bg-purple-100 transition-colors"
                          >
                            {doc.suburb}
                          </Link>
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

        {/* D. Active Suburbs — Clickable */}
        <section className="md:col-span-2">
          <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
            <span>🔥</span> 热点区域
          </h3>
          <div className="bg-white rounded-xl border border-gray-200 p-4 space-y-2">
            {active_suburbs.length === 0 ? (
              <p className="text-center text-gray-400 text-sm py-4">暂无数据</p>
            ) : (
              active_suburbs.slice(0, 10).map((s, i) => (
                <Link
                  key={s.suburb}
                  href={`/devintel/suburb/${encodeURIComponent(s.suburb)}`}
                  className="flex items-center gap-2.5 group hover:bg-purple-50 rounded-lg px-1 py-1 -mx-1 transition-colors"
                >
                  <span className="text-[10px] text-gray-400 w-4 text-right font-medium">{i + 1}</span>
                  <span className="text-xs text-gray-700 w-28 truncate group-hover:text-purple-700 transition-colors">{s.suburb}</span>
                  <div className="flex-1 bg-gray-100 rounded-full h-2">
                    <div
                      className="bg-gradient-to-r from-purple-400 to-pink-400 h-2 rounded-full transition-all"
                      style={{ width: `${Math.max(8, (s.document_count / maxSuburbCount) * 100)}%` }}
                    />
                  </div>
                  <span className="text-[10px] text-gray-500 font-medium w-6 text-right">{s.document_count}</span>
                  <span className="text-xs text-gray-300 group-hover:text-purple-400 transition-colors">→</span>
                </Link>
              ))
            )}
          </div>
        </section>
      </div>
    </div>
  );
}
