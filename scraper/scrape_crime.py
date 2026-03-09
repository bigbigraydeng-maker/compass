#!/usr/bin/env python3
"""
QLD Police Crime Data Scraper

Downloads QLD Police Division crime statistics CSV,
filters relevant divisions for our 7 suburbs,
aggregates into 5 crime categories, and writes to Supabase.

Data Source: QLD Government Open Data
URL: https://open-crime-data.s3-ap-southeast-2.amazonaws.com/Crime%20Statistics/division_Reported_Offences_Number.csv
"""

import requests
import io
import csv
import psycopg2
import os
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables (try multiple paths for worktree compatibility)
_env_candidates = [
    os.path.join(os.path.dirname(__file__), '..', 'backend', '.env'),
    os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'backend', '.env'),
]
for _env_path in _env_candidates:
    if os.path.exists(_env_path):
        load_dotenv(_env_path)
        break
DATABASE_URL = os.getenv('DATABASE_URL')

# QLD Police CSV URL
CRIME_CSV_URL = "https://open-crime-data.s3-ap-southeast-2.amazonaws.com/Crime%20Statistics/division_Reported_Offences_Number.csv"

# Division -> Suburb mapping with population weights
# QLD Police reports crime by Division, not by suburb.
# We split division totals by ABS 2021 Census population ratios.
# Source: ABS 2021 Census QuickStats for each suburb
# 从集中配置加载（按警区分组，含人口权重）
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from suburbs_config import get_police_division_map as _get_pdm
_pdm = _get_pdm()
DIVISION_SUBURB_MAP = {
    div: {s['suburb']: {'pop': s['population']} for s in subs}
    for div, subs in _pdm.items()
}

# Target divisions (keys of the mapping)
TARGET_DIVISIONS = set(DIVISION_SUBURB_MAP.keys())

def _get_suburb_weight(division, suburb):
    """Get population-based weight for a suburb within its division."""
    suburbs = DIVISION_SUBURB_MAP.get(division, {})
    total_pop = sum(s['pop'] for s in suburbs.values())
    if total_pop == 0:
        return 1.0 / max(len(suburbs), 1)
    return suburbs.get(suburb, {}).get('pop', 0) / total_pop

# Offence columns -> 5 crime categories
# Column indices (0-based) from the CSV header
CRIME_CATEGORIES = {
    'violent_crime': {
        'label': 'Violent Crime',
        'columns': [
            2,   # Homicide (Murder)
            3,   # Other Homicide
            4,   # Attempted Murder
            9,   # Assault
            10,  # Grievous Assault
            11,  # Serious Assault
            12,  # Serious Assault (Other)
            13,  # Common Assault
            14,  # Sexual Offences
            17,  # Robbery
            18,  # Armed Robbery
            19,  # Unarmed Robbery
        ]
    },
    'property_crime': {
        'label': 'Property Crime',
        'columns': [
            29,  # Unlawful Entry
            30,  # Unlawful Entry With Intent - Dwelling
            31,  # Unlawful Entry Without Violence - Dwelling
            32,  # Unlawful Entry With Violence - Dwelling
            33,  # Unlawful Entry With Intent - Shop
            34,  # Unlawful Entry With Intent - Other
            35,  # Arson
            36,  # Other Property Damage
            37,  # Unlawful Use of Motor Vehicle
        ]
    },
    'theft_fraud': {
        'label': 'Theft & Fraud',
        'columns': [
            38,  # Other Theft (excl. Unlawful Entry)
            39,  # Stealing from Dwellings
            40,  # Shop Stealing
            41,  # Vehicles (steal from/enter with intent)
            42,  # Other Stealing
            43,  # Fraud
            44,  # Fraud by Computer
            46,  # Fraud by Credit Card
            47,  # Identity Fraud
            49,  # Handling Stolen Goods
        ]
    },
    'drug_offences': {
        'label': 'Drug Offences',
        'columns': [
            55,  # Drug Offences
            56,  # Trafficking Drugs
            57,  # Possess Drugs
            58,  # Produce Drugs
            59,  # Sell Supply Drugs
        ]
    },
    'public_order': {
        'label': 'Public Order',
        'columns': [
            72,  # Breach Domestic Violence Protection Order
            73,  # Trespassing and Vagrancy
            74,  # Weapons Act Offences
            80,  # Good Order Offences
            84,  # Public Nuisance
            87,  # Dangerous Operation of a Vehicle
            88,  # Drink Driving
        ]
    }
}


