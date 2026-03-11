'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { PersonaAvatar } from './persona';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';

interface Headline {
  id: number;
  title: string;
  suburb: string;
  doc_type: string;
  source_name: string;
  created_at: string;
  url: string;
}

interface HeadlinesData {
  headlines: Headline[];
  total_documents: number;
  total_projects: number;
  last_updated: string;
}

const DOC_TYPE_COLORS: Record<string, string> = {
  planning: 'bg-blue-100 text-blue-700',
  infrastructure: 'bg-orange-100 text-orange-700',
  zoning: 'bg-green-100 text-green-700',
  transport: 'bg-purple-100 text-purple-700',
  development: 'bg-red-100 text-red-700',
};

export default function DevIntelCard() {
  const [data, setData] = useState<HeadlinesData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`${API_BASE}/api/devintel/headlines?limit=5`)
      .then(r => r.ok ? r.json() : null)
      .then(d => { if (d) setData(d); })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <section className="py-10 md:py-16 bg-gradient-to-br from-purple-50 via-white to-pink-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="animate-pulse space-y-4">
            <div className="h-8 bg-gray-200 rounded w-48" />
            <div className="h-4 bg-gray-200 rounded w-64" />
            <div className="space-y-3">
              {[1, 2, 3].map(i => (
                <div key={i} className="h-16 bg-gray-200 rounded-lg" />
              ))}
            </div>
          </div>
        </div>
      </section>
    );
  }

  if (!data || data.headlines.length === 0) return null;

  return (
    <section className="py-10 md:py-16 bg-gradient-to-br from-purple-50 via-white to-pink-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-6 md:mb-8">
          <div className="flex items-center gap-3">
            <PersonaAvatar persona="olivia" size="md" />
            <div>
              <h2 className="text-xl md:text-2xl font-bold text-gray-900">
                开发情报速递
              </h2>
              <p className="text-xs md:text-sm text-gray-500">
                {data.total_documents} 份文档 · {data.total_projects} 个项目追踪中
              </p>
            </div>
          </div>
          <Link
            href="/news?tab=devintel"
            className="text-purple-600 hover:text-purple-700 text-sm font-medium transition-colors"
          >
            查看全部 →
          </Link>
        </div>

        {/* Headlines list */}
        <div className="space-y-3">
          {data.headlines.map((item) => {
            const typeStyle = DOC_TYPE_COLORS[item.doc_type] || 'bg-gray-100 text-gray-700';
            return (
              <div
                key={item.id}
                className="bg-white rounded-xl p-4 border border-gray-100 hover:border-purple-200 hover:shadow-md transition-all"
              >
                <div className="flex items-start justify-between gap-3">
                  <div className="flex-1 min-w-0">
                    <h3 className="text-sm md:text-base font-medium text-gray-900 line-clamp-2">
                      {item.title}
                    </h3>
                    <div className="flex flex-wrap items-center gap-2 mt-2">
                      {item.doc_type && (
                        <span className={`text-[10px] md:text-xs px-2 py-0.5 rounded-full font-medium ${typeStyle}`}>
                          {item.doc_type}
                        </span>
                      )}
                      {item.suburb && (
                        <span className="text-[10px] md:text-xs px-2 py-0.5 rounded-full bg-purple-100 text-purple-700 font-medium">
                          {item.suburb}
                        </span>
                      )}
                      <span className="text-[10px] md:text-xs text-gray-400">
                        {item.source_name} · {item.created_at}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Last updated */}
        {data.last_updated && (
          <p className="text-xs text-gray-400 mt-4 text-right">
            数据更新于 {data.last_updated}
          </p>
        )}
      </div>
    </section>
  );
}
