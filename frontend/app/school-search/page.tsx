'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Header from '../components/Header';
import Footer from '../components/Footer';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8888';

interface School {
  name: string;
  school_type: string;
  suburb: string;
  naplan_percentile: number;
  catchment_suburbs: string[] | string;
  address?: string;
}

export default function SchoolSearchPage() {
  const [schools, setSchools] = useState<School[]>([]);
  const [loading, setLoading] = useState(true);
  const [filterSuburb, setFilterSuburb] = useState('');
  const [filterType, setFilterType] = useState('');
  const [analyzing, setAnalyzing] = useState<string | null>(null);
  const [analysisResult, setAnalysisResult] = useState<Record<string, string>>({});

  const suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton'];

  useEffect(() => {
    const loadSchools = async () => {
      try {
        let url = `${API_BASE}/api/schools`;
        const params = new URLSearchParams();
        if (filterSuburb) params.set('suburb', filterSuburb);
        if (filterType) params.set('school_type', filterType);
        if (params.toString()) url += `?${params.toString()}`;

        const res = await fetch(url);
        if (res.ok) {
          const data = await res.json();
          setSchools(data.schools || []);
        }
      } catch (e) {
        console.error('Failed to load schools:', e);
      } finally {
        setLoading(false);
      }
    };
    loadSchools();
  }, [filterSuburb, filterType]);

  const handleAnalyze = async (school: School) => {
    const key = school.name;
    if (analysisResult[key]) return; // 已有结果
    setAnalyzing(key);

    try {
      const suburb = school.suburb || (Array.isArray(school.catchment_suburbs) ? school.catchment_suburbs[0] : school.catchment_suburbs) || 'Sunnybank';
      const res = await fetch(`${API_BASE}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          address: `${school.name}, ${suburb}`,
          mode: 'school',
        }),
      });
      if (res.ok) {
        const data = await res.json();
        setAnalysisResult(prev => ({ ...prev, [key]: data.analysis || '分析完成' }));
      } else {
        setAnalysisResult(prev => ({ ...prev, [key]: '分析失败，请稍后重试' }));
      }
    } catch {
      setAnalysisResult(prev => ({ ...prev, [key]: '网络错误，请稍后重试' }));
    } finally {
      setAnalyzing(null);
    }
  };

  const getNaplanColor = (percentile: number) => {
    if (percentile >= 80) return 'bg-green-500';
    if (percentile >= 60) return 'bg-yellow-500';
    return 'bg-red-500';
  };

  const getNaplanLabel = (percentile: number) => {
    if (percentile >= 80) return '优秀';
    if (percentile >= 60) return '良好';
    return '一般';
  };

  const getTypeLabel = (type: string) => {
    const map: Record<string, string> = {
      primary: '小学',
      secondary: '中学',
      combined: '综合',
      special: '特殊',
    };
    return map[type?.toLowerCase()] || type;
  };

  const getTypeColor = (type: string) => {
    const map: Record<string, string> = {
      primary: 'bg-blue-100 text-blue-700',
      secondary: 'bg-purple-100 text-purple-700',
      combined: 'bg-orange-100 text-orange-700',
    };
    return map[type?.toLowerCase()] || 'bg-gray-100 text-gray-700';
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />

      {/* Hero 横幅 */}
      <section className="relative bg-gradient-to-r from-emerald-700 to-emerald-900 text-white py-12 md:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-2xl md:text-4xl font-bold mb-3 md:mb-4">🏫 校区找房</h1>
          <p className="text-sm md:text-xl text-emerald-100 max-w-2xl mx-auto">
            按学区质量寻找投资机会 · NAPLAN 排名 · 学区房价值分析
          </p>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 md:py-10">
        {/* 筛选栏 */}
        <div className="bg-white rounded-xl shadow-sm p-4 md:p-6 mb-6 md:mb-8 border border-gray-200">
          <div className="flex flex-col md:flex-row gap-3 md:gap-4">
            <div className="flex-1">
              <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1">郊区</label>
              <select
                value={filterSuburb}
                onChange={(e) => setFilterSuburb(e.target.value)}
                className="w-full px-3 py-2 rounded-lg border border-gray-300 text-xs md:text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">全部郊区</option>
                {suburbs.map(s => (
                  <option key={s} value={s}>{s}</option>
                ))}
              </select>
            </div>
            <div className="flex-1">
              <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1">学校类型</label>
              <select
                value={filterType}
                onChange={(e) => setFilterType(e.target.value)}
                className="w-full px-3 py-2 rounded-lg border border-gray-300 text-xs md:text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500"
              >
                <option value="">全部类型</option>
                <option value="primary">小学</option>
                <option value="secondary">中学</option>
                <option value="combined">综合</option>
              </select>
            </div>
            <div className="flex items-end">
              <span className="text-xs md:text-sm text-gray-500">
                共 {schools.length} 所学校
              </span>
            </div>
          </div>
        </div>

        {/* 学校列表 */}
        {loading ? (
          <div className="text-center py-20">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-emerald-600 mx-auto mb-4"></div>
            <p className="text-gray-500">加载学校数据...</p>
          </div>
        ) : schools.length === 0 ? (
          <div className="text-center py-20">
            <p className="text-gray-500 text-lg">暂无学校数据</p>
            <p className="text-gray-400 text-sm mt-2">请尝试调整筛选条件</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
            {schools.map((school, i) => {
              const catchments = Array.isArray(school.catchment_suburbs)
                ? school.catchment_suburbs
                : typeof school.catchment_suburbs === 'string'
                  ? school.catchment_suburbs.split(',').map(s => s.trim())
                  : [];

              return (
                <div key={`${school.name}-${i}`} className="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden hover:shadow-md transition-shadow">
                  <div className="p-4 md:p-5">
                    {/* 学校名 + 类型 */}
                    <div className="flex items-start justify-between mb-3">
                      <h3 className="font-bold text-sm md:text-base text-gray-900 leading-tight flex-1 mr-2">
                        {school.name}
                      </h3>
                      <span className={`text-[10px] md:text-xs px-2 py-0.5 rounded-full font-medium flex-shrink-0 ${getTypeColor(school.school_type)}`}>
                        {getTypeLabel(school.school_type)}
                      </span>
                    </div>

                    {/* NAPLAN 进度条 */}
                    <div className="mb-3">
                      <div className="flex items-center justify-between text-xs md:text-sm mb-1">
                        <span className="text-gray-600">NAPLAN 百分位</span>
                        <span className={`font-bold ${school.naplan_percentile >= 80 ? 'text-green-600' : school.naplan_percentile >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>
                          {school.naplan_percentile || 0}% · {getNaplanLabel(school.naplan_percentile || 0)}
                        </span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-2">
                        <div
                          className={`h-2 rounded-full transition-all ${getNaplanColor(school.naplan_percentile || 0)}`}
                          style={{ width: `${Math.min(100, school.naplan_percentile || 0)}%` }}
                        />
                      </div>
                    </div>

                    {/* 学区覆盖郊区 */}
                    {catchments.length > 0 && (
                      <div className="mb-3">
                        <p className="text-[10px] md:text-xs text-gray-500 mb-1">学区覆盖：</p>
                        <div className="flex flex-wrap gap-1">
                          {catchments.slice(0, 5).map((s, j) => (
                            <Link
                              key={j}
                              href={`/suburb/${encodeURIComponent(s.trim())}`}
                              className="text-[10px] md:text-xs bg-gray-100 text-gray-600 px-2 py-0.5 rounded-full hover:bg-blue-100 hover:text-blue-600 transition-colors"
                            >
                              {s.trim()}
                            </Link>
                          ))}
                          {catchments.length > 5 && (
                            <span className="text-[10px] text-gray-400">+{catchments.length - 5}</span>
                          )}
                        </div>
                      </div>
                    )}

                    {/* AI 分析按钮 */}
                    <button
                      onClick={() => handleAnalyze(school)}
                      disabled={analyzing === school.name}
                      className="w-full bg-emerald-50 hover:bg-emerald-100 text-emerald-700 py-2 rounded-lg text-xs md:text-sm font-medium transition-colors disabled:opacity-50 flex items-center justify-center gap-1"
                    >
                      {analyzing === school.name ? (
                        <>
                          <svg className="animate-spin h-3 w-3" fill="none" viewBox="0 0 24 24">
                            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                          </svg>
                          AI 分析中...
                        </>
                      ) : analysisResult[school.name] ? (
                        '📋 查看分析结果'
                      ) : (
                        '🤖 AI 分析学区价值'
                      )}
                    </button>

                    {/* 分析结果 */}
                    {analysisResult[school.name] && (
                      <div className="mt-3 bg-gray-50 rounded-lg p-3 border border-gray-100 max-h-48 overflow-y-auto">
                        <div className="text-xs md:text-sm text-gray-700 leading-relaxed">
                          {analysisResult[school.name].split('\n').map((line, j) => {
                            if (line.startsWith('## ')) return <h4 key={j} className="font-bold text-emerald-800 mt-2 mb-1 text-xs md:text-sm">{line.replace('## ', '')}</h4>;
                            if (line.startsWith('- ')) return <li key={j} className="ml-3 text-[10px] md:text-xs">{line.replace('- ', '')}</li>;
                            if (line.trim() === '') return <br key={j} />;
                            return <p key={j} className="text-[10px] md:text-xs mb-0.5">{line}</p>;
                          })}
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <Footer />
    </div>
  );
}
