"""
DevIntel API Routes - FastAPI Router for development intelligence endpoints.

Phase 1: /status, /search
Phase 2: +/crawl, /documents
Phase 3: +/chat
"""

from typing import Optional

from fastapi import APIRouter, Query, HTTPException
from pydantic import BaseModel

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from database import execute_query

from .retriever import retrieve_chunks

devintel_router = APIRouter(prefix="/api/devintel", tags=["DevIntel"])


# ====== Response Models ======

class StatusResponse(BaseModel):
    status: str = "ok"
    sources_count: int = 0
    documents_count: int = 0
    chunks_count: int = 0
    recent_queries: int = 0


class SearchResult(BaseModel):
    chunk_text: str
    source_name: str
    title: Optional[str] = None
    doc_type: Optional[str] = None
    doc_date: Optional[str] = None
    similarity: float = 0.0
    url: Optional[str] = None


class SearchResponse(BaseModel):
    query: str
    suburb: Optional[str] = None
    results_count: int = 0
    results: list = []


# ====== Endpoints ======

@devintel_router.get("/status", response_model=StatusResponse)
async def devintel_status():
    """Get DevIntel system status: table counts and health check."""
    try:
        sources = execute_query("SELECT COUNT(*) as cnt FROM devintel_sources WHERE is_active = TRUE")
        docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
        chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
        queries = execute_query(
            "SELECT COUNT(*) as cnt FROM devintel_query_logs WHERE created_at > NOW() - INTERVAL '24 hours'"
        )

        return StatusResponse(
            status="ok",
            sources_count=sources[0]["cnt"] if sources else 0,
            documents_count=docs[0]["cnt"] if docs else 0,
            chunks_count=chunks[0]["cnt"] if chunks else 0,
            recent_queries=queries[0]["cnt"] if queries else 0,
        )
    except Exception as e:
        return StatusResponse(status=f"error: {str(e)}")


@devintel_router.get("/search", response_model=SearchResponse)
async def devintel_search(
    q: str = Query(..., min_length=2, description="Search query"),
    suburb: Optional[str] = Query(None, description="Filter by suburb name"),
    doc_type: Optional[str] = Query(None, description="Filter by document type"),
    top_k: int = Query(8, ge=1, le=20, description="Max results"),
):
    """Search development intelligence knowledge base using vector similarity."""
    try:
        chunks = retrieve_chunks(
            query=q,
            suburb=suburb,
            doc_type=doc_type,
            top_k=top_k,
            log_source="search",
        )

        results = []
        for chunk in chunks:
            results.append(SearchResult(
                chunk_text=chunk.get("chunk_text", ""),
                source_name=chunk.get("source_name", ""),
                title=chunk.get("title"),
                doc_type=chunk.get("doc_type"),
                doc_date=str(chunk["doc_date"]) if chunk.get("doc_date") else None,
                similarity=round(chunk.get("similarity", 0), 4),
                url=chunk.get("url"),
            ))

        return SearchResponse(
            query=q,
            suburb=suburb,
            results_count=len(results),
            results=results,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Search failed: {str(e)}")


@devintel_router.get("/sources")
async def devintel_sources():
    """List all registered data sources and their status."""
    try:
        sources = execute_query("""
            SELECT source_name, source_type, base_url, crawl_frequency, priority,
                   is_active, last_crawled_at, last_success_at, consecutive_failures,
                   total_documents, created_at
            FROM devintel_sources
            ORDER BY priority, source_name
        """)
        return {"sources": sources, "count": len(sources)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@devintel_router.get("/query-logs")
async def devintel_query_logs(
    limit: int = Query(20, ge=1, le=100),
):
    """View recent query logs for debugging and analytics."""
    try:
        logs = execute_query("""
            SELECT query_text, suburb, doc_type, results_count,
                   top_similarity, response_time_ms, source, created_at
            FROM devintel_query_logs
            ORDER BY created_at DESC
            LIMIT %s
        """, (limit,))
        return {"logs": logs, "count": len(logs)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
