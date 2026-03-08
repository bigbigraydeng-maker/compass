'use client';
import { useState, useEffect, useRef } from 'react';
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
  const [marketStats, setMarketStats] = useState({
    totalSales: 0,
    totalListings: 0,
    medianPrice: 0,
    topSchool: 'Mansfield State High School'
  });

  const hasLoaded = useRef(false);

  useEffect(() => {
    if (hasLoaded.current) return;
    hasLoaded.current = true;

    let cancelled = false;

    const loadData = async () => {
      try {
        const [homeData, rankingsData] = await Promise.all([
          fetcher('/api/home').catch(() => null),
          fetcher('/api/rankings').catch(() => null),
        ]);

        if (cancelled) return;

        if (rankingsData?.rankings) {
          setRankings(rankingsData.rankings);
        }

        if (homeData) {
          setMarketStats({
            totalSales: homeData.total_sales || 0,
            totalListings: homeData.total_listings || 0,
            medianPrice: homeData.median_price || 0,
            topSchool: homeData.top_school || 'Mansfield State High School'
          });
        }
      } catch (error) {
        console.error('Failed to load home data:', error);
      }
    };

    loadData();

    return () => { cancelled = true; };
  }, []);

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
