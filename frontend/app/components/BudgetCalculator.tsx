'use client';

import { useState, useMemo } from 'react';

export default function BudgetCalculator() {
  const [budget, setBudget] = useState(600000);
  const [deposit, setDeposit] = useState(5); // 百分比
  const [interestRate, setInterestRate] = useState(6.5);
  const [loanTerm, setLoanTerm] = useState(30);
  const [isFirstHome, setIsFirstHome] = useState(true);
  const [isNewBuild, setIsNewBuild] = useState(true);

  const calculations = useMemo(() => {
    const depositAmount = budget * (deposit / 100);
    const loanAmount = budget - depositAmount;

    // 月利率
    const monthlyRate = interestRate / 100 / 12;
    const totalMonths = loanTerm * 12;

    // 月供（等额本息）
    const monthlyPayment = monthlyRate > 0
      ? loanAmount * (monthlyRate * Math.pow(1 + monthlyRate, totalMonths)) / (Math.pow(1 + monthlyRate, totalMonths) - 1)
      : loanAmount / totalMonths;

    // QLD 印花税计算（简化版）
    let stampDuty = 0;
    if (budget <= 5000) {
      stampDuty = 0;
    } else if (budget <= 75000) {
      stampDuty = (budget - 5000) * 0.015;
    } else if (budget <= 540000) {
      stampDuty = 1050 + (budget - 75000) * 0.035;
    } else if (budget <= 1000000) {
      stampDuty = 17325 + (budget - 540000) * 0.045;
    } else {
      stampDuty = 38025 + (budget - 1000000) * 0.0575;
    }

    // 首次置业印花税减免
    let stampDutyDiscount = 0;
    if (isFirstHome && isNewBuild) {
      if (budget <= 500000) {
        stampDutyDiscount = stampDuty; // 全免
      } else if (budget <= 550000) {
        // 递减减免
        stampDutyDiscount = stampDuty * ((550000 - budget) / 50000);
      }
    }

    // FHOG 首次置业补贴
    let fhog = 0;
    if (isFirstHome && isNewBuild && budget <= 750000) {
      fhog = 30000;
    }

    // LMI（当首付<20%时）
    let lmi = 0;
    if (deposit < 20) {
      // 简化 LMI 估算
      const lvr = (100 - deposit) / 100;
      if (lvr > 0.9) {
        lmi = loanAmount * 0.035;
      } else if (lvr > 0.85) {
        lmi = loanAmount * 0.025;
      } else if (lvr > 0.8) {
        lmi = loanAmount * 0.015;
      }
      // 首置担保计划免 LMI
      if (isFirstHome && deposit >= 5) {
        lmi = 0; // 首置担保计划
      }
    }

    const actualStampDuty = Math.max(0, stampDuty - stampDutyDiscount);
    const totalUpfront = depositAmount + actualStampDuty + lmi + 3000; // 3000 for legal fees etc.
    const effectiveBudget = budget - fhog; // 实际需要自筹

    return {
      depositAmount: Math.round(depositAmount),
      loanAmount: Math.round(loanAmount),
      monthlyPayment: Math.round(monthlyPayment),
      weeklyPayment: Math.round(monthlyPayment * 12 / 52),
      stampDuty: Math.round(stampDuty),
      stampDutyDiscount: Math.round(stampDutyDiscount),
      actualStampDuty: Math.round(actualStampDuty),
      fhog,
      lmi: Math.round(lmi),
      totalUpfront: Math.round(totalUpfront),
      effectiveBudget: Math.round(effectiveBudget),
    };
  }, [budget, deposit, interestRate, loanTerm, isFirstHome, isNewBuild]);

  const formatPrice = (n: number) => `$${n.toLocaleString('en-AU')}`;

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      <div className="bg-gradient-to-r from-green-600 to-green-700 px-4 md:px-6 py-3 md:py-4">
        <h3 className="text-white font-semibold text-sm md:text-lg flex items-center gap-2">
          🧮 首次置业预算计算器
        </h3>
        <p className="text-green-100 text-[10px] md:text-xs mt-1">计算首付、月供、印花税及政府补贴</p>
      </div>

      <div className="p-4 md:p-6 space-y-4 md:space-y-6">
        {/* 购房预算 */}
        <div>
          <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1 md:mb-2">
            购房预算: <span className="text-blue-600 font-bold">{formatPrice(budget)}</span>
          </label>
          <input
            type="range"
            min="300000"
            max="1500000"
            step="10000"
            value={budget}
            onChange={(e) => setBudget(Number(e.target.value))}
            className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
          />
          <div className="flex justify-between text-[10px] md:text-xs text-gray-400 mt-1">
            <span>$300K</span>
            <span>$1.5M</span>
          </div>
        </div>

        {/* 首付比例 */}
        <div>
          <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1 md:mb-2">
            首付比例: <span className="text-blue-600 font-bold">{deposit}%</span>
            <span className="text-gray-400 text-[10px] md:text-xs ml-2">({formatPrice(calculations.depositAmount)})</span>
          </label>
          <input
            type="range"
            min="5"
            max="50"
            step="1"
            value={deposit}
            onChange={(e) => setDeposit(Number(e.target.value))}
            className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600"
          />
          <div className="flex justify-between text-[10px] md:text-xs text-gray-400 mt-1">
            <span>5%</span>
            <span>50%</span>
          </div>
        </div>

        {/* 利率和期限 */}
        <div className="grid grid-cols-2 gap-3 md:gap-4">
          <div>
            <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1">利率 (%)</label>
            <input
              type="number"
              value={interestRate}
              onChange={(e) => setInterestRate(Number(e.target.value))}
              step="0.1"
              min="1"
              max="15"
              className="w-full px-3 py-2 rounded-lg border border-gray-300 text-xs md:text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1">贷款年限</label>
            <select
              value={loanTerm}
              onChange={(e) => setLoanTerm(Number(e.target.value))}
              className="w-full px-3 py-2 rounded-lg border border-gray-300 text-xs md:text-sm text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value={25}>25年</option>
              <option value={30}>30年</option>
            </select>
          </div>
        </div>

        {/* 首置选项 */}
        <div className="flex flex-col md:flex-row gap-3 md:gap-6">
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={isFirstHome}
              onChange={(e) => setIsFirstHome(e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500"
            />
            <span className="text-xs md:text-sm text-gray-700">首次购房</span>
          </label>
          <label className="flex items-center gap-2 cursor-pointer">
            <input
              type="checkbox"
              checked={isNewBuild}
              onChange={(e) => setIsNewBuild(e.target.checked)}
              className="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500"
            />
            <span className="text-xs md:text-sm text-gray-700">购买新房</span>
          </label>
        </div>

        {/* 计算结果 */}
        <div className="bg-gray-50 rounded-xl p-3 md:p-5 space-y-3">
          <h4 className="font-semibold text-sm md:text-base text-gray-900 mb-3">📊 费用明细</h4>

          <div className="grid grid-cols-2 gap-2 md:gap-3">
            <div className="bg-white rounded-lg p-2 md:p-3 border border-gray-100">
              <p className="text-[10px] md:text-xs text-gray-500">月供</p>
              <p className="text-sm md:text-lg font-bold text-blue-600">{formatPrice(calculations.monthlyPayment)}</p>
              <p className="text-[10px] text-gray-400">周供 {formatPrice(calculations.weeklyPayment)}</p>
            </div>
            <div className="bg-white rounded-lg p-2 md:p-3 border border-gray-100">
              <p className="text-[10px] md:text-xs text-gray-500">贷款总额</p>
              <p className="text-sm md:text-lg font-bold text-gray-900">{formatPrice(calculations.loanAmount)}</p>
            </div>
          </div>

          <div className="space-y-1.5 md:space-y-2 text-xs md:text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">印花税</span>
              <span className="text-gray-900">
                {calculations.stampDutyDiscount > 0 ? (
                  <>
                    <span className="line-through text-gray-400 mr-2">{formatPrice(calculations.stampDuty)}</span>
                    <span className="text-green-600 font-medium">{formatPrice(calculations.actualStampDuty)}</span>
                  </>
                ) : (
                  formatPrice(calculations.stampDuty)
                )}
              </span>
            </div>
            {calculations.stampDutyDiscount > 0 && (
              <div className="flex justify-between text-green-600">
                <span>印花税减免</span>
                <span className="font-medium">-{formatPrice(calculations.stampDutyDiscount)}</span>
              </div>
            )}
            {calculations.fhog > 0 && (
              <div className="flex justify-between text-green-600">
                <span>🎁 首次置业补贴 (FHOG)</span>
                <span className="font-bold">{formatPrice(calculations.fhog)}</span>
              </div>
            )}
            {calculations.lmi > 0 ? (
              <div className="flex justify-between">
                <span className="text-gray-600">LMI 贷款保险</span>
                <span className="text-orange-600">{formatPrice(calculations.lmi)}</span>
              </div>
            ) : deposit < 20 && isFirstHome ? (
              <div className="flex justify-between text-green-600">
                <span>LMI 贷款保险</span>
                <span className="font-medium">$0 (首置担保免)</span>
              </div>
            ) : null}
            <div className="flex justify-between">
              <span className="text-gray-600">法律/验房费用（估）</span>
              <span className="text-gray-900">$3,000</span>
            </div>
            <div className="border-t border-gray-200 pt-2 flex justify-between font-bold">
              <span className="text-gray-900">总前期费用</span>
              <span className="text-blue-600 text-sm md:text-base">{formatPrice(calculations.totalUpfront)}</span>
            </div>
          </div>
        </div>

        {/* 补贴提示 */}
        {isFirstHome && isNewBuild && budget <= 750000 && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-3 md:p-4">
            <p className="text-green-800 text-xs md:text-sm font-medium flex items-center gap-1">
              🎉 恭喜！您符合以下补贴条件：
            </p>
            <ul className="text-green-700 text-[10px] md:text-xs mt-2 space-y-1">
              <li>✅ QLD 首次置业补贴 $30,000</li>
              {budget <= 500000 && <li>✅ 印花税全免（节省 {formatPrice(calculations.stampDuty)}）</li>}
              {budget > 500000 && budget <= 550000 && <li>✅ 印花税部分减免（节省 {formatPrice(calculations.stampDutyDiscount)}）</li>}
              {deposit >= 5 && deposit < 20 && <li>✅ 首置担保计划（5%首付免LMI）</li>}
            </ul>
          </div>
        )}

        <p className="text-[10px] md:text-xs text-gray-400 text-center">
          * 以上计算仅供参考，实际费用请咨询贷款经纪人。利率为浮动利率估算。
        </p>
      </div>
    </div>
  );
}
