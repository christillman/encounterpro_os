

UPDATE [c_Drug_Definition] SET generic_name = 'betamethasone / clotrimazole / neomycin' WHERE drug_id in ('KEBI9772', 'KEGI9772')
UPDATE [c_Drug_Definition] SET generic_name = 'chlorpheniramine / dexamethasone' WHERE drug_id in ('UGBI4000', 'UGGI4000')
UPDATE [c_Drug_Definition] SET common_name = 'betamethasone / clotrimazole / neomycin' WHERE drug_id in ('KEGI9772')
UPDATE [c_Drug_Definition] SET common_name = 'chlorpheniramine / dexamethasone' WHERE drug_id in ('UGGI4000')
UPDATE [c_Drug_Definition] SET generic_name = 'bromhexine / guaiFENesin / menthol / salbutamol' WHERE drug_id in ('UGBI4855')
UPDATE [c_Drug_Definition] SET generic_name = 'ambroxol / levosalbutamol / guaifenesin' WHERE drug_id in ('UGBI6424')
UPDATE [c_Drug_Definition] SET generic_name = 'bromhexine / guaifenesin / terbutaline' WHERE drug_id in ('UGBI6489')

INSERT INTO [c_Drug_Generic]
	   ([generic_name]
	   ,[generic_rxcui]
	   ,[is_single_ingredient]
	   ,[drug_id]
	   ,[valid_in])
SELECT
	   'bromhexine / guaifenesin / terbutaline'
	   ,'UGGI6489'
	   ,0
	   ,'UGGI6489'
	   ,'ug'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic] WHERE [generic_rxcui] = 'UGGI6489')

INSERT INTO [c_Drug_Generic]
	   ([generic_name]
	   ,[generic_rxcui]
	   ,[is_single_ingredient]
	   ,[drug_id]
	   ,[valid_in])
 SELECT
	   'ambroxol / levosalbutamol / guaifenesin'
	   ,'UGGI6424'
	   ,0
	   ,'UGGI6424'
	   ,'ug'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic] WHERE [generic_rxcui] = 'UGGI6424')

INSERT INTO [c_Drug_Generic]
	   ([generic_name]
	   ,[generic_rxcui]
	   ,[is_single_ingredient]
	   ,[drug_id]
	   ,[valid_in])
 SELECT
	   'meningococcal polysaccharide, groups A, C, Y and W-135 conjugate vaccine 0.5 ML Injection'
	   ,'KEGI12367'
	   ,0
	   ,'KEGI12367'
	   ,'ug'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic] WHERE [generic_rxcui] = 'UGGI6424')

UPDATE c_Drug_Source_Formulation SET active_ingredients = 'ambroxol / levosalbutamol / guaifenesin' WHERE source_id = '6424'
UPDATE c_Drug_Source_Formulation SET active_ingredients = 'bromhexine / guaifenesin / terbutaline' WHERE source_id = '6489'

UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1517' WHERE generic_rxcui = 'UGGI4855'
UPDATE c_Drug_Brand SET generic_rxcui = '1008395' WHERE generic_rxcui = 'KEGI12367'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1517' WHERE ingr_rxcui = 'UGGI4855'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1008395' WHERE ingr_rxcui = 'KEGI12367'

UPDATE c_Drug_Source_Formulation SET generic_rxcui = 'KEGI1517' WHERE generic_rxcui = 'UGGI4855'
UPDATE c_Drug_Source_Formulation SET generic_rxcui = '1008395' WHERE generic_rxcui = 'KEGI12367'

INSERT INTO c_Drug_Formulation
( [form_rxcui]
      ,[form_tty]
      ,[form_descr]
      ,[ingr_rxcui]
      ,[ingr_tty]
      ,[valid_in]
)
 SELECT
	   'KEG441'
	   ,'SCD_KE'
	   ,'aceclofenac 100 mg Rectal Suppository'
	   ,'KEGI441'
	   ,'IN_KE'
	   ,'ug'
FROM c_1_record
WHERE NOT EXISTS (SELECT 1 FROM c_Drug_Formulation WHERE [form_rxcui] = 'KEG441')

UPDATE c_Drug_Formulation SET generic_form_rxcui = 'KEG441' WHERE form_rxcui = 'KEB441'

UPDATE c_Drug_Formulation
SET ingr_rxcui = '1008134'
where ingr_rxcui in (
'1007154',
'1007389',
'1007829',
'1007598')

DELETE from c_Drug_Generic
WHERE generic_rxcui IN (
'1007154',
'1007389',
'1007829',
'1007598')

UPDATE c_Drug_Brand
SET brand_name = 'Isopto Carpine'
WHERE brand_name = 'Isoptocarpine'

UPDATE c_Drug_Definition
SET common_name = 'Isopto Carpine'
WHERE common_name = 'Isoptocarpine'

-- These are generic names, not brand names
DELETE FROM c_Drug_Brand
WHERE drug_id in ('KEBI6715','KEBI5723','KEBI2939')

DELETE 
-- select * 
FROM c_Drug_Formulation
WHERE ingr_rxcui in ('KEBI6715','KEBI5723','KEBI2939')

UPDATE c_Drug_Definition
SET status = 'NA'
WHERE drug_id in ('KEBI6715','KEBI5723','KEBI2939')

UPDATE c_Drug_Source_Formulation
SET brand_name_rxcui = NULL, brand_form_rxcui = NULL
WHERE brand_name_rxcui in ('KEBI6715','KEBI5723','KEBI2939')