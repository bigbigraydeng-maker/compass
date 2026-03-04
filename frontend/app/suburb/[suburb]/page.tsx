import Link from 'next/link';
import { notFound } from 'next/navigation';

async function getSuburbData(suburbName: string) {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
  const res = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}`, {
    next: { revalidate: 3600 }
  });
  
  if (!res.ok) {
    notFound();
  }
  
  return res.json();
}

function formatPrice(price: number) {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

export default async function SuburbPage({ params }: { params: { suburb: string } }) {
  const suburbName = decodeURIComponent(params.suburb);
  const data = await getSuburbData(suburbName);

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Compass
            </Link>
            <div className="flex space-x-8">
              <Link href="/" className="text-gray-600 hover:text-blue-600 transition">首页</Link>
              <Link href="/sales" className="text-gray-600 hover:text-blue-600 transition">成交列表</Link>
              <span className="text-blue-600 font-medium">{suburbName}</span>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <Link href="/" className="text-blue-600 hover:text-blue-700 font-medium">
            ← 返回首页
          </Link>
        </div>

        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl p-8 mb-8">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">{data.suburb}</h1>
          <p className="text-blue-100">布里斯班华人热门区域</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">中位价</h3>
            <p className="text-4xl font-bold text-blue-600">
              {formatPrice(data.median_price)}
            </p>
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">成交数量</h3>
            <p className="text-4xl font-bold text-blue-600">
              {data.total_sales} 套
            </p>
          </div>
        </div>

        <div className="bg-white rounded-xl shadow-sm border">
          <div className="px-6 py-4 border-b">
            <h2 className="text-lg font-semibold text-gray-800">最近成交</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">土地面积</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {data.recent_sales.map((sale: any) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.land_size} m²</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="mt-8">
          <Link
            href="/sales"
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition font-medium inline-block"
          >
            查看更多成交 →
          </Link>
        </div>
      </main>

      <footer className="bg-white border-t mt-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 text-center text-gray-500 text-sm">
          <p>© 2026 Compass - 布里斯班华人房地产数据平台</p>
        </div>
      </footer>
    </div>
  );
}
