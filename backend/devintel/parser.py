"""
DevIntel Parser - HTML text extraction + PyMuPDF PDF parsing + metadata extraction.

Extracts clean text from web pages and PDF documents.
Auto-detects project_name, authority, stage, suburbs from content.
"""

import re
import html as _html
import urllib.parse
from typing import Dict, Optional, List
from datetime import datetime

try:
    import fitz  # PyMuPDF
    _HAS_PYMUPDF = True
except ImportError:
    _HAS_PYMUPDF = False

# ====== Suburb Detection ======

try:
    import sys, os
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    from suburbs_config import ALL_SUBURB_NAMES
    _SUBURB_SET = {s.lower(): s for s in ALL_SUBURB_NAMES}
except Exception:
    _SUBURB_SET = {}


# ====== Authority / Stage Detection ======

_AUTHORITY_PATTERNS = [
    (r"Economic Development Queensland|EDQ", "Economic Development Queensland"),
    (r"Brisbane City Council|BCC", "Brisbane City Council"),
    (r"GIICA|Brisbane 2032|Olympic", "GIICA / Brisbane 2032"),
    (r"Moreton Bay Regional Council", "Moreton Bay Regional Council"),
    (r"Sunshine Coast Council", "Sunshine Coast Council"),
    (r"Ipswich City Council", "Ipswich City Council"),
    (r"Logan City Council", "Logan City Council"),
    (r"Department of State Development", "QLD State Development"),
    (r"Transport and Main Roads|TMR", "Transport and Main Roads"),
]

_STAGE_KEYWORDS = {
    "proposed": ["proposed", "under consideration", "planning stage", "concept plan"],
    "approved": ["approved", "has been approved", "endorsed", "gazetted"],
    "under_construction": ["under construction", "construction has commenced",
                           "currently being built", "works underway", "being developed"],
    "completed": ["completed", "has been completed", "now open", "officially opened"],
    "cancelled": ["cancelled", "abandoned", "no longer proceeding"],
}

_DOC_TYPE_PATTERNS = {
    "development_scheme": [r"development\s+scheme", r"planning\s+scheme"],
    "development_charges": [r"dcop", r"development\s+charges", r"charging.*offset"],
    "infrastructure_plan": [r"ipbr", r"infrastructure\s+plan.*background"],
    "submissions_report": [r"submissions?\s+report"],
    "fact_sheet": [r"fact\s+sheet"],
    "precinct_plan": [r"precinct\s+plan", r"precinct\s+strategy"],
    "context_plan": [r"context\s+plan"],
    "scheme_amendment": [r"scheme\s+amendment", r"amendment\s+no"],
    "gazette_notice": [r"gazette", r"statutory\s+notice"],
    "cost_schedule": [r"cost\s+schedule"],
    "master_plan": [r"master\s*plan"],
    "transport_plan": [r"transport\s+plan", r"traffic\s+study"],
    "environment_report": [r"environmental\s+assessment", r"epbc"],
    "council_minutes": [r"council\s+minutes", r"meeting\s+minutes"],
}


# ====== HTML Parser ======

# Words to filter out from paragraphs
_SKIP_WORDS = [
    "cookie", "subscribe", "sign up", "log in", "copyright",
    "privacy policy", "terms of", "advertisement", "all rights",
    "javascript", "browser", "accept all", "manage preferences",
    "we use cookies", "required cookies",
]


