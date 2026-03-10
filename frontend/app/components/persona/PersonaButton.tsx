'use client';

import { PERSONAS, type PersonaKey } from './constants';

interface PersonaButtonProps {
  persona: PersonaKey;
  loading?: boolean;
  onClick?: () => void;
  label?: string;
  loadingLabel?: string;
  disabled?: boolean;
  fullWidth?: boolean;
  size?: 'sm' | 'md';
  className?: string;
}

export default function PersonaButton({
  persona,
  loading = false,
  onClick,
  label,
  loadingLabel,
  disabled = false,
  fullWidth = false,
  size = 'md',
  className = '',
}: PersonaButtonProps) {
  const config = PERSONAS[persona];
  const defaultLabel = `${config.name} 分析`;
  const defaultLoadingLabel = `${config.name} 分析中...`;

  const sizeClass = size === 'sm'
    ? 'py-2 px-4 text-xs'
    : 'py-3 px-6 text-sm';

  return (
    <button
      onClick={onClick}
      disabled={disabled || loading}
      className={`
        ${config.buttonBg} ${config.buttonHover} text-white rounded-lg
        font-medium transition-all duration-200
        disabled:opacity-50 disabled:cursor-not-allowed
        flex items-center justify-center gap-2
        ${fullWidth ? 'w-full' : ''}
        ${sizeClass}
        ${className}
      `}
    >
      {loading ? (
        <>
          <svg className="animate-spin h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
            <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
          </svg>
          {loadingLabel || defaultLoadingLabel}
        </>
      ) : (
        label || defaultLabel
      )}
    </button>
  );
}
