"""
一次性脚本：为 qld_schools.json 中的学校添加 lat/lng 坐标
使用 Google Geocoding API
"""
import json
import os
import sys
import urllib.request
import urllib.parse
import time

API_KEY = os.getenv("GOOGLE_MAPS_API_KEY", "AIzaSyAT1zfCy7Qr1_5oEeiLxaMyIwQfowyM0pI")
GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json"

def geocode(query: str) -> tuple:
    """Geocode a query string, return (lat, lng) or (None, None)."""
    params = urllib.parse.urlencode({
        "address": query,
        "key": API_KEY,
        "region": "au",
        "components": "country:AU|administrative_area:Queensland",
    })
    url = f"{GEOCODE_URL}?{params}"
    try:
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode())
        if data.get("status") == "OK" and data.get("results"):
            loc = data["results"][0]["geometry"]["location"]
            return loc["lat"], loc["lng"]
        else:
            print(f"  ⚠️ Geocode failed for '{query}': {data.get('status')}")
            return None, None
    except Exception as e:
        print(f"  ❌ Error geocoding '{query}': {e}")
        return None, None


def main():
    schools_path = os.path.join(
        os.path.dirname(__file__), "..", "data", "qld_schools.json"
    )
    schools_path = os.path.abspath(schools_path)

    print(f"📂 Loading schools from: {schools_path}")
    with open(schools_path, "r", encoding="utf-8") as f:
        schools = json.load(f)

    print(f"📋 Found {len(schools)} schools")

    updated = 0
    for i, school in enumerate(schools):
        name = school["name"]
        suburb = school.get("suburb", "Brisbane")

        # Skip if already has coordinates
        if school.get("lat") and school.get("lng"):
            print(f"  ✅ [{i+1}/{len(schools)}] {name} — already has coords")
            continue

        query = f"{name}, {suburb}, QLD, Australia"
        print(f"  🔍 [{i+1}/{len(schools)}] Geocoding: {query}")

        lat, lng = geocode(query)

        if lat and lng:
            # Validate within Brisbane area
            if -28.0 < lat < -27.0 and 152.5 < lng < 153.5:
                school["lat"] = round(lat, 6)
                school["lng"] = round(lng, 6)
                updated += 1
                print(f"     ✅ ({lat:.4f}, {lng:.4f})")
            else:
                print(f"     ⚠️ Out of Brisbane range: ({lat:.4f}, {lng:.4f})")
                # Try with just suburb
                lat2, lng2 = geocode(f"{suburb}, Brisbane, QLD, Australia")
                if lat2 and lng2 and -28.0 < lat2 < -27.0:
                    school["lat"] = round(lat2, 6)
                    school["lng"] = round(lng2, 6)
                    updated += 1
                    print(f"     ✅ Fallback to suburb center: ({lat2:.4f}, {lng2:.4f})")
        else:
            # Fallback: use suburb center
            print(f"     ⚠️ Trying suburb center fallback...")
            lat2, lng2 = geocode(f"{suburb}, Brisbane, QLD, Australia")
            if lat2 and lng2:
                school["lat"] = round(lat2, 6)
                school["lng"] = round(lng2, 6)
                updated += 1
                print(f"     ✅ Fallback: ({lat2:.4f}, {lng2:.4f})")

        # Rate limit: 50 requests/sec max, but let's be gentle
        time.sleep(0.2)

    # Save
    with open(schools_path, "w", encoding="utf-8") as f:
        json.dump(schools, f, indent=2, ensure_ascii=False)

    print(f"\n✅ Done! Updated {updated}/{len(schools)} schools with coordinates")

    # Verify all have coords
    missing = [s["name"] for s in schools if not s.get("lat") or not s.get("lng")]
    if missing:
        print(f"⚠️ Schools still missing coords: {missing}")
    else:
        print("🎉 All schools have valid coordinates!")


if __name__ == "__main__":
    main()
