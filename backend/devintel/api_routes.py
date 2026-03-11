"""
DevIntel API Routes - FastAPI Router for development intelligence endpoints.

Phase 1: /status, /search, /sources, /query-logs
Phase 2: +/documents, /crawl/trigger, /crawl/logs
Phase 3: +/chat
"""

import json
import threading
from typing import Optional, List

from fastapi import APIRouter, Query, HTTPException, BackgroundTasks
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


# ====== Phase 2 Endpoints ======

@devintel_router.get("/documents")
async def devintel_documents(
    source_name: Optional[str] = Query(None, description="Filter by source"),
    doc_type: Optional[str] = Query(None, description="Filter by document type"),
    source_type: Optional[str] = Query(None, description="Filter: html/pdf/json"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
):
    """List documents in the knowledge base with filtering."""
    try:
        conditions = []
        params = []

        if source_name:
            conditions.append("source_name = %s")
            params.append(source_name)
        if doc_type:
            conditions.append("doc_type = %s")
            params.append(doc_type)
        if source_type:
            conditions.append("source_type = %s")
            params.append(source_type)

        where = " AND ".join(conditions) if conditions else "TRUE"
        params.extend([limit, offset])

        docs = execute_query(f"""
            SELECT id, url, title, source_name, source_type, doc_type,
                   suburb, parse_status, file_size, version,
                   metadata, crawl_status, last_crawled_at, created_at
            FROM devintel_documents
            WHERE {where}
            ORDER BY created_at DESC
            LIMIT %s OFFSET %s
        """, tuple(params))

        total = execute_query(f"""
            SELECT COUNT(*) as cnt FROM devintel_documents WHERE {where}
        """, tuple(params[:-2]) if params[:-2] else None)

        # Get doc type distribution
        doc_types = execute_query("""
            SELECT doc_type, COUNT(*) as cnt
            FROM devintel_documents
            WHERE doc_type IS NOT NULL
            GROUP BY doc_type
            ORDER BY cnt DESC
        """)

        return {
            "documents": docs,
            "total": total[0]["cnt"] if total else 0,
            "limit": limit,
            "offset": offset,
            "doc_types": doc_types,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@devintel_router.get("/documents/{doc_id}")
async def devintel_document_detail(doc_id: int):
    """Get full details of a specific document including its chunks."""
    try:
        doc = execute_query(
            "SELECT * FROM devintel_documents WHERE id = %s", (doc_id,)
        )
        if not doc:
            raise HTTPException(status_code=404, detail="Document not found")

        chunks = execute_query("""
            SELECT chunk_index, chunk_text, token_count, doc_type
            FROM devintel_chunks
            WHERE document_id = %s
            ORDER BY chunk_index
        """, (doc_id,))

        result = doc[0]
        # Don't send the full content_text in the response (too large)
        if result.get("content_text"):
            result["content_preview"] = result["content_text"][:500]
            result["content_length"] = len(result["content_text"])
            del result["content_text"]

        result["chunks"] = chunks
        result["chunk_count"] = len(chunks)
        return result
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


class CrawlRequest(BaseModel):
    source_name: Optional[str] = None
    priority: Optional[str] = None
    urls: Optional[List[str]] = None


# Track running crawl status
_crawl_status = {"running": False, "last_result": None}


@devintel_router.post("/crawl/trigger")
async def devintel_crawl_trigger(
    request: CrawlRequest,
    background_tasks: BackgroundTasks,
):
    """Trigger a manual crawl. Runs in background."""
    if _crawl_status["running"]:
        raise HTTPException(status_code=409, detail="A crawl is already running")

    def run_crawl():
        _crawl_status["running"] = True
        try:
            from devintel.crawler import crawl_all_sources, crawl_source, crawl_specific_urls

            if request.urls:
                result = crawl_specific_urls(
                    request.urls,
                    source_name=request.source_name or "manual"
                )
            elif request.source_name:
                sources = execute_query(
                    "SELECT * FROM devintel_sources WHERE source_name = %s",
                    (request.source_name,)
                )
                if not sources:
                    _crawl_status["last_result"] = {"error": f"Source not found: {request.source_name}"}
                    return
                result = crawl_source(sources[0])
            elif request.priority:
                result = crawl_all_sources(priority_filter=request.priority)
            else:
                result = crawl_all_sources()

            _crawl_status["last_result"] = result
        except Exception as e:
            _crawl_status["last_result"] = {"error": str(e)}
        finally:
            _crawl_status["running"] = False

    background_tasks.add_task(run_crawl)

    return {
        "status": "started",
        "message": "Crawl started in background. Check /api/devintel/crawl/status for progress.",
    }


@devintel_router.get("/crawl/status")
async def devintel_crawl_status():
    """Check the status of a running or last completed crawl."""
    return {
        "running": _crawl_status["running"],
        "last_result": _crawl_status["last_result"],
    }


@devintel_router.get("/crawl/logs")
async def devintel_crawl_logs(
    limit: int = Query(20, ge=1, le=100),
    source_name: Optional[str] = Query(None),
):
    """View crawl history logs."""
    try:
        if source_name:
            logs = execute_query("""
                SELECT source_name, crawl_type, started_at, finished_at,
                       pages_found, pages_new, pages_updated, pages_failed,
                       chunks_created, status, error_message
                FROM devintel_crawl_logs
                WHERE source_name = %s
                ORDER BY started_at DESC
                LIMIT %s
            """, (source_name, limit))
        else:
            logs = execute_query("""
                SELECT source_name, crawl_type, started_at, finished_at,
                       pages_found, pages_new, pages_updated, pages_failed,
                       chunks_created, status, error_message
                FROM devintel_crawl_logs
                ORDER BY started_at DESC
                LIMIT %s
            """, (limit,))
        return {"logs": logs, "count": len(logs)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@devintel_router.get("/stats")
async def devintel_stats():
    """Comprehensive statistics for the DevIntel knowledge base."""
    try:
        # Basic counts
        docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
        chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
        pdf_docs = execute_query(
            "SELECT COUNT(*) as cnt FROM devintel_documents WHERE source_type = 'pdf'"
        )
        html_docs = execute_query(
            "SELECT COUNT(*) as cnt FROM devintel_documents WHERE source_type = 'html'"
        )
        ocr_needed = execute_query(
            "SELECT COUNT(*) as cnt FROM devintel_documents WHERE ocr_required = TRUE"
        )

        # By project
        by_project = execute_query("""
            SELECT metadata->>'project_name' as project, COUNT(*) as cnt
            FROM devintel_documents
            WHERE metadata->>'project_name' IS NOT NULL
            GROUP BY metadata->>'project_name'
            ORDER BY cnt DESC
        """)

        # By doc_type
        by_doc_type = execute_query("""
            SELECT doc_type, COUNT(*) as cnt
            FROM devintel_documents
            WHERE doc_type IS NOT NULL
            GROUP BY doc_type
            ORDER BY cnt DESC
        """)

        # Token stats
        token_stats = execute_query("""
            SELECT SUM(token_count) as total_tokens,
                   AVG(token_count) as avg_tokens
            FROM devintel_chunks
        """)

        # Recent crawls
        recent_crawls = execute_query("""
            SELECT source_name, started_at, status, pages_new, chunks_created
            FROM devintel_crawl_logs
            ORDER BY started_at DESC
            LIMIT 5
        """)

        return {
            "documents": {
                "total": docs[0]["cnt"] if docs else 0,
                "pdf": pdf_docs[0]["cnt"] if pdf_docs else 0,
                "html": html_docs[0]["cnt"] if html_docs else 0,
                "ocr_needed": ocr_needed[0]["cnt"] if ocr_needed else 0,
            },
            "chunks": {
                "total": chunks[0]["cnt"] if chunks else 0,
                "total_tokens": int(token_stats[0]["total_tokens"]) if token_stats and token_stats[0]["total_tokens"] else 0,
                "avg_tokens": round(float(token_stats[0]["avg_tokens"]), 1) if token_stats and token_stats[0]["avg_tokens"] else 0,
            },
            "by_project": by_project,
            "by_doc_type": by_doc_type,
            "recent_crawls": recent_crawls,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
