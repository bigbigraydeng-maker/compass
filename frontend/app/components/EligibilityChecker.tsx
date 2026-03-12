'use client';

import { useState } from 'react';

interface EligibilityResult {
  fhog: boolean;
  fhogAmount: number;
  stampDutyExemption: 'full' | 'partial' | 'none';
  stampDutyNote: string;
  guaranteeScheme: boolean;
  guaranteeNote: string;
}

export default function EligibilityChecker() {
  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState({
    citizenship: '', // 'citizen', 'pr', 'other'
    firstHome: '', // 'yes', 'no'
    propertyType: '', // 'new', 'existing'
    priceRange: '', // 'under500', '500to550', '550to750', 'over750'
  });
  const [result, setResult] = useState<EligibilityResult | null>(null);

  const questions = [
    {
      key: 'citizenship' as const,
      question: '您的身份是？',
      options: [
        { value: 'citizen', label: '🇦🇺 澳洲公民', desc: '出生或入籍' },
        { value: 'pr', label: '🛂 永久居民 (PR)', desc: '持有PR签证' },
        { value: 'other', label: '🌏 其他签证', desc: '临时签证/海外人士' },
      ],
    },
    {
      key: 'firstHome' as const,
      question: '您是否首次在澳购房？',
      options: [
        { value: 'yes', label: '✅ 是，首次购房', desc: '从未在澳洲拥有过房产' },
        { value: 'no', label: '❌ 否，已购过房', desc: '曾经拥有澳洲房产' },
      ],
    },
    {
      key: 'propertyType' as const,
      question: '您计划购买哪种房产？',
      options: [
        { value: 'new', label: '🏗️ 全新住宅', desc: '新建房/楼花/大翻新' },
        { value: 'existing', label: '🏠 二手房', desc: '已有住宅' },
      ],
    },
    {
      key: 'priceRange' as const,
      question: '预计购房价格范围？',
      options: [
        { value: 'under500', label: '$500K 以下', desc: '≤ $500,000' },
        { value: '500to550', label: '$500K - $550K', desc: '$500,001 - $550,000' },
        { value: '550to750', label: '$550K - $750K', desc: '$550,001 - $750,000' },
        { value: 'over750', label: '$750K 以上', desc: '> $750,000' },
      ],
    },
  ];

  const handleAnswer = (key: keyof typeof answers, value: string) => {
    const newAnswers = { ...answers, [key]: value };
    setAnswers(newAnswers);

    if (step < questions.length - 1) {
      setStep(step + 1);
    } else {
      // Calculate result
      calculateResult(newAnswers);
    }
  };

  const calculateResult = (a: typeof answers) => {
    const isEligiblePerson = (a.citizenship === 'citizen' || a.citizenship === 'pr') && a.firstHome === 'yes';
    const isNewBuild = a.propertyType === 'new';

    // FHOG: $30,000 for new builds ≤ $750K, first home, citizen/PR
    const fhog = isEligiblePerson && isNewBuild && a.priceRange !== 'over750';
    const fhogAmount = fhog ? 30000 : 0;

    // Stamp Duty: full exemption for new builds ≤$500K, partial $500-550K
    let stampDutyExemption: 'full' | 'partial' | 'none' = 'none';
    let stampDutyNote = '不符合印花税减免条件';
    if (isEligiblePerson && isNewBuild) {
      if (a.priceRange === 'under500') {
        stampDutyExemption = 'full';
        stampDutyNote = '新房≤$500K，印花税全免！';
      } else if (a.priceRange === '500to550') {
        stampDutyExemption = 'partial';
        stampDutyNote = '$500K-$550K 区间，印花税递减减免';
      }
    }

    // First Home Guarantee: 5% deposit, no LMI
    const guaranteeScheme = isEligiblePerson;
    const guaranteeNote = guaranteeScheme
      ? '符合首置担保计划，仅需5%首付，免LMI'
      : '不符合首置担保计划';

    setResult({ fhog, fhogAmount, stampDutyExemption, stampDutyNote, guaranteeScheme, guaranteeNote });
  };

  const reset = () => {
    setStep(0);
    setAnswers({ citizenship: '', firstHome: '', propertyType: '', priceRange: '' });
    setResult(null);
  };

  const currentQ = questions[step];

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-4 md:px-6 py-3 md:py-4">
        <h3 className="text-white font-semibold text-sm md:text-lg flex items-center gap-2">
          🔍 首置资格速查
        </h3>
        <p className="text-blue-100 text-[10px] md:text-xs mt-1">4 个问题，快速判断您可获得的补贴</p>
      </div>

      <div className="p-4 md:p-6">
        {!result ? (
          <>
            {/* Progress bar */}
            <div className="flex gap-1.5 mb-5">
              {questions.map((_, i) => (
                <div
                  key={i}
                  className={`h-1.5 flex-1 rounded-full transition-colors ${
                    i <= step ? 'bg-blue-500' : 'bg-gray-200'
                  }`}
                />
              ))}
            </div>

            {/* Question */}
            <p className="text-xs text-gray-400 mb-1">问题 {step + 1} / {questions.length}</p>
            <h4 className="text-sm md:text-base font-bold text-gray-900 mb-4">{currentQ.question}</h4>

            {/* Options */}
            <div className="space-y-2">
              {currentQ.options.map((opt) => (
                <button
                  key={opt.value}
                  onClick={() => handleAnswer(currentQ.key, opt.value)}
                  className="w-full text-left p-3 md:p-4 rounded-xl border border-gray-200 hover:border-blue-400 hover:bg-blue-50 transition-all group"
                >
                  <span className="font-semibold text-sm text-gray-900 group-hover:text-blue-700">{opt.label}</span>
                  <span className="block text-xs text-gray-500 mt-0.5">{opt.desc}</span>
                </button>
              ))}
            </div>

            {/* Back button */}
            {step > 0 && (
              <button
                onClick={() => setStep(step - 1)}
                className="mt-4 text-xs text-gray-400 hover:text-gray-600 transition-colors"
              >
                ← 上一步
              </button>
            )}
          </>
        ) : (
          /* Result */
          <div className="space-y-3">
            <h4 className="text-sm md:text-base font-bold text-gray-900 mb-4">📋 您的资格评估结果</h4>

            {/* FHOG */}
            <div className={`rounded-xl p-3 md:p-4 border ${result.fhog ? 'bg-green-50 border-green-200' : 'bg-gray-50 border-gray-200'}`}>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-semibold text-sm text-gray-900">QLD 首次置业补贴 (FHOG)</p>
                  <p className="text-xs text-gray-500 mt-0.5">购买全新住宅的现金补贴</p>
                </div>
                {result.fhog ? (
                  <span className="text-lg md:text-xl font-bold text-green-600">$30,000</span>
                ) : (
                  <span className="text-sm font-medium text-gray-400">不符合</span>
                )}
              </div>
            </div>

            {/* Stamp Duty */}
            <div className={`rounded-xl p-3 md:p-4 border ${result.stampDutyExemption !== 'none' ? 'bg-green-50 border-green-200' : 'bg-gray-50 border-gray-200'}`}>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-semibold text-sm text-gray-900">印花税减免</p>
                  <p className="text-xs text-gray-500 mt-0.5">{result.stampDutyNote}</p>
                </div>
                {result.stampDutyExemption === 'full' ? (
                  <span className="text-sm font-bold text-green-600 bg-green-100 px-2 py-1 rounded-lg">全免</span>
                ) : result.stampDutyExemption === 'partial' ? (
                  <span className="text-sm font-bold text-amber-600 bg-amber-100 px-2 py-1 rounded-lg">部分减免</span>
                ) : (
                  <span className="text-sm font-medium text-gray-400">不符合</span>
                )}
              </div>
            </div>

            {/* Guarantee Scheme */}
            <div className={`rounded-xl p-3 md:p-4 border ${result.guaranteeScheme ? 'bg-green-50 border-green-200' : 'bg-gray-50 border-gray-200'}`}>
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-semibold text-sm text-gray-900">首置担保计划</p>
                  <p className="text-xs text-gray-500 mt-0.5">{result.guaranteeNote}</p>
                </div>
                {result.guaranteeScheme ? (
                  <span className="text-sm font-bold text-green-600 bg-green-100 px-2 py-1 rounded-lg">符合</span>
                ) : (
                  <span className="text-sm font-medium text-gray-400">不符合</span>
                )}
              </div>
            </div>

            {/* Summary */}
            {(result.fhog || result.stampDutyExemption !== 'none' || result.guaranteeScheme) && (
              <div className="bg-blue-50 border border-blue-200 rounded-xl p-3 md:p-4 mt-2">
                <p className="text-blue-800 text-xs md:text-sm font-medium">
                  🎉 恭喜！您可能节省的总金额：
                </p>
                <p className="text-blue-900 text-lg md:text-xl font-bold mt-1">
                  ${(result.fhogAmount).toLocaleString('en-AU')}+
                </p>
                <p className="text-blue-600 text-[10px] md:text-xs mt-1">
                  {result.fhog && '✅ FHOG $30,000  '}
                  {result.stampDutyExemption !== 'none' && '✅ 印花税减免  '}
                  {result.guaranteeScheme && '✅ 5%首付免LMI'}
                </p>
              </div>
            )}

            <button
              onClick={reset}
              className="w-full mt-3 py-2.5 rounded-xl border border-gray-300 text-sm text-gray-600 hover:bg-gray-50 transition-colors"
            >
              重新评估
            </button>

            <p className="text-[10px] text-gray-400 text-center mt-2">
              * 以上结果仅供参考，具体资格请咨询持牌贷款经纪人
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
