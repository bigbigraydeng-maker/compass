'use client';

import { useEffect, useRef, useCallback } from 'react';

interface School {
  name: string;
  type: string;
  school_type?: string;
  suburb: string;
  sector: string;
  naplan_score: number;
  naplan_percentile: number;
  enrollment: number;
  rating: number;
  lat: number;
  lng: number;
  catchment_suburbs: string[];
}

interface SchoolMapProps {
  schools: School[];
  selectedSchool: School | null;
  onSchoolSelect: (school: School) => void;
  suburbBoundaries: any | null;
  dataSuburbs: string[];
  apiKey: string;
}

// Create SVG marker icon as data URL
function createMarkerIcon(color: string, label: string, isSelected: boolean) {
  const size = isSelected ? 36 : 28;
  const strokeColor = isSelected ? '#1d4ed8' : '#ffffff';
  const strokeWidth = isSelected ? 3 : 2;
  const svg = `
    <svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size + 8}" viewBox="0 0 ${size} ${size + 8}">
      <path d="${size === 36
        ? 'M18 2 C9.2 2 2 9.2 2 18 C2 28 18 42 18 42 C18 42 34 28 34 18 C34 9.2 26.8 2 18 2Z'
        : 'M14 2 C7.4 2 2 7.4 2 14 C2 22 14 34 14 34 C14 34 26 22 26 14 C26 7.4 20.6 2 14 2Z'
      }" fill="${color}" stroke="${strokeColor}" stroke-width="${strokeWidth}"/>
      <text x="${size / 2}" y="${size * 0.52}" text-anchor="middle" dominant-baseline="middle"
        fill="white" font-size="${isSelected ? 14 : 11}" font-weight="bold" font-family="Arial">${label}</text>
    </svg>
  `;
  return 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(svg.trim());
}

function getMarkerColor(percentile: number) {
  if (percentile >= 80) return '#22c55e';
  if (percentile >= 60) return '#eab308';
  return '#ef4444';
}

function getTypeLabel(type: string) {
  if (type === 'primary') return 'P';
  if (type === 'secondary') return 'S';
  return 'C';
}

