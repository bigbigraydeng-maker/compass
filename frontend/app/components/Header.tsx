'use client';

import Link from 'next/link';
import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function Header() {
  const router = useRouter();
  const [searchQuery, setSearchQuery] = useState('');

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    const q = searchQuery.trim();
    if (q) {
      router.push(`/suburb/${encodeURIComponent(q)}`);
      setSearchQuery('');
    }
  };

  return (
    <header className="bg-white border-b shadow-sm sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2">
            <span className="text-2xl font-bold text-blue-600">Compass</span>
          </Link>

          {/* Navigation */}
          <nav className="hidden md:flex space-x-8">
            <Link href="/suburbs" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              郊区
            </Link>
            <Link href="/listings" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              在售房源
            </Link>
            <Link href="/sales" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              成交记录
            </Link>
            <Link href="/rankings" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              排名
            </Link>
            <Link href="/new-developments" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              新楼盘
            </Link>
          </nav>

          {/* Search */}
          <form onSubmit={handleSearch} className="flex items-center">
            <div className="relative">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="搜索郊区"
                className="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button type="submit" className="absolute left-3 top-2.5 text-gray-400 hover:text-blue-500">
                🔍
              </button>
            </div>
          </form>
        </div>
      </div>
    </header>
  );
}
