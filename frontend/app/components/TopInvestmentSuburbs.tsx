interface SuburbRanking {
  id: string;
  name: string;
  compass_score: number;
  median_price: number;
  growth_rate: number;
  investment_potential: string;
}

interface TopInvestmentSuburbsProps {
  rankings: SuburbRanking[];
}

export default function TopInvestmentSuburbs({ rankings }: TopInvestmentSuburbsProps) {
  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-AU', {
      style: 'currency',
      currency: 'AUD',
      maximumFractionDigits: 0
    }).format(price);
  };

  // 模拟数据
  const mockRankings: SuburbRanking[] = [
    {
      id: '1',
      name: 'Sunnybank',
      compass_score: 82,
      median_price: 1200000,
      growth_rate: 8.5,
      investment_potential: 'High'
    },
    {
      id: '2',
      name: 'Rochedale',
      compass_score: 79,
      median_price: 950000,
      growth_rate: 12.3,
      investment_potential: 'Very High'
    },
    {
      id: '3',
      name: 'Mansfield',
      compass_score: 76,
      median_price: 1050000,
      growth_rate: 7.2,
      investment_potential: 'High'
    },
    {
      id: '4',
      name: 'Eight Mile Plains',
      compass_score: 74,
      median_price: 880000,
      growth_rate: 9.1,
      investment_potential: 'High'
    },
    {
      id: '5',
      name: 'Calamvale',
      compass_score: 71,
      median_price: 750000,
      growth_rate: 6.8,
      investment_potential: 'Medium-High'
    }
  ];

  const displayRankings = rankings.length > 0 ? rankings : mockRankings;

  return (
    <section className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center mb-12">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              Top Investment Suburbs
            </h2>
            <p className="text-lg text-gray-600">
              Ranked by Compass Score and investment potential
            </p>
          </div>
          <button className="mt-4 md:mt-0 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors">
            View Full Rankings
          </button>
        </div>
        
        <div className="space-y-6">
          {displayRankings.map((ranking, index) => (
            <div key={ranking.id} className="bg-gray-50 rounded-xl p-6 border border-gray-200 hover:shadow-md transition-shadow">
              <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div className="flex items-center gap-6">
                  <div className="text-3xl font-bold text-gray-800 w-12 text-center">
                    #{index + 1}
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-1">{ranking.name}</h3>
                    <div className="flex items-center gap-4 text-sm text-gray-600">
                      <span>Median Price: {formatPrice(ranking.median_price)}</span>
                      <span>Growth: +{ranking.growth_rate}%</span>
                      <span>Potential: {ranking.investment_potential}</span>
                    </div>
                  </div>
                </div>
                <div className="flex items-center gap-4">
                  <div className="text-center">
                    <p className="text-sm text-gray-600 mb-1">Compass Score</p>
                    <p className="text-2xl font-bold text-blue-600">{ranking.compass_score}</p>
                  </div>
                  <button className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                    View Details
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
