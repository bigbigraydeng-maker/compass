"""
DevIntel PDF Deep Crawler - Download, parse, chunk, and embed PDF documents.

Scans all data source pages for PDF links, downloads high-value documents,
extracts text with PyMuPDF, then chunks + embeds into the vector database.

Usage:
    cd backend
    python -m devintel.pdf_crawler
"""

import hashlib
import json
import os
import re
import ssl
import sys
import time
import urllib.request
import urllib.parse
from typing import List, Tuple, Dict, Optional

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from database import execute_query
from devintel.chunker import chunk_text, count_tokens
from devintel.embedder import embed_texts
from devintel.link_scanner import SCAN_TARGETS, fetch_html, extract_links, classify_links

try:
    import fitz  # PyMuPDF
    _HAS_PYMUPDF = True
except ImportError:
    _HAS_PYMUPDF = False
    print("[PDF Crawler] WARNING: PyMuPDF not installed. Run: pip install PyMuPDF")

# ====== Configuration ======

_BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/131.0.0.0 Safari/537.36"
)

# Max pages to parse per PDF document
MAX_PDF_PAGES = 50

# Max file size to download (20 MB)
MAX_FILE_SIZE = 20 * 1024 * 1024

# Download timeout in seconds
DOWNLOAD_TIMEOUT = 60

# High-value PDF keywords (filenames containing these are prioritized)
HIGH_VALUE_KEYWORDS = [
    "development-scheme", "development_scheme", "developmentscheme",
    "dcop", "ipbr",
    "submission", "submissions-report", "submissions_report",
    "fact-sheet", "factsheet", "fact_sheet",
    "precinct", "precinct-plan",
    "infrastructure-plan", "infrastructure_plan",
    "context-plan", "contextplan",
    "planning-scheme", "planningscheme",
    "amendment", "gazette",
    "cost-schedule", "costschedule",
    "strategy", "master-plan", "masterplan",
    "development-charges", "charges-schedule",
    "transport", "stormwater", "open-space",
    "pda-development", "priority-development",
    "interim-land-use",
]

# Skip PDF keywords (low-value marketing/maps)
SKIP_KEYWORDS = [
    "brochure", "flyer", "newsletter",
    "house-and-land", "house_and_land", "houseandland",
    "display-village", "display_village",
    "thumbnail", "logo", "banner",
    "application-form", "form-",
]

# Project to metadata mapping (inherit from parent page)
PROJECT_METADATA = {
    "Queen's Wharf Brisbane": {
        "project_name": "Queen's Wharf Brisbane",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "tags": ["urban_renewal", "CBD", "casino", "resort"],
    },
    "Northshore Hamilton PDA": {
        "project_name": "Northshore Hamilton PDA",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "affected_suburbs": ["Hamilton"],
        "tags": ["waterfront", "PDA", "mixed_use"],
    },
    "Woolloongabba PDA": {
        "project_name": "Woolloongabba PDA",
        "authority": "Economic Development Queensland",
        "stage": "approved",
        "affected_suburbs": ["Woolloongabba"],
        "tags": ["PDA", "Cross_River_Rail", "transit_oriented"],
    },
    "Bowen Hills PDA": {
        "project_name": "Bowen Hills PDA",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "affected_suburbs": ["Bowen Hills"],
        "tags": ["PDA", "RNA_Showgrounds"],
    },
    "Herston Quarter": {
        "project_name": "Herston Quarter",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "affected_suburbs": ["Herston"],
        "tags": ["health_precinct", "mixed_use"],
    },
    "Carseldine Village": {
        "project_name": "Carseldine Village",
        "authority": "Economic Development Queensland",
        "stage": "approved",
        "affected_suburbs": ["Carseldine"],
        "tags": ["village", "community", "education"],
    },
    "Ripley Valley PDA": {
        "project_name": "Ripley Valley PDA",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "tags": ["PDA", "Ipswich", "growth_area"],
    },
    "Yarrabilba PDA": {
        "project_name": "Yarrabilba PDA",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "tags": ["PDA", "Logan", "growth_area"],
    },
    "Greater Flagstone PDA": {
        "project_name": "Greater Flagstone PDA",
        "authority": "Economic Development Queensland",
        "stage": "approved",
        "tags": ["PDA", "Logan", "growth_area"],
    },
    "Caloundra South / Aura": {
        "project_name": "Caloundra South / Aura",
        "authority": "Economic Development Queensland",
        "stage": "under_construction",
        "tags": ["PDA", "Sunshine_Coast", "Aura"],
    },
    "Brisbane Stadium": {
        "project_name": "Brisbane Stadium",
        "authority": "GIICA / Brisbane 2032",
        "stage": "proposed",
        "tags": ["olympics", "stadium", "2032"],
    },
    "National Aquatic Centre": {
        "project_name": "National Aquatic Centre",
        "authority": "GIICA / Brisbane 2032",
        "stage": "proposed",
        "tags": ["olympics", "aquatic", "2032"],
    },
    "Mt Coot-tha": {
        "project_name": "Mt Coot-tha Precinct Transformation",
        "authority": "Brisbane City Council",
        "stage": "under_construction",
        "tags": ["parkland", "recreation", "tourism"],
    },
}

