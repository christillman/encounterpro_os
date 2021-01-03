-- We need to build this after cleaning up the formulations,
-- so we can use the cleaned formulations to populate generic_rxcui

DELETE FROM [c_Drug_Generic_Related]

-- ones we have used unique to Kenya (excludes packs)
INSERT INTO [c_Drug_Generic_Related] (
	[country_code],
	[source_id],
	[source_generic_form_descr],
	[active_ingredients],
	[generic_rxcui],
	[is_single_ingredient])
SELECT 'ke', 
	k.Retention_No, 
	k.SCD_PSN_Version,
	k.Ingredient,
	g.generic_rxcui,
	g.[is_single_ingredient]	
FROM Kenya_Drugs k
JOIN c_Drug_Generic g 
	ON g.generic_rxcui = 'KEGI' + k.Retention_No
-- (359 row(s) affected)

-- Same ingredient wording in c_Drug_Generic
INSERT INTO [c_Drug_Generic_Related] (
	[country_code],
	[source_id],
	[source_generic_form_descr],
	[active_ingredients],
	[generic_rxcui],
	[is_single_ingredient])
SELECT DISTINCT 'ke',
	k.Retention_No, 
	k.SCD_PSN_Version,
	k.Ingredient, 
	g.generic_rxcui,
	g.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Generic g ON g.generic_name = k.Ingredient
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic_Related] r
	WHERE r.country_code = 'ke' AND r.[source_id] = k.Retention_No)
AND k.Retention_No NOT IN ('480', -- Pack using []
'00nobrandfound',
'No Retention No',
'Not in Retention List')
-- (1153 row(s) affected)

-- Referenced through c_Drug_Formulation via same generic formulation wording
INSERT INTO [c_Drug_Generic_Related] (
	[country_code],
	[source_id],
	[source_generic_form_descr],
	[active_ingredients],
	[generic_rxcui],
	[is_single_ingredient])
SELECT DISTINCT 'ke',
	k.Retention_No, 
	k.SCD_PSN_Version,
	k.Ingredient, 
	g.generic_rxcui,
	g.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Formulation f ON f.form_descr = k.SCD_PSN_Version
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic_Related] r
	WHERE r.country_code = 'ke' AND r.[source_id] = k.Retention_No)
AND k.Retention_No NOT IN ('480', -- Pack using []
'00nobrandfound',
'No Retention No',
'Not in Retention List')
-- (624 row(s) affected)

-- Referenced through c_Drug_Formulation via KE formulation
INSERT INTO [c_Drug_Generic_Related] (
	[country_code],
	[source_id],
	[source_generic_form_descr],
	[active_ingredients],
	[generic_rxcui],
	[is_single_ingredient])
SELECT DISTINCT 'ke',
	k.Retention_No,  
	k.SCD_PSN_Version,
	k.Ingredient,
	g.generic_rxcui,
	g.[is_single_ingredient]
FROM Kenya_Drugs k
JOIN c_Drug_Formulation f ON f.form_rxcui = 'KEG' + k.Retention_No
JOIN c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui
WHERE NOT EXISTS (SELECT 1 FROM [c_Drug_Generic_Related] r
	WHERE r.country_code = 'ke' AND r.[source_id] = k.Retention_No)
AND k.Retention_No NOT IN ('480', -- Pack using []
'00nobrandfound',
'No Retention No',
'Not in Retention List')
-- (2 row(s) affected)

-- others where ingredient was populated 
INSERT INTO [c_Drug_Generic_Related] (
	[country_code],
	[source_id],
	[source_generic_form_descr],
	[active_ingredients],
	[generic_rxcui],
	[is_single_ingredient])
SELECT 'ke',
	k.Retention_No,  
	k.SCD_PSN_Version,
	k.Ingredient,
	NULL,
	CASE WHEN Ingredient LIKE '% / %' THEN 0 ELSE 1 END
FROM Kenya_Drugs k
WHERE k.Ingredient IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM [c_Drug_Generic_Related] r
	WHERE r.country_code = 'ke' AND r.[source_id] = k.Retention_No)
AND k.Retention_No NOT IN ('480', -- Pack using []
'00nobrandfound',
'No Retention No',
'Not in Retention List')
-- (204 row(s) affected)


-- There were two concerns here, one was referencing back to RXNORM ingredient names
-- Where RXNORM is being used as ingredient, the record is moved to c_Drug_Generic_Related 
-- with the RXNORM id in c_Drug_Generic_Related.generic_rxcui (and the retention name as it was).

-- We also standardized names (alphabetical ingredients) where no RXNORM exists
-- Where this is being done, one KE ingredient name is standardized 
-- (08 c_Drug_Generic_Kenya_Name_Standard) and others are moved to c_Drug_Generic_Related.

