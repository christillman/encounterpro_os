
-- Corrections from Uganda import, standardisations
update [c_Drug_Generic_Related] set active_ingredients = 'chlorpheniramine / dexamethasone' where active_ingredients = 'chlorpheniramin / examethasone'
update [c_Drug_Generic_Related] set active_ingredients = 'bromhexine / guaifenesin / menthol / salbutamol' where active_ingredients = 'bromhexin / uaifenesi / entho / albutamol'
update [c_Drug_Generic_Related] set active_ingredients = 'dead sea salts / sodium chloride' where active_ingredients = 'dead sea salt / odium chloride'
update [c_Drug_Generic_Related] set active_ingredients = 'ambroxol / guaifenesin / levosalbutamol' where active_ingredients = 'ambroxol HCl/levosalbutamol/guaifenesin'
update [c_Drug_Generic_Related] set active_ingredients = 'bromhexine / guaifenesin / terbutaline' where active_ingredients = 'bromhexine/guaifenesin/terbutaline'
 
DELETE FROM c_Drug_Generic WHERE generic_name = 'ambroxol HC / evosalbutamo / uaifenesin'
UPDATE c_Drug_Generic SET generic_name = 'ambroxol / guaifenesin / levosalbutamol' WHERE generic_name = 'ambroxol HCl/levosalbutamol/guaifenesin'
DELETE FROM c_Drug_Generic WHERE generic_name = 'bromhexin / uaifenesi / entho / albutamol'
UPDATE c_Drug_Generic SET generic_name = 'bromhexine / guaifenesin / terbutaline' WHERE generic_name = 'bromhexine/guaifenesin/terbutaline'
UPDATE c_Drug_Generic SET generic_name = 'chlorpheniramine / dexamethasone' WHERE generic_name = 'chlorpheniramin / examethasone'
UPDATE c_Drug_Generic SET generic_name = 'betamethasone / clotrimazole / neomycin' WHERE generic_name = 'betamethasone / clotrimazole / neomcyin'
UPDATE c_Drug_Generic SET generic_name = 'nortriptyline / pregabalin' WHERE generic_name = 'nortryptyline / pregabalin'
UPDATE c_Drug_Generic SET generic_name = REPLACE(generic_name,'pyridoxine HCl', 'pyridoxine') WHERE generic_name LIKE '%pyridoxine HCl%'
UPDATE c_Drug_Generic SET generic_name = REPLACE(generic_name,'pyridoxine hydrochloride', 'pyridoxine') WHERE generic_name LIKE '%pyridoxine hydrochloride%'
UPDATE c_Drug_Generic SET generic_name = REPLACE(generic_name,'(equivalent to nitroglycerin', '') WHERE generic_name LIKE '%(equivalent to nitroglycerin%'
UPDATE c_Drug_Generic SET generic_name = REPLACE(generic_name,'(equivalent to nitroglycerin', '') WHERE generic_name LIKE '%(equivalent to nitroglycerin%'
UPDATE c_Drug_Generic SET generic_name = REPLACE(generic_name,'(equiv to elemental Fe', '') WHERE generic_name LIKE '%(equiv to elemental Fe%'

-- eliminate citocoline in favor of citicoline
UPDATE c_Drug_Formulation SET ingr_rxcui = '997602' WHERE ingr_rxcui = 'KEGI10285'
UPDATE c_Drug_Brand SET generic_rxcui = '997602' WHERE generic_rxcui = 'KEGI10285'
UPDATE c_Drug_Generic_Related SET source_generic_form_descr = 'citicoline 1000 MG in 10 ML Oral Solution',
	active_ingredients = 'citicoline', generic_rxcui = '997602' 
	WHERE source_id = '10285' and country_code = 'ke'
UPDATE c_Drug_Definition SET generic_name = 'citicoline' WHERE generic_name = 'citocoline'
DELETE FROM c_Drug_Definition WHERE drug_id = 'KEGI10285'
DELETE FROM c_Drug_Generic WHERE generic_rxcui = 'KEGI10285'

