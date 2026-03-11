'use client';

import { useState, useEffect, useCallback } from 'react';
import Link from 'next/link';
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
  return d.toLocaleDateString('zh-CN', { year: 'numeric', month: 'short', day: 'numeric' });
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

// ====== Main Component ======

export default function DevIntelPage() {
  // Tab state
  const [activeTab, setActiveTab] = useState<'overview' | 'search' | 'documents'>('overview');

  // Overview state
  const [stats, setStats] = useState<Stats | null>(null);
  const [statsLoading, setStatsLoading] = useState(true);

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

  // Crawl state
  const [crawlStatus, setCrawlStatus] = useState<CrawlStatus>({ running: false, last_result: null });

  // ====== Data Loading ======

  useEffect(() => {
    loadStats();
  }, []);

  useEffect(() => {
    if (activeTab === 'documents') {
      loadDocuments();
    }
  }, [activeTab, docsFilter, docsPage]);

  const loadStats = async () => {
    setStatsLoading(true);
    try {
      const data = await fetcher('/api/devintel/stats');
      setStats(data);
    } catch (e) {
      console.error('Failed to load stats:', e);
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

  // ====== Render ======

  return (
    <>
      <Navbar activePage="devintel" />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        {/* Header */}
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-gray-900">Development Intelligence</h1>
          <p className="text-gray-500 mt-1">Brisbane development knowledge base - PDF documents, government data, and RAG-powered search</p>
        </div>

        {/* Tabs */}
        <div className="flex border-b mb-6">
          {[
            { key: 'overview', label: 'Overview' },
            { key: 'search', label: 'Search' },
            { key: 'documents', label: 'Documents' },
          ].map(tab => (
            <button
              key={tab.key}
              className={`px-4 py-2 text-sm font-medium border-b-2 transition ${
                activeTab === tab.key
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
              onClick={() => setActiveTab(tab.key as any)}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* Tab Content */}
        {activeTab === 'overview' && renderOverview()}
        {activeTab === 'search' && renderSearch()}
        {activeTab === 'documents' && renderDocuments()}
      </div>
    </>
  );

  // ====== Tab Renderers ======

  function renderOverview() {
    if (statsLoading || !stats) {
      return <div className="text-center py-12 text-gray-400">Loading...</div>;
    }

    return (
      <div className="space-y-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <StatCard label="Documents" value={stats.documents.total} icon="doc" />
          <StatCard label="PDF Files" value={stats.documents.pdf} icon="pdf" />
          <StatCard label="Vector Chunks" value={stats.chunks.total} icon="chunk" />
          <StatCard
            label="Total Tokens"
            value={`${(stats.chunks.total_tokens / 1000).toFixed(0)}K`}
            icon="token"
          />
        </div>

        {/* Two columns: Projects + Doc Types */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* By Project */}
          <div className="bg-white rounded-lg border p-4">
            <h3 className="font-semibold text-gray-800 mb-3">By Project</h3>
            <div className="space-y-2">
              {stats.by_project.slice(0, 10).map((item) => (
                <div key={item.project} className="flex justify-between items-center">
                  <span className="text-sm text-gray-600 truncate mr-2">{item.project}</span>
                  <div className="flex items-center gap-2">
                    <div
                      className="h-2 bg-blue-400 rounded-full"
                      style={{ width: `${Math.max(20, (item.cnt / stats.by_project[0].cnt) * 120)}px` }}
                    />
                    <span className="text-xs text-gray-500 w-6 text-right">{item.cnt}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* By Doc Type */}
          <div className="bg-white rounded-lg border p-4">
            <h3 className="font-semibold text-gray-800 mb-3">By Document Type</h3>
            <div className="flex flex-wrap gap-2">
              {stats.by_doc_type.map((item) => (
                <span
                  key={item.doc_type}
                  className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${
                    DOC_TYPE_COLORS[item.doc_type] || 'bg-gray-100 text-gray-600'
                  }`}
                >
                  {formatDocType(item.doc_type)}
                  <span className="opacity-70">({item.cnt})</span>
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* Recent Crawls + Crawl Control */}
        <div className="grid md:grid-cols-2 gap-6">
          <div className="bg-white rounded-lg border p-4">
            <h3 className="font-semibold text-gray-800 mb-3">Recent Crawls</h3>
            {stats.recent_crawls.length === 0 ? (
              <p className="text-sm text-gray-400">No crawl history</p>
            ) : (
              <div className="space-y-2">
                {stats.recent_crawls.map((crawl, i) => (
                  <div key={i} className="flex justify-between items-center text-sm">
                    <div>
                      <span className="text-gray-700">{crawl.source_name}</span>
                      <span className="text-gray-400 ml-2">{formatDate(crawl.started_at)}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className={`px-1.5 py-0.5 rounded text-xs ${
                        crawl.status === 'completed' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700'
                      }`}>
                        {crawl.status}
                      </span>
                      <span className="text-gray-500 text-xs">
                        +{crawl.pages_new} docs, {crawl.chunks_created} chunks
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          <div className="bg-white rounded-lg border p-4">
            <h3 className="font-semibold text-gray-800 mb-3">Manual Crawl</h3>
            <p className="text-sm text-gray-500 mb-3">
              Trigger a manual crawl of data sources. The daily auto-crawl runs at 3:00 AM AEST.
            </p>
            <div className="flex gap-2">
              <button
                onClick={() => triggerCrawl('P1')}
                disabled={crawlStatus.running}
                className="px-3 py-1.5 bg-blue-600 text-white text-sm rounded hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition"
              >
                {crawlStatus.running ? 'Running...' : 'Crawl P1 Sources'}
              </button>
              <button
                onClick={() => triggerCrawl()}
                disabled={crawlStatus.running}
                className="px-3 py-1.5 bg-gray-600 text-white text-sm rounded hover:bg-gray-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition"
              >
                Crawl All
              </button>
            </div>
            {crawlStatus.running && (
              <div className="mt-2 flex items-center gap-2 text-sm text-blue-600">
                <span className="animate-spin inline-block w-4 h-4 border-2 border-blue-600 border-t-transparent rounded-full" />
                Crawling in progress...
              </div>
            )}
            {stats.documents.ocr_needed > 0 && (
              <p className="mt-3 text-xs text-amber-600">
                {stats.documents.ocr_needed} scanned PDFs need OCR processing (Phase 3)
              </p>
            )}
          </div>
        </div>
      </div>
    );
  }

  function renderSearch() {
    return (
      <div className="space-y-4">
        {/* Search Form */}
        <div className="bg-white rounded-lg border p-4">
          <div className="flex flex-col md:flex-row gap-3">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
              placeholder="Search development intelligence... e.g. Cross River Rail, infrastructure charges"
              className="flex-1 px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <input
              type="text"
              value={searchSuburb}
              onChange={(e) => setSearchSuburb(e.target.value)}
              placeholder="Suburb (optional)"
              className="w-full md:w-40 px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
            <select
              value={searchDocType}
              onChange={(e) => setSearchDocType(e.target.value)}
              className="w-full md:w-44 px-3 py-2 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white"
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
              className="px-4 py-2 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 disabled:bg-gray-300 transition whitespace-nowrap"
            >
              {searching ? 'Searching...' : 'Search'}
            </button>
          </div>
        </div>

        {/* Results */}
        {searching && (
          <div className="text-center py-8 text-gray-400">
            <span className="animate-spin inline-block w-5 h-5 border-2 border-blue-600 border-t-transparent rounded-full mr-2" />
            Searching vector database...
          </div>
        )}

        {searchDone && searchResults.length === 0 && (
          <div className="text-center py-8 text-gray-400">No results found</div>
        )}

        {searchResults.length > 0 && (
          <div className="space-y-3">
            <p className="text-sm text-gray-500">{searchResults.length} results found</p>
            {searchResults.map((result, i) => (
              <div key={i} className="bg-white rounded-lg border p-4 hover:shadow-sm transition">
                <div className="flex items-start justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-medium text-gray-800">
                      {result.title || result.source_name}
                    </span>
                    {result.doc_type && (
                      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${
                        DOC_TYPE_COLORS[result.doc_type] || 'bg-gray-100 text-gray-600'
                      }`}>
                        {formatDocType(result.doc_type)}
                      </span>
                    )}
                  </div>
                  <span className={`text-xs font-mono px-2 py-0.5 rounded ${
                    result.similarity > 0.7 ? 'bg-green-100 text-green-700' :
                    result.similarity > 0.5 ? 'bg-blue-100 text-blue-700' :
                    'bg-gray-100 text-gray-600'
                  }`}>
                    {(result.similarity * 100).toFixed(1)}%
                  </span>
                </div>
                <p className="text-sm text-gray-600 leading-relaxed">
                  {truncateText(result.chunk_text, 300)}
                </p>
                {result.url && (
                  <a
                    href={result.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-xs text-blue-500 hover:text-blue-700 mt-2 inline-block truncate max-w-md"
                  >
                    {result.url}
                  </a>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  function renderDocuments() {
    return (
      <div className="space-y-4">
        {/* Filters */}
        <div className="flex flex-wrap gap-2">
          <select
            value={docsFilter.source_type || ''}
            onChange={(e) => { setDocsFilter({ ...docsFilter, source_type: e.target.value || undefined }); setDocsPage(0); }}
            className="px-3 py-1.5 border rounded text-sm bg-white"
          >
            <option value="">All Sources</option>
            <option value="pdf">PDF</option>
            <option value="html">HTML</option>
            <option value="json">JSON (Seed)</option>
          </select>
          <select
            value={docsFilter.doc_type || ''}
            onChange={(e) => { setDocsFilter({ ...docsFilter, doc_type: e.target.value || undefined }); setDocsPage(0); }}
            className="px-3 py-1.5 border rounded text-sm bg-white"
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
          <span className="text-sm text-gray-400 self-center ml-2">
            {docsTotal} documents
          </span>
        </div>

        {/* Document Table */}
        {docsLoading ? (
          <div className="text-center py-8 text-gray-400">Loading documents...</div>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b bg-gray-50">
                    <th className="text-left py-2 px-3 font-medium text-gray-600">Title</th>
                    <th className="text-left py-2 px-3 font-medium text-gray-600 hidden md:table-cell">Type</th>
                    <th className="text-left py-2 px-3 font-medium text-gray-600 hidden lg:table-cell">Source</th>
                    <th className="text-left py-2 px-3 font-medium text-gray-600 hidden md:table-cell">Size</th>
                    <th className="text-left py-2 px-3 font-medium text-gray-600">Date</th>
                  </tr>
                </thead>
                <tbody>
                  {documents.map((doc) => (
                    <tr key={doc.id} className="border-b hover:bg-gray-50 transition">
                      <td className="py-2 px-3">
                        <div className="flex items-center gap-2">
                          <span className={`w-2 h-2 rounded-full flex-shrink-0 ${
                            doc.source_type === 'pdf' ? 'bg-red-400' :
                            doc.source_type === 'html' ? 'bg-blue-400' : 'bg-gray-400'
                          }`} />
                          <a
                            href={doc.url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="text-gray-800 hover:text-blue-600 truncate max-w-xs"
                            title={doc.title}
                          >
                            {truncateText(doc.title || doc.url, 50)}
                          </a>
                        </div>
                      </td>
                      <td className="py-2 px-3 hidden md:table-cell">
                        {doc.doc_type && (
                          <span className={`px-2 py-0.5 rounded-full text-xs ${
                            DOC_TYPE_COLORS[doc.doc_type] || 'bg-gray-100 text-gray-600'
                          }`}>
                            {formatDocType(doc.doc_type)}
                          </span>
                        )}
                      </td>
                      <td className="py-2 px-3 text-gray-500 hidden lg:table-cell">
                        {doc.source_type.toUpperCase()}
                      </td>
                      <td className="py-2 px-3 text-gray-500 hidden md:table-cell">
                        {formatFileSize(doc.file_size)}
                      </td>
                      <td className="py-2 px-3 text-gray-500 text-xs">
                        {formatDate(doc.created_at)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            {docsTotal > 20 && (
              <div className="flex justify-center gap-2 pt-2">
                <button
                  onClick={() => setDocsPage(Math.max(0, docsPage - 1))}
                  disabled={docsPage === 0}
                  className="px-3 py-1 text-sm border rounded hover:bg-gray-50 disabled:opacity-30"
                >
                  Previous
                </button>
                <span className="text-sm text-gray-500 self-center">
                  Page {docsPage + 1} of {Math.ceil(docsTotal / 20)}
                </span>
                <button
                  onClick={() => setDocsPage(docsPage + 1)}
                  disabled={(docsPage + 1) * 20 >= docsTotal}
                  className="px-3 py-1 text-sm border rounded hover:bg-gray-50 disabled:opacity-30"
                >
                  Next
                </button>
              </div>
            )}
          </>
        )}
      </div>
    );
  }
}

// ====== Sub-Components ======

function StatCard({ label, value, icon }: { label: string; value: number | string; icon: string }) {
  const iconBg: Record<string, string> = {
    doc: 'bg-blue-50 text-blue-600',
    pdf: 'bg-red-50 text-red-600',
    chunk: 'bg-purple-50 text-purple-600',
    token: 'bg-green-50 text-green-600',
  };

  const iconSymbol: Record<string, string> = {
    doc: 'D',
    pdf: 'P',
    chunk: 'V',
    token: 'T',
  };

  return (
    <div className="bg-white rounded-lg border p-4">
      <div className="flex items-center gap-3">
        <div className={`w-10 h-10 rounded-lg flex items-center justify-center text-lg font-bold ${iconBg[icon] || 'bg-gray-50'}`}>
          {iconSymbol[icon] || '?'}
        </div>
        <div>
          <p className="text-2xl font-bold text-gray-900">{typeof value === 'number' ? value.toLocaleString() : value}</p>
          <p className="text-xs text-gray-500">{label}</p>
        </div>
      </div>
    </div>
  );
}
