import { useState } from 'react';
import { fetcher } from '../lib/api';

export default function AIPropertyAnalysis() {
  const [address, setAddress] = useState('');
  const [url, setUrl] = useState('');
  const [loading, setLoading] = useState(false);
  const [analysis, setAnalysis] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!address && !url) {
      setError('请输入房产地址或网址');
      return;
    }

    setLoading(true);
    setError(null);
    setAnalysis(null);

    try {
      const response = await fetch('/api/analyze', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ address, url }),
      });

      if (!response.ok) {
        throw new Error('分析失败，请重试');
      }

      const data = await response.json();
      setAnalysis(data.analysis);
    } catch (err) {
      setError(err instanceof Error ? err.message : '分析失败，请重试');
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="py-20 bg-gradient-to-r from-blue-900 to-blue-700 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-6">
            AI房产分析
          </h2>
          <p className="text-xl text-blue-100 mb-12 max-w-3xl mx-auto">
            利用AI分析任何房产，获取详细的投资洞察
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-8">
            <h3 className="text-2xl font-semibold mb-6">如何使用</h3>
            <div className="space-y-6">
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">1</div>
                <div>
                  <h4 className="font-semibold mb-2">输入房产信息</h4>
                  <p className="text-blue-100">提供地址或粘贴 Domain/Realestate 网址</p>
                </div>
              </div>
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">2</div>
                <div>
                  <h4 className="font-semibold mb-2">AI分析</h4>
                  <p className="text-blue-100">我们的AI分析市场数据和 comparable sales</p>
                </div>
              </div>
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">3</div>
                <div>
                  <h4 className="font-semibold mb-2">获取洞察</h4>
                  <p className="text-blue-100">收到详细的投资报告和建议</p>
                </div>
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-2xl overflow-hidden">
            <div className="p-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-6">尝试AI分析</h3>
              <form className="space-y-4" onSubmit={handleSubmit}>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">房产地址</label>
                  <input
                    type="text"
                    placeholder="123 Main St, Sunnybank"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">或粘贴网址</label>
                  <input
                    type="text"
                    placeholder="https://www.domain.com.au/..."
                    value={url}
                    onChange={(e) => setUrl(e.target.value)}
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white py-4 rounded-lg font-medium transition-colors text-lg disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? '分析中...' : '🤖 开始AI分析'}
                </button>
              </form>
              
              {error && (
                <div className="mt-4 p-4 bg-red-100 text-red-800 rounded-lg">
                  {error}
                </div>
              )}
              
              {analysis && (
                <div className="mt-6 p-6 bg-gray-50 rounded-lg border border-gray-200">
                  <h4 className="font-bold text-lg text-gray-900 mb-3">AI分析结果</h4>
                  <p className="text-gray-700 whitespace-pre-line">{analysis}</p>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
