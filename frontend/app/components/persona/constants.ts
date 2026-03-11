// ====== 4 位数字人品牌配置 ======

export interface PersonaConfig {
  name: string;
  title: string;
  titleEn: string;
  gradient: string;        // Tailwind gradient classes for avatar bg
  textColor: string;       // Brand accent text color
  bgColor: string;         // Light background for cards
  buttonBg: string;        // Button background
  buttonHover: string;     // Button hover
  avatar: string;          // Image path
  fallbackInitial: string; // Letter for fallback avatar
  bio: string;             // About page bio
  expertise: string[];     // Tag labels for About page
}

export const PERSONAS: Record<string, PersonaConfig> = {
  amanda: {
    name: 'Amanda',
    title: '房产投资分析师',
    titleEn: 'Property Investment Analyst',
    gradient: 'from-blue-500 to-indigo-600',
    textColor: 'text-blue-600',
    bgColor: 'bg-blue-50',
    buttonBg: 'bg-blue-600',
    buttonHover: 'hover:bg-blue-700',
    avatar: '/images/personas/amanda.png',
    fallbackInitial: 'A',
    bio: '拥有超过 10 年布里斯班房产投资顾问经验，专注服务华人投资者。擅长从租赁回报、房价走势、校区质量、治安环境等多维数据中挖掘投资机会，用大白话帮你看懂市场。特别关注南区华人聚集区（Sunnybank、Calamvale、Eight Mile Plains）和北区优质区（Ascot、Hamilton）。',
    expertise: ['投资分析', '学区评估', 'AI 聊天顾问', '海外买家咨询'],
  },
  leo: {
    name: 'Leo',
    title: '捡漏专家',
    titleEn: 'Deal Hunter',
    gradient: 'from-orange-500 to-red-500',
    textColor: 'text-orange-600',
    bgColor: 'bg-orange-50',
    buttonBg: 'bg-orange-500',
    buttonHover: 'hover:bg-orange-600',
    avatar: '/images/personas/leo.png',
    fallbackInitial: 'L',
    bio: '专注发掘被市场低估的房产机会。通过对比售价与中位价、分析土地面积溢价、追踪降价幅度等多重指标，帮你在海量房源中精准锁定高性价比标的。每天刷新数据，第一时间推送捡漏机会。',
    expertise: ['低价房源发现', '折扣分析', '投资回报计算', '土地价值评估'],
  },
  olivia: {
    name: 'Olivia',
    title: '市场经济学家',
    titleEn: 'Market Economist',
    gradient: 'from-purple-500 to-pink-500',
    textColor: 'text-purple-600',
    bgColor: 'bg-purple-50',
    buttonBg: 'bg-purple-600',
    buttonHover: 'hover:bg-purple-700',
    avatar: '/images/personas/olivia.jpg',
    fallbackInitial: 'O',
    bio: '从宏观经济视角解读布里斯班房产市场。每日追踪利率政策、移民趋势、基建规划、供需数据等关键指标，结合实地市场观察，为你提供独到的市场趋势分析和时机判断建议。',
    expertise: ['市场趋势', '每日新闻解读', '利率分析', '宏观经济'],
  },
  ethan: {
    name: 'Ethan',
    title: '数据科学家',
    titleEn: 'Data Scientist',
    gradient: 'from-emerald-500 to-teal-500',
    textColor: 'text-emerald-600',
    bgColor: 'bg-emerald-50',
    buttonBg: 'bg-emerald-600',
    buttonHover: 'hover:bg-emerald-700',
    avatar: '/images/personas/ethan.png',
    fallbackInitial: 'E',
    bio: '运用多维数据建模和算法为每个 Suburb 生成投资评分。整合房价走势、租赁回报、学区质量、治安水平、交通便利度等 8 大维度数据，构建 Compass Score 综合评分体系，用数据驱动投资决策。',
    expertise: ['数据建模', 'Suburb 评分', '多维分析', '可视化'],
  },
};

export type PersonaKey = keyof typeof PERSONAS;

// 8 维数据标签（Ethan 的评分维度）
export const DATA_DIMENSIONS = [
  { key: 'price', emoji: '📈', label: '价格走势' },
  { key: 'poi', emoji: '🏪', label: '华人配套' },
  { key: 'crime', emoji: '🛡️', label: '治安数据' },
  { key: 'transport', emoji: '🚉', label: '公共交通' },
  { key: 'school', emoji: '🏫', label: '学区质量' },
  { key: 'zoning', emoji: '🏘️', label: '土地分区' },
  { key: 'activity', emoji: '📊', label: '市场活跃度' },
  { key: 'ai', emoji: '🤖', label: 'AI 推理' },
] as const;
