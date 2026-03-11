'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { fetcher } from '../lib/api';
import { PersonaAvatar } from './persona';

interface MarketStatsProps {
  homeData?: any;
}

export default function MarketStats({ homeData: parentHomeData }: MarketStatsProps) {
  const [oliviaCommentary, setOliviaCommentary] = useState('');
  const [commentaryDate, setCommentaryDate] = useState('');

  useEffect(() => {
    let cancelled = false;
    let retryTimer: ReturnType<typeof setTimeout>;

    const loadNews = async (): Promise<any> => {
      return fetcher('/api/news').catch(() => null);
    };

    const loadData = async () => {
      try {
        const newsData = await loadNews();
        if (cancelled) return;

        if (newsData?.olivia_commentary) {
          setOliviaCommentary(newsData.olivia_commentary);
          setCommentaryDate(newsData.commentary_date || '');
        } else if (newsData?.news && newsData.news.length > 0) {
          retryTimer = setTimeout(async () => {
            if (cancelled) return;
            const retry = await loadNews();
            if (retry?.olivia_commentary && !cancelled) {
              setOliviaCommentary(retry.olivia_commentary);
              setCommentaryDate(retry.commentary_date || '');
            }
          }, 8000);
        }
      } catch (e) {
        console.error('Failed to load market data:', e);
      }
    };

    loadData();
    return () => { cancelled = true; clearTimeout(retryTimer); };
  }, [parentHomeData]);

  return (
    <section className="py-10 md:py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* 标题 */}
        <div className="mb-6 md:mb-10">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-1 md:mb-2">
            市场动态
          </h2>
          <p className="text-sm md:text-base text-gray-600">
            Olivia 每日解读
          </p>
        </div>

        {/* Olivia 每日综合解读 */}
        {oliviaCommentary ? (
          <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5 md:p-8">
            <div className="flex items-start gap-3 md:gap-5">
              <div className="flex-shrink-0">
                <PersonaAvatar persona="olivia" size="lg" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-3">
                  <span className="font-bold text-gray-900 text-base md:text-lg">Olivia</span>
                  <span className="text-[10px] md:text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-medium">Compass 市场经济学家</span>
                  <span className="text-[10px] md:text-xs text-gray-400 ml-auto">{commentaryDate}</span>
                </div>
                <div className="text-gray-700 text-sm md:text-[15px] leading-relaxed whitespace-pre-line">
                  {oliviaCommentary}
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-gray-50 rounded-xl border border-gray-100 p-6 text-center">
            <div className="flex items-center justify-center gap-2 text-gray-400">
              <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24"><circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" /><path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" /></svg>
              <span className="text-sm">Olivia 正在阅读今日新闻，稍后为您解读...</span>
            </div>
          </div>
        )}

        {/* 查看全部新闻链接 */}
        <div className="text-center mt-5">
          <Link
            href="/news"
            className="inline-flex items-center gap-1.5 bg-purple-600 hover:bg-purple-700 text-white px-5 py-2 rounded-lg text-sm font-medium transition-colors"
          >
            查看全部新闻与翻译 →
          </Link>
        </div>
      </div>
    </section>
  );
}
