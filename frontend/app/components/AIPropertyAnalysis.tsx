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
      setError('Please enter a property address');
      return;
    }

    setLoading(true);
    setError(null);
    setAnalysis(null);
    setDataDimensions(null);

    try {
      const response = await fetch(`${API_BASE}/api/analyze`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ address }),
      });

      if (!response.ok) {
        const errData = await response.json().catch(() => ({}));
        throw new Error(errData.detail || 'Analysis failed, please try again');
      }

      const data = await response.json();
      setAnalysis(data.analysis);
      setDataDimensions(data.data_dimensions || null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Analysis failed, please try again');
    } finally {
      setLoading(false);
    }
  };

  const dimensionLabels: Record<string, string> = {
    price: 'Market Price',
    poi: 'Chinese POI',
    crime: 'Safety Stats',
    transport: 'Transport',
    schools: 'School Quality',
    compass_score: 'Compass Score',
    zoning: 'Land Zoning',
  };

  return (
    <section className="py-20 bg-gradient-to-r from-blue-900 to-blue-700 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-6">
            AI Multi-Dimensional Analysis
          </h2>
          <p className="text-xl text-blue-100 mb-4 max-w-3xl mx-auto">
            Integrating POI, crime, transport, school, zoning and market data
          </p>
          <p className="text-blue-200 max-w-2xl mx-auto">
            Powered by 7-dimensional data engine for actionable investment insights
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-start">
          {/* Left: Data dimensions showcase */}
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-8">
            <h3 className="text-2xl font-semibold mb-6">7 Data Dimensions</h3>
            <div className="space-y-4">
              {[
                { icon: '$', label: 'Market Price', desc: 'Median price, sales volume, price trends' },
                { icon: 'P', label: 'Chinese POI', desc: 'Chinese restaurants, shops, churches, clinics' },
                { icon: 'S', label: 'Safety', desc: 'QLD Police crime statistics by category' },
                { icon: 'T', label: 'Transport', desc: 'Train, bus, light rail stations nearby' },
                { icon: 'E', label: 'Education', desc: 'NAPLAN scores, catchment schools' },
                { icon: 'Z', label: 'Zoning', desc: 'Residential density, development potential' },
                { icon: 'C', label: 'Compass Score', desc: 'Proprietary investment rating (5 factors)' },
              ].map((item) => (
                <div key={item.label} className="flex items-start gap-4">
                  <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0 font-bold">
                    {item.icon}
                  </div>
                  <div>
                    <h4 className="font-semibold">{item.label}</h4>
                    <p className="text-blue-200 text-sm">{item.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Right: Input form + results */}
          <div className="bg-white rounded-xl shadow-2xl overflow-hidden">
            <div className="p-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-6">AI Investment Report</h3>
              <form className="space-y-4" onSubmit={handleSubmit}>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Property Address</label>
                  <input
                    type="text"
                    placeholder="e.g. 10 Main St, Sunnybank"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-gray-900"
                  />
                  <p className="text-xs text-gray-400 mt-1">
                    Supports: Sunnybank, Eight Mile Plains, Calamvale, Rochedale, Mansfield, Ascot, Hamilton
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
                      AI Analyzing (7 dimensions)...
                    </>
                  ) : (
                    'Start AI Analysis'
                  )}
                </button>
              </form>

              {/* Loading: Show data dimensions being processed */}
              {loading && (
                <div className="mt-4 p-4 bg-blue-50 rounded-lg border border-blue-100">
                  <p className="text-sm text-blue-800 mb-2 font-medium">Loading multi-dimensional data...</p>
                  <div className="grid grid-cols-2 gap-2">
                    {Object.entries(dimensionLabels).map(([key, label], i) => (
                      <div key={key} className="flex items-center gap-2">
                        <div className={`w-2 h-2 rounded-full ${i < 4 ? 'bg-green-500' : 'bg-blue-400 animate-pulse'}`} />
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

              {/* Data dimension badges */}
              {dataDimensions && (
                <div className="mt-4 flex flex-wrap gap-2">
                  {Object.entries(dataDimensions).map(([key, available]) => (
                    <span
                      key={key}
                      className={`text-xs px-2 py-1 rounded-full ${
                        available
                          ? 'bg-green-100 text-green-700'
                          : 'bg-gray-100 text-gray-400'
                      }`}
                    >
                      {available ? '>' : 'x'} {dimensionLabels[key] || key}
                    </span>
                  ))}
                </div>
              )}

              {/* AI Report Display */}
              {analysis && (
                <div className="mt-6 p-6 bg-gray-50 rounded-lg border border-gray-200 max-h-[500px] overflow-y-auto">
                  <div className="prose prose-sm max-w-none">
                    {analysis.split('\n').map((line, i) => {
                      if (line.startsWith('## ')) {
                        return <h3 key={i} className="text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1">{line.replace('## ', '')}</h3>;
                      }
                      if (line.startsWith('### ')) {
                        return <h4 key={i} className="text-base font-semibold text-blue-800 mt-3 mb-1">{line.replace('### ', '')}</h4>;
                      }
                      if (line.startsWith('- ')) {
                        return <li key={i} className="ml-4 text-gray-700 mb-1 text-sm">{line.replace('- ', '')}</li>;
                      }
                      if (line.startsWith('**') && line.endsWith('**')) {
                        return <p key={i} className="font-semibold text-gray-900 mt-2 text-sm">{line.replace(/\*\*/g, '')}</p>;
                      }
                      if (line.trim() === '') {
                        return <br key={i} />;
                      }
                      return <p key={i} className="text-gray-700 mb-1 text-sm">{line}</p>;
                    })}
                  </div>
                  <div className="mt-4 pt-3 border-t border-gray-200 text-center">
                    <span className="text-xs text-gray-400">Powered by Compass AI Engine | {new Date().toLocaleString('zh-CN')}</span>
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
