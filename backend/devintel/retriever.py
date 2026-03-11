"""
DevIntel Retriever - pgvector cosine similarity search with metadata filtering.

Features:
- Suburb-scoped search with global fallback
- Doc type filtering
- Date range filtering
- Same-document dedup (max 2 chunks per document)
- Query logging
"""

import time
import json
from typing import List, Optional, Dict, Any

import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from database import execute_query

from .config import TOP_K, SIMILARITY_THRESHOLD, MAX_CHUNKS_PER_DOC
from .embedder import embed_single


def retrieve_chunks(
    query: str,
    suburb: Optional[str] = None,
    doc_type: Optional[str] = None,
    date_from: Optional[str] = None,
    top_k: int = TOP_K,
    log_source: str = "search",
) -> List[Dict[str, Any]]:
    """
    Retrieve relevant chunks from the vector database.

    Args:
        query: User's search query text
        suburb: Optional suburb name to filter by
        doc_type: Optional document type filter
        date_from: Optional start date (YYYY-MM-DD) for recency filter
        top_k: Max number of results to return
        log_source: Source identifier for query logging (search/rag/chat)

    Returns:
        List of chunk dicts with keys:
        - chunk_text, source_name, doc_type, doc_date, document_id
        - url, title, similarity, metadata
    """
    start_time = time.time()

    # Generate query embedding
    try:
        query_embedding = embed_single(query)
    except Exception as e:
        print(f"[DevIntel] Embedding failed for query: {e}")
        return []

    embedding_str = "[" + ",".join(str(x) for x in query_embedding) + "]"

    # Build dynamic WHERE clause
    conditions = []
    params = []

    if suburb:
        conditions.append(f"c.suburb = %s")
        params.append(suburb)

    if doc_type:
        conditions.append(f"c.doc_type = %s")
        params.append(doc_type)

    if date_from:
        conditions.append(f"c.doc_date >= %s::date")
        params.append(date_from)

    where_clause = ""
    if conditions:
        where_clause = "WHERE " + " AND ".join(conditions)

    # Fetch more than top_k to allow dedup, then trim
    fetch_limit = top_k * 3

    sql = f"""
        SELECT c.id, c.chunk_text, c.source_name, c.doc_type, c.doc_date,
               c.document_id, c.token_count, c.metadata AS chunk_metadata,
               d.url, d.title, d.metadata AS doc_metadata,
               1 - (c.embedding <=> %s::vector) AS similarity
        FROM devintel_chunks c
        JOIN devintel_documents d ON d.id = c.document_id
        {where_clause}
        ORDER BY c.embedding <=> %s::vector
        LIMIT %s
    """

    # Build params: embedding twice (for SELECT and ORDER BY), then conditions, then limit
    query_params = [embedding_str] + params + [embedding_str, fetch_limit]

    # Rearrange: the SQL has embedding first, then WHERE conditions, then embedding for ORDER BY, then LIMIT
    # Actually let me rebuild the SQL properly with positional params
    sql = _build_retrieval_sql(conditions, fetch_limit)
    query_params = _build_retrieval_params(embedding_str, params, fetch_limit)

    try:
        results = execute_query(sql, tuple(query_params))
    except Exception as e:
        print(f"[DevIntel] Retrieval query failed: {e}")
        # Fallback: if suburb filter returned too few, try global
        if suburb and "vector" in str(e).lower():
            print("[DevIntel] Vector search error, returning empty")
        return []

    # Filter by similarity threshold
    results = [r for r in results if r.get("similarity", 0) >= SIMILARITY_THRESHOLD]

    # Suburb fallback: if filtered results < 3, retry without suburb filter
    if suburb and len(results) < 3:
        print(f"[DevIntel] Only {len(results)} results for suburb={suburb}, trying global search...")
        fallback_results = retrieve_chunks(
            query=query,
            suburb=None,  # Remove suburb filter
            doc_type=doc_type,
            date_from=date_from,
            top_k=top_k,
            log_source="_fallback",  # Prevent recursive logging
        )
        # Merge: suburb results first, then global
        seen_ids = {r["id"] for r in results}
        for fr in fallback_results:
            if fr["id"] not in seen_ids:
                results.append(fr)
                seen_ids.add(fr["id"])

    # Same-document dedup: max MAX_CHUNKS_PER_DOC per document
    deduped = _dedup_by_document(results, MAX_CHUNKS_PER_DOC)

    # Trim to top_k
    final = deduped[:top_k]

    # Log query (unless it's a fallback call)
    elapsed_ms = int((time.time() - start_time) * 1000)
    if log_source != "_fallback":
        _log_query(query, suburb, doc_type, len(final),
                   final[0]["similarity"] if final else None,
                   elapsed_ms, log_source)

    return final


def _build_retrieval_sql(conditions: List[str], fetch_limit: int) -> str:
    """Build the retrieval SQL with proper parameter placeholders."""
    where_clause = ""
    if conditions:
        where_clause = "WHERE " + " AND ".join(conditions)

    return f"""
        SELECT c.id, c.chunk_text, c.source_name, c.doc_type, c.doc_date,
               c.document_id, c.token_count, c.metadata AS chunk_metadata,
               d.url, d.title, d.metadata AS doc_metadata,
               1 - (c.embedding <=> %s::vector) AS similarity
        FROM devintel_chunks c
        JOIN devintel_documents d ON d.id = c.document_id
        {where_clause}
        ORDER BY c.embedding <=> %s::vector
        LIMIT %s
    """


def _build_retrieval_params(embedding_str: str, condition_params: List, fetch_limit: int) -> List:
    """Build parameter list: embedding + conditions + embedding + limit."""
    return [embedding_str] + condition_params + [embedding_str, fetch_limit]


def _dedup_by_document(results: List[Dict], max_per_doc: int) -> List[Dict]:
    """
    Remove excess chunks from the same document.
    Preserves order (by similarity). Each document gets at most max_per_doc chunks.
    """
    doc_count = {}
    deduped = []
    for r in results:
        doc_id = r.get("document_id")
        count = doc_count.get(doc_id, 0)
        if count < max_per_doc:
            deduped.append(r)
            doc_count[doc_id] = count + 1
    return deduped


def _log_query(query: str, suburb: Optional[str], doc_type: Optional[str],
               results_count: int, top_similarity: Optional[float],
               response_time_ms: int, source: str):
    """Log query to devintel_query_logs table."""
    try:
        execute_query("""
            INSERT INTO devintel_query_logs (query_text, suburb, doc_type, results_count,
                                             top_similarity, response_time_ms, source)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (query, suburb, doc_type, results_count, top_similarity, response_time_ms, source))
    except Exception as e:
        # Non-critical, just log
        print(f"[DevIntel] Query log failed: {e}")
