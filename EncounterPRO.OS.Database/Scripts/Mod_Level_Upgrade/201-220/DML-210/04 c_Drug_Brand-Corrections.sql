
-- Left at some point in process, not searchable, drug_id has no prefix
-- common_name slightly different but is duplicated with normal drug_id match
DELETE d -- select b.brand_name, b.drug_id, d.drug_id, d.common_name, d.generic_name, d2.drug_id, d2.common_name, d2.generic_name
FROM c_Drug_Brand b 
join c_Drug_Definition d on d.drug_id = b.brand_name_rxcui 
	and d.drug_id not like 'KEB%'
join c_Drug_Definition d2 on d2.drug_id = b.drug_id
-- (17 row(s) affected)

-- Remove brands which are actually generics
delete b -- select *
from c_Drug_Brand b 
join c_Drug_Generic g ON g.generic_name = b.brand_name
-- (14 row(s) affected)

UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI13360' 
WHERE generic_rxcui IN ('KEGI16179','KEGI14953','KEGI3557','KEGI3632') -- aceclofenac / paracetamol / chlorzoxazone

UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2166' WHERE generic_rxcui = 'KEGI5740' -- amLODIPine besilate / atenolol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10843' WHERE generic_rxcui = 'KEGI5376' -- artesunate / amodiaquine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10843' WHERE generic_rxcui = 'KEGI11742' -- artesunate / amodiaquine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI12488' WHERE generic_rxcui = 'KEGI3192' -- aspirin / paracetamol / caffeine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI16702' WHERE generic_rxcui = 'KEGI16707' -- azilsartan medoxomil / hydroCHLOROthiazide
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3456' WHERE generic_rxcui = 'KEGI6458' -- bromhexine / guaiFENesin / salbutamol
UPDATE c_Drug_Brand SET generic_rxcui = '1007835' WHERE generic_rxcui = 'KEGI147' -- calcium citrate 
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI8974' WHERE generic_rxcui = 'KEGI1312' -- carbonyl iron / folic acid / vitamin B12 / vitamin C / zinc sulfate
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10796' WHERE generic_rxcui = 'KEGI11149' -- cefixime / clavulanic acid
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11122' WHERE generic_rxcui = 'KEGI3832' -- chlorpheniramine / paracetamol / pseudoephedrine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10561' WHERE generic_rxcui = 'KEGI14720' -- clindamycin phosphate / clotrimazole
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3347' WHERE generic_rxcui = 'KEGI8917' -- clopidogrel / aspirin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI521' WHERE generic_rxcui = 'KEGI6302' -- clotrimazole / beclomethasone dipropionate
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11952' WHERE generic_rxcui = 'KEGI3434' -- clotrimazole / beclomethasone dipropionate / gentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI15625' WHERE generic_rxcui = 'KEGI5668' -- clotrimazole / betamethasone / gentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI15625' WHERE generic_rxcui = 'KEGI9246' -- clotrimazole / betamethasone / gentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI8159' WHERE generic_rxcui = 'KEGI8218' -- codeine phosphate / doxylamine succinate / paracetamol / caffeine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2499A' WHERE generic_rxcui = 'KEGI3600' -- dexamethasone sodium phosphategentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2499A' WHERE generic_rxcui = 'KEGI6823A' -- dexamethasone sodium phosphategentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2499A' WHERE generic_rxcui = 'KEGI6823B' -- dexamethasone sodium phosphategentamicin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2129' WHERE generic_rxcui = 'KEGI7204' -- diclofenac sodium / paracetamol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2129' WHERE generic_rxcui = 'KEGI452' -- diclofenac sodium / paracetamol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI5385' WHERE generic_rxcui = 'KEGI1949' -- diclofenac sodium / paracetamol / chlorzoxazone
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI158' WHERE generic_rxcui = 'KEGI772' -- dicyclomine HCL / simethicone
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI8209' WHERE generic_rxcui = 'KEGI9384' -- fusidic acid / betamethasone valerate
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3022' WHERE generic_rxcui = 'KEGI5199' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3022' WHERE generic_rxcui = 'KEGI6996' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3022' WHERE generic_rxcui = 'KEGI5176' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI5438' WHERE generic_rxcui = 'KEGI8730' -- lamiVUDine / zidovudine / nevirapine
update c_Drug_Brand set generic_rxcui = '6387' where generic_rxcui = 'KEGI15803' -- lidocaine
update c_Drug_Brand set generic_rxcui = 'KEGI5808' where generic_rxcui = 'KEGI7219' -- mefenamate / tranexamic acid
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1391' WHERE generic_rxcui = 'KEGI274' -- mefenamic acid / paracetamol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI13379' WHERE generic_rxcui = 'KEGI3051' -- metformin HCL / vildagliptin
update c_Drug_Brand set generic_rxcui = 'KEGI13379' where generic_rxcui = 'KEGI13613' -- metFORMIN / VILDAgliptin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI13269' 
WHERE generic_rxcui IN ('KEGI14222','KEGI7594','KEGI5191','KEGI7213') -- pantoprazole / domperidone
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11049' 
WHERE brand_name_rxcui IN ('KEBI11049','KEBI3201','KEBI146') -- paracetamol / chlorpheniramine maleate / phenylephrine HCL
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11050' 
WHERE brand_name_rxcui IN ('KEBI11050','KEBI3748','KEBI11962','KEBI3287') -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11122' 
WHERE brand_name_rxcui IN ('KEBI3832','KEBI3861','KEBI588') -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCL
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3785' WHERE generic_rxcui = 'KEGI3815' -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCl / caffeine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI3785' WHERE generic_rxcui = 'KEGI510' -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCl / caffeine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11610' WHERE generic_rxcui = 'KEGI7304' -- paracetamol / codeine phosphate
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2949' WHERE generic_rxcui = 'KEGI6430' -- pregabalin / methylcobalamin
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI11569' WHERE generic_rxcui = 'KEGI6255' -- procaine penicillin / benzylpenicillin sodium
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10420' WHERE generic_rxcui = 'KEGI14242' -- RABEprazole sodium / domperidone
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10420' WHERE generic_rxcui = 'KEGI13580' -- RABEprazole sodium / domperidone
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI5724' WHERE generic_rxcui = 'KEGI5823' -- rifampicin / isoniazid
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI6447' WHERE generic_rxcui = 'KEGI7040' -- rifampicin / isoniazid / pyrazinamide
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI6447' WHERE generic_rxcui = 'KEGI6928' -- rifampicin / isoniazid / pyrazinamide
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1081' WHERE generic_rxcui = 'KEGI1786' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1081' WHERE generic_rxcui = 'KEGI6926' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1081' WHERE generic_rxcui = 'KEGI11416' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1081' WHERE generic_rxcui = 'KEGI5924' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1093' WHERE generic_rxcui = 'KEGI2253' -- sulfadoxine / pyrimethamine
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1093' WHERE generic_rxcui = 'KEGI3390' -- sulfadoxine / pyrimethamine

