'use client';

import { useState, useRef, useEffect, useCallback } from 'react';
import { PersonaAvatar } from './persona';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'https://compass-r58x.onrender.com';

interface Message {
  role: 'user' | 'assistant';
  content: string;
  isError?: boolean;
  timestamp?: number;
  displayContent?: string; // For typewriter effect
}

interface ChatInterfaceProps {
  context: 'first_home' | 'overseas' | 'general';
  title?: string;
  placeholder?: string;
}

// 本地预设回复（当后端不可用时使用）
const LOCAL_ANSWERS: Record<string, Record<string, string>> = {
  first_home: {
    '首次置业补贴怎么申请？': '昆士兰首次置业补贴 (FHOG) $30,000 申请步骤：\n\n1. 确认资格：首次在澳购房、年满18岁、澳洲公民/PR\n2. 房产要求：全新住宅或大翻新，房价≤$750,000\n3. 申请方式：通过贷款银行代办（最常见）或直接向 Queensland Revenue Office 申请\n4. 时间：通常在交割时自动抵扣\n\n💡 建议通过贷款经纪人一并办理，最简便。',
    '50万预算能在哪里买房？': '50万预算在布里斯班可以考虑：\n\n🏠 Calamvale - 联排/公寓，华人社区成熟\n🏠 Eight Mile Plains - 公寓为主，交通便利\n🏠 Rochedale - 新开发区联排，潜力大\n\n💰 若购买新房≤$500,000，可享印花税全免 + $30,000 FHOG 补贴\n💡 建议首选新房联排，最大化政府补贴。',
    '首付最低需要多少？': '首次购房者首付最低要求：\n\n✅ 首置担保计划：仅需 5% 首付（免LMI）\n- 单人年收入≤$125,000\n- 夫妻≤$200,000\n- 需申请名额\n\n📊 以50万房产为例：\n- 5%首付 = $25,000\n- 加上印花税（首置新房可能全免）\n- 加上法律费约$2,000-3,000\n\n💡 总前期费用约$28,000-30,000 即可入场。',
    '贷款预批流程是怎样的？': '贷款预批流程（约1-3天）：\n\n1️⃣ 准备材料：身份证明、收入证明（工资单/报税）、银行流水、负债情况\n2️⃣ 选择银行/经纪人：建议找熟悉华人客户的贷款经纪人\n3️⃣ 提交申请：线上或面对面\n4️⃣ 获取预批信：通常1-3个工作日\n\n⏰ 预批有效期：3-6个月\n💡 建议在看房前先拿到预批，谈判时更有底气。',
  },
  overseas: {
    'FIRB申请流程是什么？': 'FIRB（外国投资审查委员会）申请流程：\n\n1️⃣ 确认购买新房/空地（海外人士不能买二手房）\n2️⃣ 在线提交申请：firb.gov.au\n3️⃣ 支付申请费：\n   - 房价<$75万：约$14,100\n   - $75万-$100万：约$28,200\n4️⃣ 等待审批：通常30个工作日\n5️⃣ 获批后方可签约\n\n⚠️ 必须在签约前获得FIRB批准，否则可能被罚款。',
    '海外人士买房额外费用有哪些？': '海外人士在QLD购房额外费用：\n\n1. FIRB申请费：$14,100-$56,400（按房价）\n2. AFAD额外印花税：房价的 8%\n   - 60万房产 = 额外$48,000\n   - 100万房产 = 额外$80,000\n3. 常规印花税：约2-5%\n4. 律师费：$2,000-$5,000\n5. 验房费：$400-$600\n\n📊 100万房产总额外成本约：$108,000-$120,000\n💡 建议预算至少留12%以上作为额外费用。',
    '布里斯班有哪些新楼盘？': '布里斯班适合海外投资者的热门新房区域：\n\n🏗️ Rochedale - 大量新联排/别墅，性价比高\n🏗️ Hamilton - 滨水高端公寓，资本增值潜力大\n🏗️ Eight Mile Plains - 新公寓项目，华人社区\n🏗️ South Brisbane - CBD附近，租金回报好\n\n💡 建议通过Compass查看各区详情，或联系我们的顾问获取最新楼盘信息。',
    '海外人士能贷款吗？': '海外人士在澳贷款情况：\n\n✅ 可以贷款，但条件较严\n📊 一般可贷：房价的60-70%（需30-40%首付）\n🏦 可选银行：部分澳洲银行、中资银行（中国银行、工商银行在澳分行）\n\n📋 所需材料：\n- 护照、签证\n- 海外收入证明\n- 银行流水（6个月）\n- FIRB批准信\n\n💡 利率通常比本地居民高0.5-1%，建议找专做海外客户的贷款经纪人。',
  },
};

