
-- Remove those that are inserted below
DELETE FROM [c_Dosage_Form]
WHERE [description] IN (
'Chewable Tablet',
'Chewing Gum',
'Disintegrating Oral Tablet',
'Drug Implant',
'Medicated Bar Soap',
'Medicated Pad',
'Medicated Patch',
'Medicated Shampoo',
'Medicated Tape',
'Nasal Inhalant',
'Pack',
'Pen Injector'
)

-- these would now be duplicates
DELETE FROM [c_Dosage_Form]
WHERE [dosage_form] IN (
'Oral Capsule', 
'Oral Tablet', 
'Vaginal Tablet',
'Vag Ovule',
'Vag Pessary')

UPDATE [c_Dosage_Form] SET description = 'Cartridge' WHERE [dosage_form] = 'Cartridge' AND rxcui = '1649572'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Chewable Tablet', 'Chewable Tablet', 'PO', 'TAB','91058')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Chew Tab' AND rxcui = '91058'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Chewing Gum', 'Chewing Gum', 'PO', 'GUM','402499')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Gum' AND rxcui = '402499'
UPDATE [c_Dosage_Form] SET description = 'Delayed Release Oral Capsule' WHERE [dosage_form] = 'DR Caps' AND rxcui = '316995'
UPDATE [c_Dosage_Form] SET description = 'Delayed Release Oral Tablet' WHERE [dosage_form] = 'DR Tabs' AND rxcui = '10312'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('DisOral Tab', 'Disintegrating Oral Tablet', 'PO','TAB', '316942')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'DS Tabs' AND rxcui = '316942'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Drug Implant', 'Drug Implant', 'IN OFFICE', 'IMPL','657710')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Implant' AND rxcui = '657710'
UPDATE [c_Dosage_Form] SET description = 'Extended Release Oral Capsule' WHERE [dosage_form] = 'ER Caps' AND rxcui = '316943'
UPDATE [c_Dosage_Form] SET description = 'Extended Release Oral Tablet' WHERE [dosage_form] = 'ER Tabs' AND rxcui = '316945'
UPDATE [c_Dosage_Form] SET description = 'Granules for Oral Solution' WHERE [dosage_form] = 'Granules' AND rxcui = '1540453'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Bar Soap', 'Medicated Bar Soap', 'ON SKIN', 'BAR','316954')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Soap' AND rxcui = '316954'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Pad', 'Medicated Pad', 'APPLY', 'MEDICATEDPAD','797271')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Pads' AND rxcui = '797271'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Patch', 'Medicated Patch', 'ON SKIN', 'PATCH','1792831')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Patch' AND rxcui = '1792831'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Shampoo', 'Medicated Shampoo', 'APPLY', 'APPLY','106332')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Shampoo' AND rxcui = '106332'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Tape', 'Medicated Tape', 'ON SKIN','TAPE', '797685')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Tape' AND rxcui = '797685'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Nasal Inhalant', 'Nasal Inhalant', 'INHALE', 'INHALATION','316959')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Inhaler' AND rxcui = '316959'
UPDATE [c_Dosage_Form] SET description = 'Oral Capsule' WHERE [dosage_form] = 'Cap' AND rxcui = '316965'
UPDATE [c_Dosage_Form] SET description = 'Oral Tablet' WHERE [dosage_form] = 'Tab' AND rxcui = '317541'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Pack', 'Pack', 'ASDIR', 'PACK','746839')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Packet' AND rxcui = '746839'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Pen Injector', 'Pen Injector', 'Subcut', 'PEN','1649571')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Pens' AND rxcui = '1649571'
UPDATE [c_Dosage_Form] SET description = 'Urethral Suppository' WHERE [dosage_form] = 'Urethral Suppos' AND rxcui = '317543'
UPDATE [c_Dosage_Form] SET description = 'Vaginal Suppository' WHERE [dosage_form] = 'Vaginal Suppos' AND rxcui = '337840'
UPDATE [c_Dosage_Form] SET description = 'Vaginal Tablet', default_dose_unit = 'INSERT' WHERE [dosage_form] = 'Vag Tabs' AND rxcui = '11110'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Vag Ovule', 'Vaginal Ovule', 'INSERT', 'INSERT','KEVOV')
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Vag Pessary', 'Vaginal Pessary', 'INSERT', 'INSERT','KEVPS')

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'INHALE'
WHERE description LIKE '%Inhal%' AND rxcui IS NOT NULL 
AND [default_administer_method] IS NULL

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'PO' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND (description LIKE '%Oral%' 
OR description LIKE '%Buccal%' 
OR description LIKE '%Subling%')

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'APPLY'
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND ( description LIKE '%Cleanser%'
OR description LIKE '%Cream%'
OR description LIKE '%Foam%'
OR description LIKE '%Gel%'
OR description LIKE '%Lotion%'
OR description LIKE '%Mousse%'
OR description LIKE '%Ointment%'
OR description LIKE '%Pads%'
OR description LIKE '%Paste%'
OR description LIKE '%Topical%'
OR description LIKE '%Wash%' )