# Source name mapping by domain
DOMAIN_SOURCE_MAP = {
    "edq.qld.gov.au": "edq_priority_areas",
    "www.edq.qld.gov.au": "edq_priority_areas",
    "giica.au": "brisbane_2032",
    "brisbane.qld.gov.au": "bcc_da_tracker",
    "www.brisbane.qld.gov.au": "bcc_da_tracker",
    "publications.qld.gov.au": "qld_government_gazette",
    "statedevelopment.qld.gov.au": "qld_state_development",
}


# ====== PDF Download & Parsing ======

def _make_hash(text: str) -> str:
    return hashlib.md5(text.encode()).hexdigest()


def is_high_value_pdf(filename: str) -> bool:
    """Check if a PDF filename suggests high-value content."""
    lower = filename.lower()
    # Skip if matches skip keywords
    if any(kw in lower for kw in SKIP_KEYWORDS):
        return False
    # Accept if matches high-value keywords
    if any(kw in lower for kw in HIGH_VALUE_KEYWORDS):
        return True
    # Also accept if it looks like a government document
    # (most PDFs from gov sites are valuable by default)
    return True


def classify_pdf_type(filename: str, text_sample: str = "") -> str:
    """Classify a PDF document type from its filename and content."""
    lower = filename.lower()
    combined = (lower + " " + text_sample[:500].lower())

    if "development-scheme" in lower or "developmentscheme" in lower:
        return "development_scheme"
    if "dcop" in lower or "development charges" in combined:
        return "development_charges"
    if "ipbr" in lower or "infrastructure plan" in combined:
        return "infrastructure_plan"
    if "submission" in lower:
        return "submissions_report"
    if "fact" in lower and "sheet" in lower:
        return "fact_sheet"
    if "precinct" in lower:
        return "precinct_plan"
    if "context-plan" in lower or "contextplan" in lower:
        return "context_plan"
    if "amendment" in lower:
        return "scheme_amendment"
    if "gazette" in lower:
        return "gazette_notice"
    if "cost" in lower and "schedule" in lower:
        return "cost_schedule"
    if "master" in lower and "plan" in lower:
        return "master_plan"
    if "strategy" in lower:
        return "strategy_document"
    if "transport" in lower:
        return "transport_plan"
    if "stormwater" in lower or "water" in lower:
        return "water_infrastructure"
    if "open-space" in lower or "open_space" in lower:
        return "open_space_plan"
    return "government_pdf"


def download_pdf(url: str) -> Optional[bytes]:
    """Download a PDF file and return raw bytes."""
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = urllib.request.Request(url, headers={
        "User-Agent": _BROWSER_UA,
        "Accept": "application/pdf,*/*",
        "Accept-Language": "en-AU,en;q=0.9",
    })

    try:
        with urllib.request.urlopen(req, timeout=DOWNLOAD_TIMEOUT, context=ctx) as resp:
            # Check content length
            content_length = resp.headers.get("Content-Length")
            if content_length and int(content_length) > MAX_FILE_SIZE:
                print(f"    SKIP: File too large ({int(content_length) / 1024 / 1024:.1f} MB)")
                return None

            data = resp.read(MAX_FILE_SIZE + 1)
            if len(data) > MAX_FILE_SIZE:
                print(f"    SKIP: File exceeds {MAX_FILE_SIZE / 1024 / 1024:.0f} MB limit")
                return None

            return data
    except Exception as e:
        print(f"    Download failed: {e}")
        return None


