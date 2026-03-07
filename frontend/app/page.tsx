'use client';
import { useState, useEffect } from 'react';
import Header from './components/Header';
import Hero from './components/Hero';
import TopSuburbs from './components/TopSuburbs';
import MarketStats from './components/MarketStats';
import RecentSales from './components/RecentSales';
import RecommendedListings from './components/RecommendedListings';
import Footer from './components/Footer';

const API_BASE = 'https://compass-r58x.onrender.com';

export default function Home() {
  const [sales, setSales] = useState<any[]>([]);
  const [listings, setListings] = useState<any[]>([]);
  const [suburbs, setSuburbs] = useState<any[]>([]);
  const [marketStats, setMarketStats] = useState({
    totalSales: 0,
    totalListings: 0,
    medianPrice: 0,
    topSchool: 'Mansfield State High School'
  });

  useEffect(() => {
    // 获取最新成交数据
    fetch(`${API_BASE}/api/sales?page_size=10`)
      .then(r => r.json())
      .then(d => setSales(d.sales || []));
    
    // 获取在售房源数据
    fetch(`${API_BASE}/api/listings?page_size=10`)
      .then(r => r.json())
      .then(d => setListings(d.listings || []));
    
    // 获取郊区数据
    fetch(`${API_BASE}/api/home`)
      .then(r => r.json())
      .then(d => setSuburbs(d.suburb_stats || []));
    
    // 模拟市场统计数据
    setMarketStats({
      totalSales: 156,
      totalListings: 193,
      medianPrice: 980000,
      topSchool: 'Mansfield State High School'
    });
  }, []);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <Header />

      {/* Hero */}
      <Hero />

      {/* Top Suburbs */}
      <TopSuburbs suburbs={suburbs} />

      {/* Market Intelligence */}
      <MarketStats 
        totalSales={marketStats.totalSales}
        totalListings={marketStats.totalListings}
        medianPrice={marketStats.medianPrice}
        topSchool={marketStats.topSchool}
      />

      {/* Recent Sales */}
      <RecentSales sales={sales.map(sale => ({
        id: sale.id,
        address: sale.address,
        suburb: sale.suburb,
        price: sale.sold_price,
        beds: sale.bedrooms || 0,
        land_size: sale.land_size || 0,
        date: sale.sold_date
      }))} />

      {/* Recommended Listings */}
      <RecommendedListings listings={listings.map(listing => ({
        id: listing.id,
        address: listing.address,
        suburb: listing.suburb,
        price: listing.price || 0,
        beds: listing.bedrooms || 0,
        land_size: listing.land_size || 0,
        domain_link: listing.link || 'https://www.domain.com.au'
      }))} />

      {/* Footer */}
      <Footer />
    </div>
  );
}
