
-- Revised from 01_29_2020 KenyaRetentionDrugsUpdate.xlsx
exec sp_remove_epro_drug 0, 'KE', '7754A', 'KEBI7754A', 'KEGI7754A', 'KEB7754A', 'KEG7754A'
exec sp_remove_epro_drug 0, 'KE', '7754B', 'KEBI7754A', 'KEGI7754A', 'KEB7754B', 'KEG7754A'

exec sp_add_epro_drug 0, 0, 'KE', '7754', 'Spacovin 20 MG/ML Injection', 'drotaverine hydrochloride 20 MG/ML Injection', NULL, 'drotaverine'

/*
select 'exec sp_add_epro_drug 0, 0, ''KE'', ''' 
	+ [Kenya Drug Retention No] 
	+ ''', '''+  [Kenya Drug in SBD Version] 
	+ ''', ''' + [Kenya Drug in SCD or PSN Version] 
	+ ''', ''' + [Corresponding SCD RXCUI] 
	+ ''', ''' + Replace(IsNull([Generic Ingredients],'x'),'/',' / ') + ''''
from [dbo].[01_29_2020 KenyaRetentionDrugsUpdate]
where [Kenya Drug Retention No] in (
'No Retention Number',
'10715',
'10985',
'11017',
'11565',
'11568',
'12393',
'1327',
'13863',
'13865',
'13963',
'14150',
'14287',
'14350',
'1563',
'15669',
'15687',
'15935',
'1623',
'16268',
'1731',
'17368',
'1946',
'1977',
'2870',
'2985',
'2992',
'3015A',
'3066',
'3072A',
'3072B',
'3219',
'3301',
'3368',
'3382',
'3653',
'3724',
'3725',
'3810',
'4287',
'4446',
'5219',
'5244',
'5334',
'5644',
'666',
'7058',
'7401',
'7949',
'8288',
'8357',
'8640',
'9110',
'9114',
'9387',
'9505',
'9581',
'9632A',
'9632B',
'9742'
)
order by [Kenya Drug Retention No]
*/

