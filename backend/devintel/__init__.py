"""
Compass DevIntel - Brisbane Development Intelligence RAG Package

Phase 1: pgvector + embedding + seed data -> existing analysis auto-enhanced
Phase 2: auto-crawl + PDF parsing
Phase 3: conversation memory + frontend + enhancements
"""

from .schema import init_devintel_tables
from .api_routes import devintel_router
from .rag import get_devintel_context
from .scheduler_jobs import scheduled_devintel_crawl

__all__ = [
    "init_devintel_tables",
    "devintel_router",
    "get_devintel_context",
    "scheduled_devintel_crawl",
]
