'use client';

import Image from 'next/image';
import Link from 'next/link';
import Navbar from '../components/Navbar';
import { PersonaAvatar } from '../components/persona';
import { PERSONAS, type PersonaKey } from '../components/persona/constants';

const TEAM_ORDER: PersonaKey[] = ['amanda', 'leo', 'olivia', 'ethan'];

const COFOUNDERS = [
  {
    name: 'Richard Hu',
    title: 'Co-Founder',
    location: 'Brisbane / Auckland',
    photo: '/images/personas/richardhu.jpg',
    bio: 'Investor and entrepreneur with over 14 years of professional experience across New Zealand and Australia, with deep expertise in residential property markets and commercial sales. Active in U.S. equities, quantitative trading systems, and early-stage ventures. Expanded focus into technology-driven business models and AI applications, applying a disciplined, probability-based approach to decision-making.',
    expertise: ['Investor', 'AI Applications', 'Equity Strategy', 'Property'],
    gradient: 'from-amber-500 to-orange-600',
    bgColor: 'bg-amber-50',
    textColor: 'text-amber-700',
  },
  {
    name: 'Ray Deng（大瑞）',
    title: 'Co-Founder',
    location: 'Auckland',
    photo: '/images/personas/raydeng.jpg',
    bio: 'Cross-border entrepreneur and AI strategist, founder of Compass AI, MoveHub and WorkVisas.work. Builds bridges between Chinese, Australian and New Zealand markets, identifying opportunities for trade, investment, and collaboration. From machine learning models to natural language processing, creates intelligent systems that enhance decision-making and automate complex workflows.',
    expertise: ['AI Strategy', 'Cross-Border Ops', 'Fintech', 'NLP & ML'],
    gradient: 'from-teal-500 to-cyan-600',
    bgColor: 'bg-teal-50',
    textColor: 'text-teal-700',
  },
];

const AREA_LABELS: Record<string, { label: string; href: string }[]> = {
  amanda: [
    { label: 'AI 聊天', href: '/' },
    { label: '投资分析', href: '/' },
    { label: '学区分析', href: '/school-search' },
    { label: '首次置业', href: '/first-home' },
    { label: '海外购房', href: '/overseas-buyer' },
  ],
  leo: [
    { label: '今日捡漏', href: '/' },
    { label: '折扣房源', href: '/' },
    { label: '投资回报', href: '/' },
  ],
  olivia: [
    { label: '每日新闻解读', href: '/' },
    { label: '市场动态', href: '/' },
    { label: '宏观经济分析', href: '/' },
  ],
  ethan: [
    { label: 'Suburbs 排名', href: '/rankings' },
    { label: 'Compass Score', href: '/' },
    { label: '多维数据分析', href: '/' },
  ],
};

export default function AboutPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navbar />

      {/* Hero Banner */}
      <div className="bg-gradient-to-br from-blue-600 via-indigo-600 to-purple-700 text-white py-16 md:py-24">
        <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-3xl md:text-5xl font-bold mb-4">
            About Compass AI
          </h1>
          <p className="text-lg md:text-xl text-blue-100 max-w-2xl mx-auto">
            由资深创始人团队打造，AI数字专家全方位守护您的布里斯班房产投资之旅
          </p>
        </div>
      </div>

      <main className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 -mt-12 pb-16">
        {/* Co-Founders Section */}
        <section className="mb-16">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">
            {COFOUNDERS.map((founder) => (
              <div
                key={founder.name}
                className="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:shadow-xl transition-shadow"
              >
                {/* Card Header with gradient */}
                <div className={`bg-gradient-to-r ${founder.gradient} p-4 sm:p-6 flex items-center gap-4 sm:gap-5`}>
                  <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-4 ring-white/30 overflow-hidden flex-shrink-0">
                    <Image
                      src={founder.photo}
                      alt={founder.name}
                      width={80}
                      height={80}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div className="text-white min-w-0">
                    <h2 className="text-xl sm:text-2xl font-bold truncate">{founder.name}</h2>
                    <p className="text-white/90 font-medium text-sm sm:text-base">{founder.title}</p>
                    <p className="text-white/70 text-xs sm:text-sm">{founder.location}</p>
                  </div>
                </div>

                {/* Card Body */}
                <div className="p-4 sm:p-6">
                  <p className="text-gray-600 text-sm leading-relaxed mb-5">
                    {founder.bio}
                  </p>
                  <div>
                    <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">
                      Expertise
                    </p>
                    <div className="flex flex-wrap gap-2">
                      {founder.expertise.map((tag) => (
                        <span
                          key={tag}
                          className={`${founder.bgColor} ${founder.textColor} text-xs font-medium px-3 py-1 rounded-full`}
                        >
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* AI Team Section */}
        <section>
          <h2 className="text-2xl font-bold text-gray-800 text-center mb-8">
            AI 数字员工团队
          </h2>
          <p className="text-gray-500 text-center mb-8 -mt-4 text-sm">
            4 位 AI 数字人专家，各司其职
          </p>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 md:gap-8">
          {TEAM_ORDER.map((key) => {
            const persona = PERSONAS[key];
            const areas = AREA_LABELS[key] || [];
            return (
              <div
                key={key}
                className="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden hover:shadow-xl transition-shadow"
              >
                {/* Card Header with gradient */}
                <div className={`bg-gradient-to-r ${persona.gradient} p-6 flex items-center gap-5`}>
                  <PersonaAvatar persona={key} size="xl" className="ring-4 ring-white/30" />
                  <div className="text-white">
                    <h2 className="text-2xl font-bold">{persona.name}</h2>
                    <p className="text-white/90 font-medium">{persona.title}</p>
                    <p className="text-white/70 text-sm">{persona.titleEn}</p>
                  </div>
                </div>

                {/* Card Body */}
                <div className="p-6">
                  {/* Bio */}
                  <p className="text-gray-600 text-sm leading-relaxed mb-5">
                    {persona.bio}
                  </p>

                  {/* Expertise Tags */}
                  <div className="mb-4">
                    <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">
                      Expertise
                    </p>
                    <div className="flex flex-wrap gap-2">
                      {persona.expertise.map((tag) => (
                        <span
                          key={tag}
                          className={`${persona.bgColor} ${persona.textColor} text-xs font-medium px-3 py-1 rounded-full`}
                        >
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Responsible Areas */}
                  <div>
                    <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">
                      Areas
                    </p>
                    <div className="flex flex-wrap gap-2">
                      {areas.map((area) => (
                        <Link
                          key={area.label}
                          href={area.href}
                          className="text-xs bg-gray-100 text-gray-600 hover:bg-gray-200 px-3 py-1 rounded-full transition-colors"
                        >
                          {area.label}
                        </Link>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
        </section>

        {/* Footer */}
        <div className="text-center mt-12 space-y-3">
          <p className="text-gray-500 text-sm">
            Powered by <span className="font-semibold text-blue-600">Compass AI</span> + <span className="font-semibold">Kimi K2.5</span>
          </p>
          <p className="text-gray-400 text-xs">
            AI 生成内容仅供参考，不构成投资建议。请在做出投资决定前咨询专业顾问。
          </p>
          <Link
            href="/"
            className="inline-block mt-4 bg-blue-600 hover:bg-blue-700 text-white px-6 py-2.5 rounded-lg text-sm font-medium transition-colors"
          >
            返回首页
          </Link>
        </div>
      </main>
    </div>
  );
}
