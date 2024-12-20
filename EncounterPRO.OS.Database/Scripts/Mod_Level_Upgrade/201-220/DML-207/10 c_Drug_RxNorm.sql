DELETE FROM [c_Drug_Brand]
DELETE FROM [c_Drug_Generic]
DELETE FROM [c_Drug_Generic_Ingredient]
DELETE FROM [c_Drug_Formulation]
DELETE FROM [c_Drug_Pack]
DELETE FROM [c_Drug_Pack_Formulation]

BULK INSERT [c_Drug_Brand]
FROM '\\localhost\attachments\c_Drug_Brand.txt'
-- 

BULK INSERT [c_Drug_Generic]
FROM '\\localhost\attachments\c_Drug_Generic.txt'
-- 

BULK INSERT [c_Drug_Generic_Ingredient]
FROM '\\localhost\attachments\c_Drug_Generic_Ingredient.txt'
-- 

BULK INSERT [c_Drug_Formulation]
FROM '\\localhost\attachments\c_Drug_Formulation.txt'
-- 

BULK INSERT [c_Drug_Pack]
FROM '\\localhost\attachments\c_Drug_Pack.txt'
-- 

BULK INSERT [c_Drug_Pack_Formulation]
FROM '\\localhost\attachments\c_Drug_Pack_Formulation.txt'
--

-- Will need to adjust later for RXNORM drugs not available in Kenya
UPDATE c_Drug_Formulation SET valid_in = 'us;ke;'
UPDATE c_Drug_Pack SET valid_in = 'us;ke;'

-- the rest are probably already done

-- Adderall corrections (due to use of PINs involving 1 ingredient)
UPDATE c_Drug_Brand SET generic_rxcui = '822929' WHERE brand_name_rxcui = '84815'

-- Tdap vaccine
UPDATE c_Drug_Brand SET generic_rxcui = '1300188' WHERE brand_name_rxcui IN ('605718','352572')
UPDATE c_Drug_Brand SET generic_rxcui = '1300367' WHERE brand_name_rxcui IN ('583411','224903')

DELETE FROM c_Drug_Generic WHERE generic_rxcui = 'G224903'

UPDATE c_Office set country = 'US' 
WHERE office_id = '0001'
