"""
DevIntel RAG Orchestrator - Retrieval -> Format as prompt section.

This module is called by main.py's _build_ai_prompt() to inject
Section 10: Development Intelligence into the AI analysis prompt.
"""

from typing import Optional

from .retriever import retrieve_chunks


def get_devintel_context(suburb: Optional[str] = None, query: Optional[str] = None) -> str:
    """
    Retrieve development intelligence and format as prompt section.

    Called by _build_ai_prompt() in main.py to add Section 10.

    Args:
        suburb: Target suburb name (e.g., "Sunnybank")
        query: Optional specific query (defaults to suburb-based search)

    Returns:
        Formatted string for prompt injection, e.g.:
        "## 10. Development Intelligence\n..."
    """
    if not suburb and not query:
        return ""

    # Build search query
    search_query = query or f"{suburb} development projects infrastructure zoning changes"

    try:
        chunks = retrieve_chunks(
            query=search_query,
            suburb=suburb,
            top_k=6,  # Slightly fewer than max for prompt size
            log_source="rag",
        )
    except Exception as e:
        print(f"[DevIntel] RAG retrieval failed: {e}")
        return "## 10. Development Intelligence\n- Data temporarily unavailable"

    if not chunks:
        return "## 10. Development Intelligence\n- No development intelligence data available for this area"

    # Format chunks into prompt section
    lines = ["## 10. Development Intelligence (RAG)"]
    lines.append(f"以下是与 {suburb or 'this area'} 相关的开发情报（来源：政府公开数据）：\n")

    for i, chunk in enumerate(chunks, 1):
        source = chunk.get("source_name", "unknown")
        title = chunk.get("title", "")
        doc_date = chunk.get("doc_date", "")
        similarity = chunk.get("similarity", 0)
        text = chunk.get("chunk_text", "")

        # Truncate very long chunks for prompt efficiency
        if len(text) > 800:
            text = text[:800] + "..."

        header_parts = [f"[{source}]"]
        if title:
            header_parts.append(title)
        if doc_date:
            header_parts.append(f"({doc_date})")

        lines.append(f"**{i}. {' '.join(header_parts)}** (relevance: {similarity:.2f})")
        lines.append(text)
        lines.append("")  # blank line between entries

    lines.append("---")
    lines.append("Note: Above development intelligence is retrieved from government data sources via RAG. "
                 "Use this to enhance analysis but cross-reference with official sources for critical decisions.")

    return "\n".join(lines)
