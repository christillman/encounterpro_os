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
'Pen Injector')

-- these will now be duplicates
DELETE FROM [c_Dosage_Form]
WHERE [dosage_form] IN ('Oral Capsule', 'Oral Tablet', 'Vaginal Tablet')


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
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Pad', 'Medicated Pad', 'APPLY', 'PAD','797271')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Pads' AND rxcui = '797271'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Patch', 'Medicated Patch', 'ON SKIN', 'PATCH','1792831')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Patch' AND rxcui = '1792831'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Shampoo', 'Medicated Shampoo', 'APPLY', 'BOTTLE','106332')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Shampoo' AND rxcui = '106332'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Med Tape', 'Medicated Tape', 'ON SKIN','TAPE', '797685')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Tape' AND rxcui = '797685'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Nasal Inhalant', 'Nasal Inhalant', 'INHALE', 'INHALATION','316959')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Inhaler' AND rxcui = '316959'
UPDATE [c_Dosage_Form] SET description = 'Oral Capsule' WHERE [dosage_form] = 'Cap' AND rxcui = '316965'
UPDATE [c_Dosage_Form] SET description = 'Oral Tablet' WHERE [dosage_form] = 'Tab' AND rxcui = '317541'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Pack', 'Pack', 'ASDIR', 'PACK','746839')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Packet' AND rxcui = '746839'
INSERT INTO [c_Dosage_Form] ([dosage_form],[description],[default_administer_method],default_dose_unit,rxcui) VALUES ('Pen Injector', 'Pen Injector', 'SQ', 'PEN','1649571')
UPDATE [c_Dosage_Form] SET rxcui = NULL WHERE [dosage_form] = 'Pens' AND rxcui = '1649571'
UPDATE [c_Dosage_Form] SET description = 'Urethral Suppository' WHERE [dosage_form] = 'Urethral Suppos' AND rxcui = '317543'
UPDATE [c_Dosage_Form] SET description = 'Vaginal Suppository' WHERE [dosage_form] = 'Vaginal Suppos' AND rxcui = '337840'
UPDATE [c_Dosage_Form] SET description = 'Vaginal Tablet' WHERE [dosage_form] = 'Vag Tabs' AND rxcui = '11110'

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'INHALE', [default_dose_unit] = 'INHALATION'
WHERE description LIKE '%Inhal%' AND rxcui IS NOT NULL 
AND [default_administer_method] IS NULL

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'PO' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND (description LIKE '%Oral%' 
OR description LIKE '%Buccal%' 
OR description LIKE '%Subling%')

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'APPLY', [default_dose_unit] = 'APPLY' 
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

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'SPRAY', [default_dose_unit] = 'SPRAY' 
WHERE rxcui IS NOT NULL AND [default_administer_method] IS NULL
AND description LIKE '%Spray%'

UPDATE [c_Dosage_Form] SET [default_administer_method] = 'SQ', [default_dose_unit] = 'ML' 
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

