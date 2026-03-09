import SuburbContent from './SuburbContent';
import { ALL_SUBURBS } from '../../lib/suburbs';

export async function generateStaticParams() {
  return ALL_SUBURBS.map(suburb => ({ suburb }));
}

export default function SuburbPage({ params }: { params: { suburb: string } }) {
  const suburbName = decodeURIComponent(params.suburb);
  return <SuburbContent suburbName={suburbName} />;
}
