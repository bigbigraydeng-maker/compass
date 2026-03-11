"""
DevIntel Configuration - Data sources, embedding parameters, chunk settings
"""

# ====== Embedding & Chunking ======

EMBEDDING_MODEL = "text-embedding-3-small"
EMBEDDING_DIMENSIONS = 1536
CHUNK_SIZE = 600          # tokens per chunk (v2: up from 500, suits government docs)
CHUNK_OVERLAP = 80        # token overlap between chunks
TOP_K = 8                 # max chunks to retrieve
SIMILARITY_THRESHOLD = 0.3  # min cosine similarity to keep
MAX_CHUNKS_PER_DOC = 2    # v2: same-document dedup limit

# ====== Data Sources (will be synced to devintel_sources table) ======

DEVINTEL_SOURCES = [
    {
        "source_name": "bcc_da_tracker",
        "source_type": "html",
        "base_url": "https://developmenti.brisbane.qld.gov.au",
        "crawl_frequency": "daily",
        "priority": "P1",
        "description": "Brisbane City Council Development Application Tracker",
    },
    {
        "source_name": "qld_state_development",
        "source_type": "html",
        "base_url": "https://planning.statedevelopment.qld.gov.au",
        "crawl_frequency": "weekly",
        "priority": "P1",
        "description": "QLD State Development Assessment",
    },
    {
        "source_name": "bcc_city_plan",
        "source_type": "html",
        "base_url": "https://cityplan.brisbane.qld.gov.au",
        "crawl_frequency": "monthly",
        "priority": "P1",
        "description": "Brisbane City Plan - Zoning Changes",
    },
    {
        "source_name": "qld_government_gazette",
        "source_type": "pdf",
        "base_url": "https://publications.qld.gov.au",
        "crawl_frequency": "weekly",
        "priority": "P1",
        "description": "QLD Government Gazette - Statutory Notices",
    },
    {
        "source_name": "qld_infrastructure",
        "source_type": "html",
        "base_url": "https://statedevelopment.qld.gov.au/infrastructure",
        "crawl_frequency": "monthly",
        "priority": "P2",
        "description": "QLD Infrastructure Projects (Cross River Rail, Metro)",
    },
    {
        "source_name": "brisbane_2032",
        "source_type": "html",
        "base_url": "https://brisbane2032.com",
        "crawl_frequency": "monthly",
        "priority": "P2",
        "description": "Brisbane 2032 Olympics Venue Planning",
    },
    {
        "source_name": "bcc_council_minutes",
        "source_type": "pdf",
        "base_url": "https://brisbane.qld.gov.au/council-meetings",
        "crawl_frequency": "weekly",
        "priority": "P2",
        "description": "BCC Council Meeting Minutes",
    },
    {
        "source_name": "epbc_referrals",
        "source_type": "html",
        "base_url": "https://epbcnotices.environment.gov.au",
        "crawl_frequency": "weekly",
        "priority": "P3",
        "description": "Federal Environmental Protection Referrals",
    },
    {
        "source_name": "tmr_projects",
        "source_type": "html",
        "base_url": "https://tmr.qld.gov.au/Projects",
        "crawl_frequency": "monthly",
        "priority": "P3",
        "description": "Transport and Main Roads Projects",
    },
    {
        "source_name": "edq_priority_areas",
        "source_type": "html",
        "base_url": "https://edq.com.au",
        "crawl_frequency": "monthly",
        "priority": "P3",
        "description": "Economic Development QLD - Priority Development Areas",
    },
]

# ====== Metadata JSONB schema conventions ======
# Each document's metadata JSONB may contain:
# {
#   "project_name": "Cross River Rail",
#   "authority": "QLD State Government",
#   "stage": "under_construction",  # proposed|approved|under_construction|completed|cancelled
#   "estimated_completion": "2026",
#   "affected_suburbs": ["Woolloongabba", "Dutton Park"],
#   "tags": ["infrastructure", "transport", "rail"]
# }

METADATA_STAGES = [
    "proposed",
    "approved",
    "under_construction",
    "completed",
    "cancelled",
]
