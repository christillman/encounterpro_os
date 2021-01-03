
	-- Per Ciru email 14 Nov 2020
DELETE FROM c_Unit WHERE unit_id IN ('DROPNOSTRIL','DROPNOSTRILL','DROPNOSTRILR')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPNOSTRIL','Drop(s) in each Nostril', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPNOSTRILL','Drop(s) in left Nostril', 'NUMBER', 'N', 'Y', '#')
INSERT INTO c_Unit (unit_id, description, unit_type, plural_flag, print_unit, display_mask) 
	VALUES ('DROPNOSTRILR','Drop(s) in right Nostril', 'NUMBER', 'N', 'Y', '#')

UPDATE p
SET dose_unit = 'UNIT'
FROM c_Drug_Generic g
JOIN c_Drug_Brand b ON g.generic_rxcui = b.generic_rxcui
JOIN c_Drug_Formulation f ON f.ingr_rxcui = g.generic_rxcui
JOIN c_Drug_Package dp ON dp.drug_id = b.drug_id
JOIN c_Package p ON p.package_id = dp.package_id
WHERE g.generic_name LIKE '%Insulin%'
AND f.form_descr LIKE '%UNT%'
AND dose_unit != 'UNIT'

UPDATE p
SET dose_unit = upper(p.dose_unit) + 'NOSTRIL' 
-- select dose_unit , upper(dose_unit) + 'NOSTRIL', form_tty
FROM c_Package p
join c_Drug_Package B on p.package_id=b.package_id
join c_Drug_Formulation A on a.form_rxcui=b.form_rxcui
where form_descr like '%nasal solution%'
and p.dose_unit IN ('drop', 'spray')

UPDATE m
SET administer_method = NULL -- This triggers right/left/both options
-- select m.administer_method, dose_unit , upper(dose_unit) + 'NOSTRIL', form_tty
FROM c_Package p
join c_Drug_Package B on p.package_id=b.package_id
join c_Package_Administration_Method m on b.package_id=m.package_id
join c_Drug_Formulation A on a.form_rxcui=b.form_rxcui
where form_descr like '%nasal solution%'
and m.administer_method IS NOT NULL

UPDATE c_Package 
SET dosage_form = 'Topical Lotion'
WHERE dosage_form = 'Otic Lotion'

UPDATE c_Package 
SET dosage_form = 'Buccal Film', dose_unit = 'STRIP'
WHERE dosage_form = 'FILM'

UPDATE c_Package 
SET administer_method = 'BUCCAL'
WHERE dosage_form like 'Buccal%'

exec [sp_add_missing_drug_defn_pkg_adm_method]
