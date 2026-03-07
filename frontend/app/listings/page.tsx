'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import Navbar from '../components/Navbar';

interface Listing {
  id: number;
  address: string;
  suburb: string;
  property_type: string;
  bedrooms: number;
  bathrooms: number;
  car_spaces: number;
  land_size: number;
  price_text: string;
  price: number;
  agent_name: string;
  agent_company: string;
  link: string;
}

function formatPrice(price: number) {
  if (!price || price === 0) return '-';
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0
  }).format(price);
}

export default function ListingsPage() {
  const [listings, setListings] = useState<Listing[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [suburb, setSuburb] = useState('');
  const [propertyType, setPropertyType] = useState('');
  const [bedrooms, setBedrooms] = useState('');
  const [minPrice, setMinPrice] = useState('');
  const [maxPrice, setMaxPrice] = useState('');
  const [loading, setLoading] = useState(true);
  const perPage = 20;

  useEffect(() => {
    fetchListings();
  }, [page, suburb, propertyType, bedrooms, minPrice, maxPrice]);

  const fetchListings = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (suburb) params.append('suburb', suburb);
      if (propertyType) params.append('property_type', propertyType);
      if (bedrooms) params.append('bedrooms', bedrooms);
      if (minPrice) params.append('min_price', minPrice);
      if (maxPrice) params.append('max_price', maxPrice);
      params.append('page', page.toString());
      params.append('page_size', perPage.toString());
      
      const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const response = await fetch(`${apiUrl}/api/listings?${params}`);
      if (!response.ok) {
        setListings([]);
        setTotal(0);
        return;
      }
      const data = await response.json();
      setListings(data.listings || []);
      setTotal(data.total || 0);
    } catch (error) {
      console.error('Error fetching listings:', error);
      setListings([]);
      setTotal(0);
    } finally {
      setLoading(false);
    }
  };

  const totalPages = Math.ceil(total / perPage);

  const resetFilters = () => {
    setSuburb('');
    setPropertyType('');
    setBedrooms('');
    setMinPrice('');
    setMaxPrice('');
    setPage(1);
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* 导航栏 */}
      <Navbar activePage="listings" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <h1 className="text-3xl font-bold text-gray-800 mb-6">在售房源</h1>

        {/* 筛选器 */}
        <div className="bg-white rounded-xl shadow-sm border p-4 mb-6">
          <div className="flex flex-wrap items-center gap-4 mb-4">
            <div className="flex items-center space-x-2">
              <label className="text-gray-700 font-medium">郊区：</label>
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
                <option value="vacant_land">Vacant Land</option>
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
          
          <div className="flex flex-wrap items-center gap-4">
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
            
            <button
              onClick={resetFilters}
              className="px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg text-gray-700 transition"
            >
              重置筛选
            </button>
            
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
              <div className="overflow-x-auto w-full">
                <table className="min-w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">地址</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">郊区</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">类型</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卧室</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">卫浴</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">车位</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">挂牌价格</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">中介公司</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">链接</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {listings.map((listing) => (
                      <tr key={listing.id} className="hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{listing.address}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.suburb}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.property_type}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.bedrooms}🛏</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.bathrooms}🚿</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.car_spaces > 0 ? `${listing.car_spaces}🚗` : '-'}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-green-600">
                          {listing.price_text || formatPrice(listing.price)}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-600">{listing.agent_company || '-'}</td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm">
                          {listing.link ? (
                            <a 
                              href={listing.link} 
                              target="_blank" 
                              rel="noopener noreferrer"
                              className="text-blue-600 hover:text-blue-800 hover:underline"
                            >
                              查看详情 →
                            </a>
                          ) : (
                            '-'
                          )}
                        </td>
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
