'use client';

import { useState, useRef, useEffect, useCallback } from 'react';
import Link from 'next/link';
import { fetcher } from '../lib/api';
import {
  streamFengshuiAnalysis,
  type FengshuiMeta,
  type ElevationData,
  type PlacesData,
  type CrimeData,
} from './streamFengshui';

// ====== 方位顺序 ======
const DIRECTION_ORDER = ['北', '東北', '東', '東南', '南', '西南', '西', '西北'];

// ====== 犯罪分类英中映射 ======
const CRIME_CATEGORY_ZH: Record<string, string> = {
  theft_fraud: '盜竊詐騙',
  property_crime: '財產犯罪',
  public_order: '公共秩序',
  violent_crime: '暴力犯罪',
  drug_offences: '毒品犯罪',
  traffic: '交通違法',
  other: '其他',
  sexual_offences: '性犯罪',
  weapons: '武器犯罪',
  miscellaneous: '雜項',
};

// ====== 本地缓存工具 ======
const CACHE_KEY = 'fengshui_history';
const MAX_CACHE = 5;

interface FengshuiRecord {
  id: number;
  address: string;
  suburb: string;
  rating: string;
  summary: string;
  center_elevation: number | null;
  has_backing: boolean;
  backing_direction: string;
  has_water: boolean;
  negative_count: number;
  positive_count: number;
  total_crime: number;
  has_floor_plan: boolean;
  created_at: string;
}

interface CachedReport {
  address: string;
  suburb: string;
  rating: string;
  timestamp: number;
  masterHuContent: string;
  elevation?: ElevationData;
  places?: PlacesData;
  crime?: CrimeData;
  hasFloorPlan: boolean;
}

