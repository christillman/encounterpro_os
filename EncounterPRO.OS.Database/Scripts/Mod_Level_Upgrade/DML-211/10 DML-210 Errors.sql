
-- Update generic names of branded drugs
UPDATE d
SET generic_name = 
	CASE WHEN LEN(g.generic_name) <= 500 
		THEN g.generic_name 
		ELSE left(g.generic_name,497) + '...' END 
-- select d.generic_name, g.generic_name
FROM c_Drug_Definition d
JOIN c_Drug_Brand b ON b.drug_id = d.drug_id
JOIN c_Drug_Generic g on g.generic_rxcui = b.generic_rxcui
WHERE d.generic_name != CASE WHEN LEN(g.generic_name) <= 500 
	THEN g.generic_name 
	ELSE left(g.generic_name,497) + '...' END 
-- (326 row(s) affected)

-- 7/1/2021 mail "Incorporating Feedback from KEDrugsBrandNameReview Spreadsheet sent 09_18_2020"

-- Update brand names in c_Drug_Definition
-- KEDrugsBrandNameReview 01_06_2020.xlsx
update c_Drug_Definition SET common_name = 'Co-Malather Compact' where drug_id = 'KEBI11125'
update c_Drug_Definition SET common_name = 'Enril 20H' where drug_id = 'KEBI2584'
update c_Drug_Definition SET common_name = 'Flu-Gone-P Plus' where drug_id = 'KEBI3861'
update c_Drug_Definition SET common_name = 'Grilinctus-BM' where drug_id = 'KEBI11503'
update c_Drug_Definition SET common_name = 'Insuman basal' where drug_id = 'KEBI5907'
update c_Drug_Definition SET common_name = 'Insuman Rapid ' where drug_id = 'KEBI10907'
update c_Drug_Definition SET common_name = 'Junior Lanzol ' where drug_id = 'KEBI8684'
update c_Drug_Definition SET common_name = 'Lemsip Max Cold & Flu' where drug_id = 'KEBI215'
update c_Drug_Definition SET common_name = 'Lonart Dispersible' where drug_id = 'KEBI405'
update c_Drug_Definition SET common_name = 'Lornex Forte' where drug_id = 'KEBI11641'
update c_Drug_Definition SET common_name = 'Lornex Plus ' where drug_id = 'KEBI11642'
update c_Drug_Definition SET common_name = 'Losec MUPS' where drug_id = 'KEBI7705'
update c_Drug_Definition SET common_name = 'Losec MUPS' where drug_id = 'KEBI7706'
update c_Drug_Definition SET common_name = 'Loxiam Plus' where drug_id = 'KEBI9672'
update c_Drug_Definition SET common_name = 'Lum-Artem Forte' where drug_id = 'KEBI13036'
update c_Drug_Definition SET common_name = 'Medisart 300 H' where drug_id = 'KEBI12494'
update c_Drug_Definition SET common_name = 'Medisart H' where drug_id = 'KEBI14001'
update c_Drug_Definition SET common_name = 'Nolgripp Junior' where drug_id = 'KEBI11049'
update c_Drug_Definition SET common_name = 'Nolgripp Plus' where drug_id = 'KEBI11050'
update c_Drug_Definition SET common_name = 'Novomix-30 Flexpen' where drug_id = 'KEBI283PF'
update c_Drug_Definition SET common_name = 'Novomix-30 Penfill' where drug_id = 'KEBI283'
update c_Drug_Definition SET common_name = 'NovoRAPID Flexpen' where drug_id = 'KEBI289PF'
update c_Drug_Definition SET common_name = 'NovoRAPID Penfill' where drug_id = 'KEBI289'
update c_Drug_Definition SET common_name = 'Nurofen Migraine Pain' where drug_id = 'KEBI16475'
update c_Drug_Definition SET common_name = 'Olme-20AH' where drug_id = 'KEBI13150'
update c_Drug_Definition SET common_name = 'Olme-40AH' where drug_id = 'KEBI13149'
update c_Drug_Definition SET common_name = 'Olmesar-H' where drug_id = 'KEBI10827'
update c_Drug_Definition SET common_name = 'Proliz' where drug_id = 'KEBI11971'
update c_Drug_Definition SET common_name = 'Teltas-40 H' where drug_id = 'KEBI6211'
update c_Drug_Definition SET common_name = 'Teltas-80 H' where drug_id = 'KEBI6216'
update c_Drug_Definition SET common_name = 'Vastor 20-EZ' where drug_id = 'KEBI5811'

update c_Drug_Brand SET brand_name = 'Enril 20H' where drug_id = 'KEBI2584'
update c_Drug_Brand SET brand_name = 'Insuman basal' where drug_id = 'KEBI5907Vial'
update c_Drug_Brand SET brand_name = 'Lonart Dispersible ' where drug_id = 'KEBI405'
update c_Drug_Brand SET brand_name = 'Losec MUPS' where drug_id = 'KEBI7706'
update c_Drug_Brand SET brand_name = 'Medisart H' where drug_id = 'KEBI14001'
update c_Drug_Brand SET brand_name = 'Proliz' where drug_id = 'KEBI11971'

-- Combine Amaryl
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI5176' WHERE ingr_rxcui = 'KEBI5199'
UPDATE c_Drug_Brand_Related SET brand_name_rxcui = 'KEBI5176' WHERE brand_name_rxcui = 'KEBI5199'
DELETE FROM c_Drug_Brand WHERE brand_name_rxcui = 'KEBI5199'
DELETE FROM c_Drug_Definition WHERE drug_id = 'KEBI5199'
-- Combine Bexitrol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI2318' WHERE ingr_rxcui = 'KEBI2315'
UPDATE c_Drug_Brand_Related SET brand_name_rxcui = 'KEBI2318' WHERE brand_name_rxcui = 'KEBI2315'
DELETE FROM c_Drug_Brand WHERE brand_name_rxcui = 'KEBI2315'
DELETE FROM c_Drug_Definition WHERE drug_id = 'KEBI2315'
-- Combine Lantus
UPDATE c_Drug_Formulation SET ingr_rxcui = '261551' WHERE ingr_rxcui = 'KEBI5916'
UPDATE c_Drug_Brand_Related SET brand_name_rxcui = '261551' WHERE brand_name_rxcui = 'KEBI5916'
delete from c_Drug_Definition where drug_id = 'KEBI5916'
delete from c_Drug_Brand where drug_id = 'KEBI5916' -- Lantus Insulin 
-- KEBI5916PF -- Lantus Solostar
-- Combine Tramal
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI7890' WHERE ingr_rxcui = 'KEBI7892'
UPDATE c_Drug_Brand_Related SET brand_name_rxcui = 'KEBI7890' WHERE brand_name_rxcui = 'KEBI7892'
DELETE FROM c_Drug_Brand WHERE brand_name_rxcui = 'KEBI7892'
DELETE FROM c_Drug_Definition WHERE drug_id = 'KEBI7892'


