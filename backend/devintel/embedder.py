"""
DevIntel Embedder - OpenAI text-embedding-3-small wrapper.

Reuses the existing OpenAI client pattern from main.py.
Supports batch embedding with rate limit handling.
"""

import os
import time
from typing import List, Optional

from openai import OpenAI

from .config import EMBEDDING_MODEL, EMBEDDING_DIMENSIONS

# Reuse the same env var as main app
_client: Optional[OpenAI] = None


def _get_client() -> OpenAI:
    """Get or create OpenAI client (lazy singleton)."""
    global _client
    if _client is None:
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise RuntimeError("[DevIntel] OPENAI_API_KEY not set")
        _client = OpenAI(api_key=api_key)
    return _client


def embed_single(text: str) -> List[float]:
    """
    Generate embedding for a single text.

    Returns:
        List of floats (1536 dimensions)
    """
    if not text or not text.strip():
        return [0.0] * EMBEDDING_DIMENSIONS

    client = _get_client()
    response = client.embeddings.create(
        model=EMBEDDING_MODEL,
        input=text.strip()[:8000],  # truncate to ~8000 chars safety limit
    )
    return response.data[0].embedding


def embed_texts(texts: List[str], batch_size: int = 50) -> List[List[float]]:
    """
    Generate embeddings for a batch of texts.

    Args:
        texts: List of text strings
        batch_size: Max texts per API call (OpenAI supports up to 2048)

    Returns:
        List of embedding vectors (same order as input)
    """
    if not texts:
        return []

    client = _get_client()
    all_embeddings = []

    # Process in batches
    for i in range(0, len(texts), batch_size):
        batch = [t.strip()[:8000] if t else "" for t in texts[i:i + batch_size]]

        # Replace empty strings with a space to avoid API errors
        batch = [t if t else " " for t in batch]

        retries = 3
        for attempt in range(retries):
            try:
                response = client.embeddings.create(
                    model=EMBEDDING_MODEL,
                    input=batch,
                )
                batch_embeddings = [item.embedding for item in response.data]
                all_embeddings.extend(batch_embeddings)
                break
            except Exception as e:
                if attempt < retries - 1:
                    wait = 2 ** attempt
                    print(f"[DevIntel] Embedding batch {i//batch_size} failed (attempt {attempt+1}): {e}. Retrying in {wait}s...")
                    time.sleep(wait)
                else:
                    print(f"[DevIntel] Embedding batch {i//batch_size} failed after {retries} attempts: {e}")
                    # Return zero vectors for failed batch
                    all_embeddings.extend([[0.0] * EMBEDDING_DIMENSIONS] * len(batch))

        # Small delay between batches to respect rate limits
        if i + batch_size < len(texts):
            time.sleep(0.1)

    return all_embeddings
