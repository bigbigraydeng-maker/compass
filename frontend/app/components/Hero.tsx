import { useState } from 'react';

export default function Hero() {
  const [searchQuery, setSearchQuery] = useState('');
  const [urlQuery, setUrlQuery] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      // 导航到对应的郊区页面
      window.location.href = `/suburb/${encodeURIComponent(searchQuery)}`;
    }
  };

  const handleUrlAnalysis = (e: React.FormEvent) => {
    e.preventDefault();
    if (urlQuery.trim()) {
      // 这里可以添加URL分析逻辑
      alert('URL分析功能即将上线');
    }
  };

  return (
    <section className="bg-gradient-to-r from-blue-700 to-blue-900 text-white py-20 md:py-32">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6">
            Compass 2.0
          </h1>
          <h2 className="text-2xl md:text-3xl font-semibold mb-8">
            AI驱动的房产投资情报平台
          </h2>
          <p className="text-xl text-blue-100 mb-12 max-w-3xl mx-auto">
            找捡漏 · 看机会 · 做判断<br />
            AI 帮你发现布里斯班房地产市场的投资机会
          </p>
          
          {/* 主要搜索框 */}
          <form onSubmit={handleSearch} className="max-w-2xl mx-auto mb-8">
            <div className="flex flex-col md:flex-row gap-4">
              <input
                type="text"
                placeholder="郊区、邮编或地址"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 px-6 py-4 rounded-lg focus:outline-none text-gray-800 text-lg"
              />
              <button
                type="submit"
                className="bg-orange-500 hover:bg-orange-600 px-8 py-4 rounded-lg font-medium transition-colors text-lg whitespace-nowrap"
              >
                🔍 寻找机会
              </button>
            </div>
          </form>

          {/* URL 分析入口 */}
          <form onSubmit={handleUrlAnalysis} className="max-w-2xl mx-auto">
            <div className="flex flex-col md:flex-row gap-4">
              <input
                type="text"
                placeholder="粘贴 Domain 或 Realestate 网址进行分析"
                value={urlQuery}
                onChange={(e) => setUrlQuery(e.target.value)}
                className="flex-1 px-6 py-3 rounded-lg focus:outline-none text-gray-800"
              />
              <button
                type="submit"
                className="bg-blue-500 hover:bg-blue-600 px-6 py-3 rounded-lg font-medium transition-colors whitespace-nowrap"
              >
                🤖 AI 分析
              </button>
            </div>
          </form>
        </div>

        {/* 核心价值主张 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-16">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 text-center">
            <div className="text-3xl mb-4">💰</div>
            <h3 className="text-xl font-semibold mb-2">发现捡漏</h3>
            <p className="text-blue-100">找到低于市场价值的房产</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 text-center">
            <div className="text-3xl mb-4">📈</div>
            <h3 className="text-xl font-semibold mb-2">智能分析</h3>
            <p className="text-blue-100">AI驱动的房产估值和洞察</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 text-center">
            <div className="text-3xl mb-4">🏆</div>
            <h3 className="text-xl font-semibold mb-2">投资排名</h3>
            <p className="text-blue-100">华人投资者首选郊区</p>
          </div>
        </div>
      </div>
    </section>
  );
}
