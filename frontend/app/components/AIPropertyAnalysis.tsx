import { useState } from 'react';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8888';

export default function AIPropertyAnalysis() {
  const [address, setAddress] = useState('');
  const [loading, setLoading] = useState(false);
  const [analysis, setAnalysis] = useState<string | null>(null);
  const [dataDimensions, setDataDimensions] = useState<Record<string, boolean> | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!address) {
      setError('请输入房产地址');
      return;
    }

    setLoading(true);
    setError(null);
    setAnalysis(null);
    setDataDimensions(null);

    try {
      const response = await fetch(`${API_BASE}/api/analyze`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ address }),
      });

      if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.detail || '分析失败，请重试');
      }

      const data = await response.json();
      setAnalysis(data.analysis);
      setDataDimensions(data.data_dimensions || null);
    } catch (err) {
      setError(err instanceof Error ? err.message : '分析失败，请重试');
    } finally {
      setLoading(false);
    }
  };

  const dimensionLabels: Record<string, string> = {
    price: '房价走势',
    poi: '商圈配套',
    crime: '犯罪率',
    transport: '交通',
    schools: '校区',
    compass_score: '综合评分',
    zoning: '土地规划',
    rental: '租赁回报',
  };

  // 8维度展示数据
  const dimensions = [
    { icon: '📈', label: '租赁回报比', desc: '租金收益与房价比率分析' },
    { icon: '💰', label: '房价走势', desc: '中位价、成交量、价格趋势' },
    { icon: '🚆', label: '交通', desc: '火车站、公交站、轻轨可达性' },
    { icon: '🛒', label: '商圈', desc: '华人超市、餐厅、诊所、教堂' },
    { icon: '🛡️', label: '犯罪率', desc: 'QLD 警方犯罪统计与安全指数' },
    { icon: '🏫', label: '校区', desc: 'NAPLAN 成绩、学区划分' },
    { icon: '🏗️', label: '政府宏观发展方向', desc: '城市规划、基建投资、区域发展' },
    { icon: '🌊', label: '是否洪水区', desc: '洪水风险图、历史淹没记录' },
  ];

  return (
    <section className="relative py-16 md:py-20 text-white overflow-hidden">
      {/* 背景图 */}
      <div
        className="absolute inset-0 bg-cover bg-center"
        style={{
          backgroundImage: `url('https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=1920&q=80')`,
        }}
      />
      {/* 深色遮罩 */}
      <div className="absolute inset-0 bg-gradient-to-r from-blue-900/90 to-blue-800/85" />

      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-10 md:mb-16">
          <h2 className="text-2xl md:text-3xl font-bold mb-4">
            AI 多维投资分析引擎
          </h2>
          <p className="text-lg md:text-xl text-blue-100 mb-2 max-w-3xl mx-auto">
            融合 8 大数据维度，生成可执行的投资洞察
          </p>
          <p className="text-blue-200 text-sm max-w-2xl mx-auto">
            租赁回报 · 房价走势 · 交通 · 商圈 · 犯罪率 · 校区 · 政府规划 · 洪水风险
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 md:gap-12 items-start">
          {/* 左侧：8维度展示 */}
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 md:p-8">
            <h3 className="text-xl md:text-2xl font-semibold mb-6">8 大数据维度</h3>

            {/* 手机端：2列紧凑 / 桌面端：列表 */}
            <div className="grid grid-cols-2 md:grid-cols-1 gap-3 md:gap-4">
              {dimensions.map((item) => (
                <div key={item.label} className="flex items-start gap-2 md:gap-4">
                  <div className="bg-white/20 rounded-full w-8 h-8 md:w-10 md:h-10 flex items-center justify-center flex-shrink-0 text-sm md:text-base">
                    {item.icon}
                  </div>
                  <div className="min-w-0">
                    <h4 className="font-semibold text-sm md:text-base leading-tight">{item.label}</h4>
                    <p className="text-blue-200 text-[11px] md:text-sm hidden md:block">{item.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* 右侧：输入表单 + 结果 */}
          <div className="bg-white rounded-xl shadow-2xl overflow-hidden">
            <div className="p-6 md:p-8">
              <h3 className="text-xl md:text-2xl font-bold text-gray-900 mb-6">AI 投资报告</h3>
              <form className="space-y-4" onSubmit={handleSubmit}>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">房产地址</label>
                  <input
                    type="text"
                    placeholder="如: 10 Main St, Sunnybank"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  />
                  <p className="text-xs text-gray-400 mt-1">
                    支持: Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton
                  </p>
                </div>
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white py-4 rounded-lg font-medium transition-colors text-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
                >
                  {loading ? (
                    <>
                      <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                      </svg>
                      AI 分析中 (8维度)...
                    </>
                  ) : (
                    '🤖 开始 AI 分析'
                  )}
                </button>
              </form>

              {/* 加载中状态 */}
              {loading && (
                <div className="mt-4 p-4 bg-blue-50 rounded-lg border border-blue-100">
                  <p className="text-sm text-blue-800 mb-2 font-medium">正在加载多维数据...</p>
                  <div className="grid grid-cols-2 gap-2">
                    {Object.entries(dimensionLabels).map(([key, label], i) => (
                      <div key={key} className="flex items-center gap-2">
                        <div className={`w-2 h-2 rounded-full ${i < 5 ? 'bg-green-500' : 'bg-blue-400 animate-pulse'}`} />
                        <span className="text-xs text-gray-600">{label}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {error && (
                <div className="mt-4 p-4 bg-red-100 text-red-800 rounded-lg">
                  {error}
                </div>
              )}

              {/* 数据维度标签 */}
              {dataDimensions && (
                <div className="mt-4 flex flex-wrap gap-2">
                  {Object.entries(dataDimensions).map(([key, available]) => (
                    <span
                      key={key}
                      className={`text-xs px-2 py-1 rounded-full ${
                        available ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-400'
                      }`}
                    >
                      {available ? '✓' : '✕'} {dimensionLabels[key] || key}
                    </span>
                  ))}
                </div>
              )}

              {/* AI 报告 */}
              {analysis && (
                <div className="mt-6 p-4 md:p-6 bg-gray-50 rounded-lg border border-gray-200 max-h-[500px] overflow-y-auto">
                  <div className="prose prose-sm max-w-none">
                    {analysis.split('\n').map((line, i) => {
                      if (line.startsWith('## ')) return <h3 key={i} className="text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1">{line.replace('## ', '')}</h3>;
                      if (line.startsWith('### ')) return <h4 key={i} className="text-base font-semibold text-blue-800 mt-3 mb-1">{line.replace('### ', '')}</h4>;
                      if (line.startsWith('- ')) return <li key={i} className="ml-4 text-gray-700 mb-1 text-sm">{line.replace('- ', '')}</li>;
                      if (line.startsWith('**') && line.endsWith('**')) return <p key={i} className="font-semibold text-gray-900 mt-2 text-sm">{line.replace(/\*\*/g, '')}</p>;
                      if (line.trim() === '') return <br key={i} />;
                      return <p key={i} className="text-gray-700 mb-1 text-sm">{line}</p>;
                    })}
                  </div>
                  <div className="mt-4 pt-3 border-t border-gray-200 text-center">
                    <span className="text-xs text-gray-400">Powered by Compass AI 引擎 | {new Date().toLocaleString('zh-CN')}</span>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
