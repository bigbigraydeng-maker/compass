'use client';

import { PERSONAS, type PersonaKey } from './constants';
import PersonaAvatar from './PersonaAvatar';

interface PersonaBadgeProps {
  persona: PersonaKey;
  subtitle?: string;
  compact?: boolean;
  className?: string;
}

export default function PersonaBadge({ persona, subtitle, compact = false, className = '' }: PersonaBadgeProps) {
  const config = PERSONAS[persona];

  if (compact) {
    return (
      <div className={`flex items-center gap-1.5 ${className}`}>
        <PersonaAvatar persona={persona} size="sm" />
        <span className={`text-xs font-medium ${config.textColor}`}>{config.name}</span>
        <span className="text-[10px] text-gray-400">|</span>
        <span className="text-[10px] text-gray-500">{config.title}</span>
      </div>
    );
  }

  return (
    <div className={`flex items-center gap-3 ${className}`}>
      <PersonaAvatar persona={persona} size="md" />
      <div>
        <div className="flex items-center gap-2">
          <span className="font-semibold text-gray-900">{config.name}</span>
          <span className={`${config.bgColor} ${config.textColor} px-2 py-0.5 rounded-full font-medium text-[10px]`}>
            {config.title}
          </span>
        </div>
        {subtitle && <p className="text-xs text-gray-400 mt-0.5">{subtitle}</p>}
      </div>
    </div>
  );
}
