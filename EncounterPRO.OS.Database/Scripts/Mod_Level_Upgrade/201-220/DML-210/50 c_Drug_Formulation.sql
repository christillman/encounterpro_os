-- Drugs Incorrectly Assigned KEG ingredients.xlsx
UPDATE c_Drug_Formulation -- cholecalciferol (vitamin D3)
SET ingr_rxcui = '2418'
WHERE form_rxcui not like 'KE%' 
AND ingr_rxcui = 'KEGI15207'
UPDATE c_Drug_Formulation -- valproate (266856 divalproex sodium PIN)
SET ingr_rxcui = '40254'
WHERE form_rxcui not like 'KE%' 
AND ingr_rxcui = 'KEGI6442'

-- from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx
DELETE FROM c_Drug_Formulation 
WHERE form_rxcui IN (
'104480',
'105020',
'105341',
'105374',
'152544',
'197456',
'197533',
'199442',
'199523',
'199825',
'199924',
'246141',
'246656',
'246661',
'249520',
'309372',
'388087',
'388519',
'388520',
'388521',
'389137',
'389243',
'415490',
'423420',
'755606',
'829498',
'829613',
'854822',
'858329',
'858335',
'105138',
'106238',
'198229',
'392668',
'393275',
'854993',
'865143',
-- Kenya formulations being replaced with RXNORM
'KEG12612',
'KEG2676',
'KEG673',
'KEG3475',
'KEG590',
'KEG1500',
'KEG5858',
'KEG4584',
'KEG2253',
'KEG3390',
'KEG1093',
'KEG2974',
'KEG424',
'KEG5399',
'KEG1426',
'KEG4327',
'KEG883',
'KEG866',
'KEG2815',
'KEG11211',
'KEG5900',
'KEG7238',
'KEG7239',
'KEG143',
'KEG6468',
'KEG3089',
'KEG1663',
'KEG1891',
'KEG14266',
'KEG7888',
'KEG7957',
'KEG7647',
'KEG11145',
'KEG9104',
'KEG10589',
'KEG4061',
'KEG5392',
'KEG4510',
'KEG5514',
'KEG5701',
'KEG5812',
'KEG8283',
'KEG8311',
'KEG10587',
'KEG6833',
'KEG9102',
'KEG4945',
'KEG4368',
'KEG467',
'KEB2821', -- brand record for generic
'KEG11831' -- orphaned from misspelling chlorzoxazone
)
-- (39 row(s) affected)