def parse_pdf_bytes(pdf_bytes: bytes, max_pages: int = MAX_PDF_PAGES) -> Tuple[str, int]:
    """
    Parse PDF bytes and extract text using PyMuPDF.

    Returns:
        (extracted_text, page_count)
    """
    if not _HAS_PYMUPDF:
        raise RuntimeError("PyMuPDF (fitz) not installed")

    doc = fitz.open(stream=pdf_bytes, filetype="pdf")
    page_count = len(doc)
    pages_to_read = min(page_count, max_pages)

    text_parts = []
    for page_num in range(pages_to_read):
        page = doc[page_num]
        page_text = page.get_text("text")
        if page_text and page_text.strip():
            text_parts.append(page_text.strip())

    doc.close()

    full_text = "\n\n".join(text_parts)

    # Clean up common PDF artifacts
    full_text = re.sub(r'\n{3,}', '\n\n', full_text)
    full_text = re.sub(r'[ \t]+', ' ', full_text)
    # Remove page numbers (standalone numbers on a line)
    full_text = re.sub(r'\n\s*\d{1,3}\s*\n', '\n', full_text)

    return full_text, page_count


def _get_source_name(pdf_url: str) -> str:
    """Determine source_name from PDF URL domain."""
    domain = urllib.parse.urlparse(pdf_url).netloc
    return DOMAIN_SOURCE_MAP.get(domain, "edq_priority_areas")


def _get_suburb_from_metadata(metadata: dict) -> Optional[str]:
    """Extract primary suburb from metadata."""
    suburbs = metadata.get("affected_suburbs", [])
    if suburbs:
        return suburbs[0]
    return None


# ====== Discovery Phase ======

def discover_pdfs() -> List[Dict]:
    """
    Scan all target pages and discover PDF links.
    Returns list of dicts with: project_name, pdf_url, filename, metadata
    """
    print("=" * 70)
    print("Phase 1: Discovering PDF links from all data source pages")
    print("=" * 70)

    all_pdfs = []
    seen_urls = set()

    for title, url in SCAN_TARGETS:
        print(f"\n  Scanning: {title}")
        print(f"  URL: {url}")

        try:
            html = fetch_html(url)
            links = extract_links(html, url)
            pdfs, _, _ = classify_links(links, url)

            # Filter to high-value PDFs
            for pdf_url in pdfs:
                if pdf_url in seen_urls:
                    continue
                seen_urls.add(pdf_url)

                filename = urllib.parse.urlparse(pdf_url).path.split('/')[-1]
                # URL-decode filename
                filename = urllib.parse.unquote(filename)

                if is_high_value_pdf(filename):
                    all_pdfs.append({
                        "project_name": title,
                        "pdf_url": pdf_url,
                        "filename": filename,
                        "metadata": PROJECT_METADATA.get(title, {}),
                    })
                    print(f"    [OK] {filename}")
                else:
                    print(f"    [SKIP] {filename} (low value)")

        except Exception as e:
            print(f"    FAILED: {e}")

    print(f"\n  Total high-value PDFs discovered: {len(all_pdfs)}")
    return all_pdfs


# ====== Main Crawl Pipeline ======