UPDATE [c_Dosage_Form] SET [default_dose_unit] = 'APPLY' 
WHERE rxcui IS NOT NULL AND [default_dose_unit] IS NULL
AND ( description LIKE '%Cleanser%'
OR description LIKE '%Cream%'
OR description LIKE '%Foam%'
OR description LIKE '%Gel%'
OR description LIKE '%Lotion%'
OR description LIKE '%Mousse%'
OR description LIKE '%Ointment%'
OR description LIKE '%Pads%'
OR description LIKE '%Topical%'
OR description LIKE '%Wash%' )

UPDATE [c_Dosage_Form] SET [default_dose_unit] = 'CM' 
WHERE rxcui IS NOT NULL
AND description LIKE '%Paste%'

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'ON SKIN', [default_dose_unit] = 'APPLY' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND (description LIKE '%Dressing%'
OR description LIKE '%Soap%'
OR description LIKE '%Strip%'
OR description LIKE '%Tape%')

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'ON SKIN', [default_dose_unit] = 'PATCH' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND (description LIKE '%Patch%'
OR description LIKE '%Transderm%')

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'SPRAY'
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND description LIKE '%Spray%'

UPDATE [c_Dosage_Form] SET [default_dose_unit] = 'SPRAY' 
WHERE rxcui IS NOT NULL AND [default_dose_unit] IS NULL
AND description LIKE '%Spray%'

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'Subcut', [default_dose_unit] = 'ML' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND description LIKE '%Inj%'

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'INTRAVAGINAL' 
WHERE description LIKE '%Vagin%' AND rxcui IS NOT NULL 
AND [default_administer_method] IS NULL

UPDATE [c_Dosage_Form] SET [default_dose_unit] = 'APPLY' 
WHERE rxcui IS NOT NULL 
AND [default_dose_unit] IS NULL AND [default_administer_method] = 'APPLY' 

UPDATE [c_Dosage_Form] SET [default_dose_unit] = 'INHALATION'
WHERE description LIKE '%Inhal%' AND rxcui IS NOT NULL 
AND [default_dose_unit] IS NULL


UPDATE [c_Dosage_Form] SET default_dose_unit = 'STRIP', default_administer_unit = 'STRIP' WHERE [dosage_form] LIKE '% Film' 

