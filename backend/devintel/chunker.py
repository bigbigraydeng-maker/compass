"""
DevIntel Text Chunker - Split text into overlapping chunks for embedding.

Strategy: sentence-boundary aware chunking with configurable size and overlap.
Uses tiktoken for accurate token counting (same tokenizer as OpenAI models).
"""

import re
from typing import List, Tuple

try:
    import tiktoken
    _enc = tiktoken.encoding_for_model("text-embedding-3-small")
except ImportError:
    _enc = None
    print("[DevIntel] tiktoken not installed, falling back to word-count estimation")

from .config import CHUNK_SIZE, CHUNK_OVERLAP


def count_tokens(text: str) -> int:
    """Count tokens using tiktoken, fallback to word estimation."""
    if _enc:
        return len(_enc.encode(text))
    # Rough estimation: 1 token ~= 0.75 words for English, ~0.5 for mixed CJK
    words = len(text.split())
    cjk_chars = sum(1 for c in text if '\u4e00' <= c <= '\u9fff')
    return words + cjk_chars  # CJK chars roughly 1 token each


def _split_sentences(text: str) -> List[str]:
    """Split text into sentences, preserving sentence boundaries."""
    # Handle common sentence endings (English + Chinese)
    sentences = re.split(r'(?<=[.!?;。！？；\n])\s*', text)
    # Filter empty strings and strip whitespace
    return [s.strip() for s in sentences if s.strip()]


def chunk_text(
    text: str,
    chunk_size: int = CHUNK_SIZE,
    chunk_overlap: int = CHUNK_OVERLAP,
) -> List[Tuple[str, int]]:
    """
    Split text into overlapping chunks at sentence boundaries.

    Args:
        text: The input text to chunk
        chunk_size: Max tokens per chunk (default from config: 600)
        chunk_overlap: Token overlap between consecutive chunks (default: 80)

    Returns:
        List of (chunk_text, token_count) tuples
    """
    if not text or not text.strip():
        return []

    sentences = _split_sentences(text)
    if not sentences:
        return []

    chunks = []
    current_sentences = []
    current_tokens = 0

    for sentence in sentences:
        sentence_tokens = count_tokens(sentence)

        # If a single sentence exceeds chunk_size, split it by words
        if sentence_tokens > chunk_size:
            # Flush current buffer first
            if current_sentences:
                chunk_text_str = ' '.join(current_sentences)
                chunks.append((chunk_text_str, count_tokens(chunk_text_str)))
                current_sentences = []
                current_tokens = 0

            # Split long sentence into sub-chunks
            words = sentence.split()
            sub_chunk = []
            sub_tokens = 0
            for word in words:
                wt = count_tokens(word)
                if sub_tokens + wt > chunk_size and sub_chunk:
                    sc_text = ' '.join(sub_chunk)
                    chunks.append((sc_text, count_tokens(sc_text)))
                    # Keep overlap
                    overlap_words = []
                    overlap_t = 0
                    for w in reversed(sub_chunk):
                        wt2 = count_tokens(w)
                        if overlap_t + wt2 > chunk_overlap:
                            break
                        overlap_words.insert(0, w)
                        overlap_t += wt2
                    sub_chunk = overlap_words
                    sub_tokens = overlap_t
                sub_chunk.append(word)
                sub_tokens += wt
            if sub_chunk:
                sc_text = ' '.join(sub_chunk)
                chunks.append((sc_text, count_tokens(sc_text)))
            continue

        # Would adding this sentence exceed chunk_size?
        if current_tokens + sentence_tokens > chunk_size and current_sentences:
            # Emit current chunk
            chunk_text_str = ' '.join(current_sentences)
            chunks.append((chunk_text_str, count_tokens(chunk_text_str)))

            # Build overlap: take sentences from the end of current_sentences
            overlap_sentences = []
            overlap_tokens = 0
            for s in reversed(current_sentences):
                st = count_tokens(s)
                if overlap_tokens + st > chunk_overlap:
                    break
                overlap_sentences.insert(0, s)
                overlap_tokens += st

            current_sentences = overlap_sentences
            current_tokens = overlap_tokens

        current_sentences.append(sentence)
        current_tokens += sentence_tokens

    # Flush remaining
    if current_sentences:
        chunk_text_str = ' '.join(current_sentences)
        chunks.append((chunk_text_str, count_tokens(chunk_text_str)))

    return chunks
