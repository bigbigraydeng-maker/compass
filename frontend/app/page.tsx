'use client';
import { useState, useEffect } from 'react';
import Header from './components/Header';
import Hero from './components/Hero';
import TodayDeals from './components/TodayDeals';
import TopInvestmentSuburbs from './components/TopInvestmentSuburbs';
import AIPropertyAnalysis from './components/AIPropertyAnalysis';
import MarketStats from './components/MarketStats';
import Community from './components/Community';
import Footer from './components/Footer';
import { fetcher } from './lib/api';

export default function Home() {

  const [rankings, setRankings] = useState<any[]>([]);
  const [suburbStats, setSuburbStats] = useState<Record<string, number>>({});
  const [marketStats, setMarketStats] = useState({
    totalSales: 0,
    totalListings: 0,
    medianPrice: 0,
    topSchool: 'Mansfield State High School'
  });

  useEffect(() => {
    // 获取排名数据
    fetcher('/api/rankings')
      .then(d => {
        const mapped = (d.rankings || []).map((r: any) => ({
          ...r,
          name: r.suburb,
          compass_score: r.total_score,
          median_price: suburbStats[r.suburb] ?? null,
          growth_rate: null,
        }));
        setRankings(mapped);
      });
    
    // 获取郊区中位价数据
    fetcher('/api/home')
      .then(homeData => {
        const statsMap: Record<string, number> = {};
        homeData.suburb_stats.forEach((s: any) => {
          statsMap[s.suburb] = s.median_price;
        });
        setSuburbStats(statsMap);
        
        // 同时更新排名数据中的中位价
        if (rankings.length > 0) {
          const updatedRankings = rankings.map((r: any) => ({
            ...r,
            median_price: statsMap[r.suburb] ?? null,
          }));
          setRankings(updatedRankings);
        }
      });
    
    // 模拟市场统计数据
    setMarketStats({
      totalSales: 156,
      totalListings: 193,
      medianPrice: 980000,
      topSchool: 'Mansfield State High School'
    });
  }, [suburbStats]);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <Header />

      {/* Hero - AI搜索 + 房源分析入口 */}
      <Hero />

      {/* Today's Deals - 首页核心模块 */}
      <TodayDeals />

      {/* Top Investment Suburbs - 投资排名 */}
      <TopInvestmentSuburbs rankings={rankings} />

      {/* AI Property Analysis - 单独强化入口 */}
      <AIPropertyAnalysis />

      {/* Market Trends - 放后面 */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-gray-900 mb-12">
            Market Trends
          </h2>
          <MarketStats 
            totalSales={marketStats.totalSales}
            totalListings={marketStats.totalListings}
            medianPrice={marketStats.medianPrice}
            topSchool={marketStats.topSchool}
          />
        </div>
      </section>

      {/* Community - 预留模块 */}
      <Community />

      {/* Footer */}
      <Footer />
    </div>
  );
}