def parse_html(html_content: str, source_config: dict = None) -> Dict:
    """
    Extract clean text from HTML content.

    Args:
        html_content: Raw HTML string
        source_config: Optional source config dict with parser_config

    Returns:
        Dict with keys: text, title, doc_type, metadata, suburbs
    """
    if not html_content:
        return {"text": "", "title": "", "doc_type": None, "metadata": {}, "suburbs": []}

    config = (source_config or {}).get("parser_config", {})

    # Extract page title
    title = ""
    title_match = re.search(r"<title[^>]*>(.*?)</title>", html_content, re.DOTALL | re.IGNORECASE)
    if title_match:
        title = re.sub(r"<[^>]+>", "", title_match.group(1)).strip()
        title = _html.unescape(title)
        # Clean common suffixes
        for suffix in [" | EDQ", " - EDQ", " | Brisbane City Council", " - BCC"]:
            title = title.replace(suffix, "")

    # Find main content area
    content_html = html_content
    for tag in ["main", "article"]:
        match = re.search(rf"<{tag}[^>]*>(.*?)</{tag}>", html_content, re.DOTALL | re.IGNORECASE)
        if match:
            content_html = match.group(1)
            break

    # Custom content selector from parser_config
    custom_selector = config.get("content_selector")
    if custom_selector:
        match = re.search(custom_selector, html_content, re.DOTALL | re.IGNORECASE)
        if match:
            content_html = match.group(1)

    clean_parts = []
    seen = set()

    # Add title
    if title:
        clean_parts.append(f"# {title}")
        clean_parts.append("")

    # Extract headings (h1-h4)
    headings = re.findall(r"<h([1-4])[^>]*>(.*?)</h\1>", content_html, re.DOTALL | re.IGNORECASE)
    for level, heading_html in headings:
        heading_text = re.sub(r"<[^>]+>", "", heading_html).strip()
        heading_text = _html.unescape(heading_text)
        if heading_text and 3 < len(heading_text) < 200:
            prefix = "#" * (int(level) + 1)
            clean_parts.append(f"{prefix} {heading_text}")

    # Extract paragraphs
    paras = re.findall(r"<p[^>]*>(.*?)</p>", content_html, re.DOTALL | re.IGNORECASE)
    for p in paras:
        text = re.sub(r"<[^>]+>", "", p).strip()
        text = _html.unescape(text)
        text = re.sub(r"\s+", " ", text).strip()
        if len(text) > 15 and text not in seen:
            lower = text.lower()
            if any(skip in lower for skip in _SKIP_WORDS):
                continue
            clean_parts.append(text)
            seen.add(text)

    # Fallback: list items
    if len(clean_parts) < 5:
        list_items = re.findall(r"<li[^>]*>(.*?)</li>", content_html, re.DOTALL | re.IGNORECASE)
        for li in list_items:
            text = re.sub(r"<[^>]+>", "", li).strip()
            text = _html.unescape(text)
            text = re.sub(r"\s+", " ", text).strip()
            if len(text) > 15 and text not in seen:
                lower = text.lower()
                if any(skip in lower for skip in _SKIP_WORDS):
                    continue
                clean_parts.append(f"- {text}")
                seen.add(text)

    # Fallback: content divs
    if len(clean_parts) < 5:
        div_patterns = [
            r'<div[^>]*class="[^"]*(?:content|body|text|main|story|article|field)[^"]*"[^>]*>(.*?)</div>',
            r'<section[^>]*>(.*?)</section>',
        ]
        for pattern in div_patterns:
            for div_html in re.findall(pattern, html_content, re.DOTALL | re.IGNORECASE):
                for p in re.findall(r"<p[^>]*>(.*?)</p>", div_html, re.DOTALL | re.IGNORECASE):
                    text = re.sub(r"<[^>]+>", "", p).strip()
                    text = _html.unescape(text)
                    text = re.sub(r"\s+", " ", text).strip()
                    if len(text) > 15 and text not in seen:
                        clean_parts.append(text)
                        seen.add(text)

    full_text = "\n\n".join(clean_parts)

    # Auto-detect metadata
    metadata = _extract_metadata(full_text, title)
    suburbs = _detect_suburbs(full_text)
    doc_type = _detect_doc_type(full_text, title)

    return {
        "text": full_text,
        "title": title,
        "doc_type": doc_type,
        "metadata": metadata,
        "suburbs": suburbs,
    }


# ====== PDF Parser ======

