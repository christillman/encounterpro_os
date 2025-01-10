
/*
SELECT '(''Country_Phone_Prefix'', ''' + [list_item_id] + ''', ''+'', ' + convert(varchar(4),[sort_sequence]) + ', ''' + [status] + '''), -- ' + list_item
  FROM [EncounterPro_OS].[dbo].[c_List_Item]
  where list_id = 'Country'
  order by list_item
  */
IF NOT EXISTS (SELECT 1 FROM [c_List_Item] WHERE list_id = 'Country_Phone_Prefix')
INSERT INTO [c_List_Item] (
	 [list_id]
      ,[list_item_id]
      ,[list_item]
      ,[sort_sequence]
      ,[status]
	  )
VALUES
('Country_Phone_Prefix', 'AF', '+93', 0, 'OK'), -- Afghanistan
('Country_Phone_Prefix', 'AX', '+358 (18)', 0, 'OK'), -- Åland Islands
('Country_Phone_Prefix', 'AL', '+355', 0, 'OK'), -- Albania
('Country_Phone_Prefix', 'DZ', '+213', 0, 'OK'), -- Algeria
('Country_Phone_Prefix', 'AS', '+1 (684)', 0, 'OK'), -- American Samoa
('Country_Phone_Prefix', 'AD', '+376', 0, 'OK'), -- Andorra
('Country_Phone_Prefix', 'AO', '+244', 0, 'OK'), -- Angola
('Country_Phone_Prefix', 'AI', '+1 (264)', 0, 'OK'), -- Anguilla
('Country_Phone_Prefix', 'AQ', '+672', 0, 'OK'), -- Antarctica
('Country_Phone_Prefix', 'AG', '+1 (268)', 0, 'OK'), -- Antigua & Barbuda
('Country_Phone_Prefix', 'AR', '+54', 0, 'OK'), -- Argentina
('Country_Phone_Prefix', 'AM', '+374', 0, 'OK'), -- Armenia
('Country_Phone_Prefix', 'AW', '+297', 0, 'OK'), -- Aruba
('Country_Phone_Prefix', 'AC', '+247', 0, 'OK'), -- Ascension Island
('Country_Phone_Prefix', 'AU', '+61', 0, 'OK'), -- Australia
('Country_Phone_Prefix', 'AT', '+43', 0, 'OK'), -- Austria
('Country_Phone_Prefix', 'AZ', '+994', 0, 'OK'), -- Azerbaijan
('Country_Phone_Prefix', 'BS', '+1 (242)', 0, 'OK'), -- Bahamas
('Country_Phone_Prefix', 'BH', '+973', 0, 'OK'), -- Bahrain
('Country_Phone_Prefix', 'BD', '+880', 0, 'OK'), -- Bangladesh
('Country_Phone_Prefix', 'BB', '+1 (246)', 0, 'OK'), -- Barbados
('Country_Phone_Prefix', 'BY', '+375', 0, 'OK'), -- Belarus
('Country_Phone_Prefix', 'BE', '+32', 0, 'OK'), -- Belgium
('Country_Phone_Prefix', 'BZ', '+501', 0, 'OK'), -- Belize
('Country_Phone_Prefix', 'BJ', '+229', 0, 'OK'), -- Benin
('Country_Phone_Prefix', 'BM', '+1 (441)', 0, 'OK'), -- Bermuda
('Country_Phone_Prefix', 'BT', '+975', 0, 'OK'), -- Bhutan
('Country_Phone_Prefix', 'BO', '+591', 0, 'OK'), -- Bolivia
('Country_Phone_Prefix', 'BA', '+387', 0, 'OK'), -- Bosnia & Herzegovina
('Country_Phone_Prefix', 'BW', '+267', 0, 'OK'), -- Botswana
('Country_Phone_Prefix', 'BR', '+55', 0, 'OK'), -- Brazil
('Country_Phone_Prefix', 'IO', '+246', 0, 'OK'), -- British Indian Ocean Territory
('Country_Phone_Prefix', 'VG', '+1 (284)', 0, 'OK'), -- British Virgin Islands
('Country_Phone_Prefix', 'BN', '+673', 0, 'OK'), -- Brunei
('Country_Phone_Prefix', 'BG', '+359', 0, 'OK'), -- Bulgaria
('Country_Phone_Prefix', 'BF', '+226', 0, 'OK'), -- Burkina Faso
('Country_Phone_Prefix', 'BI', '+257', 0, 'OK'), -- Burundi
('Country_Phone_Prefix', 'KH', '+855', 0, 'OK'), -- Cambodia
('Country_Phone_Prefix', 'CM', '+237', 0, 'OK'), -- Cameroon
('Country_Phone_Prefix', 'CA', '+1', 0, 'OK'), -- Canada
('Country_Phone_Prefix', 'IC', '+34', 0, 'OK'), -- Canary Islands
('Country_Phone_Prefix', 'CV', '+238', 0, 'OK'), -- Cape Verde
('Country_Phone_Prefix', 'BQ', '+599 (3,4,7)', 0, 'OK'), -- Caribbean Netherlands
('Country_Phone_Prefix', 'KY', '+1 (345)', 0, 'OK'), -- Cayman Islands
('Country_Phone_Prefix', 'CF', '+236', 0, 'OK'), -- Central African Republic
('Country_Phone_Prefix', 'EA', '+34', 0, 'OK'), -- Ceuta & Melilla
('Country_Phone_Prefix', 'TD', '+235', 0, 'OK'), -- Chad
('Country_Phone_Prefix', 'CL', '+56', 0, 'OK'), -- Chile
('Country_Phone_Prefix', 'CN', '+86', 0, 'OK'), -- China
('Country_Phone_Prefix', 'CX', '+61 (89164)', 0, 'OK'), -- Christmas Island
('Country_Phone_Prefix', 'CC', '+61 (89162)', 0, 'OK'), -- Cocos (Keeling) Islands
('Country_Phone_Prefix', 'CO', '+57', 0, 'OK'), -- Colombia
('Country_Phone_Prefix', 'KM', '+269', 0, 'OK'), -- Comoros
('Country_Phone_Prefix', 'CG', '+242', 0, 'OK'), -- Congo - Brazzaville
('Country_Phone_Prefix', 'CD', '+243', 0, 'OK'), -- Congo - Kinshasa
('Country_Phone_Prefix', 'CK', '+682', 0, 'OK'), -- Cook Islands
('Country_Phone_Prefix', 'CR', '+506', 0, 'OK'), -- Costa Rica
('Country_Phone_Prefix', 'CI', '+225', 0, 'OK'), -- Côte d’Ivoire
('Country_Phone_Prefix', 'HR', '+385', 0, 'OK'), -- Croatia
('Country_Phone_Prefix', 'CU', '+53', 0, 'OK'), -- Cuba
('Country_Phone_Prefix', 'CW', '+599 (9)', 0, 'OK'), -- Curaçao
('Country_Phone_Prefix', 'CY', '+357', 0, 'OK'), -- Cyprus
('Country_Phone_Prefix', 'CZ', '+420', 0, 'OK'), -- Czechia
('Country_Phone_Prefix', 'DK', '+45', 0, 'OK'), -- Denmark
('Country_Phone_Prefix', 'DG', '+246', 0, 'OK'), -- Diego Garcia
('Country_Phone_Prefix', 'DJ', '+253', 0, 'OK'), -- Djibouti
('Country_Phone_Prefix', 'DM', '+1 (767)', 0, 'OK'), -- Dominica
('Country_Phone_Prefix', 'DO', '+1 (809, 829, 849)', 0, 'OK'), -- Dominican Republic
('Country_Phone_Prefix', 'EC', '+593', 0, 'OK'), -- Ecuador
('Country_Phone_Prefix', 'EG', '+20', 0, 'OK'), -- Egypt
('Country_Phone_Prefix', 'SV', '+503', 0, 'OK'), -- El Salvador
('Country_Phone_Prefix', 'GQ', '+240', 0, 'OK'), -- Equatorial Guinea
('Country_Phone_Prefix', 'ER', '+291', 40, 'Active'), -- Eritrea
('Country_Phone_Prefix', 'EE', '+372', 0, 'OK'), -- Estonia
('Country_Phone_Prefix', 'ET', '+251', 30, 'Active'), -- Ethiopia
('Country_Phone_Prefix', 'EZ', '+971', 0, 'OK'), -- Eurozone
('Country_Phone_Prefix', 'FK', '+500', 0, 'OK'), -- Falkland Islands
('Country_Phone_Prefix', 'FO', '+298', 0, 'OK'), -- Faroe Islands
('Country_Phone_Prefix', 'FJ', '+679', 0, 'OK'), -- Fiji
('Country_Phone_Prefix', 'FI', '+358', 0, 'OK'), -- Finland
('Country_Phone_Prefix', 'FR', '+33', 0, 'OK'), -- France
('Country_Phone_Prefix', 'GF', '+594', 0, 'OK'), -- French Guiana
('Country_Phone_Prefix', 'PF', '+689', 0, 'OK'), -- French Polynesia
('Country_Phone_Prefix', 'TF', '+596', 0, 'OK'), -- French Southern Territories
('Country_Phone_Prefix', 'GA', '+241', 0, 'OK'), -- Gabon
('Country_Phone_Prefix', 'GM', '+220', 0, 'OK'), -- Gambia
('Country_Phone_Prefix', 'GE', '+995', 0, 'OK'), -- Georgia
('Country_Phone_Prefix', 'DE', '+49', 0, 'OK'), -- Germany
('Country_Phone_Prefix', 'GH', '+233', 0, 'OK'), -- Ghana
('Country_Phone_Prefix', 'GI', '+350', 0, 'OK'), -- Gibraltar
('Country_Phone_Prefix', 'GR', '+30', 0, 'OK'), -- Greece
('Country_Phone_Prefix', 'GL', '+299', 0, 'OK'), -- Greenland
('Country_Phone_Prefix', 'GD', '+1 (473)', 0, 'OK'), -- Grenada
('Country_Phone_Prefix', 'GP', '+590', 0, 'OK'), -- Guadeloupe
('Country_Phone_Prefix', 'GU', '+1 (671)', 0, 'OK'), -- Guam
('Country_Phone_Prefix', 'GT', '+502', 0, 'OK'), -- Guatemala
('Country_Phone_Prefix', 'GG', '+44 (1481, 7781, 7839, 7911)', 0, 'OK'), -- Guernsey
('Country_Phone_Prefix', 'GN', '+224', 0, 'OK'), -- Guinea
('Country_Phone_Prefix', 'GW', '+245', 0, 'OK'), -- Guinea-Bissau
('Country_Phone_Prefix', 'GY', '+592', 0, 'OK'), -- Guyana
('Country_Phone_Prefix', 'HT', '+509', 0, 'OK'), -- Haiti
('Country_Phone_Prefix', 'HN', '+504', 0, 'OK'), -- Honduras
('Country_Phone_Prefix', 'HK', '+852', 0, 'OK'), -- Hong Kong SAR China
('Country_Phone_Prefix', 'HU', '+36', 0, 'OK'), -- Hungary
('Country_Phone_Prefix', 'IS', '+354', 0, 'OK'), -- Iceland
('Country_Phone_Prefix', 'IN', '+91', 0, 'OK'), -- India
('Country_Phone_Prefix', 'ID', '+62', 0, 'OK'), -- Indonesia
('Country_Phone_Prefix', 'IR', '+98', 0, 'OK'), -- Iran
('Country_Phone_Prefix', 'IQ', '+964', 0, 'OK'), -- Iraq
('Country_Phone_Prefix', 'IE', '+353', 0, 'OK'), -- Ireland
('Country_Phone_Prefix', 'IM', '+44 (1624, 7524, 7624, 7924)', 0, 'OK'), -- Isle of Man
('Country_Phone_Prefix', 'IL', '+972', 0, 'OK'), -- Israel
('Country_Phone_Prefix', 'IT', '+39', 0, 'OK'), -- Italy
('Country_Phone_Prefix', 'JM', '+1 (658, 876)', 0, 'OK'), -- Jamaica
('Country_Phone_Prefix', 'JP', '+81', 0, 'OK'), -- Japan
('Country_Phone_Prefix', 'JE', '+44 (1534)', 0, 'OK'), -- Jersey
('Country_Phone_Prefix', 'JO', '+962', 0, 'OK'), -- Jordan
('Country_Phone_Prefix', 'KZ', '+7 (6, 7)', 0, 'OK'), -- Kazakhstan
('Country_Phone_Prefix', 'KE', '+254', 80, 'Active'), -- Kenya
('Country_Phone_Prefix', 'KI', '+686', 0, 'OK'), -- Kiribati
('Country_Phone_Prefix', 'XK', '+383', 0, 'OK'), -- Kosovo
('Country_Phone_Prefix', 'KW', '+965', 0, 'OK'), -- Kuwait
('Country_Phone_Prefix', 'KG', '+996', 0, 'OK'), -- Kyrgyzstan
('Country_Phone_Prefix', 'LA', '+856', 0, 'OK'), -- Laos
('Country_Phone_Prefix', 'LV', '+371', 0, 'OK'), -- Latvia
('Country_Phone_Prefix', 'LB', '+961', 0, 'OK'), -- Lebanon
('Country_Phone_Prefix', 'LS', '+266', 0, 'OK'), -- Lesotho
('Country_Phone_Prefix', 'LR', '+231', 0, 'OK'), -- Liberia
('Country_Phone_Prefix', 'LY', '+218', 0, 'OK'), -- Libya
('Country_Phone_Prefix', 'LI', '+423', 0, 'OK'), -- Liechtenstein
('Country_Phone_Prefix', 'LT', '+370', 0, 'OK'), -- Lithuania
('Country_Phone_Prefix', 'LU', '+352', 0, 'OK'), -- Luxembourg
('Country_Phone_Prefix', 'MO', '+853', 0, 'OK'), -- Macau SAR China
('Country_Phone_Prefix', 'MK', '+389', 0, 'OK'), -- Macedonia
('Country_Phone_Prefix', 'MG', '+261', 0, 'OK'), -- Madagascar
('Country_Phone_Prefix', 'MW', '+265', 0, 'OK'), -- Malawi
('Country_Phone_Prefix', 'MY', '+60', 0, 'OK'), -- Malaysia
('Country_Phone_Prefix', 'MV', '+960', 0, 'OK'), -- Maldives
('Country_Phone_Prefix', 'ML', '+223', 0, 'OK'), -- Mali
('Country_Phone_Prefix', 'MT', '+356', 0, 'OK'), -- Malta
('Country_Phone_Prefix', 'MH', '+692', 0, 'OK'), -- Marshall Islands
('Country_Phone_Prefix', 'MQ', '+596', 0, 'OK'), -- Martinique
('Country_Phone_Prefix', 'MR', '+222', 0, 'OK'), -- Mauritania
('Country_Phone_Prefix', 'MU', '+230', 0, 'OK'), -- Mauritius
('Country_Phone_Prefix', 'YT', '+262 (269, 639)', 0, 'OK'), -- Mayotte
('Country_Phone_Prefix', 'MX', '+52', 0, 'OK'), -- Mexico
('Country_Phone_Prefix', 'FM', '+691', 0, 'OK'), -- Micronesia
('Country_Phone_Prefix', 'MD', '+373', 0, 'OK'), -- Moldova
('Country_Phone_Prefix', 'MC', '+377', 0, 'OK'), -- Monaco
('Country_Phone_Prefix', 'MN', '+976', 0, 'OK'), -- Mongolia
('Country_Phone_Prefix', 'ME', '+382', 0, 'OK'), -- Montenegro
('Country_Phone_Prefix', 'MS', '+1 (664)', 0, 'OK'), -- Montserrat
('Country_Phone_Prefix', 'MA', '+212', 0, 'OK'), -- Morocco
('Country_Phone_Prefix', 'MZ', '+258', 0, 'OK'), -- Mozambique
('Country_Phone_Prefix', 'MM', '+95', 0, 'OK'), -- Myanmar (Burma)
('Country_Phone_Prefix', 'NA', '+264', 0, 'OK'), -- Namibia
('Country_Phone_Prefix', 'NR', '+674', 0, 'OK'), -- Nauru
('Country_Phone_Prefix', 'NP', '+977', 0, 'OK'), -- Nepal
('Country_Phone_Prefix', 'NL', '+31', 0, 'OK'), -- Netherlands
('Country_Phone_Prefix', 'NC', '+687', 0, 'OK'), -- New Caledonia
('Country_Phone_Prefix', 'NZ', '+64', 0, 'OK'), -- New Zealand
('Country_Phone_Prefix', 'NI', '+505', 0, 'OK'), -- Nicaragua
('Country_Phone_Prefix', 'NE', '+227', 0, 'OK'), -- Niger
('Country_Phone_Prefix', 'NG', '+234', 0, 'OK'), -- Nigeria
('Country_Phone_Prefix', 'NU', '+683', 0, 'OK'), -- Niue
('Country_Phone_Prefix', 'NF', '+672 (3)', 0, 'OK'), -- Norfolk Island
('Country_Phone_Prefix', 'KP', '+850', 0, 'OK'), -- North Korea
('Country_Phone_Prefix', 'MP', '+1 (670)', 0, 'OK'), -- Northern Mariana Islands
('Country_Phone_Prefix', 'NO', '+47', 0, 'OK'), -- Norway
('Country_Phone_Prefix', 'OM', '+968', 0, 'OK'), -- Oman
('Country_Phone_Prefix', 'PK', '+92', 0, 'OK'), -- Pakistan
('Country_Phone_Prefix', 'PW', '+680', 0, 'OK'), -- Palau
('Country_Phone_Prefix', 'PS', '+970', 0, 'OK'), -- Palestinian Territories
('Country_Phone_Prefix', 'PA', '+507', 0, 'OK'), -- Panama
('Country_Phone_Prefix', 'PG', '+675', 0, 'OK'), -- Papua New Guinea
('Country_Phone_Prefix', 'PY', '+595', 0, 'OK'), -- Paraguay
('Country_Phone_Prefix', 'PE', '+51', 0, 'OK'), -- Peru
('Country_Phone_Prefix', 'PH', '+63', 0, 'OK'), -- Philippines
('Country_Phone_Prefix', 'PN', '+64', 0, 'OK'), -- Pitcairn Islands
('Country_Phone_Prefix', 'PL', '+48', 0, 'OK'), -- Poland
('Country_Phone_Prefix', 'PT', '+351', 0, 'OK'), -- Portugal
('Country_Phone_Prefix', 'PR', '+1 (787, 930)', 0, 'OK'), -- Puerto Rico
('Country_Phone_Prefix', 'QA', '+974', 0, 'OK'), -- Qatar
('Country_Phone_Prefix', 'RE', '+262', 0, 'OK'), -- Réunion
('Country_Phone_Prefix', 'RO', '+40', 0, 'OK'), -- Romania
('Country_Phone_Prefix', 'RU', '+7', 0, 'OK'), -- Russia
('Country_Phone_Prefix', 'RW', '+250', 60, 'Active'), -- Rwanda
('Country_Phone_Prefix', 'WS', '+685', 0, 'OK'), -- Samoa
('Country_Phone_Prefix', 'SM', '+378', 0, 'OK'), -- San Marino
('Country_Phone_Prefix', 'ST', '+239', 0, 'OK'), -- São Tomé & Príncipe
('Country_Phone_Prefix', 'SA', '+966', 0, 'OK'), -- Saudi Arabia
('Country_Phone_Prefix', 'SN', '+221', 0, 'OK'), -- Senegal
('Country_Phone_Prefix', 'RS', '+381', 0, 'OK'), -- Serbia
('Country_Phone_Prefix', 'SC', '+248', 0, 'OK'), -- Seychelles
('Country_Phone_Prefix', 'SL', '+232', 0, 'OK'), -- Sierra Leone
('Country_Phone_Prefix', 'SG', '+65', 0, 'OK'), -- Singapore
('Country_Phone_Prefix', 'SX', '+1 (721)', 0, 'OK'), -- Sint Maarten
('Country_Phone_Prefix', 'SK', '+421', 0, 'OK'), -- Slovakia
('Country_Phone_Prefix', 'SI', '+386', 0, 'OK'), -- Slovenia
('Country_Phone_Prefix', 'SB', '+677', 0, 'OK'), -- Solomon Islands
('Country_Phone_Prefix', 'SO', '+252', 50, 'Active'), -- Somalia
('Country_Phone_Prefix', 'ZA', '+27', 0, 'OK'), -- South Africa
('Country_Phone_Prefix', 'GS', '+500', 0, 'OK'), -- South Georgia & South Sandwich Islands
('Country_Phone_Prefix', 'KR', '+82', 0, 'OK'), -- South Korea
('Country_Phone_Prefix', 'SS', '+211', 20, 'Active'), -- South Sudan
('Country_Phone_Prefix', 'ES', '+34', 0, 'OK'), -- Spain
('Country_Phone_Prefix', 'LK', '+94', 0, 'OK'), -- Sri Lanka
('Country_Phone_Prefix', 'BL', '+590', 0, 'OK'), -- St. Barthélemy
('Country_Phone_Prefix', 'SH', '+290', 0, 'OK'), -- St. Helena
('Country_Phone_Prefix', 'KN', '+1 (869)', 0, 'OK'), -- St. Kitts & Nevis
('Country_Phone_Prefix', 'LC', '+1 (758)', 0, 'OK'), -- St. Lucia
('Country_Phone_Prefix', 'MF', '+590', 0, 'OK'), -- St. Martin
('Country_Phone_Prefix', 'PM', '+508', 0, 'OK'), -- St. Pierre & Miquelon
('Country_Phone_Prefix', 'VC', '+1 (784)', 0, 'OK'), -- St. Vincent & Grenadines
('Country_Phone_Prefix', 'SD', '+249', 0, 'OK'), -- Sudan
('Country_Phone_Prefix', 'SR', '+597', 0, 'OK'), -- Suriname
('Country_Phone_Prefix', 'SJ', '+47 (79)', 0, 'OK'), -- Svalbard & Jan Mayen
('Country_Phone_Prefix', 'SZ', '+268', 0, 'OK'), -- Swaziland
('Country_Phone_Prefix', 'SE', '+46', 0, 'OK'), -- Sweden
('Country_Phone_Prefix', 'CH', '+41', 0, 'OK'), -- Switzerland
('Country_Phone_Prefix', 'SY', '+963', 0, 'OK'), -- Syria
('Country_Phone_Prefix', 'TW', '+886', 0, 'OK'), -- Taiwan
('Country_Phone_Prefix', 'TJ', '+992', 0, 'OK'), -- Tajikistan
('Country_Phone_Prefix', 'TZ', '+255', 70, 'Active'), -- Tanzania
('Country_Phone_Prefix', 'TH', '+66', 0, 'OK'), -- Thailand
('Country_Phone_Prefix', 'TL', '+670', 0, 'OK'), -- Timor-Leste
('Country_Phone_Prefix', 'TG', '+228', 0, 'OK'), -- Togo
('Country_Phone_Prefix', 'TK', '+690', 0, 'OK'), -- Tokelau
('Country_Phone_Prefix', 'TO', '+676', 0, 'OK'), -- Tonga
('Country_Phone_Prefix', 'TT', '+1 (868)', 0, 'OK'), -- Trinidad & Tobago
('Country_Phone_Prefix', 'TA', '+290 (8)', 0, 'OK'), -- Tristan da Cunha
('Country_Phone_Prefix', 'TN', '+216', 0, 'OK'), -- Tunisia
('Country_Phone_Prefix', 'TR', '+90', 0, 'OK'), -- Turkey
('Country_Phone_Prefix', 'TM', '+993', 0, 'OK'), -- Turkmenistan
('Country_Phone_Prefix', 'TC', '+1 (649)', 0, 'OK'), -- Turks & Caicos Islands
('Country_Phone_Prefix', 'TV', '+688', 0, 'OK'), -- Tuvalu
('Country_Phone_Prefix', 'UM', '+1', 0, 'OK'), -- U.S. Outlying Islands
('Country_Phone_Prefix', 'VI', '+1 (340)', 0, 'OK'), -- U.S. Virgin Islands
('Country_Phone_Prefix', 'UG', '+256', 10, 'Active'), -- Uganda
('Country_Phone_Prefix', 'UA', '+380', 0, 'OK'), -- Ukraine
('Country_Phone_Prefix', 'AE', '+971', 0, 'OK'), -- United Arab Emirates
('Country_Phone_Prefix', 'GB', '+44', 0, 'OK'), -- United Kingdom
('Country_Phone_Prefix', 'UN', '+1 (212)', 0, 'OK'), -- United Nations
('Country_Phone_Prefix', 'US', '+1', 0, 'OK'), -- United States
('Country_Phone_Prefix', 'UY', '+598', 0, 'OK'), -- Uruguay
('Country_Phone_Prefix', 'UZ', '+998', 0, 'OK'), -- Uzbekistan
('Country_Phone_Prefix', 'VU', '+678', 0, 'OK'), -- Vanuatu
('Country_Phone_Prefix', 'VA', '+39 (06698)', 0, 'OK'), -- Vatican City
('Country_Phone_Prefix', 'VE', '+58', 0, 'OK'), -- Venezuela
('Country_Phone_Prefix', 'VN', '+84', 0, 'OK'), -- Vietnam
('Country_Phone_Prefix', 'WF', '+681', 0, 'OK'), -- Wallis & Futuna
('Country_Phone_Prefix', 'EH', '+212', 0, 'OK'), -- Western Sahara
('Country_Phone_Prefix', 'YE', '+967', 0, 'OK'), -- Yemen
('Country_Phone_Prefix', 'ZM', '+260', 0, 'OK'), -- Zambia
('Country_Phone_Prefix', 'ZW', '+263', 0, 'OK') -- Zimbabwe

