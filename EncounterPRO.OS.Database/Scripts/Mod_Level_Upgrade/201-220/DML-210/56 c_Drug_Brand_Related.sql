-- We need to build this after cleaning up the formulations,
-- so we can use the cleaned formulations to populate brand_name_rxcui

-- Populate c_Drug_Brand_Related
DELETE FROM [c_Drug_Brand_Related]

-- ones we have used unique to Kenya (excludes packs)
INSERT INTO [c_Drug_Brand_Related] (
	[country_code],
	[source_id],
	[source_brand_form_descr],
	[brand_name_rxcui],
	[is_single_ingredient])
SELECT 'ke',
	k.Retention_No, 
	k.SBD_Version,
	b.brand_name_rxcui,
	b.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Brand b 
	ON b.brand_name_rxcui = 'KEBI' + k.Retention_No
-- (1480 row(s) affected)

-- Referenced through c_Drug_Formulation as KE brand
INSERT INTO [c_Drug_Brand_Related] (
	[country_code],
	[source_id],
	[source_brand_form_descr],
	[brand_name_rxcui],
	[is_single_ingredient])
SELECT 'ke',
	k.Retention_No, 
	k.SBD_Version,
	b.brand_name_rxcui,
	b.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Formulation f ON f.form_rxcui = 'KEB' + k.Retention_No
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Brand_Related] r
	WHERE r.[source_id] = k.Retention_No)
-- (576 row(s) affected)

-- Referenced through c_Drug_Formulation as RXNORM brand (exact same wording)
INSERT INTO [c_Drug_Brand_Related] (
	[country_code],
	[source_id],
	[source_brand_form_descr],
	[brand_name_rxcui],
	[is_single_ingredient])
SELECT 'ke',
	k.Retention_No, 
	k.SBD_Version,
	b.brand_name_rxcui,
	b.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Formulation f ON f.form_descr = k.SBD_Version
JOIN c_Drug_Brand b ON b.brand_name_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Brand_Related] r
	WHERE r.[source_id] = k.Retention_No)
-- (177 row(s) affected)

DELETE 
-- select *
FROM [c_Drug_Brand_Related]
WHERE [source_id] IN ('3308','3309','10484','10485','5575','1034','7850','7852','3692')

INSERT INTO [c_Drug_Brand_Related] (
	[country_code],
	[source_id],
	[source_brand_form_descr],
	[brand_name_rxcui],
	[is_single_ingredient])
VALUES 
('ke','3308','Depo-MEDrol 40 MG/ML Injection','22584',1),
('ke','3309','Depo-Provera 150 MG/ML Injection','202886',1),
('ke','10484','GlucoPHAGE XR 500 MG Extended Release Oral Tablet','151827',1),
('ke','10485','GlucoPHAGE XR 750 MG Extended Release Oral Tablet','151827',1),
('ke','5575','Isoptin SR 240 MG Sustained Release Oral Tablet','203489',1),
('ke','1034','Mirena 52 MG Intrauterine Delivery System','152061',1),
('ke','7850','Zestril 10 MG Oral Tablet','196472',1),
('ke','7852','Zestril 20 MG Oral Tablet','196472',1),
('ke','3692','Zofran 2 MG/ML Injection','66981',1)

/* The rest of these, over 100, have SBD_Version the same 
-- as the generic formulation, or "no brand name" and should
-- not be in this table
-- also excludes packs which will have to be a later release
select * 
FROM Kenya_Drugs k
LEFT JOIN [c_Drug_Brand_Related] r ON r.source_id = k.Retention_No
WHERE r.source_id IS NULL
AND k.SBD_Version NOT LIKE '%{%'
AND k.Retention_No NOT IN (
'00nobrandfound',
'No Retention No',
'Not in Retention List')
*/

UPDATE b
SET valid_in = CASE 
	WHEN brand_name_rxcui LIKE 'KEBI%' THEN 'ke;'  
	ELSE 'us;'
	END
FROM c_Drug_Brand b
-- (5870 row(s) affected)

UPDATE b
SET valid_in = valid_in + 'ke;'
FROM c_Drug_Brand b
JOIN c_Drug_Brand_Related r ON r.brand_name_rxcui = b.brand_name_rxcui
WHERE valid_in NOT LIKE '%ke;%'
-- (155 row(s) affected)
