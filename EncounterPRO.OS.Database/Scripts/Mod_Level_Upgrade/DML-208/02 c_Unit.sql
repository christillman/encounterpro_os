

-- Replace U with UNIT and CC with ML

UPDATE c_Dosage_Form SET default_administer_unit = 'UNIT' WHERE default_administer_unit = 'U'
UPDATE c_Drug_Administration SET administer_unit = 'UNIT' WHERE administer_unit = 'U'
UPDATE c_Drug_Definition SET max_dose_unit = 'ML' WHERE max_dose_unit = 'CC'
UPDATE c_Drug_Definition_Archive SET max_dose_unit = 'ML' WHERE max_dose_unit = 'CC'
UPDATE c_Drug_HCPCS SET administer_unit = 'UNIT' WHERE administer_unit = 'U'
UPDATE c_Drug_HCPCS SET administer_unit = 'ML' WHERE administer_unit = 'CC'
UPDATE c_Drug_Package_Archive SET default_dispense_unit = 'ML' WHERE default_dispense_unit = 'CC'
UPDATE c_Drug_Package_Dispense SET dispense_unit = 'ML' WHERE dispense_unit = 'CC'
UPDATE c_Observation_Result SET result_unit = 'ML' WHERE result_unit = 'CC'
UPDATE c_Package SET administer_unit = 'UNIT' WHERE administer_unit = 'UNT'
UPDATE c_Package SET administer_unit = 'UNIT/ML' WHERE administer_unit = 'UNT/ML'
UPDATE c_Package SET administer_unit = 'UNIT/MG' WHERE administer_unit = 'UNT/MG'
UPDATE c_Package SET administer_unit = 'UNIT/ACTUAT' WHERE administer_unit = 'UNT/ACTUAT'
UPDATE c_Package_Archive SET administer_unit = 'UNIT' WHERE administer_unit = 'U'
UPDATE c_Package_Archive SET administer_unit = 'ML' WHERE administer_unit = 'CC'
UPDATE c_Package_Archive SET dose_unit = 'UNIT' WHERE dose_unit = 'U'
UPDATE c_Package_Archive SET dose_unit = 'ML' WHERE dose_unit = 'CC'

UPDATE c_Unit SET description = 'Intl Unit' WHERE unit_id = 'IU'
UPDATE c_Unit SET description = 'Unit/hr' WHERE unit_id = 'U/HR'
UPDATE c_Unit SET description = 'Unit/l' WHERE unit_id = 'U/l'
-- Usage of pretty_fraction in the application was replaced by display_mask
UPDATE c_Unit SET pretty_fraction = 'display_mask' WHERE 1 = 1
-- No remaining usage of these non-preferred units
DELETE FROM c_Unit WHERE unit_id IN ('U','CC','Ug/dl','Ug/ml')
DELETE FROM c_Unit_Conversion WHERE unit_to IN ('CC')
