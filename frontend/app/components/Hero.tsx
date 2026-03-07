import { useState } from 'react';

export default function Hero() {
  const [searchQuery, setSearchQuery] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      // 导航到对应的郊区页面
      window.location.href = `/suburb/${encodeURIComponent(searchQuery)}`;
    }
  };

  return (
    <section className="bg-gradient-to-r from-blue-600 to-blue-700 text-white py-16 md:py-24">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h1 className="text-3xl md:text-4xl lg:text-5xl font-bold mb-4">
            Brisbane Chinese Property Intelligence
          </h1>
          <p className="text-xl md:text-2xl text-blue-100 mb-8">
            AI 帮华人分析布里斯班房地产市场<br />
            发现值得关注的区域和房源
          </p>
          
          <form onSubmit={handleSearch} className="max-w-md mx-auto">
            <div className="flex">
              <input
                type="text"
                placeholder="Search suburb"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 px-4 py-3 rounded-l-lg focus:outline-none text-gray-800"
              />
              <button
                type="submit"
                className="bg-orange-500 hover:bg-orange-600 px-6 py-3 rounded-r-lg font-medium transition-colors"
              >
                Search
              </button>
            </div>
          </form>
        </div>

        {/* Score 展示 - 暂时隐藏，等API完成 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-12">
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-4 text-center">
            <h3 className="font-medium mb-2">Sunnybank Score</h3>
            <p className="text-2xl font-bold">82</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-4 text-center">
            <h3 className="font-medium mb-2">Rochedale Score</h3>
            <p className="text-2xl font-bold">79</p>
          </div>
          <div className="bg-white/10 backdrop-blur-sm rounded-lg p-4 text-center">
            <h3 className="font-medium mb-2">Mansfield Score</h3>
            <p className="text-2xl font-bold">76</p>
          </div>
        </div>
      </div>
    </section>
  );
}
