

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


UPDATE c_Unit SET description = 'Units', unit_id = 'UNIT' WHERE unit_id = 'U'
UPDATE c_Unit SET description = 'Intl Unit' WHERE unit_id = 'IU'
UPDATE c_Unit SET description = 'Units/hr' WHERE unit_id = 'U/HR'
UPDATE c_Unit SET description = 'Units/l' WHERE unit_id = 'U/l'
-- Usage of pretty_fraction in the application was replaced by display_mask
UPDATE c_Unit SET pretty_fraction = 'display_mask' WHERE 1 = 1
-- No remaining usage of these non-preferred units
DELETE FROM c_Unit WHERE unit_id IN ('U','CC','Ug/dl','Ug/ml')
DELETE FROM c_Unit_Conversion WHERE unit_to IN ('CC')

-- Per Revising Dosage Forms ... New Units sheet
DELETE FROM c_Unit WHERE unit_id IN ('INSERTEYE','INSERTEYEL','INSERTEYER')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('INSERTEYE','Insert in each eye', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('INSERTEYEL','Insert in right eye', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('INSERTEYER','Insert in left eye', 'NUMBER', 'N', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id IN ('DROPEAR','DROPEARL','DROPEARR')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPEAR','Drop(s) in each ear', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPEARL','Drop(s) in left ear', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPEARR','Drop(s) in right ear', 'NUMBER', 'N', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id IN ('CARTRIDGEMG','CARTRIDGEML')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('CARTRIDGEMG','MG', 'NUMBER', 'N', 'Y', '0.######')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('CARTRIDGEML','ML', 'NUMBER', 'N', 'Y', '0.##')
DELETE FROM c_Unit WHERE unit_id = 'FILM'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('FILM','Film', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'METEREDDOSE'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('METEREDDOSE','Metered Dose', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'TUBEORPACKE'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('TUBEORPACKE','Tube or Packet', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'CELLS'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('CELLS','Cells', 'NUMBER', 'N', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'MEDICATEDPAD'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask)
	VALUES ('MEDICATEDPAD','Medicated Pad', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'ACTIVATION'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('ACTIVATION','Activation', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'ACTUAT'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('ACTUAT','Actuation', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'APPLYAREA'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('APPLYAREA','Apply to the affected area', 'NUMBER', 'N', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'NOSEPIECE'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('NOSEPIECE','Nose Piece', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'PUFF'
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('PUFF','Puff', 'NUMBER', 'Y', 'Y', '#')
DELETE FROM c_Unit WHERE unit_id = 'PELLET'
INSERT INTO c_Unit ( [unit_id], [description], [unit_type], plural_flag, print_unit, display_mask) 
VALUES ('PELLET','Pellet', 'NUMBER','Y', 'Y', '#')