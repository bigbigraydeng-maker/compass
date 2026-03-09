'use client';

import { useState, useEffect, useCallback } from 'react';
import Header from '../components/Header';
import SchoolMap from './SchoolMap';
import SchoolDetailPanel from './SchoolDetailPanel';
import SchoolCard from './SchoolCard';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8888';
const MAPS_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_KEY || '';

const CORE_SUBURBS = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton'];

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

interface CatchmentData {
  suburbs_with_data: string[];
  suburbs_without_data: string[];
  aggregated: any;
}

export default function SchoolSearchPage() {
  const [schools, setSchools] = useState<School[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedSchool, setSelectedSchool] = useState<School | null>(null);
  const [catchmentData, setCatchmentData] = useState<CatchmentData | null>(null);
  const [catchmentLoading, setCatchmentLoading] = useState(false);
  const [suburbGeoJSON, setSuburbGeoJSON] = useState<any>(null);
  const [mapCollapsed, setMapCollapsed] = useState(false);

  // Filters
  const [filterSuburb, setFilterSuburb] = useState('');
  const [filterType, setFilterType] = useState('');
  const [filterSector, setFilterSector] = useState('');

  // Load schools + GeoJSON on mount
  useEffect(() => {
    const loadAll = async () => {
      try {
        const [schoolsRes, geoRes] = await Promise.all([
          fetch(`${API_BASE}/api/schools`).then(r => r.ok ? r.json() : null),
          fetch('/data/brisbane_suburbs.geojson').then(r => r.ok ? r.json() : null).catch(() => null),
        ]);

        if (schoolsRes?.schools) {
          setSchools(schoolsRes.schools);
        }
        if (geoRes) {
          setSuburbGeoJSON(geoRes);
        }
      } catch (e) {
        console.error('Failed to load data:', e);
      } finally {
        setLoading(false);
      }
    };
    loadAll();
  }, []);

  // Load catchment data when school selected
  const handleSchoolSelect = useCallback(async (school: School) => {
    setSelectedSchool(school);
    setCatchmentData(null);
    setCatchmentLoading(true);

    try {
      const res = await fetch(`${API_BASE}/api/school/${encodeURIComponent(school.name)}/catchment-data`);
      if (res.ok) {
        const data = await res.json();
        setCatchmentData(data.catchment_data);
      }
    } catch (e) {
      console.error('Failed to load catchment data:', e);
    } finally {
      setCatchmentLoading(false);
    }
  }, []);

  const handleCloseDetail = useCallback(() => {
    setSelectedSchool(null);
    setCatchmentData(null);
  }, []);

  // Filtered schools
  const filteredSchools = schools.filter(s => {
    if (filterSuburb) {
      const subMatch = s.suburb.toLowerCase() === filterSuburb.toLowerCase();
      const catchMatch = s.catchment_suburbs.some(c => c.toLowerCase() === filterSuburb.toLowerCase());
      if (!subMatch && !catchMatch) return false;
    }
    if (filterType && (s.type || s.school_type || '').toLowerCase() !== filterType.toLowerCase()) return false;
    if (filterSector && s.sector.toLowerCase() !== filterSector.toLowerCase()) return false;
    return true;
  });

  const suburbs = ['Sunnybank', 'Eight Mile Plains', 'Calamvale', 'Rochedale', 'Mansfield', 'Ascot', 'Hamilton'];

  // Filter Bar Component
  const FilterBar = () => (
    <div className="flex flex-wrap gap-2 mb-4">
      <select
        value={filterSuburb}
        onChange={(e) => setFilterSuburb(e.target.value)}
        className="px-3 py-1.5 rounded-lg border border-gray-300 text-xs text-gray-700 bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
      >
        <option value="">全部郊区</option>
        {suburbs.map(s => (
          <option key={s} value={s}>{s}</option>
        ))}
      </select>
      <select
        value={filterType}
        onChange={(e) => setFilterType(e.target.value)}
        className="px-3 py-1.5 rounded-lg border border-gray-300 text-xs text-gray-700 bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
      >
        <option value="">全部类型</option>
        <option value="primary">小学</option>
        <option value="secondary">中学</option>
        <option value="combined">综合</option>
      </select>
      <select
        value={filterSector}
        onChange={(e) => setFilterSector(e.target.value)}
        className="px-3 py-1.5 rounded-lg border border-gray-300 text-xs text-gray-700 bg-white focus:ring-2 focus:ring-emerald-500 focus:outline-none"
      >
        <option value="">全部性质</option>
        <option value="Government">公立</option>
        <option value="Catholic">天主教</option>
        <option value="Independent">私立</option>
      </select>
      <span className="text-xs text-gray-400 self-center ml-auto">
        {filteredSchools.length} 所学校
      </span>
    </div>
  );

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50">
        <Header />
        <div className="flex items-center justify-center" style={{ height: 'calc(100vh - 64px)' }}>
          <div className="text-center">
            <div className="animate-spin rounded-full h-10 w-10 border-b-2 border-emerald-600 mx-auto mb-4"></div>
            <p className="text-gray-500">加载学校数据...</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />

      {/* ===== PC 布局 (lg+) ===== */}
      <div className="hidden lg:flex" style={{ height: 'calc(100vh - 64px)' }}>
        {/* Left: Map */}
        <div className="w-[55%] xl:w-[60%] relative" style={{ height: '100%' }}>
          <SchoolMap
            schools={filteredSchools}
            selectedSchool={selectedSchool}
            onSchoolSelect={handleSchoolSelect}
            suburbBoundaries={suburbGeoJSON}
            dataSuburbs={CORE_SUBURBS}
            apiKey={MAPS_KEY}
          />
          {/* Map Legend */}
          <div className="absolute bottom-4 left-4 bg-white/90 backdrop-blur-sm rounded-lg shadow-md px-3 py-2 text-xs z-10">
            <div className="flex items-center gap-3">
              <span className="flex items-center gap-1">
                <span className="w-3 h-3 rounded-full bg-green-500 inline-block"></span> NAPLAN 优秀
              </span>
              <span className="flex items-center gap-1">
                <span className="w-3 h-3 rounded-full bg-yellow-500 inline-block"></span> 良好
              </span>
              <span className="flex items-center gap-1">
                <span className="w-3 h-3 rounded-full bg-red-500 inline-block"></span> 一般
              </span>
            </div>
          </div>
        </div>

        {/* Right: Detail Panel or School List */}
        <div className="w-[45%] xl:w-[40%] overflow-y-auto border-l border-gray-200 bg-gray-50" style={{ height: '100%' }}>
          {selectedSchool ? (
            <SchoolDetailPanel
              school={selectedSchool}
              catchmentData={catchmentData}
              loading={catchmentLoading}
              onClose={handleCloseDetail}
            />
          ) : (
            <div className="p-4">
              {/* Header */}
              <div className="mb-4">
                <h1 className="text-xl font-bold text-gray-900 mb-1">校区找房</h1>
                <p className="text-xs text-gray-500">
                  点击地图上的学校标注，查看学区投资数据
                </p>
              </div>

              <FilterBar />

              {/* School List */}
              <div className="space-y-2">
                {filteredSchools.map((school, i) => (
                  <SchoolCard
                    key={`${school.name}-${i}`}
                    school={school}
                    isSelected={false}
                    onClick={() => handleSchoolSelect(school)}
                  />
                ))}
              </div>

              {filteredSchools.length === 0 && (
                <div className="text-center py-12">
                  <p className="text-gray-500">暂无匹配的学校</p>
                  <p className="text-gray-400 text-xs mt-1">请调整筛选条件</p>
                </div>
              )}
            </div>
          )}
        </div>
      </div>

      {/* ===== 手机布局 (< lg) ===== */}
      <div className="lg:hidden flex flex-col" style={{ height: 'calc(100vh - 64px)' }}>
        {/* Map Section */}
        <div
          className={`relative transition-all duration-300 ${
            mapCollapsed ? 'h-32' : 'h-56'
          }`}
        >
          <SchoolMap
            schools={filteredSchools}
            selectedSchool={selectedSchool}
            onSchoolSelect={handleSchoolSelect}
            suburbBoundaries={suburbGeoJSON}
            dataSuburbs={CORE_SUBURBS}
            apiKey={MAPS_KEY}
          />
          {/* Collapse toggle */}
          <button
            onClick={() => setMapCollapsed(!mapCollapsed)}
            className="absolute bottom-2 right-2 bg-white/90 backdrop-blur-sm rounded-full shadow-md w-8 h-8 flex items-center justify-center text-gray-600"
          >
            <svg className={`w-4 h-4 transition-transform ${mapCollapsed ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
            </svg>
          </button>
        </div>

        {/* Content below map */}
        <div className="flex-1 overflow-y-auto">
          {selectedSchool ? (
            <SchoolDetailPanel
              school={selectedSchool}
              catchmentData={catchmentData}
              loading={catchmentLoading}
              onClose={handleCloseDetail}
            />
          ) : (
            <div className="p-3">
              <div className="flex items-center justify-between mb-3">
                <h1 className="text-lg font-bold text-gray-900">校区找房</h1>
                <span className="text-xs text-gray-400">{filteredSchools.length} 所学校</span>
              </div>

              <FilterBar />

              <div className="space-y-2">
                {filteredSchools.map((school, i) => (
                  <SchoolCard
                    key={`${school.name}-${i}`}
                    school={school}
                    isSelected={false}
                    onClick={() => handleSchoolSelect(school)}
                  />
                ))}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