UPDATE d 
SET generic_name = CASE WHEN LEN(g.generic_name) <= 500 THEN g.generic_name 
					ELSE left(g.generic_name,497) + '...' END
	-- select g.generic_name, d.generic_name
FROM c_Drug_Brand b
JOIN c_Drug_Generic g ON g.generic_rxcui = b.generic_rxcui
JOIN c_Drug_Definition d ON d.drug_id = b.drug_id
WHERE g.generic_name != d.generic_name
-- 4 rows

-- 20ML and 30ML lidocaine HCl duplicate lidocaine HCl
UPDATE c_Drug_Brand SET generic_rxcui = '6387' WHERE generic_rxcui IN ('KEGI15803','KEGI9849A','KEGI1537')
DELETE -- select *
FROM c_Drug_Generic WHERE generic_rxcui IN ('KEGI9849A','KEGI1537','KEGI15803')
UPDATE c_Drug_Formulation SET ingr_rxcui = '6387' WHERE ingr_rxcui IN ('KEGI15803','KEGI9849A','KEGI1537')
-- (2 row(s) affected)

-- Update brand names with brackets half-copied from kenya_drugs
UPDATE b 
SET brand_name = substring(brand_name,1,charindex(' (',brand_name) - 1)
-- SELECT brand_name, substring(brand_name,1,charindex(' (',brand_name) - 1)
FROM c_Drug_Brand b
WHERE brand_name_rxcui like 'KE%'
AND brand_name like  '% (%'
-- (22 row(s) affected)