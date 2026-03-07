'use client';

import Link from 'next/link';
import { useState } from 'react';

interface NavbarProps {
  activePage?: string;
}

export default function Navbar({ activePage = 'home' }: NavbarProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  
  // 郊区列表
  const suburbList = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton'];

  return (
    <>
      <nav className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="text-2xl font-bold text-blue-600">
              Compass
            </Link>
            
            {/* 移动端：汉堡按钮 */}
            <button 
              className="md:hidden flex flex-col gap-1"
              onClick={() => setMenuOpen(!menuOpen)}
            >
              <span className="w-6 h-0.5 bg-gray-700 block"/>
              <span className="w-6 h-0.5 bg-gray-700 block"/>
              <span className="w-6 h-0.5 bg-gray-700 block"/>
            </button>
            
            {/* 桌面端：导航链接 */}
            <div className="hidden md:flex space-x-6">
              <Link href="/" className={activePage === 'home' ? 'text-blue-600 font-medium' : 'text-gray-600 hover:text-blue-600 transition'}>首页</Link>
              <Link href="/sales" className={activePage === 'sales' ? 'text-blue-600 font-medium' : 'text-gray-600 hover:text-blue-600 transition'}>成交列表</Link>
              <Link href="/listings" className={activePage === 'listings' ? 'text-blue-600 font-medium' : 'text-gray-600 hover:text-blue-600 transition'}>在售房源</Link>
              {suburbList.map(suburb => (
                <Link key={suburb} href={`/suburb/${suburb}`} className="text-gray-600 hover:text-blue-600 transition">{suburb}</Link>
              ))}
            </div>
          </div>
        </div>
      </nav>
      
      {/* 展开菜单（全屏overlay） */}
      {menuOpen && (
        <div className="md:hidden fixed inset-0 bg-white z-50 flex flex-col p-6 gap-4">
          <button onClick={() => setMenuOpen(false)} className="self-end text-2xl">✕</button>
          <Link href="/" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>首页</Link>
          <Link href="/sales" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>成交列表</Link>
          <Link href="/listings" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>在售房源</Link>
          {suburbList.map(suburb => (
            <Link key={suburb} href={`/suburb/${suburb}`} className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>{suburb}</Link>
          ))}
        </div>
      )}
    </>
  );
}