export default function SchoolMap({
  schools,
  selectedSchool,
  onSchoolSelect,
  suburbBoundaries,
  dataSuburbs,
  apiKey,
}: SchoolMapProps) {
  const mapRef = useRef<HTMLDivElement>(null);
  const googleMapRef = useRef<any>(null);
  const markersRef = useRef<any[]>([]);
  const dataLayerRef = useRef<any>(null);
  const scriptLoadedRef = useRef(false);
  const infoWindowRef = useRef<any>(null);

  // Initialize map
  const initMap = useCallback(() => {
    try {
      if (!mapRef.current || !window.google?.maps) return;

      const map = new google.maps.Map(mapRef.current, {
        center: { lat: -27.53, lng: 153.06 },
        zoom: 11,
        disableDefaultUI: false,
        zoomControl: true,
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: false,
      });

      googleMapRef.current = map;
    } catch (e) {
      console.error('Failed to init map:', e);
    }
  }, []);

  // Load Google Maps script
  useEffect(() => {
    if (scriptLoadedRef.current || !apiKey) return;

    try {
      if (window.google?.maps) {
        scriptLoadedRef.current = true;
        initMap();
        return;
      }

      const script = document.createElement('script');
      script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&v=weekly`;
      script.async = true;
      script.defer = true;
      script.onload = () => {
        scriptLoadedRef.current = true;
        initMap();
      };
      script.onerror = () => {
        console.error('Failed to load Google Maps script');
      };
      document.head.appendChild(script);
    } catch (e) {
      console.error('Error loading Google Maps:', e);
    }
  }, [apiKey, initMap]);

  // Update markers when schools or selection changes
  useEffect(() => {
    try {
      const map = googleMapRef.current;
      if (!map || !window.google?.maps) return;

      // Clear existing markers
      markersRef.current.forEach(m => {
        try { m.setMap(null); } catch {}
      });
      markersRef.current = [];

      // Close info window
      if (infoWindowRef.current) {
        try { infoWindowRef.current.close(); } catch {}
      }

      schools.forEach(school => {
        if (!school.lat || !school.lng) return;

        const isSelected = selectedSchool?.name === school.name;
        const color = getMarkerColor(school.naplan_percentile || 0);
        const label = getTypeLabel(school.type || '');
        const iconUrl = createMarkerIcon(color, label, isSelected);

        const marker = new google.maps.Marker({
          map,
          position: { lat: school.lat, lng: school.lng },
          title: school.name,
          icon: {
            url: iconUrl,
            scaledSize: new google.maps.Size(isSelected ? 36 : 28, isSelected ? 44 : 36),
            anchor: new google.maps.Point(isSelected ? 18 : 14, isSelected ? 44 : 36),
          },
          zIndex: isSelected ? 100 : 1,
        });

        marker.addListener('click', () => {
          onSchoolSelect(school);
        });

        markersRef.current.push(marker);
      });
    } catch (e) {
      console.error('Error updating markers:', e);
    }
  }, [schools, selectedSchool, onSchoolSelect]);

  // Update polygon overlays when selected school changes
  useEffect(() => {
    try {
      const map = googleMapRef.current;
      if (!map || !window.google?.maps) return;

      // Clear previous data layer
      if (dataLayerRef.current) {
        try { dataLayerRef.current.setMap(null); } catch {}
        dataLayerRef.current = null;
      }

      if (!selectedSchool || !suburbBoundaries) return;

      const catchmentLower = selectedSchool.catchment_suburbs.map(s => s.toLowerCase());
      const dataSuburbsLower = dataSuburbs.map(s => s.toLowerCase());

      const dataLayer = new google.maps.Data();

      // Filter GeoJSON to only catchment suburbs
      const filteredFeatures = (suburbBoundaries.features || []).filter((f: any) => {
        const name = (f.properties?.suburb || '').toLowerCase();
        return catchmentLower.includes(name);
      });

      if (filteredFeatures.length === 0) return;

      const filteredGeoJSON = {
        type: 'FeatureCollection',
        features: filteredFeatures,
      };

      dataLayer.addGeoJson(filteredGeoJSON);

      // Style polygons
      dataLayer.setStyle((feature: any) => {
        const name = (feature.getProperty('suburb') || '').toLowerCase();
        const hasData = dataSuburbsLower.includes(name);
        return {
          fillColor: hasData ? '#3B82F6' : '#9CA3AF',
          fillOpacity: hasData ? 0.25 : 0.12,
          strokeColor: hasData ? '#2563EB' : '#6B7280',
          strokeWeight: hasData ? 2 : 1.5,
          strokeOpacity: 0.8,
        };
      });

      dataLayer.setMap(map);
      dataLayerRef.current = dataLayer;

      // Fit bounds to show all catchment polygons
      const bounds = new google.maps.LatLngBounds();
      let hasPoints = false;
      dataLayer.forEach((feature: any) => {
        const geom = feature.getGeometry();
        if (geom) {
          geom.forEachLatLng((latlng: any) => {
            bounds.extend(latlng);
            hasPoints = true;
          });
        }
      });

      if (selectedSchool.lat && selectedSchool.lng) {
        bounds.extend({ lat: selectedSchool.lat, lng: selectedSchool.lng });
        hasPoints = true;
      }

      if (hasPoints) {
        map.fitBounds(bounds, { top: 50, bottom: 50, left: 50, right: 50 });
      }
    } catch (e) {
      console.error('Error updating polygons:', e);
    }
  }, [selectedSchool, suburbBoundaries, dataSuburbs]);

  // If no API key, don't use ref (so Google Maps doesn't try to init)
  if (!apiKey) {
    return (
      <div className="w-full h-full flex items-center justify-center bg-gray-100 text-gray-500" style={{ minHeight: 400 }}>
        <div className="text-center p-6">
          <svg className="w-12 h-12 mx-auto mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
          </svg>
          <p className="text-sm font-medium">Google Maps is loading...</p>
          <p className="text-xs text-gray-400 mt-1">NEXT_PUBLIC_GOOGLE_MAPS_KEY not configured</p>
        </div>
      </div>
    );
  }

  return (
    <div ref={mapRef} className="w-full bg-gray-100" style={{ height: '100%', minHeight: 400 }} />
  );
}