-- Formulations which were deleted in error, in DML-210\70 c_Drug_Package.sql
/*
SELECT form_rxcui
INTO #bad_drug_id
FROM c_Drug_Package dp
WHERE form_rxcui like 'KE%'
and not exists (select 1 from c_Drug_Definition d where d.drug_id = dp.drug_id)
and not exists (select 1 from c_Drug_Generic g where g.drug_id = dp.drug_id)
and not exists (select 1 from c_Drug_Brand b where b.drug_id = dp.drug_id)
*/
delete
from c_Drug_Formulation 
where form_rxcui in (
'KEB10053',
'KEB10203',
'KEB10270',
'KEB10477',
'KEB10479',
'KEB10484',
'KEB10485',
'KEB10556',
'KEB10766',
'KEB10780',
'KEB10823',
'KEB10828',
'KEB10850',
'KEB10938',
'KEB10943',
'KEB11073',
'KEB11124',
'KEB11136',
'KEB11137',
'KEB11169',
'KEB11170',
'KEB11447',
'KEB1156',
'KEB11585',
'KEB11586',
'KEB1161',
'KEB11705',
'KEB11743',
'KEB11748',
'KEB11751',
'KEB11752',
'KEB11753',
'KEB11755',
'KEB1177',
'KEB11919',
'KEB11921',
'KEB11999',
'KEB12060',
'KEB12069',
'KEB12202',
'KEB12229',
'KEB12386',
'KEB1247',
'KEB12561',
'KEB12707',
'KEB1279',
'KEB1293',
'KEB130',
'KEB13116',
'KEB13297',
'KEB1358',
'KEB13625',
'KEB1366',
'KEB13804',
'KEB13806',
'KEB14086',
'KEB14087',
'KEB1418',
'KEB1420',
'KEB1422',
'KEB14278',
'KEB1432',
'KEB1435',
'KEB1445',
'KEB1460',
'KEB14876',
'KEB15506',
'KEB15615',
'KEB15702',
'KEB15702Ear',
'KEB1738',
'KEB1739',
'KEB1819',
'KEB1827',
'KEB1839',
'KEB204',
'KEB2044',
'KEB205',
'KEB2097',
'KEB2170',
'KEB2196',
'KEB2223',
'KEB2253R',
'KEB229Pen',
'KEB2353',
'KEB237',
'KEB241',
'KEB246',
'KEB247',
'KEB248',
'KEB2490',
'KEB2567',
'KEB2628',
'KEB2640',
'KEB2646',
'KEB2677',
'KEB2682',
'KEB2700',
'KEB2806',
'KEB2810',
'KEB2812',
'KEB2814',
'KEB281Pen',
'KEB282Pen',
'KEB283Pen',
'KEB289Pen',
'KEB289Vial',
'KEB301',
'KEB3023',
'KEB304',
'KEB3055',
'KEB3056',
'KEB3064',
'KEB3085',
'KEB3092',
'KEB3141',
'KEB3233',
'KEB3259',
'KEB3307',
'KEB3319',
'KEB3321',
'KEB3329',
'KEB3332',
'KEB3333',
'KEB3350',
'KEB3351',
'KEB3353',
'KEB3354',
'KEB3361',
'KEB3496',
'KEB3504',
'KEB3506',
'KEB364',
'KEB3681',
'KEB405',
'KEB4087',
'KEB4095',
'KEB4096',
'KEB4102',
'KEB418',
'KEB429',
'KEB4385',
'KEB439',
'KEB449',
'KEB4497',
'KEB4535',
'KEB4644',
'KEB470',
'KEB4738',
'KEB5214',
'KEB5255',
'KEB5310',
'KEB5361',
'KEB5374',
'KEB5413',
'KEB5419',
'KEB5426',
'KEB5428',
'KEB5434',
'KEB5478',
'KEB5480',
'KEB5698',
'KEB5720',
'KEB5744',
'KEB58',
'KEB5819',
'KEB5877',
'KEB5879',
'KEB5880',
'KEB5907Vial',
'KEB5916Pen',
'KEB5932',
'KEB5933',
'KEB5950',
'KEB5952',
'KEB6214',
'KEB6253',
'KEB6289',
'KEB6352',
'KEB639',
'KEB646',
'KEB6611',
'KEB6685',
'KEB6689',
'KEB7116',
'KEB7242',
'KEB7256',
'KEB7265',
'KEB7293',
'KEB7308',
'KEB7387',
'KEB7405',
'KEB7483',
'KEB7576',
'KEB7591',
'KEB7602',
'KEB7706',
'KEB7805',
'KEB7806',
'KEB7807',
'KEB7808',
'KEB7809',
'KEB7939',
'KEB7961',
'KEB8280',
'KEB8309',
'KEB8432',
'KEB8541',
'KEB8592',
'KEB8593',
'KEB8661',
'KEB8947',
'KEB9040',
'KEB937',
'KEB950',
'KEB9598',
'KEB9600',
'KEB9602',
'KEB9606',
'KEB963',
'KEB9704',
'KEB9706',
'KEB9721',
'KEB9944',
'KEG10218',
'KEG10316',
'KEG10644',
'KEG108',
'KEG10843',
'KEG10850',
'KEG11122',
'KEG11124',
'KEG11297',
'KEG11518',
'KEG11641',
'KEG11642',
'KEG11727',
'KEG11743',
'KEG11753',
'KEG11755',
'KEG1177',
'KEG118',
'KEG11828',
'KEG11829',
'KEG11842',
'KEG12012',
'KEG12068',
'KEG12069',
'KEG1217',
'KEG12227',
'KEG12301',
'KEG1235',
'KEG12395',
'KEG12488',
'KEG12560',
'KEG12610',
'KEG129',
'KEG130',
'KEG1301',
'KEG13036',
'KEG13066',
'KEG13074',
'KEG13284',
'KEG13360',
'KEG1391',
'KEG14279',
'KEG144',
'KEG1445',
'KEG14953',
'KEG15001',
'KEG15189',
'KEG15490',
'KEG16179',
'KEG201',
'KEG2096',
'KEG2097',
'KEG2286',
'KEG229',
'KEG231',
'KEG2315',
'KEG2318',
'KEG235',
'KEG2421',
'KEG2676',
'KEG2682',
'KEG2700',
'KEG2728',
'KEG274',
'KEG2981',
'KEG3004',
'KEG3022',
'KEG3051',
'KEG3055',
'KEG3056',
'KEG3192',
'KEG342',
'KEG3505',
'KEG3557',
'KEG3632',
'KEG3704',
'KEG3785',
'KEG3815',
'KEG3832',
'KEG3861',
'KEG3957',
'KEG4110',
'KEG432',
'KEG4372',
'KEG4392',
'KEG444',
'KEG4459',
'KEG449',
'KEG464',
'KEG470',
'KEG4920',
'KEG510',
'KEG5176',
'KEG5199',
'KEG5229',
'KEG5235',
'KEG5310',
'KEG5376',
'KEG5413',
'KEG5419',
'KEG5630',
'KEG58',
'KEG588',
'KEG5907',
'KEG6023',
'KEG6024',
'KEG6026',
'KEG6121',
'KEG6142',
'KEG6996',
'KEG7106',
'KEG718',
'KEG7202',
'KEG7228',
'KEG7385',
'KEG7387',
'KEG7412',
'KEG7580',
'KEG7602',
'KEG7742',
'KEG8009',
'KEG8159',
'KEG8162',
'KEG8163',
'KEG8193',
'KEG8218',
'KEG8261',
'KEG8645',
'KEG9006',
'KEG9008',
'KEG9009',
'KEG929',
'KEG9377',
'KEG9380',
'KEG9410',
'KEG9535',
'KEG9672',
'KEG995')