exec sp_add_epro_drug 0, 0, 'KE', '10715', 'Pizomark 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '10985', 'PiptAZO 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '11017', 'piPZO 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '11565', 'Benzapene[1] 1 Million UNITS Injectable Solution', 'benzylpenicillin sodium 1 Million UNITS Injectable Solution', 'No Corresponding SCD RXCUI', 'benzylpenicillin sodium'
exec sp_add_epro_drug 0, 0, 'KE', '11568', 'Yesom 40 MG Delayed Release Oral Capsule', 'esomeprazole magnesium 40 MG Delayed Release Oral Capsule', 'SCD-606730', 'esomeprazole'
exec sp_add_epro_drug 0, 0, 'KE', '12393', 'Injpip-TZ 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '1327', 'Lacoma 0.005 % Ophthalmic Solution', 'latanoprost 0.005 % Ophthalmic Solution', 'PSN-314072', 'latanoprost'
exec sp_add_epro_drug 0, 0, 'KE', '13863', 'Germidine 10 % Antiseptic Topical Solution', 'povidone-iodine 10 % Topical Solution', 'PSN-312564', 'povidone-iodine'
exec sp_add_epro_drug 0, 0, 'KE', '13865', 'Germidine 2 % Antiseptic Mouthwash', 'povidone-iodine 2 % Mouthwash', 'No Corresponding SCD RXCUI', 'povidone-iodine'
exec sp_add_epro_drug 0, 0, 'KE', '13963', 'Quti 150 MG Oral Tablet', 'quetiapine 150 MG Oral Tablet', 'PSN-389201', 'quetiapine'
exec sp_add_epro_drug 0, 0, 'KE', '14150', 'Tiova Rotacap 18 MCG Inhalant Powder Capsule', 'tiotropium bromide 18 MCG Inhalant Powder Capsule', 'PSN-485032', 'tiotropium'
exec sp_add_epro_drug 0, 0, 'KE', '14287', 'Igol 0.66 GM in 1 GM Granules for Oral Solution', 'ispaghula husk 0.66 GM in 1GM Granules for Oral Solution', 'No Corresponding SCD RXCUI', 'ispaghula husk'
exec sp_add_epro_drug 0, 0, 'KE', '14350', 'AsthaDIN 2 MG in 5 ML Oral Solution', 'salbutamol 2 MG in 5 ML Oral Solution', 'SCD-755497', 'salbutamol'
exec sp_add_epro_drug 0, 0, 'KE', '1563', 'Novasept 10 % Topical Ointment', 'povidone-iodine 10 % Topical Ointment', 'PSN-312563', 'povidone-iodine'
exec sp_add_epro_drug 0, 0, 'KE', '15669', 'Valazyd 160 MG Oral Tablet', 'valsartan 160 MG Oral Tablet', 'PSN-349201', 'valsartan'
exec sp_add_epro_drug 0, 0, 'KE', '15687', 'Bdocin 500 MG Oral Tablet', 'capecitabine 500 MG Oral Tablet', 'PSN-200327', 'capecitabine'
exec sp_add_epro_drug 0, 0, 'KE', '15935', 'Tiggy 50 MG in 5 ML Injection', 'tigecycline 50 MG in 5 ML Injection', 'No Corresponding SCD RXCUI', 'tigecycyline'
exec sp_add_epro_drug 0, 0, 'KE', '1623', 'Mydriacyl 1 % Opthalmic Solution', 'tropicamide 10 MG/ML Ophthalmic Solution', 'SCD-314238', 'tropicamide'
exec sp_add_epro_drug 0, 0, 'KE', '16268', 'PiptaZ 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '1731', 'Aurotaz-P 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '17368', 'Fosmol 3000 MG Granules for Oral Solution', 'fosfomycin trometamol 3000 MG Granules for Oral Solution', 'No Corresponding SCD RXCUI', 'fosfomycin'
exec sp_add_epro_drug 0, 0, 'KE', '1946', 'Peglec 118 GM / 2.93 GM / 1.48 GM / 3.37 GM / 11.36 GM Powder for Oral Solution', 'polyethylene glycol 118 GM / sodium chloride 2.93 GM / potassium chloride 1.48 GM / sodium bicarbonate 3.37 GM / Sodium Sulfate 11.36 GM Powder for Oral Solution', 'No Corresponding SCD RXCUI', 'polyethylene glycol / potassium chloride / sodium bicarbonate / sodium chloride / sodium sulfate'
exec sp_add_epro_drug 0, 0, 'KE', '1977', 'Arthrella Oral Tablet', 'boswella serrata resin extract 100 MG / cyperus rotundus tub extract 100 MG / hyoscyamus niger sd extract 20 MG / oil of ricinus communis extract 3 MG / oroxylum indicum rt extract 223.8 MG / purified strychnos nux-vomica sd extract 25 MG / suvarna paan 0.05 MG / vitex negundo lf extract 500 MG / zingiber officinale rz extract 50 MG Oral Tablet', 'No Corresponding SCD RXCUI', 'boswella serrata resin extract / cyperus rotundus tub extract / hyoscyamus niger sd extract / oil of ricinus communis extract / oroxylum indicum rt extract / purified strychnos nux-vomica sd extract / suvarna paan extract / vitex negundo lf extract / zingiber officinale rz extract'
exec sp_add_epro_drug 0, 0, 'KE', '2870', 'Eltroxin 100 MCG Oral Tablet', 'levothyroxine 100 MCG Oral Tablet', 'PSN-892246', 'levothyroxine'
exec sp_add_epro_drug 0, 0, 'KE', '2985', 'Isoryn Adult Drops 1 % Nasal Solution', 'ePHEDrine HCl 1 % Nasal Solution', 'SCD-1115985', 'ePHEDrine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '2992', 'Isoryn Pediatric Drops 0.5 % Nasal Solution', 'ePHEDrine HCl 0.5 % Nasal Solution', 'SCD-1116285', 'ePHEDrine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3015A', 'Dalacin-C 600 MG in 4 ML Injection', 'clindamycin phosphate 600 MG in 4 ML Injection', 'PSN-1737578', 'clindamycin'
exec sp_add_epro_drug 0, 0, 'KE', '3066', 'Rexe-Din 1 % Antiseptic Mouthwash', 'povidone-iodine 1 % Mouthwash', 'SCD-238272', 'povidone-iodine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3072A', 'Spiriva 18 MCG Inhalant Powder Capsule', 'tiotropium bromide 18 MCG Inhalant Powder Capsule', 'PSN-485032', 'tiotropium'
exec sp_add_epro_drug 0, 0, 'KE', '3072B', 'Spiriva Handihaler Inhalation Device', NULL, 'No Corresponding SCD RXCUI', NULL
exec sp_add_epro_drug 0, 0, 'KE', '3219', 'Wokadine 10 % Topical Ointment', 'povidone-iodine 10 % Topical Ointment', 'PSN-312563', 'povidone-iodine'
exec sp_add_epro_drug 0, 0, 'KE', '3301', 'Xalatan 0.005 % Ophthalmic Solution', 'latanoprost 0.005 % Ophthalmic Solution', 'PSN-314072', 'latanoprost'
exec sp_add_epro_drug 0, 0, 'KE', '3368', 'Basalog 100 UNITS/ML Injectable Solution', 'insulin glargine 100 UNITS/ML Injectable Solution', 'PSN-311041', 'insulin glargine'
exec sp_add_epro_drug 0, 0, 'KE', '3382', 'No Brand Name (generic name is brand name provided)', '10 ML potassium chloride 15 % (150 MG/ML) Injectable Solution', 'No Corresponding SCD RXCUI', 'potassium chloride'
exec sp_add_epro_drug 0, 0, 'KE', '3653', 'Floxapen 500 MG Injection', 'flucloxacillin 500 MG Injection', 'No Corresponding SCD RXCUI', 'flucloxacillin'
exec sp_add_epro_drug 0, 0, 'KE', '3724', 'Andrin Adult Drops 1 % Nasal Solution', 'ePHEDrine HCl 1 % Nasal Solution', 'SCD-1115985', 'ePHEDrine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3725', 'Andrin Pediatric Drops 0.5 % Nasal Solution', 'ePHEDrine HCl 0.5 % Nasal Solution', 'SCD-1116285', 'ePHEDrine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '3810', 'Cavinton 5 MG Oral Tablet', 'vinpocetine 5 MG Oral Tablet', 'SCD-429691', 'vinpocetine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '4287', 'Micronema 90 % / 450 MG / 75 MG in 10 ML Enema', 'glycerine 90 % / sodium citrate 450 MG / sodium lauryl sulphate 75 MG in 10 ML Enema', 'No Corresponding SCD RXCUI', 'glycerine / sodium citrate / sodium lauryl sulphate'
exec sp_add_epro_drug 0, 0, 'KE', '4446', 'Caredomet 25 MG Oral Capsule', 'indomethacin 25 MG Oral Capsule', 'PSN-197817', 'indomethacin'
exec sp_add_epro_drug 0, 0, 'KE', '5219', 'Tygacil 50 MG Injection', 'tigecycline 50 MG Injection', 'PSN-581531', 'tigecycyline'
exec sp_add_epro_drug 0, 0, 'KE', '5244', 'Tazocin-EF 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '5334', 'Latano 0.005 % Ophthalmic Solution', 'latanoprost 0.005 % Ophthalmic Solution', 'PSN-314072', 'latanoprost'
exec sp_add_epro_drug 0, 0, 'KE', '5644', 'Flagyl 500 MG in 100 ML Injection', 'metroNIDAZOLE 500 MG in 100 ML Injection', 'PSN-311683', 'metroNIDAZOLE'
exec sp_add_epro_drug 0, 0, 'KE', '666', 'Nemocid 250 MG Oral Tablet', 'pyrantel 250 MG Oral Tablet', 'SCD-199344', 'pyrantel', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '7058', 'Gardasil Human Papillomavirus Quadrivalent (types 6, 11, 16 and 18) Vaccine Recombinant 0.5 ML Prefilled Syringe', 'human Papillomavirus quadrivalent (types 6,11,16,18) vaccine, recombinant 0.5 ML Prefilled Syringe', 'PSN-798276', 'L1 protein, human papillomavirus type 11 vaccine / L1 protein, human papillomavirus type 16 vaccine / L1 protein, human papillomavirus type 18 vaccine / L1 protein, human papillomavirus type 6 vaccine', 'Obsolete'
exec sp_add_epro_drug 0, 0, 'KE', '7401', 'Betadine 200 MG Vaginal Pessary', 'povidone iodine 200 MG Vaginal Pessary', 'No Corresponding SCD RXCUI', 'povidone-iodine'
exec sp_add_epro_drug 0, 0, 'KE', '7949', 'No Brand Name (generic name is brand name provided)', 'atazanavir sulfate 300 MG Oral Capsule', 'PSN-664741', 'atazanavir'
exec sp_add_epro_drug 0, 0, 'KE', '8357', 'No Brand Name (generic name is brand name provided)', '10 ML potassium chloride 10 % (100 MG/ML) Injectable Solution', 'No Corresponding SCD RXCUI', 'potassium chloride'
exec sp_add_epro_drug 0, 0, 'KE', '8640', 'AsthaLIN 200 MCG/DOSE Metered Dose Inhaler, 200 Metered Doses', 'salbutamol sulphate 100 MCG/DOSE Metered Dose Inhaler, 200 Metered Doses', 'No Corresponding SCD RXCUI', 'salbutamol'
exec sp_add_epro_drug 0, 0, 'KE', '9110', 'Auromide Plus 5 % / 0.8 % Ophthalmic Solution', 'phenylephrine 5 % / tropicamide 0.8 % Ophthalmic Solution', 'No Corresponding SCD RXCUI', 'phenylephrine / tropicamide'
exec sp_add_epro_drug 0, 0, 'KE', '9114', 'Auroprost RT 0.005 % Ophthalmic Solution', 'latanoprost 0.005 % Ophthalmic Solution', 'PSN-314072', 'latanoprost'
exec sp_add_epro_drug 0, 0, 'KE', '9387', 'Latoprost RT 0.005 % Ophthalmic Solution', 'latanoprost 0.005 % Ophthalmic Solution', 'PSN-314072', 'latanoprost'
exec sp_add_epro_drug 0, 0, 'KE', '9505', 'Inno-Zopip 4.5 GM Injection', 'piperacillin 4000 MG / tazobactam 500 MG Injection', 'SCD-1659149', 'piperacillin / tazobactam'
exec sp_add_epro_drug 0, 0, 'KE', '9581', 'Atazor-R 300 MG / 100 MG Oral Tablet', 'atazanavir 300 MG / ritonavir 100 MG Oral Tablet', 'No Corresponding SCD RXCUI', 'atazanavir / ritonavir'
exec sp_add_epro_drug 0, 0, 'KE', '9632A', 'Glaritus 100 UNITS/ML Injectable Solution', 'insulin glargine 100 UNITS/ML Injectable Solution', 'PSN-311041', 'insulin glargine'
exec sp_add_epro_drug 0, 0, 'KE', '9632B', 'Glaritus 100 UNITS/ML in 3 ML Cartridge', 'insulin glargine 100 UNITS/ML in 3 ML Cartridge', 'No Corresponding SCD RXCUI', 'insulin glargine'
exec sp_add_epro_drug 0, 0, 'KE', '9742', 'Tylin 50 MG Injection', 'tigecycline 50 MG Injection', 'PSN-581531', 'tigecycyline'
exec sp_add_epro_drug 0, 0, 'KE', 'No Retention Number', 'Tiova 9 MCG/DOSE Metered Dose Inhaler, 200 Metered Doses', 'tiotropium bromide 9 MCG/DOSE Metered Dose Inhaler, 200 Metered Doses', 'No Corresponding SCD RXCUI', 'tiotropium'