-- Update for existing patients

-- Be sure phone is stripped with new version of dbo.fn_pretty_phone
UPDATE p_Patient
SET phone_number = dbo.fn_pretty_phone(phone_number)
WHERE created BETWEEN '2019-01-01' AND '2023-09-01'

-- Populate the Country_Phone_Prefix if not previously entered, based on Passport country
INSERT INTO [dbo].[p_patient_list_item] (cpr_id, list_id, list_item)
SELECT p.cpr_id, -- p.Last_Name, c.list_item, li.list_item_id, p.phone_number, 
	li.list_id,
	li.list_item
FROM p_Patient p
LEFT JOIN [dbo].[p_patient_list_item] c ON c.cpr_id = p.cpr_id AND c.list_id = 'Country'
LEFT JOIN [dbo].[c_List_Item] lic ON lic.list_id = c.list_id AND lic.list_item = c.list_item
LEFT JOIN [dbo].[c_List_Item] li ON li.list_item_id = lic.list_item_id AND li.list_id = 'Country_Phone_Prefix'
LEFT JOIN [dbo].[p_patient_list_item] cpp ON li.list_id = cpp.list_id AND cpp.cpr_id = p.cpr_id
WHERE p.created BETWEEN '2019-01-01' AND '2023-09-01'
AND left(p.phone_number,1) = '0'
AND cpp.list_id IS NULL
