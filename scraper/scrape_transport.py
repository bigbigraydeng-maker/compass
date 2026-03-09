#!/usr/bin/env python3
"""
Transport Data Scraper

Uses Google Maps Places API to search for transit stations,
bus stations, and train stations near our 7 target suburbs.
Writes results to Supabase transport_data table.
"""

import requests
import time
import psycopg2
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv(os.path.join(os.path.dirname(__file__), '..', 'backend', '.env'))
DATABASE_URL = os.getenv('DATABASE_URL')
API_KEY = os.getenv('GOOGLE_MAPS_API_KEY')

# 从集中配置加载坐标
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'backend'))
from suburbs_config import get_suburb_coords
SUBURBS = get_suburb_coords()

# Transport types to search
TRANSPORT_TYPES = [
    {'type': 'train_station', 'keyword': 'train station'},
    {'type': 'bus_station', 'keyword': 'bus station'},
    {'type': 'transit_station', 'keyword': 'transit station'},
    {'type': 'light_rail_station', 'keyword': 'light rail station'},
]

# Search radius in meters (5km)
SEARCH_RADIUS = 5000


def search_places(suburb, lat, lng, transport_type, keyword):
    """
    Search for transport POIs near a suburb using Google Maps Nearby Search.
    """
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    params = {
        'location': f"{lat},{lng}",
        'radius': SEARCH_RADIUS,
        'keyword': keyword,
        'key': API_KEY
    }

    places = []

    try:
        response = requests.get(url, params=params, timeout=30)
        data = response.json()

        if data.get('status') != 'OK':
            if data.get('status') == 'ZERO_RESULTS':
                return places
            print(f"    API status: {data.get('status')} for {keyword} in {suburb}")
            return places

        for result in data.get('results', []):
            place = {
                'suburb': suburb,
                'type': transport_type,
                'name': result.get('name', ''),
                'address': result.get('vicinity', ''),
                'lat': result['geometry']['location']['lat'],
                'lng': result['geometry']['location']['lng'],
            }
            places.append(place)

        # Handle pagination (up to 2 more pages)
        page_count = 1
        while 'next_page_token' in data and page_count < 3:
            time.sleep(2)  # Required delay for next_page_token
            params['pagetoken'] = data['next_page_token']
            response = requests.get(url, params=params, timeout=30)
            data = response.json()

            for result in data.get('results', []):
                place = {
                    'suburb': suburb,
                    'type': transport_type,
                    'name': result.get('name', ''),
                    'address': result.get('vicinity', ''),
                    'lat': result['geometry']['location']['lat'],
                    'lng': result['geometry']['location']['lng'],
                }
                places.append(place)

            page_count += 1

    except Exception as e:
        print(f"    Error searching {keyword} in {suburb}: {e}")

    return places


def deduplicate_places(places):
    """Remove duplicate places based on name + coordinates."""
    seen = set()
    unique = []
    for place in places:
        # Use name + rounded coordinates as key for deduplication
        key = (place['name'], round(place['lat'], 5), round(place['lng'], 5))
        if key not in seen:
            seen.add(key)
            unique.append(place)
    return unique


def save_to_database(records):
    """Save transport data to Supabase."""
    if not DATABASE_URL:
        print("ERROR: DATABASE_URL not configured")
        return

    try:
        conn = psycopg2.connect(DATABASE_URL)
        cur = conn.cursor()

        # Clear existing data
        cur.execute("DELETE FROM transport_data")
        print(f"  Cleared existing transport_data")

        # Insert new data
        insert_sql = """
            INSERT INTO transport_data (suburb, type, name, address, lat, lng)
            VALUES (%s, %s, %s, %s, %s, %s)
        """

        for record in records:
            cur.execute(insert_sql, (
                record['suburb'],
                record['type'],
                record['name'],
                record['address'],
                record['lat'],
                record['lng']
            ))

        conn.commit()
        print(f"  Inserted {len(records)} records into transport_data")

        # Verify
        cur.execute("SELECT suburb, type, COUNT(*) FROM transport_data GROUP BY suburb, type ORDER BY suburb, type")
        results = cur.fetchall()
        print("\n  Summary by suburb and type:")
        current_suburb = None
        for row in results:
            if row[0] != current_suburb:
                current_suburb = row[0]
                print(f"\n  {current_suburb}:")
            print(f"    {row[1]}: {row[2]} stations")

        cur.close()
        conn.close()

    except Exception as e:
        print(f"ERROR: Database operation failed: {e}")
        import traceback
        traceback.print_exc()


def main():
    """Main function."""
    print("=" * 60)
    print("Transport Data Scraper (Google Maps Places API)")
    print("=" * 60)

    if not API_KEY or API_KEY == 'YOUR_API_KEY_HERE':
        print("ERROR: GOOGLE_MAPS_API_KEY not configured in .env")
        return

    all_places = []

    for suburb, coords in SUBURBS.items():
        print(f"\nSearching transport in {suburb}...")

        suburb_places = []
        for transport in TRANSPORT_TYPES:
            print(f"  Searching {transport['keyword']}...")
            places = search_places(
                suburb,
                coords['lat'],
                coords['lng'],
                transport['type'],
                transport['keyword']
            )
            suburb_places.extend(places)
            print(f"    Found {len(places)} results")

            # Rate limiting - be gentle with the API
            time.sleep(0.5)

        # Deduplicate within suburb
        unique_places = deduplicate_places(suburb_places)
        print(f"  Total unique: {len(unique_places)} (from {len(suburb_places)} raw)")
        all_places.extend(unique_places)

    print(f"\nTotal transport POIs found: {len(all_places)}")

    if all_places:
        save_to_database(all_places)
        print("\nDone!")
    else:
        print("\nNo transport data found!")


if __name__ == "__main__":
    main()
