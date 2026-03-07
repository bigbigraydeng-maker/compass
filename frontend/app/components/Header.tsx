import Link from 'next/link';

export default function Header() {
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
            <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
              郊区
            </Link>
            <Link href="/listings" className="text-gray-700 hover:text-blue-600 font-medium">
              在售房源
            </Link>
            <Link href="/sales" className="text-gray-700 hover:text-blue-600 font-medium">
              成交记录
            </Link>
            <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
              排名
            </Link>
            <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
              新楼盘
            </Link>
          </nav>

          {/* Search */}
          <div className="flex items-center">
            <div className="relative">
              <input
                type="text"
                placeholder="搜索郊区"
                className="pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <span className="absolute left-3 top-2.5 text-gray-400">🔍</span>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}
