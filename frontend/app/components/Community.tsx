export default function Community() {
  return (
    <section className="py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-3xl font-bold text-gray-900 mb-4">
            社区
          </h2>
          <p className="text-lg text-gray-600">
            加入我们的布里斯班华人房产投资者社区
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div className="bg-white rounded-xl shadow-md p-8 text-center hover:shadow-lg transition-shadow">
            <div className="text-4xl mb-4">👥</div>
            <h3 className="text-xl font-semibold mb-3">投资者网络</h3>
            <p className="text-gray-600 mb-4">与布里斯班其他华人投资者建立联系</p>
            <button className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
              加入网络
            </button>
          </div>
          
          <div className="bg-white rounded-xl shadow-md p-8 text-center hover:shadow-lg transition-shadow">
            <div className="text-4xl mb-4">📚</div>
            <h3 className="text-xl font-semibold mb-3">投资资源</h3>
            <p className="text-gray-600 mb-4">访问房产投资指南和资源</p>
            <button className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
              探索资源
            </button>
          </div>
          
          <div className="bg-white rounded-xl shadow-md p-8 text-center hover:shadow-lg transition-shadow">
            <div className="text-4xl mb-4">📢</div>
            <h3 className="text-xl font-semibold mb-3">市场更新</h3>
            <p className="text-gray-600 mb-4">获取最新市场新闻和趋势</p>
            <button className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
              订阅
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
