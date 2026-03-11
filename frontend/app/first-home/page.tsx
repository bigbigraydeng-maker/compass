'use client';

import Header from '../components/Header';
import Footer from '../components/Footer';
import ChatInterface from '../components/ChatInterface';
import BudgetCalculator from '../components/BudgetCalculator';

export default function FirstHomePage() {
  // 购房步骤
  const steps = [
    {
      step: 1,
      title: '评估预算',
      desc: '确定首付能力、月供承受范围，了解政府补贴',
      icon: '💰',
      detail: '建议月供不超过家庭收入的30%',
    },
    {
      step: 2,
      title: '贷款预批',
      desc: '联系银行或贷款经纪人，获取预批信',
      icon: '🏦',
      detail: '预批有效期通常为3-6个月',
    },
    {
      step: 3,
      title: '找房看房',
      desc: '使用 Compass 搜索适合的 Suburb 和房源',
      icon: '🔍',
      detail: '建议至少看20套以上再做决定',
    },
    {
      step: 4,
      title: '签约交换',
      desc: '委托律师审核合同，支付定金（通常5-10%）',
      icon: '📝',
      detail: 'QLD 有5个工作日冷静期',
    },
    {
      step: 5,
      title: '交割入住',
      desc: '完成验房、贷款放款、过户登记',
      icon: '🏠',
      detail: '交割通常在签约后30-90天',
    },
  ];

  // 政府补贴
  const grants = [
    {
      title: 'QLD 首次置业补贴',
      amount: '$30,000',
      desc: '购买全新住宅或大翻新房产',
      conditions: ['房价 ≤ $750,000', '全新住宅或重大翻新', '首次在澳购房', '年满18岁'],
      color: 'from-green-500 to-green-600',
      icon: '🎁',
    },
    {
      title: '印花税减免',
      amount: '最高免除',
      desc: '首次购房者印花税优惠',
      conditions: ['新房≤$500,000 全免', '$500K-$550K 递减', '仅限首次购房者', '用作自住房'],
      color: 'from-blue-500 to-blue-600',
      icon: '📋',
    },
    {
      title: '首置担保计划',
      amount: '5%首付',
      desc: '仅需5%首付，免LMI贷款保险',
      conditions: ['年收入≤$125K(单人)', '夫妻≤$200K', '房价限额(地区不同)', '需申请名额'],
      color: 'from-purple-500 to-purple-600',
      icon: '🛡️',
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />

      {/* Hero 横幅 */}
      <section className="relative bg-gradient-to-r from-blue-700 to-blue-900 text-white py-12 md:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-2xl md:text-4xl font-bold mb-3 md:mb-4">🏠 首次置业指南</h1>
          <p className="text-sm md:text-xl text-blue-100 max-w-2xl mx-auto">
            助您迈入布里斯班房产市场 · 最高可获 $30,000 政府补贴
          </p>
        </div>
      </section>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 md:py-12">
        {/* Section 1: 购房步骤 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            📋 首次购房 5 步流程
          </h2>

          {/* 手机端：竖向时间线 */}
          <div className="md:hidden space-y-4">
            {steps.map((s, i) => (
              <div key={s.step} className="flex gap-3">
                <div className="flex flex-col items-center">
                  <div className="w-8 h-8 bg-blue-600 text-white rounded-full flex items-center justify-center text-sm font-bold">
                    {s.step}
                  </div>
                  {i < steps.length - 1 && <div className="w-0.5 flex-1 bg-blue-200 my-1" />}
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

          {/* 桌面端：横向时间线 */}
          <div className="hidden md:flex items-start justify-between relative">
            {/* 连接线 */}
            <div className="absolute top-8 left-[10%] right-[10%] h-0.5 bg-blue-200" />
            {steps.map((s) => (
              <div key={s.step} className="flex flex-col items-center text-center w-1/5 relative z-10">
                <div className="w-16 h-16 bg-blue-600 text-white rounded-full flex items-center justify-center text-2xl mb-4 shadow-lg">
                  {s.icon}
                </div>
                <h3 className="font-bold text-gray-900 mb-1">{s.title}</h3>
                <p className="text-sm text-gray-600 mb-1">{s.desc}</p>
                <p className="text-xs text-gray-400">💡 {s.detail}</p>
              </div>
            ))}
          </div>
        </section>

        {/* Section 2: 政府补贴卡片 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            🎁 政府补贴与优惠
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 md:gap-6">
            {grants.map((g) => (
              <div key={g.title} className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
                <div className={`bg-gradient-to-r ${g.color} p-4 md:p-6 text-white`}>
                  <div className="text-2xl md:text-3xl mb-2">{g.icon}</div>
                  <h3 className="font-bold text-sm md:text-lg">{g.title}</h3>
                  <p className="text-2xl md:text-3xl font-bold mt-1">{g.amount}</p>
                  <p className="text-white/80 text-xs md:text-sm mt-1">{g.desc}</p>
                </div>
                <div className="p-4 md:p-5">
                  <p className="text-xs md:text-sm font-medium text-gray-700 mb-2">申请条件：</p>
                  <ul className="space-y-1.5">
                    {g.conditions.map((c, i) => (
                      <li key={i} className="flex items-start gap-2 text-xs md:text-sm text-gray-600">
                        <span className="text-green-500 mt-0.5">✓</span>
                        {c}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* Section 3 & 4: 预算计算器 + AI 顾问 */}
        <section className="mb-10 md:mb-16">
          <h2 className="text-xl md:text-2xl font-bold text-gray-900 mb-6 md:mb-8 text-center">
            🛠️ 实用工具
          </h2>
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 md:gap-8">
            <BudgetCalculator />
            <ChatInterface context="first_home" />
          </div>
        </section>

        {/* Section 5: 微信咨询 CTA */}
        <section className="mb-10 md:mb-16">
          <div className="bg-gradient-to-r from-green-500 to-green-600 rounded-2xl p-6 md:p-10 text-white text-center">
            <h2 className="text-xl md:text-2xl font-bold mb-3 md:mb-4">💬 需要更多帮助？</h2>
            <p className="text-sm md:text-lg text-green-100 mb-4 md:mb-6 max-w-xl mx-auto">
              添加我们的微信顾问，获取一对一的首次置业咨询服务
            </p>
            <div className="inline-flex items-center gap-3 bg-white/20 backdrop-blur-sm rounded-xl px-6 py-4 border border-white/30">
              <div className="w-16 h-16 md:w-24 md:h-24 bg-white rounded-lg flex items-center justify-center">
                <span className="text-gray-400 text-xs md:text-sm text-center">微信二维码<br/>占位</span>
              </div>
              <div className="text-left">
                <p className="font-semibold text-sm md:text-base">Compass 置业顾问</p>
                <p className="text-green-100 text-xs md:text-sm">微信号: compass_brisbane</p>
                <p className="text-green-200 text-[10px] md:text-xs mt-1">工作日 9:00-18:00 在线</p>
              </div>
            </div>
          </div>
        </section>
      </div>

      <Footer />
    </div>
  );
}