export default function ChatInterface({ context, title, placeholder }: ChatInterfaceProps) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [suggestions, setSuggestions] = useState<string[]>([]);
  const [apiStatus, setApiStatus] = useState<'unknown' | 'online' | 'offline'>('unknown');
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const abortControllerRef = useRef<AbortController | null>(null);

  // 初始建议
  useEffect(() => {
    const initialSuggestions: Record<string, string[]> = {
      first_home: [
        '首次置业补贴怎么申请？',
        '50万预算能在哪里买房？',
        '首付最低需要多少？',
        '贷款预批流程是怎样的？',
      ],
      overseas: [
        'FIRB申请流程是什么？',
        '海外人士买房额外费用有哪些？',
        '布里斯班有哪些新楼盘？',
        '海外人士能贷款吗？',
      ],
      general: [
        '布里斯班哪个区投资回报最高？',
        '现在是买房的好时机吗？',
        'Sunnybank区怎么样？',
      ],
    };
    setSuggestions(initialSuggestions[context] || initialSuggestions.general);
  }, [context]);

  // 检测 API 状态
  useEffect(() => {
    const checkApi = async () => {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), 5000);
        const res = await fetch(`${API_BASE}/`, { signal: controller.signal });
        clearTimeout(timeoutId);
        setApiStatus(res.ok ? 'online' : 'offline');
      } catch {
        setApiStatus('offline');
      }
    };
    checkApi();
  }, []);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // 尝试从本地预设获取回复
  const getLocalAnswer = (text: string): string | null => {
    const contextAnswers = LOCAL_ANSWERS[context];
    if (!contextAnswers) return null;

    // 精确匹配
    if (contextAnswers[text]) return contextAnswers[text];

    // 模糊匹配
    for (const [question, answer] of Object.entries(contextAnswers)) {
      const keywords = question.replace(/[？?！!。，、]/g, '').split('');
      const matchCount = keywords.filter(k => text.includes(k)).length;
      if (matchCount > keywords.length * 0.5) return answer;
    }

    return null;
  };

  const sendMessage = async (text: string) => {
    if (!text.trim() || loading) return;

    const userMessage: Message = { role: 'user', content: text.trim(), timestamp: Date.now() };
    setMessages(prev => [...prev, userMessage]);
    setInput('');
    setLoading(true);

    // 先尝试本地回复（如果 API 离线或作为快速响应）
    if (apiStatus === 'offline') {
      const localAnswer = getLocalAnswer(text.trim());
      if (localAnswer) {
        // 模拟短暂延迟
        await new Promise(r => setTimeout(r, 500));
        setMessages(prev => [
          ...prev,
          { role: 'assistant', content: localAnswer, timestamp: Date.now() },
        ]);
        setLoading(false);
        return;
      }
    }

    try {
      // 创建新的 AbortController
      abortControllerRef.current = new AbortController();
      const timeoutId = setTimeout(() => abortControllerRef.current?.abort(), 30000); // 30秒超时

      const res = await fetch(`${API_BASE}/api/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          message: text.trim(),
          context,
          history: messages.filter(m => !m.isError).map(m => ({ role: m.role, content: m.content })),
        }),
        signal: abortControllerRef.current.signal,
      });

      clearTimeout(timeoutId);

      if (!res.ok) {
        const errData = await res.json().catch(() => ({}));
        throw new Error(errData.detail || `服务器错误 (${res.status})`);
      }

      const data = await res.json();
      setApiStatus('online');
      const reply = data.reply || '抱歉，暂时无法回答';
      const assistantMessage: Message = {
        role: 'assistant',
        content: reply,
        timestamp: Date.now(),
        displayContent: '', // Start typewriter empty
      };
      setMessages(prev => [...prev, assistantMessage]);
      // Typewriter effect
      let charIndex = 0;
      const typeInterval = setInterval(() => {
        charIndex += 2; // 2 chars at a time for speed
        if (charIndex >= reply.length) {
          clearInterval(typeInterval);
          setMessages(prev => prev.map((m, idx) =>
            idx === prev.length - 1 ? { ...m, displayContent: undefined } : m
          ));
        } else {
          setMessages(prev => prev.map((m, idx) =>
            idx === prev.length - 1 ? { ...m, displayContent: reply.slice(0, charIndex) } : m
          ));
        }
      }, 15);
      if (data.suggestions) {
        setSuggestions(data.suggestions);
      }
    } catch (err: any) {
      // API 失败 → 尝试本地回复
      const localAnswer = getLocalAnswer(text.trim());
      if (localAnswer) {
        setMessages(prev => [
          ...prev,
          { role: 'assistant', content: localAnswer, timestamp: Date.now() },
        ]);
        setApiStatus('offline');
      } else {
        const errorMsg = err.name === 'AbortError'
          ? '请求超时，AI 正在忙碌中，请稍后再试。'
          : '暂时无法连接 AI 服务。您可以点击下方的常见问题快速获取答案，或稍后重试。';
        setMessages(prev => [
          ...prev,
          { role: 'assistant', content: errorMsg, isError: true, timestamp: Date.now() },
        ]);
        setApiStatus('offline');

        // 恢复建议按钮
        const fallbackSuggestions: Record<string, string[]> = {
          first_home: [
            '首次置业补贴怎么申请？',
            '50万预算能在哪里买房？',
            '首付最低需要多少？',
            '贷款预批流程是怎样的？',
          ],
          overseas: [
            'FIRB申请流程是什么？',
            '海外人士买房额外费用有哪些？',
            '布里斯班有哪些新楼盘？',
            '海外人士能贷款吗？',
          ],
          general: [],
        };
        setSuggestions(fallbackSuggestions[context] || []);
      }
    } finally {
      setLoading(false);
      abortControllerRef.current = null;
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    sendMessage(input);
  };

  const defaultTitle = context === 'first_home' ? 'Amanda · 首次置业顾问' : context === 'overseas' ? 'Amanda · 海外购房顾问' : 'Amanda · 房产分析师';
  const defaultPlaceholder = context === 'first_home' ? '问问首次置业相关问题...' : context === 'overseas' ? '问问海外购房相关问题...' : '输入您的问题...';

  return (
    <div className="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      {/* 头部 */}
      <div className="bg-gradient-to-r from-blue-500 to-indigo-600 px-4 md:px-6 py-3 md:py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 md:gap-3">
            <PersonaAvatar persona="amanda" size="md" className="ring-2 ring-white/30" />
            <div>
              <h3 className="text-white font-semibold text-sm md:text-base">{title || defaultTitle}</h3>
              <p className="text-blue-100 text-[10px] md:text-xs">Compass AI · 7×24小时在线</p>
            </div>
          </div>
          {/* API 状态指示 */}
          <div className="flex items-center gap-1.5">
            <div className={`w-2 h-2 rounded-full ${
              apiStatus === 'online' ? 'bg-green-400' :
              apiStatus === 'offline' ? 'bg-yellow-400' :
              'bg-gray-400 animate-pulse'
            }`} />
            <span className="text-[10px] text-blue-100">
              {apiStatus === 'online' ? '在线' : apiStatus === 'offline' ? '离线模式' : '连接中'}
            </span>
          </div>
        </div>
      </div>

      {/* 消息区域 */}
      <div className="h-72 md:h-80 overflow-y-auto p-3 md:p-4 space-y-3 bg-gray-50">
        {messages.length === 0 && (
          <div className="text-center text-gray-400 text-xs md:text-sm mt-6 md:mt-8">
            <p className="text-2xl mb-2">👋</p>
            <p className="font-medium mb-1">您好！我是{title || defaultTitle}</p>
            <p className="text-[10px] md:text-xs">点击下方常见问题快速了解，或输入自定义问题</p>
            {apiStatus === 'offline' && (
              <p className="text-[10px] text-yellow-500 mt-2 bg-yellow-50 rounded-lg py-1 px-2 inline-block">
                ⚡ 离线模式：可回答预设常见问题
              </p>
            )}
          </div>
        )}

        {messages.map((msg, i) => {
          const displayText = msg.displayContent !== undefined ? msg.displayContent : msg.content;
          return (
            <div
              key={i}
              className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'} gap-2`}
            >
              {msg.role === 'assistant' && (
                <PersonaAvatar persona="amanda" size="sm" className="mt-1 flex-shrink-0" />
              )}
              <div className="flex flex-col">
                <div
                  className={`max-w-[85%] rounded-xl px-3 md:px-4 py-2 md:py-3 text-xs md:text-sm ${
                    msg.role === 'user'
                      ? 'bg-blue-600 text-white rounded-br-sm'
                      : msg.isError
                        ? 'bg-orange-50 text-orange-700 border border-orange-200 rounded-bl-sm'
                        : 'bg-white text-gray-800 shadow-sm border border-gray-100 rounded-bl-sm'
                  }`}
                >
                  {displayText.split('\n').map((line, j) => {
                    if (line.trim() === '') return <br key={j} />;
                    return <p key={j} className={j > 0 ? 'mt-1' : ''}>{line}</p>;
                  })}
                  {msg.displayContent !== undefined && (
                    <span className="inline-block w-0.5 h-3.5 bg-blue-500 animate-pulse ml-0.5" />
                  )}
                </div>
                {msg.timestamp && (
                  <span className={`text-[9px] text-gray-300 mt-0.5 ${msg.role === 'user' ? 'text-right' : ''}`}>
                    {new Date(msg.timestamp).toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })}
                  </span>
                )}
              </div>
            </div>
          );
        })}

        {loading && (
          <div className="flex justify-start">
            <div className="bg-white text-gray-500 rounded-xl px-4 py-3 shadow-sm border border-gray-100 rounded-bl-sm">
              <div className="flex items-center gap-2">
                <div className="flex gap-1">
                  <div className="w-1.5 h-1.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '0ms' }} />
                  <div className="w-1.5 h-1.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '150ms' }} />
                  <div className="w-1.5 h-1.5 bg-blue-400 rounded-full animate-bounce" style={{ animationDelay: '300ms' }} />
                </div>
                <span className="text-xs text-gray-400">
                  {apiStatus === 'offline' ? '查询中...' : 'AI 思考中（约5-15秒）...'}
                </span>
              </div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* 建议问题 - 始终显示（离线模式下尤其重要） */}
      {suggestions.length > 0 && !loading && (
        <div className="px-3 md:px-4 py-2 border-t border-gray-100 bg-white">
          <p className="text-[10px] text-gray-400 mb-1.5">
            {messages.length === 0 ? '💡 常见问题：' : '💡 继续问：'}
          </p>
          <div className="flex flex-wrap gap-1.5 md:gap-2">
            {suggestions.map((s, i) => (
              <button
                key={i}
                onClick={() => sendMessage(s)}
                className="text-xs bg-blue-50 text-blue-600 px-3 py-1.5 md:py-2 rounded-full hover:bg-blue-100 transition-colors border border-blue-100 active:scale-95"
              >
                {s}
              </button>
            ))}
          </div>
        </div>
      )}

      {/* 输入框 */}
      <form onSubmit={handleSubmit} className="p-3 md:p-4 border-t border-gray-200 bg-white">
        <div className="flex gap-2">
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder={placeholder || defaultPlaceholder}
            className="flex-1 px-3 md:px-4 py-2 md:py-2.5 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs md:text-sm text-gray-900"
            disabled={loading}
          />
          <button
            type="submit"
            disabled={loading || !input.trim()}
            className="bg-blue-600 hover:bg-blue-700 text-white px-3 md:px-4 py-2 md:py-2.5 rounded-lg text-xs md:text-sm font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed active:scale-95"
          >
            {loading ? '...' : '发送'}
          </button>
        </div>
      </form>
    </div>
  );
}
