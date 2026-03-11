"""
DevIntel Database Schema - 6 tables for RAG pipeline
Uses existing database.execute_query() from the main app.
"""

import sys
import os

# Add parent directory to path so we can import database module
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import execute_query


def init_devintel_tables():
    """Create all DevIntel tables. Safe to call multiple times (IF NOT EXISTS)."""
    print("[DevIntel] Initializing database tables...")

    # Check if pgvector extension is available
    pgvector_available = False
    try:
        execute_query("CREATE EXTENSION IF NOT EXISTS vector")
        pgvector_available = True
        print("[DevIntel] pgvector extension enabled")
    except Exception as e:
        print(f"[DevIntel] pgvector not available: {e}")
        print("[DevIntel] Will create tables without vector columns. Enable pgvector in Supabase Dashboard first.")

    # 1. Data Source Registry
    execute_query("""
        CREATE TABLE IF NOT EXISTS devintel_sources (
            id SERIAL PRIMARY KEY,
            source_name VARCHAR(100) UNIQUE NOT NULL,
            source_type VARCHAR(20) NOT NULL DEFAULT 'html',
            base_url TEXT NOT NULL,
            crawl_frequency VARCHAR(20) DEFAULT 'daily',
            priority VARCHAR(5) DEFAULT 'P2',
            is_active BOOLEAN DEFAULT TRUE,
            last_crawled_at TIMESTAMP,
            last_success_at TIMESTAMP,
            consecutive_failures INTEGER DEFAULT 0,
            total_documents INTEGER DEFAULT 0,
            parser_config JSONB DEFAULT '{}',
            metadata JSONB DEFAULT '{}',
            created_at TIMESTAMP DEFAULT NOW(),
            updated_at TIMESTAMP DEFAULT NOW()
        )
    """)

    # 2. Documents
    execute_query("""
        CREATE TABLE IF NOT EXISTS devintel_documents (
            id SERIAL PRIMARY KEY,
            url_hash VARCHAR(32) UNIQUE NOT NULL,
            url TEXT NOT NULL,
            title TEXT,
            source_name VARCHAR(100) NOT NULL,
            source_type VARCHAR(20) NOT NULL DEFAULT 'html',
            content_text TEXT,
            content_hash VARCHAR(32),
            previous_hash VARCHAR(32),
            version INTEGER DEFAULT 1,
            change_detected_at TIMESTAMP,
            file_path TEXT,
            file_size INTEGER,
            parse_status VARCHAR(20) DEFAULT 'pending',
            parse_error TEXT,
            ocr_required BOOLEAN DEFAULT FALSE,
            ocr_status VARCHAR(20),
            suburb VARCHAR(100),
            suburbs TEXT[],
            doc_date DATE,
            doc_type VARCHAR(50),
            metadata JSONB DEFAULT '{}',
            crawl_status VARCHAR(20) DEFAULT 'pending',
            last_crawled_at TIMESTAMP,
            created_at TIMESTAMP DEFAULT NOW(),
            updated_at TIMESTAMP DEFAULT NOW()
        )
    """)

    # Document indexes
    for idx_sql in [
        "CREATE INDEX IF NOT EXISTS idx_dd_url_hash ON devintel_documents(url_hash)",
        "CREATE INDEX IF NOT EXISTS idx_dd_source ON devintel_documents(source_name)",
        "CREATE INDEX IF NOT EXISTS idx_dd_suburb ON devintel_documents(suburb)",
        "CREATE INDEX IF NOT EXISTS idx_dd_doc_type ON devintel_documents(doc_type)",
        "CREATE INDEX IF NOT EXISTS idx_dd_doc_date ON devintel_documents(doc_date DESC)",
        "CREATE INDEX IF NOT EXISTS idx_dd_parse_status ON devintel_documents(parse_status)",
    ]:
        try:
            execute_query(idx_sql)
        except Exception as e:
            print(f"[DevIntel] Index warning: {e}")

    # 3. Chunks + Vector
    embedding_col = "embedding vector(1536)," if pgvector_available else "-- embedding vector(1536) requires pgvector"
    empty_json = "{}"
    chunks_sql = f"""
        CREATE TABLE IF NOT EXISTS devintel_chunks (
            id SERIAL PRIMARY KEY,
            document_id INTEGER NOT NULL REFERENCES devintel_documents(id) ON DELETE CASCADE,
            chunk_index INTEGER NOT NULL,
            chunk_text TEXT NOT NULL,
            token_count INTEGER DEFAULT 0,
            {embedding_col}
            suburb VARCHAR(100),
            doc_type VARCHAR(50),
            doc_date DATE,
            source_name VARCHAR(100),
            metadata JSONB DEFAULT '{empty_json}',
            created_at TIMESTAMP DEFAULT NOW(),
            UNIQUE(document_id, chunk_index)
        )
    """
    try:
        execute_query(chunks_sql)
        print(f"[DevIntel] Chunks table created (pgvector={'yes' if pgvector_available else 'no'})")
    except Exception as e:
        print(f"[DevIntel] Chunks table error: {e}")
        # Fallback: create without vector column
        if pgvector_available:
            print("[DevIntel] Retrying chunks table without vector column...")
            execute_query("""
                CREATE TABLE IF NOT EXISTS devintel_chunks (
                    id SERIAL PRIMARY KEY,
                    document_id INTEGER NOT NULL REFERENCES devintel_documents(id) ON DELETE CASCADE,
                    chunk_index INTEGER NOT NULL,
                    chunk_text TEXT NOT NULL,
                    token_count INTEGER DEFAULT 0,
                    suburb VARCHAR(100),
                    doc_type VARCHAR(50),
                    doc_date DATE,
                    source_name VARCHAR(100),
                    metadata JSONB DEFAULT '{}',
                    created_at TIMESTAMP DEFAULT NOW(),
                    UNIQUE(document_id, chunk_index)
                )
            """)

    for idx_sql in [
        "CREATE INDEX IF NOT EXISTS idx_dc_doc_id ON devintel_chunks(document_id)",
        "CREATE INDEX IF NOT EXISTS idx_dc_suburb ON devintel_chunks(suburb)",
        "CREATE INDEX IF NOT EXISTS idx_dc_doc_type ON devintel_chunks(doc_type)",
    ]:
        try:
            execute_query(idx_sql)
        except Exception as e:
            print(f"[DevIntel] Index warning: {e}")

    # 4. Crawl Logs
    execute_query("""
        CREATE TABLE IF NOT EXISTS devintel_crawl_logs (
            id SERIAL PRIMARY KEY,
            source_name VARCHAR(100) NOT NULL,
            crawl_type VARCHAR(20) DEFAULT 'scheduled',
            started_at TIMESTAMP DEFAULT NOW(),
            finished_at TIMESTAMP,
            pages_found INTEGER DEFAULT 0,
            pages_new INTEGER DEFAULT 0,
            pages_updated INTEGER DEFAULT 0,
            pages_failed INTEGER DEFAULT 0,
            chunks_created INTEGER DEFAULT 0,
            error_message TEXT,
            status VARCHAR(20) DEFAULT 'running'
        )
    """)

    # 5. Query Logs
    execute_query("""
        CREATE TABLE IF NOT EXISTS devintel_query_logs (
            id SERIAL PRIMARY KEY,
            query_text TEXT NOT NULL,
            suburb VARCHAR(100),
            doc_type VARCHAR(50),
            results_count INTEGER DEFAULT 0,
            top_similarity FLOAT,
            response_time_ms INTEGER,
            source VARCHAR(20) DEFAULT 'search',
            created_at TIMESTAMP DEFAULT NOW()
        )
    """)

    try:
        execute_query("CREATE INDEX IF NOT EXISTS idx_dql_created ON devintel_query_logs(created_at DESC)")
    except Exception:
        pass

    # 6. Conversations (Phase 3 - table created now, used later)
    execute_query("""
        CREATE TABLE IF NOT EXISTS devintel_conversations (
            id SERIAL PRIMARY KEY,
            session_id VARCHAR(64) NOT NULL,
            role VARCHAR(10) NOT NULL,
            content TEXT NOT NULL,
            suburb VARCHAR(100),
            context_type VARCHAR(30) DEFAULT 'general',
            rag_chunk_ids INTEGER[],
            created_at TIMESTAMP DEFAULT NOW()
        )
    """)

    try:
        execute_query("CREATE INDEX IF NOT EXISTS idx_dconv_session ON devintel_conversations(session_id, created_at)")
    except Exception:
        pass

    print("[DevIntel] All 6 tables initialized successfully.")
    _sync_sources()


def _sync_sources():
    """Sync DEVINTEL_SOURCES config into devintel_sources table."""
    from .config import DEVINTEL_SOURCES

    for src in DEVINTEL_SOURCES:
        try:
            execute_query("""
                INSERT INTO devintel_sources (source_name, source_type, base_url, crawl_frequency, priority, metadata)
                VALUES (%s, %s, %s, %s, %s, %s::jsonb)
                ON CONFLICT (source_name) DO UPDATE SET
                    base_url = EXCLUDED.base_url,
                    crawl_frequency = EXCLUDED.crawl_frequency,
                    priority = EXCLUDED.priority,
                    updated_at = NOW()
            """, (
                src["source_name"],
                src["source_type"],
                src["base_url"],
                src["crawl_frequency"],
                src["priority"],
                '{"description": "' + src.get("description", "") + '"}',
            ))
        except Exception as e:
            print(f"[DevIntel] Source sync warning for {src['source_name']}: {e}")

    print(f"[DevIntel] Synced {len(DEVINTEL_SOURCES)} data sources to DB.")
