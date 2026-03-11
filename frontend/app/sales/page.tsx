'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Navbar from '../components/Navbar';
import { fetcher } from '../lib/api';

interface Sale {
  id: number;
  property_id: number;
  sold_price: number;
  sold_date: string;
  address: string;
  suburb: string;
  property_type: string;
  land_size: number;
  bedrooms: number;
  bathrooms: number;
}

interface SalesResponse {
  sales: Sale[];
  total: number;
  page: number;
  page_size: number;
}

function formatPrice(price: number) {
  if (!price || price === 0) return '-';
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

function formatDate(dateString: string) {
  if (!dateString) return '-';
  const date = new Date(dateString);
  return date.toLocaleDateString('zh-CN');
}

export default function SalesPage() {
  const [sales, setSales] = useState<Sale[]>([]);
  const [total, setTotal] = useState<number | null>(null);
  const [page, setPage] = useState(1);
  const [suburb, setSuburb] = useState('');
  const [propertyType, setPropertyType] = useState('');
  const [bedrooms, setBedrooms] = useState('');
  const [minPrice, setMinPrice] = useState('');
  const [maxPrice, setMaxPrice] = useState('');
  const [minDate, setMinDate] = useState('');
  const [maxDate, setMaxDate] = useState('');
  const [loading, setLoading] = useState(true);
  const perPage = 20;

  useEffect(() => {
    fetchSales();
  }, [page, suburb, propertyType, bedrooms, minPrice, maxPrice, minDate, maxDate]);

  const fetchSales = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (suburb) params.append('suburb', suburb);
      if (propertyType) params.append('property_type', propertyType);
      if (bedrooms) params.append('bedrooms', bedrooms);
      if (minPrice) params.append('min_price', minPrice);
      if (maxPrice) params.append('max_price', maxPrice);
      if (minDate) params.append('min_date', minDate);
      if (maxDate) params.append('max_date', maxDate);
      params.append('page', page.toString());
      params.append('page_size', perPage.toString());
      
      const data = await fetcher(`/api/sales?${params}`);
      setSales(data.sales || []);
      setTotal(data.total || 0);
    } catch (error) {
      console.error('Error fetching sales:', error);
      setSales([]);
      setTotal(null);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = total ? Math.ceil(total / perPage) : 0;

  const resetFilters = () => {
    setSuburb('');
    setPropertyType('');
    setBedrooms('');
    setMinPrice('');
    setMaxPrice('');
    setMinDate('');
    setMaxDate('');
    setPage(1);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 导航栏 */}
      <Navbar activePage="sales" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-800 mb-6">成交记录</h1>

        {/* 筛选器 */}
        <div className="bg-white rounded-xl shadow-sm border p-4 mb-6">
          <div className="flex flex-wrap items-center gap-4 mb-4">
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">Suburb：</label>
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
                <option value="Rochedale">Rochedale</option>
                <option value="Mansfield">Mansfield</option>
                <option value="Ascot">Ascot</option>
                <option value="Hamilton">Hamilton</option>
              </select>
            </div>
            
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">类型：</label>
              <select
                value={propertyType}
                onChange={(e) => {
                  setPropertyType(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">全部</option>
                <option value="House">House</option>
                <option value="Unit">Unit</option>
                <option value="Townhouse">Townhouse</option>
              </select>
            </div>
            
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">卧室：</label>
              <select
                value={bedrooms}
                onChange={(e) => {
                  setBedrooms(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">全部</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5+</option>
              </select>
            </div>
          </div>
          
          <div className="flex flex-wrap items-center gap-4 mb-4">
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">价格范围：</label>
              <input
                type="number"
                placeholder="最低"
                value={minPrice}
                onChange={(e) => {
                  setMinPrice(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 w-32"
              />
              <span> - </span>
              <input
                type="number"
                placeholder="最高"
                value={maxPrice}
                onChange={(e) => {
                  setMaxPrice(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 w-32"
              />
            </div>
          </div>
          
          <div className="flex flex-wrap items-center gap-4">
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">日期范围：</label>
              <input
                type="date"
                value={minDate}
                onChange={(e) => {
                  setMinDate(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <span> - </span>
              <input
                type="date"
                value={maxDate}
                onChange={(e) => {
                  setMaxDate(e.target.value);
                  setPage(1);
                }}
                className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            
            <button
              onClick={resetFilters}
              className="px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg text-gray-700 transition"
            >
              重置筛选
            </button>
            
            {!loading && total !== null && (
              <span className="text-gray-600">共 {total} 条记录</span>
            )}
            {loading && (
              <span className="text-gray-600">加载中...</span>
            )}
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
              <div className="overflow-x-auto w-full">
                <table className="min-w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Suburb</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卧室</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卫浴</th>
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
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bedrooms}🛏</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.bathrooms}🚿</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{sale.land_size} m²</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-green-600">
                          {formatPrice(sale.sold_price)}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{formatDate(sale.sold_date)}</td>
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
    </div>
  );
}
