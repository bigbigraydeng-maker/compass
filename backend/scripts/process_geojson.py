"""
下载 BCC 郊区边界 GeoJSON，过滤到学校 catchment 涉及的郊区，简化后保存
"""
import json
import os
import urllib.request

BCC_GEOJSON_URL = "https://data.brisbane.qld.gov.au/api/explore/v2.1/catalog/datasets/suburb-boundaries/exports/geojson?limit=-1"

# 从 qld_schools.json 提取的所有 catchment suburbs
NEEDED_SUBURBS = {
    "Sunnybank Hills", "Sunnybank", "Runcorn", "Parkinson", "Underwood",
    "Robertson", "Algester", "Calamvale", "Eight Mile Plains", "Macgregor",
    "Stretton", "Drewvale", "Rochedale", "Rochedale South", "Springwood",
    "Mansfield", "Wishart", "Mackenzie", "Burbank", "Upper Mount Gravatt",
    "Mount Gravatt East", "Carindale", "Mount Gravatt", "Ascot", "Hamilton",
    "Hendra", "Clayfield", "Nundah", "Wooloowin", "Eagle Farm", "Pinkenba",
    "Brisbane Airport", "Albion", "Eagle Junction", "Carina", "Camp Hill",
}

# Normalize for matching (BCC uses UPPER CASE)
NEEDED_UPPER = {s.upper() for s in NEEDED_SUBURBS}

OUTPUT_PATH = os.path.join(
    os.path.dirname(__file__), "..", "..", "frontend", "public", "data", "brisbane_suburbs.geojson"
)


def simplify_coords(coords, tolerance=0.0005):
    """Simple Douglas-Peucker-like point reduction: keep every Nth point."""
    if len(coords) <= 20:
        return coords
    # Keep roughly 1 point per tolerance unit of change
    result = [coords[0]]
    for i in range(1, len(coords)):
        dx = abs(coords[i][0] - result[-1][0])
        dy = abs(coords[i][1] - result[-1][1])
        if dx > tolerance or dy > tolerance:
            result.append(coords[i])
    # Always keep last point (close polygon)
    if result[-1] != coords[-1]:
        result.append(coords[-1])
    return result


def main():
    print("Downloading BCC suburb boundaries...")
    req = urllib.request.Request(BCC_GEOJSON_URL)
    req.add_header("User-Agent", "Compass/1.0")
    with urllib.request.urlopen(req, timeout=60) as resp:
        raw = resp.read().decode("utf-8")

    data = json.loads(raw)
    total = len(data.get("features", []))
    print(f"Downloaded {total} suburb boundaries")

    # Filter
    filtered_features = []
    matched = set()
    for feature in data["features"]:
        props = feature.get("properties", {})
        suburb_name = props.get("suburb_name", "").strip()

        if suburb_name.upper() in NEEDED_UPPER:
            # Normalize suburb name to title case
            normalized = suburb_name.title()

            # Special cases
            name_map = {
                "Eight Mile Plains": "Eight Mile Plains",
                "Upper Mount Gravatt": "Upper Mount Gravatt",
                "Mount Gravatt East": "Mount Gravatt East",
                "Mount Gravatt": "Mount Gravatt",
                "Rochedale South": "Rochedale South",
                "Sunnybank Hills": "Sunnybank Hills",
                "Eagle Farm": "Eagle Farm",
                "Eagle Junction": "Eagle Junction",
                "Camp Hill": "Camp Hill",
                "Brisbane Airport": "Brisbane Airport",
            }
            # Try to find the correct casing from our needed list
            for orig in NEEDED_SUBURBS:
                if orig.upper() == suburb_name.upper():
                    normalized = orig
                    break

            # Simplify geometry to reduce file size
            geom = feature.get("geometry", {})
            if geom.get("type") == "Polygon":
                simplified_rings = []
                for ring in geom.get("coordinates", []):
                    simplified_rings.append(simplify_coords(ring))
                geom["coordinates"] = simplified_rings
            elif geom.get("type") == "MultiPolygon":
                simplified_polys = []
                for poly in geom.get("coordinates", []):
                    simplified_rings = []
                    for ring in poly:
                        simplified_rings.append(simplify_coords(ring))
                    simplified_polys.append(simplified_rings)
                geom["coordinates"] = simplified_polys

            new_feature = {
                "type": "Feature",
                "properties": {"suburb": normalized},
                "geometry": geom,
            }
            filtered_features.append(new_feature)
            matched.add(suburb_name.upper())

    output = {
        "type": "FeatureCollection",
        "features": filtered_features,
    }

    # Report
    missing = NEEDED_UPPER - matched
    print(f"Matched {len(filtered_features)}/{len(NEEDED_SUBURBS)} suburbs")
    if missing:
        print(f"Missing suburbs: {[s.title() for s in missing]}")

    # Save
    output_path = os.path.abspath(OUTPUT_PATH)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False)

    size_kb = os.path.getsize(output_path) / 1024
    print(f"Saved to {output_path} ({size_kb:.1f} KB)")


if __name__ == "__main__":
    main()
