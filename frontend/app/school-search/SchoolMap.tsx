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
  suburbBoundaries: any | null; // GeoJSON FeatureCollection
  dataSuburbs: string[];
  apiKey: string;
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
  const googleMapRef = useRef<google.maps.Map | null>(null);
  const markersRef = useRef<google.maps.marker.AdvancedMarkerElement[]>([]);
  const dataLayerRef = useRef<google.maps.Data | null>(null);
  const scriptLoadedRef = useRef(false);

  // Get marker color based on NAPLAN percentile
  const getMarkerColor = (percentile: number) => {
    if (percentile >= 80) return '#22c55e'; // green
    if (percentile >= 60) return '#eab308'; // yellow
    return '#ef4444'; // red
  };

  // Create pin SVG element
  const createPinElement = useCallback((school: School, isSelected: boolean) => {
    const color = getMarkerColor(school.naplan_percentile || 0);
    const size = isSelected ? 40 : 30;
    const borderWidth = isSelected ? 3 : 2;

    const div = document.createElement('div');
    div.innerHTML = `
      <div style="
        width: ${size}px; height: ${size}px;
        background: ${color};
        border: ${borderWidth}px solid ${isSelected ? '#1d4ed8' : 'white'};
        border-radius: 50% 50% 50% 0;
        transform: rotate(-45deg);
        box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        display: flex; align-items: center; justify-content: center;
        cursor: pointer;
        transition: all 0.2s;
      ">
        <span style="
          transform: rotate(45deg);
          color: white;
          font-size: ${isSelected ? 14 : 11}px;
          font-weight: bold;
        ">${school.type === 'primary' ? 'P' : school.type === 'secondary' ? 'S' : 'C'}</span>
      </div>
    `;
    return div;
  }, []);

  // Initialize map
  const initMap = useCallback(() => {
    if (!mapRef.current || !window.google) return;

    const map = new google.maps.Map(mapRef.current, {
      center: { lat: -27.53, lng: 153.06 },
      zoom: 11,
      mapId: 'compass-school-map',
      disableDefaultUI: false,
      zoomControl: true,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: false,
      styles: [
        {
          featureType: 'poi',
          elementType: 'labels',
          stylers: [{ visibility: 'off' }],
        },
      ],
    });

    googleMapRef.current = map;
  }, []);

  // Load Google Maps script
  useEffect(() => {
    if (scriptLoadedRef.current || !apiKey) return;

    // Check if already loaded
    if (window.google?.maps) {
      scriptLoadedRef.current = true;
      initMap();
      return;
    }

    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&libraries=marker&v=weekly`;
    script.async = true;
    script.defer = true;
    script.onload = () => {
      scriptLoadedRef.current = true;
      initMap();
    };
    document.head.appendChild(script);

    return () => {
      // Don't remove script on cleanup since it's a global resource
    };
  }, [apiKey, initMap]);

  // Update markers when schools change
  useEffect(() => {
    const map = googleMapRef.current;
    if (!map || !window.google?.maps?.marker) return;

    // Clear existing markers
    markersRef.current.forEach(m => (m.map = null));
    markersRef.current = [];

    schools.forEach(school => {
      if (!school.lat || !school.lng) return;

      const isSelected = selectedSchool?.name === school.name;
      const content = createPinElement(school, isSelected);

      const marker = new google.maps.marker.AdvancedMarkerElement({
        map,
        position: { lat: school.lat, lng: school.lng },
        content,
        title: school.name,
        zIndex: isSelected ? 100 : 1,
      });

      marker.addListener('click', () => onSchoolSelect(school));
      markersRef.current.push(marker);
    });
  }, [schools, selectedSchool, onSchoolSelect, createPinElement]);

  // Update polygon overlays when selected school changes
  useEffect(() => {
    const map = googleMapRef.current;
    if (!map || !window.google) return;

    // Clear previous data layer
    if (dataLayerRef.current) {
      dataLayerRef.current.setMap(null);
      dataLayerRef.current = null;
    }

    if (!selectedSchool || !suburbBoundaries) return;

    const catchmentLower = selectedSchool.catchment_suburbs.map(s => s.toLowerCase());
    const dataSuburbsLower = dataSuburbs.map(s => s.toLowerCase());

    // Create data layer
    const dataLayer = new google.maps.Data();

    // Filter GeoJSON to only catchment suburbs
    const filteredGeoJSON = {
      type: 'FeatureCollection' as const,
      features: suburbBoundaries.features.filter((f: any) => {
        const name = (f.properties?.suburb || '').toLowerCase();
        return catchmentLower.includes(name);
      }),
    };

    if (filteredGeoJSON.features.length > 0) {
      dataLayer.addGeoJson(filteredGeoJSON);

      // Style polygons
      dataLayer.setStyle((feature) => {
        const name = (feature.getProperty('suburb') as string || '').toLowerCase();
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
      dataLayer.forEach(feature => {
        const geom = feature.getGeometry();
        if (geom) {
          geom.forEachLatLng(latlng => bounds.extend(latlng));
        }
      });
      // Also include the school itself
      if (selectedSchool.lat && selectedSchool.lng) {
        bounds.extend({ lat: selectedSchool.lat, lng: selectedSchool.lng });
      }
      map.fitBounds(bounds, { top: 50, bottom: 50, left: 50, right: 50 });
    }
  }, [selectedSchool, suburbBoundaries, dataSuburbs]);

  return (
    <div ref={mapRef} className="w-full h-full min-h-[300px]">
      {!apiKey && (
        <div className="w-full h-full flex items-center justify-center bg-gray-100 text-gray-500">
          <p>Google Maps API Key is not configured</p>
        </div>
      )}
    </div>
  );
}