-- from Feedback2_Brand_Ingredients_2020_09_27_Dev.xlsx 
-- ... leave  brands as they are (KEB), they don't show up in RXNORM
INSERT INTO c_Drug_Formulation VALUES 
('104480', 'SCD','ethamsylate 500 MG Oral Tablet', '4112', 'IN', 'us;ke;'),
('105020', 'SCD','piracetam 800 MG Oral Tablet', '8351', 'IN', 'us;ke;'),
('105341', 'SCD','Diloxanide 500 MG Oral Tablet', '67182', 'IN', 'us;ke;'),
('105374', 'SCD','gliquidone 30 MG Oral Tablet', '25793', 'IN', 'us;ke;'),
('152544', 'SCD','aceclofenac 100 MG Oral Tablet', '16689', 'IN', 'us;ke;'),
('197456', 'SCD','Cephradine 500 MG Oral Capsule', '2239', 'IN', 'us;ke;'),
('197533', 'SCD','Cloxacillin 250 MG Oral Capsule', '2625', 'IN', 'us;ke;'),
('199442', 'SCD','butylscopolamine bromide 10 MG Oral Tablet', '9601', 'IN', 'us;ke;'),
('199523', 'SCD','zopiclone 7.5 MG Oral Tablet', '40001', 'IN', 'us;ke;'),
('199825', 'SCD','gliclazide 80 MG Oral Tablet', '4816', 'IN', 'us;ke;'),
('199924', 'SCD','Albuterol 0.5 MG/ML Injectable Solution', '435', 'IN', 'us;ke;'),
('246141', 'SCD','Ambroxol 3 MG/ML Oral Solution', '625', 'IN', 'us;ke;'),
('246656', 'SCD','Ambroxol 7.5 MG/ML Oral Solution', '625', 'IN', 'us;ke;'),
('246661', 'SCD','Carbocysteine 50 MG/ML Oral Solution', '2023', 'IN', 'us;ke;'),
('249520', 'SCD','Cinnarizine 25 MG Oral Tablet', '2549', 'IN', 'us;ke;'),
('309372', 'SCD','Cloxacillin 25 MG/ML Oral Suspension', '2625', 'IN', 'us;ke;'),
('388087', 'SCD','lornoxicam 8 MG Oral Tablet', '20890', 'IN', 'us;ke;'),
('388519', 'SCD','etoricoxib 60 MG Oral Tablet', '307296', 'IN', 'us;ke;'),
('388520', 'SCD','etoricoxib 90 MG Oral Tablet', '307296', 'IN', 'us;ke;'),
('388521', 'SCD','etoricoxib 120 MG Oral Tablet', '307296', 'IN', 'us;ke;'),
('389137', 'SCD','Gliclazide 30 MG Extended Release Oral Tablet', '4816', 'IN', 'us;ke;'),
('389243', 'SCD','Dexketoprofen 25 MG Oral Tablet', '237162', 'IN', 'us;ke;'),
('415490', 'SCD','etofenamate 0.1 MG/MG Topical Gel', '24608', 'IN', 'us;ke;'),
('423420', 'SCD','Ambroxol 6 MG/ML Oral Solution', '625', 'IN', 'us;ke;'),
('755606', 'SCD','Carbocysteine 20 MG/ML Oral Solution', '2023', 'IN', 'us;ke;'),
('829498', 'SCD','Mefenamic Acid 10 MG/ML Oral Suspension', '257844', 'IN', 'us;ke;'),
('829613', 'SCD','mefenamic acid 500 MG Oral Tablet', '257844', 'IN', 'us;ke;'),
('854822', 'SCD','Nalidixic Acid 500 MG Oral Tablet', '618425', 'IN', 'us;ke;'),
('858329', 'SCD','Ursodiol 300 MG Oral Tablet', '62427', 'IN', 'us;ke;'),
('858335', 'SCD','Ursodiol 150 MG Oral Tablet', '62427', 'IN', 'us;ke;'),
('105138', 'SCD','Ampicillin 250 MG / Cloxacillin 250 MG Oral Capsule', '106846', 'MIN', 'us;ke;'),
('106238', 'SCD','clotrimazole 1 % / hydrocortisone 1 % Topical Cream', '262272', 'MIN', 'us;ke;'),
('198229', 'SCD','Pyrimethamine 25 MG / Sulfadoxine 500 MG Oral Tablet', '203218', 'MIN', 'us;ke;'),
('392668', 'SCD','ibuprofen 5 % / levomenthol 3 % Topical Gel', '687386', 'MIN', 'us;ke;'),
('393275', 'SCD','Atenolol 50 MG / Nifedipine 20 MG Extended Release Oral Capsule', '392475', 'MIN', 'us;ke;'),
('854993', 'SCD','Indapamide 1.25 MG / Perindopril Erbumine 4 MG Oral Tablet', '388499', 'MIN', 'us;ke;'),
('865143', 'SCD','fluPHENAZine Hydrochloride 0.5 MG / Nortriptyline 10 MG Oral Tablet', '644529', 'MIN', 'us;ke;')
-- (37 row(s) affected)