-- Update those where standardised naming relation has been established
/* 
select generic_rxcui, source_id, [active_ingredients] 
from c_Drug_Generic_Related order by [active_ingredients]
*/
/*
-- this was done after the first cut, where I used the various docs to update
select distinct 'UPDATE c_Drug_Generic_Related SET generic_rxcui = ''' + r.generic_rxcui
	+ ''' WHERE active_ingredients = ''' + active_ingredients + ''' -- ', g.generic_name
	from c_Drug_Generic_Related r
	join c_Drug_Generic g ON g.generic_rxcui = r.generic_rxcui
where r.generic_rxcui is not null
order by g.generic_name
select distinct 'UPDATE c_Drug_Generic_Related SET generic_rxcui = ''''' 
	, ' WHERE active_ingredients = ''' + active_ingredients + ''' -- '
	from c_Drug_Generic_Related r
where r.generic_rxcui is null
order by 2
*/
UPDATE c_Drug_Generic_Related SET generic_rxcui = '7417' WHERE source_id = '3979' -- 12HR NIFEdipine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '190521' WHERE source_id = '10941' -- abacavir sulfate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI10052' WHERE source_id = '11889' -- aceclofenac / thiocolchicoside
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1316' WHERE source_id = '6491' -- adapalene / clindamycin phosphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '17300' WHERE source_id = '10530' -- alfuzosin hydrochloride
UPDATE c_Drug_Generic_Related SET generic_rxcui = '641' WHERE source_id = '5881' -- amikacin sulfate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '689' WHERE source_id = '12789' -- aminophylline hydrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '19711' WHERE source_id = '10752' -- amoxicillin / clavulanate potassium
UPDATE c_Drug_Generic_Related SET generic_rxcui = '19711' WHERE source_id = '13094' -- amoxicillin / clavulanic acid
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI3517' WHERE source_id = '3518' -- amoxicillin / flucloxacillin magnesium
UPDATE c_Drug_Generic_Related SET generic_rxcui = '466584' WHERE source_id = '12488' -- aspirin / caffeine / paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2259' WHERE source_id = '261' -- bacitracin zinc / neomycin
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1347' WHERE source_id = '1839' -- beclometasone dipropionate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1347' WHERE source_id = '2342' -- beclomethasone dipropionate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '10811' WHERE source_id = '15339' -- benzhexol HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1511' WHERE source_id = '9105' -- betahistine dihydrochloride
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1019' WHERE source_id = '6696' -- betamethasone dipropionate / gentamicin
UPDATE c_Drug_Generic_Related SET generic_rxcui = '389132' WHERE source_id = '2042' -- budesonide / formoterol fumarate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '20610' WHERE source_id = '742' -- cetirizine dihydrochloride
UPDATE c_Drug_Generic_Related SET generic_rxcui = '2348' WHERE source_id = '3772' -- chloramphenicol palmitate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '2403' WHERE source_id = '2154' -- chlorproMAZINE HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '274964' WHERE source_id = '8853' -- ciclesonide / INHAL Metered Dose Inhaler,
UPDATE c_Drug_Generic_Related SET generic_rxcui = '611854' WHERE source_id = '867' -- clidinium bromide / chlordiazePOXIDE HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI10561' WHERE source_id = '11176' -- clindamycin / clotrimazole
UPDATE c_Drug_Generic_Related SET generic_rxcui = '687144' WHERE source_id = '6931' -- clindamycin phosphate / tretinoin
UPDATE c_Drug_Generic_Related SET generic_rxcui = '106928' WHERE source_id = '1027' -- clotrimazole / betamethasone valerate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '605998' WHERE source_id = '7346' -- codeine phosphate / chlorpheniramine maleate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3264' WHERE source_id = '7469' -- dexamethasone decanoate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3264' WHERE source_id = '1272' -- dexamethasone sodium phosphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '237162' WHERE source_id = '7957' -- dexketoprofen
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3355' WHERE source_id = '11542' -- diclofenac diethylamine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5385' WHERE source_id = '5791' -- diclofenac potassium / paracetamol / chlorzoxazone
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3355' WHERE source_id = '2132A' -- diclofenac sodium
UPDATE c_Drug_Generic_Related SET generic_rxcui = '214502' WHERE source_id = '11847' -- diclofenac sodium / miSOPROStol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2473' WHERE source_id = '2473' -- diclofenac sodium / paracetamol / chlorzoxane
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI4920' WHERE source_id = '5630' -- diclofenac sodium / paracetamol / serratiopeptidase
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3361' WHERE source_id = '2073' -- dicycloverine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '23088' WHERE source_id = '3091' -- dihydrocodeine tartrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3443' WHERE source_id = '2135' -- dilTIAZem hydrochloride
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3498' WHERE source_id = '938' -- diphenhydrAMINE HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1430990' WHERE source_id = '12698' -- donepezil HCL / memantine HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '3640' WHERE source_id = '1917' -- doxycycline HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1001472' WHERE source_id = '15203' -- dutasteride / tamsulosin HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '214536' WHERE source_id = '5759' -- enalapril maleate / hydroCHLOROthiazide
UPDATE c_Drug_Generic_Related SET generic_rxcui = '67108' WHERE source_id = '5870' -- enoxaparin sodium
UPDATE c_Drug_Generic_Related SET generic_rxcui = '4053' WHERE source_id = '3803' -- erythromcyn ethylsuccinate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '4053' WHERE source_id = '14059' -- erythromycin estolate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '4053' WHERE source_id = '7731' -- erythromycin stearate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '283742' WHERE source_id = '5571' -- esomeprazole magnesium
UPDATE c_Drug_Generic_Related SET generic_rxcui = '4083' WHERE source_id = '1182' -- estradiol valerate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI8199' WHERE source_id = '8269' -- etophylline / theophylline hydrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1659' WHERE source_id = '2970' -- ferric ammonium citrate / folic acid / vitamin B
UPDATE c_Drug_Generic_Related SET generic_rxcui = '87636' WHERE source_id = '1306' -- fexofenadine HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = '284635' WHERE source_id = '2286' -- fluticasone propionate / salmeterol
UPDATE c_Drug_Generic_Related SET generic_rxcui = '4815' WHERE source_id = '5883' -- glibenclamide
UPDATE c_Drug_Generic_Related SET generic_rxcui = '106964' WHERE source_id = '7846' -- hydrocortisone acetate / lidocaine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '115264' WHERE source_id = '7075' -- ibandronic acid
UPDATE c_Drug_Generic_Related SET generic_rxcui = '214199' WHERE source_id = '2421' -- ipratropium / salbutamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = '7213' WHERE source_id = '221' -- ipratropium bromide
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI6503' WHERE source_id = '4757' -- iron (III) hydroxide polymaltofolic acid
UPDATE c_Drug_Generic_Related SET generic_rxcui = '42375' WHERE source_id = '13936' -- leuprolide acetate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2096' WHERE source_id = '8645' -- levosalbutamol sulphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI227' WHERE source_id = '7644' -- losartan potassium / amLODIPine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '257844' WHERE source_id = '12612' -- mefenamic acid
UPDATE c_Drug_Generic_Related SET generic_rxcui = '6902' WHERE source_id = '4764' -- methylPREDNISolone aceponate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '6902' WHERE source_id = '10134' -- methylPREDNISolone acetate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1057' WHERE source_id = '8659' -- metroNIDAZOLE / diloxanide furoate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '6922' WHERE source_id = '5188' -- metroNIDAZOLE benzoate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '6932' WHERE source_id = '4076' -- miconazole nitrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '106967' WHERE source_id = '7858' -- miconazole nitrate / hydrocortisone acetate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '216525' WHERE source_id = '4232' -- neomycin sulphate / polymyxin B sulphate / dexamethasone
UPDATE c_Drug_Generic_Related SET generic_rxcui = '352377' WHERE source_id = '7118' -- norelgestromin / ethinyl estradiol
UPDATE c_Drug_Generic_Related SET generic_rxcui = '7715' WHERE source_id = '831' -- orphenadrine citrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '7812' WHERE source_id = '15393' -- oxymetazoline HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI13269' WHERE source_id = '13631' -- pantoprazole / domperidone SR
UPDATE c_Drug_Generic_Related SET generic_rxcui = '40790' WHERE source_id = '5358' -- pantoprazole sodium
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI13269' WHERE source_id = '5232' -- pantoprazole sodium / domperidone
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI12488' WHERE source_id = '2728' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1493' WHERE source_id = '6917' -- paracetamol / caffeine anhydrous
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11049' WHERE source_id = '146' -- paracetamol / chlorphenamine maleate / phenylephrine HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11050' WHERE source_id = '11962' -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine anhydrous
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11297' WHERE source_id = '401' -- paracetamol / ibuprofen
UPDATE c_Drug_Generic_Related SET generic_rxcui = '54552' WHERE source_id = '7402' -- perindopril arginine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '1033889' WHERE source_id = '11744' -- perindopril arginine / amLODIPine besilate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '388499' WHERE source_id = '7385' -- perindopril arginine / indapamide
UPDATE c_Drug_Generic_Related SET generic_rxcui = '8183' WHERE source_id = '4693' -- phenytoin sodium
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5702' WHERE source_id = '941' -- promethazine / carbocisteine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '8745' WHERE source_id = '3929' -- promethazine HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '9071' WHERE source_id = '3583' -- quiNINE bisulphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '9071' WHERE source_id = '1463' -- quiNINE dihydrochloride
UPDATE c_Drug_Generic_Related SET generic_rxcui = '9071' WHERE source_id = '743' -- quiNINE HCI
UPDATE c_Drug_Generic_Related SET generic_rxcui = '9071' WHERE source_id = '276' -- quiNINE sulphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '114979' WHERE source_id = '11031' -- RABEprazole sodium
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2307' WHERE source_id = '4558' -- salbutamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = '435' WHERE source_id = '2307' -- salbutamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI8719' WHERE source_id = '9499' -- salbutamol sulphate / beclomethasone dipropionate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '284635' WHERE source_id = '2315' -- salmeterol / fluticasone
UPDATE c_Drug_Generic_Related SET generic_rxcui = '284635' WHERE source_id = '2318' -- salmeterol / fluticasone propionate
UPDATE c_Drug_Generic_Related SET generic_rxcui = '136411' WHERE source_id = '11901' -- sildenafil citrate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2849' WHERE source_id = '4754' -- silymarin / thiamine / pyridoxine HCl / riboflavin / nicotinamide / calcium pantothenate / cyanocobalamin
UPDATE c_Drug_Generic_Related SET generic_rxcui = '820299' WHERE source_id = '4377' -- sodium bicarbonate / citric acid
UPDATE c_Drug_Generic_Related SET generic_rxcui = '253182' WHERE source_id = '1241' -- soluble insulin, human
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1210' WHERE source_id = '4064' -- thiamine nitrate (vitamin B1) / pyridoxine (vitamin B6) / cyanocobalamin (vitamin B12)
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1210' WHERE source_id = '2422' -- thiamine nitrate (vitamin B1) / pyridoxine HCl (vitamin B6) / cyanocobalamin (vitamin B12)
UPDATE c_Drug_Generic_Related SET generic_rxcui = '38413' WHERE source_id = '10765' -- torasemide
UPDATE c_Drug_Generic_Related SET generic_rxcui = '10689' WHERE source_id = '10794' -- traMADol HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = '729455' WHERE source_id = '11135' -- valsartan / amLODIPine
UPDATE c_Drug_Generic_Related SET generic_rxcui = '39841' WHERE source_id = '5197' -- xylometazoline HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI540A' WHERE source_id = '547' -- zuclopenthixol decanoate


