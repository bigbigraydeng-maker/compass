export const API_BASE = process.env.NEXT_PUBLIC_API_BASE || 'http://localhost:8888';

export const fetcher = async (url: string, options?: RequestInit) => {
  const response = await fetch(`${API_BASE}${url}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options?.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.status} ${response.statusText}`);
  }

  return response.json();
};
