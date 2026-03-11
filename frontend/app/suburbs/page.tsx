'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Navbar from '../components/Navbar';
import { fetcher } from '../lib/api';

interface SuburbStat {
  suburb: string;
  median_price: number;
  total_sales: number;
}

const SUBURB_DESCRIPTIONS: Record<string, string> = {
  'Sunnybank': '布里斯班最大华人社区，餐饮购物极其便利',
  'Eight Mile Plains': '交通枢纽，靠近科技园区，投资潜力大',
  'Calamvale': '新兴家庭社区，学区优质，性价比高',
  'Rochedale': '快速发展区，大量新开发项目',
  'Mansfield': '成熟社区，顶级学区，环境优美',
  'Ascot': '传统富人区，赛马场周边，高端物业',
  'Hamilton': '滨河高端区，Portside商圈，生活品质一流',
};

const SUBURB_ICONS: Record<string, string> = {
  'Sunnybank': '🏮',
  'Eight Mile Plains': '🚉',
  'Calamvale': '🏡',
  'Rochedale': '🏗️',
  'Mansfield': '🎓',
  'Ascot': '🏇',
  'Hamilton': '🌊',
};

function formatPrice(price: number) {
  if (!price) return '-';
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency: 'AUD',
    maximumFractionDigits: 0,
  }).format(price);
}

export default function SuburbsPage() {
  const router = useRouter();
  const [suburbs, setSuburbs] = useState<SuburbStat[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      try {
        const data = await fetcher('/api/home');
        if (data?.suburb_stats) {
          setSuburbs(data.suburb_stats);
        }
      } catch (error) {
        console.error('Failed to load suburbs:', error);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="suburbs" />

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">布里斯班 Suburbs 总览</h1>
          <p className="text-lg text-gray-600">探索布里斯班热门华人投资区域，点击查看详细数据分析</p>
        </div>

        {loading ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <div key={i} className="bg-white rounded-xl shadow-sm border p-6 animate-pulse">
                <div className="h-8 bg-gray-200 rounded mb-4 w-2/3"></div>
                <div className="h-4 bg-gray-200 rounded mb-2"></div>
                <div className="h-4 bg-gray-200 rounded mb-6 w-1/2"></div>
                <div className="flex gap-4">
                  <div className="h-12 bg-gray-200 rounded flex-1"></div>
                  <div className="h-12 bg-gray-200 rounded flex-1"></div>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {suburbs.map((suburb) => (
              <div
                key={suburb.suburb}
                onClick={() => router.push(`/suburb/${encodeURIComponent(suburb.suburb)}`)}
                className="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-lg hover:border-blue-300 transition-all cursor-pointer group"
              >
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <span className="text-2xl">{SUBURB_ICONS[suburb.suburb] || '🏠'}</span>
                      <h2 className="text-xl font-bold text-gray-900 group-hover:text-blue-600 transition-colors">
                        {suburb.suburb}
                      </h2>
                    </div>
                    <p className="text-sm text-gray-500">
                      {SUBURB_DESCRIPTIONS[suburb.suburb] || '布里斯班优质投资区域'}
                    </p>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4 mb-4">
                  <div className="bg-blue-50 rounded-lg p-3 text-center">
                    <p className="text-xs text-gray-500 mb-1">中位价</p>
                    <p className="text-lg font-bold text-blue-600">
                      {formatPrice(suburb.median_price)}
                    </p>
                  </div>
                  <div className="bg-green-50 rounded-lg p-3 text-center">
                    <p className="text-xs text-gray-500 mb-1">成交量</p>
                    <p className="text-lg font-bold text-green-600">
                      {suburb.total_sales} 套
                    </p>
                  </div>
                </div>

                <div className="flex items-center justify-between text-sm">
                  <span className="text-gray-400">点击查看详细分析</span>
                  <span className="text-blue-500 group-hover:text-blue-700 font-medium transition-colors">
                    查看详情 →
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}
