import SuburbContent from './SuburbContent';

export async function generateStaticParams() {
  return [
    { suburb: 'Sunnybank' },
    { suburb: 'Eight Mile Plains' },
    { suburb: 'Calamvale' },
  ];
}

export default function SuburbPage({ params }: { params: { suburb: string } }) {
  const suburbName = decodeURIComponent(params.suburb);
  return <SuburbContent suburbName={suburbName} />;
}
