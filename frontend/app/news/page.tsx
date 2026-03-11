'use client';

import { useState, useEffect, useCallback } from 'react';
import Navbar from '../components/Navbar';
import { PersonaAvatar } from '../components/persona';
import { fetcher } from '../lib/api';
import DevIntelDashboard, { type TrendsData } from './DevIntelDashboard';

// ---- 类型定义 ----
interface NewsItem {
  id?: number;
  title: string;
  source: string;
  date: string;
  summary: string;
  tag: string;
  tagColor: string;
  link: string;
}

interface Commentary {
  id: number;
  pub_date: string;
  period: string;
  content: string;
  created_at: string;
}

interface DateGroup {
  date: string;
  articles: NewsItem[];
}

interface ArticleDetail {
  original_text: string;
  translated_text: string;
  error?: string;
}

// ---- 常量 ----
const PAGE_SIZE = 15;

const CATEGORIES = [
  { key: '', label: '全部', color: 'bg-gray-100 text-gray-700' },
  { key: '市场动态', label: '市场动态', color: 'bg-blue-100 text-blue-700' },
  { key: '投资趋势', label: '投资趋势', color: 'bg-purple-100 text-purple-700' },
  { key: '租赁市场', label: '租赁市场', color: 'bg-teal-100 text-teal-700' },
  { key: '拍卖数据', label: '拍卖数据', color: 'bg-orange-100 text-orange-700' },
  { key: '奥运概念', label: '奥运概念', color: 'bg-red-100 text-red-700' },
];

const PERIOD_LABELS: Record<string, { icon: string; label: string }> = {
  morning: { icon: '🌅', label: '晨报 8:00AM' },
  evening: { icon: '🌙', label: '晚报 6:00PM' },
  on_demand: { icon: '📰', label: '即时解读' },
};

function formatDate(dateStr: string): string {
  if (!dateStr) return '未知日期';
  try {
    const d = new Date(dateStr + 'T00:00:00');
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const diff = today.getTime() - d.getTime();
    const daysDiff = Math.floor(diff / 86400000);

    if (daysDiff === 0) return '今天';
    if (daysDiff === 1) return '昨天';
    if (daysDiff === 2) return '前天';

    const weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    return `${d.getMonth() + 1}月${d.getDate()}日 ${weekDays[d.getDay()]}`;
  } catch {
    return dateStr;
  }
}

function getDateArticleCount(groups: DateGroup[]): number {
  return groups.reduce((sum, g) => sum + g.articles.length, 0);
}

// ---- 分享功能 ----
async function handleShare() {
  const shareData = {
    title: 'Compass 每日市场解读 - Olivia',
    text: '布里斯班房产市场每日资讯，由 Compass 市场经济学家 Olivia 为您解读',
    url: window.location.href,
  };

  if (navigator.share) {
    try {
      await navigator.share(shareData);
    } catch {
      // user cancelled
    }
  } else {
    // fallback: copy to clipboard
    const text = `${shareData.title}\n${shareData.text}\n${shareData.url}\n\n扫描二维码访问 Compass 平台`;
    await navigator.clipboard.writeText(text);
    alert('链接已复制到剪贴板');
  }
}

