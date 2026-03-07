import Link from 'next/link';

export default function Footer() {
  return (
    <footer className="bg-gray-800 text-white py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div>
            <h3 className="text-2xl font-bold mb-4">Compass</h3>
            <p className="text-gray-400 mb-6">
              布里斯班华人房产情报平台
            </p>
            <p className="text-gray-500 text-sm">
              © 2026 Compass. 保留所有权利。
            </p>
          </div>
          <div className="grid grid-cols-2 gap-8">
            <div>
              <h4 className="font-semibold mb-4">链接</h4>
              <ul className="space-y-2">
                <li>
                  <Link href="/" className="text-gray-400 hover:text-white transition-colors">
                    首页
                  </Link>
                </li>
                <li>
                  <Link href="/listings" className="text-gray-400 hover:text-white transition-colors">
                    在售房源
                  </Link>
                </li>
                <li>
                  <Link href="/sales" className="text-gray-400 hover:text-white transition-colors">
                    成交记录
                  </Link>
                </li>
              </ul>
            </div>
            <div>
              <h4 className="font-semibold mb-4">信息</h4>
              <ul className="space-y-2">
                <li>
                  <Link href="#" className="text-gray-400 hover:text-white transition-colors">
                    关于我们
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-white transition-colors">
                    联系我们
                  </Link>
                </li>
                <li>
                  <Link href="#" className="text-gray-400 hover:text-white transition-colors">
                    隐私政策
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
