'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';

interface Sale {
  id: number;
  address: string;
  suburb: string;
  sold_price: number;
  sold_date: string;
  bedrooms: number;
  bathrooms: number;
  land_size: number;
  building_size: number;
  property_type: string;
}

function formatPrice(price: number) {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

export default function SalesPage() {
  const [sales, setSales] = useState<Sale[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [suburb, setSuburb] = useState('');
  const [loading, setLoading] = useState(true);
  const perPage = 20;

  useEffect(() => {
    fetchSales();
  }, [page, suburb]);

  const fetchSales = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (suburb) params.append('suburb', suburb);
      params.append('page', page.toString());
      params.append('page_size', perPage.toString());
      
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const response = await fetch(`${apiUrl}/api/sales?${params}`);
      const data = await response.json();
      setSales(data.sales);
      setTotal(data.total);
    } catch (error) {
      console.error('Error fetching sales:', error);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(total / perPage);

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
              <Link href="/sales" className="text-blue-600 font-medium">成交列表</Link>
              <Link href="/suburb/Sunnybank" className="text-gray-600 hover:text-blue-600 transition">Sunnybank</Link>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-800 mb-6">成交列表</h1>

        {/* 筛选器 */}
        <div className="bg-white rounded-xl shadow-sm border p-4 mb-6">
          <div className="flex flex-wrap items-center gap-4">
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">筛选郊区：</label>
              <select
                value={suburb}
                onChange={(e) => {
                  setSuburb(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">全部</option>
                <option value="Sunnybank">Sunnybank</option>
                <option value="Eight Mile Plains">Eight Mile Plains</option>
                <option value="Calamvale">Calamvale</option>
              </select>
            </div>
            <span className="text-gray-600">共 {total} 条记录</span>
          </div>
        </div>

        {/* 数据表格 */}
        {loading ? (
          <div className="text-center py-12">
            <p className="text-gray-600">加载中...</p>
          </div>
        ) : (
          <>
            <div className="bg-white rounded-xl shadow-sm border overflow-hidden">
              <div className="overflow-x-auto">
                <table className="min-w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">郊区</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卧室</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">土地面积</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交价</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">成交日期</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {sales.map((sale) => (
                      <tr key={sale.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{sale.address}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.suburb}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.property_type}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bedrooms}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.land_size} m²</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-blue-600">{formatPrice(sale.sold_price)}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.sold_date}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* 分页 */}
            {totalPages > 1 && (
              <div className="flex justify-center items-center space-x-2 mt-6">
                <button
                  onClick={() => setPage(p => Math.max(1, p - 1))}
                  disabled={page === 1}
                  className="px-4 py-2 border rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
                >
                  上一页
                </button>
                <span className="text-gray-600">
                  第 {page} 页 / 共 {totalPages} 页
                </span>
                <button
                  onClick={() => setPage(p => Math.min(totalPages, p + 1))}
                  disabled={page === totalPages}
                  className="px-4 py-2 border rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
                >
                  下一页
                </button>
              </div>
            )}
          </>
        )}
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
