'use client';
import { useState, useEffect, lazy, Suspense } from 'react';
import Header from './components/Header';
import SmartInput from './components/SmartInput';
import TodayDeals from './components/TodayDeals';
import TopInvestmentSuburbs from './components/TopInvestmentSuburbs';
import Footer from './components/Footer';
import { fetcher } from './lib/api';

// 懒加载首屏以下组件 — 减少初始 JS 加载量
const MarketStats = lazy(() => import('./components/MarketStats'));
const Community = lazy(() => import('./components/Community'));

const LazyFallback = () => (
  <div className="py-16 text-center text-gray-300">
    <div className="w-8 h-8 border-2 border-gray-200 border-t-blue-500 rounded-full animate-spin mx-auto" />
  </div>
);

export default function Home() {

  const [rankings, setRankings] = useState<any[]>([]);
  const [suburbStats, setSuburbStats] = useState<any[]>([]);
  const [homeData, setHomeData] = useState<any>(null);

  useEffect(() => {
    let cancelled = false;

    const loadData = async () => {
      try {
        const [hData, rankingsData] = await Promise.all([
          fetcher('/api/home').catch(() => null),
          fetcher('/api/rankings').catch(() => null),
        ]);

        if (cancelled) return;

        if (rankingsData?.rankings) {
          setRankings(rankingsData.rankings);
        }

        if (hData) {
          setHomeData(hData);
          if (hData.suburb_stats) {
            setSuburbStats(hData.suburb_stats);
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
      <Header />
      <SmartInput />
      <TodayDeals />
      <TopInvestmentSuburbs rankings={rankings} suburbStats={suburbStats} />

      <Suspense fallback={<LazyFallback />}>
        <MarketStats homeData={homeData} />
      </Suspense>

      <Suspense fallback={<LazyFallback />}>
        <Community />
      </Suspense>

      <Footer />
    </div>
  );
}
