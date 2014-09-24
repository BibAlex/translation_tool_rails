/*priorities*/
LOCK TABLES `priorities` WRITE;
INSERT INTO `priorities` VALUES (1,'Very low',5,0),(2,'Low',4,0),(3,'Normal',3,1),(4,'High',2,0),(5,'Top',1,0);
UNLOCK TABLES;

 
/*harvest_batch_type*/
LOCK TABLES `harvest_batch_type` WRITE;
INSERT INTO harvest_batch_type (name) VALUES ('selection phase'),('Updates batch');
UNLOCK TABLES;


/*update_status*/
LOCK TABLES `update_status` WRITE;
INSERT INTO update_status (name) VALUES ('Automatically updated'),('Manually updated from scratch'),('Manually updated from already exisiting data_object');
UNLOCK TABLES;


/*data_types*/
LOCK TABLES `data_types` WRITE;
INSERT INTO `data_types` VALUES (1,'http://purl.org/dc/dcmitype/StillImage','Image','Images'),(2,'http://purl.org/dc/dcmitype/Sound','Sound','Video/Audio'),(3,'http://purl.org/dc/dcmitype/Text','Text','Table of Contents'),(4,'http://purl.org/dc/dcmitype/MovingImage','Video','Video/Audio'),(5,'','GBIF Image','Images'),(6,'IUCN','IUCN','Images'),(7,'Flash','Flash','Video/Audio'),(8,'YouTube','YouTube','Video/Audio');
UNLOCK TABLES;


/*users*/
LOCK TABLE `users` WRITE;
INSERT INTO `users` (`name`, `username`, `password`, `super_admin`, `active`, `selector`, `email`, `country_id`, `it_admin`) VALUES ('Test User', 'test', 'password', 1, 1, 1, 'test@user.com', 63, 1);
UNLOCK TABLES;


