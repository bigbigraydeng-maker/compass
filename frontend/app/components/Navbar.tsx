'use client';

import Link from 'next/link';
import { useState } from 'react';
import { ALL_SUBURBS } from '../lib/suburbs';

interface NavbarProps {
  activePage?: string;
}

export default function Navbar({ activePage = 'home' }: NavbarProps) {
  const [menuOpen, setMenuOpen] = useState(false);
  const [suburbMenuOpen, setSuburbMenuOpen] = useState(false);

  // 郊区列表
  const suburbList = [...ALL_SUBURBS];

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
              <Link href="/news" className={activePage === 'news' ? 'text-blue-600 font-medium' : 'text-gray-600 hover:text-blue-600 transition'}>新闻</Link>
              <Link href="/devintel" className={activePage === 'devintel' ? 'text-blue-600 font-medium' : 'text-gray-600 hover:text-blue-600 transition'}>DevIntel</Link>
              <div className="relative">
                <button 
                  className="text-gray-600 hover:text-blue-600 transition flex items-center gap-1"
                  onMouseEnter={() => setSuburbMenuOpen(true)}
                  onMouseLeave={() => setSuburbMenuOpen(false)}
                >
                  郊区
                  <span className="text-xs">▼</span>
                </button>
                {suburbMenuOpen && (
                  <div className="absolute top-full left-0 mt-1 bg-white shadow-lg rounded-md py-2 w-48 z-10"
                       onMouseEnter={() => setSuburbMenuOpen(true)}
                       onMouseLeave={() => setSuburbMenuOpen(false)}>
                    {suburbList.map(suburb => (
                      <Link key={suburb} href={`/suburb/${suburb}`} className="block px-4 py-2 text-gray-600 hover:bg-gray-100 transition">{suburb}</Link>
                    ))}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>
      
      {/* 展开菜单（全屏overlay） */}
      {menuOpen && (
        <div className="md:hidden fixed inset-0 bg-white z-50 flex flex-col p-6 gap-4">
          <button onClick={() => setMenuOpen(false)} className="self-end text-2xl">✕</button>
          <Link href="/" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>首页</Link>
          <Link href="/news" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>新闻</Link>
          <Link href="/devintel" className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>DevIntel</Link>
          {suburbList.map(suburb => (
            <Link key={suburb} href={`/suburb/${suburb}`} className="text-lg py-2 border-b" onClick={() => setMenuOpen(false)}>{suburb}</Link>
          ))}
        </div>
      )}
    </>
  );
}
