import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Compass - 布里斯班华人房地产数据平台',
  description: '专注于 Sunnybank、Eight Mile Plains、Calamvale 三个区域的房产成交数据',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="zh-CN">
      <body className="antialiased">{children}</body>
    </html>
  )
}
