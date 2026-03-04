import Link from 'next/link';
import { notFound } from 'next/navigation';

interface SuburbData {
  name: string;
  stats: {
    median_price: number;
    avg_price: number;
    total_sales: number;
  };
  recent_sales: Array<{
    id: number;
    address: string;
    sold_price: number;
    sold_date: string;
    bedrooms: number;
    property_type: string;
  }>;
}

async function getSuburbData(suburbName: string): Promise<SuburbData> {
  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';
  const res = await fetch(`${apiUrl}/api/suburb/${encodeURIComponent(suburbName)}`, {
    next: { revalidate: 3600 } // ISR: 每小时重新验证
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
      {/* 导航栏 */}
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
        {/* 返回按钮 */}
        <div className="mb-6">
          <Link href="/" className="text-blue-600 hover:text-blue-700 font-medium">
            ← 返回首页
          </Link>
        </div>

        {/* Suburb 标题区 */}
        <div className="bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-xl p-8 mb-8">
          <h1 className="text-3xl md:text-4xl font-bold mb-2">{suburbName}</h1>
          <p className="text-blue-100">布里斯班华人热门区域</p>
        </div>

        {/* 统计卡片 */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">中位价</h3>
            <p className="text-4xl font-bold text-blue-600">
              {formatPrice(data.stats.median_price)}
            </p>
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">平均价</h3>
            <p className="text-4xl font-bold text-blue-600">
              {formatPrice(data.stats.avg_price)}
            </p>
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="text-lg font-semibold text-gray-700 mb-4">成交数量</h3>
            <p className="text-4xl font-bold text-blue-600">
              {data.stats.total_sales} 套
            </p>
          </div>
        </div>

        {/* 最近成交 */}
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
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卧室</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {data.recent_sales.map((sale) => (
                  <tr key={sale.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bedrooms}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* 分享按钮 */}
        <div className="mt-8 flex flex-wrap gap-4">
          <button
            onClick={() => {
              if (typeof navigator !== 'undefined' && navigator.share) {
                navigator.share({
                  title: `${suburbName} 房产数据`,
                  text: `${suburbName} 中位价 ${formatPrice(data.stats.median_price)}，成交 ${data.stats.total_sales} 套`,
                  url: typeof window !== 'undefined' ? window.location.href : ''
                });
              } else if (typeof navigator !== 'undefined') {
                navigator.clipboard.writeText(typeof window !== 'undefined' ? window.location.href : '');
                alert('链接已复制到剪贴板');
              }
            }}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition font-medium"
          >
            分享此页面
          </button>
          <Link
            href="/sales"
            className="bg-gray-200 text-gray-700 px-6 py-3 rounded-lg hover:bg-gray-300 transition font-medium text-center"
          >
            查看更多成交
          </Link>
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
