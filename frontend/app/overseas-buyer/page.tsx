'use client';

import Header from '../components/Header';
import Footer from '../components/Footer';
import ChatInterface from '../components/ChatInterface';
import Link from 'next/link';

export default function OverseasBuyerPage() {
  // 购房流程
  const steps = [
    {
      step: 1,
      title: 'FIRB 审批',
      desc: '向外国投资审查委员会申请购房许可',
      icon: '📋',
      detail: '费用约$14,100-$28,200，审批约30天',
    },
    {
      step: 2,
      title: '选择新房',
      desc: '海外人士只能购买全新住宅或空地',
      icon: '🏗️',
      detail: '不能购买二手房（有少数例外）',
    },
    {
      step: 3,
      title: '聘请律师',
      desc: '委托澳洲持牌律师审核合同',
      icon: '⚖️',
      detail: '建议选择熟悉海外买家的律师',
    },
    {
      step: 4,
      title: '签约付款',
      desc: '签署购房合同，支付10%定金',
      icon: '📝',
      detail: '定金存入律师信托账户',
    },
    {
      step: 5,
      title: '交割过户',
      desc: '贷款放款、完成过户登记',
      icon: '🏠',
      detail: '期房交割可能在1-3年后',
    },
    {
      step: 6,
      title: '税务申报',
      desc: '澳洲税号、租金收入申报、CGT',
      icon: '📊',
      detail: '建议聘请专业会计师',
    },
  ];

  // 关键须知
  const keyFacts = [
    {
      title: 'FIRB 审批费用',
      items: [
        { label: '房价 < $75万', value: '约 $14,100' },
        { label: '房价 $75万-$100万', value: '约 $28,200' },
        { label: '房价 $100万-$200万', value: '约 $56,400' },
      ],
      icon: '💼',
      color: 'bg-blue-50 border-blue-200',
      iconBg: 'bg-blue-100',
    },
    {
      title: '额外印花税 (AFAD)',
      items: [
        { label: '昆士兰州附加费', value: '8%' },
        { label: '60万房产额外', value: '$48,000' },
        { label: '100万房产额外', value: '$80,000' },
      ],
      icon: '🏛️',
      color: 'bg-red-50 border-red-200',
      iconBg: 'bg-red-100',
    },
    {
      title: '购房限制',
      items: [
        { label: '只能买', value: '全新住宅' },
        { label: '不能买', value: '二手房' },
        { label: '可以买', value: '空地（2年内建房）' },
      ],
      icon: '⚠️',
      color: 'bg-yellow-50 border-yellow-200',
      iconBg: 'bg-yellow-100',
    },
    {
      title: 'CGT 预扣税',
      items: [
        { label: '出售时预扣', value: '12.5%' },
        { label: '适用条件', value: '房价 > $75万' },
        { label: '可申请减免', value: '如有澳洲税号' },
      ],
      icon: '📊',
      color: 'bg-purple-50 border-purple-200',
      iconBg: 'bg-purple-100',
    },
  ];

  // 推荐 Suburbs
  const recommendedSuburbs = [
    { name: 'Rochedale', reason: '大量新开发项目，适合海外投资', type: '新房+空地' },
    { name: 'Eight Mile Plains', reason: '华人社区成熟，交通便利', type: '新公寓' },
    { name: 'Calamvale', reason: '性价比高，学区好', type: '新联排' },
    { name: 'Hamilton', reason: '高端滨水区，资本增值潜力大', type: '新公寓' },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />

      {/* Hero 横幅 */}
      <section className="relative bg-gradient-to-r from-purple-700 to-purple-900 text-white py-12 md:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-2xl md:text-4xl font-bold mb-3 md:mb-4">🌏 海外人士购房指南</h1>
          <p className="text-sm md:text-xl text-purple-100 max-w-2xl mx-auto">
            布里斯班投资全攻略 · FIRB指南 · 税费详解 · AI智能顾问
          </p>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 md:py-12">
        {/* Section 1: 购房流程 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            📋 海外人士购房 6 步流程
          </h2>

          {/* 手机端 */}
          <div className="md:hidden space-y-4">
            {steps.map((s, i) => (
              <div key={s.step} className="flex gap-3">
                <div className="flex flex-col items-center">
                  <div className="w-8 h-8 bg-purple-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                    {s.step}
                  </div>
                  {i < steps.length - 1 && <div className="w-0.5 flex-1 bg-purple-200 my-1" />}
                </div>
                <div className="bg-white rounded-xl p-3 shadow-sm border border-gray-100 flex-1 mb-1">
                  <div className="flex items-center gap-2 mb-1">
                    <span className="text-lg">{s.icon}</span>
                    <h3 className="font-semibold text-sm text-gray-900">{s.title}</h3>
                  </div>
                  <p className="text-xs text-gray-600">{s.desc}</p>
                  <p className="text-[10px] text-gray-400 mt-1">💡 {s.detail}</p>
                </div>
              </div>
            ))}
          </div>

          {/* 桌面端 */}
          <div className="hidden md:grid grid-cols-3 gap-6">
            {steps.map((s) => (
              <div key={s.step} className="bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-10 h-10 bg-purple-600 text-white rounded-full flex items-center justify-center font-bold">
                    {s.step}
                  </div>
                  <span className="text-2xl">{s.icon}</span>
                </div>
                <h3 className="font-bold text-gray-900 mb-2">{s.title}</h3>
                <p className="text-sm text-gray-600 mb-2">{s.desc}</p>
                <p className="text-xs text-gray-400">💡 {s.detail}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Section 2: 关键须知 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            ⚠️ 关键须知
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
            {keyFacts.map((fact) => (
              <div key={fact.title} className={`rounded-xl p-4 md:p-6 border ${fact.color}`}>
                <div className="flex items-center gap-2 md:gap-3 mb-3 md:mb-4">
                  <div className={`w-8 h-8 md:w-10 md:h-10 ${fact.iconBg} rounded-full flex items-center justify-center text-lg md:text-xl`}>
                    {fact.icon}
                  </div>
                  <h3 className="font-bold text-sm md:text-base text-gray-900">{fact.title}</h3>
                </div>
                <div className="space-y-2">
                  {fact.items.map((item, i) => (
                    <div key={i} className="flex justify-between items-center">
                      <span className="text-xs md:text-sm text-gray-600">{item.label}</span>
                      <span className="text-xs md:text-sm font-bold text-gray-900">{item.value}</span>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Section 3: 推荐 Suburbs */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            🏘️ 推荐投资 Suburbs
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
            {recommendedSuburbs.map((sub) => (
              <Link
                key={sub.name}
                href={`/suburb/${encodeURIComponent(sub.name)}`}
                className="bg-white rounded-xl p-4 md:p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-purple-200 transition-all group"
              >
                <h3 className="font-bold text-gray-900 group-hover:text-purple-600 transition-colors mb-2">
                  {sub.name}
                </h3>
                <p className="text-xs md:text-sm text-gray-600 mb-2">{sub.reason}</p>
                <span className="inline-block text-[10px] md:text-xs bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full">
                  {sub.type}
                </span>
              </Link>
            ))}
          </div>
        </section>

        {/* Section 4: AI 顾问 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            🤖 Amanda · 海外购房顾问
          </h2>
          <div className="max-w-2xl mx-auto">
            <ChatInterface context="overseas" />
          </div>
        </section>

        {/* Section 5: 微信咨询 CTA */}
        <section className="mb-10 md:mb-16">
          <div className="bg-gradient-to-r from-purple-500 to-purple-600 rounded-2xl p-6 md:p-10 text-white text-center">
            <h2 className="text-xl md:text-2xl font-bold mb-3 md:mb-4">💬 专属海外投资顾问</h2>
            <p className="text-sm md:text-lg text-purple-100 mb-4 md:mb-6 max-w-xl mx-auto">
              我们的顾问团队熟悉 FIRB 流程，可用中文全程协助您在布里斯班购房投资
            </p>
            <div className="inline-flex items-center gap-3 bg-white/20 backdrop-blur-sm rounded-xl px-6 py-4 border border-white/30">
              <div className="w-16 h-16 md:w-24 md:h-24 bg-white rounded-lg flex items-center justify-center">
                <span className="text-gray-400 text-xs md:text-sm text-center">微信二维码<br/>占位</span>
              </div>
              <div className="text-left">
                <p className="font-semibold text-sm md:text-base">Compass 海外投资顾问</p>
                <p className="text-purple-100 text-xs md:text-sm">微信号: compass_overseas</p>
                <p className="text-purple-200 text-[10px] md:text-xs mt-1">支持中英文 · 全球时区服务</p>
              </div>
            </div>
          </div>
        </section>
      </div>

      <Footer />
    </div>
  );
}
