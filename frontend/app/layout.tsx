import type { Metadata } from 'next'
import Script from 'next/script'
import './globals.css'

export const metadata: Metadata = {
  title: 'Compass - 布里斯班华人房地产数据平台',
  description: '专注于 Sunnybank、Eight Mile Plains、Calamvale、Rochedale、Mansfield、Ascot、Hamilton 七个区域的房产成交数据',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="zh-CN">
      <head>
        <meta name="referrer" content="strict-origin-when-cross-origin" />
        <link rel="dns-prefetch" href="https://compass-api-o8gw.onrender.com" />
        <link rel="preconnect" href="https://compass-api-o8gw.onrender.com" crossOrigin="anonymous" />
        <link rel="dns-prefetch" href="https://maps.googleapis.com" />
        <link rel="preconnect" href="https://maps.googleapis.com" crossOrigin="anonymous" />
        <Script
          src="https://www.googletagmanager.com/gtag/js?id=G-4MNG89LCNX"
          strategy="afterInteractive"
        />
        <Script id="google-analytics" strategy="afterInteractive">
          {`
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'G-4MNG89LCNX');
          `}
        </Script>
      </head>
      <body className="antialiased">{children}</body>
    </html>
  )
}
