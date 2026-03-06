-- 清空旧数据
DELETE FROM sales;
DELETE FROM properties;
ALTER SEQUENCE properties_id_seq RESTART WITH 1;
ALTER SEQUENCE sales_id_seq RESTART WITH 1;

-- 插入 properties
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1, '104 Kitchener Road, ASCOT', 'ASCOT', 'house', 1268.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2, '201/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (3, '5/36 Alexandra Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (4, '10 Carfin Street, ASCOT', 'ASCOT', 'house', 582.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (5, '2/26 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (6, '24 Baldwin Street, ASCOT', 'ASCOT', 'house', 769.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (7, '20512/61 St Leger Way, ASCOT', 'ASCOT', 'unit', 77.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (8, '66 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 400.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (9, '47 Alexandra Road, ASCOT', 'ASCOT', 'house', 362.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (10, '9/68 Lamington Avenue, ASCOT', 'ASCOT', 'unit', 95.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (11, '1/82 Charlton Street, ASCOT', 'ASCOT', 'unit', 809.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (12, '4/83 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (13, '17 Buxton Street, ASCOT', 'ASCOT', 'house', 438.0, NULL, 2, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (14, '24 Kitchener Road, ASCOT', 'ASCOT', 'house', 660.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (15, '4/15 Onslow Street, ASCOT', 'ASCOT', 'unit', 97.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (16, '2/55 Kitchener Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (17, '6 Comus Avenue, ASCOT', 'ASCOT', 'house', 658.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (18, '5/5 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (19, '6/40 Upper Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (20, '29C Napier Street, ASCOT', 'ASCOT', 'house', 274.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (21, '3/30 Onslow Street, ASCOT', 'ASCOT', 'unit', 100.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (22, '6/23 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (23, '46 Dobson Street, ASCOT', 'ASCOT', 'house', 539.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (24, '306/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (25, '5/40 Butler Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (26, '6/12 Magdala Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (27, '8/36 Brassey Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (28, '71 Dobson Street, ASCOT', 'ASCOT', 'house', 406.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (29, '38 Dobson Street, ASCOT', 'ASCOT', 'house', 412.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (30, '5/27 Napier Street, ASCOT', 'ASCOT', 'unit', 155.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (31, '28A Stevenson Street, ASCOT', 'ASCOT', 'house', 309.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (32, 'A3/151 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (33, '4/129 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 142.0, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (34, '6/11 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', 52.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (35, '5/92 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (36, '32 Sutherland Avenue, ASCOT', 'ASCOT', 'house', 3035.0, NULL, 6, 7, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (37, '15 Ascot Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (38, '32/46 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (39, '79 Charlton Street, ASCOT', 'ASCOT', 'house', 539.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (40, '110/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (41, '83 Charlton Street, ASCOT', 'ASCOT', 'house', 239.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (42, '5/17 Napier Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (43, '210/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (44, '4/29 Hopetoun Street, ASCOT', 'ASCOT', 'unit', 110.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (45, '4/34 Duke Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (46, '6/135 Oriel Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (47, '3/106 Racecourse Road, ASCOT', 'ASCOT', 'unit', 126.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (48, '15/46 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (49, '11 Moynihan Street, ASCOT', 'ASCOT', 'house', 622.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (50, '47 Waratah Steet, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (51, '3/29 Buxton Street, ASCOT', 'ASCOT', 'house', 159.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (52, '5/68 Lamington Avenue, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (53, '4/43 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (54, '28 Kitchener Road, ASCOT', 'ASCOT', 'house', 751.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (55, '6/17 Napier Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (56, '26 Sykes Street, ASCOT', 'ASCOT', 'house', 531.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (57, '11/59 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (58, '11-15 Kidston Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 5, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (59, '155 Yabba Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (60, '11/118 Racecourse Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (61, '3/98 Dobson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (62, '40 Dobson Street, ASCOT', 'ASCOT', 'house', 620.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (63, '52 Massey Street, ASCOT', 'ASCOT', 'house', 505.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (64, '1/32-34 Mordant Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (65, '2/11 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (66, '26 Abbott Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (67, '10402/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (68, '7/21 Vine Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (69, '136 Yabba Street, ASCOT', 'ASCOT', 'house', 792.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (70, '6/84 Charlton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (71, '302/25 Onslow Street, ASCOT', 'ASCOT', 'unit', 104.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (72, '5/12 Magdala Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (73, '4/88 Dobson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (74, '1/35 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (75, '5/59 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (76, '58 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 810.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (77, '301/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (78, '7 Wattle Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (79, '1-5/309 Lancaster Road, ASCOT', 'ASCOT', 'unit', 801.0, NULL, 11, 6, 8);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (80, '107/25 Onslow Street, ASCOT', 'ASCOT', 'unit', 101.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (81, '19 Florence Street, ASCOT', 'ASCOT', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (82, '3/84 Charlton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (83, '10906/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (84, '16 Bennison Street, ASCOT', 'ASCOT', 'house', 787.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (85, '140 Kitchener Road, ASCOT', 'ASCOT', 'house', 810.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (86, '4/5 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (87, '33 Blair Lane, ASCOT', 'ASCOT', 'house', 873.0, NULL, 4, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (88, '3/90 Lamington Avenue, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (89, '2/9 Vine Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (90, '4/95 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (91, '5/30 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (92, '6/118 Racecourse Road, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (93, '166 Oriel Road, ASCOT', 'ASCOT', 'house', 450.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (94, '62 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (95, '29 Lapraik Street, ASCOT', 'ASCOT', 'house', 1017.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (96, '7/26 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (97, '27 Ormond Street, ASCOT', 'ASCOT', 'house', 531.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (98, '7/12 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (99, '28 Silva Street, ASCOT', 'ASCOT', 'house', 876.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (100, '26/46 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (101, '10/12 Lapraik Street, ASCOT', 'ASCOT', 'unit', 122.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (102, '67 Charlton Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (103, '64 Charlton Street, ASCOT', 'ASCOT', 'house', 547.0, NULL, 5, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (104, '2/37 Buxton Street, ASCOT', 'ASCOT', 'unit', 122.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (105, '301 Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (106, '4/313 Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (107, '48 Hopetoun Street, ASCOT', 'ASCOT', 'house', 335.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (108, '25B Lonsdale Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (109, '68 Seymour Road, ASCOT', 'ASCOT', 'house', 181.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (110, '4/17 Lapraik Street, ASCOT', 'ASCOT', 'unit', 83.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (111, '20104/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (112, '3/94 Lamington Avenue, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (113, '74 Towers Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (114, '5 Norman Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (115, '85 Anthony Street, ASCOT', 'ASCOT', 'house', 407.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (116, '108 Kitchener Road, ASCOT', 'ASCOT', 'house', 822.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (117, '23 Sykes Street, ASCOT', 'ASCOT', 'house', 696.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (118, '24 Lonsdale Street, ASCOT', 'ASCOT', 'house', 577.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (119, '9 Bennison Street, ASCOT', 'ASCOT', 'house', 622.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (120, '13 Bennison Street, ASCOT', 'ASCOT', 'house', 1096.0, NULL, 6, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (121, '20411/61 St. Leger Way, ASCOT', 'ASCOT', 'unit', 87.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (122, '2/58 Beatrice Tce, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (123, '10808/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (124, '2/63 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (125, '114 Crosby Road, ASCOT', 'ASCOT', 'house', 809.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (126, '19/26 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (127, '8/26 Vine Street, ASCOT', 'ASCOT', 'house', 136.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (128, '124 Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (129, '50 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 276.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (130, '10603/61 St Leger Way, ASCOT', 'ASCOT', 'unit', 95.0, NULL, 2, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (131, '40 BALDWIN STREET, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (132, '9/12 Lapraik Street, ASCOT', 'ASCOT', 'unit', 101.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (133, '6 Abbott Street, ASCOT', 'ASCOT', 'house', 607.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (134, '85 Charlton Street, ASCOT', 'ASCOT', 'house', 370.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (135, '20808/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (136, '209/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (137, '95 Lapraik Street, ASCOT', 'ASCOT', 'house', 402.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (138, '6 Bale Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (139, '24 Butler Street, ASCOT', 'ASCOT', 'house', 693.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (140, '18 Brassey Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (141, '47 Ascot Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (142, '12/22 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (143, '3/52 Stevenson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (144, '2/40 Butler Street, ASCOT', 'ASCOT', 'unit', 1001.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (145, '8/5 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (146, '18 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (147, '125 Oriel Road, ASCOT', 'ASCOT', 'house', 800.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (148, '27/46 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (149, '5/85 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (150, '11/26 Vine Street, ASCOT', 'ASCOT', 'unit', 136.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (151, '3/80 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (152, '20704/61 ST LEGER WAY, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (153, '2/267 Lancaster Road, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (154, '105 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', 857.0, NULL, 10, 6, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (155, '98 BEATRICE TERRACE, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (156, '4/26 Norman Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (157, '10102/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (158, '10 Kidston Street, ASCOT', 'ASCOT', 'house', 620.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (159, '12 Ascot Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (160, '30 Massey Street, ASCOT', 'ASCOT', 'house', 868.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (161, '5/75 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (162, '7 Lonsdale Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (163, '53 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 438.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (164, '17/26 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (165, '22 Massey Street, ASCOT', 'ASCOT', 'house', 966.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (166, '2/21 Vine Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (167, '11 Abbott Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (168, '4/33 Charlton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (169, '47 Abbott Street, ASCOT', 'ASCOT', 'house', 744.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (170, '1/21 Vine Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (171, '199 Lancaster Road, ASCOT', 'ASCOT', 'house', 522.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (172, '2/21 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (173, '12/9 Silva Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (174, '10412/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (175, '38 Norman Street, ASCOT', 'ASCOT', 'house', 423.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (176, '20703/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (177, '10307/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (178, '4/94 Lamington Avenue, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (179, '5/37 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (180, '203/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (181, '1/39 Onslow Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (182, '2/98 Racecourse Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (183, '29 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 840.0, NULL, 5, 4, 7);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (184, '1/30 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (185, '47 Kitchener Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (186, '41 Mayfield Street, ASCOT', 'ASCOT', 'house', 607.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (187, '6/313 Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (188, '122 Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (189, '5/10 Upper Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (190, '2/17 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (191, '20801/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (192, '92 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (193, '17 Butler Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (194, '3/85 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (195, '10 Ormond Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (196, '21 Mayfield Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 5, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (197, '2/62 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (198, '96 Towers Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (199, '105/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (200, '42 Towers Street, ASCOT', 'ASCOT', 'house', 531.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (201, '4/20 Dobson Street, ASCOT', 'ASCOT', 'unit', 125.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (202, '136 Oriel Road, ASCOT', 'ASCOT', 'house', 810.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (203, '7/5 Buxton Street, ASCOT', 'ASCOT', 'unit', 103.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (204, '78 Towers Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (205, '4/135 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 193.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (206, '96 Crosby Road, ASCOT', 'ASCOT', 'house', 531.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (207, '2/80 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (208, '6/94 Racecourse Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (209, '5/94 Racecourse Road, ASCOT', 'ASCOT', 'house', 130.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (210, '2/27 Brassey Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (211, 'UNIT 3/15 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (212, '26 Lamington Avenue, ASCOT', 'ASCOT', 'house', 544.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (213, '52 Bennison Street, ASCOT', 'ASCOT', 'house', 832.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (214, '3 Morgan Street, ASCOT', 'ASCOT', 'house', 1006.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (215, '1/12-14 Dobson Street, ASCOT', 'ASCOT', 'unit', 356.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (216, '29 Dobson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (217, '2/43 Hopetoun Street, ASCOT', 'ASCOT', 'house', 251.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (218, '5/83 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (219, '30502/41 Saint Leger Way, ASCOT', 'ASCOT', 'unit', 85.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (220, '2/44 Stevenson Street, ASCOT', 'ASCOT', 'house', 137.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (221, '8 Rupert Terrace, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (222, '5/106 Racecourse Road, ASCOT', 'ASCOT', 'unit', 137.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (223, '101/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (224, '1/23 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (225, '2/83 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (226, '2/313 Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (227, '74 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (228, '1/27 Dobson Street, ASCOT', 'ASCOT', 'unit', 347.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (229, '4 Henry Street, ASCOT', 'ASCOT', 'house', 822.0, NULL, 5, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (230, '55 Stevenson Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (231, '15 Hampden Street, ASCOT', 'ASCOT', 'house', 168.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (232, '4/8 Mordant Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (233, '17c Comus Avenue, ASCOT', 'ASCOT', 'house', 526.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (234, '4/17 Magdala Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (235, '10505/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (236, '9/5 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (237, '123 Racecourse Road, ASCOT', 'ASCOT', 'house', 549.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (238, '107/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (239, '5/39 Onslow Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (240, '4/18 Kidston Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (241, '8 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (242, '1/20 Mordant Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (243, '115 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 250.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (244, '2/90 Lamington Avenue, ASCOT', 'ASCOT', 'unit', 136.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (245, '2/21 Butler Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (246, '1/32 Hopetoun Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (247, '80 Yabba Street, ASCOT', 'ASCOT', 'house', 1194.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (248, '29 Towers Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 5, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (249, '14 Bale Street, ASCOT', 'ASCOT', 'house', 901.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (250, '6/26 Buxton Street, ASCOT', 'ASCOT', 'unit', 117.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (251, '51 Massey Street, ASCOT', 'ASCOT', 'house', 374.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (252, '31 Kitchener Road, ASCOT', 'ASCOT', 'house', 635.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (253, '312/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (254, '4/37 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (255, '16 Duke Street, ASCOT', 'ASCOT', 'house', 556.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (256, '4/20 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (257, '3/43 Hopetoun Street, ASCOT', 'ASCOT', 'house', 230.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (258, '84 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (259, '2/83 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (260, '73B Palm Avenue, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (261, '20310/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (262, '104 Alexandra Road, ASCOT', 'ASCOT', 'house', 1275.0, NULL, 4, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (263, '302/297 Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (264, '1/5 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (265, '15 Rupert Terrace, ASCOT', 'ASCOT', 'house', 690.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (266, '92 Massey Street, ASCOT', 'ASCOT', 'house', 673.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (267, '95 Stevenson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (268, '8 Alexandra Road, ASCOT', 'ASCOT', 'house', 810.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (269, '2/151 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', 59.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (270, '7/93 Dobson Street, ASCOT', 'ASCOT', 'unit', 116.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (271, '2/30 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (272, '49 Bennison Street, ASCOT', 'ASCOT', 'house', 886.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (273, '3/98 Racecourse Road, ASCOT', 'ASCOT', 'unit', 143.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (274, '1/90-92 Racecourse Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (275, '1/1 Napier Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (276, '301/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (277, '3/45 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (278, '5/46 Upper Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (279, '100 Towers Street, ASCOT', 'ASCOT', 'house', 810.0, NULL, 5, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (280, '118 Beatrice Terrace, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (281, '1/29 Duke Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (282, '21 Wattle Street, ASCOT', 'ASCOT', 'house', 612.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (283, '175 Lancaster Road, ASCOT', 'ASCOT', 'house', 817.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (284, '109 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (285, '68 Kitchener Road, ASCOT', 'ASCOT', 'house', 1695.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (286, '16 Magdala Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (287, '76 Palm Avenue, ASCOT', 'ASCOT', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (288, '3/27 Brassey Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (289, '307 Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (290, '172 Oriel Road, ASCOT', 'ASCOT', 'house', 809.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (291, '1/94 Stevenson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (292, '30 Upper Lancaster Road, ASCOT', 'ASCOT', 'house', 405.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (293, '40 Mayfield Street, ASCOT', 'ASCOT', 'house', 658.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (294, '1/16 Napier Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (295, '3/26 Vine Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (296, '7/5 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (297, '174 Crosby Road, ASCOT', 'ASCOT', 'house', 713.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (298, '2/93 Racecourse Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (299, '50 Kitchener Road, ASCOT', 'ASCOT', 'house', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (300, '3/60 Dobson Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (301, '20309/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (302, '39 Alexandra Road, ASCOT', 'ASCOT', 'house', 800.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (303, '7/55 Lapraik Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (304, '1/16 Mordant Street, ASCOT', 'ASCOT', 'unit', 145.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (305, '29 Ascot Street, ASCOT', 'ASCOT', 'house', 819.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (306, '36 Stevenson Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (307, '29/46 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (308, '210/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (309, '109/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (310, '7/35 Silva Street, ASCOT', 'ASCOT', 'unit', 128.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (311, '86 Lapraik Street, ASCOT', 'ASCOT', 'house', 509.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (312, '19 Vine Street, ASCOT', 'ASCOT', 'house', 526.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (313, '4/12 Silva Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (314, '3 Hampden Street, ASCOT', 'ASCOT', 'house', 549.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (315, '5/293 Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (316, '77 Palm Avenue, ASCOT', 'ASCOT', 'house', 804.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (317, '4 Dennison Street, ASCOT', 'ASCOT', 'house', 857.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (318, '206/25 Onslow Street, ASCOT', 'ASCOT', 'unit', 1299.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (319, '1/84 CHARLTON STREET, ASCOT', 'ASCOT', 'unit', 132.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (320, '26 Ormond Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (321, '4/46 Upper Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (322, '17 Pringle Street, ASCOT', 'ASCOT', 'house', 830.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (323, '4/38 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (324, 'UNIT 1/12 Buxton Street, ASCOT', 'ASCOT', 'unit', 135.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (325, '2/22 Silva Street, ASCOT', 'ASCOT', 'house', 194.0, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (326, '6 Ormond Street, ASCOT', 'ASCOT', 'house', 562.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (327, '3/34 Duke Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (328, '11/26-30 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (329, '1/29 Buxton Street, ASCOT', 'ASCOT', 'house', 242.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (330, '301/89-95 Sevenson Street, ASCOT', 'ASCOT', 'other', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (331, '20807/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (332, '101/9 Lapraik Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (333, '17 Hopetoun Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (334, '3/36 Alexandra Road, ASCOT', 'ASCOT', 'unit', 809.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (335, '154 Yabba Street, ASCOT', 'ASCOT', 'house', 695.0, NULL, 5, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (336, '117 Yabba Street, ASCOT', 'ASCOT', 'house', 454.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (337, '13/26 Buxton Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (338, '205/25 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (339, '31 Mayfield Street, ASCOT', 'ASCOT', 'house', 696.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (340, '4/16 Napier Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (341, '81 Yabba Street, ASCOT', 'ASCOT', 'house', 582.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (342, '3/43 Silva Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (343, '22 Yabba Street, ASCOT', 'ASCOT', 'house', 1619.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (344, '102/89-95 Sevenson Street, ASCOT', 'ASCOT', 'other', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (345, 'B9/151 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (346, '88 Massey Street, ASCOT', 'ASCOT', 'house', 688.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (347, '9/102 Massey Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (348, '126 Kitchener Road, ASCOT', 'ASCOT', 'house', 422.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (349, '4 Hopetoun Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (350, '2/22 Onslow Street, ASCOT', 'ASCOT', 'unit', 123.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (351, '146 Kitchener Road, ASCOT', 'ASCOT', 'house', 605.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (352, '1/22 Onslow Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (353, '9/25 Duke Street, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (354, '10302/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (355, '119 Towers Street, ASCOT', 'ASCOT', 'house', 407.0, NULL, 5, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (356, '10203/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (357, '56 Palm Avenue, ASCOT', 'ASCOT', 'house', 964.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (358, '2/39 Dobson Street, ASCOT', 'ASCOT', 'unit', 121.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (359, '5/44 Upper Lancaster Road, ASCOT', 'ASCOT', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (360, '16 Gerald Street, ASCOT', 'ASCOT', 'house', 524.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (361, '20206/61 St Leger Way, ASCOT', 'ASCOT', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (362, '44A Charlton Street, ASCOT', 'ASCOT', 'house', 1143.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (363, 'B10/151 Beatrice Terrace, ASCOT', 'ASCOT', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (364, '7/56 Stevenson Street, ASCOT', 'ASCOT', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (365, '59 Dobson Street, ASCOT', 'ASCOT', 'house', 405.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (366, '30 Tuberose Place, CALAMVALE', 'Calamvale', 'house', 639.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (367, '15 Huntington Court, CALAMVALE', 'Calamvale', 'house', 935.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (368, '6 Bottletree Place, CALAMVALE', 'Calamvale', 'house', 860.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (369, '65/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (370, '52 Semper Place, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (371, '10 Gulubia Place, CALAMVALE', 'Calamvale', 'house', 714.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (372, '2 Waterlily Place, CALAMVALE', 'Calamvale', 'house', 726.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (373, '16/28 Menser Street, CALAMVALE', 'Calamvale', 'house', 162.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (374, '60 Menser Street, CALAMVALE', 'Calamvale', 'house', 422.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (375, '31/8 Earnshaw Street, CALAMVALE', 'Calamvale', 'house', 211.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (376, '10/28 Diane Court, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (377, '26/8 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (378, '369 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 492.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (379, '25 Currajong Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (380, '11 Khoo Place, CALAMVALE', 'Calamvale', 'vacant_land', 710.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (381, '15/20 Nicoro Place, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (382, '216 Algester Road, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (383, '47 Doulton Street, CALAMVALE', 'Calamvale', 'house', 249.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (384, '63 Dianthus Place, CALAMVALE', 'Calamvale', 'house', 626.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (385, '15/200 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 229.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (386, '56 Menser Street, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (387, '8/88 Candytuft Place, CALAMVALE', 'Calamvale', 'house', 137.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (388, '12/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 157.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (389, '2 Freeman Place, CALAMVALE', 'Calamvale', 'house', 497.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (390, 'UNIT 16/8 Gemview Street, CALAMVALE', 'Calamvale', 'other', 223.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (391, '21/2 Rory Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (392, '34/725 Gowan Road, CALAMVALE', 'Calamvale', 'house', 206.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (393, '18 Brentwood Street, CALAMVALE', 'Calamvale', 'vacant_land', 485.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (394, '2 Cibo Court, CALAMVALE', 'Calamvale', 'house', 615.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (395, '35/46 Hamish Street, CALAMVALE', 'Calamvale', 'house', 132.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (396, '67 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 514.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (397, '1/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 157.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (398, '14/16 Dellforest Drive, CALAMVALE', 'Calamvale', 'house', 207.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (399, '49 88 Shelduck Place, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (400, '5 Rivergum Place, CALAMVALE', 'Calamvale', 'house', 770.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (401, '2/25 Yarrawonga Street, CALAMVALE', 'Calamvale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (402, '19 Maywood Crescent, CALAMVALE', 'Calamvale', 'house', 730.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (403, '38 Carnation Crescent, CALAMVALE', 'Calamvale', 'house', 750.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (404, '19/8 Gemview Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (405, '9/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (406, '39/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (407, '28/8 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', 236.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (408, '27 Perkins Street, CALAMVALE', 'Calamvale', 'house', 523.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (409, '7 Parklands Street, CALAMVALE', 'Calamvale', 'house', 800.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (410, '214 Algester Road, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (411, '79 Grevillea Park Crescent, CALAMVALE', 'Calamvale', 'house', 802.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (412, 'Unit 13/64 Ormskirk St, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (413, '25 Swan Lake Crescent, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (414, '6 Carnation Crescent, CALAMVALE', 'Calamvale', 'house', 790.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (415, '45 Reardon Street, CALAMVALE', 'Calamvale', 'house', 455.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (416, '30 Harvey Place, CALAMVALE', 'Calamvale', 'house', 466.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (417, '18 Moneghetti Place, CALAMVALE', 'Calamvale', 'house', 563.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (418, '62 Orania Crescent, CALAMVALE', 'Calamvale', 'house', 914.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (419, '16/20 Neiwand Street, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (420, '22 Klim Street, CALAMVALE', 'Calamvale', 'house', 451.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (421, '12 Housman Place, CALAMVALE', 'Calamvale', 'house', 645.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (422, '26/8 Gemview Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (423, '21/88 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 194.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (424, '16 Daffodil Crescent, CALAMVALE', 'Calamvale', 'house', 750.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (425, '21 Harvey Place, CALAMVALE', 'Calamvale', 'house', 530.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (426, '6/20 Rosella Close, CALAMVALE', 'Calamvale', 'house', 198.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (427, '215/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (428, '62/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (429, '29/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 172.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (430, '32/8 Earnshaw Street, CALAMVALE', 'Calamvale', 'house', 211.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (431, '8 Samuel Street, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (432, '7 Matilda Way, CALAMVALE', 'Calamvale', 'house', 568.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (433, '33/88 Kameruka Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (434, '4 Fallon Court, CALAMVALE', 'Calamvale', 'house', 730.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (435, '247/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (436, '37/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 200.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (437, '39 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 409.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (438, '62/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (439, '30 Gemview Street, CALAMVALE', 'Calamvale', 'house', 806.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (440, '10 Kinwarton Crescent, CALAMVALE', 'Calamvale', 'house', 405.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (441, '21/53 Perkins Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (442, '8A Currajong Street, CALAMVALE', 'Calamvale', 'house', 477.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (443, '602 Gowan Road, CALAMVALE', 'Calamvale', 'house', 760.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (444, '15 NOLAN PLACE, CALAMVALE', 'Calamvale', 'house', 544.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (445, '44/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (446, '16/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 138.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (447, '3 Golden Ave, CALAMVALE', 'Calamvale', 'house', 705.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (448, '23 Sheldon Street, CALAMVALE', 'Calamvale', 'house', 817.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (449, '6 Chestnut Place, CALAMVALE', 'Calamvale', 'house', 879.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (450, '24/8 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (451, '45A/35 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (452, '34/380 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 172.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (453, '54/50 Perkins Street, CALAMVALE', 'Calamvale', 'house', 180.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (454, '57 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 456.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (455, '14 Murphy Street, CALAMVALE', 'Calamvale', 'house', 568.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (456, '8/52 Highgrove Street, CALAMVALE', 'Calamvale', 'unit', 160.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (457, '8/36 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (458, '12 Narcissus Place, CALAMVALE', 'Calamvale', 'house', 457.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (459, '43 Alfred Circuit, CALAMVALE', 'Calamvale', 'house', 715.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (460, '1 Windsor Court, CALAMVALE', 'Calamvale', 'house', 454.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (461, '25/27 Sunflower Crescent, CALAMVALE', 'Calamvale', 'house', 165.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (462, '12/422 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 191.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (463, '10/25 Yarrawonga Street, CALAMVALE', 'Calamvale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (464, '12 Moneghetti Place, CALAMVALE', 'Calamvale', 'house', 539.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (465, '64 Grevillea Park Crescent, CALAMVALE', 'Calamvale', 'house', 699.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (466, '6/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 146.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (467, '91 Sunflower Crescent, CALAMVALE', 'Calamvale', 'house', 763.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (468, '11 Lewis Place, CALAMVALE', 'Calamvale', 'house', 471.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (469, '1/28 Diane Court, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (470, '38/7 Gemview Street (72 Menser St), CALAMVALE', 'Calamvale', 'house', 207.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (471, '37/725 Gowan Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (472, '27 Hamish Street, CALAMVALE', 'Calamvale', 'house', 470.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (473, '28/2 Rory Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (474, '13/18 Diane Court, CALAMVALE', 'Calamvale', 'house', 143.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (475, '32/2 Rory Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (476, '7/78 Ormskirk Street, CALAMVALE', 'Calamvale', 'house', 133.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (477, '2 Moneghetti Place, CALAMVALE', 'Calamvale', 'house', 495.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (478, '27 Semper Place, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (479, '4/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (480, '51/8 Earnshaw Street, CALAMVALE', 'Calamvale', 'unit', 208.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (481, '190 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (482, '17/200 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 176.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (483, '23 Hailey Place, CALAMVALE', 'Calamvale', 'house', 802.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (484, '21/88 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 127.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (485, '43/38 Illaweena Street, CALAMVALE', 'Calamvale', 'house', 187.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (486, '16 Wisteria Place, CALAMVALE', 'Calamvale', 'house', 650.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (487, '29/57 Nabeel Place, CALAMVALE', 'Calamvale', 'house', 168.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (488, 'UNIT 15/10 HIGHGROVE STREET, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (489, '14 Semper Place, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (490, '22/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 157.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (491, '20 Watervale Place, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (492, '17/16 Dellforest Drive, CALAMVALE', 'Calamvale', 'house', 150.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (493, '162/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (494, '12/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 138.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (495, '29/8 Earnshaw Street, CALAMVALE', 'Calamvale', 'house', 205.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (496, '7/85 Menser Street, CALAMVALE', 'Calamvale', 'house', 169.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (497, 'Unit 21/380 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (498, '11/88 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 145.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (499, '12 Bala Place, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (500, '393 Gowan Road, CALAMVALE', 'Calamvale', 'house', 607.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (501, '70 Bougainvillea Street, CALAMVALE', 'Calamvale', 'house', 801.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (502, '32/10 Diane Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (503, '1/4 Watt Court, CALAMVALE', 'Calamvale', 'house', 167.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (504, '8 Earls Court, CALAMVALE', 'Calamvale', 'house', 659.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (505, '93 Sunflower Crescent, CALAMVALE', 'Calamvale', 'house', 862.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (506, '4/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (507, '11/200 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 201.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (508, '40/380 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 172.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (509, '38 Corypha Crescent, CALAMVALE', 'Calamvale', 'house', 722.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (510, '5/138 Golden Avenue, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (511, '30/85 Menser Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (512, '3 Carmel Place, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (513, '22/8 Gemview Street, CALAMVALE', 'Calamvale', 'other', 223.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (514, '9 Gemview Street, CALAMVALE', 'Calamvale', 'house', 512.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (515, '21/28 Menser Street, CALAMVALE', 'Calamvale', 'house', 162.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (516, '2 Harvey Place, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (517, '36/20 Nicoro Place, CALAMVALE', 'Calamvale', 'house', 236.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (518, '32/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 146.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (519, '11/88 Candytuft Place, CALAMVALE', 'Calamvale', 'house', 139.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (520, '21 Swan Lake Crescent, CALAMVALE', 'Calamvale', 'house', 762.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (521, '16/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (522, 'Unit 8/14 Sunflower Cres, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (523, '8/88 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (524, '25/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 140.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (525, '11 Galliano Court, CALAMVALE', 'Calamvale', 'house', 739.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (526, '44 Central Street, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (527, '18/18 Mornington Ct, CALAMVALE', 'Calamvale', 'house', 192.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (528, '27 Daffodil Crescent, CALAMVALE', 'Calamvale', 'house', 892.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (529, '24/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 138.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (530, '1 Lenton Place, CALAMVALE', 'Calamvale', 'house', 492.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (531, '21/53 Injune Circuit, CALAMVALE', 'Calamvale', 'house', 198.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (532, '26/53 Injune Circuit, CALAMVALE', 'Calamvale', 'house', 166.0, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (533, '52 Swan Lake Crescent, CALAMVALE', 'Calamvale', 'house', 717.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (534, '75 Palatine Street, CALAMVALE', 'Calamvale', 'house', 800.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (535, '13/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (536, '10/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 146.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (537, '20/350 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 151.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (538, '8 Tupelo Street, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (539, '15 Nabeel Place, CALAMVALE', 'Calamvale', 'house', 496.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (540, '39/16 Yarrawonga St, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (541, '24 Corypha Crescent, CALAMVALE', 'Calamvale', 'house', 616.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (542, '9/43 Bundabah Drive, CALAMVALE', 'Calamvale', 'house', 173.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (543, '52 Candytuft Place, CALAMVALE', 'Calamvale', 'house', 603.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (544, '35 Kinwarton Crescent, CALAMVALE', 'Calamvale', 'house', 2016.0, NULL, 5, 4, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (545, '53 Bougainvillea Street, CALAMVALE', 'Calamvale', 'house', 640.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (546, '27/85 Menser Street, CALAMVALE', 'Calamvale', 'house', 173.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (547, '10 Caravonica Court, CALAMVALE', 'Calamvale', 'house', 892.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (548, '25 Monsour Street, CALAMVALE', 'Calamvale', 'house', 704.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (549, '85 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (550, '2/43 Doulton Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (551, '30 Bellflower Place, CALAMVALE', 'Calamvale', 'house', 729.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (552, '6/2 Rory Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (553, '19/43 Bundabah Drive, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (554, '30/53 Injune Circuit, CALAMVALE', 'Calamvale', 'house', 193.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (555, '10 Rya Close, CALAMVALE', 'Calamvale', 'house', 1131.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (556, '86/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (557, '78/11 Butler Crescent, CALAMVALE', 'Calamvale', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (558, '42/20 Stockton Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (559, '20/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 145.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (560, '11 Wisteria Place, CALAMVALE', 'Calamvale', 'house', 605.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (561, '7 Caravonica Court, CALAMVALE', 'Calamvale', 'house', 384.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (562, '28 Khoo Place, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (563, '7 Brandy Court, CALAMVALE', 'Calamvale', 'house', 774.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (564, '53/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (565, '4 Mead Place, CALAMVALE', 'Calamvale', 'house', 528.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (566, '22/338 Algester Road, CALAMVALE', 'Calamvale', 'house', 164.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (567, '185/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (568, '23 Klim Street, CALAMVALE', 'Calamvale', 'house', 455.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (569, '48/36 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (570, '7/18 Diane Court, CALAMVALE', 'Calamvale', 'house', 143.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (571, '29 Watervale Place, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 8, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (572, '86/36 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (573, '218/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 148.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (574, '65 Parklands Street, CALAMVALE', 'Calamvale', 'house', 744.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (575, '26 Casuarina Crescent, CALAMVALE', 'Calamvale', 'house', 825.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (576, '19 Currajong Street, CALAMVALE', 'Calamvale', 'house', 735.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (577, '23 Orangetip Crescent, CALAMVALE', 'Calamvale', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (578, '3 Marigold Close, CALAMVALE', 'Calamvale', 'house', 870.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (579, '56 Palatine Street, CALAMVALE', 'Calamvale', 'house', 660.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (580, '26 Aster Place, CALAMVALE', 'Calamvale', 'house', 656.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (581, '22/10 Highgrove Street, CALAMVALE', 'Calamvale', 'house', 144.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (582, '69/36 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 143.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (583, '3/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 205.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (584, '5 Lewis Place, CALAMVALE', 'Calamvale', 'house', 451.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (585, '10 Tanglebrush Place, CALAMVALE', 'Calamvale', 'house', 800.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (586, '27 Gippsland Place, CALAMVALE', 'Calamvale', 'house', 451.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (587, '220/85 Nottingham Road, CALAMVALE', 'Calamvale', 'unit', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (588, '15/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 156.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (589, '20/360 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 166.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (590, '9/35 Clarence Street, CALAMVALE', 'Calamvale', 'house', 184.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (591, '40 Gemview St, CALAMVALE', 'Calamvale', 'house', 876.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (592, '27 Alfred Circuit, CALAMVALE', 'Calamvale', 'house', 773.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (593, 'Unit 75/36 Benhiam St, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (594, '3 Marsala Street, CALAMVALE', 'Calamvale', 'house', 620.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (595, '13/25 Yarrawonga St, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (596, '9 Bellflower Place, CALAMVALE', 'Calamvale', 'house', 721.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (597, '42/96 Formby Street, CALAMVALE', 'Calamvale', 'other', 289.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (598, '3/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 140.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (599, '10 Orania Crescent, CALAMVALE', 'Calamvale', 'house', 720.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (600, '20 Poinsettia Crescent, CALAMVALE', 'Calamvale', 'house', 815.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (601, '34/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (602, '50/88 Kameruka Street, CALAMVALE', 'Calamvale', 'house', 202.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (603, '24/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 181.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (604, '44/88 KAMERUKA STREET, CALAMVALE', 'Calamvale', 'house', 128.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (605, '5 Poplar Close, CALAMVALE', 'Calamvale', 'house', 935.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (606, '30/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', 156.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (607, '230/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 194.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (608, '21 Lyrebird Street, CALAMVALE', 'Calamvale', 'house', 750.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (609, '16/360 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 156.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (610, '20/10 Highgrove Street, CALAMVALE', 'Calamvale', 'house', 136.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (611, '181/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (612, '69 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', 810.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (613, '20/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (614, '38/108 Menser Street, CALAMVALE', 'Calamvale', 'house', 158.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (615, '54/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', 134.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (616, '26/20 Nicoro Place, CALAMVALE', 'Calamvale', 'house', 139.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (617, '39 Injune Circuit, CALAMVALE', 'Calamvale', 'house', 500.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (618, '3 Rutherglen Crescent, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (619, '94 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 460.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (620, '19 Housman Place, CALAMVALE', 'Calamvale', 'house', 578.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (621, '3 Yewleaf Place, CALAMVALE', 'Calamvale', 'house', 800.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (622, '8 Sorbus Court, CALAMVALE', 'Calamvale', 'house', 575.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (623, '30/11 Pyranees Street, CALAMVALE', 'Calamvale', 'house', 182.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (624, '18/78 Ormskirk Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (625, '58/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (626, '21/64 Ormskirk Street, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (627, '1 Mead Place, CALAMVALE', 'Calamvale', 'house', 520.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (628, '19 Earnshaw Street, CALAMVALE', 'Calamvale', 'house', 303.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (629, '32 Maywood Crescent, CALAMVALE', 'Calamvale', 'house', 754.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (630, '15/64 Ormskirk Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (631, '34 Stockton Street, CALAMVALE', 'Calamvale', 'house', 500.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (632, '2 Parklands Street, CALAMVALE', 'Calamvale', 'house', 830.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (633, '12 Gould Place, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (634, '36/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 198.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (635, '15/88 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (636, '24/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 240.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (637, '13 Harmony Street, CALAMVALE', 'Calamvale', 'house', 425.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (638, '82/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (639, '12 Galliano Court, CALAMVALE', 'Calamvale', 'house', 651.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (640, '18/88 Candytuft Place, CALAMVALE', 'Calamvale', 'house', 75.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (641, '12 Semper Place, CALAMVALE', 'Calamvale', 'house', 500.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (642, '17 Carnation Crescent, CALAMVALE', 'Calamvale', 'house', 769.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (643, '11 Narcissus Place, CALAMVALE', 'Calamvale', 'house', 495.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (644, '192/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (645, '69 Hamish Street, CALAMVALE', 'Calamvale', 'house', 485.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (646, '10/138 Golden Avenue, CALAMVALE', 'Calamvale', 'house', 131.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (647, '10/35 Clarence Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (648, '3 Violet Place, CALAMVALE', 'Calamvale', 'house', 750.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (649, '10 Webb Street, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (650, '13 Camplin Place, CALAMVALE', 'Calamvale', 'house', 580.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (651, '50/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (652, '16 Idris Court, CALAMVALE', 'Calamvale', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (653, '56 Solandra Crescent, CALAMVALE', 'Calamvale', 'house', 487.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (654, '20 Gemview Street, CALAMVALE', 'Calamvale', 'house', 804.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (655, '166/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (656, '29/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 157.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (657, '20 Bundabah Drive, CALAMVALE', 'Calamvale', 'house', 677.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (658, '41/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 130.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (659, '31/108 Menser Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (660, '49/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 151.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (661, '6/36 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (662, '20/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 140.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (663, '29/20 Stockton Street, CALAMVALE', 'Calamvale', 'house', 187.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (664, '36 Gemview Street, CALAMVALE', 'Calamvale', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (665, '37/50 Perkins Street, CALAMVALE', 'Calamvale', 'house', 182.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (666, '23 Nabeel Place, CALAMVALE', 'Calamvale', 'house', 540.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (667, '59/50 Perkins St, CALAMVALE', 'Calamvale', 'house', 173.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (668, '41/16 Yarrawonga St, CALAMVALE', 'Calamvale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (669, '144/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (670, '33 Menser Street, CALAMVALE', 'Calamvale', 'house', 448.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (671, '18/35 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (672, '5 Ayesha Place, CALAMVALE', 'Calamvale', 'house', 649.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (673, '3 Dewick Court, CALAMVALE', 'Calamvale', 'house', 501.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (674, '6 Harmony Street, CALAMVALE', 'Calamvale', 'vacant_land', 460.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (675, '59 Orania Crescent, CALAMVALE', 'Calamvale', 'house', 721.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (676, '9 Harmony Street, CALAMVALE', 'Calamvale', 'house', 425.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (677, '29/88 Shelduck Place, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (678, '16/22 Highgrove Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (679, '16 Tupelo Street, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (680, '8/11 Pyranees Street, CALAMVALE', 'Calamvale', 'house', 168.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (681, '83/18 Mornington Court, CALAMVALE', 'Calamvale', 'house', 178.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (682, '20/422 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 175.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (683, '9 Bottletree Place, CALAMVALE', 'Calamvale', 'house', 1082.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (684, '58 Chateau Street, CALAMVALE', 'Calamvale', 'house', 802.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (685, '5/11 Pyranees Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (686, '99/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 202.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (687, '41/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 177.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (688, '24/10 Highgrove Street, CALAMVALE', 'Calamvale', 'house', 136.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (689, '6 Neiwand Street, CALAMVALE', 'Calamvale', 'house', 450.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (690, '9/20 Stockton Street, CALAMVALE', 'Calamvale', 'house', 187.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (691, '12 Khoo Place, CALAMVALE', 'Calamvale', 'house', 559.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (692, '69/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 109.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (693, '46 Marsala Street, CALAMVALE', 'Calamvale', 'house', 588.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (694, '53 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', 856.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (695, '26 Hudson Street, CALAMVALE', 'Calamvale', 'house', 400.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (696, '39/50 Perkins Street, CALAMVALE', 'Calamvale', 'house', 182.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (697, '34/8 Honeysuckle Way, CALAMVALE', 'Calamvale', 'house', 227.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (698, '33 Aster Place, CALAMVALE', 'Calamvale', 'house', 676.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (699, '5 Sheldon Street, CALAMVALE', 'Calamvale', 'house', 928.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (700, '10 Boronia Close, CALAMVALE', 'Calamvale', 'house', 716.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (701, '13/35 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 142.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (702, '29 Casuarina Crescent, CALAMVALE', 'Calamvale', 'house', 780.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (703, '11 Chestnut Place, CALAMVALE', 'Calamvale', 'house', 750.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (704, '23/422 Benhiam Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (705, 'Unit 53/11 Butler Cres, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (706, '2 Dellforest Drive, CALAMVALE', 'Calamvale', 'house', 672.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (707, '62/50 Perkins Street, CALAMVALE', 'Calamvale', 'house', 163.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (708, '238/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (709, '1/1 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 146.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (710, '9/10 Highgrove Street, CALAMVALE', 'Calamvale', 'house', 134.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (711, '35/9 Eduard Place, CALAMVALE', 'Calamvale', 'house', 152.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (712, '22 Moneghetti Place, CALAMVALE', 'Calamvale', 'house', 648.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (713, '3/53 Injune Circuit, CALAMVALE', 'Calamvale', 'house', 180.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (714, '42/28 Benhiam Street, CALAMVALE', 'Calamvale', 'house', 138.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (715, '106/2 Diamantina Street, CALAMVALE', 'Calamvale', 'unit', 198.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (716, '67 Alfred Circuit, CALAMVALE', 'Calamvale', 'house', 741.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (717, '63 Alfred Circuit, CALAMVALE', 'Calamvale', 'house', 768.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (718, '26/2 Rory Court, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (719, '10 Pennant Place, CALAMVALE', 'Calamvale', 'house', 1050.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (720, '21/10 Highgrove Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (721, '8/8 Gemview Street, CALAMVALE', 'Calamvale', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (722, '13/28 Menser Street, CALAMVALE', 'Calamvale', 'house', 163.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (723, '28 Bellflower Place, CALAMVALE', 'Calamvale', 'house', 729.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (724, '29 Grevillea Crescent, CALAMVALE', 'Calamvale', 'house', 704.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (725, '25/77 Menser Street, CALAMVALE', 'Calamvale', 'house', 156.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (726, '39 Wisteria Place, CALAMVALE', 'Calamvale', 'house', 621.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (727, '54/2 Diamantina Street, CALAMVALE', 'Calamvale', 'house', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (728, '190/85 Nottingham Road, CALAMVALE', 'Calamvale', 'house', 153.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (729, '12 Pepper Tree Street, CALAMVALE', 'Calamvale', 'house', 494.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (730, '3/35 Jaffa Crescent, CALAMVALE', 'Calamvale', 'house', 146.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (731, '40 Alfred Circuit, CALAMVALE', 'Calamvale', 'house', 722.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (732, '21/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (733, '24/248 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 195.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (734, '45/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 186.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (735, '14/16 Arcadia Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 128.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (736, '57/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 177.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (737, '32 McGarry Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 611.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (738, '2 Fels Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 501.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (739, '12 Totten Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1237.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (740, '7 Petrina Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 809.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (741, '19/28 Holmead Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 330.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (742, '10/16 Doris Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (743, '2 Panache Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 868.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (744, '10/68 Timaru Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 173.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (745, '26 Azzure Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 670.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (746, '24/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (747, 'Lot 1/56 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 406.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (748, '17 Lilywood Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 1.84, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (749, '1 Alberton Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 498.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (750, '22 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 676.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (751, '5 Collett Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 622.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (752, '63 Walker Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 541.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (753, '3 Hermitage Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 671.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (754, '9 Dewberry Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 719.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (755, '52 Langford Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 375.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (756, '30 Greenlaw Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 456.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (757, '5/42 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (758, '49 London ST, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (759, '503/66 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (760, '4/248 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 188.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (761, '7 BAUHINIA CLOSE, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 618.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (762, '16/75 Levington Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (763, '17 Ellendale Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 556.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (764, '152 Bordeaux St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 486.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (765, '15/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (766, '21/577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (767, '38/407 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (768, '24 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 4047.0, NULL, NULL, NULL, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (769, '2/30 Lindeman Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 301.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (770, '36 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (771, '29/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (772, '8 Chloe Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 878.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (773, '29A Apple Blossom Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 786.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (774, '22 Avonlea Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 746.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (775, '15/36 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 181.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (776, '25 Oakleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 679.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (777, '3 Kirstin Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 429.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (778, '20/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (779, '13/45 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 110.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (780, '38/37 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 135.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (781, '16 Petrina Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 766.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (782, '6 Manara Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 957.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (783, '186 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 3901.0, NULL, 4, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (784, 'Lot 23/577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (785, '11 Rakumba Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1163.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (786, '38 Blue Grass Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 780.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (787, '27 Amarna Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 691.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (788, '121/54 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (789, '5/1 O''Meara Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 135.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (790, '17 Hermitage Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 673.0, NULL, 5, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (791, '14/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (792, '41/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (793, '3 Leelaben Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 647.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (794, '136 Chester Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 671.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (795, '55 Dandelion Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (796, '196/54 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', 83.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (797, '88 Blue Grass Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 680.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (798, '29 Blue Grass Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 758.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (799, '40 Alan Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 677.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (800, '23/7 Delonix Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (801, '60 London Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (802, '513 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 810.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (803, '14 Kalkadoon Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 618.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (804, '4 Bedarra Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 910.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (805, '348 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 805.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (806, '20 Leelaben Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 708.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (807, '14 Chanel Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 801.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (808, '12 Lindeman Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 962.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (809, '8 Dandelion Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1411.0, NULL, 5, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (810, '36/42 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (811, '1/16 Doris Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 436.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (812, '35 Collett Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 578.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (813, '1 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 615.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (814, '30 Timaru Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 401.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (815, '5/8 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (816, '2469 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 467.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (817, '309/66 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (818, '40 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 4047.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (819, '76 Malbon Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 645.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (820, '63 Dandelion Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 675.0, NULL, 6, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (821, '9 Mapleleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 616.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (822, 'Lot 26/577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (823, '16/262 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (824, '16 Saville Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 610.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (825, '577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (826, '21 Cintra Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 609.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (827, '2 Trevi Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (828, '23 Greenlaw Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (829, '7 Brooklands Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 691.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (830, '5 Teagarden Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 611.0, NULL, 6, 4, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (831, '89/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (832, '126 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 876.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (833, '7 Rakumba Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 758.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (834, '65 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (835, '5 Narmar Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 627.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (836, '11 Fanfare Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 624.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (837, '39 Ellendale Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 562.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (838, '16/28 Holmead Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 328.0, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (839, '103/66 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (840, '72/15 Violet Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 154.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (841, '14/23-45 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (842, '4/36 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (843, '404/66 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (844, '32 Greenlaw Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 491.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (845, '88 Nardie Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 829.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (846, '48/9 SAN MATEO BOULEVARD, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 187.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (847, '30 Brampton Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (848, '6 Tanis Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1050.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (849, '8 Forbes Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 803.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (850, '36/88 Bleasby road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (851, '31 Gagarra Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 800.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (852, '8/7 Delonix Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (853, '51 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (854, '65 Blue Grass Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 615.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (855, '16/40 Arcadia Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (856, '4/101 Bolton Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 249.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (857, '6 Verdelho Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 671.0, NULL, 4, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (858, '81 Malbon Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 699.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (859, '14/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (860, '3 Burns Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 803.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (861, '7/156 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (862, '15 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 617.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (863, '9 McGarry Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 640.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (864, '6 Stanton Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 801.0, NULL, 4, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (865, '43 Ingluna Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 863.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (866, '77/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 139.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (867, '9 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 692.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (868, '14 Trevi Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (869, '12 Pumice Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 653.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (870, '11/30 Lindeman Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 393.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (871, '58 Manor Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 559.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (872, '27/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 230.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (873, '82 Underwood Rd, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 616.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (874, '27/88 Bleasby road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (875, '17 Vanderbilt Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 740.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (876, '169 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 3974.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (877, '14 Bolinda Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 780.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (878, '3/28 Holmead Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (879, '39 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 647.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (880, '31 SETTLER STREET, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 588.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (881, '9 Heathfield Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 701.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (882, '18 Pinnacle Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (883, '58/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (884, '21 Trevi Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 552.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (885, '51 Blue Grass Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 681.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (886, '8/8 Manor Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (887, '35/100 Bordeaux St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 212.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (888, '68 Manchester Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 349.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (889, '9 Aviance Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 900.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (890, '2 Totten Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 949.0, NULL, 6, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (891, '11 Catalpa Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 643.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (892, '69 London Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (893, '4/41 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (894, '44/9 San Mateo Boulevard, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (895, '32/9 San Mateo Boulevard, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (896, '25 Devonlea Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 625.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (897, '10 Lakkari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 814.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (898, '5 Fitzalan Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (899, '41 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 711.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (900, '20 Catalpa Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 816.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (901, '8/156 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (902, '908/8 Win Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (903, '56/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (904, '15 Norell Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (905, '1 Cactus Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 673.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (906, '27 Demigre Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 760.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (907, '17 Yvonne Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (908, '126 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 601.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (909, '1/42 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (910, '108 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 651.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (911, '45 Manchester Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 425.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (912, '4 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (913, '44 Ingluna Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 901.0, NULL, 6, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (914, '48/16 Arcadia Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (915, '48/538 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (916, '61 Regent Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 851.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (917, '61/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 206.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (918, '83/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (919, '13 Cressbrook Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 405.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (920, '10/100 Bordeaux St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 225.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (921, '6 Chanel Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (922, '48/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (923, '4/16 Arcadia Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (924, '31/538 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 127.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (925, '23 Horizon Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 641.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (926, '19/75 LEVINGTON ROAD, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (927, '31/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 238.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (928, '39 Regent Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 805.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (929, '3 Horizon Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 687.0, NULL, 5, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (930, '83 Manchester Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 353.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (931, '32 Bolton Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 810.0, NULL, 8, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (932, '128 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1037.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (933, '36/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (934, '29/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (935, '21 Mapleleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 616.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (936, '3 Bramwell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 577.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (937, '17 Arpege Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 650.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (938, '116 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 677.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (939, '3 Yvonne Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (940, '17/37 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 135.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (941, '1110/8 Win Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (942, '14/262 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 151.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (943, '342 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 809.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (944, '5 Fendi Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 730.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (945, '25 Cranberry Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 717.0, NULL, 3, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (946, '2/41 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 129.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (947, '5 Kurru Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 852.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (948, '15 Poinciana Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 650.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (949, '8 Fendi Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 718.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (950, '50 Langford Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 379.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (951, '34 Boorala Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 713.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (952, '17 Apple Blossom Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 960.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (953, '489 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 674.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (954, '22 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (955, '11 Kandanga St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 698.0, NULL, 3, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (956, '52 Miles Platting Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 425.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (957, '10/9 San Mateo Boulevard, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (958, '29/16 Violet Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 135.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (959, '64/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (960, '6 Pumice Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 759.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (961, '35/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (962, '21/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (963, '19 Brooklands Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 502.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (964, '36/538 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (965, '46/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (966, '128 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 642.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (967, '52/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (968, '12 Brooklands Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 638.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (969, '10/45 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 169.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (970, '69/5 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (971, '69 Dandelion Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (972, '3 Angel Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (973, '51 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 969.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (974, '20/407 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 134.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (975, '18 Coneybeer Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (976, '11 Dewberry Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 628.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (977, '29 Amarna Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 693.0, NULL, 5, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (978, '5 Savanna Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (979, '32/90 Oakleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 127.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (980, '22 Chester Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 425.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (981, '60 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 889.0, NULL, 5, 6, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (982, '11/142 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 171.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (983, '15 Hermitage Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 671.0, NULL, 6, 6, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (984, '7/41 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 126.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (985, '44 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'vacant_land', 458.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (986, '42 Colvillea Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 650.0, NULL, 4, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (987, '10 Savanna Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 453.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (988, '46 Manmarra Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 850.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (989, '20 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (990, '5/101 Bolton Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (991, '88 London Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 405.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (992, '7/228 Gaskell St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (993, '72 Underwood Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 616.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (994, '3 Gagarra Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 608.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (995, '5 Ingluna Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 807.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (996, '15 Vanderbilt Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 680.0, NULL, 9, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (997, '76 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1397.0, NULL, 5, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (998, '3 Demigre Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 702.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (999, '21 Yvonne Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1000, '43 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 617.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1001, '22/75 Levington Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 152.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1002, '28 Maroo Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 672.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1003, '35 Malbon Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 759.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1004, '25/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 160.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1005, '56 Timaru Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 325.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1006, '1 Cressbrook Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 919.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1007, '13/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 133.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1008, '6 Skyline Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 605.0, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1009, '11 Kurru Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 867.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1010, '12 Burns Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 758.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1011, '7 Bowers Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 491.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1012, '47/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1013, '63/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1014, '1 Maisie Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 750.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1015, '74/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 268.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1016, '8/36 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1017, '18 Gwandalan Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 687.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1018, '54 Regent Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 853.0, NULL, 4, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1019, '26 Boorala Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 737.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1020, '15 Boorala Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 622.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1021, '18 Maisie Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 644.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1022, '17/228 Gaskell St, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1023, '33 Chanel Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 682.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1024, '25/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 246.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1025, '1012/8 Win Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1026, '33/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1027, '42 Ellendale Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 500.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1028, '22/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1029, '29 London Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1030, '76/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1031, '15/146 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1032, '6 Femme Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 634.0, NULL, 4, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1033, '40 Cressbrook Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 793.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1034, '50/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 150.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1035, '11/100 Bordeaux Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1036, '62 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 629.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1037, '25/37 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1038, '18 Satch Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1106.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1039, '17 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1040, '62 Timaru Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1041, '59 Oakleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 620.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1042, '1 Demigre Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 701.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1043, '77 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 1.21, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1044, '33 Apple Blossom Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 636.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1045, '7/248 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 177.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1046, '26 Alan Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 480.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1047, '19 Ellendale Circuit, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 528.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1048, '18 Brooklands Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 638.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1049, '36 Dromos Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 624.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1050, '4/142 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 156.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1051, '132/54 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1052, '17/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1053, '64/15 Violet Close, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1054, '43/26 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 202.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1055, '8/42 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', 77.0, NULL, 1, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1056, '45/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1057, '14/146 Padstow Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 175.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1058, '15/42 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', 88.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1059, '1 Satch Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 650.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1060, '42/37 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 135.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1061, '5 Brooklands Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 800.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1062, '7 Heathfield Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 701.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1063, '29/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1064, 'Brand New/577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1065, '4 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1066, '40/407 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1067, '22 Coneybeer Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1068, '21/40 Arcadia Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1069, '4 Dominion Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 675.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1070, '39/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1071, '8 Savanna Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 479.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1072, '6 Petunia Court, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 971.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1073, '51/228 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1074, '66 Liverpool Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 458.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1075, '27 Arkose Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 619.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1076, '31/30 Lindeman Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 350.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1077, '7/45 Gaskell Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 228.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1078, '14 Boorala Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 758.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1079, '52 Apple Blossom Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 697.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1080, '3 Sunshine Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1081, '53/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1082, '14 Chester Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 425.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1083, '114 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 651.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1084, '29/75 LEVINGTON ROAD, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1085, '84 Holmead Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 430.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1086, '11 LINDEMAN PLACE, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 760.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1087, '20/7 Delonix Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 153.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1088, '12 Goorari Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1089, '35/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1090, '5 Bowers Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 522.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1091, '50/25 Buckingham Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1092, '88 Alan Crescent, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 543.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1093, '3 Slobodian Avenue, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 696.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1094, '8 Chancery Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 577.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1095, '14 Regal Place, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1096, '46 Bolinda Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 635.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1097, '18 Mapleleaf Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 620.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1098, '12/28 Holmead Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'other', 335.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1099, '6 Heathfield Street, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 625.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1100, '11/88 Bleasby Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1101, '29/2311 Logan Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'house', 138.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1102, '35/577 Warrigal Road, EIGHT MILE PLAINS', 'Eight Mile Plains', 'unit', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1103, '60 Riverview Terrace, HAMILTON', 'HAMILTON', 'house', 1026.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1104, '28 Pine Street, HAMILTON', 'HAMILTON', 'vacant_land', 587.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1105, '21109/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1106, '11511/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1107, '2 Mikado Street, HAMILTON', 'HAMILTON', 'house', 678.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1108, '3/175 Allen Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1109, '8/55 Hillside Crescent, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1110, '50310/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', 60.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1111, '72/8 Hunt Street, HAMILTON', 'HAMILTON', 'unit', 102.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1112, '11407/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 98.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1113, '5/161 Allen Street, HAMILTON', 'HAMILTON', 'unit', 128.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1114, '16/256 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1115, '1097/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1116, '10/24-26 Rossiter Parade, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1117, '11501/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1118, '14/654-664 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1119, '41 Dickson Terrace, HAMILTON', 'HAMILTON', 'house', 401.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1120, '6/45 Parkside Circuit, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1121, '21204/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 47.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1122, '30203/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', 105.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1123, '20810/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1124, '50705/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1125, '10307/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 50.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1126, '1603/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 75.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1127, '10814/320 MacArthur Ave, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1128, '1083/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1129, '1024/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1130, '10409/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 74.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1131, '315/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1132, '18 Lynell Street, HAMILTON', 'HAMILTON', 'house', 585.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1133, '31104/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1134, '10/72 Markwell Street, HAMILTON', 'HAMILTON', 'unit', 48.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1135, '2106/118 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', 137.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1136, '10/54 Jackson Street, HAMILTON', 'HAMILTON', 'house', 113.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1137, '20706/320 MacArthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1138, '99 Jackson Street, HAMILTON', 'HAMILTON', 'house', 261.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1139, '49 Toorak Road, HAMILTON', 'HAMILTON', 'vacant_land', 607.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1140, '2 Kitchener Road, HAMILTON', 'HAMILTON', 'house', 61.0, NULL, 6, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1141, '16 Atkinson Street, HAMILTON', 'HAMILTON', 'house', 810.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1142, '10705/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1143, '1/65 Kent Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1144, '8/110 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1145, '6/59 College Street, HAMILTON', 'HAMILTON', 'unit', 118.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1146, '7/41 Rossiter Parade, HAMILTON', 'HAMILTON', 'unit', 179.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1147, '20905/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', 71.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1148, '30902/2 HARBOUR Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1149, '68a Winchester Street, HAMILTON', 'HAMILTON', 'house', 269.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1150, '1052/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1151, '3097/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1152, '3506/126 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1153, '67 Anthony Street, HAMILTON', 'HAMILTON', 'house', 610.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1154, '4096/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1155, '11 Goldsworthy Avenue, HAMILTON', 'HAMILTON', 'house', 508.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1156, 'Level 6/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1157, '1/33 Kent Street, HAMILTON', 'HAMILTON', 'unit', 809.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1158, '31 Kent Street, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 7, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1159, '30509/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1160, '3128/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1161, '1085/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1162, '833/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1163, '4/666 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1164, '308/51 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1165, '3102/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1166, '1094/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1167, '3104/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1168, '17 Dickson Terrace, HAMILTON', 'HAMILTON', 'house', 582.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1169, '5201/331 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1170, '50 Jackson Street, HAMILTON', 'HAMILTON', 'house', 387.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1171, '4026/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1172, '4/53 Winchester Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1173, '20305/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1174, '710/35 HERCULES STREET, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1175, '7/9 Windsor Street, HAMILTON', 'HAMILTON', 'house', 147.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1176, '4093/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', 68.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1177, '9302/50 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', 113.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1178, '1/21 Arran Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1179, '10313/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 65.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1180, '1092/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1181, '3103/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1182, '1073/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1183, '3124/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1184, '30604/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 51.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1185, '1061/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1186, '3095/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1187, '852/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 82.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1188, '4143/37c Harbour Road, HAMILTON', 'HAMILTON', 'unit', 116.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1189, '4210/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1190, '5/75 Allen Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1191, '840/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1192, '30903/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1193, '7/44 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1194, '809/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1195, '809/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1196, '812/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1197, '21008/320 MacArthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1198, '4208/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1199, '30403/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1200, '304/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1201, '1071/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1202, '1084/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1203, '6/92 Nudgee Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1204, '553/15 Finnegan Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1205, '3083/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1206, '1044/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1207, '30709/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 65.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1208, '5 Ludlow Street, HAMILTON', 'HAMILTON', 'house', 913.0, NULL, 5, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1209, '16 York Street, HAMILTON', 'HAMILTON', 'house', 521.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1210, '13 Quarry Street, HAMILTON', 'HAMILTON', 'house', 520.0, NULL, 5, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1211, '30202/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1212, '21511/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1213, '1316/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1214, '42 Langside Road, HAMILTON', 'HAMILTON', 'house', 744.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1215, '27 Sparkes Avenue, HAMILTON', 'HAMILTON', 'house', 810.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1216, '97 Jackson Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1217, '1/167 Allen Street, HAMILTON', 'HAMILTON', 'house', 144.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1218, '20811/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', 91.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1219, '308/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1220, '2/63 Jackson Street, HAMILTON', 'HAMILTON', 'unit', 95.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1221, '21709/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1222, '10703/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1223, '3108/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1224, '1076/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1225, '56 Windermere Road, HAMILTON', 'HAMILTON', 'house', 2039.0, NULL, 5, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1226, '11 Dickson Terrace, HAMILTON', 'HAMILTON', 'vacant_land', 759.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1227, '1408/118 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1228, '50 Oxford Street, HAMILTON', 'HAMILTON', 'house', 633.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1229, '48 Royal Terrace, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1230, '3306/126 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1231, '8/28 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1232, '11705/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1233, '30408/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1234, '56 Hillside Crescent, HAMILTON', 'HAMILTON', 'house', 754.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1235, '934/47 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 64.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1236, '20606/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', 150.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1237, '1074/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1238, '1096/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1239, '5/10 Hilda Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1240, '15/66 Allen Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1241, '3106/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1242, '1067/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1243, '301/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1244, '11 Killara Avenue, HAMILTON', 'HAMILTON', 'house', 549.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1245, '4062/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1246, '4/110 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1247, '131 Crosby Rd, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1248, '8/654 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', 125.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1249, 'Level 17/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 57.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1250, '4/125 Allen Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1251, '50609/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1252, '3062/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1253, '10509/320 MacArthur Ave, HAMILTON', 'HAMILTON', 'unit', 61.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1254, '1072/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1255, '1075/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1256, '3084/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1257, '3092/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1258, '30809/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1259, '4171/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1260, '6/33 Kent Street, HAMILTON', 'HAMILTON', 'unit', 119.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1261, '20701/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1262, '47 Hipwood Road, HAMILTON', 'HAMILTON', 'house', 809.0, NULL, 4, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1263, '10305/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1264, '25 Hillside Crescent, HAMILTON', 'HAMILTON', 'house', 418.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1265, '896/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1266, '6/12 Riverview Terrace, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1267, '12104/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1268, '3/60 Allen Street (Seymour road entry), HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1269, '2/75 Allen Street, HAMILTON', 'HAMILTON', 'unit', 127.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1270, '7/12 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1271, '30103/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1272, '302/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1273, '3048/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1274, '30608/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1275, '1051/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1276, '3045/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1277, '1031/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1278, '1065/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1279, '31304/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1280, '10410/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 64.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1281, '31404/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1282, '11308/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1283, '4087/37c Harbour Road, HAMILTON', 'HAMILTON', 'unit', 64.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1284, '10105/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1285, '825/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1286, '11907/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1287, '869/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1288, '4510/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1289, '3/33 Parkside Circuit, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1290, '21602/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1291, '10504/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', 160.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1292, '2/102 Parkside Circuit, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1293, '4107/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1294, '10403/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1295, '30104/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1296, '3/28 Kent Street, HAMILTON', 'HAMILTON', 'unit', 126.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1297, '1021/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1298, '1053/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1299, '3037/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1300, '3056/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1301, 'Type AMR/33 Remora Rd Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1302, '123 Crescent Road, HAMILTON', 'HAMILTON', 'house', 607.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1303, '20511/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1304, '123/37 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1305, '2/7 Toorak Road, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1306, '4204/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', 66.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1307, '545/15 Finnegan Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1308, '2/44 Jackson Street, HAMILTON', 'HAMILTON', 'unit', 114.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1309, '10916/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1310, '4091/37C Harbour Road, HAMILTON', 'HAMILTON', 'house', 74.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1311, '1/38 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', 1647.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1312, '42 Jackson Street, HAMILTON', 'HAMILTON', 'house', 387.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1313, '31404/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 49.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1314, '1101/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1315, '1111/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1316, '21001/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1317, '78A Allen Street, HAMILTON', 'HAMILTON', 'house', 142.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1318, 'L13/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 53.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1319, '1/8 Hunt Street, HAMILTON', 'HAMILTON', 'unit', 82.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1320, '604/8 Hunt Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1321, '4313/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1322, '815/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1323, '5206/331 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1324, '20801/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1325, '4312/18 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1326, '4130/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1327, '4084/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1328, '11409/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1329, '1091/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1330, '3053/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1331, '3078/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1332, '3076/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1333, '37 Cooksley Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1334, '27/8 Hunt Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1335, 'LGC/11 Hillside Crescent, HAMILTON', 'HAMILTON', 'unit', 179.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1336, '3045/37 Finnegan Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1337, '8 Dickson Terrace, HAMILTON', 'HAMILTON', 'vacant_land', 810.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1338, '14 Sparkes Avenue, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1339, '21507/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 56.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1340, '11/191 Allen Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1341, '5/17 Whyenbah Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1342, '10607/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1343, '6 Hants Street, HAMILTON', 'HAMILTON', 'other', 157.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1344, '10305/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1345, '3113/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1346, '803/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 75.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1347, '3121/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1348, '3125/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1349, '3116/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1350, '3126/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1351, '10301/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1352, '11408/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 84.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1353, '20807/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 56.0, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1354, '10/31 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1355, '20802/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', 89.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1356, '11A Dickson Terrace, HAMILTON', 'HAMILTON', 'house', 759.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1357, 'Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1358, '8/66 Allen Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1359, '612/12-18 Parkside Circuit, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1360, '18 Kent Street, HAMILTON', 'HAMILTON', 'house', 607.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1361, '4136/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1362, '11003/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1363, '12/54 Jackson Street, HAMILTON', 'HAMILTON', 'house', 115.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1364, '1121/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1365, '29A Ludlow Street, HAMILTON', 'HAMILTON', 'house', 635.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1366, '12 Windsor Street, HAMILTON', 'HAMILTON', 'house', 607.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1367, '832/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1368, '3107/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1369, '21207/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', 91.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1370, '1124/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1371, '561/15 Finnegan Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1372, '1 Goldsworthy Avenue, HAMILTON', 'HAMILTON', 'house', 496.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1373, '2408/118 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', 90.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1374, '42 Balowrie Street, HAMILTON', 'HAMILTON', 'house', 456.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1375, '1212/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1376, '11/54 Jackson Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1377, '5/14 Hilda Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1378, '92 Jackson Street, HAMILTON', 'HAMILTON', 'house', 332.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1379, '1002/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1380, '602/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1381, '5/92 Nudgee Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1382, '21106/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1383, '21203/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1384, '2/27 Harbour Road, HAMILTON', 'HAMILTON', 'other', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1385, 'TYPE H/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1386, '3087/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1387, '1011/35 Hercules Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1388, '20403/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', 75.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1389, '817/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 120.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1390, '100 Nudgee Road, HAMILTON', 'HAMILTON', 'house', 433.0, NULL, 3, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1391, '28 Hilda Street, HAMILTON', 'HAMILTON', 'unit', 683.0, NULL, 8, 6, 12);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1392, '101 Crescent Road, HAMILTON', 'HAMILTON', 'house', 607.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1393, '49 Oxford Street, HAMILTON', 'HAMILTON', 'house', 206.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1394, '2301/118 Parkside Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1395, '10707/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1396, '11208/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1397, '30402/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', 194.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1398, '1302/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1399, '806/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 116.0, NULL, 1, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1400, '1/110 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1401, '2/110 Kingsford Smith Drive, HAMILTON', 'HAMILTON', 'unit', 78.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1402, '38a Hants Street, HAMILTON', 'HAMILTON', 'house', 131.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1403, '41 Kent Street, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1404, '9/28 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1405, '1206/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1406, '1022/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1407, '5508/331 MacArthur Ave, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1408, '31702/15 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 5, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1409, '28 Royal Terrace, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1410, '10206/8 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 90.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1411, '521/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1412, '11/341 Macarthur Avenue, HAMILTON', 'HAMILTON', 'house', 354.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1413, '20303/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1414, '309/51 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 199.0, NULL, 3, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1415, '21308/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', 58.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1416, '412/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1417, '11 Whyenbah Street, HAMILTON', 'HAMILTON', 'house', 280.0, NULL, 4, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1418, '5113/331 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1419, '4 Langside Road, HAMILTON', 'HAMILTON', 'house', 575.0, NULL, 4, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1420, '44 Royal Terrace, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1421, '3096/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1422, '1023/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1423, '147/37 Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1424, '20 Pine Street, HAMILTON', 'HAMILTON', 'house', 587.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1425, '20608/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1426, '10509/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', 61.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1427, '3108/126 PARKSIDE Circuit, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1428, '135 Allen Street, HAMILTON', 'HAMILTON', 'house', 405.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1429, '5/28 Riverview Terrace, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1430, '98 Windermere Road, HAMILTON', 'HAMILTON', 'house', 913.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1431, '5/35 Jackson Street, HAMILTON', 'HAMILTON', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1432, '31508/2 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 69.0, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1433, '21801/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1434, '3067/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1435, '21210/37D Harbour Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1436, '305/37B Harbour Road, HAMILTON', 'HAMILTON', 'unit', 119.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1437, '1025/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1438, '3117/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1439, '3114/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1440, '1093/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1441, '4142/37C Harbour Road, HAMILTON', 'HAMILTON', 'unit', 123.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1442, '47 Riverview Terrace, HAMILTON', 'HAMILTON', 'house', 873.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1443, '38A Grays Road, HAMILTON', 'HAMILTON', 'house', 315.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1444, '129/37 Harbour Road, HAMILTON', 'HAMILTON', 'unit', 259.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1445, '10602/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', 101.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1446, '3/75 Allen Street, HAMILTON', 'HAMILTON', 'unit', 106.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1447, '102 Nudgee Road, HAMILTON', 'HAMILTON', 'house', 433.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1448, '20310/7 Wharf Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1449, '609/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1450, '10816/320 Macarthur Avenue, HAMILTON', 'HAMILTON', 'unit', 68.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1451, '21201/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1452, '1102/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1453, '3/58 College Street, HAMILTON', 'HAMILTON', 'house', 109.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1454, '411/35 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1455, '1087/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1456, '1/53 Nudgee Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1457, '20702/8 Hercules Street, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 1, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1458, '844/43 Hercules Street, HAMILTON', 'HAMILTON', 'unit', 109.0, NULL, 2, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1459, '1077/33 Remora Road, HAMILTON', 'HAMILTON', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1460, '33 Dirkala Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1461, '80 Mingera Street, MANSFIELD', 'Mansfield', 'house', 650.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1462, '12 Vaucluse Place, MANSFIELD', 'Mansfield', 'house', 478.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1463, '5 Honeysuckle Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1464, '52 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1465, '23 Lewana Street, MANSFIELD', 'Mansfield', 'house', 572.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1466, '1/3 Honeysuckle Street, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1467, '94 Mingera Street, MANSFIELD', 'Mansfield', 'house', 551.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1468, '77 Valentia Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1469, '9 Trochus Street, MANSFIELD', 'Mansfield', 'house', 647.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1470, '49 Koumala Street, MANSFIELD', 'Mansfield', 'house', 554.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1471, '37 Morialta Street, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1472, '20 Mirang Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1473, '45 Morialta Street, MANSFIELD', 'Mansfield', 'house', 650.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1474, '20 Lilyvale Street, MANSFIELD', 'Mansfield', 'house', 567.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1475, '42 Eastwood Drive, MANSFIELD', 'Mansfield', 'house', 662.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1476, '35 Lewana Street, MANSFIELD', 'Mansfield', 'house', 574.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1477, '7 Cornflower Street, MANSFIELD', 'Mansfield', 'house', 650.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1478, '27 Kiparra Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1479, '14 Trident Street, MANSFIELD', 'Mansfield', 'house', 567.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1480, '35 Honeysuckle Street, MANSFIELD', 'Mansfield', 'house', 567.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1481, '6A Culzean Street, MANSFIELD', 'Mansfield', 'house', 1001.0, NULL, 6, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1482, '8 Lachine Place, MANSFIELD', 'Mansfield', 'house', 462.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1483, '1 Chiniala Street, MANSFIELD', 'Mansfield', 'house', 539.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1484, '30/189 Wecker Road, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1485, '9 Salandra Street, MANSFIELD', 'Mansfield', 'house', 524.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1486, '26 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1487, '4 Dorval Close, MANSFIELD', 'Mansfield', 'house', 454.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1488, '11 Picardie Close, MANSFIELD', 'Mansfield', 'house', 720.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1489, '23 Bluebell Street, MANSFIELD', 'Mansfield', 'house', 594.0, NULL, 5, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1490, '28 Buttercup Street, MANSFIELD', 'Mansfield', 'house', 571.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1491, '385 Pine Mountain Road, MANSFIELD', 'Mansfield', 'house', 631.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1492, '57 Morialta Street, MANSFIELD', 'Mansfield', 'house', 564.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1493, '45 Blackberry Street, MANSFIELD', 'Mansfield', 'house', 619.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1494, '4 Redleaf Street, MANSFIELD', 'Mansfield', 'house', 557.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1495, '106 Ham Road, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1496, '34 Eastwood Drive, MANSFIELD', 'Mansfield', 'house', 916.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1497, '52 Aminya Street, MANSFIELD', 'Mansfield', 'house', 521.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1498, '28 Lilyvale Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1499, '31 Morialta Street, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1500, '9 Leru Street, MANSFIELD', 'Mansfield', 'house', 595.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1501, '15 Silex Street, MANSFIELD', 'Mansfield', 'house', 564.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1502, '24 Lewana Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1503, '5 Lachine Place, MANSFIELD', 'Mansfield', 'house', 456.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1504, '505 Creek Road, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1505, '99 Greenmeadow Road, MANSFIELD', 'Mansfield', 'house', 635.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1506, '27 Lewana Street, MANSFIELD', 'Mansfield', 'house', 572.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1507, '1/51 Mingera Street, MANSFIELD', 'Mansfield', 'house', 187.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1508, '35 Colington Street, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1509, '221 Wecker Road, MANSFIELD', 'Mansfield', 'house', 579.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1510, '1 Firthshire Street, MANSFIELD', 'Mansfield', 'house', 726.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1511, '20 Kiparra Street, MANSFIELD', 'Mansfield', 'house', 544.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1512, '27 Bridle Street, MANSFIELD', 'Mansfield', 'house', 641.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1513, '211 Wecker Road, MANSFIELD', 'Mansfield', 'house', 606.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1514, '34 Novello Street, MANSFIELD', 'Mansfield', 'house', 574.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1515, '4 Marianna Street, MANSFIELD', 'Mansfield', 'house', 603.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1516, '65 Wecker Road, MANSFIELD', 'Mansfield', 'house', 531.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1517, '161 Ham Road, MANSFIELD', 'Mansfield', 'house', 857.0, NULL, 4, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1518, '399 Pine Mountain Road, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1519, '28 Danina Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1520, '2/188 Broadwater Road, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1521, '18 Olivella Street, MANSFIELD', 'Mansfield', 'house', 653.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1522, '38 Lorinya Street, MANSFIELD', 'Mansfield', 'house', 536.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1523, '53/189 Wecker Rd, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1524, '10 Buttercup Street, MANSFIELD', 'Mansfield', 'house', 626.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1525, '63 Valentia Street, MANSFIELD', 'Mansfield', 'house', 602.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1526, '8 Picardie Close, MANSFIELD', 'Mansfield', 'house', 620.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1527, '65 Greenmeadow Road, MANSFIELD', 'Mansfield', 'house', 620.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1528, '8 Danina Street, MANSFIELD', 'Mansfield', 'house', 665.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1529, '373 Pine Mountain Road, MANSFIELD', 'Mansfield', 'house', 592.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1530, '5 Brownleaf Street, MANSFIELD', 'Mansfield', 'house', 703.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1531, '32 Bridle Street, MANSFIELD', 'Mansfield', 'house', 558.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1532, '7 Brigadoon Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1533, '41 Blackberry Street, MANSFIELD', 'Mansfield', 'house', 613.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1534, '10 Novello Street, MANSFIELD', 'Mansfield', 'house', 574.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1535, '37 Brochet Street, MANSFIELD', 'Mansfield', 'house', 645.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1536, '3 Brechin Street, MANSFIELD', 'Mansfield', 'house', 640.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1537, '21 Koumala Street, MANSFIELD', 'Mansfield', 'house', 650.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1538, '1 Picardie Close, MANSFIELD', 'Mansfield', 'house', 610.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1539, '139 Morialta Street, MANSFIELD', 'Mansfield', 'house', 415.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1540, '2/2 Honeysuckle Street, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1541, '6 Buttercup Street, MANSFIELD', 'Mansfield', 'house', 686.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1542, '3 Morialta Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1543, '8 Liatoki Street, MANSFIELD', 'Mansfield', 'house', 617.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1544, '84 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1545, '145 Wecker Road, MANSFIELD', 'Mansfield', 'house', 630.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1546, '7 Mourilyan Street, MANSFIELD', 'Mansfield', 'house', 574.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1547, '95 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1548, '14 Amoria Street, MANSFIELD', 'Mansfield', 'house', 630.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1549, '6 Parari Street, MANSFIELD', 'Mansfield', 'house', 678.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1550, '30 Bentley Court, MANSFIELD', 'Mansfield', 'house', 470.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1551, '117 Greenmeadow Road, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1552, '84 Mingera Street, MANSFIELD', 'Mansfield', 'house', 637.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1553, '81 Ham Road, MANSFIELD', 'Mansfield', 'house', 840.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1554, '59 Mingera Street, MANSFIELD', 'Mansfield', 'house', 622.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1555, '225 Broadwater Road, MANSFIELD', 'Mansfield', 'house', 678.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1556, '14 Bluebell Street, MANSFIELD', 'Mansfield', 'house', 645.0, NULL, 4, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1557, '22 Cresthaven Drive, MANSFIELD', 'Mansfield', 'house', 650.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1558, '23 Firthshire Street, MANSFIELD', 'Mansfield', 'house', 577.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1559, '47 Koumala Street, MANSFIELD', 'Mansfield', 'house', 688.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1560, '12 Liamena Street, MANSFIELD', 'Mansfield', 'house', 486.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1561, '18 Amoria Street, MANSFIELD', 'Mansfield', 'house', 630.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1562, '38 Tandanya Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1563, '49 Eastwood Drive, MANSFIELD', 'Mansfield', 'house', 469.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1564, '65 Blackberry Street, MANSFIELD', 'Mansfield', 'house', 610.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1565, '6 Redleaf Street, MANSFIELD', 'Mansfield', 'house', 557.0, NULL, 7, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1566, '13/189 Wecker Road, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1567, '22 Greenmeadow Road, MANSFIELD', 'Mansfield', 'house', 698.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1568, '3 Gretna Street, MANSFIELD', 'Mansfield', 'house', 655.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1569, '53 Koumala Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1570, '17 Marissa Close, MANSFIELD', 'Mansfield', 'house', 658.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1571, '35 Tandanya Street, MANSFIELD', 'Mansfield', 'house', 612.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1572, '45 Aminya Street, MANSFIELD', 'Mansfield', 'house', 673.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1573, '3/2 Aminya Street, MANSFIELD', 'Mansfield', 'house', 133.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1574, '27 Togar Street, MANSFIELD', 'Mansfield', 'house', 549.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1575, '11 Mirang Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1576, '25 Bluebell Street, MANSFIELD', 'Mansfield', 'house', 711.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1577, '3 Brigadoon Street, MANSFIELD', 'Mansfield', 'house', 304.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1578, '27 Danina Street, MANSFIELD', 'Mansfield', 'house', 554.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1579, '14 Jilloong Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1580, '42 Tandanya Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1581, '3 Glen Nevis Street, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1582, '129 Wecker Road, MANSFIELD', 'Mansfield', 'house', 637.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1583, '15 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 683.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1584, '22 Menkira Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1585, '4 Novello Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1586, '4 Pavuvu Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1587, '20 Valentia Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1588, '18 Picardie Close, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1589, '8 Arura Street, MANSFIELD', 'Mansfield', 'house', 615.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1590, '10 Bluebell Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1591, '12/189 Wecker Road, MANSFIELD', 'Mansfield', 'house', 231.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1592, '40 Cresthaven Drive, MANSFIELD', 'Mansfield', 'house', 645.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1593, '22 Trident Street, MANSFIELD', 'Mansfield', 'house', 567.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1594, '7/6 Aminya Street, MANSFIELD', 'Mansfield', 'house', 158.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1595, '103 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1596, '16 Tegula Street, MANSFIELD', 'Mansfield', 'house', 632.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1597, '9 Nubara Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 4, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1598, '2 Handon Street, MANSFIELD', 'Mansfield', 'house', 572.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1599, '7/188 Broadwater Road, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1600, '26 Bridle Street, MANSFIELD', 'Mansfield', 'house', 558.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1601, '13 Novello Street, MANSFIELD', 'Mansfield', 'house', 572.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1602, '25 Kiparra Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1603, '127 Ham Road, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1604, '20 Picardie Close, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1605, '29 Bluebell Street, MANSFIELD', 'Mansfield', 'house', 637.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1606, '10 Bradford Court, MANSFIELD', 'Mansfield', 'house', 618.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1607, '11 Olivella Street, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1608, '46 Morialta Street, MANSFIELD', 'Mansfield', 'house', 536.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1609, '54 Valentia Street, MANSFIELD', 'Mansfield', 'house', 562.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1610, '94 Greenmeadow Road, MANSFIELD', 'Mansfield', 'house', 733.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1611, '51 Arura Street, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1612, '77 Blackberry Street, MANSFIELD', 'Mansfield', 'house', 655.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1613, '163 Wecker Road, MANSFIELD', 'Mansfield', 'house', 584.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1614, '14 Lewana Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1615, '9/8 Greenmeadow Road, MANSFIELD', 'Mansfield', 'unit', 62.0, NULL, 2, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1616, '10 Eastwood Drive, MANSFIELD', 'Mansfield', 'house', 410.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1617, '10 Togar Street, MANSFIELD', 'Mansfield', 'house', 544.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1618, '7 Linfield Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1619, '33 Morialta Street, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1620, '3 Silo Place, MANSFIELD', 'Mansfield', 'house', 785.0, NULL, 4, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1621, '15 Danina Street, MANSFIELD', 'Mansfield', 'house', 572.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1622, '49/189 Wecker Road, MANSFIELD', 'Mansfield', 'house', 214.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1623, '22 Madau Street, MANSFIELD', 'Mansfield', 'house', 538.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1624, '20 Kane Crescent, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1625, '19 Raintree Street, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1626, '1 Tivela Street, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1627, '7 Mirang Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1628, '53 Weedon Street West, MANSFIELD', 'Mansfield', 'other', 6393.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1629, '26 Gretna Street, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1630, '20 Bridle Street, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1631, '4/8 Greenmeadow Road, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1632, '15 Lilyvale Street, MANSFIELD', 'Mansfield', 'house', 617.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1633, '7 Marianna Street, MANSFIELD', 'Mansfield', 'house', 634.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1634, '45 Koumala Street, MANSFIELD', 'Mansfield', 'house', 696.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1635, '2 Sandringham Street, MANSFIELD', 'Mansfield', 'house', 1030.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1636, '11 Nucella Street, MANSFIELD', 'Mansfield', 'vacant_land', 333.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1637, '10 Brochet Street, MANSFIELD', 'Mansfield', 'house', 704.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1638, '11 Carbora Street, MANSFIELD', 'Mansfield', 'house', 600.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1639, '105 Ham Road, MANSFIELD', 'Mansfield', 'house', 589.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1640, '10 Banika Street, MANSFIELD', 'Mansfield', 'house', 551.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1641, '20 Moeller Place, MANSFIELD', 'Mansfield', 'house', 452.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1642, '1/8 Greenmeadow Road, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1643, '28 Chiniala Street, MANSFIELD', 'Mansfield', 'house', 792.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1644, '5 Salandra Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1645, '21 Cresthaven Drive, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1646, '5/8 Greenmeadow Road, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1647, '6/8 Greenmeadow Road, MANSFIELD', 'Mansfield', 'unit', NULL, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1648, '78 Mingera Street, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1649, '11 Koumala Street, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1650, '11 Casmaria Street, MANSFIELD', 'Mansfield', 'house', 577.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1651, '72 Valentia Street, MANSFIELD', 'Mansfield', 'house', 564.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1652, '46 Dirkala Street, MANSFIELD', 'Mansfield', 'house', 516.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1653, '24 Condong Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1654, '30 Tandanya Street, MANSFIELD', 'Mansfield', 'house', 612.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1655, '16 Vaucluse Place, MANSFIELD', 'Mansfield', 'house', 687.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1656, '17 Biplex Street, MANSFIELD', 'Mansfield', 'house', 632.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1657, '19 Nubara Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1658, '42 Arura Street, MANSFIELD', 'Mansfield', 'house', 665.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1659, '27 Condong Street, MANSFIELD', 'Mansfield', 'house', 544.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1660, '5 Redleaf Street, MANSFIELD', 'Mansfield', 'house', 591.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1661, '21 Arura Street, MANSFIELD', 'Mansfield', 'house', 577.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1662, '36/12 Mailey Street, MANSFIELD', 'Mansfield', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1663, '4 Togar Street, MANSFIELD', 'Mansfield', 'house', 544.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1664, '11 Ardennes Close, MANSFIELD', 'Mansfield', 'house', 687.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1665, '3 Pareena Crescent, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1666, '533 Creek Road, MANSFIELD', 'Mansfield', 'house', 556.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1667, '28 Glen Nevis Street, MANSFIELD', 'Mansfield', 'house', 557.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1668, '12 Glen Nevis Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1669, '28 Kenora Street, MANSFIELD', 'Mansfield', 'house', 605.0, NULL, 3, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1670, '33 Glen Nevis Street, MANSFIELD', 'Mansfield', 'house', 614.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1671, '2 Condong Street, MANSFIELD', 'Mansfield', 'house', 690.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1672, '3 Handon Street, MANSFIELD', 'Mansfield', 'house', 536.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1673, '10 Salandra Street, MANSFIELD', 'Mansfield', 'house', 536.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1674, '7 Ardennes Close, MANSFIELD', 'Mansfield', 'house', 604.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1675, '65 Valentia Street, MANSFIELD', 'Mansfield', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1676, '33 Canter Street, MANSFIELD', 'Mansfield', 'house', 656.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1677, '17 Firthshire Street, MANSFIELD', 'Mansfield', 'house', 685.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1678, '16 Cresthaven Drive, MANSFIELD', 'Mansfield', 'house', 582.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1679, '105 Morialta Street, MANSFIELD', 'Mansfield', 'house', 546.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1680, '10 Trident Street, MANSFIELD', 'Mansfield', 'house', 721.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1681, '1 Banika Street, MANSFIELD', 'Mansfield', 'house', 606.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1682, '30 Condong Street, MANSFIELD', 'Mansfield', 'house', 541.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1683, '17/12 Mailey Street, MANSFIELD', 'Mansfield', 'house', 156.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1684, '123 Morialta Street, MANSFIELD', 'Mansfield', 'house', 589.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1685, '28 Valentia Street, MANSFIELD', 'Mansfield', 'house', 534.0, NULL, 4, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1686, '272 Broadwater Road, MANSFIELD', 'Mansfield', 'house', 551.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1687, '38/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1688, '15 Levoh Street, ROCHEDALE', 'Rochedale', 'house', 505.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1689, '11/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1690, '37 Major Drive, ROCHEDALE', 'Rochedale', 'house', 540.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1691, '28 Raptor Street, ROCHEDALE', 'Rochedale', 'house', 486.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1692, '93 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 301.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1693, '67/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 141.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1694, '138 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 590.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1695, '33/21 Harrier Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1696, 'Lot 16/15 Blackwood Street, ROCHEDALE', 'Rochedale', 'vacant_land', 500.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1697, '19 Ross Street, ROCHEDALE', 'Rochedale', 'house', 374.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1698, 'Lot 15/15 Blackwood Street, ROCHEDALE', 'Rochedale', 'vacant_land', 500.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1699, '68 Finch Parade, ROCHEDALE', 'Rochedale', 'house', 256.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1700, '55/89 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1701, '21/21 Harrier Street, ROCHEDALE', 'Rochedale', 'house', 184.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1702, '68/89 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1703, '44/89 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1704, 'Lot 11/15 Blackwood Street, ROCHEDALE', 'Rochedale', 'vacant_land', 500.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1705, '21 Ann Crescent, ROCHEDALE', 'Rochedale', 'house', 409.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1706, '29 Parolin Parade, ROCHEDALE', 'Rochedale', 'house', 461.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1707, '32 Dell Street, ROCHEDALE', 'Rochedale', 'house', 447.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1708, '17 Ross Street, ROCHEDALE', 'Rochedale', 'house', 600.0, NULL, 6, 6, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1709, '42 Viewpoint Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1710, '115 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 320.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1711, '18/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 180.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1712, '10/59 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1713, '2 Obrist Place, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1714, '182 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 192.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1715, '61 Frangipani Street, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1716, '11 Panorama Street, ROCHEDALE', 'Rochedale', 'house', 339.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1717, '16 Panorama Street, ROCHEDALE', 'Rochedale', 'house', 409.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1718, '8 Levoh Street, ROCHEDALE', 'Rochedale', 'house', 390.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1719, '97 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 513.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1720, '100 Mcdermott Parade, ROCHEDALE', 'Rochedale', 'house', 192.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1721, '86 McDermott Parade, ROCHEDALE', 'Rochedale', 'house', 273.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1722, '32 Paragon Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1723, '92 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', 516.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1724, '98/68 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1725, '445 Priestdale Road, ROCHEDALE', 'Rochedale', 'vacant_land', 1.01, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1726, '2 Botanica Street, ROCHEDALE', 'Rochedale', 'house', 471.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1727, '1 Paragon Street, ROCHEDALE', 'Rochedale', 'house', 600.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1728, '20 Ultimo Court, ROCHEDALE', 'Rochedale', 'house', 396.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1729, '16 Elevate Street, ROCHEDALE', 'Rochedale', 'house', 451.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1730, '374 Grieve Road, ROCHEDALE', 'Rochedale', 'house', 3.05, NULL, 6, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1731, '40 Levoh Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1732, '28/21 Lorisch Way, ROCHEDALE', 'Rochedale', 'house', 149.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1733, '25/21 Lorisch Way, ROCHEDALE', 'Rochedale', 'house', 120.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1734, '27/21 Lorisch Way, ROCHEDALE', 'Rochedale', 'house', 120.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1735, '17 Soar Street, ROCHEDALE', 'Rochedale', 'house', 443.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1736, '98 Fisher Street, ROCHEDALE', 'Rochedale', 'house', 425.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1737, '68 Frangipani Street, ROCHEDALE', 'Rochedale', 'house', 534.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1738, '7 English Place, ROCHEDALE', 'Rochedale', 'house', 512.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1739, '71 Kate Circuit, ROCHEDALE', 'Rochedale', 'house', 239.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1740, '18 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 687.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1741, '7 Grange Close, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1742, '73 Kate Circuit, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1743, '45/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1744, '53/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 179.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1745, '6 Leahcim Street, ROCHEDALE', 'Rochedale', 'house', 410.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1746, '12 Perring Crescent, ROCHEDALE', 'Rochedale', 'house', 375.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1747, '50 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 425.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1748, '13 Prestige Street, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1749, '85/68 West Street, ROCHEDALE', 'Rochedale', 'house', 201.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1750, '68 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 371.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1751, '2 Peak Court, ROCHEDALE', 'Rochedale', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1752, '92 Ascent Street, ROCHEDALE', 'Rochedale', 'house', 313.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1753, '48 Viewpoint Street, ROCHEDALE', 'Rochedale', 'house', 391.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1754, '43 Panorama Street, ROCHEDALE', 'Rochedale', 'vacant_land', 425.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1755, '112 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 458.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1756, '6 Premier Street, ROCHEDALE', 'Rochedale', 'vacant_land', 448.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1757, '15 Wombat Crescent, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1758, '26/21 Lorisch Way, ROCHEDALE', 'Rochedale', 'house', 120.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1759, '50 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1760, '54 Peregrine Street, ROCHEDALE', 'Rochedale', 'vacant_land', 416.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1761, '14 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 576.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1762, '6 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 539.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1763, '15 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 504.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1764, '12 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1765, '55 Evergreen Street, ROCHEDALE', 'Rochedale', 'vacant_land', 410.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1766, '112 Fisher Street, ROCHEDALE', 'Rochedale', 'house', 425.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1767, '70 Ford Road, ROCHEDALE', 'Rochedale', 'house', 2000.0, NULL, 5, 4, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1768, '35 Willow Way, ROCHEDALE', 'Rochedale', 'house', 543.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1769, '123 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 471.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1770, '6 Elevate Street, ROCHEDALE', 'Rochedale', 'house', 402.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1771, '46 Parolin Parade, ROCHEDALE', 'Rochedale', 'house', 416.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1772, '38 Dell Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1773, '21 Peregrine Street, ROCHEDALE', 'Rochedale', 'house', 408.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1774, '28 Lux Place, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1775, '11 Plum Place, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1776, '78 Cockatoo Place, ROCHEDALE', 'Rochedale', 'house', 778.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1777, '21/21 Lorisch Way, ROCHEDALE', 'Rochedale', 'house', 118.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1778, '13 Grand Street, ROCHEDALE', 'Rochedale', 'house', 528.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1779, '38 Royal Crescent, ROCHEDALE', 'Rochedale', 'house', 350.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1780, '116 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1781, '14 Wallaby Parade, ROCHEDALE', 'Rochedale', 'house', 323.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1782, '33 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 372.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1783, '49 Grand Street, ROCHEDALE', 'Rochedale', 'house', 450.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1784, '258 Rochedale Road, ROCHEDALE', 'Rochedale', 'other', 2.02, NULL, 5, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1785, '409 Priestdale Road, ROCHEDALE', 'Rochedale', 'vacant_land', 10000.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1786, '36 Harrier Street, ROCHEDALE', 'Rochedale', 'house', 410.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1787, '1 Willow Way, ROCHEDALE', 'Rochedale', 'house', 488.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1788, '5 Perring Crescent, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1789, '3 Jasmine Place, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1790, '29 Viewpoint Street, ROCHEDALE', 'Rochedale', 'house', 473.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1791, '125/68 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1792, '43 Resurge St, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1793, '62 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1794, '4 Blossom Place, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1795, '6 Grand Street, ROCHEDALE', 'Rochedale', 'house', 564.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1796, '22 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 388.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1797, '22 Honeyeater Place, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1798, '66 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 378.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1799, '30 Dell Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1800, '587 Grieve Road, ROCHEDALE', 'Rochedale', 'house', 5447.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1801, '18 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 465.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1802, '61 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1803, '46 Wombat Crescent, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1804, '2 Elevate Street, ROCHEDALE', 'Rochedale', 'house', 455.0, NULL, 5, 5, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1805, '18 Bock Street, ROCHEDALE', 'Rochedale', 'vacant_land', 450.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1806, '5 Penfold Crescent, ROCHEDALE', 'Rochedale', 'house', 429.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1807, '1 Botanica Street, ROCHEDALE', 'Rochedale', 'house', 450.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1808, '161 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 419.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1809, '40 Wombat Crescent, ROCHEDALE', 'Rochedale', 'house', 540.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1810, '17 Raquel Avenue, ROCHEDALE', 'Rochedale', 'house', 463.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1811, '55 Major Drive, ROCHEDALE', 'Rochedale', 'house', 423.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1812, '74 McDermott Parade, ROCHEDALE', 'Rochedale', 'house', 192.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1813, '59 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 374.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1814, '11 Paragon Street, ROCHEDALE', 'Rochedale', 'house', 390.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1815, '7/58 West Street, ROCHEDALE', 'Rochedale', 'house', 342.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1816, '435 Priestdale Road, ROCHEDALE', 'Rochedale', 'vacant_land', 1.01, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1817, '18 Honeyeater Place, ROCHEDALE', 'Rochedale', 'house', 929.0, NULL, 5, 4, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1818, '55 Royal Crescent, ROCHEDALE', 'Rochedale', 'house', 350.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1819, '108 Fisher Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1820, '3 Plateau Place, ROCHEDALE', 'Rochedale', 'house', 495.0, NULL, 6, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1821, '94/68 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1822, '69 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 532.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1823, '26 OBRIST PLACE, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1824, '87 Kate Circuit, ROCHEDALE', 'Rochedale', 'vacant_land', 717.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1825, '22 Zenith Street, ROCHEDALE', 'Rochedale', 'house', 793.0, NULL, 6, 6, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1826, '87 Royal Crescent, ROCHEDALE', 'Rochedale', 'vacant_land', 537.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1827, '48 Aspire Street, ROCHEDALE', 'Rochedale', 'house', 465.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1828, '40 Glenmore Crescent, ROCHEDALE', 'Rochedale', 'other', 1.05, NULL, 8, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1829, '56 Grand Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1830, '103 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 659.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1831, '307 Grieve Road, ROCHEDALE', 'Rochedale', 'house', 1.01, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1832, '23 Kate Circuit, ROCHEDALE', 'Rochedale', 'house', 640.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1833, '123 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 536.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1834, '33/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1835, '18 Amethyst Street, ROCHEDALE', 'Rochedale', 'house', 625.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1836, '74 Cockatoo Place, ROCHEDALE', 'Rochedale', 'house', 714.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1837, '6 Alex Place, ROCHEDALE', 'Rochedale', 'house', 405.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1838, '40 Perring Crescent, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1839, '8/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 150.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1840, '70 McDermott Parade, ROCHEDALE', 'Rochedale', 'other', 280.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1841, '9/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', 169.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1842, '38 Willow Way, ROCHEDALE', 'Rochedale', 'house', 454.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1843, '96 Major Drive, ROCHEDALE', 'Rochedale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1844, '6 Paragon Street, ROCHEDALE', 'Rochedale', 'house', 330.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1845, '62 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 254.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1846, '128 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', 489.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1847, '66 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 356.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1848, '67 Finch Parade, ROCHEDALE', 'Rochedale', 'house', 576.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1849, '21 Wallaby Parade, ROCHEDALE', 'Rochedale', 'house', 824.0, NULL, 5, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1850, '51 Grand Street, ROCHEDALE', 'Rochedale', 'house', 452.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1851, '6 Vanstone Street, ROCHEDALE', 'Rochedale', 'house', 492.0, NULL, 5, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1852, '37 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1853, '75 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 506.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1854, '6 Mcdermott Parade, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1855, '82 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 557.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1856, '8 Wallaby Parade, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1857, '68 Resurge Street, ROCHEDALE', 'Rochedale', 'house', 443.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1858, '12 Soar Street, ROCHEDALE', 'Rochedale', 'house', 426.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1859, '18/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 178.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1860, '1 & 2/21 Hillcrest Street, ROCHEDALE', 'Rochedale', 'other', 617.0, NULL, 6, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1861, '27 Grand Street, ROCHEDALE', 'Rochedale', 'house', 561.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1862, '111 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 576.0, NULL, 5, 4, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1863, '8 Ross Street, ROCHEDALE', 'Rochedale', 'house', 336.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1864, '1, 18 Woodcarver Street, ROCHEDALE', 'Rochedale', 'vacant_land', 426.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1865, '73/55 Francis Ave, ROCHEDALE', 'Rochedale', 'house', 171.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1866, '27 Soar Street, ROCHEDALE', 'Rochedale', 'house', 433.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1867, '7 Lillium Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1868, '7 Fisher Street, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1869, '19 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 341.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1870, '2 Premier Street, ROCHEDALE', 'Rochedale', 'vacant_land', 471.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1871, '23 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1872, '26 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 577.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1873, '5 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 308.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1874, '82 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1875, '51 /55 Francis Ave, ROCHEDALE', 'Rochedale', 'house', 179.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1876, '18 Daniel Drive, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1877, '48 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 485.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1878, '59 Ascent Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1879, '54 Obrist Place, ROCHEDALE', 'Rochedale', 'house', 478.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1880, '60 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'other', 209.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1881, '74 Finch Parade, ROCHEDALE', 'Rochedale', 'house', 206.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1882, '737 Grieve Road, ROCHEDALE', 'Rochedale', 'house', 2000.0, NULL, 6, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1883, '3 Perring Crescent, ROCHEDALE', 'Rochedale', 'house', 522.0, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1884, '56 /55 Francis Ave, ROCHEDALE', 'Rochedale', 'house', 176.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1885, '39 Finch Parade, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1886, '3 Dell Street, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1887, '89 Royal Crescent, ROCHEDALE', 'Rochedale', 'vacant_land', 400.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1888, '40 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 352.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1889, '49 Finch Parade, ROCHEDALE', 'Rochedale', 'house', 218.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1890, '77a Kate Circuit, ROCHEDALE', 'Rochedale', 'house', 193.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1891, '39 Cockatoo Place, ROCHEDALE', 'Rochedale', 'house', 300.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1892, '62 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 213.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1893, '30 Gardner Road, ROCHEDALE', 'Rochedale', 'house', 1.01, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1894, '15 Kestrel Street, ROCHEDALE', 'Rochedale', 'house', 522.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1895, '21 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1896, '79 Kate Circuit, ROCHEDALE', 'Rochedale', 'house', 193.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1897, '6 Willow Way, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 7, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1898, '25 Kestrel Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1899, '41/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1900, '46/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', 176.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1901, '68 Royal Crescent, ROCHEDALE', 'Rochedale', 'house', 350.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1902, '21 Lillium Street, ROCHEDALE', 'Rochedale', 'house', 342.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1903, '63 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 359.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1904, '60 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 444.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1905, '95 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 530.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1906, '27 Abloom Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1907, '98 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 391.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1908, '90 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 446.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1909, '60/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 159.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1910, '6 Peridot Place, ROCHEDALE', 'Rochedale', 'house', 483.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1911, '16 Penfold Crescent, ROCHEDALE', 'Rochedale', 'house', 514.0, NULL, 5, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1912, '36 Rosemary Circuit, ROCHEDALE', 'Rochedale', 'house', 441.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1913, '55 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 491.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1914, '106 Fisher Street, ROCHEDALE', 'Rochedale', 'house', 364.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1915, '80/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 171.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1916, '37 Daniel Drive, ROCHEDALE', 'Rochedale', 'house', 321.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1917, '41 Brilliant Place, ROCHEDALE', 'Rochedale', 'house', 519.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1918, '36/21 Harrier Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1919, '139 Splendour Street, ROCHEDALE', 'Rochedale', 'vacant_land', 528.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1920, '41/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1921, '28 Zenith Street, ROCHEDALE', 'Rochedale', 'house', 362.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1922, '55 McDermott Parade, ROCHEDALE', 'Rochedale', 'house', 710.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1923, '17 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 700.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1924, '1 Splendour Street, ROCHEDALE', 'Rochedale', 'vacant_land', 820.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1925, '11 Dell Street, ROCHEDALE', 'Rochedale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1926, '12 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 788.0, NULL, 6, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1927, '17 Wallaby Parade, ROCHEDALE', 'Rochedale', 'house', 339.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1928, '130 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 290.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1929, '28 Parolin Parade, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1930, '480 Grieve Road, ROCHEDALE', 'Rochedale', 'other', 1.97, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1931, '4/5 Palara Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1932, '36 Ford Road, ROCHEDALE', 'Rochedale', 'house', 1000.0, NULL, 4, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1933, '128 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 340.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1934, '94 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 552.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1935, '42 Aspire Street, ROCHEDALE', 'Rochedale', 'house', 524.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1936, '34 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 310.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1937, '37 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 372.0, NULL, 5, 4, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1938, '20/81 Major Drive, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1939, '39 Goshawk Cres, ROCHEDALE', 'Rochedale', 'house', 414.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1940, '47 Ascent Street, ROCHEDALE', 'Rochedale', 'house', 313.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1941, '11 Oscar Drive, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1942, '15 Leahcim Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1943, '17 Lillium Street, ROCHEDALE', 'Rochedale', 'house', 479.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1944, '106 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1945, '2 Paragon Street, ROCHEDALE', 'Rochedale', 'other', 604.0, NULL, 8, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1946, '38 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 409.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1947, '20 Aspire Street, ROCHEDALE', 'Rochedale', 'house', 384.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1948, '79/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 154.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1949, '9 Leahcim Street, ROCHEDALE', 'Rochedale', 'house', 2401.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1950, '61 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 197.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1951, '92 Mcdermott Parade, ROCHEDALE', 'Rochedale', 'house', 306.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1952, '74/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1953, '14 Goshawk Crescent, ROCHEDALE', 'Rochedale', 'house', 379.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1954, '37/21 Harrier Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1955, '62 Ascent St, ROCHEDALE', 'Rochedale', 'house', 316.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1956, '7 Evergreen Street, ROCHEDALE', 'Rochedale', 'house', 454.0, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1957, '58 Obrist Place, ROCHEDALE', 'Rochedale', 'house', 478.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1958, '626 Underwood Road, ROCHEDALE', 'Rochedale', 'other', 1.07, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1959, '43/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1960, '11/10 Zircon Close, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1961, '23 Evergreen Street, ROCHEDALE', 'Rochedale', 'house', 293.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1962, '17 Wombat Crescent, ROCHEDALE', 'Rochedale', 'house', 496.0, NULL, 7, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1963, '5/59 West Street, ROCHEDALE', 'Rochedale', 'house', 186.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1964, '46 Panorama Street, ROCHEDALE', 'Rochedale', 'house', 318.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1965, '30 Rosemary Circuit, ROCHEDALE', 'Rochedale', 'house', 441.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1966, '65 Kate Circuit, ROCHEDALE', 'Rochedale', 'house', 193.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1967, '6 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 592.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1968, '43 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 587.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1969, '5 Goodtown Street, ROCHEDALE', 'Rochedale', 'house', 1974.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1970, '9 Daniel Drive, ROCHEDALE', 'Rochedale', 'house', 411.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1971, '11 Wallaby Parade, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1972, '47 Royal Crescent, ROCHEDALE', 'Rochedale', 'house', 425.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1973, '6 Frangipani Street, ROCHEDALE', 'Rochedale', 'house', 570.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1974, '38 Raquel Avenue, ROCHEDALE', 'Rochedale', 'house', 376.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1975, '33 Rosemary Circuit, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1976, '41 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 441.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1977, '32 Aspire Street, ROCHEDALE', 'Rochedale', 'house', 668.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1978, '60 Altitude Street, ROCHEDALE', 'Rochedale', 'house', 600.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1979, '19 Soar Street, ROCHEDALE', 'Rochedale', 'house', 443.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1980, '42 Royal Crescent, ROCHEDALE', 'Rochedale', 'house', 529.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1981, '28 Willow Way, ROCHEDALE', 'Rochedale', 'house', 481.0, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1982, '12 Goshawk Crescent, ROCHEDALE', 'Rochedale', 'house', 375.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1983, '91 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1984, '15 Bock Street, ROCHEDALE', 'Rochedale', 'house', 416.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1985, '3/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 174.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1986, '98 PHOENIX STREET, ROCHEDALE', 'Rochedale', 'house', 447.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1987, '41 Obrist Place, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1988, '28 Eagle Parade, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1989, '6/10 Zircon Close, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1990, '26 Prestige Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1991, '39 Grand Street, ROCHEDALE', 'Rochedale', 'house', 515.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1992, '132 Splendour Street, ROCHEDALE', 'Rochedale', 'house', 303.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1993, '74 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 567.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1994, '30/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 172.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1995, '16 Willow Way, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1996, '102 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 408.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1997, '11 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 503.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1998, '65/55 Francis Ave, ROCHEDALE', 'Rochedale', 'house', 176.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (1999, '40/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 170.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2000, '54 Cockatoo Place, ROCHEDALE', 'Rochedale', 'house', 471.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2001, '96 Rosemary Circuit, ROCHEDALE', 'Rochedale', 'house', 315.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2002, '12 Lux Place, ROCHEDALE', 'Rochedale', 'house', 313.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2003, '10 Goodtown Street, ROCHEDALE', 'Rochedale', 'house', 2553.0, NULL, 5, 3, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2004, '62 Obrist Place, ROCHEDALE', 'Rochedale', 'house', 696.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2005, '42 Dell Street, ROCHEDALE', 'Rochedale', 'house', 623.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2006, '49 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 391.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2007, '306 GRIEVE RD, ROCHEDALE', 'Rochedale', 'other', 5.2, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2008, '25 Platypus Circuit, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2009, '7/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', 179.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2010, '53 Ascent Street, ROCHEDALE', 'Rochedale', 'house', 391.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2011, '23 Major Drive, ROCHEDALE', 'Rochedale', 'house', 324.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2012, '87/68 West Street, ROCHEDALE', 'Rochedale', 'house', 201.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2013, '35 Eagle Parade, ROCHEDALE', 'Rochedale', 'house', 517.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2014, '26 Aspire Street, ROCHEDALE', 'Rochedale', 'house', 461.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2015, '18 Grand Street, ROCHEDALE', 'Rochedale', 'house', 500.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2016, '38 Elevate Street, ROCHEDALE', 'Rochedale', 'vacant_land', 448.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2017, '30 Abloom Street, ROCHEDALE', 'Rochedale', 'house', 374.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2018, '77 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2019, '16 Woodcarver Street, ROCHEDALE', 'Rochedale', 'vacant_land', 433.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2020, '6 Abloom Street, ROCHEDALE', 'Rochedale', 'house', 354.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2021, '13 Beechmont Street, ROCHEDALE', 'Rochedale', 'house', 438.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2022, '11 Prestige Street, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2023, '74/26 Elizabeth Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2024, '57 Evergreen Street, ROCHEDALE', 'Rochedale', 'house', 8159.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2025, '102/68 West Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2026, '22 Levoh Street, ROCHEDALE', 'Rochedale', 'house', 311.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2027, '70 Parklands Circuit, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2028, '104 Kookaburra Circuit, ROCHEDALE', 'Rochedale', 'house', 464.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2029, '41 Finch Parade, ROCHEDALE', 'Rochedale', 'vacant_land', 621.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2030, '64 Eagle Parade, ROCHEDALE', 'Rochedale', 'vacant_land', 548.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2031, '3 Hillcrest Street, ROCHEDALE', 'Rochedale', 'house', 308.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2032, '1 Kite Street, ROCHEDALE', 'Rochedale', 'house', 414.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2033, '119/68 West Street, ROCHEDALE', 'Rochedale', 'house', 184.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2034, '8 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 477.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2035, '27 Phoenix Street, ROCHEDALE', 'Rochedale', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2036, '658 Underwood Road, ROCHEDALE', 'Rochedale', 'house', 1.07, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2037, '3 Myrtle Street, ROCHEDALE', 'Rochedale', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2038, '38 Abloom Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2039, '122 Cooper Crescent, ROCHEDALE', 'Rochedale', 'house', 192.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2040, '59/55 Francis Avenue, ROCHEDALE', 'Rochedale', 'house', 176.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2041, '6 English Place, ROCHEDALE', 'Rochedale', 'house', 534.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2042, '55 Ascent Street, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2043, '36 Parolin Pde, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2044, '88 Eagle Parade, ROCHEDALE', 'Rochedale', 'house', 538.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2045, '33/55 Francis Ave, ROCHEDALE', 'Rochedale', 'house', 174.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2046, '29 Daniel Drive, ROCHEDALE', 'Rochedale', 'house', 420.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2047, '86 Ascent Street, ROCHEDALE', 'Rochedale', 'house', 392.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2048, '36 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2049, '36 Cockatoo Place, ROCHEDALE', 'Rochedale', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2050, '18 Ultimo Court, ROCHEDALE', 'Rochedale', 'vacant_land', 309.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2051, '25 Bock Street, ROCHEDALE', 'Rochedale', 'house', 1607.0, NULL, 3, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2052, '79 Skyview Avenue, ROCHEDALE', 'Rochedale', 'house', 505.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2053, '16 Abloom Street, ROCHEDALE', 'Rochedale', 'house', 436.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2054, '8 Frangipani Street, ROCHEDALE', 'Rochedale', 'house', 570.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2055, '93 Dunedin Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 638.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2056, '31 Shelley Street, SUNNYBANK', 'Sunnybank', 'house', 540.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2057, '5 Batford Street, SUNNYBANK', 'Sunnybank', 'house', 556.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2058, '13 Dema Street, SUNNYBANK', 'Sunnybank', 'house', 456.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2059, '43 Shelley Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2060, '20 Valhalla Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2061, '115 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 492.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2062, '11/16 Troughton Road, SUNNYBANK', 'Sunnybank', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2063, '5/16 Troughton Road, SUNNYBANK', 'Sunnybank', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2064, '10 Sunnybrae Street, SUNNYBANK', 'Sunnybank', 'house', 556.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2065, '19/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 202.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2066, '27 Headland Street, SUNNYBANK', 'Sunnybank', 'house', 567.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2067, '39 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', 633.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2068, '28/18 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 240.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2069, '38 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 703.0, NULL, 3, 2, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2070, '17 Wana Street, SUNNYBANK', 'Sunnybank', 'house', 678.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2071, '21 Station Road, SUNNYBANK', 'Sunnybank', 'house', 810.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2072, '51 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2073, '11-13 Sunnybrae Street, SUNNYBANK', 'Sunnybank', 'house', 949.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2074, '19/371 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 239.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2075, '22 Lyell Street, SUNNYBANK', 'Sunnybank', 'house', 2140.0, NULL, 4, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2076, '237 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 531.0, NULL, 3, 2, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2077, '3 Krambruk Street, SUNNYBANK', 'Sunnybank', 'house', 721.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2078, '17 Headland Street, SUNNYBANK', 'Sunnybank', 'house', 566.0, NULL, 4, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2079, '3 Matt Street, SUNNYBANK', 'Sunnybank', 'house', 703.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2080, '30 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 741.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2081, '30 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 608.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2082, '13/152 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 288.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2083, '140 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1115.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2084, '40 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2085, '32 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', 584.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2086, '17 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 665.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2087, '38 Lavinia Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2088, '4/81 McCullough Street, SUNNYBANK', 'Sunnybank', 'house', 345.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2089, '207 Mains Road, SUNNYBANK', 'Sunnybank', 'house', 625.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2090, '279 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 7, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2091, '37 Edith Street, SUNNYBANK', 'Sunnybank', 'house', 1014.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2092, '5/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2093, '37 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', 742.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2094, '4 Pictum Place, SUNNYBANK', 'Sunnybank', 'house', 771.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2095, '215A Turton Street, SUNNYBANK', 'Sunnybank', 'house', 305.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2096, '35 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 400.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2097, '17 Selvage Street, SUNNYBANK', 'Sunnybank', 'house', 483.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2098, '45 Vanessa Street, SUNNYBANK', 'Sunnybank', 'house', 685.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2099, '1 Ningari Street, SUNNYBANK', 'Sunnybank', 'house', 604.0, NULL, 3, 1, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2100, '38 Dema Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2101, '30 Gaddes Place, SUNNYBANK', 'Sunnybank', 'house', 1308.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2102, '22/8 Deason Street, SUNNYBANK', 'Sunnybank', 'house', 210.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2103, '6 Aldershot Street, SUNNYBANK', 'Sunnybank', 'house', 650.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2104, '14/66 Station Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2105, '4A Loben Street, SUNNYBANK', 'Sunnybank', 'house', 506.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2106, '190 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2107, '31 Vanessa Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2108, '17 Tarrawonga Street, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2109, '199 Mains Road, SUNNYBANK', 'Sunnybank', 'house', 635.0, NULL, 4, 1, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2110, '26 Fairbank Street, SUNNYBANK', 'Sunnybank', 'house', 506.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2111, '9 Milbong Street, SUNNYBANK', 'Sunnybank', 'house', 597.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2112, '23/25 Odin Street, SUNNYBANK', 'Sunnybank', 'other', 166.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2113, '3/148 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 146.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2114, '7/15 Dixon St, SUNNYBANK', 'Sunnybank', 'other', 202.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2115, '1/16 Troughton Road, SUNNYBANK', 'Sunnybank', 'unit', NULL, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2116, '11 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 602.0, NULL, 7, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2117, '3 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 658.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2118, '7/57 Fairbank Street, SUNNYBANK', 'Sunnybank', 'unit', NULL, NULL, 1, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2119, '12 Pengana Street, SUNNYBANK', 'Sunnybank', 'house', 582.0, NULL, 3, 2, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2120, '50 Arcoona Street, SUNNYBANK', 'Sunnybank', 'house', 630.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2121, '28 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 809.0, NULL, 3, 1, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2122, '10 Werona Street, SUNNYBANK', 'Sunnybank', 'house', 708.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2123, '138 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 452.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2124, '1A Gundooee Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2125, '47 Glendower Street, SUNNYBANK', 'Sunnybank', 'house', 496.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2126, '78 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 708.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2127, '260 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'unit', 483.0, NULL, 5, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2128, '16 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 800.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2129, '3 Dema Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2130, '30 Janice Street, SUNNYBANK', 'Sunnybank', 'house', 657.0, NULL, 6, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2131, '110 Lister Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 301.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2132, '31 Boonaree Street, SUNNYBANK', 'Sunnybank', 'house', 860.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2133, '16 Coolinda Street, SUNNYBANK', 'Sunnybank', 'house', 630.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2134, '21 Newber Street, SUNNYBANK', 'Sunnybank', 'house', 429.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2135, '7 Salix Place, SUNNYBANK', 'Sunnybank', 'house', 706.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2136, '29 Dema Street, SUNNYBANK', 'Sunnybank', 'house', 859.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2137, '32 Kimmax Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2138, '42 Vanessa Street, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2139, '8/15 Dixon Street, SUNNYBANK', 'Sunnybank', 'other', 249.0, NULL, 2, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2140, '19 Marelda Street, SUNNYBANK', 'Sunnybank', 'house', 794.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2141, '6 Comley Street, SUNNYBANK', 'Sunnybank', 'house', 617.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2142, '7/81 Mccullough Street, SUNNYBANK', 'Sunnybank', 'house', 234.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2143, '58 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 584.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2144, '38 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 809.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2145, '8 Jasbi Street, SUNNYBANK', 'Sunnybank', 'house', 604.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2146, '20 Comley Street, SUNNYBANK', 'Sunnybank', 'house', 611.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2147, '4 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 1361.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2148, '8 Jundal Street, SUNNYBANK', 'Sunnybank', 'house', 572.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2149, '245 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 412.0, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2150, '22 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 753.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2151, '53 Shelley Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2152, '44 Lampson Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 4, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2153, '19/141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 811.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2154, '23/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 257.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2155, '8 Tarrawonga Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2156, '32 Comley Street, SUNNYBANK', 'Sunnybank', 'house', 600.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2157, '41 Lampson Street, SUNNYBANK', 'Sunnybank', 'house', 435.0, NULL, 4, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2158, '15/8 Deason Street, SUNNYBANK', 'Sunnybank', 'unit', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2159, '92 Mains Road, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2160, '30 Minden Street, SUNNYBANK', 'Sunnybank', 'house', 594.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2161, '80 Maud Street, SUNNYBANK', 'Sunnybank', 'house', 1019.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2162, '40 Hedina Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2163, '83 Woff Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2164, '32/141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 800.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2165, '55 Odin Street, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2166, '16 Chalmers Place, SUNNYBANK', 'Sunnybank', 'house', 955.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2167, '141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 824.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2168, '6 Narooma Street, SUNNYBANK', 'Sunnybank', 'house', 698.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2169, '12 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 697.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2170, '52 Shelley Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2171, '9 Station Road, SUNNYBANK', 'Sunnybank', 'house', 473.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2172, '23 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 678.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2173, '25/18 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 199.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2174, '29 Hedina Street, SUNNYBANK', 'Sunnybank', 'house', 546.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2175, '1 Trudgian Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2176, '251 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 412.0, NULL, 8, 5, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2177, '772 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 2295.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2178, '86 Station Road, SUNNYBANK', 'Sunnybank', 'house', 405.0, NULL, 6, 7, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2179, '12 Kardinia Street, SUNNYBANK', 'Sunnybank', 'house', 615.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2180, '40 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 1045.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2181, '6/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 224.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2182, '365 McCullough Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2183, '262 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'unit', 483.0, NULL, 5, 5, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2184, 'Lot 1 88 DUNEDIN ST, SUNNYBANK', 'Sunnybank', 'vacant_land', 441.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2185, '69 Mitchell Street, SUNNYBANK', 'Sunnybank', 'house', 602.0, NULL, 4, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2186, '2/148 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 136.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2187, '32 Arcoona Street, SUNNYBANK', 'Sunnybank', 'house', 723.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2188, '85 Fairbank Street, SUNNYBANK', 'Sunnybank', 'house', 703.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2189, '8 Dianella Street, SUNNYBANK', 'Sunnybank', 'house', 631.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2190, '75 Albyn Road, SUNNYBANK', 'Sunnybank', 'house', 477.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2191, '60 Maud St, SUNNYBANK', 'Sunnybank', 'house', 984.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2192, '12/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2193, '12 Feltwell Street, SUNNYBANK', 'Sunnybank', 'house', 329.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2194, '27 Trudgian Street, SUNNYBANK', 'Sunnybank', 'house', 627.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2195, '3 Valencia Street, SUNNYBANK', 'Sunnybank', 'house', 810.0, NULL, 2, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2196, '172 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 468.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2197, '24/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 204.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2198, '5 Lavinia Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2199, '17 Lavinia Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2200, '24 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 568.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2201, '55 Mitchell Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 7, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2202, '97 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 978.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2203, '27 Hedina Street, SUNNYBANK', 'Sunnybank', 'house', 546.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2204, 'Lot 1, 204 Turton Street, SUNNYBANK', 'Sunnybank', 'other', 300.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2205, '139 Breton Street, SUNNYBANK', 'Sunnybank', 'house', 539.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2206, '10 Chalmers Place, SUNNYBANK', 'Sunnybank', 'house', 720.0, NULL, 6, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2207, '27 Narooma Street, SUNNYBANK', 'Sunnybank', 'house', 627.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2208, '4/57 Fairbank Street, SUNNYBANK', 'Sunnybank', 'unit', 56.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2209, '1A Agnes Street, SUNNYBANK', 'Sunnybank', 'house', 466.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2210, '45 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 803.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2211, '25 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 549.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2212, '3 Sunnybrae Street, SUNNYBANK', 'Sunnybank', 'house', 400.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2213, '16A HEADLAND ST, SUNNYBANK', 'Sunnybank', 'house', 406.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2214, '83 Station Road, SUNNYBANK', 'Sunnybank', 'house', 537.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2215, '76 Ardargie Street, SUNNYBANK', 'Sunnybank', 'house', 911.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2216, '26 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 568.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2217, '11/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2218, '56 Boonaree Street, SUNNYBANK', 'Sunnybank', 'house', 541.0, NULL, 7, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2219, '3 Gleneagles Court, SUNNYBANK', 'Sunnybank', 'house', 1341.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2220, '144 Young Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2221, '15 Comley Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2222, '169 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 414.0, NULL, 4, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2223, '9 Pankina Street, SUNNYBANK', 'Sunnybank', 'house', 615.0, NULL, 3, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2224, '153 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 1222.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2225, '8/38 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 207.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2226, '28 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2227, '2 Edith Street, SUNNYBANK', 'Sunnybank', 'house', 451.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2228, '1 Sundew Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2229, '42 Pinecone Street, SUNNYBANK', 'Sunnybank', 'house', 961.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2230, '42 Jacinda Street, SUNNYBANK', 'Sunnybank', 'house', 670.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2231, '7/16 Lara Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2232, '85 BRETON ST, SUNNYBANK', 'Sunnybank', 'house', 471.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2233, '476 Beenleigh Rd, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 3, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2234, '2 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', 597.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2235, '17/141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 800.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2236, '96 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 2476.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2237, '7/148 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'other', NULL, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2238, '6 Kimmax Street, SUNNYBANK', 'Sunnybank', 'house', 622.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2239, '15 Headland Street, SUNNYBANK', 'Sunnybank', 'house', 632.0, NULL, 5, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2240, '19 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 1101.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2241, '1/16 Lara Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2242, '27A Narooma Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 627.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2243, '5/16 Lara Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2244, '253 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 647.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2245, '14 Coolinda Street, SUNNYBANK', 'Sunnybank', 'house', 594.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2246, '293 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 764.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2247, '69 Everest Street, SUNNYBANK', 'Sunnybank', 'house', 827.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2248, '11 Samara Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2249, '2 Kardinia Street, SUNNYBANK', 'Sunnybank', 'house', 688.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2250, '63 Boonaree Street, SUNNYBANK', 'Sunnybank', 'house', 589.0, NULL, 5, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2251, '5 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 725.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2252, '3 CORISHUN STREET, SUNNYBANK', 'Sunnybank', 'house', 418.0, NULL, 4, 4, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2253, '26 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2254, '3 Arlene Street, SUNNYBANK', 'Sunnybank', 'house', 633.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2255, '54A Keats Street, SUNNYBANK', 'Sunnybank', 'house', 414.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2256, '9 Ardargie Street, SUNNYBANK', 'Sunnybank', 'house', 1242.0, NULL, 6, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2257, '6 Ningari Street, SUNNYBANK', 'Sunnybank', 'house', 928.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2258, '16/141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 810.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2259, '12 Jundal Street, SUNNYBANK', 'Sunnybank', 'house', 665.0, NULL, 5, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2260, '8 Sherbert Street, SUNNYBANK', 'Sunnybank', 'house', 813.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2261, '11 Feltwell Street, SUNNYBANK', 'Sunnybank', 'house', 873.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2262, '52 Jacinda Street, SUNNYBANK', 'Sunnybank', 'house', 685.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2263, '5 Gleneagles Court, SUNNYBANK', 'Sunnybank', 'house', 1266.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2264, '27 Fairbank Street, SUNNYBANK', 'Sunnybank', 'house', 450.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2265, '387 Mccullough Street, SUNNYBANK', 'Sunnybank', 'house', 608.0, NULL, 8, 4, 8);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2266, '152 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'vacant_land', 625.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2267, '4 Pember Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2268, '114 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1237.0, NULL, 3, 2, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2269, '558 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 569.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2270, '8/371 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2271, '2/152 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 234.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2272, '20 Lavinia Street, SUNNYBANK', 'Sunnybank', 'house', 642.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2273, '7 Fairbank Street, SUNNYBANK', 'Sunnybank', 'house', 811.0, NULL, 6, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2274, '28 Delafield Street, SUNNYBANK', 'Sunnybank', 'house', 568.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2275, '6 Meta Street, SUNNYBANK', 'Sunnybank', 'house', 744.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2276, '13 Wana Street, SUNNYBANK', 'Sunnybank', 'house', 658.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2277, '24 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 697.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2278, '76 Woff Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2279, '3 Glendower Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 600.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2280, '40 - 46 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 2403.0, NULL, 9, 3, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2281, '42 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 1214.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2282, '4 Vanessa Street, SUNNYBANK', 'Sunnybank', 'house', 562.0, NULL, 6, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2283, '21 Kardinia Street, SUNNYBANK', 'Sunnybank', 'house', 615.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2284, '6 Acorus Place, SUNNYBANK', 'Sunnybank', 'house', 658.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2285, '8 Chalmers Place, SUNNYBANK', 'Sunnybank', 'house', 1280.0, NULL, 4, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2286, '228 Station Road, SUNNYBANK', 'Sunnybank', 'house', 1613.0, NULL, 7, 4, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2287, '3/38 DYSON AVENUE, SUNNYBANK', 'Sunnybank', 'house', 208.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2288, '23 Everest Street, SUNNYBANK', 'Sunnybank', 'house', 761.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2289, '137 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2290, '159 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 617.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2291, '5/8 Deason Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2292, '24 Everest Street, SUNNYBANK', 'Sunnybank', 'house', 423.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2293, '23 Pinecone Street, SUNNYBANK', 'Sunnybank', 'house', 623.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2294, '83 Dixon, SUNNYBANK', 'Sunnybank', 'house', 799.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2295, '41 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2296, '72 Valhalla Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2297, '10 Tarrawonga Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2298, '89 Woff Street, SUNNYBANK', 'Sunnybank', 'house', 1146.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2299, '2 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 727.0, NULL, 5, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2300, '118 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2301, '70 Keats Street, SUNNYBANK', 'Sunnybank', 'house', 1257.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2302, '27 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2303, '10 Mulgowie Street, SUNNYBANK', 'Sunnybank', 'house', 645.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2304, '33 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1516.0, NULL, 10, 7, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2305, '206 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 622.0, NULL, 3, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2306, '20/141 Station Road, SUNNYBANK', 'Sunnybank', 'house', 800.0, NULL, 6, 6, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2307, '50 Mitchell Street, SUNNYBANK', 'Sunnybank', 'house', 1011.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2308, '7/66 Station Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2309, '27 Lara Street, SUNNYBANK', 'Sunnybank', 'house', 622.0, NULL, 5, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2310, '7 Pengana Street, SUNNYBANK', 'Sunnybank', 'house', 569.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2311, '39 Breton Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 683.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2312, '16 Batford Street, SUNNYBANK', 'Sunnybank', 'house', 556.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2313, '18 Vanessa Street, SUNNYBANK', 'Sunnybank', 'house', 574.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2314, '9 Comley Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2315, '14 Becker Street, SUNNYBANK', 'Sunnybank', 'house', 665.0, NULL, 6, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2316, '12 Wheatley Street, SUNNYBANK', 'Sunnybank', 'house', 615.0, NULL, 3, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2317, '53 Boorman Street, SUNNYBANK', 'Sunnybank', 'house', 649.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2318, '5/18 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 423.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2319, '32 Valhalla Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2320, '5/148 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2321, '65 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 592.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2322, '1 Norinda Street, SUNNYBANK', 'Sunnybank', 'house', 536.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2323, '9 Maud Street, SUNNYBANK', 'Sunnybank', 'house', 1014.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2324, '10 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 660.0, NULL, 5, 3, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2325, '52 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 582.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2326, '259 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'vacant_land', 600.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2327, '7 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1009.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2328, '28 Fairbank Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2329, '12/25 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2330, '42 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 809.0, NULL, 3, 1, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2331, '287 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 764.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2332, '2 Legal Street, SUNNYBANK', 'Sunnybank', 'house', 567.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2333, '18 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 715.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2334, '237 Turton Street, SUNNYBANK', 'Sunnybank', 'house', 637.0, NULL, 7, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2335, '12/18 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2336, '28 Kimmax Street, SUNNYBANK', 'Sunnybank', 'house', 632.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2337, '290 Mains Road, SUNNYBANK', 'Sunnybank', 'house', 708.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2338, '9 Naldi Street, SUNNYBANK', 'Sunnybank', 'house', 1000.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2339, '65 Breton Street, SUNNYBANK', 'Sunnybank', 'house', 600.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2340, '5 Pristina Street, SUNNYBANK', 'Sunnybank', 'house', 632.0, NULL, 6, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2341, '27 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 708.0, NULL, 3, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2342, '46 Agnes Street, SUNNYBANK', 'Sunnybank', 'house', 1014.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2343, '71 Ardargie Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 659.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2344, '69 Ardargie Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 659.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2345, '39 Samara Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 6, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2346, '20 Pinecone Street, SUNNYBANK', 'Sunnybank', 'house', 887.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2347, '23 Woff Street, SUNNYBANK', 'Sunnybank', 'house', 774.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2348, '260 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 632.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2349, '16 Wen Place, SUNNYBANK', 'Sunnybank', 'house', 807.0, NULL, 6, 5, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2350, '52 Lampson Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2351, '397 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 2840.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2352, '3/18 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 423.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2353, '29 Dixon Street, SUNNYBANK', 'Sunnybank', 'vacant_land', 600.0, NULL, NULL, NULL, NULL);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2354, '301 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 764.0, NULL, 6, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2355, '54 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 548.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2356, '9 Narooma Street, SUNNYBANK', 'Sunnybank', 'house', 650.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2357, '2 Bintani Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 6, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2358, '25 Lavinia Street, SUNNYBANK', 'Sunnybank', 'house', 645.0, NULL, 5, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2359, '5 Kythira Street, SUNNYBANK', 'Sunnybank', 'house', 676.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2360, '1 Kimmax Street, SUNNYBANK', 'Sunnybank', 'house', 802.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2361, '14 Alconah Street, SUNNYBANK', 'Sunnybank', 'house', 431.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2362, '186 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 6, 4, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2363, '117 Dyson Avenue, SUNNYBANK', 'Sunnybank', 'house', 8478.0, NULL, 5, 3, 8);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2364, '95 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 6, 6, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2365, '2/261 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 4, 3, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2366, '25 Albyn Road, SUNNYBANK', 'Sunnybank', 'house', 905.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2367, '8 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2368, '20 Halse Street, SUNNYBANK', 'Sunnybank', 'house', 546.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2369, '152 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 731.0, NULL, 4, 2, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2370, '16/66 Station Road, SUNNYBANK', 'Sunnybank', 'house', 193.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2371, '6/148 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2372, '3/16 Lara Street, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2373, '6 Arlene Street, SUNNYBANK', 'Sunnybank', 'house', 615.0, NULL, 4, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2374, '2 Pankina Street, SUNNYBANK', 'Sunnybank', 'house', 693.0, NULL, 4, 3, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2375, '28 Valhalla Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 5, 1, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2376, '106 Station Road, SUNNYBANK', 'Sunnybank', 'house', 698.0, NULL, 6, 1, 7);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2377, '6 Cresswell Street, SUNNYBANK', 'Sunnybank', 'house', 658.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2378, '11 Altandi Street, SUNNYBANK', 'Sunnybank', 'house', 607.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2379, '44/69 Stones Road, SUNNYBANK', 'Sunnybank', 'house', 121.0, NULL, 2, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2380, '110 Troughton Road, SUNNYBANK', 'Sunnybank', 'house', 401.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2381, '26 Lyell Street, SUNNYBANK', 'Sunnybank', 'house', 2016.0, NULL, 8, 4, 10);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2382, '17 Arcoona street, SUNNYBANK', 'Sunnybank', 'house', 637.0, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2383, '1/261 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 4, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2384, '30 Mains Road, SUNNYBANK', 'Sunnybank', 'house', 736.0, NULL, 3, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2385, '19 Newber Street, SUNNYBANK', 'Sunnybank', 'house', 430.0, NULL, 5, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2386, '128 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2387, '25 Agnes Street, SUNNYBANK', 'Sunnybank', 'house', 577.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2388, '1 Bintani Street, SUNNYBANK', 'Sunnybank', 'house', 536.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2389, '192 Dunedin Street, SUNNYBANK', 'Sunnybank', 'house', 660.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2390, '77 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1236.0, NULL, 5, 3, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2391, '4 Valhalla Street, SUNNYBANK', 'Sunnybank', 'house', 698.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2392, '111 Dixon Street, SUNNYBANK', 'Sunnybank', 'house', 1826.0, NULL, 6, 2, 7);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2393, '5 Pengana Street, SUNNYBANK', 'Sunnybank', 'house', 569.0, NULL, 3, 1, 5);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2394, '50 Keats Street, SUNNYBANK', 'Sunnybank', 'house', 496.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2395, '27 Kardinia Street, SUNNYBANK', 'Sunnybank', 'house', 617.0, NULL, 4, 1, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2396, '9 Littler Street, SUNNYBANK', 'Sunnybank', 'house', 509.0, NULL, 5, 3, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2397, '4 Everest Street, SUNNYBANK', 'Sunnybank', 'house', 425.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2398, '194 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 554.0, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2399, '6/16 Troughton Road, SUNNYBANK', 'Sunnybank', 'unit', 93.0, NULL, 2, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2400, '5 Romulus Street, SUNNYBANK', 'Sunnybank', 'house', 600.0, NULL, 8, 5, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2401, '8 Pictum Place, SUNNYBANK', 'Sunnybank', 'house', 610.0, NULL, 3, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2402, '36 Odin Street (Cnr Thor st), SUNNYBANK', 'Sunnybank', 'house', 592.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2403, '57 Newber Street, SUNNYBANK', 'Sunnybank', 'house', 641.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2404, '29 Legal Street, SUNNYBANK', 'Sunnybank', 'house', 710.0, NULL, 6, 3, 7);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2405, '5 Minden Street, SUNNYBANK', 'Sunnybank', 'house', 663.0, NULL, 3, 1, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2406, '33 Devenish Street, SUNNYBANK', 'Sunnybank', 'house', 765.0, NULL, 6, 4, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2407, '21 Kylie Street, SUNNYBANK', 'Sunnybank', 'house', 708.0, NULL, 4, 2, 4);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2408, '4 Erna Court, SUNNYBANK', 'Sunnybank', 'house', 782.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2409, '11 Glendower Street, SUNNYBANK', 'Sunnybank', 'house', 833.0, NULL, 5, 3, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2410, '44 Boonaree Street, SUNNYBANK', 'Sunnybank', 'house', 577.0, NULL, 3, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2411, '204 Lister Street, SUNNYBANK', 'Sunnybank', 'house', 810.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2412, '59 Maud Street, SUNNYBANK', 'Sunnybank', 'house', 1012.0, NULL, 3, 3, 6);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2413, '57 Agnes Street, SUNNYBANK', 'Sunnybank', 'house', 546.0, NULL, 5, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2414, '427 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', 1442.0, NULL, 4, 2, 3);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2415, '44 Pinecone Street, SUNNYBANK', 'Sunnybank', 'house', 961.0, NULL, 4, 2, 2);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2416, '13/371 Beenleigh Road, SUNNYBANK', 'Sunnybank', 'house', NULL, NULL, 3, 2, 1);
INSERT INTO properties (id, address, suburb, property_type, land_size, building_size, bedrooms, bathrooms, car_spaces)
VALUES (2417, '27 Edith Street, SUNNYBANK', 'Sunnybank', 'house', 1014.0, NULL, 4, 2, 2);

-- 插入 sales
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1, 2950000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2, 905000, '2025-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (3, 877500, '2025-12-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (4, 2675000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (5, 1200000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (6, 3783000, '2026-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (7, 776000, '2025-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (8, 2180000, '2025-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (9, 2775000, '2025-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (10, 880000, '2026-01-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (11, 865000, '2026-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (12, 845000, '2026-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (13, 1525000, '2026-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (14, 3250000, '2026-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (15, 810000, '2026-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (16, 780000, '2026-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (17, 6000000, '2024-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (18, 635000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (19, 796000, '2024-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (20, 1576000, '2024-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (21, 626500, '2024-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (22, 742000, '2024-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (23, 1470000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (24, 902000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (25, 865000, '2024-10-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (26, 835000, '2024-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (27, 1170000, '2024-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (28, 1575000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (29, 2275000, '2024-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (30, 1121000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (31, 1910000, '2024-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (32, 489000, '2024-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (33, 1025000, '2024-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (34, 550000, '2024-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (35, 630000, '2024-11-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (36, 23000000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (37, 2565000, '2024-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (38, 685000, '2024-08-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (39, 4820000, '2024-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (40, 766000, '2024-08-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (41, 2100000, '2024-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (42, 645000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (43, 745000, '2024-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (44, 720000, '2024-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (45, 695000, '2024-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (46, 705000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (47, 755000, '2024-08-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (48, 1105500, '2024-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (49, 2850000, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (50, 2400000, '2024-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (51, 965000, '2024-09-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (52, 680000, '2024-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (53, 855000, '2024-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (54, 3500000, '2024-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (55, 630000, '2024-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (56, 3800000, '2024-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (57, 1525000, '2024-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (58, 9125000, '2024-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (59, 3250000, '2024-07-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (60, 2400000, '2024-06-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (61, 640000, '2024-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (62, 2380000, '2024-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (63, 3350000, '2024-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (64, 1545000, '2024-06-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (65, 885000, '2024-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (66, 3000000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (67, 705000, '2024-07-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (68, 677500, '2024-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (69, 3475000, '2024-07-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (70, 585997, '2024-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (71, 730000, '2024-07-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (72, 815000, '2024-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (73, 705000, '2024-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (74, 699500, '2024-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (75, 1585000, '2024-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (76, 5400000, '2024-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (77, 675000, '2024-04-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (78, 2700000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (79, 3050000, '2024-05-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (80, 757500, '2024-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (81, 2130000, '2024-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (82, 660000, '2024-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (83, 1550000, '2024-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (84, 6571000, '2024-05-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (85, 1700000, '2024-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (86, 450000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (87, 5800000, '2024-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (88, 599300, '2024-05-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (89, 850000, '2024-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (90, 895000, '2024-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (91, 607500, '2024-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (92, 1500000, '2024-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (93, 2150000, '2024-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (94, 2200000, '2024-03-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (95, 2350000, '2024-02-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (96, 650000, '2024-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (97, 3050000, '2024-03-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (98, 650000, '2024-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (99, 2015000, '2024-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (100, 643000, '2024-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (101, 830000, '2024-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (102, 1425000, '2024-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (103, 4000000, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (104, 706000, '2024-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (105, 1350000, '2024-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (106, 515000, '2024-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (107, 1525000, '2024-03-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (108, 1240000, '2024-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (109, 1125000, '2024-04-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (110, 620000, '2024-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (111, 1750000, '2024-04-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (112, 350000, '2024-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (113, 2200000, '2024-04-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (114, 1820000, '2023-12-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (115, 2135000, '2023-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (116, 2175000, '2024-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (117, 3000000, '2023-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (118, 2100000, '2023-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (119, 2250000, '2024-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (120, 7250000, '2024-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (121, 600000, '2023-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (122, 285000, '2023-12-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (123, 1258000, '2024-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (124, 825000, '2023-12-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (125, 3250000, '2024-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (126, 647000, '2024-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (127, 785000, '2024-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (128, 2500000, '2024-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (129, 2330000, '2024-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (130, 740000, '2023-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (131, 3600000, '2024-02-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (132, 780000, '2024-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (133, 2850000, '2023-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (134, 1995000, '2023-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (135, 1750000, '2023-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (136, 680000, '2023-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (137, 3165000, '2023-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (138, 2850000, '2023-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (139, 3360000, '2023-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (140, 1215000, '2023-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (141, 3350000, '2023-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (142, 650000, '2023-11-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (143, 749900, '2023-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (144, 748510, '2023-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (145, 610000, '2023-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (146, 5325000, '2023-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (147, 2400000, '2023-12-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (148, 595000, '2023-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (149, 580000, '2023-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (150, 625000, '2023-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (151, 514999, '2023-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (152, 1785000, '2023-09-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (153, 875000, '2023-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (154, 2453000, '2023-09-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (155, 2200000, '2023-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (156, 549000, '2023-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (157, 1000000, '2023-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (158, 2500000, '2023-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (159, 5500000, '2023-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (160, 6550000, '2023-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (161, 585000, '2023-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (162, 4200000, '2023-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (163, 1525000, '2023-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (164, 630000, '2023-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (165, 5350000, '2023-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (166, 550000, '2023-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (167, 2400000, '2023-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (168, 630000, '2023-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (169, 3075000, '2023-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (170, 570000, '2023-10-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (171, 2400000, '2023-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (172, 350000, '2023-06-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (173, 960000, '2023-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (174, 680000, '2023-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (175, 1750000, '2023-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (176, 1120000, '2023-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (177, 1400000, '2023-07-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (178, 418828, '2023-06-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (179, 554000, '2023-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (180, 680000, '2023-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (181, 977500, '2023-07-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (182, 720000, '2023-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (183, 4059000, '2023-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (184, 470000, '2023-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (185, 2085000, '2023-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (186, 4030000, '2023-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (187, 420000, '2023-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (188, 1790000, '2023-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (189, 861500, '2023-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (190, 530000, '2023-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (191, 1125000, '2023-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (192, 1265000, '2023-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (193, 1085000, '2023-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (194, 510000, '2023-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (195, 3150000, '2023-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (196, 5900000, '2023-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (197, 425000, '2023-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (198, 4300000, '2023-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (199, 680000, '2023-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (200, 3800000, '2023-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (201, 570000, '2023-05-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (202, 2480000, '2023-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (203, 552000, '2023-05-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (204, 3400000, '2023-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (205, 1035000, '2023-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (206, 2128000, '2023-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (207, 515000, '2023-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (208, 532000, '2023-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (209, 550000, '2023-05-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (210, 445000, '2023-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (211, 733000, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (212, 1750000, '2025-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (213, 3875000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (214, 6505000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (215, 1330000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (216, 1950000, '2025-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (217, 1800000, '2025-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (218, 875000, '2025-11-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (219, 1080000, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (220, 1400000, '2025-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (221, 3000000, '2025-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (222, 1160000, '2025-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (223, 975000, '2025-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (224, 842000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (225, 820000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (226, 838000, '2025-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (227, 2500000, '2025-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (228, 850000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (229, 10850000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (230, 2380000, '2023-04-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (231, 960000, '2023-04-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (232, 485000, '2023-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (233, 2725000, '2023-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (234, 500000, '2023-03-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (235, 1755000, '2023-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (236, 555000, '2023-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (237, 2250000, '2023-03-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (238, 690000, '2023-03-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (239, 870000, '2023-03-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (240, 400000, '2023-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (241, 1320000, '2023-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (242, 590000, '2023-04-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (243, 1375000, '2023-05-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (244, 532500, '2023-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (245, 405000, '2023-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (246, 540000, '2023-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (247, 5600000, '2023-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (248, 7700000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (249, 3860000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (250, 825000, '2025-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (251, 2925000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (252, 3900000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (253, 845000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (254, 902000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (255, 2125000, '2025-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (256, 792000, '2025-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (257, 1500000, '2025-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (258, 1601000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (259, 770000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (260, 2400000, '2025-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (261, 1115000, '2025-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (262, 9800000, '2025-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (263, 890000, '2025-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (264, 746000, '2025-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (265, 3000000, '2025-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (266, 3600000, '2025-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (267, 1810000, '2025-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (268, 2400000, '2025-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (269, 500000, '2025-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (270, 740000, '2025-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (271, 735000, '2025-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (272, 4875000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (273, 955000, '2025-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (274, 955000, '2025-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (275, 808000, '2025-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (276, 880000, '2025-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (277, 980000, '2025-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (278, 902000, '2025-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (279, 3570000, '2025-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (280, 2200000, '2025-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (281, 1460000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (282, 3250000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (283, 4100000, '2025-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (284, 2000000, '2025-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (285, 9000000, '2025-07-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (286, 2300000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (287, 2960000, '2025-06-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (288, 675000, '2025-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (289, 1350000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (290, 1750000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (291, 1365000, '2025-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (292, 2275000, '2025-07-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (293, 4050000, '2025-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (294, 881300, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (295, 1040000, '2025-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (296, 640000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (297, 1800000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (298, 650000, '2025-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (299, 2400000, '2025-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (300, 875000, '2025-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (301, 755000, '2025-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (302, 4850000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (303, 1362000, '2025-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (304, 820000, '2025-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (305, 3850000, '2025-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (306, 1740000, '2025-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (307, 920000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (308, 800000, '2025-06-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (309, 800000, '2025-06-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (310, 700000, '2025-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (311, 2700000, '2025-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (312, 1750000, '2025-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (313, 735000, '2025-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (314, 1232000, '2025-03-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (315, 711000, '2025-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (316, 4650000, '2025-03-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (317, 6300000, '2025-04-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (318, 807500, '2025-03-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (319, 815000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (320, 4000000, '2025-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (321, 1260000, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (322, 3375000, '2025-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (323, 750000, '2025-04-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (324, 750000, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (325, 1075050, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (326, 4550000, '2025-01-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (327, 750000, '2024-12-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (328, 730000, '2025-01-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (329, 1225000, '2025-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (330, 2250000, '2025-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (331, 1500000, '2025-01-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (332, 875000, '2025-02-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (333, 2200000, '2025-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (334, 660000, '2025-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (335, 5800000, '2025-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (336, 2415000, '2025-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (337, 740000, '2025-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (338, 780000, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (339, 4011000, '2025-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (340, 820000, '2025-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (341, 3650000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (342, 705000, '2025-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (343, 10500000, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (344, 1830000, '2025-02-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (345, 465000, '2025-02-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (346, 3510000, '2024-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (347, 484000, '2024-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (348, 1506000, '2024-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (349, 1500000, '2024-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (350, 750000, '2024-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (351, 1925750, '2024-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (352, 765000, '2024-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (353, 734000, '2024-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (354, 760000, '2024-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (355, 2550000, '2024-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (356, 795000, '2024-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (357, 4950000, '2024-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (358, 800000, '2024-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (359, 728000, '2024-12-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (360, 4410000, '2024-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (361, 1700000, '2024-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (362, 5600000, '2024-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (363, 452000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (364, 990000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (365, 2500000, '2024-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (366, 1270000, '2026-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (367, 1718000, '2026-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (368, 1654000, '2026-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (369, 865000, '2026-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (370, 1425000, '2025-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (371, 1686000, '2026-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (372, 1525000, '2026-01-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (373, 730000, '2025-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (374, 1250000, '2025-12-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (375, 795000, '2026-01-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (376, 921888, '2026-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (377, 895000, '2026-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (378, 1580000, '2026-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (379, 1412000, '2026-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (380, 810000, '2025-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (381, 716000, '2025-04-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (382, 950000, '2025-04-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (383, 1008800, '2025-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (384, 1080000, '2025-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (385, 702000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (386, 1500000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (387, 700000, '2025-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (388, 740000, '2025-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (389, 990000, '2025-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (390, 640000, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (391, 645800, '2025-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (392, 700000, '2025-04-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (393, 850000, '2025-04-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (394, 1010000, '2025-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (395, 755000, '2025-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (396, 895000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (397, 742500, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (398, 770000, '2025-05-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (399, 700000, '2025-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (400, 1180000, '2025-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (401, 700000, '2025-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (402, 1400000, '2025-03-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (403, 1335000, '2025-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (404, 685000, '2025-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (405, 666666, '2025-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (406, 705000, '2025-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (407, 645000, '2025-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (408, 1290000, '2025-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (409, 1411111, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (410, 855000, '2025-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (411, 1517777, '2025-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (412, 699000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (413, 1265000, '2025-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (414, 1701000, '2025-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (415, 975000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (416, 1425000, '2025-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (417, 997000, '2025-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (418, 1405000, '2025-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (419, 700000, '2025-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (420, 1180000, '2025-02-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (421, 1050000, '2025-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (422, 610000, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (423, 625000, '2025-02-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (424, 1190000, '2025-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (425, 1250000, '2025-02-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (426, 790000, '2025-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (427, 717000, '2025-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (428, 700000, '2025-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (429, 660000, '2025-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (430, 650000, '2025-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (431, 1420000, '2025-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (432, 1016000, '2025-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (433, 635000, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (434, 1270000, '2025-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (435, 719999, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (436, 660000, '2025-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (437, 1050000, '2025-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (438, 700000, '2025-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (439, 1378000, '2024-12-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (440, 1380000, '2025-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (441, 725000, '2025-01-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (442, 946000, '2025-01-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (443, 961000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (444, 930000, '2025-01-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (445, 630000, '2024-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (446, 705000, '2024-12-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (447, 1125000, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (448, 1120000, '2025-01-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (449, 1350000, '2024-12-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (450, 685000, '2025-01-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (451, 717000, '2025-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (452, 770000, '2025-01-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (453, 700000, '2025-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (454, 993000, '2025-02-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (455, 890000, '2025-02-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (456, 855000, '2025-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (457, 610078, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (458, 933000, '2025-01-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (459, 1750000, '2024-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (460, 880000, '2024-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (461, 780000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (462, 760000, '2024-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (463, 730000, '2024-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (464, 1075000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (465, 1235000, '2024-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (466, 721000, '2024-12-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (467, 1231000, '2024-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (468, 1050000, '2024-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (469, 735000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (470, 613500, '2024-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (471, 685000, '2024-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (472, 1582500, '2024-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (473, 648000, '2024-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (474, 635000, '2024-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (475, 650000, '2024-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (476, 675000, '2024-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (477, 1002000, '2024-12-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (478, 1280000, '2024-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (479, 708888, '2024-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (480, 661100, '2024-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (481, 1020000, '2024-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (482, 652550, '2024-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (483, 1270000, '2024-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (484, 652300, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (485, 769000, '2024-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (486, 1600000, '2024-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (487, 670000, '2024-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (488, 696000, '2024-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (489, 1366000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (490, 730000, '2024-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (491, 1580000, '2024-11-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (492, 714000, '2024-11-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (493, 710000, '2024-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (494, 700000, '2024-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (495, 625000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (496, 830000, '2024-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (497, 726000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (498, 565000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (499, 1390000, '2024-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (500, 1080000, '2024-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (501, 1570000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (502, 620000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (503, 670000, '2024-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (504, 1000000, '2024-09-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (505, 1250100, '2024-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (506, 630000, '2024-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (507, 640000, '2024-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (508, 751000, '2024-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (509, 1355000, '2024-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (510, 665000, '2024-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (511, 805000, '2024-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (512, 1180000, '2024-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (513, 605000, '2024-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (514, 1041000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (515, 720000, '2024-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (516, 1556000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (517, 745000, '2024-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (518, 720000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (519, 610000, '2024-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (520, 1370000, '2024-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (521, 680000, '2024-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (522, 710000, '2024-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (523, 750000, '2024-09-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (524, 650000, '2024-09-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (525, 1428000, '2024-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (526, 1350000, '2024-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (527, 650000, '2024-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (528, 1385000, '2024-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (529, 640000, '2024-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (530, 1000000, '2024-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (531, 880000, '2024-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (532, 690000, '2024-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (533, 1360000, '2024-09-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (534, 1610000, '2024-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (535, 695888, '2024-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (536, 726000, '2024-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (537, 695000, '2024-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (538, 1020000, '2024-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (539, 1125000, '2024-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (540, 720500, '2024-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (541, 1425000, '2024-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (542, 600000, '2024-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (543, 1490000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (544, 2343000, '2024-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (545, 1802000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (546, 760000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (547, 1031000, '2024-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (548, 1387888, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (549, 836000, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (550, 660000, '2024-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (551, 1140000, '2024-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (552, 705000, '2024-08-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (553, 638000, '2024-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (554, 780000, '2024-08-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (555, 1900000, '2024-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (556, 688888, '2024-07-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (557, 675000, '2024-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (558, 690000, '2024-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (559, 670000, '2024-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (560, 1348888, '2024-07-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (561, 1368000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (562, 1100000, '2024-07-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (563, 1200000, '2024-07-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (564, 681500, '2024-07-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (565, 900000, '2024-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (566, 852000, '2024-07-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (567, 675000, '2024-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (568, 1145000, '2024-07-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (569, 601000, '2024-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (570, 630000, '2024-07-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (571, 1900000, '2024-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (572, 600000, '2024-07-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (573, 691000, '2024-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (574, 1413000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (575, 1670000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (576, 1850000, '2025-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (577, 1345000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (578, 1690000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (579, 1275000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (580, 1939000, '2025-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (581, 825000, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (582, 750000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (583, 749000, '2025-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (584, 1268000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (585, 1586000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (586, 1360888, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (587, 870000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (588, 840000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (589, 850000, '2025-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (590, 933000, '2025-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (591, 1480000, '2025-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (592, 1800000, '2024-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (593, 665000, '2024-06-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (594, 1000000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (595, 691000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (596, 1088000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (597, 590000, '2024-06-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (598, 680000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (599, 1225000, '2024-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (600, 1470000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (601, 750000, '2024-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (602, 545000, '2024-06-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (603, 628000, '2024-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (604, 500000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (605, 1533000, '2024-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (606, 710000, '2024-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (607, 690000, '2024-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (608, 1420000, '2024-06-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (609, 660000, '2024-07-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (610, 650000, '2024-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (611, 801000, '2025-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (612, 1520000, '2025-11-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (613, 832000, '2025-11-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (614, 780000, '2025-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (615, 810000, '2025-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (616, 800000, '2025-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (617, 1600000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (618, 1870000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (619, 1150000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (620, 1200000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (621, 1950000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (622, 1395000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (623, 750000, '2025-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (624, 800000, '2025-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (625, 860000, '2025-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (626, 870000, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (627, 930000, '2025-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (628, 958000, '2025-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (629, 1570000, '2025-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (630, 791000, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (631, 1391000, '2025-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (632, 1590000, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (633, 1342888, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (634, 726000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (635, 910000, '2025-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (636, 970000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (637, 1505000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (638, 865000, '2025-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (639, 1310000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (640, 767000, '2025-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (641, 1551000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (642, 1420000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (643, 1345000, '2025-11-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (644, 857000, '2025-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (645, 1110000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (646, 785000, '2025-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (647, 800000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (648, 1425000, '2025-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (649, 1274000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (650, 1705000, '2025-09-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (651, 760000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (652, 1340000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (653, 1135000, '2025-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (654, 1463000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (655, 840000, '2025-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (656, 800000, '2025-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (657, 1308500, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (658, 700000, '2025-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (659, 730000, '2025-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (660, 820000, '2025-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (661, 766000, '2025-09-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (662, 840000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (663, 788888, '2025-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (664, 1200000, '2025-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (665, 850000, '2025-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (666, 1169000, '2025-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (667, 771000, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (668, 795000, '2025-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (669, 740000, '2025-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (670, 1690000, '2025-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (671, 800000, '2025-08-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (672, 1140000, '2025-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (673, 1124000, '2025-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (674, 800000, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (675, 1506666, '2025-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (676, 1351888, '2025-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (677, 758000, '2025-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (678, 766000, '2025-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (679, 952000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (680, 690000, '2025-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (681, 675000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (682, 750000, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (683, 1401000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (684, 1511000, '2025-06-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (685, 700000, '2025-06-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (686, 741500, '2025-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (687, 770000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (688, 740000, '2025-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (689, 918000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (690, 757000, '2025-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (691, 1100000, '2025-07-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (692, 749000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (693, 1175000, '2025-07-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (694, 1328800, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (695, 970000, '2025-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (696, 688000, '2025-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (697, 744000, '2025-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (698, 1150000, '2025-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (699, 1660000, '2025-06-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (700, 1290000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (701, 725000, '2025-05-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (702, 1680000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (703, 1565000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (704, 730000, '2025-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (705, 760000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (706, 1225000, '2025-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (707, 767000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (708, 770000, '2025-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (709, 725000, '2025-06-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (710, 718880, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (711, 750000, '2025-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (712, 1100000, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (713, 780000, '2025-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (714, 700000, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (715, 715000, '2025-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (716, 1450000, '2025-05-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (717, 1410000, '2025-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (718, 645000, '2025-05-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (719, 1600000, '2025-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (720, 695000, '2025-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (721, 633000, '2025-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (722, 691000, '2025-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (723, 1390088, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (724, 1300000, '2025-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (725, 718000, '2025-05-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (726, 1705000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (727, 681000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (728, 725000, '2025-05-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (729, 1026000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (730, 750000, '2025-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (731, 2070000, '2025-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (732, 910000, '2026-01-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (733, 955000, '2025-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (734, 820000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (735, 855000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (736, 776000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (737, 1550000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (738, 1830888, '2025-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (739, 2550000, '2026-02-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (740, 2018000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (741, 920200, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (742, 915088, '2026-02-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (743, 1727000, '2025-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (744, 862500, '2026-01-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (745, 2350000, '2026-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (746, 900000, '2026-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (747, 835000, '2024-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (748, 8500000, '2024-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (749, 1511888, '2024-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (750, 1210000, '2024-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (751, 1960000, '2024-09-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (752, 1608888, '2024-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (753, 1570000, '2024-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (754, 1800000, '2024-09-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (755, 1390000, '2024-09-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (756, 1130000, '2024-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (757, 490000, '2024-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (758, 913500, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (759, 435000, '2024-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (760, 835000, '2024-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (761, 1205000, '2024-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (762, 760000, '2024-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (763, 1650000, '2024-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (764, 1100000, '2024-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (765, 682000, '2024-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (766, 1300000, '2024-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (767, 725000, '2024-09-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (768, 3500000, '2024-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (769, 836000, '2024-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (770, 850000, '2024-08-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (771, 700000, '2024-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (772, 1630000, '2024-07-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (773, 1600000, '2024-08-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (774, 1785000, '2024-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (775, 870000, '2024-08-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (776, 1342000, '2024-07-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (777, 1893000, '2024-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (778, 687400, '2024-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (779, 760000, '2024-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (780, 775000, '2024-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (781, 1591000, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (782, 1266000, '2024-08-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (783, 3090000, '2024-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (784, 1200000, '2024-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (785, 1850000, '2024-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (786, 1500000, '2024-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (787, 1458888, '2024-05-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (788, 603000, '2024-05-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (789, 658000, '2024-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (790, 1565000, '2024-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (791, 650000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (792, 670550, '2024-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (793, 1488888, '2024-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (794, 1440000, '2024-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (795, 2510000, '2024-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (796, 607000, '2024-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (797, 1680000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (798, 1340000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (799, 1220888, '2024-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (800, 920000, '2024-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (801, 910000, '2024-07-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (802, 1553000, '2024-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (803, 1155000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (804, 1605000, '2024-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (805, 1380000, '2024-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (806, 1806000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (807, 2110000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (808, 1500000, '2024-04-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (809, 3400000, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (810, 454000, '2024-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (811, 851000, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (812, 1495000, '2024-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (813, 2255000, '2024-05-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (814, 810000, '2024-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (815, 560000, '2024-04-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (816, 988000, '2024-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (817, 424000, '2024-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (818, 3430000, '2024-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (819, 1190000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (820, 2260000, '2024-04-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (821, 1625888, '2024-04-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (822, 1250000, '2024-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (823, 731000, '2024-04-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (824, 1345000, '2024-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (825, 1150000, '2024-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (826, 1050000, '2024-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (827, 1880888, '2024-02-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (828, 960000, '2024-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (829, 1121000, '2024-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (830, 1880000, '2024-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (831, 635000, '2024-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (832, 1180000, '2024-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (833, 1410000, '2024-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (834, 945000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (835, 1255000, '2024-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (836, 1395000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (837, 2169500, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (838, 738000, '2024-03-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (839, 450000, '2024-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (840, 653800, '2024-03-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (841, 580000, '2024-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (842, 860000, '2024-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (843, 535000, '2024-01-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (844, 821000, '2023-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (845, 1371000, '2023-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (846, 650000, '2024-01-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (847, 1600000, '2024-01-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (848, 1626000, '2023-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (849, 1420000, '2023-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (850, 555000, '2023-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (851, 1610500, '2023-12-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (852, 860000, '2023-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (853, 1070000, '2023-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (854, 1410000, '2023-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (855, 649000, '2024-01-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (856, 615000, '2024-01-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (857, 1500000, '2024-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (858, 1361000, '2024-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (859, 621000, '2024-02-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (860, 1761000, '2024-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (861, 805000, '2024-02-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (862, 1160000, '2023-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (863, 1700000, '2023-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (864, 1848000, '2023-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (865, 1651000, '2023-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (866, 575000, '2023-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (867, 1841000, '2023-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (868, 1750000, '2023-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (869, 923000, '2023-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (870, 646000, '2023-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (871, 1626000, '2023-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (872, 627000, '2023-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (873, 1090000, '2023-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (874, 605000, '2023-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (875, 1538000, '2023-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (876, 4360000, '2023-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (877, 1360000, '2023-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (878, 673500, '2023-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (879, 1064000, '2023-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (880, 1690000, '2023-11-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (881, 1160000, '2023-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (882, 1720000, '2023-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (883, 554000, '2023-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (884, 1350000, '2023-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (885, 1475000, '2023-07-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (886, 600000, '2023-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (887, 534999, '2023-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (888, 615500, '2023-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (889, 1531000, '2023-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (890, 1690000, '2023-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (891, 1203500, '2023-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (892, 810000, '2023-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (893, 585000, '2023-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (894, 608888, '2023-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (895, 620000, '2023-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (896, 956000, '2023-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (897, 1440000, '2023-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (898, 1190000, '2023-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (899, 1202000, '2023-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (900, 1371000, '2023-09-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (901, 749999, '2023-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (902, 640000, '2023-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (903, 498000, '2023-04-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (904, 1539998, '2023-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (905, 900000, '2023-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (906, 1520000, '2023-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (907, 1370000, '2023-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (908, 1411000, '2023-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (909, 550000, '2023-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (910, 1075000, '2023-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (911, 860000, '2023-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (912, 1068000, '2023-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (913, 1860000, '2023-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (914, 525000, '2023-06-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (915, 630000, '2023-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (916, 1700000, '2023-06-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (917, 570000, '2023-06-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (918, 475000, '2023-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (919, 1620000, '2023-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (920, 505000, '2023-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (921, 1138000, '2023-03-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (922, 535000, '2023-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (923, 527000, '2023-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (924, 538000, '2023-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (925, 2030000, '2023-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (926, 550000, '2023-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (927, 517500, '2023-03-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (928, 1703000, '2023-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (929, 2450000, '2023-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (930, 595000, '2023-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (931, 1150000, '2023-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (932, 1120000, '2023-03-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (933, 485000, '2023-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (934, 510000, '2023-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (935, 1000000, '2023-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (936, 1000000, '2023-04-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (937, 1575000, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (938, 1802000, '2025-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (939, 1582000, '2025-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (940, 800500, '2025-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (941, 840000, '2025-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (942, 845000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (943, 1535000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (944, 1625000, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (945, 1917500, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (946, 802500, '2025-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (947, 2005000, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (948, 1230000, '2025-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (949, 2300000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (950, 1551000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (951, 1635000, '2025-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (952, 1800000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (953, 1565000, '2025-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (954, 1100000, '2025-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (955, 810000, '2022-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (956, 482500, '2023-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (957, 617000, '2022-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (958, 503000, '2023-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (959, 485000, '2022-12-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (960, 1040000, '2023-01-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (961, 480000, '2022-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (962, 495000, '2023-01-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (963, 630000, '2023-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (964, 505000, '2023-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (965, 558000, '2023-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (966, 1310000, '2023-01-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (967, 478000, '2023-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (968, 890000, '2023-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (969, 510000, '2023-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (970, 535000, '2022-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (971, 1560000, '2023-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (972, 1010000, '2023-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (973, 1363500, '2023-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (974, 570000, '2023-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (975, 1528000, '2025-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (976, 1725000, '2025-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (977, 1795000, '2025-09-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (978, 1250000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (979, 786888, '2025-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (980, 1840000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (981, 2880800, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (982, 851108, '2025-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (983, 1889000, '2025-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (984, 741500, '2025-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (985, 850000, '2025-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (986, 1320000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (987, 1305000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (988, 2041888, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (989, 1069000, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (990, 752000, '2025-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (991, 975000, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (992, 786000, '2025-08-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (993, 1300000, '2025-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (994, 1381000, '2025-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (995, 1977000, '2025-08-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (996, 1520000, '2025-08-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (997, 1450000, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (998, 1788000, '2025-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (999, 1451000, '2025-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1000, 1445000, '2025-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1001, 831000, '2025-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1002, 1368000, '2025-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1003, 1555000, '2025-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1004, 794000, '2025-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1005, 955000, '2025-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1006, 1821000, '2025-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1007, 822000, '2025-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1008, 2268888, '2025-07-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1009, 1601000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1010, 2030000, '2025-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1011, 1720000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1012, 760000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1013, 700000, '2025-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1014, 1350000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1015, 710000, '2025-06-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1016, 890500, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1017, 2041001, '2025-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1018, 1851000, '2025-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1019, 1360000, '2025-07-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1020, 1430000, '2025-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1021, 1680000, '2025-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1022, 768000, '2025-07-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1023, 1872000, '2025-06-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1024, 752500, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1025, 701000, '2025-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1026, 680000, '2025-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1027, 1700000, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1028, 701000, '2025-04-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1029, 946000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1030, 700000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1031, 895000, '2025-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1032, 1478000, '2025-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1033, 1420000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1034, 700000, '2025-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1035, 686000, '2025-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1036, 1500000, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1037, 741000, '2025-05-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1038, 2060000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1039, 1180000, '2025-05-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1040, 1060000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1041, 1576000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1042, 1300000, '2025-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1043, 11000000, '2025-04-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1044, 1586000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1045, 800000, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1046, 1516000, '2025-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1047, 1751000, '2025-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1048, 1262000, '2025-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1049, 1258000, '2025-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1050, 765000, '2025-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1051, 625000, '2025-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1052, 695000, '2025-03-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1053, 742000, '2025-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1054, 670000, '2025-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1055, 541500, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1056, 748000, '2025-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1057, 880000, '2025-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1058, 650000, '2025-03-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1059, 1375000, '2025-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1060, 730000, '2025-03-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1061, 2050000, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1062, 1100000, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1063, 736000, '2025-04-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1064, 1500000, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1065, 1586000, '2024-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1066, 713000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1067, 1480000, '2025-01-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1068, 780000, '2025-01-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1069, 2380000, '2024-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1070, 690000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1071, 1218000, '2024-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1072, 2106500, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1073, 735500, '2025-01-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1074, 895000, '2024-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1075, 1460000, '2025-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1076, 828000, '2025-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1077, 687000, '2025-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1078, 1425000, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1079, 1300000, '2025-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1080, 1740000, '2025-01-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1081, 706888, '2025-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1082, 1300000, '2025-01-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1083, 1570000, '2024-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1084, 785000, '2024-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1085, 1318000, '2024-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1086, 1388000, '2024-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1087, 830000, '2024-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1088, 1400000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1089, 700000, '2024-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1090, 1700000, '2024-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1091, 697000, '2024-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1092, 1550000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1093, 1880888, '2024-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1094, 1080000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1095, 1460000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1096, 1200000, '2024-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1097, 1569000, '2024-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1098, 723000, '2024-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1099, 1139000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1100, 725000, '2024-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1101, 687000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1102, 1300000, '2024-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1103, 6500000, '2026-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1104, 2400000, '2026-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1105, 1315000, '2026-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1106, 1300000, '2026-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1107, 2570000, '2026-02-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1108, 1410000, '2026-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1109, 1055000, '2026-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1110, 699800, '2026-02-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1111, 825000, '2026-02-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1112, 1450000, '2026-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1113, 860000, '2026-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1114, 600000, '2026-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1115, 845000, '2026-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1116, 1045000, '2026-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1117, 1100000, '2026-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1118, 975000, '2026-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1119, 5700000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1120, 1950000, '2025-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1121, 480000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1122, 1450000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1123, 2150000, '2025-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1124, 849000, '2025-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1125, 480000, '2025-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1126, 850000, '2025-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1127, 700000, '2025-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1128, 610000, '2025-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1129, 500000, '2025-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1130, 620000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1131, 501000, '2025-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1132, 2060000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1133, 485000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1134, 530000, '2025-07-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1135, 940000, '2025-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1136, 761200, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1137, 739000, '2025-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1138, 1430000, '2025-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1139, 3100000, '2025-06-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1140, 5800000, '2025-06-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1141, 3550000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1142, 485000, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1143, 1265000, '2025-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1144, 575000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1145, 710000, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1146, 1502000, '2025-07-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1147, 775000, '2025-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1148, 567500, '2025-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1149, 1300000, '2025-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1150, 580000, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1151, 755000, '2025-07-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1152, 1300000, '2025-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1153, 1850000, '2025-06-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1154, 1065000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1155, 1660000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1156, 585000, '2025-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1157, 700000, '2025-06-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1158, 2200000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1159, 630000, '2025-05-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1160, 650000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1161, 610000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1162, 610000, '2025-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1163, 481000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1164, 672000, '2025-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1165, 820000, '2025-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1166, 600000, '2025-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1167, 610000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1168, 4950000, '2025-06-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1169, 980000, '2025-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1170, 1100000, '2025-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1171, 915000, '2025-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1172, 630000, '2025-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1173, 1198000, '2025-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1174, 572500, '2025-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1175, 957500, '2025-05-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1176, 565000, '2025-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1177, 1100000, '2025-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1178, 660000, '2025-05-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1179, 550000, '2025-05-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1180, 600000, '2025-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1181, 745000, '2025-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1182, 600000, '2025-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1183, 640000, '2025-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1184, 450000, '2025-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1185, 560000, '2025-05-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1186, 600000, '2025-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1187, 630000, '2025-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1188, 1095000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1189, 620000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1190, 665000, '2025-04-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1191, 605000, '2025-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1192, 2100000, '2025-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1193, 799000, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1194, 555000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1195, 820000, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1196, 476000, '2025-05-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1197, 590000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1198, 650000, '2025-05-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1199, 450000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1200, 1440000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1201, 590000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1202, 590000, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1203, 750000, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1204, 920000, '2025-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1205, 735000, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1206, 575000, '2025-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1207, 630000, '2025-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1208, 5800000, '2025-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1209, 1780000, '2025-04-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1210, 4500000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1211, 540000, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1212, 900000, '2025-04-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1213, 535000, '2025-04-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1214, 1980000, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1215, 3750000, '2025-04-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1216, 1200000, '2025-04-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1217, 1040000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1218, 820000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1219, 576500, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1220, 760000, '2025-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1221, 2250000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1222, 460000, '2025-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1223, 625000, '2025-04-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1224, 840000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1225, 13000000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1226, 6000000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1227, 945000, '2025-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1228, 1625000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1229, 2200000, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1230, 1150000, '2025-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1231, 802000, '2025-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1232, 1200000, '2025-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1233, 770000, '2025-03-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1234, 3625000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1235, 540000, '2025-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1236, 1900000, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1237, 570000, '2025-03-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1238, 865000, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1239, 1050000, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1240, 1025000, '2025-03-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1241, 745000, '2025-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1242, 725000, '2025-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1243, 530000, '2025-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1244, 3600000, '2025-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1245, 900000, '2025-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1246, 570000, '2025-02-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1247, 2250000, '2025-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1248, 730000, '2025-02-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1249, 555000, '2025-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1250, 900000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1251, 540000, '2025-02-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1252, 745000, '2025-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1253, 606000, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1254, 570000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1255, 575000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1256, 570000, '2025-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1257, 800000, '2025-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1258, 560000, '2025-02-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1259, 765000, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1260, 700000, '2025-02-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1261, 450000, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1262, 3890000, '2025-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1263, 450000, '2025-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1264, 4300000, '2025-01-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1265, 740000, '2025-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1266, 1827000, '2025-01-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1267, 815000, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1268, 1500000, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1269, 625000, '2025-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1270, 1640000, '2025-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1271, 1350000, '2025-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1272, 532500, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1273, 540000, '2025-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1274, 557000, '2025-02-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1275, 550000, '2025-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1276, 540000, '2025-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1277, 540000, '2025-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1278, 560000, '2025-02-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1279, 1425000, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1280, 540000, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1281, 1440000, '2025-02-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1282, 550000, '2025-01-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1283, 440000, '2025-01-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1284, 417000, '2024-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1285, 730000, '2025-01-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1286, 2000000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1287, 775000, '2025-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1288, 660000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1289, 1875000, '2025-01-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1290, 490000, '2024-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1291, 2025000, '2024-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1292, 3050000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1293, 1030000, '2024-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1294, 980000, '2025-01-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1295, 1300000, '2025-01-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1296, 752000, '2025-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1297, 510000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1298, 540000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1299, 640000, '2025-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1300, 665000, '2025-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1301, 785000, '2026-01-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1302, 2840000, '2026-01-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1303, 1065000, '2026-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1304, 3890000, '2025-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1305, 2150000, '2025-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1306, 725000, '2025-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1307, 910000, '2025-12-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1308, 950000, '2025-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1309, 770000, '2025-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1310, 923000, '2025-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1311, 1246500, '2026-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1312, 1980000, '2026-01-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1313, 560000, '2026-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1314, 1050000, '2026-01-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1315, 1050000, '2026-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1316, 925000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1317, 1330000, '2024-12-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1318, 515000, '2024-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1319, 450000, '2024-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1320, 580000, '2024-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1321, 665000, '2024-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1322, 605000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1323, 765000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1324, 425000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1325, 645000, '2024-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1326, 545000, '2024-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1327, 500000, '2024-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1328, 510000, '2024-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1329, 580000, '2024-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1330, 665000, '2024-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1331, 570000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1332, 695000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1333, 1585000, '2024-12-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1334, 652000, '2025-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1335, 1700000, '2025-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1336, 680000, '2025-12-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1337, 6250000, '2025-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1338, 2650000, '2025-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1339, 661000, '2025-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1340, 820000, '2025-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1341, 2377000, '2025-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1342, 670000, '2025-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1343, 1400000, '2025-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1344, 765000, '2025-12-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1345, 780000, '2025-12-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1346, 840000, '2025-12-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1347, 700000, '2025-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1348, 680000, '2025-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1349, 775000, '2025-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1350, 785000, '2025-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1351, 865000, '2025-12-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1352, 1080000, '2025-12-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1353, 550000, '2025-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1354, 1290000, '2025-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1355, 1100000, '2025-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1356, 6000000, '2025-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1357, 1520000, '2025-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1358, 1455000, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1359, 2150000, '2025-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1360, 2350000, '2025-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1361, 650000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1362, 1250000, '2025-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1363, 850000, '2025-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1364, 1050000, '2025-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1365, 3700000, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1366, 3375000, '2025-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1367, 855000, '2025-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1368, 780000, '2025-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1369, 1289000, '2025-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1370, 990000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1371, 975000, '2025-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1372, 1950000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1373, 992500, '2025-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1374, 2975000, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1375, 570000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1376, 825000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1377, 817000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1378, 1200000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1379, 750000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1380, 651000, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1381, 869198, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1382, 685000, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1383, 695000, '2025-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1384, 4500000, '2025-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1385, 680000, '2025-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1386, 760000, '2025-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1387, 795000, '2025-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1388, 810000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1389, 895000, '2025-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1390, 1050000, '2025-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1391, 1951000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1392, 3912500, '2025-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1393, 1560000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1394, 624000, '2025-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1395, 1075000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1396, 1000000, '2025-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1397, 2250000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1398, 650000, '2025-10-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1399, 712000, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1400, 565000, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1401, 576000, '2025-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1402, 1600000, '2025-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1403, 3400000, '2025-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1404, 900000, '2025-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1405, 850000, '2025-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1406, 520000, '2025-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1407, 7500000, '2025-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1408, 7800000, '2025-09-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1409, 1770000, '2025-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1410, 818000, '2025-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1411, 845000, '2025-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1412, 1965000, '2025-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1413, 1342500, '2025-10-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1414, 2325000, '2025-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1415, 735000, '2025-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1416, 532000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1417, 3200000, '2025-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1418, 696000, '2025-09-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1419, 8000000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1420, 2650000, '2025-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1421, 745000, '2025-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1422, 520000, '2025-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1423, 2550000, '2025-09-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1424, 3200000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1425, 640000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1426, 685000, '2025-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1427, 700000, '2025-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1428, 1530000, '2025-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1429, 930000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1430, 6010000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1431, 1441000, '2025-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1432, 701000, '2025-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1433, 616000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1434, 730000, '2025-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1435, 650000, '2025-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1436, 906000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1437, 520000, '2025-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1438, 780000, '2025-09-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1439, 640000, '2025-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1440, 620000, '2025-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1441, 1160000, '2025-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1442, 3550000, '2025-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1443, 4200000, '2025-08-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1444, 4300000, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1445, 1370000, '2025-08-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1446, 716000, '2025-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1447, 1280000, '2025-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1448, 1700000, '2025-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1449, 611500, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1450, 725000, '2025-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1451, 570000, '2025-08-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1452, 920000, '2025-08-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1453, 746000, '2025-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1454, 672500, '2025-08-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1455, 805000, '2025-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1456, 635000, '2025-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1457, 495000, '2025-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1458, 888000, '2025-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1459, 780000, '2025-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1460, 1700000, '2025-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1461, 1505000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1462, 1828000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1463, 1350000, '2025-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1464, 1400000, '2025-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1465, 1362000, '2025-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1466, 745000, '2025-12-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1467, 1485000, '2025-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1468, 1350000, '2025-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1469, 1530000, '2026-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1470, 1575000, '2026-02-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1471, 1680000, '2026-02-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1472, 1400000, '2026-02-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1473, 1360000, '2026-02-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1474, 1636000, '2026-02-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1475, 1467500, '2026-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1476, 1521000, '2026-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1477, 1260000, '2024-02-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1478, 1485000, '2024-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1479, 1430000, '2024-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1480, 1105000, '2024-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1481, 2170000, '2024-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1482, 1660000, '2024-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1483, 1360001, '2024-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1484, 750000, '2024-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1485, 1228000, '2024-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1486, 1160000, '2024-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1487, 1518000, '2024-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1488, 2100000, '2024-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1489, 942200, '2024-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1490, 1430000, '2024-03-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1491, 1150000, '2024-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1492, 1100000, '2024-04-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1493, 1155000, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1494, 1105000, '2024-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1495, 1450000, '2024-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1496, 1685001, '2024-04-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1497, 1100000, '2023-11-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1498, 1130000, '2023-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1499, 1206000, '2023-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1500, 1175000, '2023-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1501, 1255000, '2023-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1502, 850000, '2023-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1503, 1370000, '2023-11-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1504, 840000, '2023-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1505, 935000, '2023-12-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1506, 1020000, '2023-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1507, 690000, '2023-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1508, 1345000, '2023-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1509, 850000, '2023-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1510, 1180000, '2024-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1511, 1020000, '2023-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1512, 1410000, '2024-01-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1513, 1184500, '2024-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1514, 1353000, '2024-01-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1515, 1700000, '2023-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1516, 869500, '2023-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1517, 1200000, '2023-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1518, 815000, '2023-08-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1519, 1250000, '2023-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1520, 508000, '2023-08-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1521, 1177000, '2023-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1522, 1161500, '2023-08-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1523, 710000, '2023-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1524, 1145000, '2023-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1525, 1050000, '2023-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1526, 1502000, '2023-09-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1527, 1060000, '2023-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1528, 1320000, '2023-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1529, 1024000, '2023-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1530, 1380000, '2023-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1531, 1300000, '2023-09-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1532, 1420000, '2023-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1533, 1270000, '2023-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1534, 1140000, '2023-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1535, 1150000, '2023-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1536, 1690000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1537, 1888000, '2025-09-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1538, 1700000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1539, 1715000, '2025-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1540, 680000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1541, 1413000, '2025-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1542, 1608000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1543, 1720000, '2025-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1544, 1426000, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1545, 1250000, '2025-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1546, 1826500, '2025-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1547, 1350000, '2025-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1548, 1381000, '2025-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1549, 1840000, '2025-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1550, 1820000, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1551, 1450000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1552, 1599888, '2025-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1553, 1865500, '2025-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1554, 1313000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1555, 1200000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1556, 1460000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1557, 1195000, '2025-08-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1558, 1685000, '2025-08-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1559, 1300500, '2025-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1560, 1217000, '2025-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1561, 1260000, '2025-08-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1562, 1452000, '2025-08-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1563, 1600000, '2025-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1564, 1420000, '2025-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1565, 1550000, '2025-09-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1566, 926000, '2025-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1567, 1130000, '2025-07-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1568, 1300000, '2025-09-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1569, 1330000, '2025-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1570, 1685000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1571, 1550000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1572, 1475000, '2025-08-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1573, 862000, '2025-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1574, 1150000, '2025-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1575, 1315000, '2025-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1576, 1481000, '2025-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1577, 1280000, '2025-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1578, 1235000, '2025-05-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1579, 1490000, '2025-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1580, 1500000, '2025-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1581, 1275000, '2025-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1582, 1300000, '2025-06-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1583, 1480000, '2025-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1584, 1300000, '2025-07-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1585, 1248000, '2025-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1586, 1414000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1587, 1500000, '2025-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1588, 1800000, '2025-07-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1589, 1400000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1590, 1245000, '2025-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1591, 920000, '2025-07-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1592, 1580000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1593, 1450000, '2025-03-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1594, 902500, '2025-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1595, 1248000, '2025-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1596, 1170000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1597, 1120000, '2025-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1598, 1250000, '2025-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1599, 626000, '2025-03-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1600, 1685000, '2025-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1601, 1800000, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1602, 1350000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1603, 1420010, '2025-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1604, 1595000, '2025-04-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1605, 1556000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1606, 1100000, '2025-04-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1607, 1290000, '2025-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1608, 1240000, '2025-05-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1609, 990000, '2025-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1610, 1360000, '2025-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1611, 1640000, '2024-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1612, 1125000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1613, 872000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1614, 1355000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1615, 407500, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1616, 1635000, '2024-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1617, 1196000, '2024-12-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1618, 1238000, '2024-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1619, 1260000, '2024-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1620, 1195000, '2025-01-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1621, 1434000, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1622, 743000, '2025-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1623, 1135000, '2025-01-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1624, 1662500, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1625, 1320000, '2025-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1626, 1220000, '2025-01-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1627, 1230000, '2025-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1628, 2300000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1629, 1520000, '2024-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1630, 1590000, '2024-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1631, 450000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1632, 1280500, '2024-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1633, 1480000, '2024-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1634, 975000, '2024-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1635, 1600000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1636, 730000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1637, 1505000, '2024-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1638, 1165000, '2024-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1639, 1482000, '2024-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1640, 1230000, '2024-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1641, 1200000, '2024-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1642, 465000, '2024-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1643, 1520000, '2024-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1644, 1155000, '2024-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1645, 1400000, '2024-11-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1646, 487000, '2024-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1647, 452000, '2024-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1648, 1190000, '2024-07-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1649, 1205000, '2024-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1650, 1101000, '2024-08-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1651, 1108000, '2024-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1652, 1306500, '2024-08-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1653, 1340000, '2024-08-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1654, 1500000, '2024-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1655, 1910000, '2024-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1656, 1350000, '2024-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1657, 1111500, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1658, 1218000, '2024-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1659, 1265000, '2024-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1660, 1445000, '2024-08-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1661, 1080000, '2024-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1662, 835000, '2024-08-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1663, 1211000, '2024-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1664, 2185000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1665, 1250000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1666, 1200000, '2024-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1667, 1450000, '2024-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1668, 1438000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1669, 1455000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1670, 1675000, '2024-05-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1671, 1139000, '2024-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1672, 1135000, '2024-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1673, 1442000, '2024-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1674, 1410000, '2024-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1675, 1190000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1676, 1810000, '2024-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1677, 1180000, '2024-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1678, 1200000, '2024-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1679, 1460000, '2024-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1680, 1850000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1681, 1430000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1682, 1320000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1683, 895000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1684, 1330000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1685, 1200000, '2024-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1686, 1280000, '2024-07-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1687, 1055000, '2026-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1688, 2650000, '2025-12-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1689, 1070000, '2026-01-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1690, 2350000, '2026-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1691, 2150000, '2026-02-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1692, 1550000, '2026-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1693, 990000, '2025-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1694, 1550000, '2025-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1695, 1290319, '2025-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1696, 1150200, '2025-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1697, 1810000, '2026-01-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1698, 990000, '2025-12-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1699, 1241000, '2026-01-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1700, 1255000, '2026-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1701, 1025000, '2026-03-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1702, 1175000, '2026-02-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1703, 1300000, '2026-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1704, 1171000, '2026-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1705, 2348000, '2024-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1706, 2550000, '2024-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1707, 2810000, '2024-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1708, 3080888, '2024-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1709, 1385000, '2024-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1710, 1388000, '2024-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1711, 986000, '2024-09-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1712, 1100000, '2024-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1713, 1695000, '2024-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1714, 940000, '2024-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1715, 1910000, '2024-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1716, 1500000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1717, 1750000, '2024-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1718, 1600000, '2024-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1719, 1650000, '2024-09-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1720, 906000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1721, 930000, '2024-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1722, 1600000, '2024-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1723, 2100000, '2024-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1724, 970000, '2024-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1725, 8000000, '2024-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1726, 2380000, '2024-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1727, 2390000, '2024-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1728, 1980888, '2024-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1729, 2420000, '2024-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1730, 2850000, '2024-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1731, 2118888, '2024-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1732, 1019000, '2024-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1733, 979000, '2024-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1734, 989000, '2024-07-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1735, 1938888, '2024-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1736, 2300000, '2024-06-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1737, 1970000, '2024-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1738, 1710000, '2024-07-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1739, 921000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1740, 1930000, '2024-07-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1741, 1430000, '2024-07-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1742, 930000, '2024-07-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1743, 1033000, '2024-07-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1744, 975000, '2024-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1745, 2200888, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1746, 1770000, '2024-03-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1747, 1375000, '2024-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1748, 2362000, '2024-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1749, 1015000, '2024-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1750, 1633888, '2024-03-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1751, 1500000, '2024-04-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1752, 1438000, '2024-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1753, 1525500, '2024-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1754, 1100000, '2024-04-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1755, 1700000, '2024-05-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1756, 1040888, '2024-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1757, 1405000, '2024-04-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1758, 984000, '2024-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1759, 1310000, '2024-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1760, 1010000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1761, 1666000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1762, 1860000, '2024-05-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1763, 1988888, '2024-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1764, 1800000, '2024-06-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1765, 988000, '2024-03-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1766, 2200000, '2024-01-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1767, 2934000, '2023-12-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1768, 1870000, '2024-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1769, 1890000, '2024-02-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1770, 1870000, '2023-12-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1771, 2020000, '2024-01-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1772, 1700000, '2024-01-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1773, 1560000, '2024-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1774, 1400000, '2024-02-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1775, 1810000, '2024-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1776, 2200100, '2024-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1777, 1088000, '2024-03-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1778, 2210000, '2024-03-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1779, 1260000, '2024-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1780, 1210000, '2024-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1781, 1256000, '2024-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1782, 1518000, '2024-03-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1783, 2420000, '2024-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1784, 4000000, '2024-02-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1785, 5200000, '2023-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1786, 2232000, '2023-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1787, 1520000, '2023-12-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1788, 2300000, '2023-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1789, 1830000, '2023-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1790, 1515000, '2023-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1791, 970000, '2023-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1792, 1940000, '2023-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1793, 1720000, '2023-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1794, 1300000, '2023-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1795, 2438000, '2023-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1796, 1660000, '2023-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1797, 1540000, '2023-12-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1798, 1625000, '2023-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1799, 1365000, '2023-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1800, 1930000, '2023-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1801, 1800000, '2023-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1802, 1701000, '2023-11-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1803, 1888000, '2023-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1804, 2800000, '2023-12-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1805, 1000000, '2023-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1806, 1850000, '2023-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1807, 2451000, '2023-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1808, 2410888, '2023-07-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1809, 2200000, '2023-08-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1810, 1955000, '2023-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1811, 1935000, '2023-09-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1812, 795000, '2023-07-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1813, 1721000, '2023-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1814, 1480000, '2023-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1815, 1655000, '2023-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1816, 7376333, '2023-10-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1817, 2750000, '2023-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1818, 1390000, '2023-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1819, 1340000, '2023-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1820, 2710000, '2023-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1821, 930000, '2023-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1822, 1831000, '2023-10-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1823, 2010000, '2023-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1824, 1358888, '2023-06-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1825, 2650000, '2023-06-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1826, 1148000, '2023-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1827, 1250000, '2023-05-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1828, 3550000, '2023-06-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1829, 2575000, '2023-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1830, 2650888, '2023-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1831, 3150000, '2023-06-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1832, 1965000, '2023-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1833, 1910000, '2023-06-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1834, 815000, '2023-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1835, 2358000, '2023-06-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1836, 1550000, '2023-06-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1837, 1608000, '2023-06-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1838, 1500000, '2023-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1839, 740000, '2023-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1840, 860000, '2023-06-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1841, 833000, '2023-06-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1842, 1367000, '2023-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1843, 1300000, '2023-06-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1844, 1250000, '2023-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1845, 959000, '2023-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1846, 1180000, '2023-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1847, 1025000, '2023-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1848, 1710000, '2023-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1849, 2000000, '2023-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1850, 2058000, '2023-05-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1851, 2475000, '2023-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1852, 1570000, '2023-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1853, 1900000, '2023-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1854, 2300000, '2023-04-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1855, 1700000, '2023-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1856, 1380000, '2023-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1857, 1740000, '2023-04-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1858, 1210000, '2023-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1859, 715000, '2023-04-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1860, 1500000, '2023-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1861, 2050000, '2023-05-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1862, 1720000, '2023-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1863, 1170000, '2023-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1864, 888000, '2023-02-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1865, 705000, '2022-12-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1866, 1800000, '2022-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1867, 1580000, '2023-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1868, 1950000, '2023-01-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1869, 1250000, '2022-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1870, 965000, '2023-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1871, 1325000, '2023-01-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1872, 1585000, '2023-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1873, 1208000, '2023-02-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1874, 1850000, '2023-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1875, 720000, '2023-02-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1876, 1750000, '2023-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1877, 1950000, '2023-02-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1878, 1200000, '2023-02-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1879, 1475000, '2023-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1880, 815000, '2023-02-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1881, 790200, '2023-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1882, 3200000, '2022-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1883, 2650000, '2022-11-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1884, 775000, '2022-11-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1885, 1618000, '2022-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1886, 2028888, '2022-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1887, 791000, '2022-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1888, 1250000, '2022-12-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1889, 740000, '2022-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1890, 675000, '2022-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1891, 1041888, '2022-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1892, 780000, '2022-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1893, 2100000, '2022-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1894, 1560000, '2022-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1895, 1720000, '2022-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1896, 700000, '2022-12-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1897, 1850888, '2022-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1898, 1846000, '2022-12-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1899, 970000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1900, 1128000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1901, 1400000, '2025-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1902, 1418888, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1903, 1458000, '2025-11-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1904, 1910000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1905, 1740000, '2025-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1906, 2608888, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1907, 1700000, '2025-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1908, 1880000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1909, 990000, '2025-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1910, 1643000, '2025-11-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1911, 2470000, '2025-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1912, 2828888, '2025-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1913, 1605000, '2025-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1914, 1650000, '2025-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1915, 1050000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1916, 1880000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1917, 1875000, '2025-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1918, 1240000, '2025-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1919, 1050000, '2022-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1920, 730000, '2022-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1921, 1170000, '2022-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1922, 1916000, '2022-08-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1923, 1601000, '2022-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1924, 1400000, '2022-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1925, 1138000, '2022-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1926, 1950000, '2022-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1927, 1250000, '2022-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1928, 805000, '2022-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1929, 1880000, '2022-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1930, 3260000, '2022-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1931, 343000, '2022-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1932, 1300000, '2022-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1933, 1235000, '2022-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1934, 1850000, '2022-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1935, 1435000, '2022-10-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1936, 1126000, '2022-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1937, 1855000, '2022-08-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1938, 750000, '2022-10-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1939, 1500000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1940, 1560000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1941, 1852000, '2025-10-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1942, 1591000, '2025-09-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1943, 1978000, '2025-10-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1944, 1536000, '2025-10-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1945, 2000000, '2025-10-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1946, 2000000, '2025-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1947, 1617000, '2025-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1948, 996000, '2025-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1949, 4200000, '2025-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1950, 1030000, '2025-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1951, 1180000, '2025-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1952, 1060000, '2025-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1953, 1435000, '2025-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1954, 1200000, '2025-10-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1955, 1490000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1956, 2350000, '2025-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1957, 1725000, '2025-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1958, 3740000, '2025-09-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1959, 975000, '2025-09-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1960, 1125000, '2025-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1961, 1800000, '2025-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1962, 1810000, '2025-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1963, 1090000, '2025-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1964, 1775000, '2025-09-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1965, 2800000, '2025-09-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1966, 990000, '2025-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1967, 2850000, '2025-09-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1968, 2120000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1969, 3500000, '2025-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1970, 2098000, '2025-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1971, 1671888, '2025-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1972, 1506000, '2025-08-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1973, 2050000, '2025-08-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1974, 1921000, '2025-08-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1975, 2340000, '2025-08-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1976, 1901000, '2025-08-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1977, 2100000, '2025-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1978, 2150000, '2025-08-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1979, 1600000, '2025-08-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1980, 1825000, '2025-08-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1981, 1880888, '2025-08-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1982, 1690000, '2025-08-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1983, 1800000, '2025-08-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1984, 1625000, '2025-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1985, 970000, '2025-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1986, 1822000, '2025-07-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1987, 1930000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1988, 1561000, '2025-06-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1989, 1120000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1990, 2250000, '2025-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1991, 2170000, '2025-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1992, 1600000, '2025-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1993, 2070000, '2025-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1994, 975000, '2025-06-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1995, 1628000, '2025-07-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1996, 1610000, '2025-06-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1997, 1870000, '2025-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1998, 965000, '2025-07-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (1999, 950000, '2025-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2000, 1510000, '2025-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2001, 1752000, '2025-06-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2002, 1375000, '2025-07-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2003, 3880000, '2025-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2004, 1870000, '2025-05-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2005, 2500000, '2025-05-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2006, 1630000, '2025-05-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2007, 3500000, '2025-04-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2008, 1648000, '2025-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2009, 965000, '2025-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2010, 1555000, '2025-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2011, 1290000, '2025-04-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2012, 990000, '2025-04-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2013, 1923000, '2025-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2014, 1830000, '2025-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2015, 1910000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2016, 1100000, '2025-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2017, 1600000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2018, 1835000, '2025-05-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2019, 1056000, '2025-03-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2020, 1850000, '2025-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2021, 1810000, '2025-02-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2022, 2155000, '2025-04-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2023, 950000, '2025-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2024, 1600000, '2025-03-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2025, 996000, '2025-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2026, 1380000, '2025-02-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2027, 1968000, '2025-02-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2028, 1810000, '2025-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2029, 1335150, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2030, 1205600, '2025-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2031, 1339999, '2025-03-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2032, 1400000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2033, 1015000, '2025-03-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2034, 1810008, '2025-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2035, 1575000, '2025-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2036, 4380000, '2025-03-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2037, 1738000, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2038, 2050000, '2024-12-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2039, 905000, '2024-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2040, 928888, '2024-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2041, 1838888, '2024-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2042, 1272000, '2024-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2043, 2110000, '2024-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2044, 1725000, '2024-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2045, 920000, '2024-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2046, 1525000, '2024-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2047, 1388000, '2024-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2048, 1300000, '2024-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2049, 1065000, '2024-12-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2050, 820000, '2024-11-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2051, 2500000, '2025-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2052, 1400000, '2025-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2053, 2400000, '2025-01-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2054, 2218888, '2025-01-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2055, 1358000, '2025-11-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2056, 1780000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2057, 1400000, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2058, 1337000, '2025-12-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2059, 1761000, '2025-10-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2060, 1668000, '2025-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2061, 1597000, '2025-11-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2062, 638888, '2025-11-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2063, 740000, '2025-11-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2064, 1505000, '2025-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2065, 780000, '2025-11-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2066, 1150000, '2026-01-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2067, 1816000, '2026-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2068, 920000, '2026-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2069, 1455000, '2026-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2070, 1105000, '2024-01-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2071, 1150000, '2024-01-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2072, 1150000, '2023-12-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2073, 2800000, '2024-02-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2074, 950000, '2024-02-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2075, 1855000, '2024-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2076, 865000, '2024-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2077, 1361000, '2024-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2078, 1045000, '2024-03-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2079, 1710000, '2024-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2080, 1310000, '2024-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2081, 1448888, '2024-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2082, 625000, '2024-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2083, 1100000, '2024-02-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2084, 1260000, '2024-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2085, 1080000, '2024-02-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2086, 1502000, '2024-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2087, 1380000, '2024-02-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2088, 650000, '2023-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2089, 1450000, '2023-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2090, 850000, '2023-10-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2091, 1500000, '2023-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2092, 515515, '2023-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2093, 1350000, '2023-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2094, 1438000, '2023-09-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2095, 1600000, '2023-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2096, 1675000, '2023-11-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2097, 1828888, '2023-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2098, 1100500, '2023-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2099, 1330000, '2023-10-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2100, 1200000, '2023-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2101, 910000, '2023-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2102, 620000, '2023-11-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2103, 910000, '2023-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2104, 901000, '2023-12-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2105, 1880000, '2023-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2106, 1430000, '2023-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2107, 1085000, '2023-11-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2108, 2150000, '2023-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2109, 1120000, '2023-07-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2110, 1410000, '2023-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2111, 1000000, '2023-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2112, 510000, '2023-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2113, 495000, '2023-08-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2114, 530000, '2023-08-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2115, 480000, '2023-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2116, 1735000, '2023-09-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2117, 776000, '2023-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2118, 276000, '2023-08-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2119, 1040000, '2023-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2120, 1100000, '2023-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2121, 1200000, '2023-08-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2122, 1395000, '2023-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2123, 1250000, '2023-09-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2124, 1660000, '2023-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2125, 1610000, '2023-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2126, 1280000, '2023-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2127, 1300000, '2023-06-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2128, 1965000, '2023-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2129, 1550000, '2023-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2130, 1490000, '2023-07-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2131, 591000, '2023-06-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2132, 1250000, '2023-05-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2133, 777777, '2023-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2134, 1820888, '2023-06-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2135, 1150000, '2023-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2136, 1250000, '2023-05-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2137, 1280000, '2023-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2138, 1039500, '2023-05-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2139, 520000, '2023-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2140, 1600000, '2023-06-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2141, 1100000, '2023-06-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2142, 600000, '2023-06-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2143, 905000, '2023-07-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2144, 1200000, '2023-06-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2145, 1050000, '2023-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2146, 1080000, '2023-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2147, 2350000, '2023-05-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2148, 965000, '2023-02-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2149, 1180000, '2023-03-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2150, 1311000, '2023-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2151, 1086000, '2023-03-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2152, 1280000, '2023-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2153, 1550000, '2023-03-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2154, 485000, '2023-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2155, 885000, '2023-03-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2156, 1301000, '2023-04-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2157, 1588000, '2023-04-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2158, 580000, '2023-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2159, 1199500, '2023-05-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2160, 980000, '2023-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2161, 1146000, '2023-05-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2162, 1252000, '2023-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2163, 2100000, '2023-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2164, 1745000, '2023-04-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2165, 1038000, '2023-03-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2166, 1425000, '2022-11-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2167, 1801000, '2022-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2168, 888888, '2023-01-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2169, 1015000, '2022-10-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2170, 895000, '2022-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2171, 720000, '2022-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2172, 950000, '2022-11-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2173, 550000, '2022-10-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2174, 1080000, '2022-10-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2175, 6200000, '2022-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2176, 1060000, '2022-11-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2177, 333000, '2023-01-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2178, 1410000, '2023-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2179, 1200000, '2022-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2180, 2000000, '2023-01-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2181, 516000, '2023-01-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2182, 1085000, '2023-01-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2183, 1320000, '2023-01-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2184, 795000, '2022-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2185, 1398000, '2022-09-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2186, 475000, '2022-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2187, 823000, '2022-07-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2188, 1992000, '2022-07-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2189, 1325000, '2022-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2190, 850000, '2022-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2191, 1250000, '2022-07-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2192, 420000, '2022-09-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2193, 1458000, '2022-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2194, 800000, '2022-07-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2195, 1000000, '2022-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2196, 1290000, '2022-08-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2197, 460000, '2022-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2198, 1200000, '2022-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2199, 1215000, '2022-10-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2200, 1680000, '2022-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2201, 1058888, '2022-09-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2202, 1828000, '2022-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2203, 850000, '2022-09-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2204, 595000, '2022-04-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2205, 815000, '2022-04-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2206, 1800000, '2022-04-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2207, 905000, '2022-05-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2208, 300000, '2022-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2209, 788000, '2022-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2210, 1605000, '2022-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2211, 725000, '2022-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2212, 1190000, '2022-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2213, 1928888, '2022-05-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2214, 1608000, '2022-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2215, 1120000, '2022-05-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2216, 888000, '2022-05-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2217, 405000, '2022-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2218, 1118088, '2022-05-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2219, 1680000, '2022-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2220, 1588000, '2022-06-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2221, 1390000, '2022-06-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2222, 649000, '2022-06-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2223, 935000, '2022-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2224, 1800000, '2022-02-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2225, 395000, '2022-03-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2226, 855000, '2022-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2227, 1361000, '2022-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2228, 955000, '2022-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2229, 1365000, '2022-02-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2230, 1060000, '2022-03-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2231, 630000, '2022-02-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2232, 830000, '2022-03-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2233, 780000, '2022-03-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2234, 795000, '2022-03-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2235, 1680000, '2022-03-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2236, 2500000, '2022-03-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2237, 475000, '2022-03-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2238, 1002000, '2022-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2239, 1725000, '2022-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2240, 896000, '2022-03-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2241, 680000, '2022-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2242, 905000, '2022-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2243, 625000, '2022-04-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2244, 880000, '2021-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2245, 752000, '2021-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2246, 850000, '2021-11-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2247, 980000, '2021-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2248, 1100000, '2021-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2249, 1280000, '2021-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2250, 990000, '2021-11-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2251, 1250000, '2021-12-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2252, 1700000, '2022-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2253, 965000, '2021-11-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2254, 1266000, '2021-12-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2255, 820000, '2022-01-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2256, 1550000, '2021-12-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2257, 1350000, '2021-10-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2258, 1500000, '2022-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2259, 1960000, '2022-01-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2260, 1200888, '2022-02-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2261, 1120000, '2022-01-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2262, 1518000, '2025-09-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2263, 2250000, '2025-08-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2264, 1645000, '2025-09-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2265, 1588000, '2025-09-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2266, 800000, '2025-08-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2267, 1352500, '2025-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2268, 1710000, '2025-08-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2269, 1040000, '2025-08-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2270, 825000, '2025-08-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2271, 750000, '2025-08-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2272, 1580000, '2025-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2273, 2180000, '2025-09-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2274, 1598000, '2025-09-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2275, 1952000, '2025-10-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2276, 1280000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2277, 1852000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2278, 1450000, '2025-10-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2279, 755000, '2021-09-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2280, 2370000, '2021-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2281, 1090000, '2021-09-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2282, 840000, '2021-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2283, 881000, '2021-09-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2284, 1225000, '2021-09-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2285, 2400000, '2021-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2286, 2028000, '2021-09-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2287, 400000, '2021-09-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2288, 867000, '2021-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2289, 840000, '2021-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2290, 730000, '2021-10-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2291, 435000, '2021-10-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2292, 1291000, '2021-10-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2293, 1100000, '2021-10-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2294, 1040000, '2021-10-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2295, 980000, '2021-10-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2296, 1458000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2297, 1308000, '2025-06-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2298, 2178888, '2025-07-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2299, 1330000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2300, 1280000, '2025-06-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2301, 1300000, '2025-07-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2302, 1200000, '2025-07-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2303, 1782000, '2025-05-31');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2304, 2270000, '2025-06-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2305, 968000, '2025-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2306, 2600000, '2025-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2307, 2452000, '2025-06-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2308, 915000, '2025-07-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2309, 1730000, '2025-07-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2310, 1070000, '2025-07-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2311, 890000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2312, 1311000, '2025-03-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2313, 1120000, '2025-05-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2314, 2280000, '2025-04-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2315, 3026800, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2316, 1518000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2317, 1400500, '2025-04-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2318, 901000, '2025-04-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2319, 1545000, '2025-05-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2320, 630000, '2025-04-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2321, 1300000, '2025-04-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2322, 1320000, '2025-04-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2323, 1535000, '2025-05-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2324, 1395000, '2025-05-26');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2325, 1007000, '2025-05-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2326, 710000, '2025-01-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2327, 1520000, '2025-02-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2328, 1881000, '2025-01-14');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2329, 685000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2330, 1590000, '2025-02-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2331, 950000, '2025-02-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2332, 928000, '2025-01-15');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2333, 1683500, '2025-02-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2334, 2750000, '2025-01-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2335, 726000, '2025-01-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2336, 1620000, '2025-02-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2337, 1310000, '2025-03-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2338, 1850000, '2025-02-19');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2339, 1690000, '2025-03-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2340, 1712000, '2025-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2341, 1734300, '2025-03-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2342, 1520000, '2025-02-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2343, 1040000, '2025-01-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2344, 1000000, '2025-01-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2345, 1811000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2346, 1352000, '2024-11-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2347, 1250000, '2024-12-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2348, 905000, '2024-12-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2349, 3288888, '2024-11-09');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2350, 1780000, '2024-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2351, 2255000, '2024-11-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2352, 885000, '2024-11-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2353, 800000, '2024-11-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2354, 902000, '2024-11-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2355, 900000, '2024-12-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2356, 1275000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2357, 972000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2358, 1440000, '2024-12-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2359, 1105000, '2024-11-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2360, 1583000, '2024-12-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2361, 1110000, '2025-01-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2362, 2350000, '2024-11-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2363, 4000000, '2024-10-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2364, 1350000, '2024-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2365, 915000, '2024-10-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2366, 1400000, '2024-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2367, 1150000, '2024-10-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2368, 780000, '2024-10-21');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2369, 1100000, '2024-09-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2370, 1102500, '2024-10-02');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2371, 600000, '2024-08-30');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2372, 810000, '2024-09-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2373, 1351500, '2024-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2374, 1580000, '2024-10-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2375, 1458000, '2024-10-05');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2376, 1550000, '2024-10-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2377, 1150000, '2024-09-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2378, 1107000, '2024-10-12');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2379, 610000, '2024-09-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2380, 860000, '2024-10-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2381, 2300000, '2024-11-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2382, 1335000, '2024-10-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2383, 1050000, '2024-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2384, 1111111, '2024-06-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2385, 2218888, '2024-07-16');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2386, 768500, '2024-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2387, 1180000, '2024-06-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2388, 1060000, '2024-07-04');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2389, 1320000, '2024-07-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2390, 1467000, '2024-06-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2391, 1680000, '2024-07-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2392, 2150000, '2024-07-22');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2393, 965000, '2024-07-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2394, 900000, '2024-07-17');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2395, 1260000, '2024-07-27');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2396, 1560000, '2024-08-10');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2397, 1246000, '2024-08-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2398, 900000, '2024-07-01');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2399, 605000, '2024-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2400, 1750000, '2024-05-24');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2401, 1500000, '2024-05-28');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2402, 1350000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2403, 1368000, '2024-03-23');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2404, 2050000, '2024-03-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2405, 985000, '2024-03-13');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2406, 2725000, '2024-04-20');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2407, 1300000, '2024-05-29');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2408, 1140000, '2024-05-03');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2409, 1640000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2410, 1300000, '2024-05-11');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2411, 1075000, '2024-05-07');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2412, 1500000, '2024-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2413, 1113000, '2024-05-25');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2414, 1300000, '2024-04-18');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2415, 1250000, '2024-06-08');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2416, 810000, '2024-06-06');
INSERT INTO sales (property_id, sold_price, sold_date)
VALUES (2417, 1472000, '2024-06-11');
