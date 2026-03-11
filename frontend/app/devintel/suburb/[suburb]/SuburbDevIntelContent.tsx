'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Navbar from '../../../components/Navbar';
import { PersonaAvatar } from '../../../components/persona';
import { fetcher } from '../../../lib/api';

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

const STAGE_LABELS: Record<string, string> = {
  proposed: '规划中',
  approved: '已批准',
  under_construction: '建设中',
  completed: '已完工',
  cancelled: '已取消',
};

function formatDocType(dt: string): string {
  return DOC_TYPE_LABELS[dt] || dt.replace(/_/g, ' ');
}

interface SuburbData {
  suburb: string;
  analysis: string;
  documents: Array<{
    id: number;
    title: string;
    source_name: string;
    doc_type: string | null;
    url: string;
    created_at: string | null;
  }>;
  doc_type_distribution: Array<{ doc_type: string; count: number }>;
  projects: Array<{
    project_name: string;
    stage: string | null;
    authority: string | null;
    doc_count: number;
  }>;
  total_documents: number;
}

export default function SuburbDevIntelContent({ suburb }: { suburb: string }) {
  const [data, setData] = useState<SuburbData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    setLoading(true);
    fetcher(`/api/devintel/suburb/${encodeURIComponent(suburb)}`)
      .then((d: SuburbData) => setData(d))
      .catch(() => setError('数据加载失败'))
      .finally(() => setLoading(false));
  }, [suburb]);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="news" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-gray-500 mb-6">
          <Link href="/news" className="hover:text-purple-600 transition-colors">开发情报</Link>
          <span>/</span>
          <span className="text-gray-900 font-medium">{suburb}</span>
        </div>

        {/* Header */}
        <div className="flex items-center gap-4 mb-6">
          <div className="w-12 h-12 bg-gradient-to-br from-purple-500 to-pink-500 rounded-xl flex items-center justify-center text-white text-lg font-bold">
            {suburb[0]}
          </div>
          <div>
            <h1 className="text-2xl font-bold text-gray-900">{suburb}</h1>
            <p className="text-sm text-purple-600">开发情报详情</p>
          </div>
          {data && (
            <span className="ml-auto text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
              {data.total_documents} 份文档
            </span>
          )}
        </div>

        {loading ? (
          <div className="space-y-4">
            {[1, 2, 3].map(i => (
              <div key={i} className="bg-white rounded-xl border p-6 animate-pulse">
                <div className="h-4 bg-gray-200 rounded w-1/3 mb-3" />
                <div className="h-16 bg-gray-100 rounded" />
              </div>
            ))}
          </div>
        ) : error ? (
          <div className="bg-white rounded-xl border p-12 text-center">
            <p className="text-gray-500">{error}</p>
            <Link href="/news" className="text-sm text-purple-600 hover:text-purple-700 mt-2 inline-block">
              返回开发情报
            </Link>
          </div>
        ) : data ? (
          <div className="space-y-6">
            {/* AI Analysis */}
            {data.analysis && (
              <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5">
                <div className="flex items-center gap-2 mb-3">
                  <PersonaAvatar persona="olivia" size="sm" />
                  <h3 className="text-sm font-semibold text-purple-700">Olivia 开发趋势分析</h3>
                </div>
                <p className="text-sm text-gray-700 leading-relaxed">{data.analysis}</p>
              </div>
            )}

            {/* Stats Row */}
            <div className="grid grid-cols-3 gap-3">
              <div className="bg-white rounded-xl border p-4 text-center">
                <p className="text-xl font-bold text-purple-600 font-mono">{data.total_documents}</p>
                <p className="text-xs text-gray-500 mt-1">总文档数</p>
              </div>
              <div className="bg-white rounded-xl border p-4 text-center">
                <p className="text-xl font-bold text-blue-600 font-mono">{data.projects.length}</p>
                <p className="text-xs text-gray-500 mt-1">相关项目</p>
              </div>
              <div className="bg-white rounded-xl border p-4 text-center">
                <p className="text-xl font-bold text-emerald-600 font-mono">{data.doc_type_distribution.length}</p>
                <p className="text-xs text-gray-500 mt-1">文档类型</p>
              </div>
            </div>

            {/* Related Projects */}
            {data.projects.length > 0 && (
              <section>
                <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
                  <span>🏗️</span> 相关项目
                </h3>
                <div className="space-y-2">
                  {data.projects.map(p => (
                    <div key={p.project_name} className="bg-white rounded-xl border p-4">
                      <div className="flex items-center justify-between">
                        <div>
                          <h4 className="text-sm font-bold text-gray-900">{p.project_name}</h4>
                          {p.authority && <p className="text-[10px] text-gray-500 mt-0.5">{p.authority}</p>}
                        </div>
                        <div className="flex items-center gap-2">
                          {p.stage && (
                            <span className="text-[10px] px-2 py-0.5 rounded-full bg-blue-100 text-blue-700 font-medium">
                              {STAGE_LABELS[p.stage] || p.stage}
                            </span>
                          )}
                          <span className="text-[10px] text-gray-400">{p.doc_count} 份文档</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            )}

            {/* Document Type Distribution */}
            {data.doc_type_distribution.length > 0 && (
              <section>
                <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
                  <span>📊</span> 文档类型分布
                </h3>
                <div className="bg-white rounded-xl border p-4">
                  <div className="space-y-2">
                    {data.doc_type_distribution.map(d => {
                      const maxCount = data.doc_type_distribution[0]?.count || 1;
                      return (
                        <div key={d.doc_type} className="flex items-center gap-3">
                          <span className="text-xs text-gray-600 w-24 truncate">{formatDocType(d.doc_type)}</span>
                          <div className="flex-1 bg-gray-100 rounded-full h-2.5">
                            <div
                              className="bg-gradient-to-r from-purple-400 to-pink-400 h-2.5 rounded-full"
                              style={{ width: `${Math.max(8, (d.count / maxCount) * 100)}%` }}
                            />
                          </div>
                          <span className="text-xs text-gray-500 font-mono w-6 text-right">{d.count}</span>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </section>
            )}

            {/* Recent Documents */}
            <section>
              <h3 className="text-sm font-semibold text-gray-800 mb-3 flex items-center gap-1.5">
                <span>📄</span> 最新文档
              </h3>
              <div className="space-y-2">
                {data.documents.length === 0 ? (
                  <div className="bg-white rounded-xl border p-6 text-center text-gray-400 text-sm">暂无文档</div>
                ) : (
                  data.documents.map(doc => (
                    <div key={doc.id} className="bg-white rounded-xl border border-gray-200 hover:border-purple-200 transition-colors p-3.5">
                      <div className="flex items-start justify-between gap-2">
                        <div className="flex-1 min-w-0">
                          <a
                            href={doc.url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="text-sm font-medium text-gray-900 hover:text-purple-600 line-clamp-2 transition-colors"
                          >
                            {doc.title}
                          </a>
                          <div className="flex items-center gap-1.5 mt-1">
                            {doc.doc_type && (
                              <span className="px-1.5 py-0.5 rounded text-[10px] font-medium bg-blue-50 text-blue-600">
                                {formatDocType(doc.doc_type)}
                              </span>
                            )}
                            <span className="text-[10px] text-gray-400">{doc.source_name}</span>
                          </div>
                        </div>
                        {doc.created_at && (
                          <span className="text-[10px] text-gray-400 flex-shrink-0">{doc.created_at}</span>
                        )}
                      </div>
                    </div>
                  ))
                )}
              </div>
            </section>

            {/* Back link */}
            <div className="text-center pt-4">
              <Link
                href="/news"
                className="inline-flex items-center gap-1 text-sm text-purple-600 hover:text-purple-700 font-medium"
              >
                ← 返回开发情报
              </Link>
            </div>
          </div>
        ) : null}
      </main>
    </div>
  );
}
