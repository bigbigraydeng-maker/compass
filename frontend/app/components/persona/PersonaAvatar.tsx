'use client';

import { useState } from 'react';
import { PERSONAS, type PersonaKey } from './constants';

interface PersonaAvatarProps {
  persona: PersonaKey;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

const SIZE_MAP = {
  sm: 'w-8 h-8 text-xs',
  md: 'w-11 h-11 text-sm',
  lg: 'w-14 h-14 text-xl',
  xl: 'w-20 h-20 text-3xl',
};

export default function PersonaAvatar({ persona, size = 'md', className = '' }: PersonaAvatarProps) {
  const config = PERSONAS[persona];
  const [imgError, setImgError] = useState(false);
  const sizeClass = SIZE_MAP[size];

  if (!imgError && config.avatar) {
    return (
      <img
        src={config.avatar}
        alt={config.name}
        className={`${sizeClass} rounded-full object-cover shadow-md ${className}`}
        onError={() => setImgError(true)}
      />
    );
  }

  // Fallback: gradient circle with initial
  return (
    <div
      className={`${sizeClass} rounded-full bg-gradient-to-br ${config.gradient} flex items-center justify-center shadow-md ${className}`}
    >
      <span className="text-white font-bold">{config.fallbackInitial}</span>
    </div>
  );
}
