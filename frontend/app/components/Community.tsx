export default function Community() {
  const socialLinks = [
    {
      name: '小红书',
      // 小红书官方 logo 占位图（红色背景 + 白色文字）
      logo: 'https://img.icons8.com/color/96/xiaohongshu.png',
      logoFallback: '小红书',
      desc: '布里斯班房产攻略、实地探盘笔记',
      color: 'bg-red-500',
      bgHover: 'hover:bg-red-50',
      url: '#', // 替换为真实小红书链接
      cta: '关注我们',
    },
    {
      name: '抖音',
      // 抖音 logo 占位图
      logo: 'https://img.icons8.com/color/96/tiktok--v1.png',
      logoFallback: '抖音',
      desc: '实拍看房视频、市场分析短视频',
      color: 'bg-black',
      bgHover: 'hover:bg-gray-50',
      url: '#', // 替换为真实抖音链接
      cta: '关注我们',
    },
    {
      name: '微信公众号',
      // 微信 logo 占位图
      logo: 'https://img.icons8.com/color/96/weixing.png',
      logoFallback: '微信',
      desc: '深度投资分析、每周市场报告',
      color: 'bg-green-500',
      bgHover: 'hover:bg-green-50',
      url: '#', // 替换为真实公众号链接
      cta: '扫码关注',
    },
  ];

  return (
    <section className="py-10 md:py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-8 md:mb-12">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-900 mb-2 md:mb-4">
            关注我们
          </h2>
          <p className="text-sm md:text-lg text-gray-600">
            获取最新布里斯班房产投资资讯
          </p>
        </div>

        {/* 手机端：横排紧凑 / 桌面端：三列卡片 */}
        <div className="grid grid-cols-3 md:grid-cols-3 gap-3 md:gap-8">
          {socialLinks.map((social) => (
            <a
              key={social.name}
              href={social.url}
              target="_blank"
              rel="noopener noreferrer"
              className={`bg-white rounded-xl shadow-md p-4 md:p-8 text-center transition-all hover:shadow-lg ${social.bgHover} group`}
            >
              {/* 社媒 Logo */}
              <div className="w-14 h-14 md:w-20 md:h-20 mx-auto mb-3 md:mb-4 rounded-2xl overflow-hidden shadow-lg group-hover:scale-110 transition-transform">
                <img
                  src={social.logo}
                  alt={social.name}
                  className="w-full h-full object-cover"
                  onError={(e) => {
                    // logo 加载失败时显示纯色背景 + 文字
                    const target = e.target as HTMLImageElement;
                    target.style.display = 'none';
                    const parent = target.parentElement;
                    if (parent) {
                      parent.classList.add(social.color, 'flex', 'items-center', 'justify-center');
                      parent.innerHTML = `<span class="text-white font-bold text-sm md:text-lg">${social.logoFallback}</span>`;
                    }
                  }}
                />
              </div>

              {/* 名称 */}
              <h3 className="text-sm md:text-xl font-semibold mb-1 md:mb-3 text-gray-900">
                {social.name}
              </h3>

              {/* 描述 - 仅桌面 */}
              <p className="text-gray-600 mb-4 text-sm hidden md:block">
                {social.desc}
              </p>

              {/* 按钮 - 仅桌面 */}
              <span className="hidden md:inline-block bg-gray-100 group-hover:bg-blue-600 group-hover:text-white text-gray-700 px-6 py-2.5 rounded-lg font-medium transition-colors text-sm">
                {social.cta}
              </span>
            </a>
          ))}
        </div>

        {/* 底部提示 */}
        <p className="text-center text-xs text-gray-400 mt-6 md:mt-10">
          Compass · 布里斯班华人房产投资数据平台
        </p>
      </div>
    </section>
  );
}
