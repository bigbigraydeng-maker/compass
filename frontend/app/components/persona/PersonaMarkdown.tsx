'use client';

interface PersonaMarkdownProps {
  content: string;
  variant?: 'light' | 'dark' | 'compact';
  className?: string;
}

/**
 * Unified markdown renderer for all persona analysis results.
 * Based on SuburbContent.tsx's most complete implementation.
 *
 * Variants:
 * - light: White/gray bg pages (SuburbContent, SchoolDetailPanel)
 * - dark:  Dark bg sections (Hero, AIPropertyAnalysis)
 * - compact: Small containers (TodayDeals)
 */
export default function PersonaMarkdown({ content, variant = 'light', className = '' }: PersonaMarkdownProps) {
  if (!content) return null;

  const lines = content.split('\n');

  // Color schemes per variant
  const colors = {
    light: {
      h2: 'text-lg font-bold text-blue-900 mt-4 mb-2 border-b border-blue-100 pb-1',
      h3: 'text-base font-semibold text-blue-800 mt-3 mb-1',
      li: 'ml-4 text-gray-700 mb-1 text-sm',
      bold: 'font-semibold text-gray-900 text-sm',
      p: 'text-gray-700 text-sm leading-relaxed',
    },
    dark: {
      h2: 'text-lg font-bold text-white mt-4 mb-2 border-b border-white/20 pb-1',
      h3: 'text-base font-semibold text-blue-200 mt-3 mb-1',
      li: 'ml-4 text-gray-200 mb-1 text-sm',
      bold: 'font-bold text-white text-sm',
      p: 'text-gray-200 text-sm leading-relaxed',
    },
    compact: {
      h2: 'text-sm font-bold text-gray-900 mt-3 mb-1',
      h3: 'text-xs font-semibold text-gray-800 mt-2 mb-0.5',
      li: 'ml-3 text-gray-600 mb-0.5 text-xs',
      bold: 'font-bold text-gray-800 text-xs',
      p: 'text-gray-600 text-xs leading-relaxed',
    },
  };

  const c = colors[variant];

  return (
    <div className={`space-y-0.5 ${className}`}>
      {lines.map((line, i) => {
        const trimmed = line.trim();

        if (!trimmed) {
          return <div key={i} className="h-2" />;
        }

        // ## heading
        if (trimmed.startsWith('## ')) {
          return <h3 key={i} className={c.h2}>{trimmed.slice(3)}</h3>;
        }

        // ### subheading
        if (trimmed.startsWith('### ')) {
          return <h4 key={i} className={c.h3}>{trimmed.slice(4)}</h4>;
        }

        // - bullet point
        if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
          return (
            <li key={i} className={c.li}>
              <InlineFormat text={trimmed.slice(2)} variant={variant} />
            </li>
          );
        }

        // **bold line** (entire line bold)
        if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
          return <p key={i} className={c.bold}>{trimmed.slice(2, -2)}</p>;
        }

        // Regular paragraph with inline bold support
        return (
          <p key={i} className={c.p}>
            <InlineFormat text={trimmed} variant={variant} />
          </p>
        );
      })}
    </div>
  );
}

/** Handles inline **bold** within text */
function InlineFormat({ text, variant }: { text: string; variant: string }) {
  const parts = text.split(/(\*\*[^*]+\*\*)/g);
  const strongClass = variant === 'dark' ? 'font-semibold text-white' : 'font-semibold text-gray-900';

  return (
    <>
      {parts.map((part, i) => {
        if (part.startsWith('**') && part.endsWith('**')) {
          return <strong key={i} className={strongClass}>{part.slice(2, -2)}</strong>;
        }
        return <span key={i}>{part}</span>;
      })}
    </>
  );
}
