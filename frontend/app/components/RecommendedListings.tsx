interface ListingData {
  id: string;
  address: string;
  suburb: string;
  price: number;
  beds: number;
  land_size: number;
  domain_link: string;
}

interface RecommendedListingsProps {
  listings: ListingData[];
}

export default function RecommendedListings({ listings }: RecommendedListingsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  return (
    <section className="py-16 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-2xl md:text-3xl font-bold text-gray-800">
            Recommended Listings
          </h2>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {listings.slice(0, 6).map((listing) => (
            <div key={listing.id} className="bg-gradient-to-br from-gray-50 to-white rounded-xl shadow-sm p-6 border">
              <div className="mb-4">
                <h3 className="font-semibold text-gray-800 mb-1">{listing.address}</h3>
                <p className="text-sm text-gray-500">{listing.suburb}</p>
              </div>
              
              <div className="flex justify-between items-start mb-6">
                <div>
                  <p className="text-2xl font-bold text-orange-600">{formatPrice(listing.price)}</p>
                </div>
                <div className="text-right">
                  <p className="text-sm text-gray-600">{listing.beds} bed</p>
                  <p className="text-sm text-gray-600">{listing.land_size} sqm</p>
                </div>
              </div>
              
              <a
                href={listing.domain_link}
                target="_blank"
                rel="noopener noreferrer"
                className="block w-full bg-blue-600 hover:bg-blue-700 text-white text-center py-3 rounded-lg font-medium transition-colors"
              >
                View on Domain
              </a>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
