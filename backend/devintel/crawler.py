"""
DevIntel Crawler - Production web crawler for government data sources.

Crawls registered data sources (HTML pages + PDF documents):
1. Fetches page content
2. Discovers linked PDFs
3. Parses content using parser.py
4. Chunks, embeds, and stores in vector DB
5. Logs crawl activity

Supports incremental crawling with content_hash change detection.
"""

import hashlib
import json
import re
import ssl
import time
import urllib.request
import urllib.parse
from datetime import datetime
from typing import Dict, List, Optional, Tuple

import os, sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import execute_query
from devintel.parser import parse_html, parse_pdf
from devintel.chunker import chunk_text, count_tokens
from devintel.embedder import embed_texts
from devintel.config import DEVINTEL_SOURCES

# ====== Constants ======

_BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/131.0.0.0 Safari/537.36"
)

MAX_PDF_SIZE = 20 * 1024 * 1024   # 20 MB
MAX_PDF_PAGES = 50
DOWNLOAD_TIMEOUT = 60
FETCH_TIMEOUT = 30

# PDF filename patterns to skip
_SKIP_PDF_PATTERNS = [
    "brochure", "flyer", "newsletter",
    "house-and-land", "house_and_land", "houseandland",
    "display-village", "display_village",
    "thumbnail", "logo", "banner",
]


# ====== HTTP Helpers ======

def _make_hash(text: str) -> str:
    return hashlib.md5(text.encode()).hexdigest()


def _ssl_context():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