-- update generic_rxcui where the ingredient name matches those already accounted for
UPDATE r
SET generic_rxcui = r2.generic_rxcui
FROM [c_Drug_Generic_Related] r
JOIN [c_Drug_Generic_Related] r2
	ON r2.active_ingredients = r.active_ingredients
WHERE r.generic_rxcui IS NULL
AND r2.generic_rxcui IS NOT NULL
-- (50 row(s) affected)

-- Additional updates from Suggested_Kenya_Mappings.xlsx
update c_Drug_Generic_Related set generic_rxcui = '1100072' where source_id = '15686'
update c_Drug_Generic_Related set generic_rxcui = '46041' where source_id = '13639'
update c_Drug_Generic_Related set generic_rxcui = '46041' where source_id = '1870'
update c_Drug_Generic_Related set generic_rxcui = '214212' where source_id = '6951'
update c_Drug_Generic_Related set generic_rxcui = '703' where source_id = '5435'
update c_Drug_Generic_Related set generic_rxcui = '704' where source_id = '13054'
update c_Drug_Generic_Related set generic_rxcui = '852897' where source_id = '3564'
update c_Drug_Generic_Related set generic_rxcui = '852897' where source_id = '3566'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '10938'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '10943'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '2535'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '3158'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '5113'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '5214'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '5739'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '934'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '937'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '9820'
update c_Drug_Generic_Related set generic_rxcui = '1033889' where source_id = '11751'
update c_Drug_Generic_Related set generic_rxcui = '1033889' where source_id = '11752'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '3060'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '3092'
update c_Drug_Generic_Related set generic_rxcui = '1008824' where source_id = '6388'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '12228'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '12229'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '3339'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '4809'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '4859'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '4871'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '4884'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '8176'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '9552'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '9559'
update c_Drug_Generic_Related set generic_rxcui = '83367' where source_id = '9700'
update c_Drug_Generic_Related set generic_rxcui = '284623' where source_id = '3132'
update c_Drug_Generic_Related set generic_rxcui = '284623' where source_id = '3133'
update c_Drug_Generic_Related set generic_rxcui = '18603' where source_id = '1370'
update c_Drug_Generic_Related set generic_rxcui = '1091643' where source_id = '16701'
update c_Drug_Generic_Related set generic_rxcui = '1091643' where source_id = '16703'
update c_Drug_Generic_Related set generic_rxcui = '1520' where source_id = '1578'
update c_Drug_Generic_Related set generic_rxcui = '19484' where source_id = '10202'
update c_Drug_Generic_Related set generic_rxcui = '19484' where source_id = '10203'
update c_Drug_Generic_Related set generic_rxcui = '19484' where source_id = '12435'
update c_Drug_Generic_Related set generic_rxcui = '19484' where source_id = '7547'
update c_Drug_Generic_Related set generic_rxcui = '214317' where source_id = '10367'
update c_Drug_Generic_Related set generic_rxcui = '214317' where source_id = '10477'
update c_Drug_Generic_Related set generic_rxcui = '214317' where source_id = '10479'
update c_Drug_Generic_Related set generic_rxcui = '214317' where source_id = '7550'
update c_Drug_Generic_Related set generic_rxcui = '214317' where source_id = '7576'
update c_Drug_Generic_Related set generic_rxcui = '597142' where source_id = '6235'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI3456' where source_id = '6458'
update c_Drug_Generic_Related set generic_rxcui = '42347' where source_id = '3224'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '11190'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '1818'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '1819'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '3070'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '5680'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '5688'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '731'
update c_Drug_Generic_Related set generic_rxcui = '214354' where source_id = '9040'
update c_Drug_Generic_Related set generic_rxcui = '284628' where source_id = '3268'
update c_Drug_Generic_Related set generic_rxcui = '284628' where source_id = '5690'
update c_Drug_Generic_Related set generic_rxcui = '83682' where source_id = '15512'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '3684'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '4087'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '4096'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '5130'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '4111'
update c_Drug_Generic_Related set generic_rxcui = '2194' where source_id = '6454'
update c_Drug_Generic_Related set generic_rxcui = '20610' where source_id = '2283'
update c_Drug_Generic_Related set generic_rxcui = '20610' where source_id = '5516'
update c_Drug_Generic_Related set generic_rxcui = '20610' where source_id = '5517'
update c_Drug_Generic_Related set generic_rxcui = '20610' where source_id = '5873'
update c_Drug_Generic_Related set generic_rxcui = '4986' where source_id = '12071'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '2565'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '2567'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '3307'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '5293'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '5642'
update c_Drug_Generic_Related set generic_rxcui = '2582' where source_id = '9710'
update c_Drug_Generic_Related set generic_rxcui = '2596' where source_id = '11771'
update c_Drug_Generic_Related set generic_rxcui = '2596' where source_id = '1243'
update c_Drug_Generic_Related set generic_rxcui = '2596' where source_id = '2913'
update c_Drug_Generic_Related set generic_rxcui = '2596' where source_id = '5296'
update c_Drug_Generic_Related set generic_rxcui = '2597' where source_id = '5041'
update c_Drug_Generic_Related set generic_rxcui = '106928' where source_id = '4844'
update c_Drug_Generic_Related set generic_rxcui = '106928' where source_id = '6949'
update c_Drug_Generic_Related set generic_rxcui = '3008' where source_id = '4881'
update c_Drug_Generic_Related set generic_rxcui = '3008' where source_id = '4886'
update c_Drug_Generic_Related set generic_rxcui = '597501' where source_id = '6283'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '2788'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '2792'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '5067'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '703'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '704'
update c_Drug_Generic_Related set generic_rxcui = '3355' where source_id = '5285'
update c_Drug_Generic_Related set generic_rxcui = '3443' where source_id = '5477'
update c_Drug_Generic_Related set generic_rxcui = '135447' where source_id = '13716'
update c_Drug_Generic_Related set generic_rxcui = '135447' where source_id = '1572'
update c_Drug_Generic_Related set generic_rxcui = '135447' where source_id = '1573'
update c_Drug_Generic_Related set generic_rxcui = '135447' where source_id = '4039'
update c_Drug_Generic_Related set generic_rxcui = '662263' where source_id = '10905'
update c_Drug_Generic_Related set generic_rxcui = '49276' where source_id = '12705'
update c_Drug_Generic_Related set generic_rxcui = '49276' where source_id = '12707'
update c_Drug_Generic_Related set generic_rxcui = '3640' where source_id = '11443'
update c_Drug_Generic_Related set generic_rxcui = '1375947' where source_id = '5530'
update c_Drug_Generic_Related set generic_rxcui = '1375947' where source_id = '582'
update c_Drug_Generic_Related set generic_rxcui = '3743' where source_id = '8388'
update c_Drug_Generic_Related set generic_rxcui = '1007761' where source_id = '6165'
update c_Drug_Generic_Related set generic_rxcui = '1008145' where source_id = '2752'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '2287'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '2385'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '3140'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '3141'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '5283'
update c_Drug_Generic_Related set generic_rxcui = '3827' where source_id = '5758'
update c_Drug_Generic_Related set generic_rxcui = '321988' where source_id = '4239'
update c_Drug_Generic_Related set generic_rxcui = '321988' where source_id = '7067'
update c_Drug_Generic_Related set generic_rxcui = '321988' where source_id = '7542'
update c_Drug_Generic_Related set generic_rxcui = '321988' where source_id = '7545'
update c_Drug_Generic_Related set generic_rxcui = '283742' where source_id = '13571'
update c_Drug_Generic_Related set generic_rxcui = '283742' where source_id = '7721'
update c_Drug_Generic_Related set generic_rxcui = '214565' where source_id = '3302'
update c_Drug_Generic_Related set generic_rxcui = '4491' where source_id = '1607'
update c_Drug_Generic_Related set generic_rxcui = '4496' where source_id = '14810'
update c_Drug_Generic_Related set generic_rxcui = '1424888' where source_id = '10555'
update c_Drug_Generic_Related set generic_rxcui = '1424888' where source_id = '10556'
update c_Drug_Generic_Related set generic_rxcui = '42355' where source_id = '7797'
update c_Drug_Generic_Related set generic_rxcui = '138099' where source_id = '5861'
update c_Drug_Generic_Related set generic_rxcui = '1596450' where source_id = '1718'
update c_Drug_Generic_Related set generic_rxcui = '1596450' where source_id = '2236'
update c_Drug_Generic_Related set generic_rxcui = '1596450' where source_id = '2249'
update c_Drug_Generic_Related set generic_rxcui = '26237' where source_id = '10769'
update c_Drug_Generic_Related set generic_rxcui = '5470' where source_id = '10027'
update c_Drug_Generic_Related set generic_rxcui = '5470' where source_id = '2245'
update c_Drug_Generic_Related set generic_rxcui = '5470' where source_id = '6340'
update c_Drug_Generic_Related set generic_rxcui = '5492' where source_id = '6232'
update c_Drug_Generic_Related set generic_rxcui = '5492' where source_id = '7001'
update c_Drug_Generic_Related set generic_rxcui = '5521' where source_id = '670'
update c_Drug_Generic_Related set generic_rxcui = '214652' where source_id = '4138'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI4945' where source_id = '7387'
update c_Drug_Generic_Related set generic_rxcui = '51428' where source_id = '289'
update c_Drug_Generic_Related set generic_rxcui = '51428' where source_id = '289PF'
update c_Drug_Generic_Related set generic_rxcui = '51428' where source_id = '289V'
update c_Drug_Generic_Related set generic_rxcui = '400008' where source_id = '12233'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI1235' where source_id = '1217'
update c_Drug_Generic_Related set generic_rxcui = '1649480' where source_id = '721'
update c_Drug_Generic_Related set generic_rxcui = '1649480' where source_id = '724'
update c_Drug_Generic_Related set generic_rxcui = '1649480' where source_id = '7416'
update c_Drug_Generic_Related set generic_rxcui = '1649480' where source_id = '7417'
update c_Drug_Generic_Related set generic_rxcui = '35827' where source_id = '1245'
update c_Drug_Generic_Related set generic_rxcui = '35827' where source_id = '1247'
update c_Drug_Generic_Related set generic_rxcui = '35827' where source_id = '5255'
update c_Drug_Generic_Related set generic_rxcui = '35827' where source_id = '5940'
update c_Drug_Generic_Related set generic_rxcui = '35827' where source_id = '5970'
update c_Drug_Generic_Related set generic_rxcui = '6185' where source_id = '16548'
update c_Drug_Generic_Related set generic_rxcui = '1598388' where source_id = '11839'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '1537'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '15803'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '7766'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '7844'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '9849A'
update c_Drug_Generic_Related set generic_rxcui = '6387' where source_id = '9849B'
update c_Drug_Generic_Related set generic_rxcui = '1243019' where source_id = '1014'
update c_Drug_Generic_Related set generic_rxcui = '1243019' where source_id = '1065'
update c_Drug_Generic_Related set generic_rxcui = '1243019' where source_id = '958'
update c_Drug_Generic_Related set generic_rxcui = '6468' where source_id = '13237'
update c_Drug_Generic_Related set generic_rxcui = '6468' where source_id = '7864'
update c_Drug_Generic_Related set generic_rxcui = '214681' where source_id = '15954'
update c_Drug_Generic_Related set generic_rxcui = '214682' where source_id = '6682'
update c_Drug_Generic_Related set generic_rxcui = '29410' where source_id = '7712'
update c_Drug_Generic_Related set generic_rxcui = '29410' where source_id = '7714'
update c_Drug_Generic_Related set generic_rxcui = '6691' where source_id = '3309'
update c_Drug_Generic_Related set generic_rxcui = '6691' where source_id = '5265'
update c_Drug_Generic_Related set generic_rxcui = '6691' where source_id = '8413'
update c_Drug_Generic_Related set generic_rxcui = '6719' where source_id = '5321'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10481'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10482'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10483'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10484'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10485'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10529'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '10767'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '13625'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '3085'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '3276'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '4497'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '4535'
update c_Drug_Generic_Related set generic_rxcui = '6809' where source_id = '9606'
update c_Drug_Generic_Related set generic_rxcui = '729717' where source_id = '9535'
update c_Drug_Generic_Related set generic_rxcui = '729596' where source_id = '7773'
update c_Drug_Generic_Related set generic_rxcui = '729596' where source_id = '7774'
update c_Drug_Generic_Related set generic_rxcui = '6902' where source_id = '3303'
update c_Drug_Generic_Related set generic_rxcui = '6902' where source_id = '3305'
update c_Drug_Generic_Related set generic_rxcui = '6902' where source_id = '3306'
update c_Drug_Generic_Related set generic_rxcui = '6915' where source_id = '3238'
update c_Drug_Generic_Related set generic_rxcui = '6915' where source_id = '3880'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '1277'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '1279'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '6354'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '637'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '639'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '6685'
update c_Drug_Generic_Related set generic_rxcui = '6918' where source_id = '6689'
update c_Drug_Generic_Related set generic_rxcui = '108118' where source_id = '6628'
update c_Drug_Generic_Related set generic_rxcui = '108118' where source_id = '7112A'
update c_Drug_Generic_Related set generic_rxcui = '108118' where source_id = '7112B'
update c_Drug_Generic_Related set generic_rxcui = '108118' where source_id = '9872'
update c_Drug_Generic_Related set generic_rxcui = '88249' where source_id = '10612'
update c_Drug_Generic_Related set generic_rxcui = '7145' where source_id = '3599'
update c_Drug_Generic_Related set generic_rxcui = '7145' where source_id = '3602'
update c_Drug_Generic_Related set generic_rxcui = '31476' where source_id = '2541'
update c_Drug_Generic_Related set generic_rxcui = '597159' where source_id = '877'
update c_Drug_Generic_Related set generic_rxcui = '31555' where source_id = '13071'
update c_Drug_Generic_Related set generic_rxcui = '31555' where source_id = '13140'
update c_Drug_Generic_Related set generic_rxcui = '31555' where source_id = '6127'
update c_Drug_Generic_Related set generic_rxcui = '7514' where source_id = '11984'
update c_Drug_Generic_Related set generic_rxcui = '321064' where source_id = '10822'
update c_Drug_Generic_Related set generic_rxcui = '321064' where source_id = '10823'
update c_Drug_Generic_Related set generic_rxcui = '135391' where source_id = '11234'
update c_Drug_Generic_Related set generic_rxcui = '135391' where source_id = '11236'
update c_Drug_Generic_Related set generic_rxcui = '135391' where source_id = '14552'
update c_Drug_Generic_Related set generic_rxcui = '135391' where source_id = '1667'
update c_Drug_Generic_Related set generic_rxcui = '7646' where source_id = '7705'
update c_Drug_Generic_Related set generic_rxcui = '7646' where source_id = '7706'
update c_Drug_Generic_Related set generic_rxcui = '260101' where source_id = '10562'
update c_Drug_Generic_Related set generic_rxcui = '260101' where source_id = '10563'
update c_Drug_Generic_Related set generic_rxcui = '260101' where source_id = '10565'
update c_Drug_Generic_Related set generic_rxcui = '32675' where source_id = '2951'
update c_Drug_Generic_Related set generic_rxcui = '7804' where source_id = '9703'
update c_Drug_Generic_Related set generic_rxcui = '7804' where source_id = '9709'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI1493' where source_id = '4376'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI11122' where source_id = '3832'
update c_Drug_Generic_Related set generic_rxcui = '32937' where source_id = '3511'
update c_Drug_Generic_Related set generic_rxcui = '54552' where source_id = '5556'
update c_Drug_Generic_Related set generic_rxcui = '54552' where source_id = '5557'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI10886' where source_id = '3242'
update c_Drug_Generic_Related set generic_rxcui = '33738' where source_id = '2673'
update c_Drug_Generic_Related set generic_rxcui = '33738' where source_id = '2677'
update c_Drug_Generic_Related set generic_rxcui = '861634' where source_id = '12095'
update c_Drug_Generic_Related set generic_rxcui = '861634' where source_id = '12096'
update c_Drug_Generic_Related set generic_rxcui = '861634' where source_id = '12097'
update c_Drug_Generic_Related set generic_rxcui = '746741' where source_id = '11593'
update c_Drug_Generic_Related set generic_rxcui = '746741' where source_id = '11595'
update c_Drug_Generic_Related set generic_rxcui = '746741' where source_id = '2983'
update c_Drug_Generic_Related set generic_rxcui = '746741' where source_id = '3000'
update c_Drug_Generic_Related set generic_rxcui = '746741' where source_id = '3034'
update c_Drug_Generic_Related set generic_rxcui = '8638' where source_id = '2437'
update c_Drug_Generic_Related set generic_rxcui = '8638' where source_id = '6265'
update c_Drug_Generic_Related set generic_rxcui = '8638' where source_id = '3036'
update c_Drug_Generic_Related set generic_rxcui = '8638' where source_id = '3197'
update c_Drug_Generic_Related set generic_rxcui = '8638' where source_id = '5975'
update c_Drug_Generic_Related set generic_rxcui = '8745' where source_id = '5902'
update c_Drug_Generic_Related set generic_rxcui = '8787' where source_id = '11446'
update c_Drug_Generic_Related set generic_rxcui = '8787' where source_id = '11447'
update c_Drug_Generic_Related set generic_rxcui = '684879' where source_id = '10147'
update c_Drug_Generic_Related set generic_rxcui = '684879' where source_id = '2925'
update c_Drug_Generic_Related set generic_rxcui = '51272' where source_id = '7558'
update c_Drug_Generic_Related set generic_rxcui = '51272' where source_id = '7560'
update c_Drug_Generic_Related set generic_rxcui = '51272' where source_id = '7625'
update c_Drug_Generic_Related set generic_rxcui = '51272' where source_id = '7626'
update c_Drug_Generic_Related set generic_rxcui = '73056' where source_id = '5597'
update c_Drug_Generic_Related set generic_rxcui = '88014' where source_id = '8627'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '11802'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '204'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '205'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '3352'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '3353'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '3354'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '6743'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '6744'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '7649'
update c_Drug_Generic_Related set generic_rxcui = '301542' where source_id = '7650'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI2307' where source_id = '4567'
update c_Drug_Generic_Related set generic_rxcui = '9639' where source_id = '2954'
update c_Drug_Generic_Related set generic_rxcui = '36435' where source_id = '8543'
update c_Drug_Generic_Related set generic_rxcui = '36437' where source_id = '2967'
update c_Drug_Generic_Related set generic_rxcui = '36437' where source_id = '7632'
update c_Drug_Generic_Related set generic_rxcui = '214824' where source_id = '7818'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '10604'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '10607'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '10609'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '13846'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '950'
update c_Drug_Generic_Related set generic_rxcui = '593411' where source_id = '1197'
update c_Drug_Generic_Related set generic_rxcui = '322167' where source_id = '11376'
update c_Drug_Generic_Related set generic_rxcui = '322167' where source_id = '11377'
update c_Drug_Generic_Related set generic_rxcui = '322167' where source_id = '3355'
update c_Drug_Generic_Related set generic_rxcui = '37418' where source_id = '14157'
update c_Drug_Generic_Related set generic_rxcui = '37418' where source_id = '14158'
update c_Drug_Generic_Related set generic_rxcui = '37418' where source_id = '3078'
update c_Drug_Generic_Related set generic_rxcui = '10324' where source_id = '10949'
update c_Drug_Generic_Related set generic_rxcui = '10324' where source_id = '5806'
update c_Drug_Generic_Related set generic_rxcui = '77492' where source_id = '11375'
update c_Drug_Generic_Related set generic_rxcui = '77492' where source_id = '3356'
update c_Drug_Generic_Related set generic_rxcui = '77492' where source_id = '3592'
update c_Drug_Generic_Related set generic_rxcui = '77492' where source_id = '6811'
update c_Drug_Generic_Related set generic_rxcui = '1721603' where source_id = '2743'
update c_Drug_Generic_Related set generic_rxcui = '300195' where source_id = '2743'
update c_Drug_Generic_Related set generic_rxcui = '10395' where source_id = '1109'
update c_Drug_Generic_Related set generic_rxcui = '10395' where source_id = '3782'
update c_Drug_Generic_Related set generic_rxcui = '57258' where source_id = '12818'
update c_Drug_Generic_Related set generic_rxcui = '57258' where source_id = '7561'
update c_Drug_Generic_Related set generic_rxcui = '57258' where source_id = '7563'
update c_Drug_Generic_Related set generic_rxcui = '1487518' where source_id = '13727'
update c_Drug_Generic_Related set generic_rxcui = '275891' where source_id = '12051'
update c_Drug_Generic_Related set generic_rxcui = '306674' where source_id = '2367'
update c_Drug_Generic_Related set generic_rxcui = '306674' where source_id = '2373'
update c_Drug_Generic_Related set generic_rxcui = '306674' where source_id = '2377'
update c_Drug_Generic_Related set generic_rxcui = '39786' where source_id = '6441'
update c_Drug_Generic_Related set generic_rxcui = '11170' where source_id = '4661'
update c_Drug_Generic_Related set generic_rxcui = '11170' where source_id = '5308'
update c_Drug_Generic_Related set generic_rxcui = '11170' where source_id = '5575'
update c_Drug_Generic_Related set generic_rxcui = '77655' where source_id = '10760'

