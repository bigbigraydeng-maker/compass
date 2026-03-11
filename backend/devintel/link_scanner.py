"""
DevIntel Link Scanner - Analyze pages for PDF links and sub-page links.

Scans all 15 data source pages to discover:
1. PDF file links (direct downloads)
2. Sub-page links (related pages on the same domain)

Usage:
    cd backend
    python -m devintel.link_scanner
"""

import re
import ssl
import urllib.request
import urllib.parse
from collections import defaultdict
import os, sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

_BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/131.0.0.0 Safari/537.36"
)

# Same targets as crawl_test.py (deduplicated)
SCAN_TARGETS = [
    ("Queen's Wharf Brisbane", "https://www.edq.qld.gov.au/projects/queens-wharf-brisbane/"),
    ("Northshore Hamilton PDA", "https://www.edq.qld.gov.au/projects/northshore-hamilton/"),
    ("Woolloongabba PDA", "https://www.edq.qld.gov.au/projects/woolloongabba/"),
    ("Bowen Hills PDA", "https://www.edq.qld.gov.au/projects/bowen-hills/"),
    ("Herston Quarter", "https://www.edq.qld.gov.au/projects/herston-quarter/"),
    ("Carseldine Village", "https://www.edq.qld.gov.au/projects/carseldine-village/"),
    ("Brisbane Stadium", "https://giica.au/venues/brisbane-stadium"),
    ("National Aquatic Centre", "https://giica.au/venues/national-aquatic-centre"),
    ("Mt Coot-tha", "https://www.brisbane.qld.gov.au/parks-and-recreation/park-projects/mt-coot-tha-precinct-transformation"),
    ("Ripley Valley PDA", "https://www.edq.qld.gov.au/projects/ripley-valley/"),
    ("Yarrabilba PDA", "https://www.edq.qld.gov.au/projects/yarrabilba/"),
    ("Greater Flagstone PDA", "https://www.edq.qld.gov.au/projects/greater-flagstone/"),
    ("Caloundra South / Aura", "https://www.edq.qld.gov.au/projects/caloundra-south/"),
]


def fetch_html(url: str, timeout: int = 25) -> str:
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
        return raw.decode(charset, errors="replace")


def extract_links(html: str, base_url: str):
    """Extract all href links from HTML, resolve relative URLs."""
    links = re.findall(r'href=["\']([^"\']+)["\']', html, re.IGNORECASE)
    resolved = []
    for link in links:
        # Skip anchors, javascript, mailto
        if link.startswith(('#', 'javascript:', 'mailto:', 'tel:')):
            continue
        # Resolve relative URLs
        full_url = urllib.parse.urljoin(base_url, link)
        resolved.append(full_url)
    return resolved


def classify_links(links, base_url):
    """Classify links into PDFs, sub-pages, and external."""
    base_domain = urllib.parse.urlparse(base_url).netloc

    pdfs = []
    sub_pages = []
    external = []

    seen = set()
    for link in links:
        if link in seen:
            continue
        seen.add(link)

        parsed = urllib.parse.urlparse(link)
        path = parsed.path.lower()

        if path.endswith('.pdf'):
            pdfs.append(link)
        elif parsed.netloc == base_domain:
            # Same domain = sub-page
            # Filter out obvious non-content pages
            skip_patterns = [
                '/search', '/login', '/register', '/cart', '/checkout',
                '/privacy', '/terms', '/sitemap', '/rss', '/feed',
                '/wp-admin', '/wp-content', '/assets/', '/static/',
                '.css', '.js', '.png', '.jpg', '.gif', '.svg', '.ico',
            ]
            if not any(p in path for p in skip_patterns):
                sub_pages.append(link)
        else:
            # Check if external link is a PDF
            if path.endswith('.pdf'):
                pdfs.append(link)
            else:
                external.append(link)

    return pdfs, sub_pages, external


def scan_all():
    """Scan all target pages and report findings."""
    print("=" * 80)
    print("DevIntel Link Scanner - Discovering PDFs and Sub-pages")
    print("=" * 80)

    total_pdfs = 0
    total_subpages = 0
    all_pdfs = []
    all_subpages = []

    for title, url in SCAN_TARGETS:
        print(f"\n{'─'*80}")
        print(f"  {title}")
        print(f"  {url}")

        try:
            html = fetch_html(url)
            links = extract_links(html, url)
            pdfs, sub_pages, external = classify_links(links, url)

            # Filter sub-pages to only relevant ones (same project path or related)
            base_path = urllib.parse.urlparse(url).path.rstrip('/')
            relevant_sub = []
            for sp in sub_pages:
                sp_path = urllib.parse.urlparse(sp).path
                # Keep sub-pages that are under the same project path or in /projects/
                if (sp_path.startswith(base_path) and sp_path != base_path + '/') or \
                   '/projects/' in sp_path or \
                   '/development-scheme' in sp_path or \
                   '/plans/' in sp_path or \
                   '/documents/' in sp_path or \
                   '/venues/' in sp_path:
                    relevant_sub.append(sp)

            print(f"  PDF files:    {len(pdfs)}")
            for p in pdfs:
                filename = urllib.parse.urlparse(p).path.split('/')[-1]
                print(f"    [PDF] {filename}")
                print(f"          {p[:120]}")
                all_pdfs.append((title, p, filename))

            print(f"  Sub-pages:    {len(relevant_sub)} (relevant) / {len(sub_pages)} (total)")
            for sp in relevant_sub[:10]:  # Show max 10
                sp_path = urllib.parse.urlparse(sp).path
                print(f"    [LINK] {sp_path}")
                all_subpages.append((title, sp, sp_path))
            if len(relevant_sub) > 10:
                print(f"    ... and {len(relevant_sub) - 10} more")

            total_pdfs += len(pdfs)
            total_subpages += len(relevant_sub)

        except Exception as e:
            print(f"  FAILED: {e}")

    # Summary
    print(f"\n{'='*80}")
    print(f"SCAN SUMMARY")
    print(f"{'='*80}")
    print(f"  Pages scanned:    {len(SCAN_TARGETS)}")
    print(f"  Total PDFs found: {total_pdfs}")
    print(f"  Total sub-pages:  {total_subpages}")

    if all_pdfs:
        print(f"\n  ALL PDFs:")
        for title, url, filename in all_pdfs:
            print(f"    [{title}] {filename}")
            print(f"      {url[:120]}")

    return all_pdfs, all_subpages


if __name__ == "__main__":
    scan_all()
