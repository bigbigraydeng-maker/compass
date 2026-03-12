#!/usr/bin/env python3
"""
Import scraped sales data from CSV into Compass database.

Usage:
    python scraper/import_sales.py [--csv data/raw_sales.csv]

Steps:
1. Read CSV (output of scrape_sales.py)
2. Upsert into properties table
3. Insert into sales table (skip duplicates by address+sold_date)
4. Refresh suburb_stats aggregates
"""

import csv
import os
import sys
from datetime import datetime

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from database import get_db_connection, get_db_cursor, execute_query


def normalize_suburb(raw: str) -> str:
    """Normalize suburb name to title case to match suburbs_config convention."""
    return raw.strip().title()


def import_csv(csv_path: str = "data/raw_sales_new.csv"):
    """Import raw_sales CSV into properties + sales tables."""
    if not os.path.exists(csv_path):
        print(f"[ERROR] CSV not found: {csv_path}")
        return

    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    print(f"[Import] Read {len(rows)} rows from {csv_path}")

    inserted = 0
    skipped = 0
    errors = 0

    with get_db_connection() as conn:
        with get_db_cursor(conn) as cur:
            for row in rows:
                try:
                    # Address in CSV already includes suburb, e.g. "104 Kitchener Road, ASCOT"
                    full_address = row.get('address', '').strip()
                    suburb = normalize_suburb(row.get('suburb', ''))
                    property_type = row.get('property_type', '').strip()
                    bedrooms = int(row.get('bedrooms', 0) or 0)
                    bathrooms = int(row.get('bathrooms', 0) or 0)
                    car_spaces = int(row.get('car_spaces', 0) or 0)
                    land_size = float(row.get('land_size', 0) or 0)
                    sold_price = float(row.get('sold_price', 0) or 0)
                    sold_date = row.get('sold_date', '').strip()

                    if not full_address or not suburb or sold_price <= 0 or not sold_date:
                        skipped += 1
                        continue

                    # Check for duplicate sale
                    cur.execute(
                        """SELECT id FROM sales s
                           JOIN properties p ON s.property_id = p.id
                           WHERE p.full_address = %s AND s.sale_date = %s""",
                        (full_address, sold_date)
                    )
                    dup = cur.fetchone()
                    if dup:
                        skipped += 1
                        continue

                    # Upsert property
                    cur.execute(
                        """INSERT INTO properties (full_address, suburb, postcode, property_type, bedrooms, bathrooms, car_spaces, land_size)
                           VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                           ON CONFLICT (full_address) DO UPDATE SET
                             property_type = EXCLUDED.property_type,
                             bedrooms = EXCLUDED.bedrooms,
                             bathrooms = EXCLUDED.bathrooms,
                             car_spaces = EXCLUDED.car_spaces,
                             land_size = EXCLUDED.land_size
                           RETURNING id""",
                        (full_address, suburb, '', property_type, bedrooms, bathrooms, car_spaces, land_size)
                    )
                    prop_row = cur.fetchone()
                    property_id = prop_row['id'] if prop_row else None

                    if not property_id:
                        skipped += 1
                        continue

                    # Insert sale
                    cur.execute(
                        """INSERT INTO sales (property_id, sale_price, sale_date, suburb)
                           VALUES (%s, %s, %s, %s)""",
                        (property_id, sold_price, sold_date, suburb)
                    )
                    inserted += 1
                except Exception as e:
                    errors += 1
                    if errors <= 5:
                        print(f"[Import] Error on row: {e}")

            conn.commit()

    print(f"[Import] Done: {inserted} inserted, {skipped} skipped, {errors} errors")
    return inserted


def refresh_suburb_stats():
    """Recalculate suburb_stats from sales data."""
    print("[Import] Refreshing suburb_stats...")

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

    print("[Import] suburb_stats refreshed")


if __name__ == "__main__":
    csv_file = sys.argv[1] if len(sys.argv) > 1 else "data/raw_sales_new.csv"
    count = import_csv(csv_file)
    if count and count > 0:
        refresh_suburb_stats()
    print("[Import] Complete")
