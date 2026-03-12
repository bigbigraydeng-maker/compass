'use client';

import { useState, useMemo } from 'react';

interface Scenario {
  label: string;
  rate: number;
  term: number;
}

export default function MortgageComparison() {
  const [loanAmount, setLoanAmount] = useState(500000);
  const [scenarios, setScenarios] = useState<Scenario[]>([
    { label: '当前利率', rate: 6.5, term: 30 },
    { label: '低利率', rate: 5.5, term: 30 },
    { label: '短期贷款', rate: 6.5, term: 25 },
  ]);

  const results = useMemo(() => {
    return scenarios.map((s) => {
      const monthlyRate = s.rate / 100 / 12;
      const totalMonths = s.term * 12;
      const monthlyPayment = monthlyRate > 0
        ? loanAmount * (monthlyRate * Math.pow(1 + monthlyRate, totalMonths)) / (Math.pow(1 + monthlyRate, totalMonths) - 1)
        : loanAmount / totalMonths;
      const totalPayment = monthlyPayment * totalMonths;
      const totalInterest = totalPayment - loanAmount;
      return {
        ...s,
        monthlyPayment: Math.round(monthlyPayment),
        weeklyPayment: Math.round(monthlyPayment * 12 / 52),
        totalInterest: Math.round(totalInterest),
        totalPayment: Math.round(totalPayment),
      };
    });
  }, [loanAmount, scenarios]);

  const fmt = (n: number) => `$${n.toLocaleString('en-AU')}`;

  const updateScenario = (index: number, field: keyof Scenario, value: string | number) => {
    setScenarios(prev => prev.map((s, i) => i === index ? { ...s, [field]: value } : s));
  };

  // Find best scenario (lowest total interest)
  const bestIdx = results.reduce((best, r, i) => r.totalInterest < results[best].totalInterest ? i : best, 0);

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      <div className="bg-gradient-to-r from-purple-600 to-purple-700 px-4 md:px-6 py-3 md:py-4">
        <h3 className="text-white font-semibold text-sm md:text-lg flex items-center gap-2">
          📊 月供对比器
        </h3>
        <p className="text-purple-100 text-[10px] md:text-xs mt-1">对比不同利率和贷款年限的月供差异</p>
      </div>

      <div className="p-4 md:p-6 space-y-4 md:space-y-5">
        {/* Loan amount */}
        <div>
          <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1 md:mb-2">
            贷款金额: <span className="text-purple-600 font-bold">{fmt(loanAmount)}</span>
          </label>
          <input
            type="range"
            min="100000"
            max="1500000"
            step="10000"
            value={loanAmount}
            onChange={(e) => setLoanAmount(Number(e.target.value))}
            className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-purple-500"
          />
          <div className="flex justify-between text-[10px] md:text-xs text-gray-400 mt-1">
            <span>$100K</span>
            <span>$1.5M</span>
          </div>
        </div>

        {/* Scenario inputs */}
        <div className="space-y-2">
          {scenarios.map((s, i) => (
            <div key={i} className={`flex items-center gap-2 md:gap-3 p-2 md:p-3 rounded-lg border ${i === bestIdx ? 'border-purple-300 bg-purple-50' : 'border-gray-200'}`}>
              <input
                type="text"
                value={s.label}
                onChange={(e) => updateScenario(i, 'label', e.target.value)}
                className="w-20 md:w-24 text-xs md:text-sm font-medium text-gray-900 bg-transparent focus:outline-none truncate"
              />
              <div className="flex items-center gap-1">
                <input
                  type="number"
                  value={s.rate}
                  onChange={(e) => updateScenario(i, 'rate', Number(e.target.value))}
                  step="0.1"
                  min="1"
                  max="15"
                  className="w-14 md:w-16 px-2 py-1 rounded border border-gray-300 text-xs md:text-sm text-gray-900 text-center focus:outline-none focus:ring-1 focus:ring-purple-500"
                />
                <span className="text-xs text-gray-400">%</span>
              </div>
              <div className="flex items-center gap-1">
                <select
                  value={s.term}
                  onChange={(e) => updateScenario(i, 'term', Number(e.target.value))}
                  className="px-2 py-1 rounded border border-gray-300 text-xs md:text-sm text-gray-900 focus:outline-none focus:ring-1 focus:ring-purple-500"
                >
                  <option value={20}>20年</option>
                  <option value={25}>25年</option>
                  <option value={30}>30年</option>
                </select>
              </div>
              {i === bestIdx && (
                <span className="text-[10px] font-medium text-purple-600 bg-purple-100 px-1.5 py-0.5 rounded-full ml-auto whitespace-nowrap">
                  最优
                </span>
              )}
            </div>
          ))}
        </div>

        {/* Comparison table */}
        <div className="bg-gray-50 rounded-xl overflow-hidden">
          <table className="w-full text-xs md:text-sm">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left p-2 md:p-3 text-gray-500 font-medium">方案</th>
                <th className="text-right p-2 md:p-3 text-gray-500 font-medium">月供</th>
                <th className="text-right p-2 md:p-3 text-gray-500 font-medium hidden md:table-cell">周供</th>
                <th className="text-right p-2 md:p-3 text-gray-500 font-medium">总利息</th>
              </tr>
            </thead>
            <tbody>
              {results.map((r, i) => (
                <tr key={i} className={`border-b border-gray-100 ${i === bestIdx ? 'bg-purple-50' : ''}`}>
                  <td className="p-2 md:p-3">
                    <span className="font-medium text-gray-900">{r.label}</span>
                    <span className="block text-[10px] text-gray-400">{r.rate}% / {r.term}年</span>
                  </td>
                  <td className="p-2 md:p-3 text-right font-bold text-gray-900">{fmt(r.monthlyPayment)}</td>
                  <td className="p-2 md:p-3 text-right text-gray-600 hidden md:table-cell">{fmt(r.weeklyPayment)}</td>
                  <td className="p-2 md:p-3 text-right">
                    <span className={`font-bold ${i === bestIdx ? 'text-purple-600' : 'text-gray-900'}`}>
                      {fmt(r.totalInterest)}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Savings highlight */}
        {results.length > 1 && (
          <div className="bg-purple-50 border border-purple-200 rounded-lg p-3">
            <p className="text-purple-800 text-xs md:text-sm">
              💡 选择「{results[bestIdx].label}」方案，相比最高方案可节省利息{' '}
              <span className="font-bold">
                {fmt(Math.max(...results.map(r => r.totalInterest)) - results[bestIdx].totalInterest)}
              </span>
            </p>
          </div>
        )}

        <p className="text-[10px] md:text-xs text-gray-400 text-center">
          * 等额本息还款方式，实际利率以银行批复为准
        </p>
      </div>
    </div>
  );
}
