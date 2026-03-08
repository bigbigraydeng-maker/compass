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
  const [suburbStats, setSuburbStats] = useState<any[]>([]);

  useEffect(() => {
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
          if (homeData.suburb_stats) {
            setSuburbStats(homeData.suburb_stats);
          }
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
      <TopInvestmentSuburbs rankings={rankings} suburbStats={suburbStats} />

      {/* AI Property Analysis - 单独强化入口 */}
      <AIPropertyAnalysis />

      {/* 市场动态 - 新闻 + 近期成交 */}
      <MarketStats />

      {/* Community - 预留模块 */}
      <Community />

      {/* Footer */}
      <Footer />
    </div>
  );
}
