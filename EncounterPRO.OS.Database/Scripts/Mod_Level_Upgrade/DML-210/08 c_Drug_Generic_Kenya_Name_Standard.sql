
-- Correct brands with no linked generics
/*
select 'UPDATE c_Drug_Brand SET generic_rxcui = ''' + b.generic_rxcui + ''' WHERE generic_rxcui = ''fillin'' -- ' 
	+ case when k.ingredient is not null then k.Ingredient
	when k.scd_psn_version like '30 ML %' THEN dbo.fn_ingredients(substring(k.scd_psn_version,7,100))
	else dbo.fn_ingredients(k.scd_psn_version) end as ingr
FROM c_Drug_Brand b
JOIN Kenya_Drugs k ON k.Retention_No = substring(b.brand_name_rxcui,5,20)
WHERE NOT EXISTS (SELECT 1 
	FROM c_Drug_Generic g
	WHERE g.generic_rxcui = b.generic_rxcui)
AND b.brand_name_rxcui LIKE 'KEBI%'
order by case when k.ingredient is not null then k.Ingredient
	when k.scd_psn_version like '30 ML %' THEN dbo.fn_ingredients(substring(k.scd_psn_version,7,100))
	else dbo.fn_ingredients(k.scd_psn_version) end
*/

-- Insert missing generics after mod level 209
/*
SELECT 'KEGI'+MIN(k.source_id) AS generic_rxcui, 
	g.active_ingredients AS generic_name
--INTO #new_generics2
FROM c_Drug_Brand b
JOIN c_Drug_Brand_Related k ON k.source_id = substring(b.brand_name_rxcui,5,20)
JOIN c_Drug_Generic_Related g ON g.source_id = k.source_id
WHERE b.brand_name_rxcui like 'KEB%'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g1
	WHERE g1.generic_rxcui = b.generic_rxcui)
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g2
	WHERE g2.generic_rxcui = g.generic_rxcui)
GROUP BY g.active_ingredients
ORDER BY 1


-- function can't extract ingredients when the name starts with a digit
DELETE FROM #new_generics WHERE generic_name like '2%' or generic_name like '3%'
-- function doesn't handle "(equivalent to" very well
DELETE FROM #new_generics WHERE generic_name like '%(equi%'

INSERT INTO c_Drug_Generic (generic_rxcui, generic_name, [is_single_ingredient], drug_id)
SELECT generic_rxcui, 
	generic_name, 
	CASE WHEN charindex(' / ',generic_name) > 0 THEN 0 ELSE 1 END, 
	generic_rxcui
FROM #new_generics
-- 0
*/


