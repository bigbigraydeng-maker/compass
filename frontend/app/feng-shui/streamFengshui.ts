/**
 * 天機堂 · 风水堪輿分析 SSE 流解析器
 * 处理 /api/fengshui/analyze 返回的多事件 SSE 流
 */

import { API_BASE } from '../lib/api';

// ====== 类型定义 ======

export interface FengshuiMeta {
  address: string;
  suburb: string;
  lat: number;
  lng: number;
  has_floor_plan?: boolean;
}

export interface ElevationData {
  center_elevation: number;
  elevations: Record<string, number>;
  relative_to_center: Record<string, number>;
  backing_direction: string;
  has_backing: boolean;
  max_height_diff: number;
  terrain_flat: boolean;
  error?: string;
}

export interface PlaceItem {
  name: string;
  distance_m: number;
  vicinity: string;
  category: string;
}

export interface PlacesData {
  negative: PlaceItem[];
  positive: PlaceItem[];
  water_features: PlaceItem[];
  error?: string;
}

export interface CrimeData {
  suburb: string;
  total_incidents: number;
  categories: Record<string, number>;
  error?: string;
}

export interface FengshuiStreamCallbacks {
  onMeta?: (data: FengshuiMeta) => void;
  onElevation?: (data: ElevationData) => void;
  onPlaces?: (data: PlacesData) => void;
  onCrime?: (data: CrimeData) => void;
  onMasterHuContent?: (text: string) => void;
  onDone?: () => void;
  onError?: (message: string) => void;
}

// ====== 流式请求 ======

export async function streamFengshuiAnalysis(
  address: string,
  callbacks: FengshuiStreamCallbacks,
  signal?: AbortSignal,
  floorPlan?: File | null,
): Promise<void> {
  const formData = new FormData();
  formData.append('address', address);
  if (floorPlan) {
    formData.append('floor_plan', floorPlan);
  }

  const response = await fetch(`${API_BASE}/api/fengshui/analyze`, {
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
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (!line.startsWith('data: ')) continue;
        try {
          const payload = JSON.parse(line.slice(6));
          switch (payload.type) {
            case 'meta':
              callbacks.onMeta?.(payload as FengshuiMeta);
              break;
            case 'fengshui_data':
              if (payload.category === 'elevation') {
                callbacks.onElevation?.(payload.data as ElevationData);
              } else if (payload.category === 'places') {
                callbacks.onPlaces?.(payload.data as PlacesData);
              } else if (payload.category === 'crime') {
                callbacks.onCrime?.(payload.data as CrimeData);
              }
              break;
            case 'master_hu_content':
              callbacks.onMasterHuContent?.(payload.text as string);
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
