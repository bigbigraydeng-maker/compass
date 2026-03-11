"""
DevIntel Seed Script - Load suburb_development.json into the vector database.

This populates devintel_documents and devintel_chunks with initial data
from the existing suburb_development.json file.

Usage:
    cd backend
    python -m devintel.seed
"""

import json
import hashlib
import os
import sys

# Ensure parent is in path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database import execute_query
from devintel.chunker import chunk_text, count_tokens
from devintel.embedder import embed_texts


SEED_FILE = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "data", "suburb_development.json"
)


def _make_hash(text: str) -> str:
    return hashlib.md5(text.encode()).hexdigest()


def _build_document_text(suburb: str, data: dict) -> str:
    """
    Convert a suburb's development data into a single text document
    suitable for chunking and embedding.
    """
    lines = []
    lines.append(f"# {suburb} Development Intelligence")
    lines.append("")

    # Zoning Summary
    zoning = data.get("zoning_summary", "")
    if zoning:
        lines.append("## Zoning Summary")
        lines.append(zoning)
        lines.append("")

    zoning_cn = data.get("zoning_summary_cn", "")
    if zoning_cn:
        lines.append(zoning_cn)
        lines.append("")

    # Key Projects
    projects = data.get("key_projects", [])
    if projects:
        lines.append("## Key Development Projects")
        for p in projects:
            name = p.get("name", "Unknown Project")
            name_cn = p.get("name_cn", "")
            desc = p.get("description", "")
            desc_cn = p.get("description_cn", "")
            status = p.get("status", "unknown")
            completion = p.get("estimated_completion", "TBD")

            lines.append(f"### {name}")
            if name_cn:
                lines.append(f"({name_cn})")
            lines.append(f"Status: {status}")
            lines.append(f"Estimated completion: {completion}")
            if desc:
                lines.append(desc)
            if desc_cn:
                lines.append(desc_cn)
            lines.append("")

    # Infrastructure
    infra = data.get("infrastructure", [])
    if infra:
        lines.append("## Infrastructure")
        for item in infra:
            lines.append(f"- {item}")
        lines.append("")

    infra_cn = data.get("infrastructure_cn", [])
    if infra_cn:
        for item in infra_cn:
            lines.append(f"- {item}")
        lines.append("")

    # Council Priority
    priority = data.get("council_priority", "")
    if priority:
        lines.append(f"## Council Priority: {priority}")
        lines.append("")

    return "\n".join(lines)


def _extract_metadata(suburb: str, data: dict) -> dict:
    """Extract structured metadata from suburb development data."""
    projects = data.get("key_projects", [])
    project_names = [p.get("name", "") for p in projects if p.get("name")]

    return {
        "project_names": project_names,
        "council_priority": data.get("council_priority", ""),
        "authority": "Brisbane City Council",
        "stage": "mixed",  # Suburb-level seed data covers multiple stages
        "affected_suburbs": [suburb],
        "tags": ["development", "infrastructure", "zoning", "seed_data"],
    }


