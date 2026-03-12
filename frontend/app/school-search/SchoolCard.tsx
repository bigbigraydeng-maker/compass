'use client';

interface School {
  name: string;
  type: string;
  school_type?: string;
  suburb: string;
  sector: string;
  naplan_score: number;
  naplan_percentile: number;
  enrollment: number;
  rating: number;
  lat: number;
  lng: number;
  catchment_suburbs: string[];
}

interface SchoolCardProps {
  school: School;
  isSelected: boolean;
  isComparing?: boolean;
  onCompareToggle?: (school: School) => void;
  onClick: () => void;
}

const typeLabels: Record<string, string> = {
  primary: '小学',
  secondary: '中学',
  combined: '综合',
};

const sectorLabels: Record<string, string> = {
  Government: '公立',
  Catholic: '天主教',
  Independent: '私立',
};

export default function SchoolCard({ school, isSelected, isComparing, onCompareToggle, onClick }: SchoolCardProps) {
  const naplanPct = school.naplan_percentile || 0;

  return (
    <div
      className={`bg-white rounded-xl border p-4 transition-all hover:shadow-md ${
        isSelected
          ? 'border-blue-500 shadow-md ring-2 ring-blue-100'
          : isComparing
          ? 'border-emerald-400 ring-1 ring-emerald-100'
          : 'border-gray-200 hover:border-blue-300'
      }`}
    >
      {/* Header: Name + badges */}
      <div className="flex items-start justify-between mb-2">
        <h3
          onClick={onClick}
          className="font-semibold text-sm text-gray-900 leading-tight flex-1 mr-2 cursor-pointer hover:text-blue-600 transition-colors"
        >
          {school.name}
        </h3>
        <div className="flex items-center gap-1.5 flex-shrink-0">
          <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-medium ${
            school.type === 'primary' ? 'bg-blue-100 text-blue-700' :
            school.type === 'secondary' ? 'bg-purple-100 text-purple-700' :
            'bg-orange-100 text-orange-700'
          }`}>
            {typeLabels[school.type] || school.type}
          </span>
          <span className={`text-[10px] px-1.5 py-0.5 rounded-full font-medium ${
            school.sector === 'Government' ? 'bg-green-100 text-green-700' :
            school.sector === 'Catholic' ? 'bg-yellow-100 text-yellow-700' :
            'bg-pink-100 text-pink-700'
          }`}>
            {sectorLabels[school.sector] || school.sector}
          </span>
        </div>
      </div>

      {/* NAPLAN bar */}
      <div className="mb-2 cursor-pointer" onClick={onClick}>
        <div className="flex items-center justify-between text-xs mb-0.5">
          <span className="text-gray-500">NAPLAN</span>
          <span className={`font-bold ${
            naplanPct >= 80 ? 'text-green-600' : naplanPct >= 60 ? 'text-yellow-600' : 'text-red-600'
          }`}>
            {naplanPct}%
          </span>
        </div>
        <div className="w-full bg-gray-200 rounded-full h-1.5">
          <div
            className={`h-1.5 rounded-full ${
              naplanPct >= 80 ? 'bg-green-500' : naplanPct >= 60 ? 'bg-yellow-500' : 'bg-red-500'
            }`}
            style={{ width: `${Math.min(100, naplanPct)}%` }}
          />
        </div>
      </div>

      {/* Meta row + compare button */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2 text-[10px] text-gray-500 cursor-pointer" onClick={onClick}>
          <span>{school.suburb}</span>
          <span>|</span>
          <span>{school.enrollment || '-'}人</span>
          {school.catchment_suburbs.length > 1 && (
            <>
              <span>|</span>
              <span>覆盖{school.catchment_suburbs.length}区</span>
            </>
          )}
        </div>
        {onCompareToggle && (
          <button
            onClick={(e) => {
              e.stopPropagation();
              onCompareToggle(school);
            }}
            className={`text-[10px] px-2 py-0.5 rounded-full border transition-colors ${
              isComparing
                ? 'bg-emerald-100 text-emerald-700 border-emerald-300'
                : 'bg-gray-50 text-gray-400 border-gray-200 hover:border-emerald-300 hover:text-emerald-600'
            }`}
          >
            {isComparing ? '✓ 对比中' : '+ 对比'}
          </button>
        )}
      </div>
    </div>
  );
}
