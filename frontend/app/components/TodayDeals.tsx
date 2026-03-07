interface DealData {
  id: string;
  address: string;
  suburb: string;
  listing_price: number;
  estimated_value: number;
  discount_percent: number;
  compass_score: number;
}

interface TodayDealsProps {
  deals: DealData[];
}

export default function TodayDeals({ deals }: TodayDealsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 模拟数据
  const mockDeals: DealData[] = [
    {
      id: '1',
      address: '123 Main St',
      suburb: 'Sunnybank',
      listing_price: 850000,
      estimated_value: 980000,
      discount_percent: 13,
      compass_score: 82
    },
    {
      id: '2',
      address: '456 Oak Ave',
      suburb: 'Rochedale',
      listing_price: 720000,
      estimated_value: 850000,
      discount_percent: 15,
      compass_score: 79
    },
    {
      id: '3',
      address: '789 Pine Rd',
      suburb: 'Mansfield',
      listing_price: 920000,
      estimated_value: 1050000,
      discount_percent: 12,
      compass_score: 76
    }
  ];

  const displayDeals = deals.length > 0 ? deals : mockDeals;

  return (
    <section className="py-20 bg-gradient-to-br from-gray-50 to-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-12">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Today's Deals
            </h2>
            <p className="text-lg text-gray-600">
              Handpicked investment opportunities below market value
            </p>
          </div>
          <button className="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
            View All Deals
          </button>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {displayDeals.map((deal) => (
            <div key={deal.id} className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow overflow-hidden border border-gray-200">
              <div className="p-6">
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <h3 className="font-bold text-lg text-gray-900 mb-1">{deal.address}</h3>
                    <p className="text-sm text-gray-500">{deal.suburb}</p>
                  </div>
                  <div className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium">
                    {deal.discount_percent}% OFF
                  </div>
                </div>
                
                <div className="space-y-3 mb-6">
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Listing Price</span>
                    <span className="font-semibold text-gray-900">{formatPrice(deal.listing_price)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Estimated Value</span>
                    <span className="font-semibold text-blue-600">{formatPrice(deal.estimated_value)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-sm text-gray-600">Compass Score</span>
                    <span className="font-semibold text-orange-600">{deal.compass_score}</span>
                  </div>
                </div>
                
                <div className="flex gap-3">
                  <button className="flex-1 bg-blue-600 hover:bg-blue-700 text-white py-3 rounded-lg font-medium transition-colors">
                    🤖 Analyze
                  </button>
                  <button className="bg-gray-100 hover:bg-gray-200 text-gray-800 py-3 px-4 rounded-lg font-medium transition-colors">
                    View
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
