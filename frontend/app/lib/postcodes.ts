/**
 * Brisbane suburb postcodes for Domain.com.au URL generation
 */
export const SUBURB_POSTCODES: Record<string, string> = {
  'Sunnybank': '4109',
  'Eight Mile Plains': '4113',
  'Calamvale': '4116',
  'Rochedale': '4123',
  'Mansfield': '4122',
  'Ascot': '4007',
  'Hamilton': '4007',
  'Runcorn': '4113',
  'Wishart': '4122',
  'Upper Mount Gravatt': '4122',
  'Macgregor': '4109',
  'Robertson': '4109',
  'Stretton': '4116',
  'Kuraby': '4112',
  'Coopers Plains': '4108',
  'Algester': '4115',
  'Parkinson': '4115',
  // Additional suburbs that may appear in school catchments
  'Sunnybank Hills': '4109',
  'Acacia Ridge': '4110',
  'Tarragindi': '4121',
  'Holland Park': '4121',
  'Holland Park West': '4121',
  'Mount Gravatt': '4122',
  'Mount Gravatt East': '4122',
  'Wishart': '4122',
  'Mackenzie': '4156',
  'Rochedale South': '4123',
  'Springwood': '4127',
  'Underwood': '4119',
  'Slacks Creek': '4127',
  'Woodridge': '4114',
  'Logan Central': '4114',
  'Browns Plains': '4118',
  'Carina': '4152',
  'Carina Heights': '4152',
  'Camp Hill': '4152',
  'Cannon Hill': '4170',
  'Bulimba': '4171',
  'Hawthorne': '4171',
  'Norman Park': '4170',
  'Morningside': '4170',
  'New Farm': '4005',
  'Teneriffe': '4005',
  'Fortitude Valley': '4006',
  'Hendra': '4011',
  'Clayfield': '4011',
  'Nundah': '4012',
  'Toowong': '4066',
  'St Lucia': '4067',
  'Indooroopilly': '4068',
  'Kenmore': '4069',
  'Chapel Hill': '4069',
  'Paddington': '4064',
  'Red Hill': '4059',
  'Kelvin Grove': '4059',
  'Woolloongabba': '4102',
  'South Brisbane': '4101',
  'West End': '4101',
  'Highgate Hill': '4101',
  'Greenslopes': '4120',
  'Stones Corner': '4120',
};

/**
 * Build a Domain.com.au search URL for a given suburb
 */
export function buildDomainSearchUrl(suburb: string): string {
  const postcode = SUBURB_POSTCODES[suburb];
  const slug = suburb.toLowerCase().replace(/\s+/g, '-');
  if (postcode) {
    return `https://www.domain.com.au/sale/${slug}-qld-${postcode}/`;
  }
  // Fallback: search by suburb name
  return `https://www.domain.com.au/sale/?suburb=${encodeURIComponent(suburb)}+QLD`;
}