-- These are being removed because they now reference either RXNORM
-- or another KEGI ingredient after name standardization
-- (only one unique spelling is retained in c_Drug_Generic)
-- Note, the references are retained in c_Drug_Generic_Related
-- c_Drug_Brand and c_Drug Formulation references will be 
-- updated in 40 c_Drug_Brand.sql and 50 c_Drug_Formulation.sql
DELETE g
FROM c_Drug_Generic g
WHERE g.generic_rxcui IN (
'KEGI3979', -- 12HR NIFEdipine
'KEGI10941', -- abacavir sulfate
'KEGI11889', -- aceclofenac / thiocolchicoside
'KEGI6491', -- adapalene / clindamycin phosphate
'KEGI10530', -- alfuzosin hydrochloride
'KEGI5881', -- amikacin sulfate
'KEGI12789', -- aminophylline hydrate
'KEGI10752', -- amoxicillin / clavulanate potassium
'KEGI13094', -- amoxicillin / clavulanic acid
'KEGI3518', -- amoxicillin / flucloxacillin magnesium
'KEGI261', -- bacitracin zinc / neomycin
'KEGI1839', -- beclometasone dipropionate
'KEGI2342', -- beclomethasone dipropionate
'KEGI9105', -- betahistine dihydrochloride
'KEGI6696', -- betamethasone dipropionate / gentamicin
'KEGI2042', -- budesonide / formoterol fumarate
'KEGI742', -- cetirizine dihydrochloride
'KEGI3772', -- chloramphenicol palmitate
'KEGI2154', -- chlorproMAZINE HCL
'KEGI8853', -- ciclesonide / INHAL Metered Dose Inhaler,
'KEGI867', -- clidinium bromide / chlordiazePOXIDE HCl
'KEGI11176', -- clindamycin / clotrimazole
'KEGI6931', -- clindamycin phosphate / tretinoin
'KEGI1027', -- clotrimazole / betamethasone valerate
'KEGI7346', -- codeine phosphate / chlorpheniramine maleate
'KEGI7469', -- dexamethasone decanoate
'KEGI1272', -- dexamethasone sodium phosphate
'KEGI7957', -- dexketoprofen
'KEGI11542', -- diclofenac diethylamine
'KEGI5791', -- diclofenac potassium / paracetamol / chlorzoxazone
'KEGI2132A', -- diclofenac sodium
'KEGI11847', -- diclofenac sodium / miSOPROStol
'KEGI2473', -- diclofenac sodium / paracetamol / chlorzoxane
'KEGI5630', -- diclofenac sodium / paracetamol / serratiopeptidase
'KEGI3091', -- dihydrocodeine tartrate
'KEGI2135', -- dilTIAZem hydrochloride
'KEGI938', -- diphenhydrAMINE HCL
'KEGI12698', -- donepezil HCL / memantine HCL
'KEGI1917', -- doxycycline HCL
'KEGI15203', -- dutasteride / tamsulosin HCL
'KEGI5759', -- enalapril maleate / hydroCHLOROthiazide
'KEGI5870', -- enoxaparin sodium
'KEGI3803', -- erythromcyn ethylsuccinate
'KEGI14059', -- erythromycin estolate
'KEGI7731', -- erythromycin stearate
'KEGI5571', -- esomeprazole magnesium
'KEGI1182', -- estradiol valerate
'KEGI8269', -- etophylline / theophylline hydrate
'KEGI2970', -- ferric ammonium citrate / folic acid / vitamin B
'KEGI1306', -- fexofenadine HCl
'KEGI2286', -- fluticasone propionate / salmeterol
'KEGI7846', -- hydrocortisone acetate / lidocaine
'KEGI7075', -- ibandronic acid
'KEGI221', -- ipratropium bromide
'KEGI4757', -- iron (III) hydroxide polymaltofolic acid
'KEGI13936', -- leuprolide acetate
'KEGI8645', -- levosalbutamol sulphate
'KEGI7644', -- losartan potassium / amLODIPine
'KEGI12612', -- mefenamic acid
'KEGI4764', -- methylPREDNISolone aceponate
'KEGI10134', -- methylPREDNISolone acetate
'KEGI8659', -- metroNIDAZOLE / diloxanide furoate
'KEGI5188', -- metroNIDAZOLE benzoate
'KEGI4076', -- miconazole nitrate
'KEGI7858', -- miconazole nitrate / hydrocortisone acetate
'KEGI4232', -- neomycin sulphate / polymyxin B sulphate / dexamethasone
'KEGI7118', -- norelgestromin / ethinyl estradiol
'KEGI831', -- orphenadrine citrate
'KEGI15393', -- oxymetazoline HCl
'KEGI13631', -- pantoprazole / domperidone SR
'KEGI5358', -- pantoprazole sodium
'KEGI5232', -- pantoprazole sodium / domperidone
'KEGI2728', -- paracetamol / aspirin / caffeine
'KEGI6917', -- paracetamol / caffeine anhydrous
'KEGI146', -- paracetamol / chlorphenamine maleate / phenylephrine HCL
'KEGI11962', -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine anhydrous
'KEGI401', -- paracetamol / ibuprofen
'KEGI7402', -- perindopril arginine
'KEGI11744', -- perindopril arginine / amLODIPine besilate
'KEGI7385', -- perindopril arginine / indapamide
'KEGI4693', -- phenytoin sodium
'KEGI941', -- promethazine / carbocisteine
'KEGI3929', -- promethazine HCL
'KEGI3583', -- quiNINE bisulphate
'KEGI1463', -- quiNINE dihydrochloride
'KEGI743', -- quiNINE HCI
'KEGI276', -- quiNINE sulphate
'KEGI11031', -- RABEprazole sodium
'KEGI4558', -- salbutamol
'KEGI9499', -- salbutamol sulphate / beclomethasone dipropionate
'KEGI2315', -- salmeterol / fluticasone
'KEGI2318', -- salmeterol / fluticasone propionate
'KEGI11901', -- sildenafil citrate
'KEGI4754', -- silymarin / thiamine / pyridoxine HCl / riboflavin / nicotinamide / calcium pantothenate / cyanocobalamin
'KEGI4377', -- sodium bicarbonate / citric acid
'KEGI1241', -- soluble insulin, human
'KEGI4064', -- thiamine nitrate (vitamin B1) / pyridoxine (vitamin B6) / cyanocobalamin (vitamin B12)
'KEGI2422', -- thiamine nitrate (vitamin B1) / pyridoxine HCl (vitamin B6) / cyanocobalamin (vitamin B12)
'KEGI10794', -- traMADol HCL
'KEGI11135', -- valsartan / amLODIPine
'KEGI5197', -- xylometazoline HCl
'KEGI547' -- zuclopenthixol decanoate
)
-- (102 row(s) affected)


DELETE -- select *
FROM c_Drug_Generic 
WHERE generic_rxcui IN (
'KEGI6503',
'KEGI1616',
'KEGI10723',
'KEGI2484',
'KEGI5249',
'KEGI7260',
'KEGI8976',
'KEGI9944',
'KEGI15190',
'KEGI2421',
'KEGI2073',
'KEGI1796',
'KEGI5883',
'KEGI10765',
'KEGI15339',
'KEGI12133',
'KEGI7259'
)

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('folic acid / iron(III) hydroxide', 'KEGI6503', 0, 'KEGI6503')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('beclomethasone / miconazole / neomycin', 'KEGI1616', 0, 'KEGI1616')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('clotrimazole / metroNIDAZOLE', 'KEGI10723', 0, 'KEGI10723')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('efavirenz / lamiVUDine / zidovudine', 'KEGI2484', 0, 'KEGI2484')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('adrenaline / lidocaine', 'KEGI5249', 0, 'KEGI5249')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('ferrous glycine / folic acid / zinc', 'KEGI7260', 0, 'KEGI7260')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('cyanocobalamin / folic acid / iron / zinc', 'KEGI8976', 0, 'KEGI8976')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('diloxanide / simethicone / tinidazole', 'KEGI9944', 0, 'KEGI9944')


-- Cocoflu
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('dextromethorphan / doxylamine / paracetamol / phenylephrine', 'KEGI15190', 0, 'KEGI15190')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI15190' WHERE brand_name_rxcui = 'KEBI15190'

INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('ipratropium / salbutamol', 'KEGI2421', 0, 'KEGI2421')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2421' 
WHERE brand_name_rxcui = 'KEBI2421'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('dicycloverine', 'KEGI2073', 1, 'KEGI2073')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI2073' 
WHERE brand_name_rxcui = 'KEBI2073'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('adrenaline', 'KEGI1796', 1, 'KEGI1796')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI1796' 
WHERE generic_rxcui = '3992' AND brand_name_rxcui like 'KEB%'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('glibenclamide', 'KEGI5883', 1, 'KEGI5883')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI5883' 
WHERE generic_rxcui = '4815' AND brand_name_rxcui like 'KEB%'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('torasemide', 'KEGI10765', 1, 'KEGI10765')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI10765' 
WHERE generic_rxcui = '38413' AND brand_name_rxcui like 'KEB%'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('benzhexol', 'KEGI15339', 1, 'KEGI15339')
UPDATE c_Drug_Brand SET generic_rxcui = 'KEGI15339' 
WHERE generic_rxcui = '10811' AND brand_name_rxcui like 'KEB%'
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('ferrous ascorbate / folic acid', 'KEGI12133', 0, 'KEGI12133')
INSERT INTO c_Drug_Generic (generic_name, generic_rxcui, is_single_ingredient, drug_id)
VALUES ('ferrous glycine sulfate / folic acid', 'KEGI7259', 0, 'KEGI7259')

-- Update Kenya generic names to RXNORM format for comparability
-- from Revised_Alphabetized generic_names 11_12_2020.xlsx

