'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { PersonaButton, PersonaMarkdown } from './persona';

export default function Hero() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');
  const [aiInput, setAiInput] = useState('');
  const [isSearching, setIsSearching] = useState(false);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [aiReport, setAiReport] = useState<string | null>(null);
  const [aiError, setAiError] = useState<string | null>(null);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const q = searchQuery.trim();
    if (q) {
      setIsSearching(true);
      window.location.href = `/suburb/${encodeURIComponent(q)}`;
    }
  };

  const handleAiAnalysis = async (e: React.FormEvent) => {
    e.preventDefault();
    const input = aiInput.trim();
    if (!input) return;

    setIsAnalyzing(true);
    setAiReport(null);
    setAiError(null);

    try {
      const apiBase = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const res = await fetch(`${apiBase}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address: input, url: input }),
      });

      if (!res.ok) throw new Error(`API error: ${res.status}`);
      const data = await res.json();
      setAiReport(data.analysis || data.report || '分析完成，但未返回内容');
    } catch (error: any) {
      setAiError(error.message || '分析失败，请稍后重试');
    } finally {
      setIsAnalyzing(false);
    }
  };

  // 快捷郊区按钮
  const quickSuburbs = [
    { name: 'Sunnybank', label: 'Sunnybank' },
    { name: 'Eight Mile Plains', label: 'EMP' },
    { name: 'Calamvale', label: 'Calamvale' },
    { name: 'Rochedale', label: 'Rochedale' },
    { name: 'Mansfield', label: 'Mansfield' },
    { name: 'Ascot', label: 'Ascot' },
    { name: 'Hamilton', label: 'Hamilton' },
  ];

  // 三个功能入口
  const featureCards = [
    {
      icon: '🏫',
      title: '校区找房',
      desc: '按学区质量寻找投资机会',
      href: '/school-search',
      gradient: 'from-emerald-500/20 to-emerald-600/10',
      border: 'border-emerald-400/30',
      hoverBg: 'hover:bg-emerald-500/20',
    },
    {
      icon: '🏠',
      title: '首次置业',
      desc: '首置补贴 · 预算计算 · AI顾问',
      href: '/first-home',
      gradient: 'from-blue-500/20 to-blue-600/10',
      border: 'border-blue-400/30',
      hoverBg: 'hover:bg-blue-500/20',
    },
    {
      icon: '🌏',
      title: '海外人士购房',
      desc: 'FIRB指南 · 税费 · AI顾问',
      href: '/overseas-buyer',
      gradient: 'from-purple-500/20 to-purple-600/10',
      border: 'border-purple-400/30',
      hoverBg: 'hover:bg-purple-500/20',
    },
  ];

  return (
    <section className="relative text-white py-16 md:py-32 overflow-hidden">
      {/* Background image */}
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{
          backgroundImage: `url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80')`,
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/60 to-black/80" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-10 md:mb-16">
          <h1 className="text-3xl md:text-5xl lg:text-6xl font-bold mb-4 md:mb-6 drop-shadow-lg">
            Compass 2.0
          </h1>
          <h2 className="text-xl md:text-3xl font-semibold mb-4 md:mb-8 drop-shadow-md">
            AI驱动的房产投资机会发现平台
          </h2>
          <p className="text-base md:text-xl text-gray-200 mb-8 md:mb-12 max-w-3xl mx-auto drop-shadow">
            找捡漏 · 看机会 · 做判断<br />
            AI 帮你发现布里斯班房地产市场的投资机会
          </p>

          {/* 主要搜索框 */}
          <form onSubmit={handleSearch} className="max-w-3xl mx-auto mb-4 md:mb-10">
            <div className="flex flex-col md:flex-row gap-3 md:gap-4">
              <input
                type="text"
                placeholder="输入 Suburb 名称，如 Sunnybank、Hamilton"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 px-4 md:px-6 py-3 md:py-4 rounded-lg focus:outline-none text-gray-800 text-base md:text-lg shadow-lg"
                required
              />
              <button
                type="submit"
                className="bg-orange-500 hover:bg-orange-600 px-6 md:px-8 py-3 md:py-4 rounded-lg font-medium transition-colors text-base md:text-lg whitespace-nowrap flex items-center justify-center gap-2 shadow-lg"
                disabled={isSearching}
              >
                {isSearching ? (
                  <>
                    <svg className="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    搜索中...
                  </>
                ) : '🔍 寻找机会'}
              </button>
            </div>
          </form>

          {/* 移动端快捷郊区按钮 */}
          <div className="md:hidden flex flex-wrap justify-center gap-2 mb-6">
            {quickSuburbs.map((s) => (
              <button
                key={s.name}
                onClick={() => router.push(`/suburb/${encodeURIComponent(s.name)}`)}
                className="bg-white/15 backdrop-blur-sm text-white text-xs px-3 py-1.5 rounded-full border border-white/20 hover:bg-white/25 transition-colors"
              >
                {s.label}
              </button>
            ))}
          </div>

          {/* 桌面端支持提示 */}
          <p className="hidden md:block text-gray-300 text-sm mb-10">支持 17 个 Suburbs：Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton, Runcorn, Wishart 等</p>

          {/* AI 分析入口 */}
          <form onSubmit={handleAiAnalysis} className="max-w-3xl mx-auto">
            <div className="flex flex-col md:flex-row gap-3 md:gap-4">
              <input
                type="text"
                placeholder="输入地址或 Suburb 名，Amanda 为你分析"
                value={aiInput}
                onChange={(e) => setAiInput(e.target.value)}
                className="flex-1 px-4 md:px-6 py-3 md:py-4 rounded-lg focus:outline-none text-gray-800 text-base md:text-lg shadow-lg"
                required
              />
              <PersonaButton
                persona="amanda"
                loading={isAnalyzing}
                className="px-6 md:px-8 py-3 md:py-4 text-base md:text-lg shadow-lg whitespace-nowrap"
              />
            </div>
            <p className="text-gray-300 text-xs md:text-sm mt-2 md:mt-3">例如：10 Main St, Sunnybank 或 Sunnybank</p>
          </form>

          {/* AI 分析结果展示 */}
          {(aiReport || aiError || isAnalyzing) && (
            <div className="max-w-3xl mx-auto mt-8">
              <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-left">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-bold">Amanda 投资分析报告</h3>
                  {aiReport && (
                    <button
                      onClick={() => { setAiReport(null); setAiError(null); }}
                      className="text-gray-400 hover:text-white text-sm"
                    >
                      ✕ 关闭
                    </button>
                  )}
                </div>

                {isAnalyzing && (
                  <div className="flex items-center gap-3 text-gray-300">
                    <svg className="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <span>正在分析中，请稍候（约 10-15 秒）...</span>
                  </div>
                )}

                {aiError && (
                  <div className="text-red-300 bg-red-900/30 rounded-lg p-4">
                    分析失败：{aiError}
                  </div>
                )}

                {aiReport && (
                  <div className="max-h-96 overflow-y-auto pr-2 custom-scrollbar">
                    <PersonaMarkdown content={aiReport} variant="dark" />
                  </div>
                )}
              </div>
            </div>
          )}
        </div>

        {/* 三个功能入口卡片 */}
        <div className="grid grid-cols-3 md:grid-cols-3 gap-3 md:gap-8 mt-8 md:mt-16">
          {featureCards.map((card) => (
            <Link
              key={card.title}
              href={card.href}
              className={`bg-gradient-to-br ${card.gradient} backdrop-blur-md rounded-xl p-4 md:p-6 text-center ${card.hoverBg} transition-all border ${card.border} group hover:scale-105`}
            >
              <div className="text-2xl md:text-4xl mb-2 md:mb-4 group-hover:scale-110 transition-transform">
                {card.icon}
              </div>
              <h3 className="text-sm md:text-xl font-semibold mb-1 md:mb-2">{card.title}</h3>
              <p className="text-gray-300 text-[10px] md:text-sm hidden md:block">{card.desc}</p>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
