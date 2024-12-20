-- Remove injection dosage forms which include administer_method
DELETE FROM c_dosage_form
WHERE dosage_form IN (
'Inj (IA)',
'Inj (ID)',
'Inj (IL)',
'Inj (IT)',
'Inj IM',
'Inj IS',
'Inj IV',
'Inj SQ',
'INJNB')
-- (9 row(s) affected)

UPDATE c_dosage_form 
SET default_administer_method = NULL
WHERE dosage_form like '%inj%'
OR dosage_form IN (
'Pens',
'Prefilled Syrg'
)
-- (10 row(s) affected)
