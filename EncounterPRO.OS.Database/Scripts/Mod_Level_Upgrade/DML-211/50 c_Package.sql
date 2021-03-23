-- Correct dose_units not found in c_Unit
UPDATE p
SET dose_unit = 
-- select dose_unit, 
	CASE dose_unit WHEN 'ACTUATNASAL' THEN 'ACTUATNOSTRIL'
		WHEN 'UNITS' THEN 'UNIT'
		WHEN 'GM' THEN 'GRAM'
		WHEN 'GRAMS' THEN 'GRAM'
		END
FROM c_Package p
WHERE dose_unit IN ('ACTUATNASAL','UNITS','GM','GRAMS')
-- (286 row(s) affected)

-- Set dose_unit where currently NULL