UPDATE [c_Dosage_Form] SET default_dose_unit = 'UNIT', default_administer_unit = 'UNIT' WHERE [dosage_form] = 'Inhalant Powder' AND rxcui = '317000'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLICATOR', default_administer_unit = 'APPLICATOR' WHERE [dosage_form] = 'Vaginal Foam' AND rxcui = '11107'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLICATOR', default_administer_unit = 'APPLICATOR' WHERE [dosage_form] = 'Vaginal Oint' AND rxcui = '317010'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'SUPP', default_administer_unit = 'SUPP' WHERE [dosage_form] = 'Rectal Suppos' AND rxcui = '316978'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'PUFF', default_administer_unit = 'PUFF' WHERE [dosage_form] = 'Metered Inhaler' AND rxcui = '721654'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'TSP', default_administer_unit = 'Mouthwash', default_administer_method = 'SWISHSPIT' WHERE [dosage_form] = 'Mouthwash' AND rxcui = '7067'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'ML' WHERE [dosage_form] = 'MucousMemSoln' AND rxcui = '316956'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLY' WHERE [dosage_form] = 'Oral Foam' AND rxcui = '346284'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLY' WHERE [dosage_form] = 'Oral Gel' AND rxcui = '346169'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'LOZG' WHERE [dosage_form] = 'Oral Lozenge' AND rxcui = '316992'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLY' WHERE [dosage_form] = 'Oral Ointment' AND rxcui = '346288'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'VIAL', default_administer_method = 'NEBULIZER' WHERE [dosage_form] = 'Inhalant Soln' AND rxcui = '346161'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'PACKE' WHERE [dosage_form] = 'Pwdr Nasal Soln' AND rxcui = '1540452'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLICATOR', default_administer_unit = 'APPLICATOR'  WHERE [dosage_form] = 'Rectal Cream' AND rxcui = '316975'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'APPLICATOR', default_administer_unit = 'APPLICATOR'  WHERE [dosage_form] = 'Rectal Gel' AND rxcui = '346170'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'MG' WHERE [dosage_form] = 'InhalationSusp' AND rxcui = '2107948'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'TAB', default_administer_unit = 'TAB' WHERE [dosage_form] = 'Effervescent' AND rxcui = '1535727'
UPDATE [c_Dosage_Form] SET default_dose_unit = 'TAB', default_administer_unit = 'TAB' WHERE [dosage_form] = 'Sublingual Tab' AND rxcui = '317007'

DELETE FROM c_Dosage_Form
WHERE dosage_form IN ('VaginalSystem','ChewEROralTab','OralFilm','SublingualFilm',
	'InhalationSpray','DROralGran','ChewableBar','OralPellet','InhalationSusp','VaginalInsert','VaginalSponge')

INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('VaginalSystem','Vaginal System','Vag Sys', 'INTRAVAGINAL', 1, 'APPLICATOR', 'N', 'APPLICATOR', '2199220')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('ChewEROralTab','Chewable Extended Release Oral Tablet','Chewable ER Tab', 'PO', 1, 'TAB', 'N', 'MG', '2269573')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('OralFilm','Oral Film','Oral Film', 'PO', 1, 'STRIP', 'N', 'STRIP', '2269575')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('SublingualFilm','Sublingual Film','Subling Film', 'PO', 1, 'STRIP', 'N', 'STRIP', '2269578')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('InhalationSpray','Inhalation Spray','Inhltion Spray', 'SPRAY', 1, 'SPRAY', 'N', 'SPRAY', '2284289')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('DROralGran','Delayed Release Oral Granules','DR Granules', 'PO', 1, 'MG', 'N', 'TSP', '2284290')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('ChewableBar','Chewable Bar','Chew Bar', 'PO', 1, 'BAR', 'N', 'BAR', '316941')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('OralPellet','Oral Pellet','Oral Pellet', 'PO', 1, 'PELLET', 'N', 'PELLET', '317691')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('InhalationSusp','Inhalation Suspension','Inhalation Susp', 'INHALE', 1, 'ML', 'N', 'PUFF', '2107948')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('VaginalInsert','Vaginal Insert','Vaginal Insert', 'INTRAVAGINAL', 1, 'APPLICATOR', 'N', 'APPLICATOR', '2107950')
INSERT INTO c_Dosage_Form (
[dosage_form]
      ,[description]
      ,[abbreviation]
      ,[default_administer_method]
      ,[default_dose_amount]
      ,[default_dose_unit]
      ,[dose_in_name_flag]
      ,[default_administer_unit]
      ,[rxcui]
	  )
VALUES ('VaginalSponge','Vaginal Sponge','Vaginal Sponge', 'INTRAVAGINAL', 1, 'APPLICATOR', 'N', 'APPLICATOR', '2173190')

UPDATE c_Dosage_Form
SET [default_administer_method] = 'Subcut'
WHERE default_administer_method = 'SQ'