def parse_pdf(pdf_input, max_pages: int = 50) -> Dict:
    """
    Extract text from PDF using PyMuPDF.

    Args:
        pdf_input: Either a file path (str) or raw bytes
        max_pages: Maximum pages to process

    Returns:
        Dict with keys: text, title, page_count, ocr_required, metadata, suburbs, doc_type
    """
    if not _HAS_PYMUPDF:
        raise RuntimeError("PyMuPDF (fitz) not installed. Run: pip install PyMuPDF")

    # Open PDF from bytes or file path
    if isinstance(pdf_input, bytes):
        doc = fitz.open(stream=pdf_input, filetype="pdf")
    else:
        doc = fitz.open(pdf_input)

    page_count = len(doc)
    pages_to_read = min(page_count, max_pages)

    text_parts = []
    for page_num in range(pages_to_read):
        page = doc[page_num]
        page_text = page.get_text("text")
        if page_text and page_text.strip():
            text_parts.append(page_text.strip())

    # Try to get title from metadata
    pdf_meta = doc.metadata or {}
    title = pdf_meta.get("title", "") or ""

    doc.close()

    full_text = "\n\n".join(text_parts)

    # Clean up common PDF artifacts
    full_text = re.sub(r'\n{3,}', '\n\n', full_text)
    full_text = re.sub(r'[ \t]+', ' ', full_text)
    full_text = re.sub(r'\n\s*\d{1,3}\s*\n', '\n', full_text)  # Page numbers

    # Check if OCR is needed (very little text extracted)
    ocr_required = len(full_text.strip()) < 100 and page_count > 0

    # Auto-detect metadata
    metadata = _extract_metadata(full_text, title)
    suburbs = _detect_suburbs(full_text)
    doc_type = _detect_doc_type(full_text, title)

    return {
        "text": full_text,
        "title": title,
        "page_count": page_count,
        "ocr_required": ocr_required,
        "metadata": metadata,
        "suburbs": suburbs,
        "doc_type": doc_type,
    }


# ====== Metadata Extraction ======

def _extract_metadata(text: str, title: str = "") -> Dict:
    """Extract structured metadata from text content."""
    combined = f"{title}\n{text[:3000]}".lower()
    metadata = {}

    # Detect authority
    for pattern, authority_name in _AUTHORITY_PATTERNS:
        if re.search(pattern, combined, re.IGNORECASE):
            metadata["authority"] = authority_name
            break

    # Detect stage
    for stage, keywords in _STAGE_KEYWORDS.items():
        if any(kw in combined for kw in keywords):
            metadata["stage"] = stage
            break

    # Extract dates (Australian format: DD Month YYYY or Month YYYY)
    date_patterns = [
        r'(\d{1,2}\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4})',
        r'((?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4})',
    ]
    for pattern in date_patterns:
        match = re.search(pattern, text[:2000], re.IGNORECASE)
        if match:
            metadata["document_date"] = match.group(1)
            break

    # Extract project names from common patterns
    project_patterns = [
        r'(?:Priority Development Area|PDA)[\s:]+([A-Z][A-Za-z\s]+?)(?:\n|\.|\s{2,})',
        r'(?:Development Scheme for|Scheme for)\s+(?:the\s+)?([A-Z][A-Za-z\s]+?)(?:\n|\.)',
    ]
    for pattern in project_patterns:
        match = re.search(pattern, text[:2000])
        if match:
            metadata["project_name"] = match.group(1).strip()
            break

    return metadata


def _detect_suburbs(text: str) -> List[str]:
    """Detect Brisbane suburb names in text."""
    if not _SUBURB_SET:
        return []

    found = []
    text_lower = text.lower()
    for suburb_lower, suburb_proper in _SUBURB_SET.items():
        # Word boundary search to avoid partial matches
        if re.search(r'\b' + re.escape(suburb_lower) + r'\b', text_lower):
            found.append(suburb_proper)

    return list(set(found))


def _detect_doc_type(text: str, title: str = "") -> Optional[str]:
    """Detect document type from content and title."""
    combined = f"{title}\n{text[:1000]}".lower()

    for doc_type, patterns in _DOC_TYPE_PATTERNS.items():
        for pattern in patterns:
            if re.search(pattern, combined, re.IGNORECASE):
                return doc_type

    return None
