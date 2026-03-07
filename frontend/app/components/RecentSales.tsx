import Link from 'next/link';

interface SaleData {
  id: string;
  address: string;
  suburb: string;
  price: number;
  beds: number;
  land_size: number;
  date: string;
}

interface RecentSalesProps {
  sales: SaleData[];
}

export default function RecentSales({ sales }: RecentSalesProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  return (
    <section className="py-16 bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-800">
            Latest Sales
          </h2>
          <Link href="/sales" className="text-blue-600 hover:text-blue-700 text-sm font-medium flex items-center">
            View All
            <span className="ml-1">→</span>
          </Link>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {sales.slice(0, 6).map((sale) => (
            <div key={sale.id} className="bg-white rounded-xl shadow-sm p-6 border">
              <div className="mb-4">
                <h3 className="font-semibold text-gray-800 mb-1">{sale.address}</h3>
                <p className="text-sm text-gray-500">{sale.suburb}</p>
              </div>
              
              <div className="flex justify-between items-start mb-4">
                <div>
                  <p className="text-2xl font-bold text-blue-600">{formatPrice(sale.price)}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-gray-600">{sale.beds} bed</p>
                  <p className="text-sm text-gray-600">{sale.land_size} sqm</p>
                </div>
              </div>
              
              <div className="text-sm text-gray-500">
                {sale.date}
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
