DELETE FROM [c_Drug_Brand]
DELETE FROM [c_Drug_Generic]
DELETE FROM [c_Drug_Generic_Ingredient]
DELETE FROM [c_Drug_Formulation]
DELETE FROM [c_Drug_Pack]
DELETE FROM [c_Drug_Pack_Formulation]

-- Includes first 1000 Kenya drugs and new strength, dose_form columns

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