update c_Drug_Formulation SET ingr_rxcui = '7417' WHERE ingr_rxcui = 'KEGI3979'
update c_Drug_Formulation SET ingr_rxcui = '16689' WHERE ingr_rxcui = 'KEGI1426'
update c_Drug_Formulation SET ingr_rxcui = '438399' WHERE ingr_rxcui = 'KEGI14266'
update c_Drug_Formulation SET ingr_rxcui = '1904' WHERE ingr_rxcui = 'KEGI7273'
update c_Drug_Formulation SET ingr_rxcui = '2023' WHERE ingr_rxcui = 'KEGI5514'
update c_Drug_Formulation SET ingr_rxcui = '2239' WHERE ingr_rxcui = 'KEGI5399'
update c_Drug_Formulation SET ingr_rxcui = '2549' WHERE ingr_rxcui = 'KEGI7888'
update c_Drug_Formulation SET ingr_rxcui = '262272' WHERE ingr_rxcui = 'KEGI2815'
update c_Drug_Formulation SET ingr_rxcui = '2625' WHERE ingr_rxcui = 'KEGI866'
update c_Drug_Formulation SET ingr_rxcui = '237162' WHERE ingr_rxcui = 'KEGI7957'
update c_Drug_Formulation SET ingr_rxcui = '233386' WHERE ingr_rxcui = 'KEGI467'
update c_Drug_Formulation SET ingr_rxcui = '23203' WHERE ingr_rxcui = 'KEGI11145'
update c_Drug_Formulation SET ingr_rxcui = '23796' WHERE ingr_rxcui = 'KEGI12622'
update c_Drug_Formulation SET ingr_rxcui = '4112' WHERE ingr_rxcui = 'KEGI8283'
update c_Drug_Formulation SET ingr_rxcui = '24608' WHERE ingr_rxcui = 'KEGI684'
update c_Drug_Formulation SET ingr_rxcui = '307296' WHERE ingr_rxcui = 'KEGI10587'
update c_Drug_Formulation SET ingr_rxcui = '644529' WHERE ingr_rxcui = 'KEGI5392'
update c_Drug_Formulation SET ingr_rxcui = '4816' WHERE ingr_rxcui = 'KEGI3475'
update c_Drug_Formulation SET ingr_rxcui = '25793' WHERE ingr_rxcui = 'KEGI590'
update c_Drug_Formulation SET ingr_rxcui = '106964' WHERE ingr_rxcui = 'KEGI7847'
update c_Drug_Formulation SET ingr_rxcui = '1851' WHERE ingr_rxcui = 'KEGI424'
update c_Drug_Formulation SET ingr_rxcui = '687386' WHERE ingr_rxcui = 'KEGI1500'
update c_Drug_Formulation SET ingr_rxcui = '20890' WHERE ingr_rxcui = 'KEGI143'
update c_Drug_Formulation SET ingr_rxcui = '6693' WHERE ingr_rxcui = 'KEGI2974'
update c_Drug_Formulation SET ingr_rxcui = '7240' WHERE ingr_rxcui = 'KEGI11211'
update c_Drug_Formulation SET ingr_rxcui = '392475' WHERE ingr_rxcui = 'KEGI5858'
update c_Drug_Formulation SET ingr_rxcui = '388499' WHERE ingr_rxcui = 'KEGI4945'
update c_Drug_Formulation SET ingr_rxcui = '8351' WHERE ingr_rxcui = 'KEGI4368'
update c_Drug_Formulation SET ingr_rxcui = '435' WHERE ingr_rxcui = 'KEGI4584'
update c_Drug_Formulation SET ingr_rxcui = '9794' WHERE ingr_rxcui = 'KEGI6979'
UPDATE c_Drug_Formulation SET ingr_rxcui = '203218' where ingr_rxcui IN ('KEGI11997','KEGI1093')
update c_Drug_Formulation SET ingr_rxcui = '38085' WHERE ingr_rxcui = 'KEGI11651'
update c_Drug_Formulation SET ingr_rxcui = '11065' WHERE ingr_rxcui = 'KEGI7238'
update c_Drug_Formulation SET ingr_rxcui = '40001' WHERE ingr_rxcui = 'KEGI5900'

-- Formulations which are not linked
UPDATE f
SET ingr_rxcui = replace(f.form_rxcui,'KEG','KEGI'),
	ingr_tty = CASE WHEN form_descr like '% / %' THEN 'MIN_KE' ELSE 'IN_KE' END  
-- select g.valid_in, f.form_descr, dbo.fn_ingredients(f.form_descr), g.generic_name
from c_Drug_Formulation f
join c_Drug_Generic g
	on g.generic_rxcui = replace(f.form_rxcui,'KEG','KEGI')
where f.ingr_rxcui is null
and f.form_rxcui like 'KEG%'
-- (259 row(s) affected)

UPDATE f
SET ingr_rxcui = g.generic_rxcui,
	ingr_tty = CASE WHEN form_descr like '% / %' THEN 'MIN_KE' ELSE 'IN_KE' END
-- select ingr_rxcui, g.generic_rxcui, ingr_tty
from c_Drug_Formulation f
JOIN c_Drug_Generic g
	on g.generic_name = dbo.fn_ingredients(f.form_descr)
where ingr_rxcui is null
and f.form_rxcui like 'KEG%'
-- (70 row(s) affected)

UPDATE f
SET ingr_rxcui = g.generic_rxcui,
	ingr_tty = CASE WHEN form_descr like '% / %' THEN 'MIN_KE' ELSE 'IN_KE' END
