/**
 * Compass 多模态分析 SSE 流解析器
 * 处理 /api/analyze/multimodal 返回的多事件 SSE 流
 */

import { API_BASE } from './api';

// ====== 类型定义 ======

export interface PropertyData {
  source: string;
  url: string;
  address: string;
  suburb: string;
  price: string;
  bedrooms: number;
  bathrooms: number;
  parking: number;
  land_size: number;
  property_type: string;
  description: string;
  images: string[];
  error?: string;
}

export interface EthanScore {
  total: number;
  grade: string;
  breakdown: Record<string, { score: number; max: number }>;
}

export interface ComparableSale {
  address: string;
  price: number;
  date: string;
  type: string;
  beds: number;
  baths: number;
  land_sqm: number;
  price_per_sqm?: number;
  suburb?: string;
}

export interface ComparableSalesData {
  same_suburb: ComparableSale[];
  nearby_suburbs: ComparableSale[];
  stats: {
    same_suburb_median?: number;
    same_suburb_avg?: number;
    same_suburb_min?: number;
    same_suburb_max?: number;
    same_suburb_count?: number;
    nearby_median?: number;
    nearby_count?: number;
    price_trend_6m?: string;
  };
}

export interface LeoVerdict {
  verdict: string;      // 值得买 / 观望 / 不建议
  confidence: string;   // 高 / 中 / 低
  fair_price_range: string;
  reason: string;
}

export interface MetaData {
  input_type: string;
  suburb: string;
  mode: string;
  has_images: boolean;
  geocoded?: boolean;
  formatted_address?: string;
}

export interface StreamCallbacks {
  onMeta?: (data: MetaData) => void;
  onPropertyData?: (data: PropertyData) => void;
  onEthanScore?: (data: EthanScore) => void;
  onComparableSales?: (data: ComparableSalesData) => void;
  onAmandaContent?: (text: string) => void;
  onLeoVerdict?: (data: LeoVerdict) => void;
  onDone?: () => void;
  onError?: (message: string) => void;
}

// ====== 流式请求 ======

export async function streamMultimodalAnalysis(
  textInput: string | null,
  images: File[],
  mode: string,
  callbacks: StreamCallbacks,
  signal?: AbortSignal,
): Promise<void> {
  const formData = new FormData();
  if (textInput) {
    formData.append('text_input', textInput);
  }
  formData.append('mode', mode);
  images.forEach((img) => formData.append('images', img));

  const response = await fetch(`${API_BASE}/api/analyze/multimodal`, {
    method: 'POST',
    body: formData,
    signal,
  });

  if (!response.ok) {
    const errData = await response.json().catch(() => ({}));
    throw new Error(errData.detail || `分析失败 (${response.status})`);
  }

  const reader = response.body?.getReader();
  if (!reader) throw new Error('浏览器不支持流式响应');

  const decoder = new TextDecoder();
  let buffer = '';

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      // 保留最后一行（可能不完整）
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (!line.startsWith('data: ')) continue;
        try {
          const payload = JSON.parse(line.slice(6));
          switch (payload.type) {
            case 'meta':
              callbacks.onMeta?.(payload as MetaData);
              break;
            case 'property_data':
              callbacks.onPropertyData?.(payload.data as PropertyData);
              break;
            case 'ethan_score':
              callbacks.onEthanScore?.(payload.data as EthanScore);
              break;
            case 'comparable_sales':
              callbacks.onComparableSales?.(payload.data as ComparableSalesData);
              break;
            case 'amanda_content':
              callbacks.onAmandaContent?.(payload.text as string);
              break;
            case 'leo_verdict':
              callbacks.onLeoVerdict?.(payload.data as LeoVerdict);
              break;
            case 'done':
              callbacks.onDone?.();
              break;
            case 'error':
              callbacks.onError?.(payload.message || '分析出错');
              break;
          }
        } catch (e) {
          if (e instanceof SyntaxError) continue;
          throw e;
        }
      }
    }
  } finally {
    reader.releaseLock();
  }
}

// ====== 输入类型检测 (前端) ======

export type InputType = 'domain_url' | 'rea_url' | 'address' | 'image' | 'freeform';

export function detectInputType(text: string, hasImages: boolean): InputType {
  if (hasImages) return 'image';
  if (!text) return 'freeform';
  const t = text.trim().toLowerCase();
  if (t.includes('domain.com.au')) return 'domain_url';
  if (t.includes('realestate.com.au')) return 'rea_url';
  // 地址检测（带街道类型后缀）
  if (/\d+\s+\w+\s+(st|street|rd|road|ave|avenue|dr|drive|ct|court|pl|place|cr|crescent|way|lane|ln|tce|terrace|pde|parade|cct|circuit|cl|close)/i.test(t)) return 'address';
  // 已知suburb名或者看起来像地名（纯英文词，1-3个单词）
  if (/^[a-z\s]+$/i.test(t.trim()) && t.trim().split(/\s+/).length <= 3 && t.trim().length >= 3) return 'address';
  return 'freeform';
}

export const INPUT_TYPE_LABELS: Record<InputType, { emoji: string; label: string }> = {
  domain_url: { emoji: '🔗', label: 'Domain 链接已识别' },
  rea_url: { emoji: '🔗', label: 'REA 链接已识别' },
  address: { emoji: '📍', label: '地址已识别' },
  image: { emoji: '📷', label: '图片分析模式' },
  freeform: { emoji: '💬', label: '自由提问' },
};
