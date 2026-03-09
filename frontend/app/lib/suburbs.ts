/**
 * Compass 区域集中配置（前端）
 * 所有区域列表统一在此维护
 */

export const ALL_SUBURBS = [
  // 核心 7 区
  'Sunnybank',
  'Eight Mile Plains',
  'Calamvale',
  'Rochedale',
  'Mansfield',
  'Ascot',
  'Hamilton',
  // 扩展 10 区
  'Runcorn',
  'Wishart',
  'Upper Mount Gravatt',
  'Macgregor',
  'Robertson',
  'Stretton',
  'Kuraby',
  'Coopers Plains',
  'Algester',
  'Parkinson',
] as const;

export const CORE_SUBURBS = ALL_SUBURBS.slice(0, 7);

export type SuburbName = typeof ALL_SUBURBS[number];
