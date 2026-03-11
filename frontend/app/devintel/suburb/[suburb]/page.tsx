import SuburbDevIntelContent from './SuburbDevIntelContent';
import { ALL_SUBURBS } from '../../../lib/suburbs';

// 额外的可能出现在 DevIntel 中的区域
const EXTRA_DEVINTEL_SUBURBS = [
  'Brisbane City',
  'South Brisbane',
  'West End',
  'Woolloongabba',
  'Kangaroo Point',
  'Fortitude Valley',
  'Newstead',
  'Toowong',
  'Indooroopilly',
  'Chermside',
  'Nundah',
  'Coorparoo',
  'Mount Gravatt',
  'Holland Park',
  'Greenslopes',
  'Springwood',
  'Logan Central',
  'Browns Plains',
  'Springfield',
  'Ipswich',
];

export async function generateStaticParams() {
  const allSuburbs = [...ALL_SUBURBS, ...EXTRA_DEVINTEL_SUBURBS];
  return allSuburbs.map(suburb => ({ suburb }));
}

export default function SuburbDevIntelPage({ params }: { params: { suburb: string } }) {
  const suburbName = decodeURIComponent(params.suburb);
  return <SuburbDevIntelContent suburb={suburbName} />;
}
