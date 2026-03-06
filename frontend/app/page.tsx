import Link from 'next/link';

async function getHomeData() {
  try {
    const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com'}/api/home`, {
      next: { revalidate: 60 }
    });
    if (!res.ok) return { latest_sales: [], suburb_stats: [] };
    return res.json();
  } catch (e) {
    return { latest_sales: [], suburb_stats: [] };
  }
}

function formatPrice(price: number) {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

export default async function Home() {
  const data = await getHomeData();
  
  // 确保数据结构完整
  const suburbs = data?.suburbs || [];
  const latestSales = data?.latest_sales || [];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 导航栏 */}
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Compass
            </Link>
            <div className="flex space-x-6">
              <Link href="/" className="text-blue-600 font-medium">首页</Link>
              <Link href="/sales" className="text-gray-600 hover:text-blue-600 transition">成交列表</Link>
              <Link href="/listings" className="text-gray-600 hover:text-blue-600 transition">在售房源</Link>
              <Link href="/suburb/Sunnybank" className="text-gray-600 hover:text-blue-600 transition">Sunnybank</Link>
              <Link href="/suburb/Eight Mile Plains" className="text-gray-600 hover:text-blue-600 transition">Eight Mile Plains</Link>
              <Link href="/suburb/Calamvale" className="text-gray-600 hover:text-blue-600 transition">Calamvale</Link>
              <Link href="/suburb/Rochedale" className="text-gray-600 hover:text-blue-600 transition">Rochedale</Link>
              <Link href="/suburb/Mansfield" className="text-gray-600 hover:text-blue-600 transition">Mansfield</Link>
              <Link href="/suburb/Ascot" className="text-gray-600 hover:text-blue-600 transition">Ascot</Link>
              <Link href="/suburb/Hamilton" className="text-gray-600 hover:text-blue-600 transition">Hamilton</Link>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* 主标题区 */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl p-8 mb-8">
          <h1 className="text-3xl md:text-4xl font-bold mb-4">
            布里斯班华人房地产数据平台
          </h1>
          <p className="text-blue-100 text-lg">
            专注于 Sunnybank、Eight Mile Plains、Calamvale、Rochedale、Mansfield、Ascot、Hamilton 七个区域
          </p>
        </div>

        {/* Suburb 统计卡片 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {suburbs.map((suburb: any) => (
            <Link
              key={suburb.name}
              href={`/suburb/${encodeURIComponent(suburb.name)}`}
              className="bg-white rounded-xl shadow-sm border hover:shadow-md transition-shadow p-6"
            >
              <h3 className="text-lg font-semibold text-gray-800 mb-4">{suburb.name}</h3>
              <div className="space-y-2">
                <div>
                  <p className="text-sm text-gray-500">中位价</p>
                  <p className="text-2xl font-bold text-blue-600">{formatPrice(suburb.median_price)}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">成交数量</p>
                  <p className="text-lg font-semibold text-gray-800">{suburb.total_sales} 套</p>
                </div>
              </div>
              <div className="mt-4 text-blue-600 text-sm font-medium">
                查看详情 →
              </div>
            </Link>
          ))}
        </div>

        {/* 最新成交 */}
        <div className="bg-white rounded-xl shadow-sm border">
          <div className="px-6 py-4 border-b flex justify-between items-center">
            <h2 className="text-lg font-semibold text-gray-800">最新成交</h2>
            <Link href="/sales" className="text-blue-600 hover:text-blue-700 text-sm font-medium">
              查看全部 →
            </Link>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">郊区</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {latestSales.map((sale: any) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.suburb}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="px-6 py-4 text-center text-sm text-gray-500">© 2026 Compass - 布里斯班华人房地产数据平台</p>
        </div>
      </main>
    </div>
  );
}
