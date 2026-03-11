'use client';

import { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import { fetcher } from '../lib/api';

// ====== Type Definitions ======

interface Stats {
  documents: {
    total: number;
    pdf: number;
    html: number;
    ocr_needed: number;
  };
  chunks: {
    total: number;
    total_tokens: number;
    avg_tokens: number;
  };
  by_project: Array<{ project: string; cnt: number }>;
  by_doc_type: Array<{ doc_type: string; cnt: number }>;
  recent_crawls: Array<{
    source_name: string;
    started_at: string;
    status: string;
    pages_new: number;
    chunks_created: number;
  }>;
}

interface SearchResult {
  chunk_text: string;
  source_name: string;
  title: string | null;
  doc_type: string | null;
  doc_date: string | null;
  similarity: number;
  url: string | null;
}

interface Document {
  id: number;
  url: string;
  title: string;
  source_name: string;
  source_type: string;
  doc_type: string | null;
  suburb: string | null;
  parse_status: string;
  file_size: number | null;
  version: number;
  metadata: Record<string, any>;
  crawl_status: string;
  last_crawled_at: string;
  created_at: string;
}

interface Source {
  source_name: string;
  source_type: string;
  base_url: string;
  crawl_frequency: string;
  priority: string;
  is_active: boolean;
  last_crawled_at: string | null;
  last_success_at: string | null;
  consecutive_failures: number;
  total_documents: number;
  created_at: string;
}

interface CrawlStatus {
  running: boolean;
  last_result: Record<string, any> | null;
}

// ====== Helper Functions ======

function formatDocType(type: string | null): string {
  if (!type) return '-';
  return type.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
}

function formatFileSize(bytes: number | null): string {
  if (!bytes) return '-';
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}

function formatDate(dateStr: string | null): string {
  if (!dateStr) return '-';
  const d = new Date(dateStr);
  return d.toLocaleDateString('en-AU', { year: 'numeric', month: 'short', day: 'numeric' });
}

function formatTimeAgo(dateStr: string | null): string {
  if (!dateStr) return 'Never';
  const d = new Date(dateStr);
  const now = new Date();
  const diffMs = now.getTime() - d.getTime();
  const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
  const diffDays = Math.floor(diffHours / 24);
  if (diffDays > 30) return `${Math.floor(diffDays / 30)}mo ago`;
  if (diffDays > 0) return `${diffDays}d ago`;
  if (diffHours > 0) return `${diffHours}h ago`;
  return 'Just now';
}

function truncateText(text: string, maxLen: number): string {
  if (text.length <= maxLen) return text;
  return text.slice(0, maxLen) + '...';
}

const DOC_TYPE_COLORS: Record<string, string> = {
  development_scheme: 'bg-blue-100 text-blue-800',
  development_charges: 'bg-green-100 text-green-800',
  infrastructure_plan: 'bg-purple-100 text-purple-800',
  context_plan: 'bg-teal-100 text-teal-800',
  submissions_report: 'bg-yellow-100 text-yellow-800',
  fact_sheet: 'bg-orange-100 text-orange-800',
  precinct_plan: 'bg-indigo-100 text-indigo-800',
  olympics_venue: 'bg-red-100 text-red-800',
  government_pdf: 'bg-gray-100 text-gray-700',
  development_overview: 'bg-sky-100 text-sky-800',
  urban_renewal: 'bg-emerald-100 text-emerald-800',
  priority_development_area: 'bg-violet-100 text-violet-800',
  web_page: 'bg-slate-100 text-slate-700',
};

const PRIORITY_COLORS: Record<string, string> = {
  P1: 'bg-red-100 text-red-700',
  P2: 'bg-yellow-100 text-yellow-700',
  P3: 'bg-gray-100 text-gray-600',
};

// ====== Main Component ======

export default function DevIntelPage() {
  // Tab state
  const [activeTab, setActiveTab] = useState<'overview' | 'search' | 'documents' | 'sources'>('overview');

  // Overview state
  const [stats, setStats] = useState<Stats | null>(null);
  const [statsLoading, setStatsLoading] = useState(true);
  const [statsError, setStatsError] = useState<string | null>(null);

  // Search state
  const [query, setQuery] = useState('');
  const [searchSuburb, setSearchSuburb] = useState('');
  const [searchDocType, setSearchDocType] = useState('');
  const [searchResults, setSearchResults] = useState<SearchResult[]>([]);
  const [searching, setSearching] = useState(false);
  const [searchDone, setSearchDone] = useState(false);

  // Documents state
  const [documents, setDocuments] = useState<Document[]>([]);
  const [docsTotal, setDocsTotal] = useState(0);
  const [docsLoading, setDocsLoading] = useState(false);
  const [docsFilter, setDocsFilter] = useState<{ source_type?: string; doc_type?: string }>({});
  const [docsPage, setDocsPage] = useState(0);

  // Sources state
  const [sources, setSources] = useState<Source[]>([]);
  const [sourcesLoading, setSourcesLoading] = useState(false);

  // Crawl state
  const [crawlStatus, setCrawlStatus] = useState<CrawlStatus>({ running: false, last_result: null });

  // ====== Data Loading ======

  useEffect(() => {
    loadStats();
  }, []);

  useEffect(() => {
    if (activeTab === 'documents') {
      loadDocuments();
    } else if (activeTab === 'sources') {
      loadSources();
    }
  }, [activeTab, docsFilter, docsPage]);

  const loadStats = async () => {
    setStatsLoading(true);
    setStatsError(null);
    try {
      const data = await fetcher('/api/devintel/stats');
      setStats(data);
    } catch (e: any) {
      console.error('Failed to load stats:', e);
      setStatsError(e.message || 'Failed to connect to backend');
    }
    setStatsLoading(false);
  };

  const loadDocuments = async () => {
    setDocsLoading(true);
    try {
      const params = new URLSearchParams();
      if (docsFilter.source_type) params.set('source_type', docsFilter.source_type);
      if (docsFilter.doc_type) params.set('doc_type', docsFilter.doc_type);
      params.set('limit', '20');
      params.set('offset', String(docsPage * 20));

      const data = await fetcher(`/api/devintel/documents?${params.toString()}`);
      setDocuments(data.documents || []);
      setDocsTotal(data.total || 0);
    } catch (e) {
      console.error('Failed to load documents:', e);
    }
    setDocsLoading(false);
  };

  const loadSources = async () => {
    setSourcesLoading(true);
    try {
      const data = await fetcher('/api/devintel/sources');
      setSources(data.sources || []);
    } catch (e) {
      console.error('Failed to load sources:', e);
    }
    setSourcesLoading(false);
  };

  const handleSearch = async () => {
    if (!query.trim()) return;
    setSearching(true);
    setSearchDone(false);
    try {
      const params = new URLSearchParams({ q: query });
      if (searchSuburb) params.set('suburb', searchSuburb);
      if (searchDocType) params.set('doc_type', searchDocType);
      params.set('top_k', '10');

      const data = await fetcher(`/api/devintel/search?${params.toString()}`);
      setSearchResults(data.results || []);
      setSearchDone(true);
    } catch (e) {
      console.error('Search failed:', e);
    }
    setSearching(false);
  };

  const triggerCrawl = async (priority?: string) => {
    try {
      await fetcher('/api/devintel/crawl/trigger', {
        method: 'POST',
        body: JSON.stringify(priority ? { priority } : {}),
      });
      setCrawlStatus({ ...crawlStatus, running: true });
      // Poll status
      const interval = setInterval(async () => {
        try {
          const status = await fetcher('/api/devintel/crawl/status');
          setCrawlStatus(status);
          if (!status.running) {
            clearInterval(interval);
            loadStats();
          }
        } catch {
          clearInterval(interval);
        }
      }, 5000);
    } catch (e) {
      console.error('Crawl trigger failed:', e);
    }
  };

  // ====== Tab Definitions ======
  const tabs = [
    { key: 'overview', label: 'Overview', icon: '📊' },
    { key: 'search', label: 'Search', icon: '🔍' },
    { key: 'documents', label: 'Documents', icon: '📄' },
    { key: 'sources', label: 'Sources', icon: '🌐' },
  ];

  // ====== Render ======

  return (
    <>
      <Navbar activePage="devintel" />

      <div className="min-h-screen bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header */}
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900">Development Intelligence</h1>
            <p className="text-gray-500 mt-2">
              Brisbane development knowledge base — PDF documents, government data, and vector-powered search
            </p>
          </div>

          {/* Tabs */}
          <div className="flex border-b border-gray-200 mb-8">
            {tabs.map(tab => (
              <button
                key={tab.key}
                className={`px-5 py-3 text-sm font-medium border-b-2 transition-colors ${
                  activeTab === tab.key
                    ? 'border-blue-600 text-blue-600'
                    : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
                }`}
                onClick={() => setActiveTab(tab.key as any)}
              >
                <span className="mr-1.5">{tab.icon}</span>
                {tab.label}
              </button>
            ))}
          </div>

          {/* Tab Content */}
          {activeTab === 'overview' && renderOverview()}
          {activeTab === 'search' && renderSearch()}
          {activeTab === 'documents' && renderDocuments()}
          {activeTab === 'sources' && renderSources()}
        </div>
      </div>
    </>
  );

  // ====== Tab: Overview ======

  function renderOverview() {
    if (statsLoading) {
      return (
        <div className="text-center py-16">
          <div className="animate-spin inline-block w-8 h-8 border-3 border-blue-600 border-t-transparent rounded-full mb-3" />
          <p className="text-gray-400">Loading statistics...</p>
        </div>
      );
    }

    if (statsError) {
      return (
        <div className="bg-white rounded-xl shadow-sm border p-8 text-center">
          <p className="text-red-500 mb-2">Failed to load statistics</p>
          <p className="text-sm text-gray-400 mb-4">{statsError}</p>
          <button
            onClick={loadStats}
            className="px-4 py-2 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors"
          >
            Retry
          </button>
        </div>
      );
    }

    if (!stats) return null;

    return (
      <div className="space-y-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard label="Documents" value={stats.documents.total} sub={`${stats.documents.pdf} PDF + ${stats.documents.html} HTML`} color="blue" />
          <StatCard label="Vector Chunks" value={stats.chunks.total} sub={`~${stats.chunks.avg_tokens} tokens avg`} color="purple" />
          <StatCard label="Total Tokens" value={`${(stats.chunks.total_tokens / 1000).toFixed(0)}K`} sub="Indexed content" color="green" />
          <StatCard label="OCR Pending" value={stats.documents.ocr_needed} sub="Scanned PDFs" color={stats.documents.ocr_needed > 0 ? 'amber' : 'gray'} />
        </div>

        {/* Two columns: Projects + Doc Types */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* By Project */}
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="font-semibold text-gray-800 mb-4">Documents by Project</h3>
            {stats.by_project.length === 0 ? (
              <p className="text-sm text-gray-400">No project data yet</p>
            ) : (
              <div className="space-y-3">
                {stats.by_project.slice(0, 10).map((item) => {
                  const maxCnt = stats.by_project[0]?.cnt || 1;
                  const pct = Math.max(8, (item.cnt / maxCnt) * 100);
                  return (
                    <div key={item.project}>
                      <div className="flex justify-between items-center mb-1">
                        <span className="text-sm text-gray-700 truncate mr-2">{item.project}</span>
                        <span className="text-xs text-gray-500 font-medium">{item.cnt}</span>
                      </div>
                      <div className="w-full bg-gray-100 rounded-full h-2">
                        <div
                          className="bg-blue-500 h-2 rounded-full transition-all"
                          style={{ width: `${pct}%` }}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>

          {/* By Doc Type */}
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="font-semibold text-gray-800 mb-4">Document Types</h3>
            {stats.by_doc_type.length === 0 ? (
              <p className="text-sm text-gray-400">No type data yet</p>
            ) : (
              <div className="flex flex-wrap gap-2">
                {stats.by_doc_type.map((item) => (
                  <span
                    key={item.doc_type}
                    className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium ${
                      DOC_TYPE_COLORS[item.doc_type] || 'bg-gray-100 text-gray-600'
                    }`}
                  >
                    {formatDocType(item.doc_type)}
                    <span className="opacity-60">({item.cnt})</span>
                  </span>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Recent Crawls + Crawl Control */}
        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="font-semibold text-gray-800 mb-4">Recent Crawls</h3>
            {stats.recent_crawls.length === 0 ? (
              <p className="text-sm text-gray-400">No crawl history yet</p>
            ) : (
              <div className="space-y-3">
                {stats.recent_crawls.map((crawl, i) => (
                  <div key={i} className="flex justify-between items-center">
                    <div className="flex items-center gap-2">
                      <span className={`w-2 h-2 rounded-full ${
                        crawl.status === 'completed' ? 'bg-green-500' :
                        crawl.status === 'running' ? 'bg-blue-500 animate-pulse' :
                        'bg-yellow-500'
                      }`} />
                      <span className="text-sm text-gray-700">{crawl.source_name}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <span className="text-xs text-gray-500">
                        +{crawl.pages_new} docs, {crawl.chunks_created} chunks
                      </span>
                      <span className="text-xs text-gray-400">{formatDate(crawl.started_at)}</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="bg-white rounded-xl shadow-sm border p-6">
            <h3 className="font-semibold text-gray-800 mb-4">Manual Crawl</h3>
            <p className="text-sm text-gray-500 mb-4">
              Trigger a manual crawl. Auto-crawl runs daily at 3:00 AM AEST.
            </p>
            <div className="flex gap-3">
              <button
                onClick={() => triggerCrawl('P1')}
                disabled={crawlStatus.running}
                className="px-4 py-2 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
              >
                {crawlStatus.running ? 'Running...' : 'Crawl P1'}
              </button>
              <button
                onClick={() => triggerCrawl()}
                disabled={crawlStatus.running}
                className="px-4 py-2 bg-gray-100 text-gray-700 text-sm rounded-lg hover:bg-gray-200 disabled:bg-gray-100 disabled:text-gray-400 disabled:cursor-not-allowed transition-colors"
              >
                Crawl All
              </button>
            </div>
            {crawlStatus.running && (
              <div className="mt-3 flex items-center gap-2 text-sm text-blue-600">
                <span className="animate-spin inline-block w-4 h-4 border-2 border-blue-600 border-t-transparent rounded-full" />
                Crawling in progress...
              </div>
            )}
          </div>
        </div>
      </div>
    );
  }

  // ====== Tab: Search ======

  function renderSearch() {
    return (
      <div className="space-y-6">
        {/* Search Form */}
        <div className="bg-white rounded-xl shadow-sm border p-6">
          <h3 className="font-semibold text-gray-800 mb-4">Vector Similarity Search</h3>
          <div className="flex flex-col md:flex-row gap-3">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
              placeholder="Search development intelligence... e.g. Cross River Rail, infrastructure charges"
              className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <input
              type="text"
              value={searchSuburb}
              onChange={(e) => setSearchSuburb(e.target.value)}
              placeholder="Suburb (optional)"
              className="w-full md:w-40 px-4 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <select
              value={searchDocType}
              onChange={(e) => setSearchDocType(e.target.value)}
              className="w-full md:w-48 px-4 py-2.5 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
            >
              <option value="">All Types</option>
              <option value="development_scheme">Development Scheme</option>
              <option value="development_charges">Development Charges</option>
              <option value="infrastructure_plan">Infrastructure Plan</option>
              <option value="context_plan">Context Plan</option>
              <option value="submissions_report">Submissions Report</option>
              <option value="fact_sheet">Fact Sheet</option>
              <option value="precinct_plan">Precinct Plan</option>
              <option value="olympics_venue">Olympics Venue</option>
            </select>
            <button
              onClick={handleSearch}
              disabled={searching || !query.trim()}
              className="px-6 py-2.5 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors whitespace-nowrap"
            >
              {searching ? 'Searching...' : 'Search'}
            </button>
          </div>
        </div>

        {/* Results */}
        {searching && (
          <div className="text-center py-12">
            <span className="animate-spin inline-block w-6 h-6 border-2 border-blue-600 border-t-transparent rounded-full mb-3" />
            <p className="text-gray-400 text-sm">Searching vector database...</p>
          </div>
        )}

        {searchDone && searchResults.length === 0 && (
          <div className="bg-white rounded-xl shadow-sm border p-8 text-center">
            <p className="text-gray-400">No results found for &ldquo;{query}&rdquo;</p>
            <p className="text-xs text-gray-300 mt-1">Try different keywords or remove filters</p>
          </div>
        )}

        {searchResults.length > 0 && (
          <div className="space-y-4">
            <p className="text-sm text-gray-500 font-medium">
              {searchResults.length} results found
            </p>
            {searchResults.map((result, i) => (
              <div key={i} className="bg-white rounded-xl shadow-sm border p-5 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center gap-2 flex-wrap">
                    <span className="text-sm font-semibold text-gray-800">
                      {result.title || result.source_name}
                    </span>
                    {result.doc_type && (
                      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                        DOC_TYPE_COLORS[result.doc_type] || 'bg-gray-100 text-gray-600'
                      }`}>
                        {formatDocType(result.doc_type)}
                      </span>
                    )}
                    {result.doc_date && (
                      <span className="text-xs text-gray-400">{formatDate(result.doc_date)}</span>
                    )}
                  </div>
                  <SimilarityBadge value={result.similarity} />
                </div>
                <p className="text-sm text-gray-600 leading-relaxed">
                  {truncateText(result.chunk_text, 350)}
                </p>
                {result.url && (
                  <a
                    href={result.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-xs text-blue-500 hover:text-blue-700 mt-2 inline-flex items-center gap-1"
                  >
                    <span className="truncate max-w-md">{result.url}</span>
                    <span>→</span>
                  </a>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  // ====== Tab: Documents ======

  function renderDocuments() {
    return (
      <div className="space-y-4">
        {/* Filters */}
        <div className="bg-white rounded-xl shadow-sm border p-4 flex flex-wrap gap-3 items-center">
          <span className="text-sm text-gray-500 font-medium">Filters:</span>
          <select
            value={docsFilter.source_type || ''}
            onChange={(e) => { setDocsFilter({ ...docsFilter, source_type: e.target.value || undefined }); setDocsPage(0); }}
            className="px-3 py-1.5 border border-gray-300 rounded-lg text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Sources</option>
            <option value="pdf">PDF</option>
            <option value="html">HTML</option>
            <option value="json">JSON (Seed)</option>
          </select>
          <select
            value={docsFilter.doc_type || ''}
            onChange={(e) => { setDocsFilter({ ...docsFilter, doc_type: e.target.value || undefined }); setDocsPage(0); }}
            className="px-3 py-1.5 border border-gray-300 rounded-lg text-sm bg-white focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">All Types</option>
            <option value="development_scheme">Development Scheme</option>
            <option value="development_charges">Development Charges</option>
            <option value="infrastructure_plan">Infrastructure Plan</option>
            <option value="context_plan">Context Plan</option>
            <option value="fact_sheet">Fact Sheet</option>
            <option value="government_pdf">Government PDF</option>
            <option value="development_overview">Development Overview</option>
          </select>
          <span className="text-sm text-gray-400 ml-auto">
            {docsTotal} document{docsTotal !== 1 ? 's' : ''}
          </span>
        </div>

        {/* Document Table */}
        <div className="bg-white rounded-xl shadow-sm border overflow-hidden">
          {docsLoading ? (
            <div className="text-center py-12 text-gray-400">Loading documents...</div>
          ) : documents.length === 0 ? (
            <div className="text-center py-12 text-gray-400">No documents found</div>
          ) : (
            <>
              <div className="overflow-x-auto">
                <table className="min-w-full">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Title</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Type</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden lg:table-cell">Source</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Size</th>
                      <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {documents.map((doc) => (
                      <tr key={doc.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-6 py-3">
                          <div className="flex items-center gap-2.5">
                            <span className={`w-2.5 h-2.5 rounded-full flex-shrink-0 ${
                              doc.source_type === 'pdf' ? 'bg-red-400' :
                              doc.source_type === 'html' ? 'bg-blue-400' : 'bg-gray-400'
                            }`} />
                            <a
                              href={doc.url}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="text-sm text-gray-800 hover:text-blue-600 truncate max-w-xs transition-colors"
                              title={doc.title}
                            >
                              {truncateText(doc.title || doc.url, 55)}
                            </a>
                          </div>
                        </td>
                        <td className="px-6 py-3 hidden md:table-cell">
                          {doc.doc_type ? (
                            <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                              DOC_TYPE_COLORS[doc.doc_type] || 'bg-gray-100 text-gray-600'
                            }`}>
                              {formatDocType(doc.doc_type)}
                            </span>
                          ) : (
                            <span className="text-xs text-gray-300">-</span>
                          )}
                        </td>
                        <td className="px-6 py-3 hidden lg:table-cell">
                          <span className="text-xs text-gray-500 uppercase">{doc.source_type}</span>
                        </td>
                        <td className="px-6 py-3 text-xs text-gray-500 hidden md:table-cell">
                          {formatFileSize(doc.file_size)}
                        </td>
                        <td className="px-6 py-3 text-xs text-gray-500">
                          {formatDate(doc.created_at)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Pagination */}
              {docsTotal > 20 && (
                <div className="flex justify-between items-center px-6 py-3 bg-gray-50 border-t">
                  <button
                    onClick={() => setDocsPage(Math.max(0, docsPage - 1))}
                    disabled={docsPage === 0}
                    className="px-3 py-1.5 text-sm border rounded-lg hover:bg-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                  >
                    ← Previous
                  </button>
                  <span className="text-xs text-gray-500">
                    Page {docsPage + 1} of {Math.ceil(docsTotal / 20)}
                  </span>
                  <button
                    onClick={() => setDocsPage(docsPage + 1)}
                    disabled={(docsPage + 1) * 20 >= docsTotal}
                    className="px-3 py-1.5 text-sm border rounded-lg hover:bg-white disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                  >
                    Next →
                  </button>
                </div>
              )}
            </>
          )}
        </div>
      </div>
    );
  }

  // ====== Tab: Sources ======

  function renderSources() {
    if (sourcesLoading) {
      return <div className="text-center py-12 text-gray-400">Loading sources...</div>;
    }

    return (
      <div className="space-y-4">
        <div className="bg-white rounded-xl shadow-sm border overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Source</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Priority</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Type</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden lg:table-cell">Frequency</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Docs</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider hidden md:table-cell">Last Crawl</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100">
                {sources.map((src) => (
                  <tr key={src.source_name} className="hover:bg-gray-50 transition-colors">
                    <td className="px-6 py-3">
                      <div>
                        <a
                          href={src.base_url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-sm text-gray-800 hover:text-blue-600 font-medium transition-colors"
                        >
                          {src.source_name.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}
                        </a>
                        <p className="text-xs text-gray-400 truncate max-w-xs">{src.base_url}</p>
                      </div>
                    </td>
                    <td className="px-6 py-3 hidden md:table-cell">
                      <span className={`px-2 py-0.5 rounded text-xs font-medium ${
                        PRIORITY_COLORS[src.priority] || 'bg-gray-100 text-gray-600'
                      }`}>
                        {src.priority}
                      </span>
                    </td>
                    <td className="px-6 py-3 text-xs text-gray-500 uppercase hidden md:table-cell">
                      {src.source_type}
                    </td>
                    <td className="px-6 py-3 text-xs text-gray-500 hidden lg:table-cell capitalize">
                      {src.crawl_frequency}
                    </td>
                    <td className="px-6 py-3 text-sm text-gray-700 font-medium">
                      {src.total_documents}
                    </td>
                    <td className="px-6 py-3 text-xs text-gray-500 hidden md:table-cell">
                      {formatTimeAgo(src.last_crawled_at)}
                    </td>
                    <td className="px-6 py-3">
                      {src.is_active ? (
                        <span className="inline-flex items-center gap-1">
                          <span className={`w-2 h-2 rounded-full ${
                            src.consecutive_failures > 2 ? 'bg-red-500' :
                            src.consecutive_failures > 0 ? 'bg-yellow-500' :
                            'bg-green-500'
                          }`} />
                          <span className="text-xs text-gray-500">
                            {src.consecutive_failures > 2 ? 'Failing' :
                             src.consecutive_failures > 0 ? 'Warning' :
                             'Active'}
                          </span>
                        </span>
                      ) : (
                        <span className="text-xs text-gray-400">Disabled</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    );
  }
}

// ====== Sub-Components ======

function StatCard({ label, value, sub, color }: { label: string; value: number | string; sub: string; color: string }) {
  const colorMap: Record<string, { bg: string; text: string; iconBg: string }> = {
    blue:   { bg: 'bg-blue-50',   text: 'text-blue-600',   iconBg: 'bg-blue-100' },
    purple: { bg: 'bg-purple-50', text: 'text-purple-600', iconBg: 'bg-purple-100' },
    green:  { bg: 'bg-green-50',  text: 'text-green-600',  iconBg: 'bg-green-100' },
    amber:  { bg: 'bg-amber-50',  text: 'text-amber-600',  iconBg: 'bg-amber-100' },
    gray:   { bg: 'bg-gray-50',   text: 'text-gray-500',   iconBg: 'bg-gray-100' },
  };

  const c = colorMap[color] || colorMap.gray;

  return (
    <div className="bg-white rounded-xl shadow-sm border p-5">
      <p className="text-xs text-gray-500 font-medium uppercase tracking-wider mb-2">{label}</p>
      <p className={`text-3xl font-bold ${c.text}`}>
        {typeof value === 'number' ? value.toLocaleString() : value}
      </p>
      <p className="text-xs text-gray-400 mt-1">{sub}</p>
    </div>
  );
}

function SimilarityBadge({ value }: { value: number }) {
  const pct = (value * 100).toFixed(1);
  const cls = value > 0.7 ? 'bg-green-100 text-green-700' :
              value > 0.5 ? 'bg-blue-100 text-blue-700' :
              value > 0.3 ? 'bg-yellow-100 text-yellow-700' :
              'bg-gray-100 text-gray-600';
  return (
    <span className={`text-xs font-mono px-2 py-0.5 rounded-full ${cls}`}>
      {pct}%
    </span>
  );
}