def crawl_pdfs(pdf_list: Optional[List[Dict]] = None, max_pdfs: int = 100):
    """
    Download, parse, chunk, embed, and store PDFs.

    Args:
        pdf_list: Pre-discovered PDF list (or None to discover automatically)
        max_pdfs: Maximum number of PDFs to process
    """
    if not _HAS_PYMUPDF:
        print("ERROR: PyMuPDF not installed. Run: pip install PyMuPDF")
        return

    # Phase 1: Discover
    if pdf_list is None:
        pdf_list = discover_pdfs()

    if not pdf_list:
        print("\nNo PDFs to process.")
        return

    # Limit
    if len(pdf_list) > max_pdfs:
        print(f"\nLimiting to {max_pdfs} PDFs (out of {len(pdf_list)} discovered)")
        pdf_list = pdf_list[:max_pdfs]

    print(f"\n{'='*70}")
    print(f"Phase 2: Downloading and parsing {len(pdf_list)} PDFs")
    print(f"{'='*70}")

    results = {
        "success": 0,
        "failed": 0,
        "skipped": 0,
        "total_chunks": 0,
        "total_pages": 0,
        "errors": [],
    }

    all_chunks_to_embed = []  # (doc_id, chunk_index, chunk_text, token_count, pdf_info)

    for i, pdf_info in enumerate(pdf_list, 1):
        pdf_url = pdf_info["pdf_url"]
        filename = pdf_info["filename"]
        project = pdf_info["project_name"]
        metadata = pdf_info.get("metadata", {}).copy()

        print(f"\n[{i}/{len(pdf_list)}] {filename}")
        print(f"  Project: {project}")
        print(f"  URL: {pdf_url[:100]}")

        # Check if already exists
        url_hash = _make_hash(pdf_url)
        existing = execute_query(
            "SELECT id, content_hash FROM devintel_documents WHERE url_hash = %s",
            (url_hash,)
        )

        # Download PDF
        print(f"  Downloading...")
        pdf_bytes = download_pdf(pdf_url)
        if pdf_bytes is None:
            results["failed"] += 1
            results["errors"].append({
                "filename": filename,
                "project": project,
                "error": "Download failed",
            })
            continue

        file_size = len(pdf_bytes)
        print(f"  Downloaded: {file_size / 1024:.1f} KB")

        # Parse PDF
        try:
            pdf_text, page_count = parse_pdf_bytes(pdf_bytes)
            results["total_pages"] += page_count
            print(f"  Parsed: {page_count} pages, {len(pdf_text)} chars, {count_tokens(pdf_text)} tokens")
        except Exception as e:
            print(f"  Parse FAILED: {e}")
            results["failed"] += 1
            results["errors"].append({
                "filename": filename,
                "project": project,
                "error": f"Parse failed: {e}",
            })
            # Store document with failed status
            if not existing:
                try:
                    execute_query("""
                        INSERT INTO devintel_documents
                        (url_hash, url, title, source_name, source_type,
                         parse_status, parse_error, file_size, metadata,
                         crawl_status, last_crawled_at)
                        VALUES (%s, %s, %s, %s, 'pdf', 'failed', %s, %s, %s::jsonb, 'completed', NOW())
                    """, (
                        url_hash, pdf_url, filename,
                        _get_source_name(pdf_url),
                        str(e), file_size,
                        json.dumps(metadata),
                    ))
                except Exception:
                    pass
            continue

        # Skip nearly empty PDFs (likely scanned/image-only)
        if len(pdf_text.strip()) < 100:
            print(f"  SKIP: Very little text extracted ({len(pdf_text)} chars) - likely scanned PDF")
            # Mark as needing OCR
            if not existing:
                try:
                    execute_query("""
                        INSERT INTO devintel_documents
                        (url_hash, url, title, source_name, source_type,
                         parse_status, file_size, ocr_required, metadata,
                         crawl_status, last_crawled_at)
                        VALUES (%s, %s, %s, %s, 'pdf', 'parsed', %s, TRUE, %s::jsonb, 'completed', NOW())
                    """, (
                        url_hash, pdf_url, filename,
                        _get_source_name(pdf_url),
                        file_size, json.dumps(metadata),
                    ))
                except Exception:
                    pass
            results["skipped"] += 1
            continue

        content_hash = _make_hash(pdf_text)

        # Classify PDF type
        doc_type = classify_pdf_type(filename, pdf_text)
        metadata["pdf_filename"] = filename
        metadata["pdf_pages"] = page_count
        metadata["pdf_size_kb"] = round(file_size / 1024, 1)
        metadata["doc_classification"] = doc_type

        # Build a title from filename
        doc_title = filename.replace('.pdf', '').replace('-', ' ').replace('_', ' ').title()
        doc_title = f"{project} - {doc_title}"

        # Check if unchanged
        if existing:
            old_hash = existing[0].get("content_hash", "")
            if old_hash == content_hash:
                print(f"  UNCHANGED - skipping")
                results["skipped"] += 1
                continue

        suburb = _get_suburb_from_metadata(metadata)

        # Store/Update document
        try:
            if existing:
                doc_id = existing[0]["id"]
                execute_query("""
                    UPDATE devintel_documents
                    SET content_text = %s, content_hash = %s, previous_hash = %s,
                        version = version + 1, change_detected_at = NOW(),
                        title = %s, parse_status = 'parsed', updated_at = NOW(),
                        metadata = %s::jsonb, crawl_status = 'completed',
                        last_crawled_at = NOW(), doc_type = %s,
                        suburb = %s, source_type = 'pdf',
                        file_size = %s
                    WHERE id = %s
                """, (
                    pdf_text, content_hash, existing[0].get("content_hash"),
                    doc_title, json.dumps(metadata), doc_type,
                    suburb, file_size, doc_id,
                ))
                execute_query("DELETE FROM devintel_chunks WHERE document_id = %s", (doc_id,))
                print(f"  Updated document (id={doc_id}, version+1)")
            else:
                execute_query("""
                    INSERT INTO devintel_documents
                    (url_hash, url, title, source_name, source_type, content_text,
                     content_hash, suburb, doc_type, parse_status, metadata,
                     crawl_status, last_crawled_at, file_size)
                    VALUES (%s, %s, %s, %s, 'pdf', %s, %s, %s, %s, 'parsed', %s::jsonb,
                            'completed', NOW(), %s)
                """, (
                    url_hash, pdf_url, doc_title,
                    _get_source_name(pdf_url),
                    pdf_text, content_hash,
                    suburb, doc_type,
                    json.dumps(metadata),
                    file_size,
                ))
                result = execute_query(
                    "SELECT id FROM devintel_documents WHERE url_hash = %s",
                    (url_hash,)
                )
                doc_id = result[0]["id"]
                print(f"  New document created (id={doc_id})")

            results["success"] += 1

        except Exception as e:
            print(f"  ERROR storing document: {e}")
            results["failed"] += 1
            results["errors"].append({
                "filename": filename,
                "project": project,
                "error": str(e),
            })
            continue

        # Chunk the document
        chunks = chunk_text(pdf_text)
        print(f"  Chunked: {len(chunks)} chunks")

        for idx, (ct, tc) in enumerate(chunks):
            all_chunks_to_embed.append((doc_id, idx, ct, tc, pdf_info, doc_type))

        # Polite delay between downloads
        time.sleep(0.5)

    # ====== Phase 3: Batch Embed ======
    if all_chunks_to_embed:
        print(f"\n{'='*70}")
        print(f"Phase 3: Embedding {len(all_chunks_to_embed)} chunks from {results['success']} PDFs")
        print(f"{'='*70}")

        chunk_texts = [c[2] for c in all_chunks_to_embed]

        try:
            embeddings = embed_texts(chunk_texts)
            print(f"Embedding complete! ({len(embeddings)} vectors)")
        except Exception as e:
            print(f"ERROR embedding: {e}")
            return results

        # Store chunks with vectors
        print(f"Storing {len(all_chunks_to_embed)} chunks with vectors...")
        stored = 0
        for i, (doc_id, chunk_idx, ct, tc, pdf_info, doc_type) in enumerate(all_chunks_to_embed):
            embedding = embeddings[i]
            embedding_str = "[" + ",".join(str(x) for x in embedding) + "]"

            metadata = pdf_info.get("metadata", {}).copy()
            suburb = _get_suburb_from_metadata(metadata)
            source_name = _get_source_name(pdf_info["pdf_url"])

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
                    doc_id, chunk_idx, ct, tc, embedding_str,
                    suburb, doc_type, source_name,
                    json.dumps(metadata),
                ))
                stored += 1
            except Exception as e:
                print(f"  ERROR storing chunk {chunk_idx} for doc {doc_id}: {e}")

        results["total_chunks"] = stored
        print(f"Stored {stored} chunks successfully.")

    # Log crawl
    try:
        execute_query("""
            INSERT INTO devintel_crawl_logs
            (source_name, crawl_type, pages_found, pages_new, pages_failed,
             chunks_created, status, finished_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, NOW())
        """, (
            "pdf_deep_crawl", "manual",
            len(pdf_list), results["success"], results["failed"],
            results["total_chunks"], "completed",
        ))
    except Exception as e:
        print(f"\n[WARN] Failed to log crawl: {e}")

    # Update source document counts
    try:
        for src in ["edq_priority_areas", "brisbane_2032", "bcc_da_tracker", "qld_state_development"]:
            execute_query("""
                UPDATE devintel_sources
                SET total_documents = (SELECT COUNT(*) FROM devintel_documents WHERE source_name = %s),
                    last_success_at = NOW(), updated_at = NOW()
                WHERE source_name = %s
            """, (src, src))
    except Exception:
        pass

    # ====== Summary ======
    print(f"\n{'='*70}")
    print(f"PDF DEEP CRAWL SUMMARY")
    print(f"{'='*70}")
    print(f"  PDFs processed:    {len(pdf_list)}")
    print(f"  Success:           {results['success']}")
    print(f"  Failed:            {results['failed']}")
    print(f"  Skipped:           {results['skipped']} (unchanged or empty)")
    print(f"  Total PDF pages:   {results['total_pages']}")
    print(f"  Chunks created:    {results['total_chunks']}")

    if results["errors"]:
        print(f"\n  Errors:")
        for err in results["errors"]:
            print(f"    - [{err.get('project','')}] {err['filename']}: {err['error'][:80]}")

    # Final DB stats
    try:
        docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
        chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
        pdf_docs = execute_query(
            "SELECT COUNT(*) as cnt FROM devintel_documents WHERE source_type = 'pdf'"
        )
        print(f"\n  Database totals:")
        print(f"    Documents:     {docs[0]['cnt']} ({pdf_docs[0]['cnt']} PDFs)")
        print(f"    Chunks:        {chunks[0]['cnt']}")
    except Exception:
        pass

    return results


