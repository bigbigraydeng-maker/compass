'use client';
import { useState, useEffect, lazy, Suspense } from 'react';
import Header from './components/Header';
import SmartInput from './components/SmartInput';
import QuickEntryCards from './components/QuickEntryCards';
import TopInvestmentSuburbs from './components/TopInvestmentSuburbs';
import Footer from './components/Footer';
import { fetcher } from './lib/api';

const MarketStats = lazy(() => import('./components/MarketStats'));
const Community = lazy(() => import('./components/Community'));

const LazyFallback = () => (
  <div className="py-16 text-center text-gray-300">
    <div className="w-8 h-8 border-2 border-gray-200 border-t-blue-500 rounded-full animate-spin mx-auto" />
  </div>
);

export default function Home() {
  const [suburbStats, setSuburbStats] = useState<any[]>([]);
  const [homeData, setHomeData] = useState<any>(null);

  useEffect(() => {
    let cancelled = false;

    const loadData = async () => {
      try {
        const hData = await fetcher('/api/home').catch(() => null);
        if (cancelled) return;
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
      <QuickEntryCards />
      <TopInvestmentSuburbs suburbStats={suburbStats} />

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