-- eliminate Polymyxin-B in favor of Polymyxin B
UPDATE c_Drug_Formulation SET ingr_rxcui = '8536', valid_in = 'us;ke;ug;' WHERE ingr_rxcui = 'KEGI14159'
UPDATE c_Drug_Brand SET generic_rxcui = '8536' WHERE generic_rxcui = 'KEGI14159'
UPDATE c_Drug_Generic_Related SET generic_rxcui = '8536' WHERE generic_rxcui = 'KEGI14159'
DELETE FROM c_Drug_Definition WHERE drug_id = 'KEGI14159'
DELETE FROM c_Drug_Generic WHERE generic_rxcui = 'KEGI14159'

-- replacements found for c_Drug_Source_Formulation
UPDATE [c_Drug_Generic_Related] SET generic_rxcui = '1008065' WHERE source_id = '3971' and country_code = 'ke'
UPDATE [c_Drug_Generic_Related] SET generic_rxcui = '69120' WHERE source_id = '3072B' and country_code = 'ke'
DELETE FROM c_Drug_Generic where generic_rxcui = 'KEGI3072B'
UPDATE [c_Drug_Generic_Related] SET generic_rxcui = 'KEGI7058' WHERE source_id = '7058B' and country_code = 'ke'
UPDATE [c_Drug_Brand_Related] SET brand_name_rxcui = 'KEBI7058' WHERE source_id = '7058B' and country_code = 'ke'
UPDATE [c_Drug_Brand_Related] SET brand_name_rxcui = '261542' WHERE source_id = '1213' and country_code = 'ke'
UPDATE [c_Drug_Brand_Related] SET brand_name_rxcui = '261542' WHERE source_id = '9230' and country_code = 'ke'


DELETE g
FROM [c_Drug_Generic_Related] g 
WHERE country_code = 'ug' 
AND source_id IN (
SELECT r1.source_id
FROM [c_Drug_Brand_Related] r1
JOIN [c_Drug_Brand_Related] r2 
	ON r1.source_brand_form_descr = r2.source_brand_form_descr
	AND r1.country_code = r2.country_code
	AND r1.brand_name_rxcui = r2.brand_name_rxcui
WHERE r1.source_id > r2.source_id
AND r1.country_code = 'ug'
)

DELETE r1 
FROM [c_Drug_Brand_Related] r1
JOIN [c_Drug_Brand_Related] r2 
	ON r1.source_brand_form_descr = r2.source_brand_form_descr
	AND r1.country_code = r2.country_code
	AND r1.brand_name_rxcui = r2.brand_name_rxcui
WHERE r1.source_id > r2.source_id
AND r1.country_code = 'ug'

DELETE g
FROM [c_Drug_Generic_Related] g 
WHERE source_id BETWEEN 'NL00017' AND 'NL00032'
AND g.country_code = 'ug' 

-- Were "none" in first Uganda spreadsheet, can now be identified
UPDATE [c_Drug_Brand_Related] SET source_id = '4115' WHERE source_id = 'NL00001' and country_code = 'ug'
UPDATE [c_Drug_Brand_Related] SET source_id = '6759' WHERE source_id = 'NL00007' and country_code = 'ug'

UPDATE [c_Drug_Brand_Related] SET source_brand_form_descr = 'Beuflox-D 0.3 % / 0.1 % OTIC Suspension' 
WHERE source_id = '15702B' and country_code = 'ke'

UPDATE [c_Drug_Generic_Related] SET source_id = '4115' WHERE source_id = 'NL00001' and country_code = 'ug'
UPDATE [c_Drug_Generic_Related] SET source_id = '6759' WHERE source_id = 'NL00007' and country_code = 'ug'

UPDATE [c_Drug_Generic_Related] SET source_generic_form_descr 
	= REPLACE(source_generic_form_descr, 'MCG / INHAL', 'MCG/INHAL')
WHERE source_generic_form_descr LIKE '%MCG / INHAL%'