# ====== Sub-page Crawler (bonus) ======

def discover_and_crawl_subpages():
    """
    Crawl sub-pages discovered from data source pages.
    These are HTML pages linked from the main project pages.
    """
    from devintel.crawl_test import extract_text_from_html, fetch_page

    print(f"\n{'='*70}")
    print(f"Sub-page Crawler: Discovering and crawling linked HTML pages")
    print(f"{'='*70}")

    results = {"success": 0, "failed": 0, "skipped": 0, "total_chunks": 0}
    all_chunks_to_embed = []
    seen_urls = set()

    for title, url in SCAN_TARGETS:
        print(f"\n  Scanning sub-pages for: {title}")

        try:
            html = fetch_html(url)
            links = extract_links(html, url)
            _, sub_pages, _ = classify_links(links, url)

            # Filter to relevant sub-pages
            base_path = urllib.parse.urlparse(url).path.rstrip('/')
            relevant = []
            for sp in sub_pages:
                sp_path = urllib.parse.urlparse(sp).path
                if sp in seen_urls or sp == url:
                    continue
                if (sp_path.startswith(base_path) and sp_path != base_path + '/') or \
                   '/development-scheme' in sp_path or \
                   '/plans/' in sp_path or \
                   '/documents/' in sp_path:
                    relevant.append(sp)
                    seen_urls.add(sp)

            if not relevant:
                print(f"    No new sub-pages found")
                continue

            print(f"    Found {len(relevant)} sub-pages")

            for sp_url in relevant[:5]:  # Limit to 5 sub-pages per project
                sp_path = urllib.parse.urlparse(sp_url).path
                print(f"    Crawling: {sp_path}")

                url_hash = _make_hash(sp_url)
                existing = execute_query(
                    "SELECT id, content_hash FROM devintel_documents WHERE url_hash = %s",
                    (url_hash,)
                )
                if existing:
                    print(f"      Already exists - skipping")
                    results["skipped"] += 1
                    continue

                try:
                    sp_html, final_url = fetch_page(sp_url)
                    sp_text = extract_text_from_html(sp_html, title=f"{title} - {sp_path.split('/')[-1]}")

                    if len(sp_text.strip()) < 50:
                        print(f"      Too little content - skipping")
                        continue

                    content_hash = _make_hash(sp_text)
                    metadata = PROJECT_METADATA.get(title, {}).copy()
                    metadata["parent_page"] = url
                    metadata["sub_page_path"] = sp_path
                    suburb = _get_suburb_from_metadata(metadata)

                    sp_title = sp_path.split('/')[-1].replace('-', ' ').title()
                    doc_title = f"{title} - {sp_title}"

                    execute_query("""
                        INSERT INTO devintel_documents
                        (url_hash, url, title, source_name, source_type, content_text,
                         content_hash, suburb, doc_type, parse_status, metadata,
                         crawl_status, last_crawled_at)
                        VALUES (%s, %s, %s, %s, 'html', %s, %s, %s, %s, 'parsed', %s::jsonb,
                                'completed', NOW())
                    """, (
                        url_hash, sp_url, doc_title,
                        _get_source_name(sp_url),
                        sp_text, content_hash,
                        suburb, "sub_page",
                        json.dumps(metadata),
                    ))

                    result = execute_query(
                        "SELECT id FROM devintel_documents WHERE url_hash = %s",
                        (url_hash,)
                    )
                    doc_id = result[0]["id"]

                    chunks = chunk_text(sp_text)
                    for idx, (ct, tc) in enumerate(chunks):
                        all_chunks_to_embed.append((doc_id, idx, ct, tc, {
                            "metadata": metadata,
                            "pdf_url": sp_url,  # reuse field for source_name lookup
                        }, "sub_page"))

                    results["success"] += 1
                    print(f"      OK: {len(sp_text)} chars, {len(chunks)} chunks")
                    time.sleep(1)

                except Exception as e:
                    print(f"      FAILED: {e}")
                    results["failed"] += 1

        except Exception as e:
            print(f"    Scan failed: {e}")

    # Embed sub-page chunks
    if all_chunks_to_embed:
        print(f"\n  Embedding {len(all_chunks_to_embed)} sub-page chunks...")
        chunk_texts = [c[2] for c in all_chunks_to_embed]

        try:
            embeddings = embed_texts(chunk_texts)
            for i, (doc_id, chunk_idx, ct, tc, info, doc_type) in enumerate(all_chunks_to_embed):
                embedding = embeddings[i]
                embedding_str = "[" + ",".join(str(x) for x in embedding) + "]"
                metadata = info.get("metadata", {})
                suburb = _get_suburb_from_metadata(metadata)
                source_name = _get_source_name(info.get("pdf_url", ""))

                execute_query("""
                    INSERT INTO devintel_chunks
                    (document_id, chunk_index, chunk_text, token_count, embedding,
                     suburb, doc_type, source_name, metadata)
                    VALUES (%s, %s, %s, %s, %s::vector, %s, %s, %s, %s::jsonb)
                    ON CONFLICT (document_id, chunk_index) DO UPDATE SET
                        chunk_text = EXCLUDED.chunk_text,
                        embedding = EXCLUDED.embedding
                """, (
                    doc_id, chunk_idx, ct, tc, embedding_str,
                    suburb, doc_type, source_name,
                    json.dumps(metadata),
                ))
                results["total_chunks"] += 1
        except Exception as e:
            print(f"  Embedding failed: {e}")

    print(f"\n  Sub-page results: {results['success']} success, {results['failed']} failed, {results['total_chunks']} chunks")
    return results


if __name__ == "__main__":
    print("=" * 70)
    print("DevIntel PDF Deep Crawler")
    print("=" * 70)

    # Step 1: Crawl all PDFs
    pdf_results = crawl_pdfs()

    # Step 2: Crawl sub-pages
    subpage_results = discover_and_crawl_subpages()

    # Final summary
    print(f"\n{'='*70}")
    print(f"COMPLETE DEEP CRAWL SUMMARY")
    print(f"{'='*70}")
    print(f"  PDFs:       {pdf_results.get('success', 0)} documents, {pdf_results.get('total_chunks', 0)} chunks")
    print(f"  Sub-pages:  {subpage_results.get('success', 0)} documents, {subpage_results.get('total_chunks', 0)} chunks")

    try:
        docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
        chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
        print(f"\n  TOTAL IN DATABASE:")
        print(f"    Documents: {docs[0]['cnt']}")
        print(f"    Chunks:    {chunks[0]['cnt']}")
    except Exception:
        pass
