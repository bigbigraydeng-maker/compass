'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Navbar from '../components/Navbar';
import { fetcher } from '../lib/api';

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
    maximumFractionDigits: 0,
  }).format(price);
}

export default function NewDevelopmentsPage() {
  const router = useRouter();
  const [listings, setListings] = useState<Listing[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    const loadData = async () => {
      try {
        const data = await fetcher('/api/listings?page_size=12');
        if (data?.listings) {
          setListings(data.listings);
          setTotal(data.total || 0);
        }
      } catch (error) {
        console.error('Failed to load listings:', error);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="new-developments" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Hero banner */}
        <div className="bg-gradient-to-r from-blue-600 to-indigo-700 rounded-2xl p-8 mb-8 text-white">
          <div className="max-w-2xl">
            <h1 className="text-3xl font-bold mb-3">新楼盘</h1>
            <p className="text-blue-100 text-lg mb-6">
              布里斯班最新开发项目和楼盘信息，助您抢先把握投资机会
            </p>
            <div className="bg-white/20 backdrop-blur rounded-xl p-4 border border-white/30">
              <div className="flex items-center gap-3">
                <span className="text-3xl">🏗️</span>
                <div>
                  <p className="font-semibold text-lg">功能建设中</p>
                  <p className="text-blue-100 text-sm">
                    新楼盘专属页面即将上线，将包含：开发商信息、户型图、价格区间、交房时间等
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Current listings preview */}
        <div className="mb-6">
          <div className="flex justify-between items-center mb-4">
            <div>
              <h2 className="text-2xl font-bold text-gray-900">最新在售房源</h2>
              <p className="text-gray-500 mt-1">共 {total} 套房源在售</p>
            </div>
            <button
              onClick={() => router.push('/listings')}
              className="text-blue-600 hover:text-blue-800 font-medium transition-colors"
            >
              查看全部房源 →
            </button>
          </div>
        </div>

        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <div key={i} className="bg-white rounded-xl shadow-sm border p-6 animate-pulse">
                <div className="h-6 bg-gray-200 rounded mb-3 w-3/4"></div>
                <div className="h-4 bg-gray-200 rounded mb-2 w-1/2"></div>
                <div className="h-4 bg-gray-200 rounded mb-4 w-1/3"></div>
                <div className="h-8 bg-gray-200 rounded"></div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {listings.map((listing) => (
              <div
                key={listing.id}
                className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-lg hover:border-blue-300 transition-all"
              >
                <div className="mb-3">
                  <h3 className="font-bold text-gray-900 mb-1 line-clamp-2">{listing.address}</h3>
                  <p
                    className="text-sm text-blue-600 hover:text-blue-800 cursor-pointer font-medium"
                    onClick={() => router.push(`/suburb/${encodeURIComponent(listing.suburb)}`)}
                  >
                    {listing.suburb} →
                  </p>
                </div>

                <div className="flex flex-wrap gap-2 mb-3">
                  <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                    {listing.property_type}
                  </span>
                  {listing.bedrooms > 0 && (
                    <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                      {listing.bedrooms} 卧
                    </span>
                  )}
                  {listing.bathrooms > 0 && (
                    <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                      {listing.bathrooms} 卫
                    </span>
                  )}
                  {listing.car_spaces > 0 && (
                    <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                      {listing.car_spaces} 车位
                    </span>
                  )}
                  {listing.land_size > 0 && (
                    <span className="bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs">
                      {listing.land_size}m²
                    </span>
                  )}
                </div>

                <div className="flex items-center justify-between">
                  <p className="text-lg font-bold text-green-600">
                    {listing.price_text || formatPrice(listing.price)}
                  </p>
                  {listing.link && (
                    <a
                      href={listing.link}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-sm text-blue-600 hover:text-blue-800 hover:underline"
                    >
                      查看详情 →
                    </a>
                  )}
                </div>

                {listing.agent_company && (
                  <p className="text-xs text-gray-400 mt-2">{listing.agent_company}</p>
                )}
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