def parse_month_year(month_year_str):
    """
    Parse QLD Police month-year format (e.g., 'JAN24', 'DEC23') to a sortable string.
    Returns format 'YYYY-MM' or None if cannot parse.
    """
    month_map = {
        'JAN': '01', 'FEB': '02', 'MAR': '03', 'APR': '04',
        'MAY': '05', 'JUN': '06', 'JUL': '07', 'AUG': '08',
        'SEP': '09', 'OCT': '10', 'NOV': '11', 'DEC': '12'
    }

    if len(month_year_str) != 5:
        return None

    month_abbr = month_year_str[:3].upper()
    year_suffix = month_year_str[3:]

    if month_abbr not in month_map:
        return None

    try:
        year_num = int(year_suffix)
        # 2-digit year: 00-99 -> 2000-2099
        full_year = 2000 + year_num
        return f"{full_year}-{month_map[month_abbr]}"
    except ValueError:
        return None


def download_crime_data():
    """Download and parse QLD Police crime CSV."""
    print("Downloading QLD Police crime data...")
    response = requests.get(CRIME_CSV_URL, timeout=120)
    response.raise_for_status()
    print(f"  Downloaded: {len(response.content):,} bytes")

    reader = csv.reader(io.StringIO(response.text))
    header = next(reader)

    # Determine cutoff: last 24 months
    now = datetime.now()
    cutoff_year = now.year - 2
    cutoff_month = now.month
    cutoff_str = f"{cutoff_year}-{cutoff_month:02d}"

    print(f"  Filtering data from {cutoff_str} onwards")
    print(f"  Target divisions: {TARGET_DIVISIONS}")

    records = []
    skipped = 0

    for row in reader:
        division = row[0]
        month_year_raw = row[1]

        # Only process target divisions
        if division not in TARGET_DIVISIONS:
            continue

        # Parse month-year
        month_year = parse_month_year(month_year_raw)
        if not month_year:
            skipped += 1
            continue

        # Filter for last 24 months
        if month_year < cutoff_str:
            continue

        # Get suburbs for this division
        suburbs_info = DIVISION_SUBURB_MAP[division]

        # Calculate crime category totals for this division
        for cat_key, cat_info in CRIME_CATEGORIES.items():
            division_total = 0
            for col_idx in cat_info['columns']:
                try:
                    val = row[col_idx].strip()
                    if val:
                        division_total += int(val)
                except (IndexError, ValueError):
                    pass

            # Split by population weight for each suburb
            for suburb in suburbs_info:
                weight = _get_suburb_weight(division, suburb)
                suburb_count = round(division_total * weight)
                records.append({
                    'division': division,
                    'suburb': suburb,
                    'month_year': month_year,
                    'category': cat_key,
                    'count': suburb_count
                })

    print(f"  Parsed {len(records)} records (skipped {skipped} unparseable rows)")
    return records


def save_to_database(records):
    """Save crime data to Supabase."""
    if not DATABASE_URL:
        print("ERROR: DATABASE_URL not configured")
        return

    try:
        conn = psycopg2.connect(DATABASE_URL)
        cur = conn.cursor()

        # Clear existing data
        cur.execute("DELETE FROM crime_stats")
        print(f"  Cleared existing crime_stats data")

        # Insert new data
        insert_sql = """
            INSERT INTO crime_stats (division, suburb, month_year, category, count)
            VALUES (%s, %s, %s, %s, %s)
        """

        for record in records:
            cur.execute(insert_sql, (
                record['division'],
                record['suburb'],
                record['month_year'],
                record['category'],
                record['count']
            ))

        conn.commit()
        print(f"  Inserted {len(records)} records into crime_stats")

        # Verify
        cur.execute("SELECT suburb, category, COUNT(*), SUM(count) FROM crime_stats GROUP BY suburb, category ORDER BY suburb, category")
        results = cur.fetchall()
        print("\n  Summary by suburb and category:")
        current_suburb = None
        for row in results:
            if row[0] != current_suburb:
                current_suburb = row[0]
                print(f"\n  {current_suburb}:")
            print(f"    {row[1]}: {row[2]} months, total {row[3]} offences")

        cur.close()
        conn.close()

    except Exception as e:
        print(f"ERROR: Database operation failed: {e}")
        import traceback
        traceback.print_exc()


def main():
    """Main function."""
    print("=" * 60)
    print("QLD Police Crime Data Scraper")
    print("=" * 60)

    records = download_crime_data()

    if records:
        save_to_database(records)
        print("\nDone!")
    else:
        print("\nNo records found!")


if __name__ == "__main__":
    main()
