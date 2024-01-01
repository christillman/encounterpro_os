
-- Duplicated brand
DELETE 
-- select *
FROM c_Drug_Brand 
where brand_name = 'INJ.K MM' 
AND brand_name_rxcui = 'KEBI16615'

SELECT * FROM c_Drug_Brand b
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Definition d 
	WHERE d.drug_id = b.drug_id)

-- from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
-- these will be inserted in 45 c_Drug_Generic
update c_Drug_Brand SET generic_rxcui = '7417' WHERE generic_rxcui = 'KEGI3979'
update c_Drug_Brand SET generic_rxcui = '16689' WHERE generic_rxcui = 'KEGI1426'
update c_Drug_Brand SET generic_rxcui = '438399' WHERE generic_rxcui = 'KEGI14266'
update c_Drug_Brand SET generic_rxcui = '1904' WHERE generic_rxcui = 'KEGI7273'
update c_Drug_Brand SET generic_rxcui = '2023' WHERE generic_rxcui = 'KEGI5514'
update c_Drug_Brand SET generic_rxcui = '2239' WHERE generic_rxcui = 'KEGI5399'
update c_Drug_Brand SET generic_rxcui = '2549' WHERE generic_rxcui = 'KEGI7888'
update c_Drug_Brand SET generic_rxcui = '262272' WHERE generic_rxcui = 'KEGI2815'
update c_Drug_Brand SET generic_rxcui = '2625' WHERE generic_rxcui = 'KEGI866'
update c_Drug_Brand SET generic_rxcui = '237162' WHERE generic_rxcui = 'KEGI7957'
update c_Drug_Brand SET generic_rxcui = '233386' WHERE generic_rxcui = 'KEGI467'
update c_Drug_Brand SET generic_rxcui = '23203' WHERE generic_rxcui = 'KEGI11145'
update c_Drug_Brand SET generic_rxcui = '23796' WHERE generic_rxcui = 'KEGI12622'
update c_Drug_Brand SET generic_rxcui = '4112' WHERE generic_rxcui = 'KEGI8283'
update c_Drug_Brand SET generic_rxcui = '24608' WHERE generic_rxcui = 'KEGI684'
update c_Drug_Brand SET generic_rxcui = '307296' WHERE generic_rxcui = 'KEGI10587'
update c_Drug_Brand SET generic_rxcui = '644529' WHERE generic_rxcui = 'KEGI5392'
update c_Drug_Brand SET generic_rxcui = '4816' WHERE generic_rxcui = 'KEGI3475'
update c_Drug_Brand SET generic_rxcui = '25793' WHERE generic_rxcui = 'KEGI590'
update c_Drug_Brand SET generic_rxcui = '106964' WHERE generic_rxcui = 'KEGI7847'
update c_Drug_Brand SET generic_rxcui = '1851' WHERE generic_rxcui = 'KEGI424'
update c_Drug_Brand SET generic_rxcui = '687386' WHERE generic_rxcui = 'KEGI1500'
update c_Drug_Brand SET generic_rxcui = '20890' WHERE generic_rxcui = 'KEGI143'
update c_Drug_Brand SET generic_rxcui = '6693' WHERE generic_rxcui = 'KEGI2974'
update c_Drug_Brand SET generic_rxcui = '7240' WHERE generic_rxcui = 'KEGI11211'
update c_Drug_Brand SET generic_rxcui = '392475' WHERE generic_rxcui = 'KEGI5858'
update c_Drug_Brand SET generic_rxcui = '388499' WHERE generic_rxcui = 'KEGI4945'
update c_Drug_Brand SET generic_rxcui = '8351' WHERE generic_rxcui = 'KEGI4368'
update c_Drug_Brand SET generic_rxcui = '435' WHERE generic_rxcui = 'KEGI4584'
update c_Drug_Brand SET generic_rxcui = '9794' WHERE generic_rxcui = 'KEGI6979'
UPDATE c_Drug_Brand SET generic_rxcui = '203218' where generic_rxcui IN ('KEGI11997','KEGI1093')
update c_Drug_Brand SET generic_rxcui = '38085' WHERE generic_rxcui = 'KEGI11651'
update c_Drug_Brand SET generic_rxcui = '11065' WHERE generic_rxcui = 'KEGI7238'
update c_Drug_Brand SET generic_rxcui = '40001' WHERE generic_rxcui = 'KEGI5900'

-- Revise existing Humalog Mix to HumaLOG Mix-25
UPDATE c_Drug_Brand
SET brand_name = 'HumaLOG Mix-25' 
WHERE brand_name_rxcui = '261542'
DELETE FROM c_Drug_Brand
WHERE brand_name_rxcui = 'KEBI1207'
DELETE FROM c_Drug_Definition
WHERE drug_id = 'KEBI1207'
UPDATE c_Drug_Brand_Related 
SET brand_name_rxcui = '261542'
WHERE brand_name_rxcui IN ('KEBI1207','KEBI9230')
UPDATE c_Drug_Formulation 
SET ingr_rxcui = '261542'
WHERE form_rxcui IN ('KEB1207','KEB1211','KEB9230')
