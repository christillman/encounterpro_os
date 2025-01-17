
UPDATE [c_Immunization_Dose_Schedule] 
SET valid_in = REPLACE(valid_in, 'ke;', 'ke;ug;')
WHERE valid_in like '%ke;%'
AND valid_in NOT like '%ug;%'

UPDATE c_Drug_Brand 
SET valid_in = REPLACE(valid_in, 'ke;', 'ke;ug;')
WHERE valid_in like '%ke;%'
AND valid_in NOT like '%ug;%'

UPDATE c_Drug_Generic 
SET valid_in = REPLACE(valid_in, 'ke;', 'ke;ug;')
WHERE valid_in like '%ke;%'
AND valid_in NOT like '%ug;%'

UPDATE c_Drug_Formulation 
SET valid_in = REPLACE(valid_in, 'ke;', 'ke;ug;')
WHERE valid_in like '%ke;%'
AND valid_in NOT like '%ug;%'

UPDATE c_Drug_Pack
SET valid_in = REPLACE(valid_in, 'ke;', 'ke;ug;')
WHERE valid_in like '%ke;%'
AND valid_in NOT like '%ug;%'
