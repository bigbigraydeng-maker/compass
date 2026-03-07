export default function AIPropertyAnalysis() {
  return (
    <section className="py-20 bg-gradient-to-r from-blue-900 to-blue-700 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold mb-6">
            AI Property Analysis
          </h2>
          <p className="text-xl text-blue-100 mb-12 max-w-3xl mx-auto">
            Leverage AI to analyze any property and get detailed investment insights
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div className="bg-white/10 backdrop-blur-sm rounded-xl p-8">
            <h3 className="text-2xl font-semibold mb-6">How It Works</h3>
            <div className="space-y-6">
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">1</div>
                <div>
                  <h4 className="font-semibold mb-2">Enter Property Details</h4>
                  <p className="text-blue-100">Provide address or paste Domain/Realestate URL</p>
                </div>
              </div>
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">2</div>
                <div>
                  <h4 className="font-semibold mb-2">AI Analysis</h4>
                  <p className="text-blue-100">Our AI analyzes market data and comparable sales</p>
                </div>
              </div>
              <div className="flex items-start gap-4">
                <div className="bg-white/20 rounded-full w-10 h-10 flex items-center justify-center flex-shrink-0">3</div>
                <div>
                  <h4 className="font-semibold mb-2">Get Insights</h4>
                  <p className="text-blue-100">Receive detailed investment report and recommendations</p>
                </div>
              </div>
            </div>
          </div>
          
          <div className="bg-white rounded-xl shadow-2xl overflow-hidden">
            <div className="p-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-6">Try AI Analysis</h3>
              <form className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Property Address</label>
                  <input
                    type="text"
                    placeholder="123 Main St, Sunnybank"
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">Or Paste URL</label>
                  <input
                    type="text"
                    placeholder="https://www.domain.com.au/..."
                    className="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                </div>
                <button
                  type="button"
                  className="w-full bg-blue-600 hover:bg-blue-700 text-white py-4 rounded-lg font-medium transition-colors text-lg"
                >
                  🤖 Start AI Analysis
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
