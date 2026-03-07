-- 清空旧的土地数据
DELETE FROM listings WHERE property_type = 'vacant_land';

-- 导入土地数据
INSERT INTO listings (address, suburb, property_type, land_size, price_text, price, agent_name, agent_company, link, scraped_date, bedrooms, bathrooms, car_spaces, created_at) VALUES
('37 STONES ROAD SUNNYBANK', 'Sunnybank', 'vacant_land', 7210, 'Offers from $1.95M', 1950000, 'Dennis You', 'Yong Corporate', 'https://www.domain.com.au/37-stones-road-sunnybank-qld-4109-2020421206', '2026-03-07', NULL, NULL, NULL, NOW()),
('SUNNYBANK', 'Sunnybank', 'vacant_land', 500, '$750,000', 750000, 'Property Now', 'Property Now', 'https://www.domain.com.au/sunnybank-qld-4109-2017547801', '2026-03-07', NULL, NULL, NULL, NOW()),
('5 Brampton Street EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 456, 'Submit offers', NULL, 'Property Now', 'Property Now', 'https://www.domain.com.au/5-brampton-street-eight-mile-plains-qld-4113-2020291042', '2026-03-07', NULL, NULL, NULL, NOW()),
('EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 750, 'Expression Of Interest (EOI)', NULL, 'George Yang', 'Ray White Sunnybank Hills', 'https://www.domain.com.au/eight-mile-plains-qld-4113-2020233562', '2026-03-07', NULL, NULL, NULL, NOW()),
('69 Samuel Street CALAMVALE', 'Calamvale', 'vacant_land', 421, 'SUBMIT OFFERS', NULL, 'Jackson Chow', 'LJ Hooker Property Partners - SunnyBank Hills & Mount Gravatt', 'https://www.domain.com.au/69-samuel-street-calamvale-qld-4116-2020615090', '2026-03-07', NULL, NULL, NULL, NOW()),
('Lot Proposed Lot 2/121 Ormskirk Street CALAMVALE', 'Calamvale', 'vacant_land', 562, '$850,000', 850000, 'David Hills', 'Harcourts Results Calamvale', 'https://www.domain.com.au/lot-proposed-lot-2-121-ormskirk-street-calamvale-qld-4116-2019877360', '2026-03-07', NULL, NULL, NULL, NOW()),
('Lot Proposed Lot 3/121 Ormskirk Street CALAMVALE', 'Calamvale', 'vacant_land', 562, '$850,000', 850000, 'Adam Muntazir', 'Harcourts Results Calamvale', 'https://www.domain.com.au/lot-proposed-lot-3-121-ormskirk-street-calamvale-qld-4116-2019877350', '2026-03-07', NULL, NULL, NULL, NOW()),
('13/Lot 13 , 19 Ormskirk Street CALAMVALE', 'Calamvale', 'vacant_land', 1010, '$700,000 to $738,000', 700000, 'buymyplace .', 'buymyplace', 'https://www.domain.com.au/13-lot-13-19-ormskirk-street-calamvale-qld-4116-2018738754', '2026-03-07', NULL, NULL, NULL, NOW()),
('CALAMVALE', 'Calamvale', 'vacant_land', 452, '$680,000 to $748,000', 680000, 'buymyplace .', 'buymyplace', 'https://www.domain.com.au/calamvale-qld-4116-2018738752', '2026-03-07', NULL, NULL, NULL, NOW()),
('Lot 5, 361 Benhiam Street CALAMVALE', 'Calamvale', 'vacant_land', 4368, 'Submit offers', NULL, 'Jasmine Wu', 'Harcourts Results Calamvale', 'https://www.domain.com.au/lot-5-361-benhiam-street-calamvale-qld-4116-2016833226', '2026-03-07', NULL, NULL, NULL, NOW()),
('122 Crosby Road ASCOT', 'Ascot', 'vacant_land', 885, 'Expression of Interest Closing Thurs 5 Mar, 12pm', 5000000, 'Dwight Ferguson', 'Ray White Dwight Ferguson', 'https://www.domain.com.au/122-crosby-road-ascot-qld-4007-2020439832', '2026-03-07', NULL, NULL, NULL, NOW()),
('247 Lancaster Road ASCOT', 'Ascot', 'vacant_land', 405, '$1,750,000', 1750000, 'No Agent Property - QLD', 'No Agent Property ', 'https://www.domain.com.au/247-lancaster-road-ascot-qld-4007-2019946886', '2026-03-07', NULL, NULL, NULL, NOW()),
('25 Winchester Street HAMILTON', 'Ascot', 'vacant_land', 607, 'Auction', NULL, 'Hamish Foulger', 'Ray White (Ascot)', 'https://www.domain.com.au/25-winchester-street-hamilton-qld-4007-2020644708', '2026-03-07', NULL, NULL, NULL, NOW()),
('25 Winchester Street HAMILTON', 'Hamilton', 'vacant_land', 607, 'Auction', NULL, 'Hamish Foulger', 'Ray White (Ascot)', 'https://www.domain.com.au/25-winchester-street-hamilton-qld-4007-2020644708', '2026-03-07', NULL, NULL, NULL, NOW()),
('25 Perry Street HAMILTON', 'Hamilton', 'vacant_land', 1118, '$3,900,000 - $4,100,000', 3900000, 'Amanda Butler', 'Butler+Co Estate Agents', 'https://www.domain.com.au/25-perry-street-hamilton-qld-4007-2020443949', '2026-03-07', NULL, NULL, NULL, NOW()),
('49 Toorak Road HAMILTON', 'Hamilton', 'vacant_land', 607, 'BY NEGOTIATION', NULL, 'Emil Juresic', 'NGU Real Estate - Brisbane', 'https://www.domain.com.au/49-toorak-road-hamilton-qld-4007-2020400549', '2026-03-07', NULL, NULL, NULL, NOW()),
('11 Prospect Terrace HAMILTON', 'Hamilton', 'vacant_land', 493, 'For Sale', NULL, 'Sarah Hackett', 'Place Estate Agents New Farm', 'https://www.domain.com.au/11-prospect-terrace-hamilton-qld-4007-2019902893', '2026-03-07', NULL, NULL, NULL, NOW());

-- 验证导入结果
SELECT property_type, COUNT(*) as total FROM listings GROUP BY property_type;
