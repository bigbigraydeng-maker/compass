"""
DevIntel Parser - Phase 2 placeholder.

HTML text extraction + PyMuPDF PDF parsing + metadata extraction.
Extracts project_name, authority, stage from document content.
"""


def parse_html(html_content: str, source_config: dict = None) -> dict:
    """
    Phase 2: Extract clean text from HTML.

    Returns:
        Dict with keys: text, title, doc_date, doc_type, metadata
    """
    raise NotImplementedError("Phase 2 - parser not yet implemented")


def parse_pdf(pdf_path: str, max_pages: int = 50) -> dict:
    """
    Phase 2: Extract text from PDF using PyMuPDF.

    Returns:
        Dict with keys: text, title, page_count, ocr_required, metadata
    """
    raise NotImplementedError("Phase 2 - parser not yet implemented")