-- select ingr_rxcui, g.generic_rxcui, ingr_tty
from c_Drug_Formulation f
JOIN Kenya_Drugs k ON k.Retention_No = substring(f.form_rxcui,4,20)
JOIN c_Drug_Generic g
	on g.generic_name = k.Ingredient
where ingr_rxcui is null
and f.form_rxcui like 'KEG%'
-- (14 row(s) affected)

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13360' 
WHERE form_rxcui IN ('KEG16179','KEG14953','KEG3557','KEG3632') -- aceclofenac / paracetamol / chlorzoxazone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1316' WHERE form_rxcui = 'KEG6491' -- adapalene / clindamycin phosphate

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2166' WHERE form_rxcui = 'KEG5740' -- amLODIPine besilate / atenolol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2166' WHERE form_rxcui = 'KEG2170' -- amLODIPine besilate / atenolol

UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG10752' -- amoxicillin / clavulanate potassium
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG13712' -- amoxicillin / clavulanate potassium
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG9591' -- amoxicillin / clavulanate potassium
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG9598' -- amoxicillin / clavulanic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG15791' -- amoxicillin / clavulanic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG1919' -- amoxicillin / clavulanic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = '19711' WHERE form_rxcui = 'KEG1922' -- amoxicillin / clavulanic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3517' WHERE form_rxcui = 'KEG3518' -- amoxicillin / flucloxacillin magnesium
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3517' WHERE form_rxcui = 'KEG4015' -- amoxicillin / flucloxacillin magnesium
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10843' WHERE form_rxcui = 'KEG5376' -- artesunate / amodiaquine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10843' WHERE form_rxcui = 'KEG11742' -- artesunate / amodiaquine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10843' WHERE form_rxcui = 'KEG5419' -- artesunate / amodiaquine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10843' WHERE form_rxcui = 'KEG10850' -- artesunate / amodiaquine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2963' WHERE form_rxcui = 'KEG6388' -- aspirin / paracetamol / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG3192' -- ascorbic acid / folic acid / cyanocobalamin / ferrous fumarate / zinc sulphate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI16702' WHERE form_rxcui = 'KEG16707' -- azilsartan medoxomil / hydroCHLOROthiazide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2259' WHERE form_rxcui = 'KEG261' -- bacitracin zinc / neomycin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1019' WHERE form_rxcui = 'KEG6696' -- betamethasone dipropionate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1019' WHERE form_rxcui = 'KEG6701' -- betamethasone dipropionate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132' WHERE form_rxcui = 'KEG8592' -- budesonide / formoterol fumarate
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132' WHERE form_rxcui = 'KEG2042' -- budesonide / formoterol fumarate
UPDATE c_Drug_Formulation SET ingr_rxcui = '389132' WHERE form_rxcui = 'KEG2044' -- budesonide / formoterol fumarate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3456' WHERE form_rxcui = 'KEG6458' -- bromhexine / guaiFENesin / salbutamol
UPDATE c_Drug_Formulation SET ingr_rxcui = '1007835' WHERE form_rxcui = 'KEG147' -- calcium citrate 
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8974' WHERE form_rxcui = 'KEG1312' -- carbonyl iron / folic acid / vitamin B12 / vitamin C / zinc sulfate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10796' WHERE form_rxcui = 'KEG11149' -- cefixime / clavulanic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11122' WHERE form_rxcui = 'KEG3832' -- chlorpheniramine / paracetamol / pseudoephedrine
UPDATE c_Drug_Formulation SET ingr_rxcui = '274964' WHERE form_rxcui = 'KEG8853' -- ciclesonide / INHAL Metered Dose Inhaler
UPDATE c_Drug_Formulation SET ingr_rxcui = '274964' WHERE form_rxcui = 'KEG8854' -- ciclesonide / INHAL Metered Dose Inhaler
UPDATE c_Drug_Formulation SET ingr_rxcui = '611854' WHERE form_rxcui = 'KEG867' -- clidinium bromide / chlordiazePOXIDE HCl
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10561' WHERE form_rxcui = 'KEG14720' -- clindamycin phosphate / clotrimazole
UPDATE c_Drug_Formulation SET ingr_rxcui = '687144' WHERE form_rxcui = 'KEG6931' -- clindamycin phosphate / tretinoin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3347' WHERE form_rxcui = 'KEG8917' -- clopidogrel / aspirin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI521' WHERE form_rxcui = 'KEG6302' -- clotrimazole / beclomethasone dipropionate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI521' WHERE form_rxcui = 'KEG8100' -- clotrimazole / beclomethasone dipropionate
UPDATE c_Drug_Formulation SET ingr_rxcui = '106928' WHERE form_rxcui = 'KEG1027' -- clotrimazole / betamethasone valerate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11952' WHERE form_rxcui = 'KEG3434' -- clotrimazole / beclomethasone dipropionate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI15625' WHERE form_rxcui = 'KEG5668' -- clotrimazole / betamethasone / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI15625' WHERE form_rxcui = 'KEG9246' -- clotrimazole / betamethasone / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = '605998' WHERE form_rxcui = 'KEG7346' -- codeine phosphate / chlorpheniramine maleate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8159' WHERE form_rxcui = 'KEG8218' -- codeine phosphate / doxylamine succinate / paracetamol / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2499A' WHERE form_rxcui = 'KEG3600' -- dexamethasone sodium phosphate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2499A' WHERE form_rxcui = 'KEG6823A' -- dexamethasone sodium phosphate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2499A' WHERE form_rxcui = 'KEG6823B' -- dexamethasone sodium phosphate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2499A' WHERE form_rxcui = 'KEG2499B' -- dexamethasone sodium phosphate / gentamicin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2129' WHERE form_rxcui = 'KEG7204' -- diclofenac sodium / paracetamol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2129' WHERE form_rxcui = 'KEG452' -- diclofenac sodium / paracetamol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5385' WHERE form_rxcui = 'KEG1949' -- diclofenac sodium / paracetamol / chlorzoxazone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5385' WHERE form_rxcui = 'KEG2473' -- diclofenac sodium / paracetamol / chlorzoxazone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4920' WHERE form_rxcui = 'KEG5630' -- diclofenac sodium / paracetamol / serratiopeptidase
UPDATE c_Drug_Formulation SET ingr_rxcui = '214502' WHERE form_rxcui = 'KEG11847' -- diclofenac sodium / miSOPROStol
UPDATE c_Drug_Formulation SET ingr_rxcui = '214502' WHERE form_rxcui = 'KEG11849' -- diclofenac sodium / miSOPROStol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5385' WHERE form_rxcui = 'KEG5791' -- diclofenac potassium / paracetamol / chlorzoxazone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI158' WHERE form_rxcui = 'KEG772' -- dicyclomine HCL / simethicone
UPDATE c_Drug_Formulation SET ingr_rxcui = '1430990' WHERE form_rxcui = 'KEG12698' -- donepezil HCL / memantine HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = '1001472' WHERE form_rxcui = 'KEG15203' -- dutasteride / tamsulosin HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = '214536' WHERE form_rxcui = 'KEG5759' -- enalapril maleate / hydroCHLOROthiazide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8199' WHERE form_rxcui = 'KEG8269' -- etophylline / theophylline hydrate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8209' WHERE form_rxcui = 'KEG9384' -- fusidic acid / betamethasone valerate
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635' WHERE form_rxcui = 'KEG3506' -- fluticasone propionate / salmeterol
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635' WHERE form_rxcui = 'KEG3501' -- fluticasone propionate / salmeterol
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635' WHERE form_rxcui = 'KEG3504' -- fluticasone propionate / salmeterol
UPDATE c_Drug_Formulation SET ingr_rxcui = '284635' WHERE form_rxcui = 'KEG2286' -- fluticasone propionate / salmeterol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3022' WHERE form_rxcui = 'KEG5199' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3022' WHERE form_rxcui = 'KEG6996' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3022' WHERE form_rxcui = 'KEG5176' -- glimepiride / metFORMIN HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = '106964' WHERE form_rxcui = 'KEG7846' -- hydrocortisone acetate / lidocaine
UPDATE c_Drug_Formulation SET ingr_rxcui = '106964' WHERE form_rxcui = 'KEG7847' -- hydrocortisone acetate / lidocaine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6503' WHERE form_rxcui = 'KEG4757' -- iron (III) hydroxide polymaltofolic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5438' WHERE form_rxcui = 'KEG8730' -- lamiVUDine / zidovudine / nevirapine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5438' WHERE form_rxcui = 'KEG6047' -- lamiVUDine / zidovudine / nevirapine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5438' WHERE form_rxcui = 'KEG10931' -- lamiVUDine / zidovudine / nevirapine
update c_Drug_Formulation set ingr_rxcui = '6387' WHERE form_rxcui = 'KEG15803' -- lidocaine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI227' WHERE form_rxcui = 'KEG7644' -- losartan potassium / amLODIPine
update c_Drug_Formulation set ingr_rxcui = 'KEGI5808' WHERE form_rxcui = 'KEG7219' -- mefenamate / tranexamic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1391' WHERE form_rxcui = 'KEG274' -- mefenamic acid / paracetamol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13379' WHERE form_rxcui = 'KEG3051' -- metformin HCL / vildagliptin
update c_Drug_Formulation set ingr_rxcui = 'KEGI13379' WHERE form_rxcui = 'KEG13613' -- metFORMIN / VILDAgliptin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1057' WHERE form_rxcui = 'KEG8659' -- metroNIDAZOLE / diloxanide furoate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1057' WHERE form_rxcui = 'KEG8660' -- metroNIDAZOLE / diloxanide furoate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1057' WHERE form_rxcui = 'KEG8661' -- metroNIDAZOLE / diloxanide furoate
UPDATE c_Drug_Formulation SET ingr_rxcui = '106967' WHERE form_rxcui = 'KEG7858' -- miconazole nitrate / hydrocortisone acetate
UPDATE c_Drug_Formulation SET ingr_rxcui = '216525' WHERE form_rxcui = 'KEG4232' -- neomycin sulphate / polymyxin B sulphate / dexamethasone
UPDATE c_Drug_Formulation SET ingr_rxcui = '352377' WHERE form_rxcui = 'KEG7118' -- norelgestromin / ethinyl estradiol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13269' 
WHERE form_rxcui IN ('KEG14222','KEG7594','KEG5191','KEG7213') -- pantoprazole / domperidone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13269' WHERE form_rxcui = 'KEG13631' -- pantoprazole / domperidone SR
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13269' WHERE form_rxcui = 'KEG5232' -- pantoprazole sodium / domperidone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG3505' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG8193' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG2728' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG881' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12488' WHERE form_rxcui = 'KEG995' -- paracetamol / aspirin / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1493' WHERE form_rxcui = 'KEG6917' -- paracetamol / caffeine anhydrous
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11049' WHERE form_rxcui = 'KEG3201' -- paracetamol / chlorphenamine maleate / phenylephrine HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11049' WHERE form_rxcui = 'KEG146' -- paracetamol / chlorphenamine maleate / phenylephrine HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050' WHERE form_rxcui = 'KEG3748' -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050' WHERE form_rxcui = 'KEG3287' -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine anhydrous
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11050' WHERE form_rxcui = 'KEG11962' -- paracetamol / chlorpheniramine maleate / phenylephrine HCL / caffeine anhydrous
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3785' WHERE form_rxcui = 'KEG3815' -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCl / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3785' WHERE form_rxcui = 'KEG510' -- paracetamol / chlorpheniramine maleate / pseudoephedrine HCl / caffeine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11610' WHERE form_rxcui = 'KEG7304' -- paracetamol / codeine phosphate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11297' WHERE form_rxcui = 'KEG401' -- paracetamol / ibuprofen
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889' WHERE form_rxcui = 'KEG11744' -- perindopril arginine / amLODIPine besilate
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889' WHERE form_rxcui = 'KEG11748' -- perindopril arginine / amLODIPine besilate
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889' WHERE form_rxcui = 'KEG11751' -- perindopril arginine / amLODIPine besilate
UPDATE c_Drug_Formulation SET ingr_rxcui = '1033889' WHERE form_rxcui = 'KEG11752' -- perindopril arginine / amLODIPine besilate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4945' WHERE form_rxcui = 'KEG7387' -- perindopril arginine / indapamide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2949' WHERE form_rxcui = 'KEG6430' -- pregabalin / methylcobalamin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11569' WHERE form_rxcui = 'KEG6255' -- procaine penicillin / benzylpenicillin sodium
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5702' WHERE form_rxcui = 'KEG941' -- promethazine / carbocisteine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10420' WHERE form_rxcui = 'KEG14242' -- RABEprazole sodium / domperidone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10420' WHERE form_rxcui = 'KEG13580' -- RABEprazole sodium / domperidone
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5724' WHERE form_rxcui = 'KEG5823' -- rifampicin / isoniazid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5724' WHERE form_rxcui = 'KEG10655' -- rifampicin / isoniazid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6447' WHERE form_rxcui = 'KEG7040' -- rifampicin / isoniazid / pyrazinamide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6447' WHERE form_rxcui = 'KEG6928' -- rifampicin / isoniazid / pyrazinamide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI6447' WHERE form_rxcui = 'KEG11070' -- rifampicin / isoniazid / pyrazinamide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1081' WHERE form_rxcui = 'KEG1786' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1081' WHERE form_rxcui = 'KEG6926' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1081' WHERE form_rxcui = 'KEG11416' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1081' WHERE form_rxcui = 'KEG5924' -- rifampicin / isoniazid / pyrazinamide / ethambutol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8719' WHERE form_rxcui = 'KEG9499' -- salbutamol sulphate / beclomethasone dipropionate
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2849' WHERE form_rxcui = 'KEG4754' -- silymarin / thiamine / pyridoxine HCl / riboflavin / nicotinamide / calcium pantothenate / cyanocobalamin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1093' WHERE form_rxcui = 'KEG2253' -- sulfadoxine / pyrimethamine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1093' WHERE form_rxcui = 'KEG3390' -- sulfadoxine / pyrimethamine
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1210' WHERE form_rxcui = 'KEG4064' -- thiamine nitrate (vitamin B1) / pyridoxine (vitamin B6) / cyanocobalamin (vitamin B12)
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1210' WHERE form_rxcui = 'KEG2422' -- thiamine nitrate (vitamin B1) / pyridoxine HCl (vitamin B6) / cyanocobalamin (vitamin B12)
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13379' WHERE form_rxcui = 'KEG17278' -- VILDAgliptin / metFORMIN HCL
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI13379' WHERE form_rxcui = 'KEG14512' -- VILDAgliptin / metFORMIN HCL