INSERT INTO c_Drug_Formulation VALUES ('KEB10053','SBD_KE','Aflodor 16 MG / 200 MG Sustained Release Oral Capsule','KEBI10052','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10203','SBD_KE','Concor 10 MG Oral Tablet','KEBI10202','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10270','SBD_KE','Amtel 80 MG / 10 MG Oral Tablet','KEBI10266','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10477','SBD_KE','Ziak 5 MG / 6.25 MG Oral Tablet','KEBI10367','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10479','SBD_KE','Ziak 10 MG / 6.25 MG Oral Tablet','KEBI10367','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10556','SBD_KE','Relvar Ellipta 200 MCG/25 MCG Dry Powder Inhaler, 30 Doses','KEBI10555','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10766','SBD_KE','Toras-Denk 10 MG Oral Tablet','KEBI10765','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10780','SBD_KE','Nebilet Plus 5 MG / 25 MG Oral Tablet','KEBI10776','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10823','SBD_KE','Olmesar 40 MG Oral Tablet','KEBI10822','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10828','SBD_KE','Olmesar-H 40 MG / 12.5 MG Oral Tablet','KEBI10827','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB10850','SBD_KE','Falcimon 25 MG / 67.5 MG Oral Tablet','KEBI10843','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11073','SBD_KE','Forxiga 10 MG Oral Tablet','KEBI11066','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11124','SBD_KE','Coldril 120 MG / 1 MG / 10 MG in 5 ML Oral Solution','KEBI11122','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11136','SBD_KE','Avsar 160 MG / 5 MG Oral Tablet','KEBI11135','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11137','SBD_KE','Avsar 160 MG / 10 MG Oral Tablet','KEBI11135','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11169','SBD_KE','Aldomet 250 MG Oral Tablet','KEBI11169','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11170','SBD_KE','Aldomet 500 MG Oral Tablet','KEBI11169','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11447','SBD_KE','Bedranol 10 MG Oral Tablet','KEBI11446','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1156','SBD_KE','Hyspar 5 MG / 120 MG in 5 ML Oral Solution','KEBI1150','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11585','SBD_KE','Inegy 10 MG / 20 MG Oral Tablet','KEBI11582','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11586','SBD_KE','Inegy 10 MG / 40 MG Oral Tablet','KEBI11582','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1161','SBD_KE','Benduric 2.5 MG Oral Tablet','KEBI1126','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11705','SBD_KE','Cefo-L 50 MG / 60 Million Spores in 5 ML Powder for Oral Suspension','KEBI11704','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11743','SBD_KE','Triplixam 5 MG / 1.25 MG / 5 MG Oral Tablet','KEBI11727','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11748','SBD_KE','Coveram 10 MG / 5 MG Oral Tablet','KEBI11744','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11751','SBD_KE','Coveram 10 MG / 10 MG Oral Tablet','KEBI11744','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11752','SBD_KE','Coveram 5 MG / 10 MG Oral Tablet','KEBI11744','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11753','SBD_KE','Triplixam 10 MG / 2.5 MG / 10 MG Oral Tablet','KEBI11727','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11755','SBD_KE','Triplixam 5 MG / 1.25 MG / 10 MG Oral Tablet','KEBI11727','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1177','SBD_KE','Lum-Artem 20 MG / 120 MG Oral Tablet','KEBI1165','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11919','SBD_KE','Valsar-Denk 80 MG Oral Tablet','KEBI10774','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB11921','SBD_KE','Valsar-Denk 160 MG Oral Tablet','KEBI10774','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12060','SBD_KE','"Komefan 280" (artemether 40 MG / lumefantrine 240 MG) Oral Tablet','KEBI12059','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12069','SBD_KE','Natrixam 1.5 MG / 5 MG Modified Release Oral Tablet','KEBI12068','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12202','SBD_KE','Akudinir 300 MG Oral Capsule','KEBI12200','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12229','SBD_KE','Cholestrom 20 MG Oral Tablet','KEBI12228','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12386','SBD_KE','Tolvat 30 MG Oral Tablet','KEBI12382','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1247','SBD_KE','Rolac 30 MG/ML Injection','KEBI1245','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12561','SBD_KE','Sanmol 500 MG Effervescent Oral Tablet','KEBI12560','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB12707','SBD_KE','Dilur 4 MG Oral Tablet','KEBI12705','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1279','SBD_KE','Met XL 100 MG Extended Release Oral Tablet','KEBI1277','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1293','SBD_KE','Artefan 180 MG / 1080 MG in 60 ML Oral Suspension','KEBI1270','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB130','SBD_KE','Artesun 60 MG Injection','KEBI129','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB13116','SBD_KE','Lercapil 10 MG Oral Tablet','KEBI12630','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB13297','SBD_KE','Dichlor 25 MG Oral Tablet','KEBI13296','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1358','SBD_KE','Artefan 20 MG / 120 MG Dispersible Oral Tablet','KEBI1270','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB13625','SBD_KE','GlucoMET XR 750 MG Extended Release Oral Tablet','KEBI10529','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1366','SBD_KE','Metoz 5 MG Oral Tablet','KEBI1365','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB13804','SBD_KE','"Uperio 50 MG" (sacubitril 24.3 MG / valsartan 25.7 MG) Oral Tablet','KEBI13803','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB13806','SBD_KE','"Uperio 100 MG" (sacubitril 48.6 MG / valsartan 51.4 MG) Oral Tablet','KEBI13803','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB14086','SBD_KE','Niredil 10 MG Transdermal Patch','KEBI14085','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB14087','SBD_KE','Niredil 15 MG Transdermal Patch','KEBI14085','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1418','SBD_KE','ORAcef 500 MG Oral Capsule','KEBI1414','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1420','SBD_KE','ORAcef 125 MG in 5 ML Powder for Oral Suspension','KEBI1414','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1422','SBD_KE','ORAcef 250 MG in 5 ML Powder for Oral Suspension','KEBI1414','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB14278','SBD_KE','S-Amlosafe 5 MG Oral Tablet','KEBI14277','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1432','SBD_KE','Blokium 100 MG Oral Tablet','KEBI1429','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1435','SBD_KE','Sabulin 4 MG Oral Tablet','KEBI1431','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1445','SBD_KE','Artesiane 20 MG/ML Injection','KEBI12227','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1460','SBD_KE','Cipronat 750 MG Oral Tablet','KEBI1457','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB14876','SBD_KE','Ramizid 10 MG Oral Tablet','KEBI11351','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB15506','SBD_KE','Labnir 300 MG Oral Capsule','KEBI15491','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB15615','SBD_KE','Artefan 60 MG / 360 MG Oral Tablet','KEBI1270','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1738','SBD_KE','Aurozil 125 MG in 5 ML Oral Suspension','KEBI1737','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1739','SBD_KE','Aurozil 250 MG in 5 ML Oral Suspension','KEBI1737','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1819','SBD_KE','Advant 16 MG Oral Tablet','KEBI1818','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1827','SBD_KE','Anadol 100 MG in 2 ML Injectable Solution','KEBI1825','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB1839','SBD_KE','Beclomin 250 MCG HFA Inhaler, 200 Puffs','KEBI1087','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB204','SBD_KE','Rostat 5 MG Oral Tablet','KEBI11802','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2044','SBD_KE','Formonide 400 MCG / 6 MCG Metered Dose Inhaler, 120 Metered Doses','KEBI2042','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB205','SBD_KE','Rostat 10 MG Oral Tablet','KEBI11802','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2097','SBD_KE','Levostar 1 MG in 5 ML Oral Syrup','KEBI2096','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2170','SBD_KE','Amdocal Plus 5 MG / 50 MG Oral Tablet','KEBI2166','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2196','SBD_KE','Cemet 400 MG Oral Tablet','KEBI2186','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2223','SBD_KE','Cardisprin 75 MG Enteric Coated Oral Tablet','KEBI11683','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2353','SBD_KE','Lofral 5 MG Oral Tablet','KEBI2316','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB237','SBD_KE','"Curam 625 MG" (amoxicillin 500 MG / clavulanate potassium 125 MG) Oral Tablet','KEBI15791','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB241','SBD_KE','"Curam 1000 MG" (amoxicillin 875 MG / clavulanate potassium 125 MG) Oral Tablet','KEBI15791','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB246','SBD_KE','Biodroxil 1000 MG Oral Tablet','KEBI245','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB247','SBD_KE','Biodroxil 125 MG in 5 ML Oral Suspension','KEBI245','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB248','SBD_KE','Biodroxil 250 MG in 5 ML Granules for Oral Suspension','KEBI245','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2567','SBD_KE','Dalacin-C 300 MG Oral Capsule','KEBI2565','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2628','SBD_KE','Mexic 15 MG Oral Tablet','KEBI2626','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2640','SBD_KE','Starval 80 MG Oral Tablet','KEBI2613','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2646','SBD_KE','Amtel 40 MG / 5 MG Oral Tablet','KEBI10266','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2677','SBD_KE','Pioday 30 MG Oral Tablet','KEBI2673','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2682','SBD_KE','"Ampiclox 90 MG" (ampicillin 60 MG / cloxacillin 30 MG) in 0.6 ML Neonatal Oral Drops Suspension','KEBI2676','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2700','SBD_KE','"Ampiclox 250 MG" (ampicillin 125 MG / cloxacillin 125 MG) in 5 ML Powder for Oral Solution','KEBI2676','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2806','SBD_KE','"Clavulin 228.5 MG" (amoxicillin 200 MG / clavulanic acid 28.5 MG) in 5 ML Oral Suspension','KEBI2802','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2810','SBD_KE','"Clavulin 625 MG" (amoxicillin 500 MG / clavulanate potassium 125 MG) Oral Tablet','KEBI2802','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2812','SBD_KE','"Clavulin 1000 MG" (amoxicillin 875 MG / clavulanate potassium 125 MG) Oral Tablet','KEBI2802','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB2814','SBD_KE','Co-Diovan 160 MG / 12.5 MG Oral Tablet','KEBI2804','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB301','SBD_KE','NovoNorm 1 MG Oral Tablet','KEBI299','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3023','SBD_KE','Glimepiride Denk 3 MG Oral Tablet','KEBI3009','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB304','SBD_KE','NovoNorm 2 MG Oral Tablet','KEBI299','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3055','SBD_KE','Galvus Met 50 MG / 850 MG Oral Tablet','KEBI3051','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3056','SBD_KE','Galvus Met 50 MG / 1000 MG Oral Tablet','KEBI3051','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3064','SBD_KE','Fortum 2 GM Injection','KEBI3057','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3085','SBD_KE','Metformin Denk 500 MG Oral Tablet','KEBI10767','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3092','SBD_KE','Amlo-Denk 5 MG Oral Tablet','KEBI3060','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3141','SBD_KE','Ena-Denk 20 MG Oral Tablet','KEBI3140','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3233','SBD_KE','Cipro-Denk 500 MG Oral Tablet','KEBI11983','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3259','SBD_KE','Varinil 5 MG Oral Tablet','KEBI10965','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3307','SBD_KE','Dalacin-C 75 MG in 5 ML Granules for Oral Suspension','KEBI2565','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3319','SBD_KE','Getryl 2 MG Oral Tablet','KEBI3318','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3321','SBD_KE','Getryl 4 MG Oral Tablet','KEBI3318','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3329','SBD_KE','Penamox 500 MG Oral Capsule','KEBI3328','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3332','SBD_KE','Penamox 125 MG in 5 ML Oral Suspension','KEBI3328','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3333','SBD_KE','Penamox 250 MG in 5 ML Oral Suspension','KEBI3328','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3350','SBD_KE','Risek 40 MG Oral Capsule','KEBI3349','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3351','SBD_KE','Risek 40 MG Injection','KEBI3349','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3353','SBD_KE','Rovista 10 MG Oral Tablet','KEBI3352','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3354','SBD_KE','Rovista 20 MG Oral Tablet','KEBI3352','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3361','SBD_KE','Treviamet 50 MG / 1000 MG Oral Tablet','KEBI3360','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3496','SBD_KE','Seretide Accuhaler/ Diskus 250 MCG/50 MCG, Dry Powder Inhaler, 60 inhalations','KEBI3488','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3504','SBD_KE','Seretide Evohaler 125 MCG/25 MCG Metered Dose Inhaler, 120 Inhalations','KEBI3501','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3506','SBD_KE','Seretide Evohaler 250 MCG/25 MCG Metered Dose Inhaler, 120 Inhalations','KEBI3501','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB364','SBD_KE','Extacef-DT 100 MG Dispersible Oral Tablet','KEBI256','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB3681','SBD_KE','Zentel 400 MG Oral Tablet','KEBI3675','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB405','SBD_KE','Lonart 20 MG / 120 MG Dispersible Oral Tablet','KEBI397','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4087','SBD_KE','Zinnat 250 MG in 5 ML Oral Suspension','KEBI3684','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4095','SBD_KE','Para-Denk 125 MG Rectal Suppository','KEBI4081','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4096','SBD_KE','Zinnat 125 MG in 5 ML Oral Suspension','KEBI3684','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4102','SBD_KE','Nifedi-Denk 10 MG Extended Release Oral Tablet','KEBI3979','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB418','SBD_KE','Gacet 1000 MG Rectal Suppository','KEBI404','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB429','SBD_KE','Buscopan 10 MG Oral Tablet','KEBI424','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4385','SBD_KE','Lacillin 500 MG Oral Capsule','KEBI4350','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB439','SBD_KE','Lonart 20 MG / 120 MG Oral Tablet','KEBI397','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB449','SBD_KE','P-Alaxin 40 MG / 320 MG Oral Tablet','KEBI342','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4497','SBD_KE','GlucoMET 850 MG Oral Tablet','KEBI3276','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4535','SBD_KE','GlucoMET XR 500 MG Oral Tablet','KEBI10529','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB4644','SBD_KE','Trabilin 50 MG Oral Capsule','KEBI4640','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB470','SBD_KE','Gvither 20 MG/ML Injection','KEBI464','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5214','SBD_KE','Amlibon 10 MG Oral Tablet','KEBI2535','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5255','SBD_KE','Rolac 10 MG/ML Injection','KEBI1245','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5361','SBD_KE','Pantoloc 40 MG Oral Tablet','KEBI5358','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5374','SBD_KE','Aprovel 300 MG Oral Tablet','KEBI5298','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5413','SBD_KE','Artesunate Amodiaquine Winthrop 50 MG / 135 MG Oral Tablet','KEBI5376','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5419','SBD_KE','Artesunate Amodiaquine Winthrop 100 MG / 270 MG Oral Tablet','KEBI5376','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5426','SBD_KE','CoAprovel 300 MG / 25 MG Oral Tablet','KEBI5336','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5428','SBD_KE','CoAprovel 300 MG / 12.5 MG Oral Tablet','KEBI5336','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5434','SBD_KE','Lufanate 20 MG / 120 MG Oral Tablet','KEBI5430','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5478','SBD_KE','Colastin-L 20 MG Oral Tablet','KEBI2820','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5480','SBD_KE','Mono-Tildiem SR 200 MG Sustained Release Oral Capsule','KEBI5477','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5698','SBD_KE','Orelox 40 MG in 5 ML Granules for Oral Suspension','KEBI5696','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5720','SBD_KE','Cardinol 100 MG Oral Tablet','KEBI1172','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5744','SBD_KE','Carca 6.25 MG Oral Tablet','KEBI5743','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB58','SBD_KE','D-Artepp 40 MG / 320 MG Oral Tablet','KEBI11623','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5819','SBD_KE','Lisace 5 MG Oral Tablet','KEBI4635','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5877','SBD_KE','Clexane 40 MG in 0.4 ML Prefilled Syringe','KEBI5870','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5879','SBD_KE','Clexane 60 MG in 0.6 ML Prefilled Syringe','KEBI5870','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5880','SBD_KE','Clexane 80 MG in 0.8 ML Prefilled Syringe','KEBI5870','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5932','SBD_KE','Tritace 5 MG Oral Tablet','KEBI5835','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5933','SBD_KE','Tritace 10 MG Oral Tablet','KEBI5835','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5950','SBD_KE','Tritazide 5 MG / 12.5 MG Oral Tablet','KEBI5947','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB5952','SBD_KE','Tritazide 10 MG / 25 MG Oral Tablet','KEBI5947','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6214','SBD_KE','Teltas 80 MG Oral Tablet','KEBI6210','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6253','SBD_KE','Metrozol 250 MG Oral Tablet','KEBI6239','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6289','SBD_KE','Esose 20 MG Oral Tablet','KEBI5571','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6352','SBD_KE','Cardinol 50 MG Oral Tablet','KEBI1172','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB639','SBD_KE','Revelol XL 50 MG Extended Release Oral Tablet','KEBI637','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB646','SBD_KE','Oxipod 100 MG Dispersible Oral Tablet','KEBI591','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6685','SBD_KE','Betaloc ZoK 50 MG Controlled Release Oral Tablet','KEBI6354','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB6689','SBD_KE','Betaloc ZoK 100 MG Controlled Release Oral Tablet','KEBI6354','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7116','SBD_KE','Dilatrend 25 MG Oral Tablet','KEBI7111','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7242','SBD_KE','Orelox 200 MG Oral Tablet','KEBI5696','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7256','SBD_KE','Dilcontin XL 90 MG Controlled Release Oral Tablet','KEBI7183','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7265','SBD_KE','Nitrocontin 6.4 MG Controlled Release Oral Tablet','KEBI7264','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7293','SBD_KE','Cefacure 250 MG Oral Capsule','KEBI7292','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7308','SBD_KE','Tritazide 10 MG / 12.5 MG Oral Tablet','KEBI5947','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7387','SBD_KE','bi Preterax 5 MG / 1.25 MG Oral Tablet','KEBI7385','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7405','SBD_KE','Coversyl 10 MG Oral Tablet','KEBI7402','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7483','SBD_KE','Pariet 20 MG Delayed Release Oral Tablet','KEBI7481','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7576','SBD_KE','Corbis-H 10 MG / 6.25 MG Oral Tablet','KEBI7550','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7591','SBD_KE','Pantocid 40 MG Oral Tablet','KEBI7590','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7602','SBD_KE','"Ampoxin 1 GM" (ampicillin 500 MG / cloxacillin 500 MG) Injection','KEBI7580','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7706','SBD_KE','Losec MUPS 20 MG Delayed Release Oral Tablet','KEBI7705','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7805','SBD_KE','Rocephin 500 MG Intravenous Injection','KEBI7805','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7806','SBD_KE','Rocephin 500 MG Intramuscular Injection','KEBI7805','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7807','SBD_KE','Rocephin 1 GM Intravenous Injection','KEBI7805','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7808','SBD_KE','Rocephin 1 GM Intramuscular Injection','KEBI7805','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7809','SBD_KE','Rocephin 2 GM Intravenous Injection','KEBI7805','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7939','SBD_KE','Asomex 5 MG Oral Tablet','KEBI7938','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB7961','SBD_KE','Metpure -XL 50 MG Extended Release Oral Tablet','KEBI7960','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8280','SBD_KE','Melonac 7.5 MG Oral Tablet','KEBI7501','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8309','SBD_KE','S-Numlo 5 MG Oral Tablet','KEBI8308','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8432','SBD_KE','Dawasprin 300 MG Oral Tablet','KEBI13035','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8541','SBD_KE','Budecort 100 MCG/ACTUAT Metered Dose Inhaler, 200 Metered Doses','KEBI8540','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8592','SBD_KE','Foralin 100 MCG / 6 MCG Metered Dose Inhaler, 120 Metered Doses','KEBI8591','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8593','SBD_KE','Foralin 400 MCG / 6 MCG Metered Dose Inhaler, 120 Metered Doses','KEBI8591','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8661','SBD_KE','Diracip-M 100 MG / 125 MG in 5 ML Oral Suspension','KEBI8659','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB8947','SBD_KE','Zithroriv 500 MG Oral Capsule','KEBI8946','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9040','SBD_KE','Candez 16 MG Oral Tablet','KEBI731','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB937','SBD_KE','Amlovas 10 MG Oral Tablet','KEBI934','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB950','SBD_KE','Trevia 50 MG Oral Tablet','KEBI1197','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9598','SBD_KE','Amoxiclav-Denk 1000 MG / 125 MG Powder for Oral Suspension','KEBI10752','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9600','SBD_KE','Carvedi-Denk 25 MG Oral Tablet','KEBI9599','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9602','SBD_KE','Losar-Denk 100 MG Oral Tablet','KEBI10089','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9606','SBD_KE','Metformin Denk 1000 MG Oral Tablet','KEBI10767','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB963','SBD_KE','Ciprobay 500 MG Oral Tablet','KEBI166','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9704','SBD_KE','Epnone 50 MG Oral Tablet','KEBI10378','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9706','SBD_KE','Prasusafe 5 MG Oral Tablet','KEBI522','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9721','SBD_KE','Risek Insta 20 MG / 1680 MG Powder for Oral Suspension','KEBI9720','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEB9944','SBD_KE','Tinilox-MPS 75 MG / 62.5 MG / 12.5 MG in 5 ML Oral Suspension','KEBI7916','BN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG10218','SCD_KE','artesunate 60 MG Injection','KEGI10218','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG10316','SCD_KE','alpha-beta arteether 75 MG/ML Injection','KEGI10316','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG10644','SCD_KE','paracetamol 1000 MG Effervescent Oral Tablet','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG108','SCD_KE','calcium carbonate 325 MG / sodium alginate 500 MG / sodium bicarbonate 213 MG in 10 ML Oral Suspension','KEGI108','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG10843','SCD_KE','artesunate 50 MG / amodiaquine 135 MG Oral Tablet','KEGI10843','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG10850','SCD_KE','artesunate 25 MG / amodiaquine 67.5 MG Oral Tablet','KEGI10843','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11122','SCD_KE','paracetamol 500 MG / chlorpheniramine maleate 2 MG / pseudoephedrine HCl 30 MG Oral Capsule','KEGI11122','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11124','SCD_KE','paracetamol 120 MG / chlorpheniramine maleate 1 MG / pseudoephedrine HCl 10 MG in 5 ML Oral Solution','KEGI11122','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11297','SCD_KE','ibuprofen 200 MG / paracetamol 325 MG in 10 ML Oral Suspension','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11518','SCD_KE','aceclofenac 100 MG / paracetamol 375 MG Oral Tablet','KEGI11518','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11641','SCD_KE','lornoxicam 8 MG / paracetamol 325 MG Oral Tablet','KEGI11641','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11642','SCD_KE','lornoxicam 4 MG / paracetamol 325 MG Oral Tablet','KEGI11641','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11727','SCD_KE','perindopril arginine 10 MG / indapamide 2.5 MG / amLODIPine 5 MG Oral Tablet','KEGI11727','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11743','SCD_KE','perindopril arginine 5 MG / indapamide 1.25 MG / amLODIPine 5 MG Oral Tablet','KEGI11727','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11753','SCD_KE','perindopril arginine 10 MG / indapamide 2.5 MG / amLODIPine 10 MG Oral Tablet','KEGI11727','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11755','SCD_KE','perindopril arginine 5 MG / indapamide 1.25 MG / amLODIPine 10 MG Oral Tablet','KEGI11727','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1177','SCD_KE','B-artemether 20 MG / lumefantrine 120 MG Oral Tablet','KEGI1165','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG118','SCD_KE','calcium carbonate 187.5 MG / sodium alginate 250 MG / sodium bicarbonate 106.5 MG Oral Tablet','KEGI108','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11828','SCD_KE','aceclofenac 100 MG / paracetamol 500 MG Oral Tablet','KEGI11518','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11829','SCD_KE','chlorzoxazone 250 MG / paracetamol 325 MG Oral Tablet','KEGI11829','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG11842','SCD_KE','aceclofenac 100 MG / paracetamol 325 MG Oral Tablet','KEGI11518','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12012','SCD_KE','lornoxicam 4 MG / paracetamol 500 MG Oral Tablet','KEGI11641','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12068','SCD_KE','indapamide 1.5 MG / amLODIPine 10 MG Modified Release Oral Tablet','KEGI12068','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12069','SCD_KE','indapamide 1.5 MG / amLODIPine 5 MG Modified Release Oral Tablet','KEGI12068','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1217','SCD_KE','isophane (NPH) insulin, human 70 UNITS/ML / soluble insulin, human 30 UNITS/ML Suspension for Injection in 3 ML Cartridge','KEGI281','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12227','SCD_KE','artemether 300 MG in 3 ML Injection','KEGI12227','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12301','SCD_KE','artemether 100 MG/ML Injection Solution','KEGI12227','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1235','SCD_KE','isophane (NPH) insulin, human 100 UNITS/ML Suspension for Injection in 3 ML Cartridge','KEGI1235','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12395','SCD_KE','cefoperazone 500 MG / sulbactam 500 MG Injection','KEGI12395','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12488','SCD_KE','aspirin 150 MG / paracetamol 250 MG / caffeine 30 MG Oral Tablet','KEGI12488','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12560','SCD_KE','paracetamol 120 MG Effervescent Oral Tablet','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG12610','SCD_KE','ibuprofen 400 MG / paracetamol 500 MG Oral Tablet','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG129','SCD_KE','artesunate 30 MG/ML Injection','KEGI10218','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1301','SCD_KE','artemether 80 MG/ML Injection Solution','KEGI12227','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG13036','SCD_KE','B-artemether 80 MG / lumefantrine 480 MG Oral Tablet','KEGI1165','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG13066','SCD_KE','pyronaridine tetraphosphate 180 MG / artesunate 60 MG Oral Tablet','KEGI13066','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG13074','SCD_KE','cefoperazone 1000 MG / sulbactam 1000 MG Injection','KEGI12395','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG13284','SCD_KE','aceclofenac 200 MG / serratiopeptidase 30 MG Oral Tablet','KEGI13284','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG13360','SCD_KE','aceclofenac 100 MG / paracetamol 325 MG / chlorzoxazone 250 MG Oral Tablet','KEGI13360','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1391','SCD_KE','mefenamic acid 250 MG / paracetamol 500 MG Oral Tablet','KEGI1391','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG1445','SCD_KE','artemether 20 MG/ML Injection','KEGI12227','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG14953','SCD_KE','aceclofenac 100 MG / paracetamol 500 MG / chlorzoxazone 250 MG Oral Tablet','KEGI13360','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG15001','SCD_KE','artesunate 50 MG Rectal Suppository','KEGI10218','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG15189','SCD_KE','cilnidipine 5 MG Oral Tablet','KEGI15189','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG15490','SCD_KE','cilnidipine 10 MG Oral Tablet','KEGI15189','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG16179','SCD_KE','aceclofenac 100 MG / paracetamol 325 MG / chlorzoxazone 500 MG Oral Tablet','KEGI13360','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG201','SCD_KE','norfloxacin 400 MG / tinidazole 600 MG Oral Tablet','KEGI201','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2096','SCD_KE','levosalbutamol 1 MG Oral Tablet','KEGI2096','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2097','SCD_KE','levosalbutamol 1 MG in 5 ML Oral Solution','KEGI2096','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2286','SCD_KE','fluticasone propionate 250 MCG/PUFF / salmeterol 25 MCG/PUFF Metered Dose Inhaler, 120 Puffs','284635','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG231','SCD_KE','calcium carbonate 80 MG / sodium alginate 250 MG / sodium bicarbonate 133.5 MG Oral Tablet','KEGI108','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2315','SCD_KE','salmeterol 25 MCG/ACTUAT / fluticasone 125 MCG/ACTUAT HFA Metered Dose Inhaler, 120 Metered Inhalations','284635','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2318','SCD_KE','salmeterol 25 MCG/ACTUAT / fluticasone propionate 250 MCG/ACTUAT HFA Metered Dose Inhaler, 120 Metered Inhalations','284635','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG235','SCD_KE','calcium carbonate 160 MG / sodium alginate 500 MG / sodium bicarbonate 267 MG in 10 ML Oral Suspension','KEGI108','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2682','SCD_KE','ampicillin 60 MG / cloxacillin 30 MG in 0.6 ML Oral Suspension','106846','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2700','SCD_KE','ampicillin 125 MG / cloxacillin 125 MG in 5 ML Powder for Oral Solution','106846','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2728','SCD_KE','paracetamol 200 MG / aspirin 400 MG / caffeine 50 MG Oral Tablet','KEGI12488','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG274','SCD_KE','mefenamic acid 500 MG / paracetamol 450 MG Oral Tablet','KEGI1391','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG2981','SCD_KE','ibuprofen 100 MG / paracetamol 125 MG in 5 ML Oral Suspension','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3022','SCD_KE','glimepiride 1 MG / metFORMIN HCL 500 MG Sustained Release Oral Tablet','KEGI3022','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3192','SCD_KE','aspirin 250 MG / paracetamol 250 MG / caffeine 30 MG Oral Tablet','KEGI12488','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG342','SCD_KE','dihydroartemisinin 80 MG / piperaquine phosphate 640 MG in 80 ML Powder for Oral Suspension','KEGI11623','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3505','SCD_KE','paracetamol 250 MG / aspirin 300 MG / caffeine 30 MG Oral Tablet','KEGI12488','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3557','SCD_KE','aceclofenac 100 MG / paracetamol 500 MG / chlorzoxazone 375 MG Oral Tablet','KEGI13360','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3632','SCD_KE','aceclofenac 100 MG / paracetamol 500 MG / chlorzoxazone 500 MG Oral Tablet','KEGI13360','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3704','SCD_KE','aceclofenac 100 MG / serratiopeptidase 15 MG Oral Tablet','KEGI13284','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3785','SCD_KE','paracetamol 350 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','KEGI3785','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3815','SCD_KE','paracetamol 300 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','KEGI3785','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3832','SCD_KE','paracetamol 600 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 60 MG Oral Tablet','KEGI11122','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG3861','SCD_KE','paracetamol 120 MG / chlorpheniramine maleate 1 MG / pseudoephedrine HCL 15 MG in 5 ML Oral Solution','KEGI11122','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG4110','SCD_KE','paracetamol 120 MG in 5 ML Oral Suspension','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG432','SCD_KE','paracetamol 240 MG in 5 ML Oral Solution','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG4372','SCD_KE','alpha-beta arteether 150 MG in 2 ML Injection','KEGI10316','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG4392','SCD_KE','ampicillin 125 MG / cloxacillin 125 MG in 5 ML Oral Suspension','106846','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG4459','SCD_KE','chlorzoxazone 250 MG / paracetamol 300 MG Oral Capsule','KEGI11829','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG464','SCD_KE','artemether 40 MG/ML Injection Solution','KEGI12227','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG4920','SCD_KE','diclofenac potassium 50 MG / paracetamol 500 MG / serratiopeptidase 15 MG Oral Tablet','KEGI4920','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG510','SCD_KE','paracetamol 400 MG / chlorpheniramine maleate 4 MG / pseudoephedrine HCL 30 MG / caffeine 30 MG Oral Capsule','KEGI3785','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG5176','SCD_KE','glimepiride 2 MG / metFORMIN HCL 500 MG Oral Tablet','KEGI3022','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG5199','SCD_KE','glimepiride 2 MG / metFORMIN HCL 500 MG Sustained Release Oral Tablet','KEGI3022','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG5235','SCD_KE','traMADol HCL 50 MG / paracetamol 500 MG Oral Tablet','352362','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG5419','SCD_KE','artesunate 100 MG / amodiaquine 270 MG Oral Tablet','KEGI10843','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG5630','SCD_KE','diclofenac sodium 50 MG / paracetamol 500 MG / serratiopeptidase 15 MG Oral Tablet','KEGI4920','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG588','SCD_KE','paracetamol 120 MG / chlorpheniramine maleate 2 MG / pseudoephedrine HCL 10 MG in 5 ML Oral Solution','KEGI11122','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG6024','SCD_KE','ibuprofen 200 MG / paracetamol 250 MG / caffeine 30 MG Oral Capsule','KEGI6024','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG6026','SCD_KE','ibuprofen 400 MG / paracetamol 325 MG Oral Tablet','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG6121','SCD_KE','glimepiride 2 MG / pioglitazone HCL 15 MG / metFORMIN HCL 500 MG Sustained Release Oral Tablet','KEGI6121','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG6142','SCD_KE','ampicillin 250 MG / cloxacillin 250 MG Injection','106846','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG6996','SCD_KE','glimepiride 1 MG / metFORMIN HCL 500 MG Oral Tablet','KEGI3022','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7106','SCD_KE','ibuprofen 100 MG / paracetamol 120 MG in 5 ML Oral Suspension','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7202','SCD_KE','ibuprofen 400 MG / paracetamol 500 MG / chlorzoxazone 250 MG Oral Tablet','KEGI7202','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7228','SCD_KE','chlorzoxazone 250 MG / paracetamol 500 MG Oral Tablet','KEGI11829','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7385','SCD_KE','perindopril arginine 10 MG / indapamide 2.5 MG Oral Tablet','388499','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7387','SCD_KE','perindopril arginine 5 MG / indapamide 1.25 MG Oral Tablet','388499','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7412','SCD_KE','gliclazide 60 MG Oral Tablet','4816','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7602','SCD_KE','ampicillin 500 MG / cloxacillin 500 MG Injection','106846','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG7742','SCD_KE','irbesartan 150 MG / amLODIPine besilate 5 MG Oral Tablet','KEGI7742','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8009','SCD_KE','paracetamol 30 MG/ML Oral Solution','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8159','SCD_KE','codeine phosphate 10 MG / doxylamine succinate 5 MG / paracetamol 450 MG / caffeine 50 MG Oral Tablet','KEGI8159','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8162','SCD_KE','ibuprofen 200 MG / paracetamol 250 MG in 10 ML Oral Suspension','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8163','SCD_KE','ibuprofen 200 MG / paracetamol 250 MG Oral Capsule','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8193','SCD_KE','paracetamol 200 MG / aspirin 300 MG / caffeine 30 MG Oral Tablet','KEGI12488','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8218','SCD_KE','codeine phosphate 10 MG / doxylamine succinate 5 MG / paracetamol 450 MG / caffeine 45 MG Oral Tablet','KEGI8159','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8261','SCD_KE','metroNIDAZOLE 10 MG / chlorhexidine gluconate 0.5 MG per 1 GM Oral Gel','KEGI8261','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG8645','SCD_KE','levosalbutamol sulphate 1.25 MG in 2.5 ML Inhalation Solution','KEGI2096','IN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9006','SCD_KE','irbesartan 150 MG / amLODIPine besilate 10 MG Oral Tablet','KEGI7742','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9008','SCD_KE','irbesartan 300 MG / amLODIPine besilate 5 MG Oral Tablet','KEGI7742','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9009','SCD_KE','irbesartan 300 MG / amLODIPine besilate 10 MG Oral Tablet','KEGI7742','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG929','SCD_KE','paracetamol 120 MG Oral Tablet','KEGI10644','IN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9377','SCD_KE','ibuprofen 100 MG / paracetamol 162.5 MG in 5 ML Oral Suspension','KEGI11297','MIN_KE','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9380','SCD_KE','metroNIDAZOLE benzoate 10 MG Oral Gel','6922','IN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG9535','SCD_KE','SITagliptin 50 MG / metFORMIN HCL 850 MG Oral Tablet','729717','MIN','ke;',NULL)
INSERT INTO c_Drug_Formulation VALUES ('KEG995','SCD_KE','paracetamol 300 MG / aspirin 600 MG / caffeine 50 MG Oral Tablet','KEGI12488','MIN','ke;',NULL)

UPDATE c_Drug_Formulation 
SET ingr_rxcui = '1008065'
WHERE form_rxcui = 'KEG3971'