-- second set
update c_Drug_Generic_Related set generic_rxcui = '1223' where source_id = '14808'
update c_Drug_Generic_Related set generic_rxcui = '1223' where source_id = '3090'
update c_Drug_Generic_Related set generic_rxcui = '1223' where source_id = '5956'
update c_Drug_Generic_Related set generic_rxcui = '1223' where source_id = '6881'
update c_Drug_Generic_Related set generic_rxcui = '2670' where source_id = '6920'
update c_Drug_Generic_Related set generic_rxcui = '4337' where source_id = '14380'
update c_Drug_Generic_Related set generic_rxcui = '4337' where source_id = '2174'
update c_Drug_Generic_Related set generic_rxcui = '52175' where source_id = '10089'
update c_Drug_Generic_Related set generic_rxcui = '52175' where source_id = '1074'
update c_Drug_Generic_Related set generic_rxcui = '52175' where source_id = '9602'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '11429'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '11430'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '13983'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '13984'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '15492'
update c_Drug_Generic_Related set generic_rxcui = '7052' where source_id = '15494'
update c_Drug_Generic_Related set generic_rxcui = '7242' where source_id = '10671'
update c_Drug_Generic_Related set generic_rxcui = '75917' where source_id = '10227'
update c_Drug_Generic_Related set generic_rxcui = '17767' where source_id = '7939'
update c_Drug_Generic_Related set generic_rxcui = '11289' where source_id = '2960'
update c_Drug_Generic_Related set generic_rxcui = '39993' where source_id = '5927'

