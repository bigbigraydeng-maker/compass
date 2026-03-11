"""
DevIntel Crawl Test - Crawl 15 specific Brisbane development data sources.

Tests the full pipeline: Fetch → Parse → Chunk → Embed → Store

Usage:
    cd backend
    python -m devintel.crawl_test
"""

import hashlib
import json
import re
import html as _html
import urllib.request
import ssl
import os
import sys
import time
from typing import Optional, List, Tuple

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from database import execute_query
from devintel.chunker import chunk_text, count_tokens
from devintel.embedder import embed_texts

# ====== 15 Target Data Sources ======

CRAWL_TARGETS = [
    # 一、城市更新项目
    {
        "url": "https://www.edq.qld.gov.au/projects/queens-wharf-brisbane/",
        "title": "Queen's Wharf Brisbane",
        "source_name": "edq_priority_areas",
        "doc_type": "urban_renewal",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Queen's Wharf Brisbane",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "estimated_completion": "2025",
            "investment": "$3.6B",
            "tags": ["urban_renewal", "CBD", "casino", "resort", "mixed_use"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/northshore-hamilton/",
        "title": "Northshore Hamilton PDA",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Northshore Hamilton PDA",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "affected_suburbs": ["Hamilton"],
            "tags": ["waterfront", "PDA", "mixed_use", "residential"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/woolloongabba/",
        "title": "Woolloongabba PDA",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Woolloongabba PDA",
            "authority": "Economic Development Queensland",
            "stage": "approved",
            "affected_suburbs": ["Woolloongabba"],
            "tags": ["PDA", "Cross_River_Rail", "transit_oriented", "mixed_use"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/bowen-hills/",
        "title": "Bowen Hills PDA",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Bowen Hills PDA",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "affected_suburbs": ["Bowen Hills"],
            "tags": ["PDA", "RNA_Showgrounds", "mixed_use"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/herston-quarter/",
        "title": "Herston Quarter",
        "source_name": "edq_priority_areas",
        "doc_type": "urban_renewal",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Herston Quarter",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "affected_suburbs": ["Herston"],
            "tags": ["health_precinct", "mixed_use", "hospital"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/carseldine-village/",
        "title": "Carseldine Village",
        "source_name": "edq_priority_areas",
        "doc_type": "urban_renewal",
        "category": "城市更新项目",
        "metadata": {
            "project_name": "Carseldine Village",
            "authority": "Economic Development Queensland",
            "stage": "approved",
            "affected_suburbs": ["Carseldine"],
            "tags": ["village", "community", "mixed_use", "education"],
        },
    },
    # 二、2032奥运相关
    {
        "url": "https://giica.au/venues/brisbane-stadium",
        "title": "Brisbane Stadium (Victoria Park)",
        "source_name": "brisbane_2032",
        "doc_type": "olympics_venue",
        "category": "2032奥运相关开发",
        "metadata": {
            "project_name": "Brisbane Stadium (Victoria Park)",
            "authority": "GIICA / Brisbane 2032",
            "stage": "proposed",
            "tags": ["olympics", "stadium", "Victoria_Park", "2032"],
        },
    },
    {
        "url": "https://giica.au/venues/national-aquatic-centre",
        "title": "National Aquatic Centre",
        "source_name": "brisbane_2032",
        "doc_type": "olympics_venue",
        "category": "2032奥运相关开发",
        "metadata": {
            "project_name": "National Aquatic Centre",
            "authority": "GIICA / Brisbane 2032",
            "stage": "proposed",
            "tags": ["olympics", "aquatic", "swimming", "2032"],
        },
    },
    # 三、新开发区域增长项目
    {
        "url": "https://www.brisbane.qld.gov.au/parks-and-recreation/park-projects/mt-coot-tha-precinct-transformation",
        "title": "Mt Coot-tha Precinct Transformation",
        "source_name": "bcc_da_tracker",
        "doc_type": "precinct_transformation",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Mt Coot-tha Precinct Transformation",
            "authority": "Brisbane City Council",
            "stage": "under_construction",
            "tags": ["parkland", "recreation", "tourism", "Mt_Coot-tha"],
        },
    },
    {
        "url": "https://www.moretonbay.qld.gov.au/Services/Planning-and-building/Caboolture-West",
        "title": "Caboolture West Development Area",
        "source_name": "qld_state_development",
        "doc_type": "growth_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Caboolture West Development Area",
            "authority": "Moreton Bay Regional Council",
            "stage": "approved",
            "planned_population": 70000,
            "tags": ["growth_area", "new_suburb", "Moreton_Bay", "masterplan"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/ripley-valley/",
        "title": "Ripley Valley Priority Development Area",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Ripley Valley PDA",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "tags": ["PDA", "Ipswich", "growth_area", "new_suburb"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/yarrabilba/",
        "title": "Yarrabilba Priority Development Area",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Yarrabilba PDA",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "tags": ["PDA", "Logan", "growth_area", "new_suburb"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/greater-flagstone/",
        "title": "Greater Flagstone Priority Development Area",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Greater Flagstone PDA",
            "authority": "Economic Development Queensland",
            "stage": "approved",
            "tags": ["PDA", "Logan", "growth_area", "future_city"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/caloundra-south/",
        "title": "Caloundra South / Aura Development",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Caloundra South / Aura",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "tags": ["PDA", "Sunshine_Coast", "Aura", "masterplan"],
        },
    },
    {
        "url": "https://www.edq.qld.gov.au/projects/northshore-hamilton/",
        "title": "Northshore Hamilton PDA (Waterfront Redevelopment)",
        "source_name": "edq_priority_areas",
        "doc_type": "priority_development_area",
        "category": "新开发区域增长项目",
        "metadata": {
            "project_name": "Northshore Hamilton Waterfront",
            "authority": "Economic Development Queensland",
            "stage": "under_construction",
            "affected_suburbs": ["Hamilton"],
            "tags": ["waterfront", "PDA", "Brisbane_largest"],
        },
    },
]


# ====== HTML Fetcher ======

_BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/131.0.0.0 Safari/537.36"
)


def fetch_page(url: str, timeout: int = 30) -> Tuple[str, str]:
    """
    Fetch a web page and return (html_content, final_url).
    Handles redirects and SSL issues gracefully.
    """
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = urllib.request.Request(url, headers={
        "User-Agent": _BROWSER_UA,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-AU,en;q=0.9",
    })

    with urllib.request.urlopen(req, timeout=timeout, context=ctx) as resp:
        raw = resp.read()
        charset = resp.headers.get_content_charset() or "utf-8"
        html_text = raw.decode(charset, errors="replace")
        final_url = resp.url
        return html_text, final_url


def extract_text_from_html(html_text: str, title: str = "") -> str:
    """
    Extract clean text from HTML. Multi-strategy approach:
    1. <article> tag
    2. <main> tag
    3. Content divs
    4. All <p> tags
    Also extracts <h1>-<h4> headings for structure.
    """
    clean_parts = []

    # Add title if provided
    if title:
        clean_parts.append(f"# {title}")
        clean_parts.append("")

    # Extract page title from HTML if not provided
    if not title:
        title_match = re.search(r"<title[^>]*>(.*?)</title>", html_text, re.DOTALL | re.IGNORECASE)
        if title_match:
            page_title = re.sub(r"<[^>]+>", "", title_match.group(1)).strip()
            page_title = _html.unescape(page_title)
            if page_title:
                clean_parts.append(f"# {page_title}")
                clean_parts.append("")

    # Extract headings (h1-h4) and paragraphs
    # Strategy 1: <main> or <article> tag
    content_html = html_text
    main_match = re.search(r"<main[^>]*>(.*?)</main>", html_text, re.DOTALL | re.IGNORECASE)
    article_match = re.search(r"<article[^>]*>(.*?)</article>", html_text, re.DOTALL | re.IGNORECASE)

    if main_match:
        content_html = main_match.group(1)
    elif article_match:
        content_html = article_match.group(1)

    # Extract headings
    headings = re.findall(r"<h([1-4])[^>]*>(.*?)</h\1>", content_html, re.DOTALL | re.IGNORECASE)
    for level, heading_html in headings:
        heading_text = re.sub(r"<[^>]+>", "", heading_html).strip()
        heading_text = _html.unescape(heading_text)
        if heading_text and len(heading_text) > 3 and len(heading_text) < 200:
            prefix = "#" * (int(level) + 1)
            clean_parts.append(f"{prefix} {heading_text}")

    # Extract paragraphs
    skip_words = [
        "cookie", "subscribe", "sign up", "log in", "copyright",
        "privacy policy", "terms of", "advertisement", "all rights",
        "javascript", "browser", "accept all", "manage preferences",
        "we use cookies", "required cookies",
    ]

    seen = set()
    paras = re.findall(r"<p[^>]*>(.*?)</p>", content_html, re.DOTALL | re.IGNORECASE)
    for p in paras:
        text = re.sub(r"<[^>]+>", "", p).strip()
        text = _html.unescape(text)
        # Clean extra whitespace
        text = re.sub(r"\s+", " ", text).strip()
        if len(text) > 15 and text not in seen:
            lower = text.lower()
            if any(skip in lower for skip in skip_words):
                continue
            clean_parts.append(text)
            seen.add(text)

    # Strategy 2: If very little content, try <li> items in content area
    if len(clean_parts) < 5:
        list_items = re.findall(r"<li[^>]*>(.*?)</li>", content_html, re.DOTALL | re.IGNORECASE)
        for li in list_items:
            text = re.sub(r"<[^>]+>", "", li).strip()
            text = _html.unescape(text)
            text = re.sub(r"\s+", " ", text).strip()
            if len(text) > 15 and text not in seen:
                lower = text.lower()
                if any(skip in lower for skip in skip_words):
                    continue
                clean_parts.append(f"- {text}")
                seen.add(text)

    # Strategy 3: Content divs (fallback)
    if len(clean_parts) < 5:
        div_patterns = [
            r'<div[^>]*class="[^"]*(?:content|body|text|main|story|article|field)[^"]*"[^>]*>(.*?)</div>',
            r'<section[^>]*>(.*?)</section>',
        ]
        for pattern in div_patterns:
            div_matches = re.findall(pattern, html_text, re.DOTALL | re.IGNORECASE)
            for div_html in div_matches:
                inner_paras = re.findall(r"<p[^>]*>(.*?)</p>", div_html, re.DOTALL | re.IGNORECASE)
                for p in inner_paras:
                    text = re.sub(r"<[^>]+>", "", p).strip()
                    text = _html.unescape(text)
                    text = re.sub(r"\s+", " ", text).strip()
                    if len(text) > 15 and text not in seen:
                        clean_parts.append(text)
                        seen.add(text)

    result = "\n\n".join(clean_parts)
    return result


def _make_hash(text: str) -> str:
    return hashlib.md5(text.encode()).hexdigest()


# ====== Main Crawl Function ======

def crawl_and_store_targets():
    """Crawl all 15 target URLs and store in DevIntel database."""
    print("=" * 70)
    print("DevIntel Crawl Test: 15 Brisbane Development Data Sources")
    print("=" * 70)

    results = {
        "success": 0,
        "failed": 0,
        "skipped": 0,
        "total_chunks": 0,
        "errors": [],
    }

    all_chunks_to_embed = []  # (doc_id, chunk_index, chunk_text, token_count, target)

    # Deduplicate URLs (Northshore Hamilton appears twice)
    seen_urls = set()

    for i, target in enumerate(CRAWL_TARGETS, 1):
        url = target["url"]
        title = target["title"]
        category = target["category"]

        print(f"\n[{i}/{len(CRAWL_TARGETS)}] {title}")
        print(f"  Category: {category}")
        print(f"  URL: {url}")

        # Check for duplicate URLs
        url_hash = _make_hash(url)
        if url in seen_urls:
            # Same URL but different metadata context — use title hash instead
            url_hash = _make_hash(url + "|" + title)

        seen_urls.add(url)

        # Check if already exists and unchanged
        existing = execute_query(
            "SELECT id, content_hash FROM devintel_documents WHERE url_hash = %s",
            (url_hash,)
        )

        # Fetch page
        try:
            print(f"  Fetching...")
            html_content, final_url = fetch_page(url)
            print(f"  Fetched: {len(html_content)} chars (from {final_url[:80]})")
        except Exception as e:
            print(f"  FAILED to fetch: {e}")
            results["failed"] += 1
            results["errors"].append({"title": title, "url": url, "error": str(e)})
            continue

        # Extract text
        doc_text = extract_text_from_html(html_content, title=title)
        if not doc_text or len(doc_text.strip()) < 50:
            print(f"  WARNING: Very little content extracted ({len(doc_text)} chars)")
            # Still store what we have but flag it
            if len(doc_text.strip()) < 20:
                print(f"  SKIPPED: No meaningful content")
                results["failed"] += 1
                results["errors"].append({"title": title, "url": url, "error": "No content extracted"})
                continue

        content_hash = _make_hash(doc_text)
        print(f"  Extracted: {len(doc_text)} chars, {count_tokens(doc_text)} tokens")

        # Check if unchanged
        if existing:
            old_hash = existing[0].get("content_hash", "")
            if old_hash == content_hash:
                print(f"  UNCHANGED - skipping")
                results["skipped"] += 1
                continue

        # Store/Update document
        metadata = target.get("metadata", {})
        suburb = None
        suburbs = metadata.get("affected_suburbs", [])
        if suburbs:
            suburb = suburbs[0]

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
                        suburb = %s
                    WHERE id = %s
                """, (doc_text, content_hash, existing[0].get("content_hash"),
                      title, json.dumps(metadata), target["doc_type"],
                      suburb, doc_id))
                execute_query("DELETE FROM devintel_chunks WHERE document_id = %s", (doc_id,))
                print(f"  Updated document (id={doc_id}, version+1)")
            else:
                execute_query("""
                    INSERT INTO devintel_documents
                    (url_hash, url, title, source_name, source_type, content_text,
                     content_hash, suburb, doc_type, parse_status, metadata,
                     crawl_status, last_crawled_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s::jsonb, %s, NOW())
                """, (
                    url_hash, url, title,
                    target["source_name"], "html",
                    doc_text, content_hash,
                    suburb, target["doc_type"],
                    "parsed", json.dumps(metadata),
                    "completed",
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
            results["errors"].append({"title": title, "url": url, "error": str(e)})
            continue

        # Chunk the document
        chunks = chunk_text(doc_text)
        print(f"  Chunked: {len(chunks)} chunks")

        for idx, (ct, tc) in enumerate(chunks):
            all_chunks_to_embed.append((doc_id, idx, ct, tc, target))

        # Small delay between requests
        time.sleep(1)

    # Log crawl
    try:
        execute_query("""
            INSERT INTO devintel_crawl_logs
            (source_name, crawl_type, pages_found, pages_new, pages_failed, status, finished_at)
            VALUES (%s, %s, %s, %s, %s, %s, NOW())
        """, (
            "crawl_test", "manual",
            len(CRAWL_TARGETS), results["success"], results["failed"],
            "completed",
        ))
    except Exception as e:
        print(f"\n[WARN] Failed to log crawl: {e}")

    # Batch embed all chunks
    if all_chunks_to_embed:
        print(f"\n{'='*70}")
        print(f"Embedding {len(all_chunks_to_embed)} chunks...")
        chunk_texts = [c[2] for c in all_chunks_to_embed]

        try:
            embeddings = embed_texts(chunk_texts)
            print(f"Embedding complete!")
        except Exception as e:
            print(f"ERROR embedding: {e}")
            return results

        # Store chunks
        print(f"Storing {len(all_chunks_to_embed)} chunks with vectors...")
        for i, (doc_id, chunk_idx, ct, tc, target) in enumerate(all_chunks_to_embed):
            embedding = embeddings[i]
            embedding_str = "[" + ",".join(str(x) for x in embedding) + "]"

            metadata = target.get("metadata", {})
            suburb = None
            suburbs = metadata.get("affected_suburbs", [])
            if suburbs:
                suburb = suburbs[0]

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
                    suburb, target["doc_type"], target["source_name"],
                    json.dumps(metadata),
                ))
                results["total_chunks"] += 1
            except Exception as e:
                print(f"  ERROR storing chunk {chunk_idx} for doc {doc_id}: {e}")

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

    # Print summary
    print(f"\n{'='*70}")
    print(f"CRAWL SUMMARY")
    print(f"{'='*70}")
    print(f"  Success:     {results['success']}/{len(CRAWL_TARGETS)}")
    print(f"  Failed:      {results['failed']}")
    print(f"  Skipped:     {results['skipped']} (unchanged)")
    print(f"  Chunks:      {results['total_chunks']}")

    if results["errors"]:
        print(f"\n  Errors:")
        for err in results["errors"]:
            print(f"    - {err['title']}: {err['error'][:80]}")

    # Final stats
    try:
        docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
        chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
        print(f"\n  Total in DB:")
        print(f"    Documents: {docs[0]['cnt']}")
        print(f"    Chunks:    {chunks[0]['cnt']}")
    except:
        pass

    return results


if __name__ == "__main__":
    crawl_and_store_targets()
