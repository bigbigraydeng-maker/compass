import Link from 'next/link';

interface SuburbData {
  name: string;
  median_price: number;
  sales_count: number;
}

interface TopSuburbsProps {
  suburbs: SuburbData[];
}

export default function TopSuburbs({ suburbs }: TopSuburbsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 固定的6个郊区
  const topSuburbs = [
    { name: 'Sunnybank', median_price: 1200000, sales_count: 150 },
    { name: 'Rochedale', median_price: 950000, sales_count: 120 },
    { name: 'Mansfield', median_price: 1050000, sales_count: 90 },
    { name: 'Eight Mile Plains', median_price: 880000, sales_count: 85 },
    { name: 'Calamvale', median_price: 750000, sales_count: 70 },
    { name: 'Hamilton', median_price: 1400000, sales_count: 60 }
  ];

  return (
    <section className="py-16 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h2 className="text-2xl md:text-3xl font-bold text-gray-800 mb-8">
          Top Suburbs for Chinese Buyers
        </h2>
        
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {topSuburbs.map((suburb) => (
            <Link
              key={suburb.name}
              href={`/suburb/${encodeURIComponent(suburb.name)}`}
              className="bg-white rounded-xl shadow-sm hover:shadow-md transition-shadow p-6 border"
            >
              <h3 className="text-lg font-semibold text-gray-800 mb-4">{suburb.name}</h3>
              <div className="space-y-3">
                <div>
                  <p className="text-sm text-gray-500">Median Price</p>
                  <p className="text-2xl font-bold text-blue-600">{formatPrice(suburb.median_price)}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500">Sales Count</p>
                  <p className="text-lg font-semibold text-gray-800">{suburb.sales_count} 套</p>
                </div>
              </div>
              <div className="mt-6 text-blue-600 text-sm font-medium flex items-center">
                View Details
                <span className="ml-1">→</span>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </section>
  );
}