/*countries*/
LOCK TABLES `countries` WRITE;
INSERT INTO `countries` VALUES ('Andorra',1),('United Arab Emirates',2),('Afghanistan',3),('Antigua and Barbuda',4),('Anguilla',5),('Albania',6),('Armenia',7),('Netherlands Antilles',8),('Angola',9),('Antarctica',10),('Argentina',11),('American Samoa',12),('Austria',13),('Australia',14),('Aruba',15),('Azerbaijan',16),('Bosnia and Herzegovina',17),('Barbados',18),('Bangladesh',19),('Belgium',20),('Burkina Faso',21),('Bulgaria',22),('Bahrain',23),('Burundi',24),('Benin',25),('Bermuda',26),('Brunei Darussalam',27),('Bolivia',28),('Brazil',29),('Bahamas',30),('Bhutan',31),('Bouvet Island',32),('Botswana',33),('Belarus',34),('Belize',35),('Canada',36),('Cocos (Keeling) Islands',37),('Congo, the Democratic Republic of the',38),('Central African Republic',39),('Congo',40),('Switzerland',41),('Cote D\'Ivoire',42),('Cook Islands',43),('Chile',44),('Cameroon',45),('China',46),('Colombia',47),('Costa Rica',48),('Serbia and Montenegro',49),('Cuba',50),('Cape Verde',51),('Christmas Island',52),('Cyprus',53),('Czech Republic',54),('Germany',55),('Djibouti',56),('Denmark',57),('Dominica',58),('Dominican Republic',59),('Algeria',60),('Ecuador',61),('Estonia',62),('Egypt',63),('Western Sahara',64),('Eritrea',65),('Spain',66),('Ethiopia',67),('Finland',68),('Fiji',69),('Falkland Islands (Malvinas)',70),('Micronesia, Federated States of',71),('Faroe Islands',72),('France',73),('Gabon',74),('United Kingdom',75),('Grenada',76),('Georgia',77),('French Guiana',78),('Ghana',79),('Gibraltar',80),('Greenland',81),('Gambia',82),('Guinea',83),('Guadeloupe',84),('Equatorial Guinea',85),('Greece',86),('South Georgia and the South Sandwich Islands',87),('Guatemala',88),('Guam',89),('Guinea-Bissau',90),('Guyana',91),('Hong Kong',92),('Heard Island and Mcdonald Islands',93),('Honduras',94),('Croatia',95),('Haiti',96),('Hungary',97),('Indonesia',98),('Ireland',99),('Israel',100),('India',101),('British Indian Ocean Territory',102),('Iraq',103),('Iran, Islamic Republic of',104),('Iceland',105),('Italy',106),('Jamaica',107),('Jordan',108),('Japan',109),('Kenya',110),('Kyrgyzstan',111),('Cambodia',112),('Kiribati',113),('Comoros',114),('Saint Kitts and Nevis',115),('Korea, Democratic People\'s Republic of',116),('Korea, Republic of',117),('Kuwait',118),('Cayman Islands',119),('Kazakhstan',120),('Lao People\'s Democratic Republic',121),('Lebanon',122),('Saint Lucia',123),('Liechtenstein',124),('Sri Lanka',125),('Liberia',126),('Lesotho',127),('Lithuania',128),('Luxembourg',129),('Latvia',130),('Libyan Arab Jamahiriya',131),('Morocco',132),('Monaco',133),('Moldova, Republic of',134),('Madagascar',135),('Marshall Islands',136),('Macedonia, the Former Yugoslav Republic of',137),('Mali',138),('Myanmar',139),('Mongolia',140),('Macao',141),('Northern Mariana Islands',142),('Martinique',143),('Mauritania',144),('Montserrat',145),('Malta',146),('Mauritius',147),('Maldives',148),('Malawi',149),('Mexico',150),('Malaysia',151),('Mozambique',152),('Namibia',153),('New Caledonia',154),('Niger',155),('Norfolk Island',156),('Nigeria',157),('Nicaragua',158),('Netherlands',159),('Norway',160),('Nepal',161),('Nauru',162),('Niue',163),('New Zealand',164),('Oman',165),('Panama',166),('Peru',167),('French Polynesia',168),('Papua New Guinea',169),('Philippines',170),('Pakistan',171),('Poland',172),('Saint Pierre and Miquelon',173),('Pitcairn',174),('Puerto Rico',175),('Palestinian Territory, Occupied',176),('Portugal',177),('Palau',178),('Paraguay',179),('Qatar',180),('Reunion',181),('Romania',182),('Russian Federation',183),('Rwanda',184),('Saudi Arabia',185),('Solomon Islands',186),('Seychelles',187),('Sudan',188),('Sweden',189),('Singapore',190),('Saint Helena',191),('Slovenia',192),('Svalbard and Jan Mayen',193),('Slovakia',194),('Sierra Leone',195),('San Marino',196),('Senegal',197),('Somalia',198),('Suriname',199),('Sao Tome and Principe',200),('El Salvador',201),('Syrian Arab Republic',202),('Swaziland',203),('Turks and Caicos Islands',204),('Chad',205),('French Southern Territories',206),('Togo',207),('Thailand',208),('Tajikistan',209),('Tokelau',210),('Timor-Leste',211),('Turkmenistan',212),('Tunisia',213),('Tonga',214),('Turkey',215),('Trinidad and Tobago',216),('Tuvalu',217),('Taiwan, Province of China',218),('Tanzania, United Republic of',219),('Ukraine',220),('Uganda',221),('United States Minor Outlying Islands',222),('United States',223),('Uruguay',224),('Uzbekistan',225),('Holy See (Vatican City State)',226),('Saint Vincent and the Grenadines',227),('Venezuela',228),('Virgin Islands, British',229),('Virgin Islands, U.s.',230),('Viet Nam',231),('Vanuatu',232),('Wallis and Futuna',233),('Samoa',234),('Yemen',235),('Mayotte',236),('South Africa',237),('Zambia',238),('Zimbabwe',239);
UNLOCK TABLES;


