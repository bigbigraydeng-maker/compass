-- Compass MVP Sales 数据导入
-- 注意：需要先导入 properties 数据
-- 此脚本使用子查询自动关联 property_id

WITH sales_data AS (
    SELECT '93 Dunedin Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1358000 AS sold_price, '2025-11-05'::date AS sold_date UNION ALL
    SELECT '31 Shelley Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1780000 AS sold_price, '2025-10-25'::date AS sold_date UNION ALL
    SELECT '5 Batford Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1400000 AS sold_price, '2025-10-31'::date AS sold_date UNION ALL
    SELECT '13 Dema Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1337000 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '43 Shelley Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1761000 AS sold_price, '2025-10-25'::date AS sold_date UNION ALL
    SELECT '20 Valhalla Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1668000 AS sold_price, '2025-10-31'::date AS sold_date UNION ALL
    SELECT '115 Turton Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1597000 AS sold_price, '2025-11-01'::date AS sold_date UNION ALL
    SELECT '11/16 Troughton Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 638888 AS sold_price, '2025-11-07'::date AS sold_date UNION ALL
    SELECT '5/16 Troughton Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 740000 AS sold_price, '2025-11-26'::date AS sold_date UNION ALL
    SELECT '10 Sunnybrae Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1505000 AS sold_price, '2025-11-29'::date AS sold_date UNION ALL
    SELECT '19/38 Dyson Avenue, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 780000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT '27 Headland Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1150000 AS sold_price, '2026-01-19'::date AS sold_date UNION ALL
    SELECT '39 Mulgowie Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1816000 AS sold_price, '2026-03-02'::date AS sold_date UNION ALL
    SELECT '28/18 Altandi Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 920000 AS sold_price, '2026-02-17'::date AS sold_date UNION ALL
    SELECT '38 Samara Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1455000 AS sold_price, '2026-03-04'::date AS sold_date UNION ALL
    SELECT '52 Jacinda Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1518000 AS sold_price, '2025-09-02'::date AS sold_date UNION ALL
    SELECT '5 Gleneagles Court, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2250000 AS sold_price, '2025-08-22'::date AS sold_date UNION ALL
    SELECT '27 Fairbank Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1645000 AS sold_price, '2025-09-05'::date AS sold_date UNION ALL
    SELECT '387 Mccullough Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1588000 AS sold_price, '2025-09-18'::date AS sold_date UNION ALL
    SELECT '152 Beenleigh Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 800000 AS sold_price, '2025-08-27'::date AS sold_date UNION ALL
    SELECT '140 Dixon Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1560000 AS sold_price, '2025-08-07'::date AS sold_date UNION ALL
    SELECT '4 Pember Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1352500 AS sold_price, '2025-08-21'::date AS sold_date UNION ALL
    SELECT '114 Dixon Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1710000 AS sold_price, '2025-08-16'::date AS sold_date UNION ALL
    SELECT '558 Beenleigh Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1040000 AS sold_price, '2025-08-23'::date AS sold_date UNION ALL
    SELECT '8/371 Beenleigh Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 825000 AS sold_price, '2025-08-25'::date AS sold_date UNION ALL
    SELECT '2/152 Lister Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 750000 AS sold_price, '2025-08-21'::date AS sold_date UNION ALL
    SELECT '20 Lavinia Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1580000 AS sold_price, '2025-10-10'::date AS sold_date UNION ALL
    SELECT '7 Fairbank Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2180000 AS sold_price, '2025-09-20'::date AS sold_date UNION ALL
    SELECT '28 Delafield Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1598000 AS sold_price, '2025-09-13'::date AS sold_date UNION ALL
    SELECT '6 Meta Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1952000 AS sold_price, '2025-10-16'::date AS sold_date UNION ALL
    SELECT '13 Wana Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1280000 AS sold_price, '2025-10-11'::date AS sold_date UNION ALL
    SELECT '24 Devenish Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1852000 AS sold_price, '2025-10-11'::date AS sold_date UNION ALL
    SELECT '76 Woff Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1450000 AS sold_price, '2025-10-11'::date AS sold_date UNION ALL
    SELECT '72 Valhalla Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1458000 AS sold_price, '2025-06-02'::date AS sold_date UNION ALL
    SELECT '199 Mains Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1400000 AS sold_price, '2025-07-16'::date AS sold_date UNION ALL
    SELECT '10 Tarrawonga Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1308000 AS sold_price, '2025-06-02'::date AS sold_date UNION ALL
    SELECT '89 Woff Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2178888 AS sold_price, '2025-07-07'::date AS sold_date UNION ALL
    SELECT '2 Dunedin Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1330000 AS sold_price, '2025-05-31'::date AS sold_date UNION ALL
    SELECT '118 Lister Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1280000 AS sold_price, '2025-06-10'::date AS sold_date UNION ALL
    SELECT '70 Keats Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1300000 AS sold_price, '2025-07-28'::date AS sold_date UNION ALL
    SELECT '27 Samara Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1200000 AS sold_price, '2025-07-02'::date AS sold_date UNION ALL
    SELECT '10 Mulgowie Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1782000 AS sold_price, '2025-05-31'::date AS sold_date UNION ALL
    SELECT '33 Dixon Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2270000 AS sold_price, '2025-06-30'::date AS sold_date UNION ALL
    SELECT '206 Lister Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 968000 AS sold_price, '2025-06-07'::date AS sold_date UNION ALL
    SELECT '20/141 Station Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2600000 AS sold_price, '2025-06-07'::date AS sold_date UNION ALL
    SELECT '50 Mitchell Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 2452000 AS sold_price, '2025-06-07'::date AS sold_date UNION ALL
    SELECT '7/66 Station Road, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 915000 AS sold_price, '2025-07-14'::date AS sold_date UNION ALL
    SELECT '27 Lara Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1730000 AS sold_price, '2025-07-05'::date AS sold_date UNION ALL
    SELECT '58 Halse Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1102000 AS sold_price, '2025-08-03'::date AS sold_date UNION ALL
    SELECT '7 Pengana Street, SUNNYBANK' AS address, 'Sunnybank' AS suburb, 1070000 AS sold_price, '2025-07-15'::date AS sold_date UNION ALL
    SELECT '21/25 Buckingham Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 910000 AS sold_price, '2026-01-05'::date AS sold_date UNION ALL
    SELECT '24/248 Padstow Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 955000 AS sold_price, '2025-12-10'::date AS sold_date UNION ALL
    SELECT '45/25 Buckingham Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 820000 AS sold_price, '2025-11-24'::date AS sold_date UNION ALL
    SELECT '14/16 Arcadia Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 855000 AS sold_price, '2025-11-26'::date AS sold_date UNION ALL
    SELECT '57/26 Buckingham Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 776000 AS sold_price, '2025-11-26'::date AS sold_date UNION ALL
    SELECT '32 McGarry Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1550000 AS sold_price, '2025-11-26'::date AS sold_date UNION ALL
    SELECT '2 Fels Close, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1830888 AS sold_price, '2025-11-29'::date AS sold_date UNION ALL
    SELECT '17 Apple Blossom Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1800000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT '12 Totten Close, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2550000 AS sold_price, '2026-02-16'::date AS sold_date UNION ALL
    SELECT '7 Petrina Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2018000 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '19/28 Holmead Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 920200 AS sold_price, '2025-11-24'::date AS sold_date UNION ALL
    SELECT '10/16 Doris Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 915088 AS sold_price, '2026-02-23'::date AS sold_date UNION ALL
    SELECT '2 Panache Close, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1727000 AS sold_price, '2025-12-18'::date AS sold_date UNION ALL
    SELECT '10/68 Timaru Crescent, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 862500 AS sold_price, '2026-01-20'::date AS sold_date UNION ALL
    SELECT '26 Azzure Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2350000 AS sold_price, '2026-02-07'::date AS sold_date UNION ALL
    SELECT '17 Arpege Crescent, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1575000 AS sold_price, '2025-10-27'::date AS sold_date UNION ALL
    SELECT '20 Liverpool Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1069000 AS sold_price, '2025-10-13'::date AS sold_date UNION ALL
    SELECT '116 Bordeaux Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1802000 AS sold_price, '2025-10-18'::date AS sold_date UNION ALL
    SELECT '13 Cressbrook Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2120500 AS sold_price, '2025-10-24'::date AS sold_date UNION ALL
    SELECT '3 Yvonne Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1582000 AS sold_price, '2025-10-24'::date AS sold_date UNION ALL
    SELECT '17/37 Slobodian Avenue, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 800500 AS sold_price, '2025-10-26'::date AS sold_date UNION ALL
    SELECT '1110/8 Win Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 840000 AS sold_price, '2025-10-20'::date AS sold_date UNION ALL
    SELECT '14/262 Padstow Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 845000 AS sold_price, '2025-10-29'::date AS sold_date UNION ALL
    SELECT '342 Warrigal Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1535000 AS sold_price, '2025-10-25'::date AS sold_date UNION ALL
    SELECT '5 Fendi Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1625000 AS sold_price, '2025-11-08'::date AS sold_date UNION ALL
    SELECT '25 Cranberry Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1917500 AS sold_price, '2025-11-08'::date AS sold_date UNION ALL
    SELECT '2/41 Bleasby Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 802500 AS sold_price, '2025-11-04'::date AS sold_date UNION ALL
    SELECT '5 Kurru Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2005000 AS sold_price, '2025-11-08'::date AS sold_date UNION ALL
    SELECT '15 Poinciana Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1230000 AS sold_price, '2025-11-13'::date AS sold_date UNION ALL
    SELECT '8 Fendi Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2300000 AS sold_price, '2025-11-15'::date AS sold_date UNION ALL
    SELECT '50 Langford Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1551000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT '34 Boorala Crescent, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1635000 AS sold_price, '2025-11-21'::date AS sold_date UNION ALL
    SELECT '489 Warrigal Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1565000 AS sold_price, '2025-11-14'::date AS sold_date UNION ALL
    SELECT '22 Liverpool Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1100000 AS sold_price, '2025-11-14'::date AS sold_date UNION ALL
    SELECT '18 Coneybeer Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1528000 AS sold_price, '2025-09-04'::date AS sold_date UNION ALL
    SELECT '11 Dewberry Close, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1725000 AS sold_price, '2025-09-08'::date AS sold_date UNION ALL
    SELECT '11 Fanfare Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2100000 AS sold_price, '2025-09-18'::date AS sold_date UNION ALL
    SELECT '29 Amarna Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1795000 AS sold_price, '2025-09-14'::date AS sold_date UNION ALL
    SELECT '3 Angel Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1351000 AS sold_price, '2025-08-30'::date AS sold_date UNION ALL
    SELECT '1 Cressbrook Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1821000 AS sold_price, '2025-08-30'::date AS sold_date UNION ALL
    SELECT '5 Savanna Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1250000 AS sold_price, '2025-09-01'::date AS sold_date UNION ALL
    SELECT '32/90 Oakleaf Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 786888 AS sold_price, '2025-09-08'::date AS sold_date UNION ALL
    SELECT '22 Chester Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1840000 AS sold_price, '2025-09-13'::date AS sold_date UNION ALL
    SELECT '60 Bordeaux Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2880800 AS sold_price, '2025-09-20'::date AS sold_date UNION ALL
    SELECT '11/142 Padstow Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 851108 AS sold_price, '2025-09-18'::date AS sold_date UNION ALL
    SELECT '15 Hermitage Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1889000 AS sold_price, '2025-09-27'::date AS sold_date UNION ALL
    SELECT '7/41 Bleasby Road, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 741500 AS sold_price, '2025-09-23'::date AS sold_date UNION ALL
    SELECT '44 Liverpool Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 850000 AS sold_price, '2025-09-17'::date AS sold_date UNION ALL
    SELECT '42 Colvillea Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1320000 AS sold_price, '2025-09-10'::date AS sold_date UNION ALL
    SELECT '10 Savanna Place, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 1305000 AS sold_price, '2025-10-08'::date AS sold_date UNION ALL
    SELECT '46 Manmarra Crescent, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 2041888 AS sold_price, '2025-10-13'::date AS sold_date UNION ALL
    SELECT '5/101 Bolton Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 752000 AS sold_price, '2025-10-02'::date AS sold_date UNION ALL
    SELECT '88 London Street, EIGHT MILE PLAINS' AS address, 'Eight Mile Plains' AS suburb, 975000 AS sold_price, '2025-10-13'::date AS sold_date UNION ALL
    SELECT '30 Tuberose Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1270000 AS sold_price, '2026-02-25'::date AS sold_date UNION ALL
    SELECT '15 Huntington Court, CALAMVALE' AS address, 'Calamvale' AS suburb, 1718000 AS sold_price, '2026-02-06'::date AS sold_date UNION ALL
    SELECT '6 Bottletree Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1654000 AS sold_price, '2026-01-07'::date AS sold_date UNION ALL
    SELECT '65/9 Eduard Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 865000 AS sold_price, '2026-02-18'::date AS sold_date UNION ALL
    SELECT '52 Semper Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1425000 AS sold_price, '2025-12-22'::date AS sold_date UNION ALL
    SELECT '10 Gulubia Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1686000 AS sold_price, '2026-01-07'::date AS sold_date UNION ALL
    SELECT '2 Waterlily Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1525000 AS sold_price, '2026-01-14'::date AS sold_date UNION ALL
    SELECT '40 Gemview St, CALAMVALE' AS address, 'Calamvale' AS suburb, 1480000 AS sold_price, '2026-01-29'::date AS sold_date UNION ALL
    SELECT '60 Menser Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1250000 AS sold_price, '2025-12-25'::date AS sold_date UNION ALL
    SELECT '31/8 Earnshaw Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 795000 AS sold_price, '2026-01-26'::date AS sold_date UNION ALL
    SELECT '10/28 Diane Court, CALAMVALE' AS address, 'Calamvale' AS suburb, 921888 AS sold_price, '2026-01-28'::date AS sold_date UNION ALL
    SELECT '26/8 Honeysuckle Way, CALAMVALE' AS address, 'Calamvale' AS suburb, 895000 AS sold_price, '2026-01-28'::date AS sold_date UNION ALL
    SELECT '369 Benhiam Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1580000 AS sold_price, '2026-02-28'::date AS sold_date UNION ALL
    SELECT '25 Currajong Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1412000 AS sold_price, '2026-01-30'::date AS sold_date UNION ALL
    SELECT '65 Parklands Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1413000 AS sold_price, '2025-11-24'::date AS sold_date UNION ALL
    SELECT '26 Casuarina Crescent, CALAMVALE' AS address, 'Calamvale' AS suburb, 1670000 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '19 Currajong Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1850000 AS sold_price, '2025-12-07'::date AS sold_date UNION ALL
    SELECT '23 Orangetip Crescent, CALAMVALE' AS address, 'Calamvale' AS suburb, 1345000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT ', CALAMVALE' AS address, 'Calamvale' AS suburb, 770000 AS sold_price, '2025-11-20'::date AS sold_date UNION ALL
    SELECT '3 Marigold Close, CALAMVALE' AS address, 'Calamvale' AS suburb, 1690000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT '56 Palatine Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1275000 AS sold_price, '2025-11-22'::date AS sold_date UNION ALL
    SELECT '26 Aster Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1939000 AS sold_price, '2025-11-29'::date AS sold_date UNION ALL
    SELECT '22/10 Highgrove Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 825000 AS sold_price, '2025-11-18'::date AS sold_date UNION ALL
    SELECT '69/36 Benhiam Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 750000 AS sold_price, '2025-11-24'::date AS sold_date UNION ALL
    SELECT '3/18 Mornington Court, CALAMVALE' AS address, 'Calamvale' AS suburb, 749000 AS sold_price, '2025-11-30'::date AS sold_date UNION ALL
    SELECT '5 Lewis Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1268000 AS sold_price, '2025-11-26'::date AS sold_date UNION ALL
    SELECT '10 Tanglebrush Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1586000 AS sold_price, '2025-11-24'::date AS sold_date UNION ALL
    SELECT '27 Gippsland Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1360888 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '220/85 Nottingham Road, CALAMVALE' AS address, 'Calamvale' AS suburb, 870000 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '15/77 Menser Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 840000 AS sold_price, '2025-12-06'::date AS sold_date UNION ALL
    SELECT '20/360 Benhiam Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 850000 AS sold_price, '2025-12-18'::date AS sold_date UNION ALL
    SELECT '9/35 Clarence Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 933000 AS sold_price, '2025-12-10'::date AS sold_date UNION ALL
    SELECT '16/28 Menser Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 730000 AS sold_price, '2025-12-19'::date AS sold_date UNION ALL
    SELECT '181/85 Nottingham Road, CALAMVALE' AS address, 'Calamvale' AS suburb, 801000 AS sold_price, '2025-11-10'::date AS sold_date UNION ALL
    SELECT '69 Honeysuckle Way, CALAMVALE' AS address, 'Calamvale' AS suburb, 1520000 AS sold_price, '2025-11-01'::date AS sold_date UNION ALL
    SELECT '20/2 Diamantina Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 832000 AS sold_price, '2025-11-01'::date AS sold_date UNION ALL
    SELECT '38/108 Menser Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 780000 AS sold_price, '2025-11-02'::date AS sold_date UNION ALL
    SELECT '54/9 Eduard Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 810000 AS sold_price, '2025-11-03'::date AS sold_date UNION ALL
    SELECT '26/20 Nicoro Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 800000 AS sold_price, '2025-11-04'::date AS sold_date UNION ALL
    SELECT '39 Injune Circuit, CALAMVALE' AS address, 'Calamvale' AS suburb, 1600000 AS sold_price, '2025-11-17'::date AS sold_date UNION ALL
    SELECT '3 Rutherglen Crescent, CALAMVALE' AS address, 'Calamvale' AS suburb, 1870000 AS sold_price, '2025-11-15'::date AS sold_date UNION ALL
    SELECT '94 Benhiam Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 1150000 AS sold_price, '2025-11-06'::date AS sold_date UNION ALL
    SELECT '19 Housman Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1200000 AS sold_price, '2025-11-15'::date AS sold_date UNION ALL
    SELECT '3 Yewleaf Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 1950000 AS sold_price, '2025-11-15'::date AS sold_date UNION ALL
    SELECT '53/9 Eduard Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 835500 AS sold_price, '2025-11-05'::date AS sold_date UNION ALL
    SELECT '8 Sorbus Court, CALAMVALE' AS address, 'Calamvale' AS suburb, 1395000 AS sold_price, '2025-11-15'::date AS sold_date UNION ALL
    SELECT '30/11 Pyranees Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 750000 AS sold_price, '2025-11-11'::date AS sold_date UNION ALL
    SELECT '18/78 Ormskirk Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 800000 AS sold_price, '2025-11-09'::date AS sold_date UNION ALL
    SELECT '58/2 Diamantina Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 860000 AS sold_price, '2025-11-10'::date AS sold_date UNION ALL
    SELECT '21/64 Ormskirk Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 870000 AS sold_price, '2025-11-18'::date AS sold_date UNION ALL
    SELECT '1 Mead Place, CALAMVALE' AS address, 'Calamvale' AS suburb, 930000 AS sold_price, '2025-11-14'::date AS sold_date UNION ALL
    SELECT '19 Earnshaw Street, CALAMVALE' AS address, 'Calamvale' AS suburb, 958000 AS sold_price, '2025-11-03'::date AS sold_date
)
INSERT INTO sales(property_id, sold_price, sold_date)
SELECT p.id, t.sold_price, t.sold_date
FROM sales_data t
JOIN properties p ON t.address = p.address AND t.suburb = p.suburb;
