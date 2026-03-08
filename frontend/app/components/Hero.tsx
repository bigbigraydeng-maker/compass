import { useState } from 'react';
import { fetcher } from '../lib/api';

export default function Hero() {
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

  // 简单 markdown 渲染
  const renderMarkdown = (text: string) => {
    return text
      .split('\n')
      .map((line, i) => {
        if (line.startsWith('## ')) return <h3 key={i} className="text-lg font-bold mt-4 mb-2 text-white">{line.replace('## ', '')}</h3>;
        if (line.startsWith('**') && line.endsWith('**')) return <p key={i} className="font-bold text-white mt-2">{line.replace(/\*\*/g, '')}</p>;
        const formatted = line.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        return <p key={i} className="text-gray-200 text-sm leading-relaxed" dangerouslySetInnerHTML={{ __html: formatted }} />;
      });
  };

  return (
    <section className="relative text-white py-20 md:py-32 overflow-hidden">
      {/* Background image */}
      <div
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{
          backgroundImage: `url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80')`,
        }}
      />
      <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/60 to-black/80" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 drop-shadow-lg">
            Compass 2.0
          </h1>
          <h2 className="text-2xl md:text-3xl font-semibold mb-8 drop-shadow-md">
            AI驱动的房产投资机会发现平台
          </h2>
          <p className="text-xl text-gray-200 mb-12 max-w-3xl mx-auto drop-shadow">
            找捡漏 · 看机会 · 做判断<br />
            AI 帮你发现布里斯班房地产市场的投资机会
          </p>

          {/* 主要搜索框 */}
          <form onSubmit={handleSearch} className="max-w-3xl mx-auto mb-10">
            <div className="flex flex-col md:flex-row gap-4">
              <input
                type="text"
                placeholder="输入郊区名称，如 Sunnybank、Hamilton"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 px-6 py-4 rounded-lg focus:outline-none text-gray-800 text-lg shadow-lg"
                required
              />
              <button
                type="submit"
                className="bg-orange-500 hover:bg-orange-600 px-8 py-4 rounded-lg font-medium transition-colors text-lg whitespace-nowrap flex items-center justify-center gap-2 shadow-lg"
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
            <p className="text-gray-300 text-sm mt-3">支持 7 个郊区：Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton</p>
          </form>

          {/* AI 分析入口 */}
          <form onSubmit={handleAiAnalysis} className="max-w-3xl mx-auto">
            <div className="flex flex-col md:flex-row gap-4">
              <input
                type="text"
                placeholder="输入地址或郊区名进行 AI 投资分析"
                value={aiInput}
                onChange={(e) => setAiInput(e.target.value)}
                className="flex-1 px-6 py-4 rounded-lg focus:outline-none text-gray-800 text-lg shadow-lg"
                required
              />
              <button
                type="submit"
                className="bg-blue-500 hover:bg-blue-600 px-8 py-4 rounded-lg font-medium transition-colors text-lg whitespace-nowrap flex items-center justify-center gap-2 shadow-lg"
                disabled={isAnalyzing}
              >
                {isAnalyzing ? (
                  <>
                    <svg className="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    AI 分析中...
                  </>
                ) : '🤖 AI 分析'}
              </button>
            </div>
            <p className="text-gray-300 text-sm mt-3">例如：10 Main St, Sunnybank 或 Sunnybank</p>
          </form>

          {/* AI 分析结果展示 */}
          {(aiReport || aiError || isAnalyzing) && (
            <div className="max-w-3xl mx-auto mt-8">
              <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 border border-white/20 text-left">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-lg font-bold">🤖 AI 投资分析报告</h3>
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
                    {renderMarkdown(aiReport)}
                  </div>
                )}
              </div>
            </div>
          )}
        </div>

        {/* 核心价值主张 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
          <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 text-center hover:bg-white/20 transition-colors border border-white/10">
            <div className="text-3xl mb-4">💰</div>
            <h3 className="text-xl font-semibold mb-2">发现捡漏</h3>
            <p className="text-gray-300">找到低于市场价值的房产</p>
          </div>
          <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 text-center hover:bg-white/20 transition-colors border border-white/10">
            <div className="text-3xl mb-4">📈</div>
            <h3 className="text-xl font-semibold mb-2">智能分析</h3>
            <p className="text-gray-300">AI驱动的房产估值和洞察</p>
          </div>
          <div className="bg-white/10 backdrop-blur-md rounded-xl p-6 text-center hover:bg-white/20 transition-colors border border-white/10">
            <div className="text-3xl mb-4">🏆</div>
            <h3 className="text-xl font-semibold mb-2">投资排名</h3>
            <p className="text-gray-300">华人投资者首选郊区</p>
          </div>
        </div>
      </div>
    </section>
  );
}