def seed_from_json():
    """Main seed function: load JSON, create documents, chunk, embed, store."""
    print(f"[DevIntel Seed] Loading data from {SEED_FILE}")

    if not os.path.exists(SEED_FILE):
        print(f"[DevIntel Seed] ERROR: Seed file not found: {SEED_FILE}")
        return False

    with open(SEED_FILE, 'r', encoding='utf-8') as f:
        suburb_data = json.load(f)

    print(f"[DevIntel Seed] Found {len(suburb_data)} suburbs")

    total_docs = 0
    total_chunks = 0
    all_chunks_to_embed = []  # (doc_id, chunk_index, chunk_text, token_count, suburb, metadata)

    for suburb, data in suburb_data.items():
        print(f"[DevIntel Seed] Processing: {suburb}")

        # Build document text
        doc_text = _build_document_text(suburb, data)
        if not doc_text.strip():
            print(f"  Skipping {suburb}: empty content")
            continue

        url = f"seed://suburb_development/{suburb.lower().replace(' ', '_')}"
        url_hash = _make_hash(url)
        content_hash = _make_hash(doc_text)
        metadata = _extract_metadata(suburb, data)

        # Upsert document
        try:
            existing = execute_query(
                "SELECT id, content_hash FROM devintel_documents WHERE url_hash = %s",
                (url_hash,)
            )

            if existing:
                doc_id = existing[0]["id"]
                old_hash = existing[0].get("content_hash", "")
                if old_hash == content_hash:
                    print(f"  {suburb}: unchanged, skipping")
                    continue
                # Update existing document
                execute_query("""
                    UPDATE devintel_documents
                    SET content_text = %s, content_hash = %s, previous_hash = %s,
                        version = version + 1, change_detected_at = NOW(),
                        parse_status = 'parsed', updated_at = NOW(),
                        metadata = %s::jsonb
                    WHERE id = %s
                """, (doc_text, content_hash, old_hash, json.dumps(metadata), doc_id))
                # Delete old chunks (will re-create)
                execute_query("DELETE FROM devintel_chunks WHERE document_id = %s", (doc_id,))
                print(f"  {suburb}: updated (version+1)")
            else:
                # Insert new document
                execute_query("""
                    INSERT INTO devintel_documents
                    (url_hash, url, title, source_name, source_type, content_text,
                     content_hash, suburb, doc_type, parse_status, metadata, crawl_status)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s::jsonb, %s)
                """, (
                    url_hash, url,
                    f"{suburb} Development Intelligence",
                    "seed_data", "json",
                    doc_text, content_hash,
                    suburb, "development_overview",
                    "parsed",
                    json.dumps(metadata),
                    "completed",
                ))
                # Get the new doc ID
                result = execute_query(
                    "SELECT id FROM devintel_documents WHERE url_hash = %s",
                    (url_hash,)
                )
                doc_id = result[0]["id"]
                print(f"  {suburb}: new document created (id={doc_id})")

            total_docs += 1

        except Exception as e:
            print(f"  ERROR creating document for {suburb}: {e}")
            continue

        # Chunk the document
        chunks = chunk_text(doc_text)
        print(f"  {suburb}: {len(chunks)} chunks")

        for idx, (ct, tc) in enumerate(chunks):
            all_chunks_to_embed.append((doc_id, idx, ct, tc, suburb, metadata))

    if not all_chunks_to_embed:
        print("[DevIntel Seed] No chunks to embed. Done.")
        return True

    # Batch embed all chunks
    print(f"\n[DevIntel Seed] Embedding {len(all_chunks_to_embed)} chunks...")
    chunk_texts = [c[2] for c in all_chunks_to_embed]

    try:
        embeddings = embed_texts(chunk_texts)
    except Exception as e:
        print(f"[DevIntel Seed] ERROR embedding: {e}")
        return False

    # Store chunks + embeddings
    print(f"[DevIntel Seed] Storing {len(all_chunks_to_embed)} chunks with embeddings...")

    for i, (doc_id, chunk_idx, ct, tc, suburb, metadata) in enumerate(all_chunks_to_embed):
        embedding = embeddings[i]
        embedding_str = "[" + ",".join(str(x) for x in embedding) + "]"

        try:
            execute_query("""
                INSERT INTO devintel_chunks
                (document_id, chunk_index, chunk_text, token_count, embedding,
                 suburb, doc_type, source_name, metadata)
                VALUES (%s, %s, %s, %s, %s::vector, %s, %s, %s, %s::jsonb)
                ON CONFLICT (document_id, chunk_index) DO UPDATE SET
                    chunk_text = EXCLUDED.chunk_text,
                    token_count = EXCLUDED.token_count,
                    embedding = EXCLUDED.embedding,
                    metadata = EXCLUDED.metadata
            """, (
                doc_id, chunk_idx, ct, tc, embedding_str,
                suburb, "development_overview", "seed_data",
                json.dumps(metadata),
            ))
            total_chunks += 1
        except Exception as e:
            print(f"  ERROR storing chunk {chunk_idx} for doc {doc_id}: {e}")

    print(f"\n[DevIntel Seed] Complete! {total_docs} documents, {total_chunks} chunks embedded.")

    # Update source stats
    try:
        execute_query("""
            UPDATE devintel_sources
            SET total_documents = (SELECT COUNT(*) FROM devintel_documents WHERE source_name = 'seed_data'),
                last_success_at = NOW(),
                updated_at = NOW()
            WHERE source_name = 'seed_data'
        """)
    except Exception:
        pass  # seed_data source may not exist in sources table

    return True


if __name__ == "__main__":
    print("=" * 60)
    print("DevIntel Seed: Loading suburb_development.json into vector DB")
    print("=" * 60)

    # Load environment
    from dotenv import load_dotenv
    load_dotenv()

    success = seed_from_json()

    if success:
        print("\n[OK] Seed completed successfully!")

        # Quick stats
        try:
            docs = execute_query("SELECT COUNT(*) as cnt FROM devintel_documents")
            chunks = execute_query("SELECT COUNT(*) as cnt FROM devintel_chunks")
            print(f"  Documents: {docs[0]['cnt']}")
            print(f"  Chunks: {chunks[0]['cnt']}")
        except:
            pass
    else:
        print("\n[FAIL] Seed failed. Check errors above.")
        sys.exit(1)
