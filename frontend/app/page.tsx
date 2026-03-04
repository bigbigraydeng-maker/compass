import Link from 'next/link';

async function getHomeData() {
  const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'}/api/home`, {
    next: { revalidate: 60 } // 每分钟重新验证
  });
  if (!res.ok) throw new Error('Failed to fetch data');
  return res.json();
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

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 导航栏 */}
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Compass
            </Link>
            <div className="flex space-x-8">
              <Link href="/" className="text-blue-600 font-medium">首页</Link>
              <Link href="/sales" className="text-gray-600 hover:text-blue-600 transition">成交列表</Link>
              <Link href="/suburb/Sunnybank" className="text-gray-600 hover:text-blue-600 transition">Sunnybank</Link>
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
            专注于 Sunnybank、Eight Mile Plains、Calamvale 三个区域
          </p>
        </div>

        {/* Suburb 统计卡片 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {data.suburbs.map((suburb: any) => (
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
                {data.latest_sales.map((sale: any) => (
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
        </div>
      </main>

      {/* 页脚 */}
      <footer className="bg-white border-t mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 text-center text-gray-500 text-sm">
          <p>© 2026 Compass - 布里斯班华人房地产数据平台</p>
        </div>
      </footer>
    </div>
  );
}
