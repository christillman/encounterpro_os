
-- dose_unit NULL to allow clinician to accept proper eye/ear/nostril at runtime
UPDATE c_Package_Administration_Method
SET administer_method = 
-- select dose_unit, pm.administer_method,
CASE
	WHEN dose_unit = 'ACTUATNASAL' THEN NULL
	WHEN dose_unit = 'ACTUATNOSTRIL' THEN NULL
	WHEN dose_unit = 'APPLYEAR' THEN NULL
	WHEN dose_unit = 'APPLYEYE' THEN NULL
	WHEN dose_unit = 'CARTRIDGEM' THEN NULL
	WHEN dose_unit = 'DROPEAR' THEN NULL
	WHEN dose_unit = 'DROPEYE' THEN NULL
	WHEN dose_unit = 'DROPNOSTRIL' THEN NULL
	WHEN dose_unit = 'INSERTEYE' THEN 'IN OFFICE'
	WHEN dose_unit = 'SPRAYNOSTRIL' THEN NULL END
from c_Package p 
join c_Package_Administration_Method pm on p.package_id = pm.package_id
where dose_unit IN ('ACTUATNASAL',
'APPLYEAR',
'APPLYEYE',
'CARTRIDGEM',
'DROPEAR',
'DROPEYE',
'DROPNOSTRIL',
'INSERTEYE',
'SPRAYNOSTRIL')
AND IsNull(pm.administer_method,'x') != CASE
	WHEN dose_unit = 'ACTUATNASAL' THEN 'x'
	WHEN dose_unit = 'ACTUATNOSTRIL' THEN 'x'
	WHEN dose_unit = 'APPLYEAR' THEN 'x'
	WHEN dose_unit = 'APPLYEYE' THEN 'x'
	WHEN dose_unit = 'CARTRIDGEM' THEN 'x'
	WHEN dose_unit = 'DROPEAR' THEN 'x'
	WHEN dose_unit = 'DROPEYE' THEN 'x'
	WHEN dose_unit = 'DROPNOSTRIL' THEN 'x'
	WHEN dose_unit = 'INSERTEYE' THEN 'IN OFFICE'
	WHEN dose_unit = 'SPRAYNOSTRIL' THEN 'x' END