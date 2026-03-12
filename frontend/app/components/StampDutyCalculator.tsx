'use client';

import { useState, useMemo } from 'react';

type BuyerType = 'first_home_new' | 'first_home_existing' | 'investor' | 'foreign';

export default function StampDutyCalculator() {
  const [price, setPrice] = useState(650000);
  const [buyerType, setBuyerType] = useState<BuyerType>('first_home_new');

  const result = useMemo(() => {
    // QLD transfer duty brackets
    let baseDuty = 0;
    if (price <= 5000) {
      baseDuty = 0;
    } else if (price <= 75000) {
      baseDuty = (price - 5000) * 0.015;
    } else if (price <= 540000) {
      baseDuty = 1050 + (price - 75000) * 0.035;
    } else if (price <= 1000000) {
      baseDuty = 17325 + (price - 540000) * 0.045;
    } else {
      baseDuty = 38025 + (price - 1000000) * 0.0575;
    }

    // First home concessions (new builds)
    let concession = 0;
    let concessionLabel = '';
    if (buyerType === 'first_home_new') {
      if (price <= 500000) {
        concession = baseDuty;
        concessionLabel = '首置新房全免';
      } else if (price <= 550000) {
        concession = baseDuty * ((550000 - price) / 50000);
        concessionLabel = '首置新房递减减免';
      }
    }

    // Foreign buyer surcharge (AFAD) = 8% in QLD
    let foreignSurcharge = 0;
    if (buyerType === 'foreign') {
      foreignSurcharge = price * 0.08;
    }

    const finalDuty = Math.max(0, baseDuty - concession) + foreignSurcharge;

    // Registration fee + mortgage registration (approx)
    const transferFee = 250;
    const mortgageFee = 200;
    const totalGovFees = finalDuty + transferFee + mortgageFee;

    return {
      baseDuty: Math.round(baseDuty),
      concession: Math.round(concession),
      foreignSurcharge: Math.round(foreignSurcharge),
      finalDuty: Math.round(finalDuty),
      transferFee,
      mortgageFee,
      totalGovFees: Math.round(totalGovFees),
    };
  }, [price, buyerType]);

  const fmt = (n: number) => `$${n.toLocaleString('en-AU')}`;

  const buyerTypes: { value: BuyerType; label: string; desc: string }[] = [
    { value: 'first_home_new', label: '首置 · 新房', desc: '可享印花税减免' },
    { value: 'first_home_existing', label: '首置 · 二手', desc: '标准税率' },
    { value: 'investor', label: '投资者', desc: '标准税率' },
    { value: 'foreign', label: '海外买家', desc: '+8% AFAD附加税' },
  ];

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      <div className="bg-gradient-to-r from-orange-500 to-orange-600 px-4 md:px-6 py-3 md:py-4">
        <h3 className="text-white font-semibold text-sm md:text-lg flex items-center gap-2">
          📋 印花税计算器
        </h3>
        <p className="text-orange-100 text-[10px] md:text-xs mt-1">QLD Transfer Duty · 含首置减免和海外附加税</p>
      </div>

      <div className="p-4 md:p-6 space-y-4 md:space-y-5">
        {/* Property price */}
        <div>
          <label className="block text-xs md:text-sm font-medium text-gray-700 mb-1 md:mb-2">
            房产价格: <span className="text-orange-600 font-bold">{fmt(price)}</span>
          </label>
          <input
            type="range"
            min="200000"
            max="2000000"
            step="10000"
            value={price}
            onChange={(e) => setPrice(Number(e.target.value))}
            className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-orange-500"
          />
          <div className="flex justify-between text-[10px] md:text-xs text-gray-400 mt-1">
            <span>$200K</span>
            <span>$2M</span>
          </div>
        </div>

        {/* Buyer type */}
        <div>
          <label className="block text-xs md:text-sm font-medium text-gray-700 mb-2">购房者类型</label>
          <div className="grid grid-cols-2 gap-2">
            {buyerTypes.map((bt) => (
              <button
                key={bt.value}
                onClick={() => setBuyerType(bt.value)}
                className={`p-2 md:p-3 rounded-lg border text-left transition-all ${
                  buyerType === bt.value
                    ? 'border-orange-400 bg-orange-50 ring-1 ring-orange-400'
                    : 'border-gray-200 hover:border-orange-300'
                }`}
              >
                <span className="block text-xs md:text-sm font-semibold text-gray-900">{bt.label}</span>
                <span className="block text-[10px] md:text-xs text-gray-500">{bt.desc}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Results */}
        <div className="bg-gray-50 rounded-xl p-3 md:p-5 space-y-2 md:space-y-3">
          <h4 className="font-semibold text-sm md:text-base text-gray-900">📊 费用明细</h4>

          <div className="space-y-1.5 text-xs md:text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">基础印花税 (Transfer Duty)</span>
              <span className="text-gray-900 font-medium">{fmt(result.baseDuty)}</span>
            </div>

            {result.concession > 0 && (
              <div className="flex justify-between text-green-600">
                <span>首置减免 ({result.concession === result.baseDuty ? '全免' : '部分'})</span>
                <span className="font-medium">-{fmt(result.concession)}</span>
              </div>
            )}

            {result.foreignSurcharge > 0 && (
              <div className="flex justify-between text-red-600">
                <span>海外买家附加税 (AFAD 8%)</span>
                <span className="font-medium">+{fmt(result.foreignSurcharge)}</span>
              </div>
            )}

            <div className="flex justify-between">
              <span className="text-gray-600">产权过户费</span>
              <span className="text-gray-900">{fmt(result.transferFee)}</span>
            </div>

            <div className="flex justify-between">
              <span className="text-gray-600">贷款登记费</span>
              <span className="text-gray-900">{fmt(result.mortgageFee)}</span>
            </div>

            <div className="border-t border-gray-200 pt-2 flex justify-between font-bold">
              <span className="text-gray-900">政府总费用</span>
              <span className="text-orange-600 text-sm md:text-base">{fmt(result.totalGovFees)}</span>
            </div>
          </div>
        </div>

        {buyerType === 'foreign' && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-3">
            <p className="text-red-800 text-xs md:text-sm font-medium">
              ⚠️ 海外买家须知
            </p>
            <p className="text-red-700 text-[10px] md:text-xs mt-1">
              QLD 对海外买家征收 8% AFAD 附加税（Additional Foreign Acquirer Duty），此外还需申请 FIRB 审批（费用另计）。
            </p>
          </div>
        )}

        <p className="text-[10px] md:text-xs text-gray-400 text-center">
          * 基于 QLD State Revenue Office 2024-25 税率，仅供参考
        </p>
      </div>
    </div>
  );
}