UPDATE c_Drug_Formulation SET ingr_rxcui = '1347' WHERE form_rxcui = 'KEG1839' -- beclometasone dipropionate
UPDATE c_Drug_Formulation SET ingr_rxcui = '4053' WHERE form_rxcui = 'KEG3803' -- erythromcyn ethylsuccinate
UPDATE c_Drug_Formulation SET ingr_rxcui = '115264' WHERE form_rxcui = 'KEG7075' -- ibandronic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2096' WHERE form_rxcui = 'KEG8645' -- levosalbutamol sulphate
UPDATE c_Drug_Formulation SET ingr_rxcui = '257844' WHERE form_rxcui = 'KEG243' -- mefenamic acid
UPDATE c_Drug_Formulation SET ingr_rxcui = '388499' WHERE form_rxcui = 'KEG7387' -- perindopril arginine / indapamide
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2307' WHERE form_rxcui = 'KEG4558' -- salbutamol
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2307' WHERE form_rxcui = 'KEG4598' -- salbutamol
UPDATE c_Drug_Formulation SET ingr_rxcui = '253182' WHERE form_rxcui = 'KEG282PF' -- soluble insulin, human
UPDATE c_Drug_Formulation SET ingr_rxcui = '253182' WHERE form_rxcui = 'KEG1241' -- soluble insulin, human
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI540A' WHERE form_rxcui = 'KEG547' -- zuclopenthixol decanoate


