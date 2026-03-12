import Link from 'next/link';

export default function QuickEntryCards() {
  return (
    <section className="py-8 md:py-12 bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-2 gap-4 md:gap-6">
          {/* 首次置业 */}
          <Link
            href="/first-home"
            className="group relative bg-white rounded-2xl border border-gray-200 shadow-sm hover:shadow-lg transition-all hover:-translate-y-1 overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-blue-50 to-blue-100/50 opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative p-5 md:p-8 text-center">
              <div className="w-14 h-14 md:w-16 md:h-16 mx-auto mb-3 md:mb-4 bg-blue-100 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg className="w-7 h-7 md:w-8 md:h-8 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
                </svg>
              </div>
              <h3 className="text-base md:text-xl font-bold text-gray-900 mb-1 md:mb-2">首次置业</h3>
              <p className="text-xs md:text-sm text-gray-500 leading-relaxed">
                首置补贴 · 预算计算 · AI顾问
              </p>
            </div>
          </Link>

          {/* 校区找房 */}
          <Link
            href="/school-search"
            className="group relative bg-white rounded-2xl border border-gray-200 shadow-sm hover:shadow-lg transition-all hover:-translate-y-1 overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-emerald-50 to-emerald-100/50 opacity-0 group-hover:opacity-100 transition-opacity" />
            <div className="relative p-5 md:p-8 text-center">
              <div className="w-14 h-14 md:w-16 md:h-16 mx-auto mb-3 md:mb-4 bg-emerald-100 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform">
                <svg className="w-7 h-7 md:w-8 md:h-8 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M4.26 10.147a60.436 60.436 0 00-.491 6.347A48.627 48.627 0 0112 20.904a48.627 48.627 0 018.232-4.41 60.46 60.46 0 00-.491-6.347m-15.482 0a50.57 50.57 0 00-2.658-.813A59.905 59.905 0 0112 3.493a59.902 59.902 0 0110.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.697 50.697 0 0112 13.489a50.702 50.702 0 017.74-3.342M6.75 15a.75.75 0 100-1.5.75.75 0 000 1.5zm0 0v-3.675A55.378 55.378 0 0112 8.443m-7.007 11.55A5.981 5.981 0 006.75 15.75v-1.5" />
                </svg>
              </div>
              <h3 className="text-base md:text-xl font-bold text-gray-900 mb-1 md:mb-2">校区找房</h3>
              <p className="text-xs md:text-sm text-gray-500 leading-relaxed">
                按学区质量寻找投资机会
              </p>
            </div>
          </Link>
        </div>
      </div>
    </section>
  );
}
