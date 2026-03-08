export const API_BASE = process.env.NEXT_PUBLIC_API_BASE || 'http://localhost:8888';

// === 内存缓存：相同数据5分钟内不重复请求 ===
const cache = new Map<string, { data: any; timestamp: number }>();
const CACHE_TTL = 5 * 60 * 1000; // 5 分钟缓存
const pendingRequests = new Map<string, Promise<any>>(); // 请求去重

function getCacheKey(url: string, options?: RequestInit): string {
  const method = options?.method || 'GET';
  const body = options?.body || '';
  return `${method}:${url}:${body}`;
}

export const fetcher = async (url: string, options?: RequestInit) => {
  const fullUrl = `${API_BASE}${url}`;
  const cacheKey = getCacheKey(fullUrl, options);
  const isGet = !options?.method || options.method === 'GET';

  // GET 请求检查缓存
  if (isGet) {
    const cached = cache.get(cacheKey);
    if (cached && Date.now() - cached.timestamp < CACHE_TTL) {
      return cached.data;
    }

    // 请求去重：相同URL的并发请求只发一次
    const pending = pendingRequests.get(cacheKey);
    if (pending) {
      return pending;
    }
  }

  const fetchPromise = (async () => {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 15000); // 15s 超时

      const response = await fetch(fullUrl, {
        ...options,
        signal: controller.signal,
        headers: {
          'Content-Type': 'application/json',
          ...options?.headers,
        },
      });

      clearTimeout(timeoutId);

      if (!response.ok) {
        throw new Error(`API Error: ${response.status} ${response.statusText}`);
      }

      const data = await response.json();

      // GET 请求存入缓存
      if (isGet) {
        cache.set(cacheKey, { data, timestamp: Date.now() });
      }

      return data;
    } finally {
      pendingRequests.delete(cacheKey);
    }
  })();

  if (isGet) {
    pendingRequests.set(cacheKey, fetchPromise);
  }

  return fetchPromise;
};

// 清除缓存（页面切换或手动刷新时使用）
export const clearCache = () => {
  cache.clear();
  pendingRequests.clear();
};