update c_Drug_Generic_Related set generic_rxcui = '614534' where source_id = '3123'
update c_Drug_Generic_Related set generic_rxcui = '614534' where source_id = '6043'
update c_Drug_Generic_Related set generic_rxcui = '284620' where source_id = '9982'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '11195'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '2966'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '3002'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '3213'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '3214'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '3507'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '4032'
update c_Drug_Generic_Related set generic_rxcui = '281' where source_id = '6315'
update c_Drug_Generic_Related set generic_rxcui = '1006911' where source_id = '1472'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI8974' where source_id = '1312'
update c_Drug_Generic_Related set generic_rxcui = '4986' where source_id = '10480'
update c_Drug_Generic_Related set generic_rxcui = '214451' where source_id = '4069'
update c_Drug_Generic_Related set generic_rxcui = '1546887' where source_id = '12082'
update c_Drug_Generic_Related set generic_rxcui = '214617' where source_id = '12494'
update c_Drug_Generic_Related set generic_rxcui = '214617' where source_id = '14001'
update c_Drug_Generic_Related set generic_rxcui = '214617' where source_id = '5336'
update c_Drug_Generic_Related set generic_rxcui = '214617' where source_id = '5426'
update c_Drug_Generic_Related set generic_rxcui = '214617' where source_id = '5428'
update c_Drug_Generic_Related set generic_rxcui = '214558' where source_id = '1037'
update c_Drug_Generic_Related set generic_rxcui = '214618' where source_id = '10376'
update c_Drug_Generic_Related set generic_rxcui = '214618' where source_id = '7848'
update c_Drug_Generic_Related set generic_rxcui = '214619' where source_id = '10088'
update c_Drug_Generic_Related set generic_rxcui = '214619' where source_id = '4928'
update c_Drug_Generic_Related set generic_rxcui = '216525' where source_id = '1614'
update c_Drug_Generic_Related set generic_rxcui = '216525' where source_id = '1622'
update c_Drug_Generic_Related set generic_rxcui = '253182' where source_id = '10907'
update c_Drug_Generic_Related set generic_rxcui = '7514' where source_id = '1188'
update c_Drug_Generic_Related set generic_rxcui = '7514' where source_id = '1281'
update c_Drug_Generic_Related set generic_rxcui = '1008801' where source_id = '13149'
update c_Drug_Generic_Related set generic_rxcui = '1008801' where source_id = '13150'
update c_Drug_Generic_Related set generic_rxcui = '817496' where source_id = '10827'
update c_Drug_Generic_Related set generic_rxcui = '817496' where source_id = '10828'
update c_Drug_Generic_Related set generic_rxcui = '1033889' where source_id = '17176'
update c_Drug_Generic_Related set generic_rxcui = '1033889' where source_id = '17177'
update c_Drug_Generic_Related set generic_rxcui = '607999' where source_id = '2680'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI2949' where source_id = '6430'
update c_Drug_Generic_Related set generic_rxcui = '9384' where source_id = '11291'
update c_Drug_Generic_Related set generic_rxcui = '9384' where source_id = '11292'
update c_Drug_Generic_Related set generic_rxcui = '1043562' where source_id = '7696'
update c_Drug_Generic_Related set generic_rxcui = '729717' where source_id = '11139'
update c_Drug_Generic_Related set generic_rxcui = '729717' where source_id = '3360'
update c_Drug_Generic_Related set generic_rxcui = '729717' where source_id = '3361'
update c_Drug_Generic_Related set generic_rxcui = '729717' where source_id = '9539'
update c_Drug_Generic_Related set generic_rxcui = '108190' where source_id = '3933'
update c_Drug_Generic_Related set generic_rxcui = '108190' where source_id = '5282A'
update c_Drug_Generic_Related set generic_rxcui = '108190' where source_id = '5282B'
update c_Drug_Generic_Related set generic_rxcui = '203218' where source_id = '1093'
update c_Drug_Generic_Related set generic_rxcui = '203218' where source_id = '2253'
update c_Drug_Generic_Related set generic_rxcui = '203218' where source_id = '3390'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '2352'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '2830'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '3594'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '3987'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '4013'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '5022'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '5024'
update c_Drug_Generic_Related set generic_rxcui = '10831' where source_id = '5025'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '3777'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '3846'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '3847'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '3889'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '10266'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '10270'
update c_Drug_Generic_Related set generic_rxcui = '901212' where source_id = '2646'
update c_Drug_Generic_Related set generic_rxcui = '284636' where source_id = '1154'
update c_Drug_Generic_Related set generic_rxcui = '284636' where source_id = '1175'
update c_Drug_Generic_Related set generic_rxcui = '284636' where source_id = '6211'
update c_Drug_Generic_Related set generic_rxcui = '284636' where source_id = '6216'
update c_Drug_Generic_Related set generic_rxcui = '1008789' where source_id = '12332'
update c_Drug_Generic_Related set generic_rxcui = '1008789' where source_id = '15658'
update c_Drug_Generic_Related set generic_rxcui = '883815' where source_id = '1670'
update c_Drug_Generic_Related set generic_rxcui = '883815' where source_id = '1679'
update c_Drug_Generic_Related set generic_rxcui = '883815' where source_id = '5809'
update c_Drug_Generic_Related set generic_rxcui = '73645' where source_id = '4623'
update c_Drug_Generic_Related set generic_rxcui = '729455' where source_id = '11136'
update c_Drug_Generic_Related set generic_rxcui = '729455' where source_id = '11137'
update c_Drug_Generic_Related set generic_rxcui = '214626' where source_id = '2804'
update c_Drug_Generic_Related set generic_rxcui = '214626' where source_id = '2814'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI5440' where source_id = '5442'
update c_Drug_Generic_Related set generic_rxcui = '388499' where source_id = '4945'
update c_Drug_Generic_Related set generic_rxcui = '644529' where source_id = '5392'
update c_Drug_Generic_Related set generic_rxcui = '392475' where source_id = '5858'

