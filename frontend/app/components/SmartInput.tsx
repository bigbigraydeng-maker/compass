'use client';

import { useState, useRef, useCallback, useEffect } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { PersonaButton } from './persona';
import { CORE_SUBURBS } from '../lib/suburbs';
import {
  streamMultimodalAnalysis,
  detectInputType,
  INPUT_TYPE_LABELS,
  type InputType,
  type PropertyData,
  type EthanScore,
  type ComparableSalesData,
  type LeoVerdict,
  type MetaData,
} from '../lib/streamAnalysis';
import AnalysisResults from './AnalysisResults';

// 分析模式
const MODES = [
  { key: 'general', label: '投资分析', icon: '🏠' },
  { key: 'school', label: '学区', icon: '🏫' },
  { key: 'first_home', label: '首置', icon: '🏡' },
  { key: 'overseas', label: '海外', icon: '🌏' },
] as const;

export default function SmartInput() {
  const router = useRouter();

  // 输入状态
  const [textInput, setTextInput] = useState('');
  const [images, setImages] = useState<File[]>([]);
  const [imagePreviews, setImagePreviews] = useState<string[]>([]);
  const [mode, setMode] = useState('general');
  const [inputType, setInputType] = useState<InputType>('freeform');

  // 输入校验
  const [validationError, setValidationError] = useState<string | null>(null);

  // 分析状态
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [showResults, setShowResults] = useState(false);
  const [meta, setMeta] = useState<MetaData | null>(null);
  const [propertyData, setPropertyData] = useState<PropertyData | null>(null);
  const [ethanScore, setEthanScore] = useState<EthanScore | null>(null);
  const [comparableSales, setComparableSales] = useState<ComparableSalesData | null>(null);
  const [amandaContent, setAmandaContent] = useState('');
  const [leoVerdict, setLeoVerdict] = useState<LeoVerdict | null>(null);
  const [error, setError] = useState<string | null>(null);

  const fileInputRef = useRef<HTMLInputElement>(null);
  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const abortRef = useRef<AbortController | null>(null);

  // 实时检测输入类型
  useEffect(() => {
    setInputType(detectInputType(textInput, images.length > 0));
  }, [textInput, images]);

  // 自动调整文本框高度
  const adjustHeight = useCallback(() => {
    const el = textareaRef.current;
    if (el) {
      el.style.height = 'auto';
      el.style.height = `${Math.min(el.scrollHeight, 150)}px`;
    }
  }, []);

  // 图片选择
  const handleImageSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    const valid = files.filter(f => f.size <= 5 * 1024 * 1024 && f.type.startsWith('image/'));
    const newImages = [...images, ...valid].slice(0, 3);
    setImages(newImages);
    // 生成预览
    const previews = newImages.map(f => URL.createObjectURL(f));
    imagePreviews.forEach(p => URL.revokeObjectURL(p));
    setImagePreviews(previews);
    if (e.target) e.target.value = '';
  };

  const removeImage = (index: number) => {
    URL.revokeObjectURL(imagePreviews[index]);
    setImages(prev => prev.filter((_, i) => i !== index));
    setImagePreviews(prev => prev.filter((_, i) => i !== index));
  };

  // 重置分析状态
  const resetAnalysis = () => {
    setShowResults(false);
    setMeta(null);
    setPropertyData(null);
    setEthanScore(null);
    setComparableSales(null);
    setAmandaContent('');
    setLeoVerdict(null);
    setError(null);
  };

  // 输入校验
  const validateInput = (text: string, hasImages: boolean): string | null => {
    if (hasImages) return null; // 有图片就可以分析
    if (!text.trim()) return '请输入地址或粘贴链接';
    const t = text.trim();
    // URL直接通过
    if (t.toLowerCase().includes('domain.com.au') || t.toLowerCase().includes('realestate.com.au')) return null;
    // 地址格式通过
    if (/\d+\s+\w+\s+(st|street|rd|road|ave|avenue|dr|drive|ct|court|pl|place|cr|crescent|way|lane|ln|tce|terrace|pde|parade|cct|circuit|cl|close)/i.test(t)) return null;
    // 看起来像地名（纯英文，1-3词，3+字符）
    if (/^[a-zA-Z\s]+$/.test(t) && t.split(/\s+/).length <= 3 && t.length >= 3) return null;
    // 包含数字+文字的组合也可能是地址
    if (/\d+/.test(t) && /[a-zA-Z]/.test(t) && t.length >= 5) return null;
    return '请输入有效的房产地址（如: 10 Smith St, Sunnybank）、Domain/REA链接、或区域名称';
  };

  // 提交分析
  const handleSubmit = async (e?: React.FormEvent) => {
    e?.preventDefault();
    if (!textInput.trim() && images.length === 0) return;

    // 输入校验
    const error = validateInput(textInput, images.length > 0);
    if (error) {
      setValidationError(error);
      setTimeout(() => setValidationError(null), 4000);
      return;
    }
    setValidationError(null);

    // 中断之前的请求
    abortRef.current?.abort();
    abortRef.current = new AbortController();

    resetAnalysis();
    setIsAnalyzing(true);
    setShowResults(true);

    try {
      await streamMultimodalAnalysis(
        textInput.trim() || null,
        images,
        mode,
        {
          onMeta: (data) => setMeta(data),
          onPropertyData: (data) => setPropertyData(data),
          onEthanScore: (data) => setEthanScore(data),
          onComparableSales: (data) => setComparableSales(data),
          onAmandaContent: (text) => setAmandaContent(prev => prev + text),
          onLeoVerdict: (data) => setLeoVerdict(data),
          onDone: () => setIsAnalyzing(false),
          onError: (msg) => {
            setError(msg);
            setIsAnalyzing(false);
          },
        },
        abortRef.current.signal,
      );
    } catch (err: any) {
      if (err.name !== 'AbortError') {
        setError(err.message || '分析失败，请重试');
      }
      setIsAnalyzing(false);
    }
  };

  // 快捷区域
  const quickSuburbs = CORE_SUBURBS.map(s => ({
    name: s,
    label: s === 'Eight Mile Plains' ? 'EMP' : s,
  }));

  const quickAnalyze = (suburb: string) => {
    setTextInput(suburb);
    // 触发一次分析
    setTimeout(() => {
      setTextInput(suburb);
      handleSubmitDirect(suburb);
    }, 0);
  };

  const handleSubmitDirect = async (directInput: string) => {
    abortRef.current?.abort();
    abortRef.current = new AbortController();
    resetAnalysis();
    setIsAnalyzing(true);
    setShowResults(true);
    try {
      await streamMultimodalAnalysis(
        directInput,
        [],
        mode,
        {
          onMeta: (data) => setMeta(data),
          onPropertyData: (data) => setPropertyData(data),
          onEthanScore: (data) => setEthanScore(data),
          onComparableSales: (data) => setComparableSales(data),
          onAmandaContent: (text) => setAmandaContent(prev => prev + text),
          onLeoVerdict: (data) => setLeoVerdict(data),
          onDone: () => setIsAnalyzing(false),
          onError: (msg) => {
            setError(msg);
            setIsAnalyzing(false);
          },
        },
        abortRef.current.signal,
      );
    } catch (err: any) {
      if (err.name !== 'AbortError') {
        setError(err.message || '分析失败，请重试');
      }
      setIsAnalyzing(false);
    }
  };

  // Ctrl+Enter 提交
  const handleKeyDown = (e: React.KeyboardEvent) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
      handleSubmit();
    }
  };

  // 功能卡片
  const featureCards: Array<{
    icon: string; title: string; desc: string; href: string;
    gradient: string; border: string; hoverBg: string; hot?: boolean;
  }> = [
    {
      icon: '🏫', title: '校区找房', desc: '按学区质量寻找投资机会',
      href: '/school-search',
      gradient: 'from-emerald-500/20 to-emerald-600/10',
      border: 'border-emerald-400/30',
      hoverBg: 'hover:bg-emerald-500/20',
    },
    {
      icon: '🏠', title: '首次置业', desc: '首置补贴 · 预算计算 · AI顾问',
      href: '/first-home',
      gradient: 'from-blue-500/20 to-blue-600/10',
      border: 'border-blue-400/30',
      hoverBg: 'hover:bg-blue-500/20',
    },
    {
      icon: '🌏', title: '海外人士购房', desc: 'FIRB指南 · 税费 · AI顾问',
      href: '/overseas-buyer',
      gradient: 'from-purple-500/20 to-purple-600/10',
      border: 'border-purple-400/30',
      hoverBg: 'hover:bg-purple-500/20',
    },
    {
      icon: '☰', title: '天機堂', desc: '風水堪輿 · 地形煞氣 · 胡師傅',
      href: '/feng-shui',
      gradient: 'from-amber-500/20 to-red-700/10',
      border: 'border-amber-400/30',
      hoverBg: 'hover:bg-amber-500/20',
      hot: true,
    },
  ];

  const typeInfo = INPUT_TYPE_LABELS[inputType];

  return (
    <>
      <section className="relative text-white py-16 md:py-28 overflow-hidden">
        {/* Background */}
        <div
          className="absolute inset-0 bg-cover bg-center bg-no-repeat"
          style={{
            backgroundImage: `url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80')`,
          }}
        />
        <div className="absolute inset-0 bg-gradient-to-b from-black/70 via-black/60 to-black/80" />

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          {/* Header */}
          <div className="text-center mb-8 md:mb-12">
            <h1 className="text-3xl md:text-5xl lg:text-6xl font-bold mb-3 md:mb-5 drop-shadow-lg">
              Compass 2.0
            </h1>
            <h2 className="text-lg md:text-2xl font-semibold mb-3 md:mb-6 drop-shadow-md">
              AI驱动的房产投资机会发现平台
            </h2>
            <p className="text-sm md:text-lg text-gray-200 max-w-2xl mx-auto drop-shadow">
              粘贴 Domain/REA 链接 · 输入地址 · 上传图片 · 自由提问
            </p>
          </div>

          {/* 智能输入区 */}
          <div className="max-w-3xl mx-auto">
            <div className="bg-white/10 backdrop-blur-md rounded-2xl border border-white/20 overflow-hidden">
              {/* 文本输入 */}
              <div className="p-4 md:p-5">
                <textarea
                  ref={textareaRef}
                  value={textInput}
                  onChange={(e) => { setTextInput(e.target.value); adjustHeight(); }}
                  onKeyDown={handleKeyDown}
                  placeholder="粘贴 Domain/REA 链接、输入地址、或直接提问..."
                  rows={2}
                  className="w-full bg-transparent text-white placeholder-gray-400 text-base md:text-lg resize-none focus:outline-none"
                  style={{ minHeight: '52px' }}
                />
              </div>

              {/* 输入校验错误 */}
              {validationError && (
                <div className="mx-4 md:mx-5 mb-2 px-3 py-2 bg-red-500/20 border border-red-400/40 rounded-lg text-red-200 text-sm">
                  ⚠️ {validationError}
                </div>
              )}

              {/* 图片预览 */}
              {imagePreviews.length > 0 && (
                <div className="px-4 md:px-5 pb-3 flex gap-2">
                  {imagePreviews.map((src, i) => (
                    <div key={i} className="relative w-16 h-16 rounded-lg overflow-hidden border border-white/30">
                      <img src={src} alt="" className="w-full h-full object-cover" />
                      <button
                        onClick={() => removeImage(i)}
                        className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full text-white text-xs flex items-center justify-center hover:bg-red-600"
                      >
                        x
                      </button>
                    </div>
                  ))}
                </div>
              )}

              {/* 工具栏 */}
              <div className="px-4 md:px-5 pb-4 flex items-center justify-between gap-3 flex-wrap">
                <div className="flex items-center gap-3">
                  {/* 图片上传 */}
                  <button
                    onClick={() => fileInputRef.current?.click()}
                    className="text-gray-300 hover:text-white transition-colors text-sm flex items-center gap-1"
                    disabled={images.length >= 3}
                  >
                    <span>📷</span>
                    <span className="hidden md:inline">
                      {images.length > 0 ? `${images.length}/3` : '上传图片'}
                    </span>
                  </button>
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/jpeg,image/png,image/webp"
                    multiple
                    onChange={handleImageSelect}
                    className="hidden"
                  />

                  {/* 输入类型标签 */}
                  {(textInput.trim() || images.length > 0) && (
                    <span className="text-xs px-2 py-1 rounded-full bg-white/15 text-gray-200">
                      {typeInfo.emoji} {typeInfo.label}
                    </span>
                  )}
                </div>

                <div className="flex items-center gap-2">
                  {/* 模式选择 */}
                  <div className="flex gap-1">
                    {MODES.map((m) => (
                      <button
                        key={m.key}
                        onClick={() => setMode(m.key)}
                        className={`text-xs px-2 py-1 rounded-full transition-colors ${
                          mode === m.key
                            ? 'bg-blue-500/40 text-white border border-blue-400/50'
                            : 'bg-white/10 text-gray-300 hover:bg-white/20'
                        }`}
                      >
                        <span className="mr-0.5">{m.icon}</span>
                        <span>{m.label}</span>
                      </button>
                    ))}
                  </div>

                  {/* 提交按钮 */}
                  <PersonaButton
                    persona="amanda"
                    loading={isAnalyzing}
                    onClick={() => handleSubmit()}
                    label="Amanda 分析"
                    loadingLabel="分析中..."
                    disabled={!textInput.trim() && images.length === 0}
                    size="sm"
                    className="!py-2 !px-4"
                  />
                </div>
              </div>
            </div>

            {/* 快捷提示 */}
            <p className="text-center text-gray-400 text-xs mt-4">
              粘贴 Domain/REA 链接 · 输入地址 · 上传图片 · 自由提问
            </p>
          </div>

          {/* 功能卡片 */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 md:gap-6 mt-10 md:mt-16 max-w-4xl mx-auto">
            {featureCards.map((card) => (
              <Link
                key={card.title}
                href={card.href}
                className={`relative bg-gradient-to-br ${card.gradient} backdrop-blur-md rounded-xl p-4 md:p-6 text-center ${card.hoverBg} transition-all border ${card.border} group hover:scale-105`}
              >
                {card.hot && (
                  <span className="absolute -top-2 -right-2 bg-gradient-to-r from-red-500 to-orange-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full shadow-lg animate-pulse">
                    HOT
                  </span>
                )}
                <div className="text-2xl md:text-4xl mb-2 md:mb-4 group-hover:scale-110 transition-transform">
                  {card.icon}
                </div>
                <h3 className="text-sm md:text-xl font-semibold mb-1 md:mb-2">{card.title}</h3>
                <p className="text-gray-300 text-[10px] md:text-sm hidden md:block">{card.desc}</p>
              </Link>
            ))}
          </div>
        </div>
      </section>

      {/* 分析结果 */}
      {showResults && (
        <AnalysisResults
          isLoading={isAnalyzing}
          meta={meta}
          propertyData={propertyData}
          ethanScore={ethanScore}
          comparableSales={comparableSales}
          amandaContent={amandaContent}
          leoVerdict={leoVerdict}
          error={error}
          onClose={resetAnalysis}
        />
      )}
    </>
  );
}