function loadCachedReports(): CachedReport[] {
  try {
    const raw = localStorage.getItem(CACHE_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch { return []; }
}

function saveCachedReport(report: CachedReport) {
  try {
    const list = loadCachedReports();
    const filtered = list.filter(r => r.address.toLowerCase() !== report.address.toLowerCase());
    filtered.unshift(report);
    localStorage.setItem(CACHE_KEY, JSON.stringify(filtered.slice(0, MAX_CACHE)));
  } catch { /* ignore */ }
}

/** 从AI输出中提取评级 A-E */
function extractRating(content: string): string {
  const match = content.match(/總體評級[^A-E]*([A-E])/);
  return match ? match[1] : '?';
}

// ====== 主页面 ======
export default function FengShuiPage() {
  const [address, setAddress] = useState('');
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [showResults, setShowResults] = useState(false);

  // 平面图状态
  const [floorPlan, setFloorPlan] = useState<File | null>(null);
  const [floorPlanPreview, setFloorPlanPreview] = useState<string | null>(null);
  const floorPlanRef = useRef<HTMLInputElement>(null);

  // 数据状态
  const [meta, setMeta] = useState<FengshuiMeta | null>(null);
  const [elevation, setElevation] = useState<ElevationData | null>(null);
  const [places, setPlaces] = useState<PlacesData | null>(null);
  const [crime, setCrime] = useState<CrimeData | null>(null);
  const [masterHuContent, setMasterHuContent] = useState('');
  const [error, setError] = useState<string | null>(null);

  // 分享/下载状态
  const [shareToast, setShareToast] = useState(false);

  // 历史记录
  const [history, setHistory] = useState<CachedReport[]>([]);
  const [showHistory, setShowHistory] = useState(false);

  // 查看缓存报告
  const [viewingCached, setViewingCached] = useState<CachedReport | null>(null);

  // 公開風水記錄
  const [publicRecords, setPublicRecords] = useState<FengshuiRecord[]>([]);
  const [recordStats, setRecordStats] = useState<Record<string, number>>({});
  const [recordFilter, setRecordFilter] = useState('');

  const abortRef = useRef<AbortController | null>(null);

  // 加載公開記錄
  useEffect(() => {
    loadPublicRecords();
  }, [recordFilter]);

  const loadPublicRecords = async () => {
    try {
      const params = new URLSearchParams({ limit: '20' });
      if (recordFilter) params.set('rating', recordFilter);
      const data = await fetcher(`/api/fengshui/records?${params}`);
      if (data?.records) {
        setPublicRecords(data.records);
        setRecordStats(data.stats || {});
      }
    } catch { /* ignore */ }
  };

  // 加载历史记录
  useEffect(() => {
    setHistory(loadCachedReports());
  }, []);

  const handleFloorPlanSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    // 验证文件类型
    if (!file.type.startsWith('image/')) {
      setError('請上傳圖片格式的平面圖（JPG/PNG/WebP）');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setError('平面圖檔案大小不能超過5MB');
      return;
    }
    // 基础图片有效性检测
    const img = new Image();
    const url = URL.createObjectURL(file);
    img.onload = () => {
      if (img.width < 100 || img.height < 100) {
        setError('圖片尺寸過小，請上傳清晰的平面圖');
        URL.revokeObjectURL(url);
        return;
      }
      if (floorPlanPreview) URL.revokeObjectURL(floorPlanPreview);
      setFloorPlan(file);
      setFloorPlanPreview(url);
      setError(null);
    };
    img.onerror = () => {
      setError('無法讀取圖片，請上傳有效的平面圖檔案');
      URL.revokeObjectURL(url);
    };
    img.src = url;
    if (e.target) e.target.value = '';
  };

  const removeFloorPlan = () => {
    if (floorPlanPreview) URL.revokeObjectURL(floorPlanPreview);
    setFloorPlan(null);
    setFloorPlanPreview(null);
  };

  const resetAnalysis = () => {
    setShowResults(false);
    setMeta(null);
    setElevation(null);
    setPlaces(null);
    setCrime(null);
    setMasterHuContent('');
    setError(null);
    setViewingCached(null);
  };

  const handleSubmit = async (e?: React.FormEvent) => {
    e?.preventDefault();
    const trimmed = address.trim();
    if (!trimmed) return;

    // 基础地址格式验证
    if (trimmed.length < 5) {
      setError('請輸入完整的地址，例如: 10 Main St, Sunnybank QLD');
      return;
    }

    abortRef.current?.abort();
    abortRef.current = new AbortController();

    resetAnalysis();
    setIsAnalyzing(true);
    setShowResults(true);

    let finalMeta: FengshuiMeta | null = null;
    let finalElevation: ElevationData | null = null;
    let finalPlaces: PlacesData | null = null;
    let finalCrime: CrimeData | null = null;
    let fullContent = '';

    try {
      await streamFengshuiAnalysis(
        trimmed,
        {
          onMeta: (data) => { setMeta(data); finalMeta = data; },
          onElevation: (data) => { setElevation(data); finalElevation = data; },
          onPlaces: (data) => { setPlaces(data); finalPlaces = data; },
          onCrime: (data) => { setCrime(data); finalCrime = data; },
          onMasterHuContent: (text) => {
            fullContent += text;
            setMasterHuContent(prev => prev + text);
          },
          onDone: () => {
            setIsAnalyzing(false);
            // 刷新公開記錄（後端已自動保存）
            setTimeout(() => loadPublicRecords(), 1000);
            // 保存到本地缓存
            if (finalMeta && fullContent) {
              const report: CachedReport = {
                address: finalMeta.address,
                suburb: finalMeta.suburb,
                rating: extractRating(fullContent),
                timestamp: Date.now(),
                masterHuContent: fullContent,
                elevation: finalElevation ?? undefined,
                places: finalPlaces ?? undefined,
                crime: finalCrime ?? undefined,
                hasFloorPlan: finalMeta.has_floor_plan ?? false,
              };
              saveCachedReport(report);
              setHistory(loadCachedReports());
            }
          },
          onError: (msg) => {
            let friendlyMsg = msg;
            if (msg.includes('Geocoding failed') || msg.includes('ZERO_RESULTS')) {
              friendlyMsg = '無法識別該地址，請確認輸入了完整真實的澳洲地址。例如: 10 Main St, Sunnybank QLD';
            } else if (msg.includes('Geocoding error')) {
              friendlyMsg = '地址解析服務暫時不可用，請稍後重試';
            }
            setError(friendlyMsg);
            setIsAnalyzing(false);
          },
        },
        abortRef.current.signal,
        floorPlan,
      );
    } catch (err: any) {
      if (err.name !== 'AbortError') {
        let friendlyMsg = err.message || '分析失敗，請重試';
        if (friendlyMsg.includes('Geocoding')) {
          friendlyMsg = '無法識別該地址。請輸入完整的澳洲地址，如: 10 Main St, Sunnybank QLD';
        }
        setError(friendlyMsg);
      }
      setIsAnalyzing(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
      handleSubmit();
    }
  };

  // 分享报告
  const handleShare = useCallback(() => {
    const content = viewingCached?.masterHuContent || masterHuContent;
    const addr = viewingCached?.address || meta?.address || '';
    if (!content) return;
    const text = `天機堂 · 風水堪輿報告\n地址: ${addr}\n${'─'.repeat(30)}\n${content}\n${'─'.repeat(30)}\n天機堂 × Compass | ${new Date().toLocaleString('zh-TW')}`;
    navigator.clipboard.writeText(text).then(() => {
      setShareToast(true);
      setTimeout(() => setShareToast(false), 2000);
    });
  }, [masterHuContent, meta, viewingCached]);

  // 下载报告
  const handleDownload = useCallback(() => {
    const content = viewingCached?.masterHuContent || masterHuContent;
    const addr = viewingCached?.address || meta?.address || '';
    if (!content) return;
    const text = `天機堂 · 風水堪輿報告\n\n地址: ${addr}\n生成時間: ${new Date().toLocaleString('zh-TW')}\n${'═'.repeat(40)}\n\n${content}\n\n${'═'.repeat(40)}\n免責聲明：天機堂風水分析基於地形數據與傳統堪輿理論的 AI 綜合判讀，僅供參考。\n天機堂 × Compass`;
    const blob = new Blob([text], { type: 'text/plain;charset=utf-8' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    const suburb = viewingCached?.suburb || meta?.suburb || 'report';
    a.download = `天機堂_${suburb}_${new Date().toISOString().slice(0, 10)}.txt`;
    a.click();
    URL.revokeObjectURL(url);
  }, [masterHuContent, meta, viewingCached]);

  // 查看历史报告
  const viewCachedReport = (report: CachedReport) => {
    setViewingCached(report);
    setShowResults(true);
    setShowHistory(false);
  };

  // 示例地址
  const examples = [
    '10 Doreen St, Sunnybank QLD',
    '25 Dobie St, Runcorn QLD',
    '8 Doris Ct, Robertson QLD',
    '15 Pine Rd, Calamvale QLD',
  ];

  // 当前展示的内容（可能来自缓存或实时分析）
  const displayContent = viewingCached?.masterHuContent || masterHuContent;
  const displayElevation = viewingCached?.elevation || elevation;
  const displayPlaces = viewingCached?.places || places;
  const displayCrime = viewingCached?.crime || crime;
  const displayAddress = viewingCached?.address || meta?.address;
  const displaySuburb = viewingCached?.suburb || meta?.suburb;

  return (
    <div className="min-h-screen bg-neutral-950">
      {/* 导航 */}
      <header className="border-b border-amber-900/30 bg-neutral-950/95 backdrop-blur-sm sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-14">
            <Link href="/" className="text-amber-400/70 text-sm hover:text-amber-300 transition-colors">
              ← 返回 Compass
            </Link>
            <div className="flex items-center gap-2">
              <span className="text-amber-500 text-lg">☰</span>
              <span className="text-amber-100 font-bold">天機堂</span>
              <span className="text-amber-600/60 text-xs">× Compass</span>
            </div>
          </div>
        </div>
      </header>

      {/* Hero */}
      <section className="relative py-16 md:py-24 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-amber-950/30 via-neutral-950 to-neutral-950" />
        <div className="absolute inset-0 opacity-5"
          style={{
            backgroundImage: `radial-gradient(circle at 50% 50%, #f59e0b 1px, transparent 1px)`,
            backgroundSize: '40px 40px',
          }}
        />

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <div className="mb-6">
            <span className="text-5xl md:text-7xl">☰</span>
          </div>
          <h1 className="text-3xl md:text-5xl font-bold text-amber-100 mb-3 tracking-wide">
            天機堂
          </h1>
          <p className="text-amber-500/80 text-lg md:text-xl mb-2">
            風水堪輿 · AI 數據分析
          </p>
          <p className="text-amber-700/60 text-sm max-w-lg mx-auto mb-10">
            融合傳統巒頭形勢理論與 Google 地形數據，為您的陽宅堪輿提供數據化參考
          </p>

          {/* 输入区 */}
          <div className="max-w-2xl mx-auto">
            <form onSubmit={handleSubmit}>
              <div className="bg-neutral-900/80 backdrop-blur-md rounded-2xl border border-amber-800/30 overflow-hidden">
                <div className="p-4 md:p-5">
                  <input
                    type="text"
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    onKeyDown={handleKeyDown}
                    placeholder="輸入完整地址，如: 10 Main St, Sunnybank QLD..."
                    className="w-full bg-transparent text-amber-100 placeholder-amber-800/50 text-base md:text-lg focus:outline-none"
                  />
                </div>
                {/* 平面图预览 */}
                {floorPlanPreview && (
                  <div className="px-4 md:px-5 pb-3 flex items-center gap-3">
                    <div className="relative w-16 h-16 rounded-lg overflow-hidden border border-amber-700/30">
                      <img src={floorPlanPreview} alt="平面圖" className="w-full h-full object-cover" />
                      <button
                        onClick={removeFloorPlan}
                        className="absolute -top-1 -right-1 w-5 h-5 bg-red-600 rounded-full text-white text-xs flex items-center justify-center hover:bg-red-500"
                      >
                        x
                      </button>
                    </div>
                    <span className="text-amber-600/50 text-xs">已上傳平面圖，胡師傅將額外分析室內格局</span>
                  </div>
                )}

                <div className="px-4 md:px-5 pb-4 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <button
                      type="button"
                      onClick={() => floorPlanRef.current?.click()}
                      className="text-amber-700/50 hover:text-amber-500 text-sm flex items-center gap-1 transition-colors"
                    >
                      <span>📐</span>
                      <span className="hidden md:inline text-xs">{floorPlan ? '已上傳' : '上傳平面圖'}</span>
                    </button>
                    <input
                      ref={floorPlanRef}
                      type="file"
                      accept="image/jpeg,image/png,image/webp"
                      onChange={handleFloorPlanSelect}
                      className="hidden"
                    />
                    <span className="text-amber-800/40 text-xs hidden md:inline">Ctrl+Enter 提交</span>
                  </div>
                  <button
                    type="submit"
                    disabled={!address.trim() || isAnalyzing}
                    className="flex items-center gap-2 px-5 py-2 rounded-lg text-sm font-medium transition-all disabled:opacity-40
                      bg-gradient-to-r from-amber-700 to-red-800 text-amber-100 hover:from-amber-600 hover:to-red-700 active:scale-95"
                  >
                    {isAnalyzing ? (
                      <>
                        <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                        </svg>
                        堪輿中...
                      </>
                    ) : (
                      <>☰ 胡師傅 分析</>
                    )}
                  </button>
                </div>
              </div>
            </form>

            {/* 示例地址 + 历史按钮 */}
            <div className="mt-4 flex flex-wrap justify-center gap-2">
              {examples.map((addr) => (
                <button
                  key={addr}
                  onClick={() => { setAddress(addr); }}
                  className="text-amber-700/50 hover:text-amber-500 text-xs px-3 py-1.5 rounded-full border border-amber-900/20 hover:border-amber-700/40 transition-colors"
                >
                  {addr.split(',')[0]}
                </button>
              ))}
              {history.length > 0 && (
                <button
                  onClick={() => setShowHistory(!showHistory)}
                  className="text-amber-500/60 hover:text-amber-400 text-xs px-3 py-1.5 rounded-full border border-amber-700/30 hover:border-amber-500/40 transition-colors flex items-center gap-1"
                >
                  <span>📋</span> 歷史記錄 ({history.length})
                </button>
              )}
            </div>

            {/* 输入验证提示 */}
            {error && !showResults && (
              <div className="mt-4 p-3 bg-red-950/50 border border-red-800/40 rounded-lg text-red-400 text-sm text-left">
                {error}
              </div>
            )}
          </div>
        </div>
      </section>

      {/* 历史记录面板 */}
      {showHistory && history.length > 0 && !showResults && (
        <section className="pb-8 bg-neutral-950">
          <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="bg-neutral-900/80 rounded-xl border border-amber-800/20 p-5">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-semibold text-amber-200 text-sm flex items-center gap-2">
                  <span>📋</span> 近期堪輿記錄
                </h3>
                <button
                  onClick={() => setShowHistory(false)}
                  className="text-amber-700/50 hover:text-amber-500 text-xs"
                >
                  收起
                </button>
              </div>
              <div className="space-y-2">
                {history.map((r, i) => (
                  <button
                    key={i}
                    onClick={() => viewCachedReport(r)}
                    className="w-full text-left p-3 rounded-lg bg-neutral-800/50 hover:bg-neutral-800 border border-transparent hover:border-amber-800/20 transition-all"
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2">
                          <RatingBadge rating={r.rating} />
                          <span className="text-amber-100 text-sm truncate">{r.address}</span>
                        </div>
                        <div className="text-amber-700/40 text-xs mt-1">
                          {new Date(r.timestamp).toLocaleString('zh-TW')}
                          {r.hasFloorPlan && <span className="ml-2">📐 含平面圖</span>}
                        </div>
                      </div>
                      <span className="text-amber-700/40 text-xs ml-2">查看 →</span>
                    </div>
                  </button>
                ))}
              </div>
            </div>
          </div>
        </section>
      )}

      {/* 分析结果 */}
      {showResults && (
        <section className="pb-16 bg-neutral-950">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            {/* 顶部栏 */}
            <div className="flex items-center justify-between mb-6 flex-wrap gap-3">
              <div className="flex items-center gap-3">
                <h2 className="text-xl font-bold text-amber-100">堪輿報告</h2>
                {(displaySuburb || displayAddress) && (
                  <span className="text-sm text-amber-600/60">{displaySuburb}區 · {displayAddress}</span>
                )}
                {viewingCached && (
                  <span className="text-xs px-2 py-0.5 rounded-full bg-amber-900/30 text-amber-500/70">緩存</span>
                )}
                {isAnalyzing && (
                  <span className="flex items-center gap-1.5 text-amber-500 text-sm">
                    <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                    </svg>
                    分析中…
                  </span>
                )}
              </div>
              <div className="flex items-center gap-2">
                {displayContent && !isAnalyzing && (
                  <>
                    <button
                      onClick={handleShare}
                      className="text-amber-600/50 hover:text-amber-400 text-xs px-3 py-1.5 rounded-lg border border-amber-800/20 hover:border-amber-600/40 transition-all flex items-center gap-1"
                    >
                      <span>📋</span> 複製分享
                    </button>
                    <button
                      onClick={handleDownload}
                      className="text-amber-600/50 hover:text-amber-400 text-xs px-3 py-1.5 rounded-lg border border-amber-800/20 hover:border-amber-600/40 transition-all flex items-center gap-1"
                    >
                      <span>📥</span> 下載報告
                    </button>
                  </>
                )}
                <button
                  onClick={resetAnalysis}
                  className="text-amber-700/50 hover:text-amber-500 text-sm px-3 py-1 rounded hover:bg-amber-900/20 transition"
                >
                  關閉
                </button>
              </div>
            </div>

            {/* 分享成功提示 */}
            {shareToast && (
              <div className="mb-4 p-3 bg-green-950/40 border border-green-700/30 rounded-lg text-green-400 text-sm text-center">
                已複製報告到剪貼板，可直接貼上分享
              </div>
            )}

            {/* 错误 */}
            {error && (
              <div className="mb-6 p-4 bg-red-950/50 border border-red-800/50 rounded-lg text-red-400 text-sm">
                <div className="font-medium mb-1">分析出錯</div>
                <div>{error}</div>
                {error.includes('地址') && (
                  <div className="mt-2 text-red-500/60 text-xs">
                    提示：請輸入完整的澳洲地址，包括街道號碼、街道名、郊區名和州名。
                    例如: &quot;10 Main St, Sunnybank QLD&quot;
                  </div>
                )}
              </div>
            )}

            {/* 主内容 */}
            <div className="flex flex-col lg:flex-row gap-6">
              {/* 胡師傅分析 - 主区域 */}
              <div className="flex-1 min-w-0">
                <div className="bg-neutral-900/80 rounded-xl border border-amber-800/20 p-6">
                  <div className="flex items-center gap-3 mb-4">
                    <div className="w-10 h-10 rounded-full bg-gradient-to-br from-amber-600 to-red-800 flex items-center justify-center text-white text-lg font-bold">
                      胡
                    </div>
                    <div>
                      <h3 className="font-semibold text-amber-100">胡師傅 · 堪輿分析</h3>
                      <p className="text-xs text-amber-700/50">天機堂首席堪輿師</p>
                    </div>
                  </div>

                  {displayContent ? (
                    <div className="max-h-[700px] overflow-y-auto pr-2">
                      <FengshuiMarkdown content={displayContent} />
                      {isAnalyzing && (
                        <span className="inline-block w-2 h-4 bg-amber-500 animate-pulse ml-1" />
                      )}
                    </div>
                  ) : isAnalyzing ? (
                    <div className="space-y-3 animate-pulse">
                      <div className="h-4 bg-amber-900/30 rounded w-3/4" />
                      <div className="h-4 bg-amber-900/30 rounded w-1/2" />
                      <div className="h-4 bg-amber-900/30 rounded w-5/6" />
                      <div className="h-4 bg-amber-900/30 rounded w-2/3" />
                    </div>
                  ) : null}

                  {!isAnalyzing && displayContent && (
                    <div className="mt-4 pt-3 border-t border-amber-900/20 text-center">
                      <span className="text-xs text-amber-800/40">
                        天機堂 × Compass | {viewingCached
                          ? new Date(viewingCached.timestamp).toLocaleString('zh-TW')
                          : new Date().toLocaleString('zh-TW')}
                      </span>
                    </div>
                  )}
                </div>
              </div>

              {/* 侧边栏 */}
              <div className="lg:w-80 space-y-4">
                {displayElevation && !displayElevation.error && <ElevationCard data={displayElevation} />}
                {displayPlaces && !displayPlaces.error && <PlacesSummaryCard data={displayPlaces} />}
                {displayCrime && !displayCrime.error && <CrimeCard data={displayCrime} />}

                {/* 数据加载中 placeholders */}
                {isAnalyzing && !elevation && !viewingCached && (
                  <div className="bg-neutral-900/60 rounded-xl border border-amber-800/10 p-5 animate-pulse">
                    <div className="h-4 bg-amber-900/20 rounded w-1/2 mb-3" />
                    <div className="h-3 bg-amber-900/15 rounded w-full mb-2" />
                    <div className="h-3 bg-amber-900/15 rounded w-3/4" />
                  </div>
                )}
              </div>
            </div>
          </div>
        </section>
      )}

      {/* 功能介紹 */}
      {!showResults && !showHistory && (
        <section className="py-16 bg-neutral-950">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              {[
                { icon: '⛰️', title: '巒頭形勢', desc: '9點地形高差分析，識別靠山與地勢走向' },
                { icon: '💧', title: '水法分析', desc: '周邊水體探測，湖泊河流小溪的財運影響' },
                { icon: '🏛️', title: '環境煞氣', desc: '負面設施距離監測，吉地環境加分評估' },
              ].map(item => (
                <div key={item.title} className="text-center p-6 rounded-xl border border-amber-900/15 bg-neutral-900/40">
                  <div className="text-3xl mb-3">{item.icon}</div>
                  <h3 className="text-amber-200 font-semibold mb-2">{item.title}</h3>
                  <p className="text-amber-800/50 text-sm">{item.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* 近期堪輿排行 — 公開展示 */}
      {!showResults && publicRecords.length > 0 && (
        <section className="py-12 bg-neutral-950">
          <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8">
            {/* 標題 + 統計 */}
            <div className="text-center mb-8">
              <h2 className="text-2xl font-bold text-amber-100 mb-2">📜 近期堪輿排行</h2>
              <p className="text-amber-700/60 text-sm mb-4">
                天機堂已為 {Object.values(recordStats).reduce((a, b) => a + b, 0)} 處物業完成風水堪輿
              </p>
              {/* 評級統計 pills */}
              <div className="flex justify-center gap-2 flex-wrap">
                {['A', 'B', 'C', 'D', 'E'].map(r => {
                  const count = recordStats[r] || 0;
                  if (count === 0) return null;
                  const colors: Record<string, string> = {
                    A: 'bg-green-900/40 text-green-400 border-green-700/30',
                    B: 'bg-blue-900/40 text-blue-400 border-blue-700/30',
                    C: 'bg-amber-900/40 text-amber-400 border-amber-700/30',
                    D: 'bg-orange-900/40 text-orange-400 border-orange-700/30',
                    E: 'bg-red-900/40 text-red-400 border-red-700/30',
                  };
                  return (
                    <button
                      key={r}
                      onClick={() => setRecordFilter(recordFilter === r ? '' : r)}
                      className={`px-3 py-1 rounded-full text-xs font-medium border transition-all ${
                        recordFilter === r
                          ? colors[r].replace('/40', '/70').replace('/30', '/60') + ' ring-1 ring-current'
                          : colors[r]
                      }`}
                    >
                      {r} 級 · {count}
                    </button>
                  );
                })}
                {recordFilter && (
                  <button
                    onClick={() => setRecordFilter('')}
                    className="px-3 py-1 rounded-full text-xs text-amber-600/50 border border-amber-800/20 hover:text-amber-400 transition-colors"
                  >
                    全部
                  </button>
                )}
              </div>
            </div>

            {/* 記錄列表 */}
            <div className="space-y-3">
              {publicRecords.map((rec) => {
                const ratingColors: Record<string, string> = {
                  A: 'from-green-600 to-green-800',
                  B: 'from-blue-600 to-blue-800',
                  C: 'from-amber-600 to-amber-800',
                  D: 'from-orange-600 to-orange-800',
                  E: 'from-red-600 to-red-800',
                };
                const borderColors: Record<string, string> = {
                  A: 'border-green-800/30 hover:border-green-700/50',
                  B: 'border-blue-800/30 hover:border-blue-700/50',
                  C: 'border-amber-800/30 hover:border-amber-700/50',
                  D: 'border-orange-800/30 hover:border-orange-700/50',
                  E: 'border-red-800/30 hover:border-red-700/50',
                };
                return (
                  <div
                    key={rec.id}
                    className={`bg-neutral-900/80 rounded-xl border p-4 md:p-5 transition-all ${borderColors[rec.rating] || 'border-amber-800/20'}`}
                  >
                    <div className="flex items-start gap-3 md:gap-4">
                      {/* 評級徽標 */}
                      <div className={`flex-shrink-0 w-11 h-11 rounded-lg bg-gradient-to-br ${ratingColors[rec.rating] || 'from-neutral-600 to-neutral-800'} flex items-center justify-center`}>
                        <span className="text-white text-lg font-bold">{rec.rating}</span>
                      </div>
                      {/* 內容 */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 flex-wrap">
                          <h3 className="text-amber-100 font-medium text-sm md:text-base truncate">{rec.address}</h3>
                          {rec.has_floor_plan && <span className="text-[10px] px-1.5 py-0.5 rounded bg-amber-900/30 text-amber-500/70">📐 含平面圖</span>}
                        </div>
                        <div className="flex items-center gap-3 mt-1 text-xs text-amber-700/50 flex-wrap">
                          <span>{rec.suburb}區</span>
                          {rec.center_elevation && <span>海拔 {rec.center_elevation}m</span>}
                          {rec.has_backing && <span className="text-green-500/60">✓ 有靠山（{rec.backing_direction}）</span>}
                          {rec.has_water && <span className="text-blue-400/60">💧 近水</span>}
                          {rec.positive_count > 0 && <span className="text-green-500/50">吉地×{rec.positive_count}</span>}
                          {rec.negative_count > 0 && <span className="text-red-400/50">煞氣×{rec.negative_count}</span>}
                        </div>
                        {rec.summary && (
                          <p className="text-amber-100/50 text-xs mt-2 line-clamp-2">{rec.summary}</p>
                        )}
                      </div>
                      {/* 時間 */}
                      <div className="flex-shrink-0 text-right hidden md:block">
                        <span className="text-amber-800/40 text-[10px]">
                          {rec.created_at ? new Date(rec.created_at).toLocaleDateString('zh-TW') : ''}
                        </span>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </section>
      )}

      {/* 免責聲明 */}
      {!showResults && (
        <section className="pb-16 bg-neutral-950">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center">
              <p className="text-amber-900/40 text-xs leading-relaxed max-w-lg mx-auto">
                免責聲明：天機堂風水分析基於地形數據與傳統堪輿理論的 AI 綜合判讀，僅供參考，
                不構成任何購房建議。實際購房決策請結合專業驗房報告與個人需求。
              </p>
            </div>
          </div>
        </section>
      )}
    </div>
  );
}

// ====== 子组件 ======

/** 评级徽标 */
function RatingBadge({ rating }: { rating: string }) {
  const colors: Record<string, string> = {
    A: 'bg-green-600 text-white',
    B: 'bg-blue-600 text-white',
    C: 'bg-amber-600 text-white',
    D: 'bg-orange-600 text-white',
    E: 'bg-red-600 text-white',
    '?': 'bg-neutral-600 text-white',
  };
  return (
    <span className={`inline-flex items-center justify-center w-6 h-6 rounded text-xs font-bold ${colors[rating] || colors['?']}`}>
      {rating}
    </span>
  );
}

/** 风水主题 Markdown 渲染 */
function FengshuiMarkdown({ content }: { content: string }) {
  if (!content) return null;
  const lines = content.split('\n');

  return (
    <div className="space-y-0.5">
      {lines.map((line, i) => {
        const trimmed = line.trim();
        if (!trimmed) return <div key={i} className="h-2" />;

        if (trimmed.startsWith('## ')) {
          return (
            <h3 key={i} className="text-lg font-bold text-amber-200 mt-5 mb-2 border-b border-amber-800/20 pb-1">
              {trimmed.slice(3)}
            </h3>
          );
        }
        if (trimmed.startsWith('### ')) {
          return <h4 key={i} className="text-base font-semibold text-amber-300/80 mt-3 mb-1">{trimmed.slice(4)}</h4>;
        }
        if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
          return (
            <li key={i} className="ml-4 text-amber-100/70 mb-1 text-sm list-disc">
              <FengshuiInline text={trimmed.slice(2)} />
            </li>
          );
        }
        if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
          return <p key={i} className="font-semibold text-amber-100 text-sm">{trimmed.slice(2, -2)}</p>;
        }
        return (
          <p key={i} className="text-amber-100/70 text-sm leading-relaxed">
            <FengshuiInline text={trimmed} />
          </p>
        );
      })}
    </div>
  );
}

function FengshuiInline({ text }: { text: string }) {
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  return (
    <>
      {parts.map((part, i) => {
        if (part.startsWith('**') && part.endsWith('**')) {
          return <strong key={i} className="font-semibold text-amber-200">{part.slice(2, -2)}</strong>;
        }
        return <span key={i}>{part}</span>;
      })}
    </>
  );
}

/** 地形卡 */
function ElevationCard({ data }: { data: ElevationData }) {
  return (
    <div className="bg-neutral-900/80 rounded-xl border border-amber-800/20 p-5">
      <h4 className="font-semibold text-amber-200 text-sm mb-3 flex items-center gap-2">
        <span>⛰️</span> 地形分析
      </h4>

      <div className="text-center mb-3">
        <span className="text-amber-100 text-sm">中心海拔</span>
        <span className="text-2xl font-bold text-amber-300 ml-2">{data.center_elevation}m</span>
      </div>

      {data.has_backing && (
        <div className="mb-3 p-2 bg-green-950/30 border border-green-800/30 rounded-lg text-center">
          <span className="text-green-400 text-sm font-medium">
            ✓ 有靠山 · {data.backing_direction}方 · 高差{data.max_height_diff}m
          </span>
        </div>
      )}

      {!data.has_backing && (
        <div className="mb-3 p-2 bg-amber-950/20 border border-amber-800/20 rounded-lg text-center">
          <span className="text-amber-600/60 text-sm">
            {data.terrain_flat ? '地勢平坦，無明顯靠山' : '未檢測到靠山'}
          </span>
        </div>
      )}

      {/* 8方位表 */}
      <div className="space-y-1.5">
        {DIRECTION_ORDER.map((dir) => {
          const diff = data.relative_to_center[dir] ?? 0;
          const isMax = dir === data.backing_direction && data.has_backing;
          return (
            <div key={dir} className="flex items-center justify-between text-xs">
              <span className={`w-8 ${isMax ? 'text-green-400 font-bold' : 'text-amber-600/60'}`}>{dir}</span>
              <div className="flex-1 mx-2 h-1.5 bg-neutral-800 rounded-full overflow-hidden">
                <div
                  className={`h-full rounded-full transition-all duration-500 ${
                    diff > 2 ? 'bg-green-500' : diff > 0 ? 'bg-amber-600' : 'bg-amber-900/40'
                  }`}
                  style={{ width: `${Math.min(Math.max((diff + 10) / 20 * 100, 5), 100)}%` }}
                />
              </div>
              <span className={`w-14 text-right ${isMax ? 'text-green-400 font-bold' : 'text-amber-500/60'}`}>
                {diff > 0 ? '+' : ''}{diff}m
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

/** 周边设施卡 */
function PlacesSummaryCard({ data }: { data: PlacesData }) {
  const hasNeg = data.negative.length > 0;
  const hasPos = data.positive.length > 0;
  const hasWater = data.water_features.length > 0;

  if (!hasNeg && !hasPos && !hasWater) return null;

  return (
    <div className="bg-neutral-900/80 rounded-xl border border-amber-800/20 p-5">
      <h4 className="font-semibold text-amber-200 text-sm mb-3 flex items-center gap-2">
        <span>🏛️</span> 周邊環境
      </h4>

      {/* 负面 */}
      {hasNeg && (
        <div className="mb-3">
          <p className="text-xs text-red-400/80 font-medium mb-1.5">煞氣設施</p>
          {data.negative.slice(0, 5).map((p, i) => (
            <div key={i} className="flex items-center justify-between text-xs py-1 border-b border-neutral-800/50 last:border-0">
              <span className="text-red-300/70 truncate flex-1">✗ {p.name}</span>
              <span className="text-red-500/50 ml-2">{p.distance_m}m</span>
            </div>
          ))}
        </div>
      )}

      {!hasNeg && (
        <div className="mb-3 p-2 bg-green-950/20 rounded-lg">
          <span className="text-green-500/70 text-xs">✓ 500m內無負面設施</span>
        </div>
      )}

      {/* 正面 */}
      {hasPos && (
        <div className="mb-3">
          <p className="text-xs text-green-400/80 font-medium mb-1.5">吉地環境</p>
          {data.positive.slice(0, 5).map((p, i) => (
            <div key={i} className="flex items-center justify-between text-xs py-1 border-b border-neutral-800/50 last:border-0">
              <span className="text-green-300/70 truncate flex-1">✓ {p.name}</span>
              <span className="text-green-500/50 ml-2">{p.distance_m}m</span>
            </div>
          ))}
        </div>
      )}

      {/* 水体 */}
      {hasWater && (
        <div>
          <p className="text-xs text-blue-400/80 font-medium mb-1.5">水體（財位）</p>
          {data.water_features.slice(0, 3).map((p, i) => (
            <div key={i} className="flex items-center justify-between text-xs py-1 border-b border-neutral-800/50 last:border-0">
              <span className="text-blue-300/70 truncate flex-1">💧 {p.name}</span>
              <span className="text-blue-500/50 ml-2">{p.distance_m}m</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/** 治安卡 - 全中文 */
function CrimeCard({ data }: { data: CrimeData }) {
  const entries = Object.entries(data.categories || {}).slice(0, 6);
  if (entries.length === 0) return null;

  const maxCount = Math.max(...entries.map(([, v]) => v), 1);

  return (
    <div className="bg-neutral-900/80 rounded-xl border border-amber-800/20 p-5">
      <h4 className="font-semibold text-amber-200 text-sm mb-3 flex items-center gap-2">
        <span>🛡️</span> 治安數據
      </h4>

      <div className="text-center mb-3">
        <span className="text-amber-100/60 text-xs">近12個月 · {data.suburb}區</span>
        <div className="text-xl font-bold text-amber-300 mt-1">{data.total_incidents.toLocaleString()}</div>
        <span className="text-amber-700/50 text-xs">案件總數</span>
      </div>

      <div className="space-y-2">
        {entries.map(([cat, count]) => (
          <div key={cat}>
            <div className="flex justify-between text-xs mb-0.5">
              <span className="text-amber-500/60 truncate flex-1">
                {CRIME_CATEGORY_ZH[cat] || cat}
              </span>
              <span className="text-amber-400/70 ml-2">{count.toLocaleString()}</span>
            </div>
            <div className="h-1.5 bg-neutral-800 rounded-full overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-amber-700 to-red-700 rounded-full"
                style={{ width: `${(count / maxCount) * 100}%` }}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