/*
-- List of related names
SELECT distinct r.[active_ingredients], g.generic_name, r.generic_rxcui
FROM c_Drug_Generic_Related r
LEFT JOIN c_Drug_Generic g
ON g.generic_rxcui = r.generic_rxcui
order by r.[active_ingredients], g.generic_name
*/

-- from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
update c_Drug_Generic_Related SET generic_rxcui = '7417' WHERE generic_rxcui = 'KEGI3979'
update c_Drug_Generic_Related SET generic_rxcui = '16689' WHERE generic_rxcui = 'KEGI1426'
update c_Drug_Generic_Related SET generic_rxcui = '438399' WHERE generic_rxcui = 'KEGI14266'
update c_Drug_Generic_Related SET generic_rxcui = '1904' WHERE generic_rxcui = 'KEGI7273'
update c_Drug_Generic_Related SET generic_rxcui = '2023' WHERE generic_rxcui = 'KEGI5514'
update c_Drug_Generic_Related SET generic_rxcui = '2239' WHERE generic_rxcui = 'KEGI5399'
update c_Drug_Generic_Related SET generic_rxcui = '2549' WHERE generic_rxcui = 'KEGI7888'
update c_Drug_Generic_Related SET generic_rxcui = '262272' WHERE generic_rxcui = 'KEGI2815'
update c_Drug_Generic_Related SET generic_rxcui = '2625' WHERE generic_rxcui = 'KEGI866'
update c_Drug_Generic_Related SET generic_rxcui = '237162' WHERE generic_rxcui = 'KEGI7957'
update c_Drug_Generic_Related SET generic_rxcui = '233386' WHERE generic_rxcui = 'KEGI467'
update c_Drug_Generic_Related SET generic_rxcui = '23203' WHERE generic_rxcui = 'KEGI11145'
update c_Drug_Generic_Related SET generic_rxcui = '23796' WHERE generic_rxcui = 'KEGI12622'
update c_Drug_Generic_Related SET generic_rxcui = '4112' WHERE generic_rxcui = 'KEGI8283'
update c_Drug_Generic_Related SET generic_rxcui = '24608' WHERE generic_rxcui = 'KEGI684'
update c_Drug_Generic_Related SET generic_rxcui = '307296' WHERE generic_rxcui = 'KEGI10587'
update c_Drug_Generic_Related SET generic_rxcui = '644529' WHERE generic_rxcui = 'KEGI5392'
update c_Drug_Generic_Related SET generic_rxcui = '4816' WHERE generic_rxcui = 'KEGI3475'
update c_Drug_Generic_Related SET generic_rxcui = '25793' WHERE generic_rxcui = 'KEGI590'
update c_Drug_Generic_Related SET generic_rxcui = '106964' WHERE generic_rxcui = 'KEGI7847'
update c_Drug_Generic_Related SET generic_rxcui = '1851' WHERE generic_rxcui = 'KEGI424'
update c_Drug_Generic_Related SET generic_rxcui = '687386' WHERE generic_rxcui = 'KEGI1500'
update c_Drug_Generic_Related SET generic_rxcui = '20890' WHERE generic_rxcui = 'KEGI143'
update c_Drug_Generic_Related SET generic_rxcui = '6693' WHERE generic_rxcui = 'KEGI2974'
update c_Drug_Generic_Related SET generic_rxcui = '7240' WHERE generic_rxcui = 'KEGI11211'
update c_Drug_Generic_Related SET generic_rxcui = '392475' WHERE generic_rxcui = 'KEGI5858'
update c_Drug_Generic_Related SET generic_rxcui = '388499' WHERE generic_rxcui = 'KEGI4945'
update c_Drug_Generic_Related SET generic_rxcui = '8351' WHERE generic_rxcui = 'KEGI4368'
update c_Drug_Generic_Related SET generic_rxcui = '435' WHERE generic_rxcui = 'KEGI4584'
update c_Drug_Generic_Related SET generic_rxcui = '9794' WHERE generic_rxcui = 'KEGI6979'
UPDATE c_Drug_Generic_Related SET generic_rxcui = '203218' where generic_rxcui IN ('KEGI11997','KEGI1093')
update c_Drug_Generic_Related SET generic_rxcui = '38085' WHERE generic_rxcui = 'KEGI11651'
update c_Drug_Generic_Related SET generic_rxcui = '11065' WHERE generic_rxcui = 'KEGI7238'
update c_Drug_Generic_Related SET generic_rxcui = '40001' WHERE generic_rxcui = 'KEGI5900'

UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11610' WHERE source_id = '11610' -- codeine / paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI496' WHERE source_id = '496' -- chlorpheniramine / paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11122' WHERE source_id = '11122' -- chlorpheniramine / paracetamol / pseudoephedrine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11050' WHERE source_id = '11050' -- caffeine / chlorpheniramine / paracetamol / phenylephrine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI10644' WHERE source_id = '10644' -- paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1493' WHERE source_id = '1493' -- caffeine / paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI9594' WHERE source_id = '9594' -- caffeine / paracetamol / phenylephrine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI15190' WHERE source_id = '15190' -- dextromethorphan / doxylamine / paracetamol / phenylephrine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI215' WHERE source_id = '215' -- paracetamol / phenylephrine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5235' WHERE source_id = '5235' -- paracetamol / traMADol
update c_Drug_Generic_Related set generic_rxcui = 'KEGI5235' where source_id = '10825'
update c_Drug_Generic_Related set generic_rxcui = 'KEGI5235' where source_id = '14909'

-- just to make sure
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI12488' WHERE generic_rxcui = '466584'	 -- aspirin / paracetamol / caffeine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI10644' WHERE generic_rxcui = '161'	 -- paracetamol
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI1493' WHERE generic_rxcui = '108038'	 -- paracetamol / caffeine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI496' WHERE generic_rxcui = '214179'	 -- paracetamol / chlorpheniramine maleate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11050' WHERE generic_rxcui = '819910'	 -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11122' WHERE generic_rxcui = '689765'	 -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCl
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI11610' WHERE generic_rxcui = '817579'	 -- paracetamol / codeine phosphate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI15190' WHERE generic_rxcui = '1008701'	 -- paracetamol / dextromethorphan HBr / phenylephrine HCL / doxylamine succinate
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI215' WHERE generic_rxcui = '214186'	 -- paracetamol / phenylephrine HCL
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI9594' WHERE generic_rxcui = '817911'	 -- paracetamol / phenylephrine HCL / caffeine
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5235' WHERE generic_rxcui = '352362'	 -- traMADol HCL / paracetamol

UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2421' WHERE generic_rxcui = '214199'
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2307' WHERE generic_rxcui = '435'
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5385' WHERE source_id = '11831'
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI2073' WHERE generic_rxcui = '3361'
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI5883' WHERE generic_rxcui = '4815'
UPDATE c_Drug_Generic_Related SET generic_rxcui = 'KEGI15339' WHERE generic_rxcui = '10811'


-- Populate valid_in column first cut
UPDATE g
SET valid_in = CASE 
	WHEN generic_rxcui LIKE 'KEGI%' THEN 'ke;'  
	ELSE 'us;'
	END
FROM c_Drug_Generic g
-- (3978 row(s) affected)

UPDATE g
SET valid_in = valid_in + 'ke;'
-- select distinct valid_in
FROM c_Drug_Generic g
JOIN c_Drug_Generic_Related r ON r.generic_rxcui = g.generic_rxcui
WHERE valid_in NOT LIKE '%ke;%'
-- (480 row(s) affected)

-- Change c_Drug_Formulation valid_in to us; for those that don't appear in source tables
UPDATE f
SET valid_in = 'us;' -- select *
FROM c_Drug_Formulation f
WHERE valid_in LIKE '%ke;%'
AND form_rxcui NOT LIKE 'KE%'
AND NOT EXISTS (SELECT 1 FROM c_Drug_Brand_Related br
	WHERE br.brand_name_rxcui = f.ingr_rxcui)
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic_Related gr
	WHERE gr.generic_rxcui = f.ingr_rxcui)
AND NOT EXISTS (SELECT 1 FROM Kenya_Drugs k
	WHERE k.SCD_PSN_Version = form_descr)
AND NOT EXISTS (SELECT 1 FROM Kenya_Drugs k
	WHERE substring(k.Corresponding_RXCUI,5,20) = form_rxcui)
and valid_in != 'us;'
-- (15356 row(s) affected)

-- Correct for previous updates to generic_rxcui
UPDATE b
SET generic_rxcui = gr.generic_rxcui
-- SELECT * 
FROM c_Drug_Brand b
JOIN c_Drug_Generic_Related gr
	ON gr.source_id = substring(b.generic_rxcui,5,20)
WHERE b.generic_rxcui LIKE 'KEGI%'
AND gr.generic_rxcui != b.generic_rxcui
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g 
	WHERE g.generic_rxcui = b.generic_rxcui)
-- (199 row(s) affected)

SELECT * 
FROM c_Drug_Generic_Related gr
WHERE gr.generic_rxcui IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM c_Drug_Generic g 
	WHERE g.generic_rxcui = gr.generic_rxcui)

