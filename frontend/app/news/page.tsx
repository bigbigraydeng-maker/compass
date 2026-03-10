'use client';

import { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import { PersonaAvatar } from '../components/persona';
import { fetcher } from '../lib/api';

interface NewsItem {
  title: string;
  source: string;
  date: string;
  summary: string;
  tag: string;
  tagColor: string;
  link: string;
}

interface ArticleDetail {
  original_text: string;
  translated_text: string;
  error?: string;
}

export default function NewsPage() {
  const [newsItems, setNewsItems] = useState<NewsItem[]>([]);
  const [commentary, setCommentary] = useState('');
  const [commentaryDate, setCommentaryDate] = useState('');
  const [loading, setLoading] = useState(true);
  const [expandedIdx, setExpandedIdx] = useState<number | null>(null);
  const [articleCache, setArticleCache] = useState<Record<string, ArticleDetail>>({});
  const [articleLoading, setArticleLoading] = useState<number | null>(null);

  useEffect(() => {
    const loadNews = async () => {
      try {
        const data = await fetcher('/api/news');
        if (data?.news) {
          setNewsItems(data.news);
        }
        if (data?.amanda_commentary) {
          setCommentary(data.amanda_commentary);
          setCommentaryDate(data.commentary_date || '');
        } else if (data?.news?.length > 0) {
          // 点评还未生成，8秒后重试
          setTimeout(async () => {
            const retry = await fetcher('/api/news').catch(() => null);
            if (retry?.amanda_commentary) {
              setCommentary(retry.amanda_commentary);
              setCommentaryDate(retry.commentary_date || '');
            }
          }, 8000);
        }
      } catch (e) {
        console.error('Failed to load news:', e);
      } finally {
        setLoading(false);
      }
    };
    loadNews();
  }, []);

  const handleExpand = async (idx: number, link: string) => {
    if (expandedIdx === idx) {
      setExpandedIdx(null);
      return;
    }
    setExpandedIdx(idx);

    // 已缓存则跳过
    if (articleCache[link]) return;

    // 请求全文+翻译
    setArticleLoading(idx);
    try {
      const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const res = await fetch(`${API_BASE}/api/news/detail?url=${encodeURIComponent(link)}`, {
        signal: AbortSignal.timeout(30000),
      });
      const data = await res.json();
      setArticleCache(prev => ({ ...prev, [link]: data }));
    } catch (e) {
      setArticleCache(prev => ({
        ...prev,
        [link]: { original_text: '', translated_text: '', error: '获取文章失败，请稍后再试' },
      }));
    } finally {
      setArticleLoading(null);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="news" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* 页面标题 */}
        <div className="flex items-center gap-4 mb-8">
          <PersonaAvatar persona="olivia" size="lg" />
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-gray-900">Olivia 每日市场解读</h1>
            <p className="text-sm text-purple-600 font-medium">Compass 市场经济学家 · 每日更新</p>
          </div>
        </div>

        {/* Olivia 综合解读 */}
        {loading ? (
          <div className="bg-white rounded-xl border p-8 mb-8 animate-pulse">
            <div className="h-5 bg-gray-200 rounded w-2/3 mb-3" />
            <div className="h-4 bg-gray-200 rounded w-full mb-2" />
            <div className="h-4 bg-gray-200 rounded w-5/6 mb-2" />
            <div className="h-4 bg-gray-200 rounded w-4/6" />
          </div>
        ) : commentary ? (
          <div className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5 md:p-8 mb-8">
            <div className="flex items-start gap-3 md:gap-5">
              <div className="flex-shrink-0">
                <PersonaAvatar persona="olivia" size="lg" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-3">
                  <span className="font-bold text-gray-900 text-base md:text-lg">Olivia</span>
                  <span className="text-[10px] md:text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-medium">
                    Compass 市场经济学家
                  </span>
                  <span className="text-[10px] md:text-xs text-gray-400 ml-auto">{commentaryDate}</span>
                </div>
                <div className="text-gray-700 text-sm md:text-[15px] leading-relaxed whitespace-pre-line">
                  {commentary}
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-gray-50 rounded-xl border border-gray-100 p-6 text-center mb-8">
            <div className="flex items-center justify-center gap-2 text-gray-400">
              <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <span className="text-sm">Olivia 正在阅读今日新闻，稍后为您解读...</span>
            </div>
          </div>
        )}

        {/* 新闻列表 */}
        <h2 className="text-lg font-bold text-gray-900 mb-4">
          新闻原文与中文翻译
          <span className="text-sm font-normal text-gray-400 ml-2">
            点击展开查看全文
          </span>
        </h2>

        {loading ? (
          <div className="space-y-3">
            {[1, 2, 3, 4, 5].map(i => (
              <div key={i} className="bg-white rounded-lg border p-4 animate-pulse">
                <div className="h-4 bg-gray-200 rounded w-1/4 mb-2" />
                <div className="h-5 bg-gray-200 rounded w-3/4" />
              </div>
            ))}
          </div>
        ) : newsItems.length === 0 ? (
          <div className="bg-white rounded-xl border p-12 text-center">
            <p className="text-gray-500">暂无新闻数据</p>
          </div>
        ) : (
          <div className="space-y-3">
            {newsItems.map((news, idx) => {
              const isExpanded = expandedIdx === idx;
              const article = articleCache[news.link];
              const isLoading = articleLoading === idx;

              return (
                <div
                  key={idx}
                  className={`bg-white rounded-xl border transition-all ${
                    isExpanded ? 'border-purple-200 shadow-md' : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  {/* 标题栏（可点击） */}
                  <button
                    onClick={() => handleExpand(idx, news.link)}
                    className="w-full text-left p-4 md:p-5 flex items-start gap-3"
                  >
                    <span className={`mt-0.5 text-xs transition-transform ${isExpanded ? 'rotate-90' : ''}`}>
                      ▶
                    </span>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1.5 flex-wrap">
                        <span className={`px-2 py-0.5 rounded-full text-[10px] md:text-xs font-medium ${news.tagColor}`}>
                          {news.tag}
                        </span>
                        <span className="text-[10px] md:text-xs text-gray-400">
                          {news.source} · {news.date}
                        </span>
                      </div>
                      <p className={`text-sm md:text-base font-medium text-gray-900 ${isExpanded ? '' : 'line-clamp-2'}`}>
                        {news.title}
                      </p>
                      {!isExpanded && news.summary && (
                        <p className="text-xs text-gray-400 mt-1 line-clamp-1">{news.summary}</p>
                      )}
                    </div>
                  </button>

                  {/* 展开内容 */}
                  {isExpanded && (
                    <div className="px-4 md:px-5 pb-5 border-t border-gray-100">
                      {isLoading ? (
                        <div className="py-8">
                          <div className="flex flex-col items-center gap-3">
                            <svg className="animate-spin h-6 w-6 text-purple-500" viewBox="0 0 24 24">
                              <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                              <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                            </svg>
                            <p className="text-sm text-gray-500">正在获取原文并翻译中...</p>
                            <p className="text-xs text-gray-400">首次加载可能需要 10-20 秒</p>
                          </div>
                        </div>
                      ) : article?.error && !article.original_text ? (
                        <div className="py-6 text-center">
                          <p className="text-sm text-gray-500 mb-3">{article.error}</p>
                          <a
                            href={news.link}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="inline-flex items-center gap-1 text-sm text-purple-600 hover:text-purple-700 font-medium"
                          >
                            直接访问原文 ↗
                          </a>
                        </div>
                      ) : article ? (
                        <div className="pt-4 space-y-4">
                          {/* 中文翻译 */}
                          {article.translated_text && (
                            <div>
                              <h4 className="text-sm font-semibold text-purple-700 mb-2 flex items-center gap-1.5">
                                <span className="w-1.5 h-1.5 bg-purple-500 rounded-full" />
                                中文翻译
                              </h4>
                              <div className="bg-purple-50/50 rounded-lg p-4 text-sm text-gray-700 leading-relaxed whitespace-pre-line">
                                {article.translated_text}
                              </div>
                            </div>
                          )}

                          {/* 英文原文 */}
                          {article.original_text && (
                            <details className="group">
                              <summary className="text-sm font-semibold text-gray-500 mb-2 flex items-center gap-1.5 cursor-pointer hover:text-gray-700">
                                <span className="w-1.5 h-1.5 bg-gray-400 rounded-full" />
                                English Original
                                <span className="text-xs text-gray-400 ml-1">（点击展开）</span>
                              </summary>
                              <div className="bg-gray-50 rounded-lg p-4 text-sm text-gray-600 leading-relaxed whitespace-pre-line">
                                {article.original_text}
                              </div>
                            </details>
                          )}

                          {/* 原文链接 */}
                          <div className="pt-2 border-t border-gray-100">
                            <a
                              href={news.link}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="inline-flex items-center gap-1 text-sm text-purple-600 hover:text-purple-700 font-medium"
                            >
                              查看原文 ↗
                            </a>
                          </div>
                        </div>
                      ) : null}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}

        {/* 底部信息 */}
        <div className="text-center mt-8 space-y-2">
          <p className="text-xs text-gray-400">
            新闻由 Google News 自动聚合 · 翻译由 Kimi K2.5 AI 生成 · 仅供参考
          </p>
        </div>
      </main>
    </div>
  );
}