update c_Drug_Generic set generic_name = 'aceclofenac / thiocolchicoside' where generic_rxcui = 'KEGI10052'
update c_Drug_Generic set generic_name = 'aceclofenac / chlorzoxazone / paracetamol' where generic_rxcui = 'KEGI13360'
update c_Drug_Generic set generic_name = 'activated dimethicone / clidinium / dicyclomine / paracetamol' where generic_rxcui = 'KEGI10014'
update c_Drug_Generic set generic_name = 'adrenaline / lidocaine' where generic_rxcui = 'KEGI5249'
update c_Drug_Generic set generic_name = 'allantoin / hydrocortisone / lidocaine / zinc oxide' where generic_rxcui = 'KEGI316'
update c_Drug_Generic set generic_name = 'aloe vera / ketoconazole / zinc pyrithione' where generic_rxcui = 'KEGI10313'
update c_Drug_Generic set generic_name = 'alpha tocopherol / ascorbic acid / chondroitin / glucosamine / manganese / methyl sulphonyl methane' where generic_rxcui = 'KEGI7190'
update c_Drug_Generic set generic_name = 'alpha-lipoic acid / benfotiamine / chromium / folic acid / inositol / methylcobalamin / pyridoxine hydrochloride' where generic_rxcui = 'KEGI12633'
update c_Drug_Generic set generic_name = 'alpha-lipoic acid / folic acid / gamma linolenate / methylcobalamin / pyridoxine' where generic_rxcui = 'KEGI4034'
update c_Drug_Generic set generic_name = 'alpha-lipoic acid / folic acid / methylcobalamin / pregabalin / vitamin B1 / vitamin B6' where generic_rxcui = 'KEGI17081'
update c_Drug_Generic set generic_name = 'alpha-lipoic acid / folic acid / methylcobalamin / pregabalin / vitamin B6' where generic_rxcui = 'KEGI10300'
update c_Drug_Generic set generic_name = 'alpha-lipoic acid / methylcobalamin / pregabalin' where generic_rxcui = 'KEGI11643'
update c_Drug_Generic set generic_name = 'ambroxol' where generic_rxcui = 'KEGI14266'
update c_Drug_Generic set generic_name = 'amLODIPine / atenolol' where generic_rxcui = 'KEGI2166'
update c_Drug_Generic set generic_name = 'amLODIPine / hydroCHLOROthiazide / losartan' where generic_rxcui = 'KEGI6087'
update c_Drug_Generic set generic_name = 'amLODIPine / indapamide' where generic_rxcui = 'KEGI12068'
update c_Drug_Generic set generic_name = 'amLODIPine / indapamide / perindopril' where generic_rxcui = 'KEGI11727'
update c_Drug_Generic set generic_name = 'amLODIPine / irbesartan' where generic_rxcui = 'KEGI7742'
update c_Drug_Generic set generic_name = 'amLODIPine / losartan' where generic_rxcui = 'KEGI227'
update c_Drug_Generic set generic_name = 'ammonium chloride / bromhexine / promethazine' where generic_rxcui = 'KEGI9803'
update c_Drug_Generic set generic_name = 'ammonium chloride / codeine / diphenhydrAMINE' where generic_rxcui = 'KEGI3101'
update c_Drug_Generic set generic_name = 'ammonium chloride / diphenhydrAMINE' where generic_rxcui = 'KEGI3172'
update c_Drug_Generic set generic_name = 'ammonium chloride / sodium citrate / terbutaline' where generic_rxcui = 'KEGI8169'
update c_Drug_Generic set generic_name = 'amodiaquine / artesunate' where generic_rxcui = 'KEGI10843'
update c_Drug_Generic set generic_name = 'amoxicillin / flucloxacillin' where generic_rxcui = 'KEGI3517'
update c_Drug_Generic set generic_name = 'anise oil / dill oil / ginger tincture / sodium bicarbonate / sodium citrate' where generic_rxcui = 'KEGI4409'
update c_Drug_Generic set generic_name = 'artesunate / pyronaridine' where generic_rxcui = 'KEGI13066'
update c_Drug_Generic set generic_name = 'ascorbic acid / calcium carbonate / calcium lactate gluconate' where generic_rxcui = 'KEGI5100'
update c_Drug_Generic set generic_name = 'ascorbic acid / calcium lactate / dexopanthenol / ferrous gluconate / niacinamide / pyridoxine / riboflavin / thiamine / vitamin B12' where generic_rxcui = 'KEGI5154'
update c_Drug_Generic set generic_name = 'ascorbic acid / cyanocobalamin / ferrous fumarate / folic acid / glycine / histidine / l-lysine / pyridoxine / riboflavin / thiamine' where generic_rxcui = 'KEGI17317'
update c_Drug_Generic set generic_name = 'ascorbic acid / cyanocobalamin / ferrous fumarate / folic acid / glycine / l-histidine / l-lysine / pyridoxine / riboflavin / thiamine' where generic_rxcui = 'KEGI1944'
update c_Drug_Generic set generic_name = 'ascorbic acid / cyanocobalamin / ferrous fumarate / folic acid / zinc' where generic_rxcui = 'KEGI2963'
update c_Drug_Generic set generic_name = 'ascorbic acid / ferrous fumarate / folic acid / pyridoxine' where generic_rxcui = 'KEGI6435'
update c_Drug_Generic set generic_name = 'ascorbic acid / lycopene / selenium dioxide / vitamin A / vitamin E / zinc' where generic_rxcui = 'KEGI3617'
update c_Drug_Generic set generic_name = 'aspirin / caffeine / paracetamol' where generic_rxcui = 'KEGI12488'
update c_Drug_Generic set generic_name = 'aspirin / clopidogrel' where generic_rxcui = 'KEGI3347'
update c_Drug_Generic set generic_name = 'Atenolol / NIFEdipine' where generic_rxcui = 'KEGI5858'
update c_Drug_Generic set generic_name = 'atorvastatin / telmisartan' where generic_rxcui = 'KEGI9889'
update c_Drug_Generic set generic_name = 'azilsartan / hydroCHLOROthiazide' where generic_rxcui = 'KEGI16702'
update c_Drug_Generic set generic_name = 'bacitracin / gramicidin-D / neomycin' where generic_rxcui = 'KEGI4969'
update c_Drug_Generic set generic_name = 'bacitracin / neomycin' where generic_rxcui = 'KEGI2259'
update c_Drug_Generic set generic_name = 'balsam peru / bismuth oxide / bismuth subgallate / zinc oxide' where generic_rxcui = 'KEGI1021'
update c_Drug_Generic set generic_name = 'beclomethasone / clotrimazole' where generic_rxcui = 'KEGI521'
update c_Drug_Generic set generic_name = 'beclomethasone / clotrimazole / gentamicin' where generic_rxcui = 'KEGI11952'
update c_Drug_Generic set generic_name = 'beclomethasone / clotrimazole / neomycin' where generic_rxcui = 'KEGI12572'
update c_Drug_Generic set generic_name = 'beclomethasone / miconazole' where generic_rxcui = 'KEGI1087'
update c_Drug_Generic set generic_name = 'beclomethasone / miconazole / neomycin' where generic_rxcui = 'KEGI1616'
update c_Drug_Generic set generic_name = 'benfothiamine / folic acid / methylcobalamin / pregabalin / pyridoxine' where generic_rxcui = 'KEGI11108'
update c_Drug_Generic set generic_name = 'benzathine penicillin / benzylpenicillin potassium / procaine penicillin' where generic_rxcui = 'KEGI11566'
update c_Drug_Generic set generic_name = 'benzylpenicillin sodium / procaine penicillin' where generic_rxcui = 'KEGI11569'
update c_Drug_Generic set generic_name = 'betamethasone / clotrimazole / gentamicin' where generic_rxcui = 'KEGI15625'
update c_Drug_Generic set generic_name = 'betamethasone / clotrimazole / neomcyin' where generic_rxcui = 'KEGI9772'
update c_Drug_Generic set generic_name = 'betamethasone / fusidic acid' where generic_rxcui = 'KEGI8209'
update c_Drug_Generic set generic_name = 'betamethasone / gentamicin' where generic_rxcui = 'KEGI1019'
update c_Drug_Generic set generic_name = 'betamethasone / lidocaine / phenylephrine' where generic_rxcui = 'KEGI7352'
update c_Drug_Generic set generic_name = 'betamethasone / miconazole / neomycin' where generic_rxcui = 'KEGI11996'
update c_Drug_Generic set generic_name = 'betamethasone / mupirocin' where generic_rxcui = 'KEGI5108'
update c_Drug_Generic set generic_name = 'betamethasone / neomycin' where generic_rxcui = 'KEGI4094A'
update c_Drug_Generic set generic_name = 'betamethasone / salicylic acid' where generic_rxcui = 'KEGI2153'
update c_Drug_Generic set generic_name = 'bimatoprost / timolol' where generic_rxcui = 'KEGI6247'
update c_Drug_Generic set generic_name = 'brinzolamide / timolol' where generic_rxcui = 'KEGI6822'
update c_Drug_Generic set generic_name = 'bromhexine / guaiFENesin / menthol / salbutamol' where generic_rxcui = 'KEGI1517'
update c_Drug_Generic set generic_name = 'bromhexine / guaiFENesin / menthol / terbutaline' where generic_rxcui = 'KEGI2611'
update c_Drug_Generic set generic_name = 'bromhexine / guaiFENesin / salbutamol' where generic_rxcui = 'KEGI3456'
update c_Drug_Generic set generic_name = 'bromhexine / salbutamol' where generic_rxcui = 'KEGI11321'
update c_Drug_Generic set generic_name = 'bromhexine / terbutaline' where generic_rxcui = 'KEGI11503'
update c_Drug_Generic set generic_name = 'caffeine / chlorpheniramine / paracetamol / phenylephrine' where generic_rxcui = 'KEGI11050'
update c_Drug_Generic set generic_name = 'caffeine / chlorpheniramine / paracetamol / pseudoephedrine' where generic_rxcui = 'KEGI3785'
update c_Drug_Generic set generic_name = 'caffeine / codeine / doxylamine / paracetamol' where generic_rxcui = 'KEGI8159'
update c_Drug_Generic set generic_name = 'caffeine / ibuprofen / paracetamol' where generic_rxcui = 'KEGI6024'
update c_Drug_Generic set generic_name = 'caffeine / paracetamol' where generic_rxcui = 'KEGI1493'
update c_Drug_Generic set generic_name = 'caffeine / paracetamol / phenylephrine' where generic_rxcui = 'KEGI9594'
update c_Drug_Generic set generic_name = 'caffeine / paracetamol / phenylephrine / terpine hydrate / vitamin C' where generic_rxcui = 'KEGI10677'
update c_Drug_Generic set generic_name = 'caffeine / paracetamol / pseudoephedrine' where generic_rxcui = 'KEGI2996'
update c_Drug_Generic set generic_name = 'calcium carbonate / magnesium hydroxide / vitamin D3 / zinc' where generic_rxcui = 'KEGI2607'
update c_Drug_Generic set generic_name = 'calcium citrate / magnesium / vitamin D3 / zinc' where generic_rxcui = 'KEGI1131'
update c_Drug_Generic set generic_name = 'calcium citrate / vitamin D3' where generic_rxcui = 'KEGI11846'
update c_Drug_Generic set generic_name = 'calcium dobesilate / hydrocortisone / lidocaine / zinc oxide' where generic_rxcui = 'KEGI7374'
update c_Drug_Generic set generic_name = 'calcium pantothenate / cyanocobalamin / nicotinamide / pyridoxine / riboflavin / silymarin / thiamine' where generic_rxcui = 'KEGI2849'
update c_Drug_Generic set generic_name = 'camylofin / paracetamol' where generic_rxcui = 'KEGI4166'
update c_Drug_Generic set generic_name = 'carbonyl iron / folic acid / selenium / vitamin B12 / vitamin E' where generic_rxcui = 'KEGI8325'
update c_Drug_Generic set generic_name = 'cefixime / clavulanate' where generic_rxcui = 'KEGI10796'
update c_Drug_Generic set generic_name = 'cefuroxime / clavulanate' where generic_rxcui = 'KEGI15924'
update c_Drug_Generic set generic_name = 'chitosan hydrochloride / silver sulfADIAZINE' where generic_rxcui = 'KEGI10422'
update c_Drug_Generic set generic_name = 'chlorhexidine / lidocaine / metroNIDAZOLE' where generic_rxcui = 'KEGI461'
update c_Drug_Generic set generic_name = 'chlorhexidine / metroNIDAZOLE' where generic_rxcui = 'KEGI8261'
update c_Drug_Generic set generic_name = 'chlorhexidine / silver sulfADIAZINE' where generic_rxcui = 'KEGI2953'
update c_Drug_Generic set generic_name = 'chlorpheniramine / dextromethorphan / menthol / pseudoephedrine / sodium citrate' where generic_rxcui = 'KEGI7350'
update c_Drug_Generic set generic_name = 'chlorpheniramine / paracetamol' where generic_rxcui = 'KEGI496'
update c_Drug_Generic set generic_name = 'chlorpheniramine / paracetamol / phenylephrine' where generic_rxcui = 'KEGI11049'
update c_Drug_Generic set generic_name = 'chlorpheniramine / paracetamol / pseudoephedrine' where generic_rxcui = 'KEGI11122'
update c_Drug_Generic set generic_name = 'chlorpheniramine / paracetamol / vitamin C' where generic_rxcui = 'KEGI11726'
update c_Drug_Generic set generic_name = 'chlorthalidone / cilnidipine / telmisartan' where generic_rxcui = 'KEGI17385'
update c_Drug_Generic set generic_name = 'chlorthalidone / cilnidipine / valsartan' where generic_rxcui = 'KEGI17303'
update c_Drug_Generic set generic_name = 'chlorzoxane / diclofenac / paracetamol', generic_rxcui = 'KEGI2473' where generic_rxcui = 'KEGI11831'
update c_Drug_Generic set generic_name = 'chlorzoxazone / diclofenac / paracetamol' where generic_rxcui = 'KEGI5385'
update c_Drug_Generic set generic_name = 'chlorzoxazone / ibuprofen' where generic_rxcui = 'KEGI11092'
update c_Drug_Generic set generic_name = 'chlorzoxazone / ibuprofen / paracetamol' where generic_rxcui = 'KEGI7202'
update c_Drug_Generic set generic_name = 'chondroitin / glucosamine' where generic_rxcui = 'KEGI7981'
update c_Drug_Generic set generic_name = 'chymotrypsin / trypsin' where generic_rxcui = 'KEGI5654'
update c_Drug_Generic set generic_name = 'cinchocaine / esculin / hydrocortisone / neomycin' where generic_rxcui = 'KEGI5390'
update c_Drug_Generic set generic_name = 'cinchocaine hydrochloride / prednisoLONE' where generic_rxcui = 'KEGI1136'
update c_Drug_Generic set generic_name = 'citric acid / sodium bicarbonate / sodium citrate / tartaric acid' where generic_rxcui = 'KEGI8170'
update c_Drug_Generic set generic_name = 'clindamycin / clotrimazole' where generic_rxcui = 'KEGI10561'
update c_Drug_Generic set generic_name = 'clobetasol propionate' where generic_rxcui = 'KEGI4263'
update c_Drug_Generic set generic_name = 'clobetasone' where generic_rxcui = 'KEGI2900'
update c_Drug_Generic set generic_name = 'clotrimazole / lactic acid bacillus / metroNIDAZOLE' where generic_rxcui = 'KEGI10101'
update c_Drug_Generic set generic_name = 'clotrimazole / metroNIDAZOLE' where generic_rxcui = 'KEGI10723'
update c_Drug_Generic set generic_name = 'clotrimazole / selenium' where generic_rxcui = 'KEGI5574'
update c_Drug_Generic set generic_name = 'codeine / ibuprofen / paracetamol' where generic_rxcui = 'KEGI8217'
update c_Drug_Generic set generic_name = 'codeine / paracetamol' where generic_rxcui = 'KEGI11610'
update c_Drug_Generic set generic_name = 'copper / ferrous fumarate / folic acid / peptone / vitamin B12' where generic_rxcui = 'KEGI1558'
update c_Drug_Generic set generic_name = 'cyanocobalamin / folic acid / iron / zinc' where generic_rxcui = 'KEGI8976'
update c_Drug_Generic set generic_name = 'cyanocobalamin / pyridoxine / thiamine' where generic_rxcui = 'KEGI1210'
UPDATE c_Drug_Generic SET generic_name = 'thiamine nitrate (vitamin B1) / pyridoxine HCl (vitamin B6) / cyanocobalamin (vitamin B12)' where generic_rxcui = 'KEGI2422'
UPDATE c_Drug_Generic SET generic_name = 'thiamine nitrate (vitamin B1) / pyridoxine (vitamin B6) / cyanocobalamin (vitamin B12)' where generic_rxcui = 'KEGI4064'
update c_Drug_Generic set generic_name = 'cyproheptadine / elemental iron / elemental zinc / glycine / vitamin B1 / vitamin B2 / vitamin B3 / vitamin B6 / vitamin B12' where generic_rxcui = 'KEGI2735'
update c_Drug_Generic set generic_name = 'cyproterone / ethinyl estradiol' where generic_rxcui = 'KEGI980'
update c_Drug_Generic set generic_name = 'dexamethasone / gentamicin' where generic_rxcui = 'KEGI2499A'
update c_Drug_Generic set generic_name = 'dexamethasone / moxifloxacin' where generic_rxcui = 'KEGI1323'
update c_Drug_Generic set generic_name = 'dexketoprofen' where generic_rxcui = 'KEGI11561'
update c_Drug_Generic set generic_name = 'dextromethorphan / guaiFENesin / promethazine' where generic_rxcui = 'KEGI9805'
update c_Drug_Generic set generic_name = 'diacerein / glucosamine / methyl sulphonyl methane' where generic_rxcui = 'KEGI3801'
update c_Drug_Generic set generic_name = 'diclofenac / lidocaine' where generic_rxcui = 'KEGI2485'
update c_Drug_Generic set generic_name = 'diclofenac / paracetamol' where generic_rxcui = 'KEGI2129'
update c_Drug_Generic set generic_name = 'diclofenac / paracetamol / serratiopeptidase' where generic_rxcui = 'KEGI4920'
update c_Drug_Generic set generic_name = 'diclofenac / paracetamol / tiZANidine' where generic_rxcui = 'KEGI9077'
update c_Drug_Generic set generic_name = 'diclofenac / RABEprazole' where generic_rxcui = 'KEGI11597'
update c_Drug_Generic set generic_name = 'diclofenac / serratiopeptidase' where generic_rxcui = 'KEGI7206'
update c_Drug_Generic set generic_name = 'diclofenac / thiocolchicoside' where generic_rxcui = 'KEGI11543'
update c_Drug_Generic set generic_name = 'diclofenac / tiZANidine' where generic_rxcui = 'KEGI9075'
update c_Drug_Generic set generic_name = 'dicyclomine / diloxanide / metroNIDAZOLE' where generic_rxcui = 'KEGI16158'
update c_Drug_Generic set generic_name = 'dicyclomine / mefenamate' where generic_rxcui = 'KEGI358'
update c_Drug_Generic set generic_name = 'dicyclomine / simethicone' where generic_rxcui = 'KEGI158'
update c_Drug_Generic set generic_name = 'dicycloverine / paracetamol' where generic_rxcui = 'KEGI532'
update c_Drug_Generic set generic_name = 'diflucortolone / isoconazole' where generic_rxcui = 'KEGI1114'
update c_Drug_Generic set generic_name = 'dill seed oil / sodium bicarbonate' where generic_rxcui = 'KEGI7134'
update c_Drug_Generic set generic_name = 'dill seed oil terpenless / sodium bicarbonate' where generic_rxcui = 'KEGI1123'
update c_Drug_Generic set generic_name = 'diloxanide' where generic_rxcui = 'KEGI11145'
update c_Drug_Generic set generic_name = 'diloxanide / dimeticone / homatropine / tinidazole' where generic_rxcui = 'KEGI7916'
update c_Drug_Generic set generic_name = 'diloxanide / metroNIDAZOLE' where generic_rxcui = 'KEGI1057'
update c_Drug_Generic set generic_name = 'diloxanide / metroNIDAZOLE / simethicone' where generic_rxcui = 'KEGI7081'
update c_Drug_Generic set generic_name = 'diloxanide / simethicone / tinidazole' where generic_rxcui = 'KEGI9944'
update c_Drug_Generic set generic_name = 'diphenhydrAMINE / paracetamol / pseudoephedrine' where generic_rxcui = 'KEGI1035'
update c_Drug_Generic set generic_name = 'dolutegravir / lamiVUDine / tenofovir disoproxil' where generic_rxcui = 'KEGI12929'
update c_Drug_Generic set generic_name = 'domperidone / esomeprazole' where generic_rxcui = 'KEGI14179'
update c_Drug_Generic set generic_name = 'domperidone / omeprazole' where generic_rxcui = 'KEGI4036'
update c_Drug_Generic set generic_name = 'domperidone / pantoprazole' where generic_rxcui = 'KEGI13269'
update c_Drug_Generic set generic_name = 'domperidone / RABEprazole' where generic_rxcui = 'KEGI10420'
update c_Drug_Generic set generic_name = 'doxylamine / folic acid / pyridoxine' where generic_rxcui = 'KEGI3586'
update c_Drug_Generic set generic_name = 'drotaverine' where generic_rxcui = 'KEGI5481'
update c_Drug_Generic set generic_name = 'drotaverine / mefenamate' where generic_rxcui = 'KEGI2831'
update c_Drug_Generic set generic_name = 'efavirenz / lamiVUDine / zidovudine' where generic_rxcui = 'KEGI2484'
update c_Drug_Generic set generic_name = 'enalapril / nitrendipine' where generic_rxcui = 'KEGI14172'
update c_Drug_Generic set generic_name = 'ePHEDrine / theophylline' where generic_rxcui = 'KEGI3731'
update c_Drug_Generic set generic_name = 'esomeprazole / itopride' where generic_rxcui = 'KEGI7642'
update c_Drug_Generic set generic_name = 'esomeprazole magnesium / naproxen' where generic_rxcui = 'KEGI15333'
update c_Drug_Generic set generic_name = 'ethambutol / isoniazid' where generic_rxcui = 'KEGI4909'
update c_Drug_Generic set generic_name = 'ethambutol / isoniazid / pyrazinamide / rifampicin' where generic_rxcui = 'KEGI1081'
update c_Drug_Generic set generic_name = 'etifoxine' where generic_rxcui = 'KEGI6661'
update c_Drug_Generic set generic_name = 'etophylline / theophylline' where generic_rxcui = 'KEGI8199'
update c_Drug_Generic set generic_name = 'felodipine / metoprolol' where generic_rxcui = 'KEGI7701'
update c_Drug_Generic set generic_name = 'fenoterol / ipratropium' where generic_rxcui = 'KEGI2674'
update c_Drug_Generic set generic_name = 'ferric ammonium citrate / folic acid / vitamin B12 / zinc' where generic_rxcui = 'KEGI13239'
update c_Drug_Generic set generic_name = 'ferric ammonium citrate / nicotinamide / pyridoxine / riboflavin / thiamine' where generic_rxcui = 'KEGI3487'
update c_Drug_Generic set generic_name = 'ferrous sulfate / nicotinamide / vitamin B1 / vitamin B2 / vitamin B6' where generic_rxcui = 'KEGI4524'
update c_Drug_Generic set generic_name = 'finasteride / tamsulosin' where generic_rxcui = 'KEGI7002'
update c_Drug_Generic set generic_name = 'fluPHENAZine / nortriptyline' where generic_rxcui = 'KEGI5392'
update c_Drug_Generic set generic_name = 'fluticasone / mupirocin' where generic_rxcui = 'KEGI12568'
update c_Drug_Generic set generic_name = 'folic acid / iron carbonyl / vitamin B12 / vitamin C / zinc' where generic_rxcui = 'KEGI8974'
update c_Drug_Generic set generic_name = 'folic acid / iron(III) hydroxide' where generic_rxcui = 'KEGI6503'
update c_Drug_Generic set generic_name = 'fusidic acid / mometasone' where generic_rxcui = 'KEGI11299'
update c_Drug_Generic set generic_name = 'glibenclamide / metFORMIN' where generic_rxcui = 'KEGI564'
update c_Drug_Generic set generic_name = 'gliclazide / metFORMIN' where generic_rxcui = 'KEGI4168'
update c_Drug_Generic set generic_name = 'glimepiride / metFORMIN' where generic_rxcui = 'KEGI3022'
update c_Drug_Generic set generic_name = 'glimepiride / metFORMIN / pioglitazone' where generic_rxcui = 'KEGI6121'
update c_Drug_Generic set generic_name = 'glucosamine / chondroitin' where generic_rxcui = 'KEGI7189'
update c_Drug_Generic set generic_name = 'guaiFENesin / salbutamol' where generic_rxcui = 'KEGI4595'
update c_Drug_Generic set generic_name = 'hydroCHLOROthiazide / nebivolol' where generic_rxcui = 'KEGI10776'
update c_Drug_Generic set generic_name = 'hydroCHLOROthiazide / ramipril' where generic_rxcui = 'KEGI5947'
update c_Drug_Generic set generic_name = 'hydroCHLOROthiazide / zofenopril' where generic_rxcui = 'KEGI11560'
update c_Drug_Generic set generic_name = 'HYDROXYprogesterone' where generic_rxcui = 'KEGI1191B'
update c_Drug_Generic set generic_name = 'indapamide / perindopril' where generic_rxcui = 'KEGI4945'
update c_Drug_Generic set generic_name = 'insulin aspart / insulin aspart protamine' where generic_rxcui = 'KEGI283'
update c_Drug_Generic set generic_name = 'ipratropium / levosalbutamol' where generic_rxcui = 'KEGI8721'
update c_Drug_Generic set generic_name = 'isoconazole' where generic_rxcui = 'KEGI1094'
update c_Drug_Generic set generic_name = 'isoniazid / pyrazinamide / rifampicin' where generic_rxcui = 'KEGI6447'
update c_Drug_Generic set generic_name = 'isoniazid / rifampicin' where generic_rxcui = 'KEGI5724'
update c_Drug_Generic set generic_name = 'ispaghula husk / lactulose' where generic_rxcui = 'KEGI9258'
update c_Drug_Generic set generic_name = 'itopride / RABEPrazole' where generic_rxcui = 'KEGI13672'
update c_Drug_Generic set generic_name = 'lamiVUDine / nevirapine / zidovudine' where generic_rxcui = 'KEGI5438'
update c_Drug_Generic set generic_name = 'latanoprost / timolol' where generic_rxcui = 'KEGI13777'
update c_Drug_Generic set generic_name = 'levosalbutamol' where generic_rxcui = 'KEGI2096'
update c_Drug_Generic set generic_name = 'lidocaine / paracetamol' where generic_rxcui = 'KEGI5332'
update c_Drug_Generic set generic_name = 'magnesium carbonate / magnesium trisilicate / sodium bicarbonate' where generic_rxcui = 'KEGI3975'
update c_Drug_Generic set generic_name = 'mefenamate / paracetamol' where generic_rxcui = 'KEGI1391'
UPDATE c_Drug_Generic SET generic_name = 'mefenamate / tranexamic acid' WHERE generic_rxcui = 'KEGI5808' -- mefenamate / tranexamic acid
update c_Drug_Generic set generic_name = 'metFORMIN / VILDAgliptin' where generic_rxcui = 'KEGI13379'
update c_Drug_Generic set generic_name = 'methylcobalamin / pregabalin' where generic_rxcui = 'KEGI2949'
update c_Drug_Generic set generic_name = 'metroNIDAZOLE / miconazole' where generic_rxcui = 'KEGI6957'
update c_Drug_Generic set generic_name = 'metroNIDAZOLE / neomycin / nystatin' where generic_rxcui = 'KEGI10412'
update c_Drug_Generic set generic_name = 'miconazole / triamcinolone' where generic_rxcui = 'KEGI277'
update c_Drug_Generic set generic_name = 'mosapride' where generic_rxcui = 'KEGI5852'
update c_Drug_Generic set generic_name = 'mosapride / RABEprazole' where generic_rxcui = 'KEGI3664'
update c_Drug_Generic set generic_name = 'nalidixate' where generic_rxcui = 'KEGI11211'
update c_Drug_Generic set generic_name = 'neomycin / nystatin / polymyxin B' where generic_rxcui = 'KEGI4981'
update c_Drug_Generic set generic_name = 'nitroglycerine' where generic_rxcui = 'KEGI14085'
update c_Drug_Generic set generic_name = 'nortryptyline / pregabalin' where generic_rxcui = 'KEGI15717'
update c_Drug_Generic set generic_name = 'paracetamol / promethazine / pseudoephedrine / triprolidine' where generic_rxcui = 'KEGI9802'
update c_Drug_Generic set generic_name = 'paracetamol / traMADol' where generic_rxcui = 'KEGI5235'
update c_Drug_Generic set generic_name = 'peppermint oil / sodium bicarbonate' where generic_rxcui = 'KEGI4895'
update c_Drug_Generic set generic_name = 'paracetamol / phenylephrine' where generic_rxcui = 'KEGI215'
update c_Drug_Generic set generic_name = 'pyrimethamine / sulfadoxine' where generic_rxcui = 'KEGI1093'
update c_Drug_Generic set generic_name = 'pyrimethamine / sulfametopyrazine' where generic_rxcui = 'KEGI4396'
update c_Drug_Generic set generic_name = 'salbutamol' where generic_rxcui = 'KEGI2307'
update c_Drug_Generic set generic_name = 'tiemonium' where generic_rxcui = 'KEGI1252'
update c_Drug_Generic set generic_name = 'travoprost / timolol' where generic_rxcui = 'KEGI1600'
update c_Drug_Generic set generic_name = 'zofenopril' where generic_rxcui = 'KEGI9416'
update c_Drug_Generic set generic_name = 'zuclopenthixol' where generic_rxcui = 'KEGI540A'

update c_Drug_Generic set generic_name = 'ferrous sulfate' where generic_rxcui = 'KEGI3920'
update c_Drug_Generic set generic_name = 'ferrous sulfate / folic acid' where generic_rxcui = 'KEGI3971'