def fetch_page(url: str, timeout: int = FETCH_TIMEOUT) -> Tuple[bytes, str, str]:
    """
    Fetch a web page.

    Returns:
        (raw_bytes, content_type, final_url)
    """
    req = urllib.request.Request(url, headers={
        "User-Agent": _BROWSER_UA,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,application/pdf,*/*;q=0.8",
        "Accept-Language": "en-AU,en;q=0.9",
    })

    with urllib.request.urlopen(req, timeout=timeout, context=_ssl_context()) as resp:
        raw = resp.read(MAX_PDF_SIZE + 1)
        content_type = resp.headers.get("Content-Type", "")
        final_url = resp.url
        return raw, content_type, final_url


def _is_pdf_url(url: str) -> bool:
    path = urllib.parse.urlparse(url).path.lower()
    return path.endswith('.pdf')


def _is_valuable_pdf(filename: str) -> bool:
    """Check if PDF filename suggests it's worth crawling."""
    lower = filename.lower()
    return not any(kw in lower for kw in _SKIP_PDF_PATTERNS)


def _discover_pdf_links(html: str, base_url: str) -> List[str]:
    """Find PDF links within an HTML page."""
    links = re.findall(r'href=["\']([^"\']+)["\']', html, re.IGNORECASE)
    pdfs = []
    seen = set()
    for link in links:
        if link.startswith(('#', 'javascript:', 'mailto:', 'tel:')):
            continue
        full_url = urllib.parse.urljoin(base_url, link)
        if full_url in seen:
            continue
        seen.add(full_url)
        if _is_pdf_url(full_url):
            filename = urllib.parse.unquote(urllib.parse.urlparse(full_url).path.split('/')[-1])
            if _is_valuable_pdf(filename):
                pdfs.append(full_url)
    return pdfs


# ====== Document Storage ======

def _store_document(
    url: str,
    title: str,
    source_name: str,
    source_type: str,
    text: str,
    doc_type: Optional[str],
    suburb: Optional[str],
    suburbs: List[str],
    metadata: Dict,
    file_size: Optional[int] = None,
    page_count: Optional[int] = None,
    ocr_required: bool = False,
) -> Optional[int]:
    """
    Store or update a document in the database.
    Returns the document ID if stored/updated, None if unchanged.
    """
    url_hash = _make_hash(url)
    content_hash = _make_hash(text) if text else None

    existing = execute_query(
        "SELECT id, content_hash FROM devintel_documents WHERE url_hash = %s",
        (url_hash,)
    )

    if existing:
        old_hash = existing[0].get("content_hash", "")
        if old_hash == content_hash:
            return None  # Unchanged

        doc_id = existing[0]["id"]
        execute_query("""
            UPDATE devintel_documents
            SET content_text = %s, content_hash = %s, previous_hash = %s,
                version = version + 1, change_detected_at = NOW(),
                title = %s, parse_status = %s, updated_at = NOW(),
                metadata = %s::jsonb, crawl_status = 'completed',
                last_crawled_at = NOW(), doc_type = %s,
                suburb = %s, source_type = %s,
                file_size = %s, ocr_required = %s
            WHERE id = %s
        """, (
            text, content_hash, old_hash,
            title, 'parsed' if text else 'failed',
            json.dumps(metadata), doc_type,
            suburb, source_type,
            file_size, ocr_required,
            doc_id,
        ))
        # Clear old chunks for re-embedding
        execute_query("DELETE FROM devintel_chunks WHERE document_id = %s", (doc_id,))
        return doc_id
    else:
        suburbs_arr = "{" + ",".join(f'"{s}"' for s in suburbs) + "}" if suburbs else None
        execute_query("""
            INSERT INTO devintel_documents
            (url_hash, url, title, source_name, source_type, content_text,
             content_hash, suburb, suburbs, doc_type, parse_status, metadata,
             crawl_status, last_crawled_at, file_size, ocr_required)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s::text[], %s, %s, %s::jsonb,
                    'completed', NOW(), %s, %s)
        """, (
            url_hash, url, title, source_name, source_type,
            text, content_hash,
            suburb, suburbs_arr, doc_type,
            'parsed' if text else 'failed',
            json.dumps(metadata),
            file_size, ocr_required,
        ))
        result = execute_query(
            "SELECT id FROM devintel_documents WHERE url_hash = %s", (url_hash,)
        )
        return result[0]["id"]


def _embed_and_store_chunks(
    doc_id: int,
    text: str,
    source_name: str,
    doc_type: Optional[str],
    suburb: Optional[str],
    metadata: Dict,
) -> int:
    """Chunk text, embed, and store. Returns number of chunks created."""
    chunks = chunk_text(text)
    if not chunks:
        return 0

    chunk_texts = [ct for ct, _ in chunks]
    embeddings = embed_texts(chunk_texts)

    stored = 0
    for idx, ((ct, tc), embedding) in enumerate(zip(chunks, embeddings)):
        embedding_str = "[" + ",".join(str(x) for x in embedding) + "]"
        try:
            execute_query("""
                INSERT INTO devintel_chunks
                (document_id, chunk_index, chunk_text, token_count, embedding,
                 suburb, doc_type, source_name, metadata)
                VALUES (%s, %s, %s, %s, %s::vector, %s, %s, %s, %s::jsonb)
                ON CONFLICT (document_id, chunk_index) DO UPDATE SET
                    chunk_text = EXCLUDED.chunk_text,
                    token_count = EXCLUDED.token_count,
                    embedding = EXCLUDED.embedding,
                    metadata = EXCLUDED.metadata
            """, (
                doc_id, idx, ct, tc, embedding_str,
                suburb, doc_type, source_name,
                json.dumps(metadata),
            ))
            stored += 1
        except Exception as e:
            print(f"    [ERROR] Chunk {idx} for doc {doc_id}: {e}")

    return stored


# ====== Source Crawlers ======

def crawl_source(source_config: dict) -> dict:
    """
    Crawl a single data source.

    Args:
        source_config: Dict from devintel_sources table or DEVINTEL_SOURCES config

    Returns:
        Dict with crawl results: pages_found, pages_new, pages_updated, etc.
    """
    source_name = source_config["source_name"]
    base_url = source_config["base_url"]
    source_type = source_config.get("source_type", "html")

    result = {
        "source_name": source_name,
        "pages_found": 0,
        "pages_new": 0,
        "pages_updated": 0,
        "pages_failed": 0,
        "pages_unchanged": 0,
        "chunks_created": 0,
        "errors": [],
    }

    # Start crawl log
    try:
        execute_query("""
            INSERT INTO devintel_crawl_logs
            (source_name, crawl_type, status, started_at)
            VALUES (%s, %s, %s, NOW())
        """, (source_name, "scheduled", "running"))
    except Exception:
        pass

    print(f"  [Crawl] {source_name}: {base_url}")

    try:
        # Fetch the main page
        raw, content_type, final_url = fetch_page(base_url)

        if "pdf" in content_type.lower() or _is_pdf_url(base_url):
            # Direct PDF source
            _crawl_single_pdf(base_url, source_name, raw, result)
        else:
            # HTML source — parse page and discover PDFs
            charset = "utf-8"
            ct_match = re.search(r'charset=([^\s;]+)', content_type)
            if ct_match:
                charset = ct_match.group(1)
            html = raw.decode(charset, errors="replace")

            _crawl_html_page(final_url, source_name, html, result)

            # Discover and crawl linked PDFs
            pdf_links = _discover_pdf_links(html, final_url)
            result["pages_found"] += len(pdf_links)
            for pdf_url in pdf_links:
                try:
                    _crawl_pdf_url(pdf_url, source_name, result)
                    time.sleep(0.3)  # Polite delay
                except Exception as e:
                    result["pages_failed"] += 1
                    result["errors"].append(f"PDF {pdf_url}: {e}")

    except Exception as e:
        result["pages_failed"] += 1
        result["errors"].append(f"Main page: {e}")
        print(f"    FAILED: {e}")

    # Update crawl log
    try:
        execute_query("""
            UPDATE devintel_crawl_logs
            SET finished_at = NOW(), pages_found = %s, pages_new = %s,
                pages_updated = %s, pages_failed = %s, chunks_created = %s,
                status = %s,
                error_message = %s
            WHERE source_name = %s AND status = 'running'
        """, (
            result["pages_found"], result["pages_new"],
            result["pages_updated"], result["pages_failed"],
            result["chunks_created"],
            "completed" if not result["errors"] else "completed_with_errors",
            "; ".join(result["errors"][:5]) if result["errors"] else None,
            source_name,
        ))
    except Exception:
        pass

    # Update source status
    try:
        if result["pages_new"] + result["pages_updated"] > 0:
            execute_query("""
                UPDATE devintel_sources
                SET last_crawled_at = NOW(), last_success_at = NOW(),
                    consecutive_failures = 0,
                    total_documents = (SELECT COUNT(*) FROM devintel_documents WHERE source_name = %s),
                    updated_at = NOW()
                WHERE source_name = %s
            """, (source_name, source_name))
        elif result["pages_failed"] > 0 and result["pages_new"] == 0:
            execute_query("""
                UPDATE devintel_sources
                SET last_crawled_at = NOW(),
                    consecutive_failures = consecutive_failures + 1,
                    updated_at = NOW()
                WHERE source_name = %s
            """, (source_name,))
        else:
            execute_query("""
                UPDATE devintel_sources
                SET last_crawled_at = NOW(), updated_at = NOW()
                WHERE source_name = %s
            """, (source_name,))
    except Exception:
        pass

    return result


def _crawl_html_page(url: str, source_name: str, html: str, result: dict):
    """Process a single HTML page."""
    result["pages_found"] += 1

    parsed = parse_html(html, {"source_name": source_name})
    text = parsed["text"]
    title = parsed["title"]

    if not text or len(text.strip()) < 50:
        print(f"    HTML: too little content ({len(text)} chars)")
        return

    suburb = parsed["suburbs"][0] if parsed["suburbs"] else None
    doc_type = parsed["doc_type"] or "web_page"
    metadata = parsed["metadata"]

    doc_id = _store_document(
        url=url, title=title, source_name=source_name, source_type="html",
        text=text, doc_type=doc_type, suburb=suburb,
        suburbs=parsed["suburbs"], metadata=metadata,
    )

    if doc_id is None:
        result["pages_unchanged"] += 1
        print(f"    HTML: unchanged")
        return

    # Embed chunks
    n_chunks = _embed_and_store_chunks(
        doc_id, text, source_name, doc_type, suburb, metadata
    )
    result["pages_new"] += 1
    result["chunks_created"] += n_chunks
    print(f"    HTML: {len(text)} chars, {n_chunks} chunks")


def _crawl_pdf_url(url: str, source_name: str, result: dict):
    """Download and process a single PDF URL."""
    filename = urllib.parse.unquote(urllib.parse.urlparse(url).path.split('/')[-1])
    print(f"    PDF: {filename[:60]}")

    try:
        raw, content_type, _ = fetch_page(url, timeout=DOWNLOAD_TIMEOUT)
    except Exception as e:
        result["pages_failed"] += 1
        print(f"      Download failed: {e}")
        return

    _crawl_single_pdf(url, source_name, raw, result, filename=filename)


def _crawl_single_pdf(
    url: str, source_name: str, pdf_bytes: bytes, result: dict,
    filename: str = ""
):
    """Process PDF bytes."""
    if len(pdf_bytes) > MAX_PDF_SIZE:
        print(f"      Too large ({len(pdf_bytes) / 1024 / 1024:.1f} MB)")
        result["pages_failed"] += 1
        return

    file_size = len(pdf_bytes)

    try:
        parsed = parse_pdf(pdf_bytes, max_pages=MAX_PDF_PAGES)
    except Exception as e:
        print(f"      Parse failed: {e}")
        result["pages_failed"] += 1
        _store_document(
            url=url, title=filename, source_name=source_name, source_type="pdf",
            text="", doc_type=None, suburb=None, suburbs=[],
            metadata={"parse_error": str(e)}, file_size=file_size,
        )
        return

    text = parsed["text"]
    page_count = parsed["page_count"]
    ocr_required = parsed["ocr_required"]

    if ocr_required or len(text.strip()) < 100:
        print(f"      Scanned PDF (needs OCR)")
        _store_document(
            url=url, title=filename or parsed.get("title", ""),
            source_name=source_name, source_type="pdf",
            text=text, doc_type=None, suburb=None, suburbs=[],
            metadata=parsed.get("metadata", {}),
            file_size=file_size, ocr_required=True,
        )
        result["pages_new"] += 1
        return

    doc_title = filename.replace('.pdf', '').replace('-', ' ').replace('_', ' ').title()
    if parsed.get("title"):
        doc_title = parsed["title"]

    suburb = parsed["suburbs"][0] if parsed.get("suburbs") else None
    doc_type = parsed.get("doc_type") or "government_pdf"
    metadata = parsed.get("metadata", {})
    metadata["pdf_pages"] = page_count
    metadata["pdf_size_kb"] = round(file_size / 1024, 1)

    doc_id = _store_document(
        url=url, title=doc_title, source_name=source_name, source_type="pdf",
        text=text, doc_type=doc_type, suburb=suburb,
        suburbs=parsed.get("suburbs", []), metadata=metadata,
        file_size=file_size, page_count=page_count,
    )

    if doc_id is None:
        result["pages_unchanged"] += 1
        print(f"      Unchanged")
        return

    n_chunks = _embed_and_store_chunks(
        doc_id, text, source_name, doc_type, suburb, metadata
    )
    result["pages_new"] += 1
    result["chunks_created"] += n_chunks
    print(f"      {page_count} pages, {len(text)} chars, {n_chunks} chunks")


# ====== Crawl All ======

def crawl_all_sources(priority_filter: Optional[str] = None) -> Dict:
    """
    Crawl all active sources due for refresh.

    Args:
        priority_filter: Optional "P1", "P2", "P3" to limit scope

    Returns:
        Aggregated crawl results
    """
    if priority_filter:
        sources = execute_query(
            "SELECT * FROM devintel_sources WHERE is_active = TRUE AND priority = %s ORDER BY source_name",
            (priority_filter,)
        )
    else:
        sources = execute_query(
            "SELECT * FROM devintel_sources WHERE is_active = TRUE ORDER BY priority, source_name"
        )

    if not sources:
        print("[DevIntel] No active sources found")
        return {"total_sources": 0}

    print(f"\n{'='*60}")
    print(f"DevIntel Crawl: {len(sources)} active sources")
    print(f"{'='*60}")

    total = {
        "total_sources": len(sources),
        "sources_success": 0,
        "sources_failed": 0,
        "total_pages": 0,
        "total_new": 0,
        "total_updated": 0,
        "total_chunks": 0,
    }

    for source in sources:
        try:
            result = crawl_source(source)
            total["total_pages"] += result["pages_found"]
            total["total_new"] += result["pages_new"]
            total["total_updated"] += result["pages_updated"]
            total["total_chunks"] += result["chunks_created"]
            total["sources_success"] += 1
        except Exception as e:
            print(f"  [ERROR] {source['source_name']}: {e}")
            total["sources_failed"] += 1

        time.sleep(1)  # Polite delay between sources

    print(f"\n{'='*60}")
    print(f"Crawl Summary: {total['sources_success']}/{total['total_sources']} sources")
    print(f"  Pages: {total['total_pages']} found, {total['total_new']} new")
    print(f"  Chunks: {total['total_chunks']} created")
    print(f"{'='*60}")

    return total


def crawl_specific_urls(urls: List[str], source_name: str = "manual") -> Dict:
    """
    Crawl specific URLs on demand (for manual crawl trigger).

    Args:
        urls: List of URLs to crawl
        source_name: Source name to associate with

    Returns:
        Crawl results
    """
    result = {
        "source_name": source_name,
        "pages_found": len(urls),
        "pages_new": 0,
        "pages_updated": 0,
        "pages_failed": 0,
        "pages_unchanged": 0,
        "chunks_created": 0,
        "errors": [],
    }

    for url in urls:
        try:
            raw, content_type, final_url = fetch_page(url)

            if "pdf" in content_type.lower() or _is_pdf_url(url):
                _crawl_single_pdf(url, source_name, raw, result)
            else:
                charset = "utf-8"
                ct_match = re.search(r'charset=([^\s;]+)', content_type)
                if ct_match:
                    charset = ct_match.group(1)
                html = raw.decode(charset, errors="replace")
                _crawl_html_page(final_url, source_name, html, result)

            time.sleep(0.5)
        except Exception as e:
            result["pages_failed"] += 1
            result["errors"].append(f"{url}: {e}")

    return result