UPDATE c_Drug_Formulation SET ingr_rxcui = '438399' WHERE form_rxcui = '246141' -- Ambroxol
UPDATE c_Drug_Formulation SET ingr_rxcui = '438399' WHERE form_rxcui = '246656' -- Ambroxol
UPDATE c_Drug_Formulation SET ingr_rxcui = '438399' WHERE form_rxcui = '423420' -- Ambroxol
UPDATE c_Drug_Formulation SET ingr_rxcui = '106846' WHERE form_rxcui = '105138' -- Ampicillin / Cloxacillin
UPDATE c_Drug_Formulation SET ingr_rxcui = '23203' WHERE form_rxcui = '105341' -- Diloxanide
UPDATE c_Drug_Formulation SET ingr_rxcui = '7240' WHERE form_rxcui = '854822' -- Nalidixic Acid

/*

select form_rxcui, dbo.fn_ingredients(f.form_descr) 
from c_Drug_Formulation f
where ingr_rxcui is null

select ingr_rxcui, form_rxcui, dbo.fn_ingredients(f.form_descr)  from c_Drug_Formulation f
where not exists (select 1 from c_Drug_Generic g where g.generic_rxcui = f.ingr_rxcui)
and not exists (select 1 from c_Drug_Brand b where b.brand_name_rxcui = f.ingr_rxcui)
*/
