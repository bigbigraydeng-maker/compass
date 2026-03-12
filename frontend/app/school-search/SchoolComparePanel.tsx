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

interface Props {
  schools: School[];
  onRemove: (name: string) => void;
  onClose: () => void;
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

export default function SchoolComparePanel({ schools, onRemove, onClose }: Props) {
  if (schools.length < 2) return null;

  const bestNaplan = Math.max(...schools.map(s => s.naplan_percentile || 0));
  const bestEnrollment = Math.max(...schools.map(s => s.enrollment || 0));
  const bestRating = Math.max(...schools.map(s => s.rating || 0));

  return (
    <div className="bg-white rounded-xl shadow-lg border border-blue-200 overflow-hidden">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 px-4 py-3 flex items-center justify-between">
        <h3 className="text-white font-semibold text-sm flex items-center gap-2">
          📊 学校对比 ({schools.length})
        </h3>
        <button onClick={onClose} className="text-white/70 hover:text-white text-xs">
          关闭
        </button>
      </div>

      {/* Comparison grid */}
      <div className="overflow-x-auto">
        <table className="w-full text-xs md:text-sm">
          <thead>
            <tr className="border-b border-gray-100 bg-gray-50">
              <th className="text-left p-2 md:p-3 text-gray-500 font-medium w-20 md:w-28">指标</th>
              {schools.map((s) => (
                <th key={s.name} className="p-2 md:p-3 text-center min-w-[120px]">
                  <div className="flex flex-col items-center gap-1">
                    <span className="font-semibold text-gray-900 text-xs leading-tight">{s.name}</span>
                    <button
                      onClick={() => onRemove(s.name)}
                      className="text-[10px] text-red-400 hover:text-red-600"
                    >
                      移除
                    </button>
                  </div>
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {/* Type */}
            <tr className="border-b border-gray-50">
              <td className="p-2 md:p-3 text-gray-500">类型</td>
              {schools.map((s) => (
                <td key={s.name} className="p-2 md:p-3 text-center text-gray-900">
                  {typeLabels[s.type] || s.type} · {sectorLabels[s.sector] || s.sector}
                </td>
              ))}
            </tr>

            {/* NAPLAN */}
            <tr className="border-b border-gray-50">
              <td className="p-2 md:p-3 text-gray-500">NAPLAN</td>
              {schools.map((s) => {
                const pct = s.naplan_percentile || 0;
                const isBest = pct === bestNaplan && schools.length > 1;
                return (
                  <td key={s.name} className="p-2 md:p-3 text-center">
                    <div className="flex flex-col items-center gap-1">
                      <span className={`font-bold ${isBest ? 'text-green-600' : pct >= 80 ? 'text-green-600' : pct >= 60 ? 'text-yellow-600' : 'text-red-600'}`}>
                        {pct}%
                        {isBest && ' ★'}
                      </span>
                      <div className="w-full max-w-[80px] bg-gray-200 rounded-full h-1.5">
                        <div
                          className={`h-1.5 rounded-full ${pct >= 80 ? 'bg-green-500' : pct >= 60 ? 'bg-yellow-500' : 'bg-red-500'}`}
                          style={{ width: `${Math.min(100, pct)}%` }}
                        />
                      </div>
                    </div>
                  </td>
                );
              })}
            </tr>

            {/* Enrollment */}
            <tr className="border-b border-gray-50">
              <td className="p-2 md:p-3 text-gray-500">在读人数</td>
              {schools.map((s) => {
                const isBest = (s.enrollment || 0) === bestEnrollment && schools.length > 1;
                return (
                  <td key={s.name} className={`p-2 md:p-3 text-center font-medium ${isBest ? 'text-blue-600' : 'text-gray-900'}`}>
                    {s.enrollment || '-'} 人
                  </td>
                );
              })}
            </tr>

            {/* Rating */}
            <tr className="border-b border-gray-50">
              <td className="p-2 md:p-3 text-gray-500">评分</td>
              {schools.map((s) => {
                const isBest = (s.rating || 0) === bestRating && schools.length > 1;
                return (
                  <td key={s.name} className={`p-2 md:p-3 text-center font-medium ${isBest ? 'text-blue-600' : 'text-gray-900'}`}>
                    {s.rating || '-'} / 10
                  </td>
                );
              })}
            </tr>

            {/* Suburb */}
            <tr className="border-b border-gray-50">
              <td className="p-2 md:p-3 text-gray-500">位置</td>
              {schools.map((s) => (
                <td key={s.name} className="p-2 md:p-3 text-center text-gray-900">
                  {s.suburb}
                </td>
              ))}
            </tr>

            {/* Catchment count */}
            <tr>
              <td className="p-2 md:p-3 text-gray-500">学区覆盖</td>
              {schools.map((s) => (
                <td key={s.name} className="p-2 md:p-3 text-center text-gray-900">
                  {s.catchment_suburbs.length} 个区域
                </td>
              ))}
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
}
