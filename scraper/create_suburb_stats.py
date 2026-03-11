#!/usr/bin/env python3
"""Create and populate suburb_stats table."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from database import execute_query, get_db_connection, get_db_cursor

# 1. Create suburb_stats table
with get_db_connection() as conn:
    with get_db_cursor(conn) as cur:
        cur.execute("""
            CREATE TABLE IF NOT EXISTS suburb_stats (
                id SERIAL PRIMARY KEY,
                suburb VARCHAR(100) UNIQUE NOT NULL,
                median_price NUMERIC(12, 2) DEFAULT 0,
                total_sales INTEGER DEFAULT 0,
                monthly_growth_rate NUMERIC(8, 4) DEFAULT 0,
                updated_at TIMESTAMP DEFAULT NOW()
            )
        """)
        conn.commit()
        print("suburb_stats table created!")

# 2. Populate with aggregate data from sales
execute_query("""
    INSERT INTO suburb_stats (suburb, median_price, total_sales, monthly_growth_rate, updated_at)
    SELECT
        s.suburb,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.sale_price) as median_price,
        COUNT(*) as total_sales,
        0 as monthly_growth_rate,
        NOW() as updated_at
    FROM sales s
    WHERE s.suburb IS NOT NULL AND s.sale_price > 0
    GROUP BY s.suburb
    ON CONFLICT (suburb) DO UPDATE SET
        median_price = EXCLUDED.median_price,
        total_sales = EXCLUDED.total_sales,
        updated_at = NOW()
""")
print("suburb_stats populated!")

# 3. Verify
stats = execute_query("SELECT suburb, median_price, total_sales FROM suburb_stats ORDER BY median_price DESC")
print("\nSuburb stats:")
for r in stats:
    mp = int(r["median_price"])
    print(f"  {r['suburb']}: median ${mp:,}, sales: {r['total_sales']}")