export default function NewsPage() {
  // Tab 状态
  const [activeTab, setActiveTab] = useState<'commentary' | 'articles' | 'devintel'>('commentary');

  // DevIntel 趋势数据
  const [trendsData, setTrendsData] = useState<TrendsData | null>(null);
  const [trendsLoading, setTrendsLoading] = useState(false);

  // Olivia 解读 Tab 状态
  const [commentaries, setCommentaries] = useState<Commentary[]>([]);
  const [commentaryPage, setCommentaryPage] = useState(1);
  const [commentaryTotal, setCommentaryTotal] = useState(0);
  const [commentaryLoading, setCommentaryLoading] = useState(true);

  // 新闻原文 Tab 状态
  const [allArticles, setAllArticles] = useState<NewsItem[]>([]);
  const [selectedCategory, setSelectedCategory] = useState('');
  const [articlesLoading, setArticlesLoading] = useState(false);
  const [visibleCount, setVisibleCount] = useState(PAGE_SIZE);

  // 文章展开状态 — 支持多个同时展开
  const [expandedLinks, setExpandedLinks] = useState<Set<string>>(new Set());
  const [articleCache, setArticleCache] = useState<Record<string, ArticleDetail>>({});
  const [loadingLinks, setLoadingLinks] = useState<Set<string>>(new Set());

  // 加载 Olivia 解读
  useEffect(() => {
    loadCommentaries(1);
  }, []);

  const loadCommentaries = async (page: number) => {
    setCommentaryLoading(true);
    try {
      const data = await fetcher(`/api/news/commentaries?page=${page}&page_size=10`);
      if (data?.commentaries) {
        if (page === 1) {
          setCommentaries(data.commentaries);
        } else {
          setCommentaries(prev => [...prev, ...data.commentaries]);
        }
        setCommentaryTotal(data.total || 0);
        setCommentaryPage(page);
      }
    } catch (e) {
      console.error('Failed to load commentaries:', e);
    } finally {
      setCommentaryLoading(false);
    }
  };

  // 加载 DevIntel 趋势
  useEffect(() => {
    if (activeTab === 'devintel' && !trendsData) {
      setTrendsLoading(true);
      fetcher('/api/devintel/trends')
        .then((data: TrendsData) => setTrendsData(data))
        .catch((e: Error) => console.error('Failed to load trends:', e))
        .finally(() => setTrendsLoading(false));
    }
  }, [activeTab, trendsData]);

  // 加载新闻
  useEffect(() => {
    if (activeTab === 'articles') {
      loadArticles();
    }
  }, [activeTab, selectedCategory]);

  const loadArticles = async () => {
    setArticlesLoading(true);
    setVisibleCount(PAGE_SIZE);
    try {
      const params = new URLSearchParams({ days: '14' });
      if (selectedCategory) params.set('category', selectedCategory);
      const data = await fetcher(`/api/news/by-date?${params}`);
      if (data?.dates) {
        // 扁平化所有文章，保留日期信息
        const flat: NewsItem[] = [];
        for (const group of data.dates) {
          for (const a of group.articles) {
            flat.push({ ...a, date: a.date || group.date });
          }
        }
        setAllArticles(flat);
      }
    } catch (e) {
      console.error('Failed to load articles:', e);
      try {
        const fallback = await fetcher('/api/news');
        if (fallback?.news) {
          let items = fallback.news;
          if (selectedCategory) {
            items = items.filter((n: NewsItem) => n.tag === selectedCategory);
          }
          setAllArticles(items);
        }
      } catch { /* ignore */ }
    } finally {
      setArticlesLoading(false);
    }
  };

  // 按日期分组可见的文章
  const visibleArticles = allArticles.slice(0, visibleCount);
  const dateGroupsVisible: DateGroup[] = [];
  const dateMap: Record<string, NewsItem[]> = {};
  for (const a of visibleArticles) {
    const d = a.date || '未知';
    if (!dateMap[d]) dateMap[d] = [];
    dateMap[d].push(a);
  }
  for (const [date, articles] of Object.entries(dateMap)) {
    dateGroupsVisible.push({ date, articles });
  }
  dateGroupsVisible.sort((a, b) => b.date.localeCompare(a.date));

  const hasMore = visibleCount < allArticles.length;

  // 展开文章获取翻译（支持多个同时展开）
  const handleExpand = useCallback(async (link: string, title: string, summary: string) => {
    setExpandedLinks(prev => {
      const next = new Set(prev);
      if (next.has(link)) {
        next.delete(link);
      } else {
        next.add(link);
      }
      return next;
    });

    // 如果已缓存或正在加载，不重复请求
    if (articleCache[link] || loadingLinks.has(link)) return;

    setLoadingLinks(prev => new Set(prev).add(link));
    try {
      const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';
      const params = new URLSearchParams({ url: link, title, summary: summary || '' });
      const res = await fetch(`${API_BASE}/api/news/detail?${params}`, {
        signal: AbortSignal.timeout(60000),
      });
      const data = await res.json();
      setArticleCache(prev => ({ ...prev, [link]: data }));
    } catch {
      setArticleCache(prev => ({
        ...prev,
        [link]: { original_text: '', translated_text: '', error: '获取文章失败，请稍后再试' },
      }));
    } finally {
      setLoadingLinks(prev => {
        const next = new Set(prev);
        next.delete(link);
        return next;
      });
    }
  }, [articleCache, loadingLinks]);

  // 按日期分组 commentaries
  const groupedCommentaries: Record<string, Commentary[]> = {};
  for (const c of commentaries) {
    const d = c.pub_date || '未知';
    if (!groupedCommentaries[d]) groupedCommentaries[d] = [];
    groupedCommentaries[d].push(c);
  }
  const commentaryDates = Object.keys(groupedCommentaries).sort((a, b) => b.localeCompare(a));

  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar activePage="news" />

      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* 页面标题 + 分享按钮 */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-4">
            <PersonaAvatar persona="olivia" size="lg" />
            <div>
              <h1 className="text-2xl md:text-3xl font-bold text-gray-900">Olivia 每日市场解读</h1>
              <p className="text-sm text-purple-600 font-medium">
                Compass 市场经济学家 · 每日 8AM / 6PM 更新
              </p>
            </div>
          </div>
          <button
            onClick={handleShare}
            className="flex-shrink-0 flex items-center gap-1.5 bg-purple-100 hover:bg-purple-200 text-purple-700 px-3 py-2 rounded-lg text-sm font-medium transition-colors"
            title="分享"
          >
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
            </svg>
            分享
          </button>
        </div>

        {/* Tab 切换 */}
        <div className="flex bg-gray-100 rounded-lg p-1 mb-6">
          <button
            className={`flex-1 px-4 py-2.5 rounded-md text-sm font-medium transition-colors ${
              activeTab === 'commentary' ? 'bg-white shadow text-purple-600' : 'text-gray-600 hover:text-gray-900'
            }`}
            onClick={() => setActiveTab('commentary')}
          >
            📊 Olivia 解读
          </button>
          <button
            className={`flex-1 px-4 py-2.5 rounded-md text-sm font-medium transition-colors ${
              activeTab === 'articles' ? 'bg-white shadow text-purple-600' : 'text-gray-600 hover:text-gray-900'
            }`}
            onClick={() => setActiveTab('articles')}
          >
            📰 新闻原文
          </button>
          <button
            className={`flex-1 px-4 py-2.5 rounded-md text-sm font-medium transition-colors ${
              activeTab === 'devintel' ? 'bg-white shadow text-purple-600' : 'text-gray-600 hover:text-gray-900'
            }`}
            onClick={() => setActiveTab('devintel')}
          >
            🏗️ 开发情报
          </button>
        </div>

        {/* ===== Olivia 解读 Tab ===== */}
        {activeTab === 'commentary' && (
          <div className="space-y-6">
            {commentaryLoading && commentaries.length === 0 ? (
              <div className="space-y-4">
                {[1, 2, 3].map(i => (
                  <div key={i} className="bg-white rounded-xl border p-6 animate-pulse">
                    <div className="h-4 bg-gray-200 rounded w-1/4 mb-3" />
                    <div className="h-4 bg-gray-200 rounded w-full mb-2" />
                    <div className="h-4 bg-gray-200 rounded w-5/6 mb-2" />
                    <div className="h-4 bg-gray-200 rounded w-4/6" />
                  </div>
                ))}
              </div>
            ) : commentaryDates.length === 0 ? (
              <div className="bg-white rounded-xl border p-12 text-center">
                <PersonaAvatar persona="olivia" size="lg" />
                <p className="text-gray-500 mt-4">暂无历史解读</p>
                <p className="text-sm text-gray-400 mt-1">Olivia 将在每天 8:00AM 和 6:00PM 发布市场解读</p>
              </div>
            ) : (
              commentaryDates.map(date => (
                <div key={date}>
                  {/* 日期标题 — 醒目样式 */}
                  <div className="flex items-center gap-3 mb-4">
                    <div className="bg-purple-600 text-white text-xs font-bold px-3 py-1.5 rounded-lg">
                      {formatDate(date)}
                    </div>
                    <span className="text-xs text-gray-400">{date}</span>
                    <div className="h-px flex-1 bg-gray-200" />
                    <span className="text-xs text-gray-400">{groupedCommentaries[date].length} 篇解读</span>
                  </div>

                  {/* 该日期的点评 */}
                  <div className="space-y-3">
                    {groupedCommentaries[date].map(c => {
                      const periodInfo = PERIOD_LABELS[c.period] || { icon: '📰', label: c.period };
                      return (
                        <div
                          key={c.id}
                          className="bg-gradient-to-br from-purple-50 via-white to-pink-50 rounded-xl border border-purple-100 p-5 md:p-6"
                        >
                          <div className="flex items-start gap-3 md:gap-4">
                            <div className="flex-shrink-0">
                              <PersonaAvatar persona="olivia" size="md" />
                            </div>
                            <div className="flex-1 min-w-0">
                              <div className="flex items-center gap-2 mb-2 flex-wrap">
                                <span className="font-bold text-gray-900">Olivia</span>
                                <span className="text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full font-medium">
                                  {periodInfo.icon} {periodInfo.label}
                                </span>
                              </div>
                              <div className="text-gray-700 text-sm md:text-[15px] leading-relaxed whitespace-pre-line">
                                {c.content}
                              </div>
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              ))
            )}

            {/* 加载更多 */}
            {commentaries.length < commentaryTotal && (
              <div className="text-center">
                <button
                  onClick={() => loadCommentaries(commentaryPage + 1)}
                  disabled={commentaryLoading}
                  className="bg-purple-100 hover:bg-purple-200 text-purple-700 px-6 py-2.5 rounded-lg text-sm font-medium transition-colors disabled:opacity-50"
                >
                  {commentaryLoading ? '加载中...' : '加载更多解读'}
                </button>
              </div>
            )}
          </div>
        )}

        {/* ===== 新闻原文 Tab ===== */}
        {activeTab === 'articles' && (
          <div>
            {/* 分类筛选 */}
            <div className="flex flex-wrap gap-2 mb-5">
              {CATEGORIES.map(cat => (
                <button
                  key={cat.key}
                  onClick={() => setSelectedCategory(cat.key)}
                  className={`px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
                    selectedCategory === cat.key
                      ? `${cat.color} ring-2 ring-offset-1 ring-purple-300`
                      : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                  }`}
                >
                  {cat.label}
                </button>
              ))}
              {!articlesLoading && (
                <span className="text-xs text-gray-400 self-center ml-2">
                  共 {allArticles.length} 条
                </span>
              )}
            </div>

            {articlesLoading ? (
              <div className="space-y-3">
                {[1, 2, 3, 4, 5].map(i => (
                  <div key={i} className="bg-white rounded-lg border p-4 animate-pulse">
                    <div className="h-4 bg-gray-200 rounded w-1/4 mb-2" />
                    <div className="h-5 bg-gray-200 rounded w-3/4" />
                  </div>
                ))}
              </div>
            ) : dateGroupsVisible.length === 0 ? (
              <div className="bg-white rounded-xl border p-12 text-center">
                <p className="text-gray-500">暂无新闻数据</p>
                <p className="text-sm text-gray-400 mt-1">
                  {selectedCategory ? `"${selectedCategory}" 分类暂无新闻，试试其他分类` : '系统正在抓取最新新闻'}
                </p>
              </div>
            ) : (
              <div className="space-y-6">
                {dateGroupsVisible.map(group => (
                  <div key={group.date}>
                    {/* 日期分隔 — 醒目样式 */}
                    <div className="flex items-center gap-3 mb-3">
                      <div className="bg-blue-600 text-white text-xs font-bold px-3 py-1.5 rounded-lg">
                        {formatDate(group.date)}
                      </div>
                      <span className="text-xs text-gray-400">{group.date}</span>
                      <div className="h-px flex-1 bg-gray-200" />
                      <span className="text-xs text-gray-400">{group.articles.length} 条新闻</span>
                    </div>

                    {/* 该日期的新闻列表 */}
                    <div className="space-y-2">
                      {group.articles.map((news, idx) => {
                        const isExpanded = expandedLinks.has(news.link);
                        const article = articleCache[news.link] as ArticleDetail | undefined;
                        const isLoading = loadingLinks.has(news.link);

                        return (
                          <div
                            key={`${news.link}-${idx}`}
                            className={`bg-white rounded-xl border transition-all ${
                              isExpanded ? 'border-purple-200 shadow-md' : 'border-gray-200 hover:border-gray-300'
                            }`}
                          >
                            {/* 标题栏 */}
                            <button
                              onClick={() => handleExpand(news.link, news.title, news.summary)}
                              className="w-full text-left p-4 flex items-start gap-3"
                            >
                              <span className={`mt-0.5 text-xs transition-transform duration-200 ${isExpanded ? 'rotate-90' : ''}`}>
                                ▶
                              </span>
                              <div className="flex-1 min-w-0">
                                <div className="flex items-center gap-2 mb-1 flex-wrap">
                                  <span className={`px-2 py-0.5 rounded-full text-[10px] md:text-xs font-medium ${news.tagColor}`}>
                                    {news.tag}
                                  </span>
                                  <span className="text-[10px] md:text-xs text-gray-400">
                                    {news.source}
                                  </span>
                                  {isLoading && (
                                    <svg className="animate-spin h-3.5 w-3.5 text-purple-500" viewBox="0 0 24 24">
                                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                                    </svg>
                                  )}
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
                              <div className="px-4 pb-4 border-t border-gray-100">
                                {isLoading && !article ? (
                                  <div className="py-8">
                                    <div className="flex flex-col items-center gap-3">
                                      <div className="flex items-center gap-2">
                                        <PersonaAvatar persona="olivia" size="sm" />
                                        <svg className="animate-spin h-5 w-5 text-purple-500" viewBox="0 0 24 24">
                                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                                        </svg>
                                      </div>
                                      <p className="text-sm text-purple-600 font-medium">Olivia 正在为您解读这条新闻...</p>
                                      <p className="text-xs text-gray-400">首次加载约需 5-15 秒</p>
                                    </div>
                                  </div>
                                ) : article?.translated_text ? (
                                  <div className="pt-4 space-y-4">
                                    {/* 中文翻译/解读 */}
                                    <div>
                                      <div className="flex items-center gap-2 mb-2">
                                        <PersonaAvatar persona="olivia" size="sm" />
                                        <h4 className="text-sm font-semibold text-purple-700">
                                          {article.original_text ? '中文翻译' : 'Olivia 解读'}
                                        </h4>
                                      </div>
                                      <div className="bg-gradient-to-br from-purple-50 to-pink-50 rounded-lg p-4 text-sm text-gray-700 leading-relaxed whitespace-pre-line border border-purple-100">
                                        {article.translated_text}
                                      </div>
                                    </div>

                                    {/* 英文原文（折叠） */}
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

                                    {/* 底部操作栏 */}
                                    <div className="pt-2 border-t border-gray-100 flex items-center justify-between">
                                      <a
                                        href={news.link}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="inline-flex items-center gap-1 text-sm text-purple-600 hover:text-purple-700 font-medium"
                                      >
                                        查看英文原文 ↗
                                      </a>
                                      {!article.original_text && (
                                        <span className="text-xs text-gray-400">原文来源限制访问，已由 Olivia 生成解读</span>
                                      )}
                                    </div>
                                  </div>
                                ) : article?.error ? (
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
                                ) : null}
                              </div>
                            )}
                          </div>
                        );
                      })}
                    </div>
                  </div>
                ))}

                {/* 加载更多 / 计数 */}
                <div className="text-center pt-4">
                  {hasMore ? (
                    <button
                      onClick={() => setVisibleCount(prev => prev + PAGE_SIZE)}
                      className="bg-blue-100 hover:bg-blue-200 text-blue-700 px-6 py-2.5 rounded-lg text-sm font-medium transition-colors"
                    >
                      加载更多新闻（已显示 {visibleCount} / {allArticles.length}）
                    </button>
                  ) : allArticles.length > 0 ? (
                    <p className="text-xs text-gray-400">已显示全部 {allArticles.length} 条新闻</p>
                  ) : null}
                </div>
              </div>
            )}
          </div>
        )}

        {/* ===== 开发情报 Tab ===== */}
        {activeTab === 'devintel' && (
          <DevIntelDashboard data={trendsData} loading={trendsLoading} />
        )}

        {/* Compass 品牌 + 二维码 分享卡片 */}
        <div className="mt-10 bg-gradient-to-br from-gray-900 to-gray-800 rounded-2xl p-6 md:p-8 text-center text-white">
          <div className="flex flex-col md:flex-row items-center justify-center gap-6">
            <div className="flex-1">
              <h3 className="text-lg font-bold mb-2">Compass 布里斯班华人房产平台</h3>
              <p className="text-sm text-gray-300 mb-3">
                新闻来源: Google News · Domain · REA · 后花园澳洲
              </p>
              <p className="text-xs text-gray-400">
                AI 翻译仅供参考 · Olivia 每日 8AM / 6PM 自动发布解读
              </p>
              <button
                onClick={handleShare}
                className="mt-4 inline-flex items-center gap-2 bg-purple-600 hover:bg-purple-700 text-white px-5 py-2 rounded-lg text-sm font-medium transition-colors"
              >
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
                </svg>
                分享给朋友
              </button>
            </div>
            {/* QR Code 占位 — 使用 Google Charts QR API 生成 */}
            <div className="flex-shrink-0 bg-white rounded-xl p-3">
              <img
                src={`https://api.qrserver.com/v1/create-qr-code/?size=120x120&data=${encodeURIComponent('https://compass-eight.vercel.app/news')}`}
                alt="扫码访问 Compass"
                width={120}
                height={120}
                className="rounded"
              />
              <p className="text-[10px] text-gray-600 text-center mt-1 font-medium">扫码访问 Compass</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
