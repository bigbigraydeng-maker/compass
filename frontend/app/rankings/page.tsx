'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Navbar from '../components/Navbar';
import { PersonaAvatar } from '../components/persona';
import { fetcher } from '../lib/api';

interface ScoreBreakdown {
  score: number;
  max: number;
  label: string;
}

interface RankingData {
  suburb: string;
  total_score: number;
  grade: string;
  rank: number;
  breakdown: Record<string, ScoreBreakdown>;
  data_sources: string[];
  updated_at: string;
}

function formatPrice(price: number) {
  if (!price) return '-';
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0,
  }).format(price);
}

const GRADE_STYLES: Record<string, string> = {
  'S': 'bg-gradient-to-r from-yellow-400 to-orange-500 text-white',
  'A': 'bg-gradient-to-r from-green-400 to-green-600 text-white',
  'B': 'bg-gradient-to-r from-blue-400 to-blue-600 text-white',
  'C': 'bg-gradient-to-r from-gray-400 to-gray-600 text-white',
};

const DIMENSION_COLORS: Record<string, string> = {
  'growth': 'bg-red-500',
  'school': 'bg-yellow-500',
  'land': 'bg-green-500',
  'activity': 'bg-blue-500',
  'chinese': 'bg-purple-500',
};

export default function RankingsPage() {
  const router = useRouter();
  const [rankings, setRankings] = useState<RankingData[]>([]);
  const [loading, setLoading] = useState(true);
  const [updatedAt, setUpdatedAt] = useState('');

  useEffect(() => {
    const loadData = async () => {
      try {
        const data = await fetcher('/api/rankings');
        if (data?.rankings) {
          setRankings(data.rankings);
          setUpdatedAt(data.updated_at || '');
        }
      } catch (error) {
        console.error('Failed to load rankings:', error);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="rankings" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-3">
            <PersonaAvatar persona="ethan" size="lg" />
            <div>
              <h1 className="text-3xl font-bold text-gray-900">Compass 投资排名</h1>
              <p className="text-sm text-emerald-600 font-medium">Ethan 的多维评分模型</p>
            </div>
          </div>
          <p className="text-lg text-gray-600">
            基于 5 维度评分体系（房价增长、学区质量、土地价值、市场活跃度、华人友好度）
          </p>
          {updatedAt && (
            <p className="text-sm text-gray-400 mt-1">数据更新: {updatedAt}</p>
          )}
        </div>

        {loading ? (
          <div className="space-y-6">
            {[1, 2, 3].map((i) => (
              <div key={i} className="bg-white rounded-xl shadow-sm border p-6 animate-pulse">
                <div className="h-8 bg-gray-200 rounded mb-4 w-1/3"></div>
                <div className="h-4 bg-gray-200 rounded mb-2 w-2/3"></div>
                <div className="flex gap-4 mt-4">
                  {[1, 2, 3, 4, 5].map((j) => (
                    <div key={j} className="h-6 bg-gray-200 rounded flex-1"></div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        ) : rankings.length === 0 ? (
          <div className="bg-white rounded-xl shadow-sm border p-12 text-center">
            <p className="text-xl text-gray-500 mb-2">暂无排名数据</p>
            <p className="text-gray-400">评分系统正在计算中，请稍后再来</p>
          </div>
        ) : (
          <div className="space-y-6">
            {rankings.map((item, index) => (
              <div
                key={item.suburb}
                onClick={() => router.push(`/suburb/${encodeURIComponent(item.suburb)}`)}
                className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-lg hover:border-blue-300 transition-all cursor-pointer"
              >
                <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                  {/* Left: Rank + Name + Grade */}
                  <div className="flex items-center gap-4">
                    <div className="text-4xl font-bold text-gray-300 w-16 text-center">
                      #{item.rank || index + 1}
                    </div>
                    <div>
                      <h2 className="text-2xl font-bold text-gray-900 mb-1">{item.suburb}</h2>
                      <div className="flex items-center gap-3">
                        <span className={`px-3 py-1 rounded-full text-sm font-bold ${GRADE_STYLES[item.grade] || GRADE_STYLES['C']}`}>
                          {item.grade} 级
                        </span>
                        <span className="text-3xl font-bold text-blue-600">{item.total_score}</span>
                        <span className="text-sm text-gray-400">/ 100</span>
                      </div>
                    </div>
                  </div>

                  {/* Right: Score breakdown bars */}
                  <div className="flex-1 max-w-xl">
                    {item.breakdown && Object.entries(item.breakdown).map(([key, dim]) => (
                      <div key={key} className="flex items-center gap-2 mb-2 last:mb-0">
                        <span className="text-xs text-gray-500 w-20 text-right">{dim.label}</span>
                        <div className="flex-1 bg-gray-100 rounded-full h-4 overflow-hidden">
                          <div
                            className={`h-full rounded-full ${DIMENSION_COLORS[key] || 'bg-blue-500'} transition-all`}
                            style={{ width: `${(dim.score / dim.max) * 100}%` }}
                          ></div>
                        </div>
                        <span className="text-xs font-semibold text-gray-700 w-12">
                          {dim.score}/{dim.max}
                        </span>
                      </div>
                    ))}
                  </div>

                  {/* Arrow */}
                  <div className="text-blue-400 text-2xl hidden lg:block">→</div>
                </div>

                {/* Data sources */}
                {item.data_sources && (
                  <div className="mt-4 pt-3 border-t border-gray-100">
                    <div className="flex flex-wrap gap-2">
                      {item.data_sources.map((src, i) => (
                        <span key={i} className="text-xs bg-gray-100 text-gray-500 px-2 py-1 rounded">
                          {src}
                        </span>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
