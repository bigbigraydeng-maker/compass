"""
DevIntel Crawler - Phase 2 placeholder.

HTML/PDF page crawler for government data sources.
Reuses patterns from main.py's _fetch_article_content().
"""


def crawl_source(source_config: dict) -> dict:
    """
    Phase 2: Crawl a single data source.

    Args:
        source_config: Dict from devintel_sources table

    Returns:
        Dict with crawl results: pages_found, pages_new, etc.
    """
    raise NotImplementedError("Phase 2 - crawler not yet implemented")


def crawl_all_sources():
    """
    Phase 2: Crawl all active sources due for refresh.
    """
    raise NotImplementedError("Phase 2 - crawler not yet implemented")