-- Added per email
exec sp_add_epro_drug 0, 0, 'KE', 'NL00011', 'Dixarit 0.025 MG Oral Tablet', 'cloNIDine HCl 0.025 MG Oral Tablet', 'SCD-892791', 'cloNIDine'

-- Added via diff 01_29_2020 KenyaRetentionDrugsUpdate.csv
exec sp_add_epro_drug 0, 0, 'KE', '3205', NULL, 'benzhexol HCl 5 MG Oral Tablet', 'PSN-905283', 'benzhexol HCl'
exec sp_add_epro_drug 0, 0, 'KE', '4726', NULL, 'benzhexol HCl 2 MG Oral Tablet', 'PSN-905269', 'benzhexol HCl'

exec sp_add_epro_drug 0, 0, 'KE', '8288', 'Trio Kit { 1 (Azithromycin 1 GM Oral Tablet) / 1 (Fluconazole 150 MG Oral Tablet) / 2 (Secnidazole 1 GM Oral Tablet)}', '{1 (azithromycin 1 GM Oral Tablet) / 1 (fluconazole 150 MG Oral Tablet) / 2 (secnidazole 1 GM Oral Tablet)}', 'No Corresponding SCD RXCUI', '{  (azithromycin )/(fluconazole )/( secnidazole ) } Kit'
