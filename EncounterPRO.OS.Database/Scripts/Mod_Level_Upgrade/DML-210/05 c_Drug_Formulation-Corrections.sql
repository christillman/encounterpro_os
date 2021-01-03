
UPDATE f
SET ingr_tty = 'MIN' 
-- select *
FROM c_Drug_Formulation f
WHERE ingr_tty IS NULL
AND form_descr like '% / %'

-- 11_16_2020 KenyaRetentionDrugsUpdate.xlsx
UPDATE c_Drug_Formulation 
SET form_descr = 'Ventolin Rotacaps 200 MCG Inhalation Powder, Hard Capsule'
WHERE form_descr = 'Ventolin Rotacaps Hard Capsule'
UPDATE c_Drug_Formulation 
SET form_descr = 'Ventolin Rotacaps 200 MCG Inhalation Powder, Hard Capsules, 128 Capsules'
WHERE form_descr = 'Ventolin Rotacaps 128 Capsules'
UPDATE c_Drug_Formulation 
SET form_descr = 'Ventolin Rotacaps 200 MCG Inhalation Powder, Hard Capsules, 100 Capsules'
WHERE form_descr = 'Ventolin Rotacaps 100 Capsules'
UPDATE c_Drug_Formulation 
SET form_descr = 'Ampiclox 90 MG in 0.6 ML Neonatal Drops'
WHERE form_descr = 'Ampiclox 90 MG Neonatal Drops'
UPDATE c_Drug_Formulation 
SET form_descr = 'Ampiclox 250 MG in 5 ML Powder for Oral Solution'
WHERE form_descr = 'Ampiclox 250 MG Powder for Oral Solution'



-- Corrections needed where brand formulations were pointed to generic ingredients
-- 17-alpha-Hydroxyprogesterone, HYDROXYprogesterone caproate
UPDATE c_Drug_Formulation SET ingr_rxcui = '5542' WHERE form_rxcui = '1087964'
UPDATE c_Drug_Formulation SET ingr_rxcui = '5542' WHERE form_rxcui = '1796690'
UPDATE c_Drug_Formulation SET ingr_rxcui = '5542' WHERE form_rxcui = '2000011'
-- mefenamic acid, Mefenamate
UPDATE c_Drug_Formulation SET form_rxcui = '829613', ingr_rxcui = '257844', valid_in = 'us;ke;' WHERE form_rxcui = 'KEG2974'
UPDATE c_Drug_Formulation SET ingr_rxcui = '257844' WHERE form_rxcui = '829500'
-- Multitrace-5 
UPDATE c_Drug_Formulation SET ingr_rxcui = '218486' WHERE form_rxcui = '1293739'
UPDATE c_Drug_Formulation SET ingr_rxcui = '218486' WHERE form_rxcui = '262197'
-- LiqSorb
UPDATE c_Drug_Formulation SET ingr_rxcui = '727279' WHERE form_rxcui = '1297770'
UPDATE c_Drug_Formulation SET ingr_rxcui = '727279' WHERE form_rxcui = '1297990'
-- Multigen
UPDATE c_Drug_Formulation SET ingr_rxcui = '802648' WHERE form_rxcui = '802748'
UPDATE c_Drug_Formulation SET ingr_rxcui = '802647' WHERE form_rxcui = '802762'
-- Dialyvite
UPDATE c_Drug_Formulation SET ingr_rxcui = '404993' WHERE form_rxcui = '1114342'
UPDATE c_Drug_Formulation SET ingr_rxcui = '404993' WHERE form_rxcui = '826653'
UPDATE c_Drug_Formulation SET ingr_rxcui = '404991' WHERE form_rxcui = '826860'
UPDATE c_Drug_Formulation SET ingr_rxcui = '826624' WHERE form_rxcui = '826865'
-- Enfamil
UPDATE c_Drug_Formulation SET ingr_rxcui = '1086383' WHERE form_rxcui = '1086386'
-- Poly-Vi-Sol
UPDATE c_Drug_Formulation SET ingr_rxcui = '219298' WHERE form_rxcui = '876861'
UPDATE c_Drug_Formulation SET ingr_rxcui = '219301' WHERE form_rxcui = '876866'
-- Eldertonic
UPDATE c_Drug_Formulation SET ingr_rxcui = '92573' WHERE form_rxcui = '1111752'
-- Ellis Tonic
UPDATE c_Drug_Formulation SET ingr_rxcui = '877478' WHERE form_rxcui = '1111750'
-- Somnicin
UPDATE c_Drug_Formulation SET ingr_rxcui = '1293415' WHERE form_rxcui = '1293420'
-- ReliOn Glucose
UPDATE c_Drug_Formulation SET ingr_rxcui = '1423388' WHERE form_rxcui = '1423393'
-- Hematogen
UPDATE c_Drug_Formulation SET ingr_rxcui = '1372721' WHERE form_rxcui = '999749'
UPDATE c_Drug_Formulation SET ingr_rxcui = '1372721' WHERE form_rxcui = '999783'
-- Hemocyte Plus
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087396' WHERE form_rxcui = '1087399'
-- BiferaRx
UPDATE c_Drug_Formulation SET ingr_rxcui = '978677' WHERE form_rxcui = '978680'
-- Integra F
UPDATE c_Drug_Formulation SET ingr_rxcui = '999736' WHERE form_rxcui = '999826'
-- Ferocon
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087205' WHERE form_rxcui = '1087208'
-- Ferrex 150 Forte Plus
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087246' WHERE form_rxcui = '1087249'
-- Folgard OS
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087282' WHERE form_rxcui = '1087285'
-- Folivane-F
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087299' WHERE form_rxcui = '1087302'
-- Liq-10
UPDATE c_Drug_Formulation SET ingr_rxcui = '1088927' WHERE form_rxcui = '1088930'
-- Q-Up
UPDATE c_Drug_Formulation SET ingr_rxcui = '1090912' WHERE form_rxcui = '1090915'
-- Nephrocaps QT
UPDATE c_Drug_Formulation SET ingr_rxcui = '1095605' WHERE form_rxcui = '1095608'
-- MVC-Fluoride
UPDATE c_Drug_Formulation SET ingr_rxcui = '881173' WHERE form_rxcui = '1428828'
-- Calcionate
UPDATE c_Drug_Formulation SET ingr_rxcui = '215824' WHERE form_rxcui = '755681'
-- Niferex-150
UPDATE c_Drug_Formulation SET ingr_rxcui = '68728' WHERE form_rxcui = '996032'
-- Cetrimide(s)
UPDATE c_Drug_Formulation SET ingr_rxcui = '2284' WHERE form_rxcui = '199534'
-- Icar-C Plus
UPDATE c_Drug_Formulation SET ingr_rxcui = '1087415' WHERE form_rxcui = '1087418'
-- Multitrace-4
UPDATE c_Drug_Formulation SET ingr_rxcui = '218482' WHERE form_rxcui = '803062'
UPDATE c_Drug_Formulation SET ingr_rxcui = '218482' WHERE form_rxcui = '803239'
-- Maalox Plus
UPDATE c_Drug_Formulation SET ingr_rxcui = '152000' WHERE form_rxcui = '211641'
-- Phillips Milk of Magnesia
UPDATE c_Drug_Formulation SET ingr_rxcui = '219233' WHERE form_rxcui = '845652'
-- Nicomide
UPDATE c_Drug_Formulation SET ingr_rxcui = '352801' WHERE form_rxcui = '1246066'
-- BioGaia
UPDATE c_Drug_Formulation SET ingr_rxcui = '1247273' WHERE form_rxcui = '1247286'

-- Correct non-PSN notation for injections, where volume is at the front
UPDATE c_Drug_Formulation
SET form_descr = substring(form_descr, 8, len(form_descr) - 17) + ' in ' + left(form_descr,7) + 'Injection'
where left(form_descr,7) like '% ml '
-- (2 row(s) affected)

UPDATE c_Drug_Formulation
SET form_descr = substring(form_descr, 7, len(form_descr) - 16) + ' in ' + left(form_descr,6) + 'Injection'
where left(form_descr,6) like '% ml '
-- (2 row(s) affected)

-- pick up referenced values from RXCONSO_FULL
DELETE FROM c_Drug_Formulation
WHERE form_rxcui in (
'1549372',
'1000978',
'411846',
'1088455',
'1236182',
'198229',
'251135',
'836466',
'849329',
'854872',
'857705',
'992898',
'997550'
)

INSERT INTO c_Drug_Formulation VALUES ('1000978','SCD_PSN','oxymetazoline HCl 0.025 % Nasal Solution','7812','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('1088455','SCD_PSN','alfuzosin HCl 2.5 MG Oral Tablet','17300','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('1236182','SCD_PSN','dihydrocodeine tartrate 30 MG Oral Tablet','23088','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('1549372','SCD_PSN','xylometazoline HCl 0.1 % Nasal Solution','39841','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('198229','SCD_PSN','sulfadoxine 500 MG / pyrimethamine 25 MG Oral Tablet','203218','MIN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('251135','SCD','Quinine 300 MG/ML Injectable Solution','9071','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('411846','SCD','24 HR Diclofenac Sodium 100 MG Extended Release Oral Capsule','3355','IN','ke;')
INSERT INTO c_Drug_Formulation VALUES ('836466','SCD_PSN','traMADol HCl 50 MG Oral Capsule','10689','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('849329','SCD','tramadol hydrochloride 50 MG/ML Injectable Solution','10689','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('854872','SCD_PSN','RABEprazole sodium 10 MG Delayed Release Oral Tablet','114979','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('857705','SCD','Diclofenac Sodium 25 MG/ML Injectable Solution','3355','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('992898','SCD','Promethazine Hydrochloride 1 MG/ML Oral Solution','8745','IN','us;ke;')
INSERT INTO c_Drug_Formulation VALUES ('997550','SCD_PSN','fexofenadine HCl 120 MG Oral Tablet','87636','IN','us;ke;')

-- amLODIPine mesilate
DELETE FROM c_Drug_Formulation WHERE form_rxcui in ('KEG3060','KEG3092')
INSERT INTO c_Drug_Formulation VALUES ('KEG3060','SCD_PSN_KE','amLODIPine mesilate equivalent to amLODIPine 10 MG Oral Tablet','17767','IN_KE','ke;')
INSERT INTO c_Drug_Formulation VALUES ('KEG3092','SCD_PSN_KE','amLODIPine mesilate equivalent to amLODIPine 5 MG Oral Tablet','17767','IN_KE','ke;')


-- Ingredient order switched on these
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI281', ingr_tty = 'IN_KE' WHERE ingr_rxcui is null and form_rxcui = 'KEG1217'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4232', ingr_tty = 'IN_KE' WHERE ingr_rxcui is null and form_rxcui = 'KEG1614'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4232', ingr_tty = 'IN_KE' WHERE ingr_rxcui is null and form_rxcui = 'KEG1622'

UPDATE c_Drug_Formulation SET form_rxcui = '2179635' WHERE form_rxcui = 'KEG7890'
UPDATE c_Drug_Formulation SET ingr_rxcui = '352362' WHERE form_rxcui = 'KEG5235'
UPDATE c_Drug_Formulation SET ingr_rxcui = '2284' WHERE form_rxcui = '199534'
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEBI16866' WHERE ingr_rxcui = 'KEBI16615'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1021' WHERE form_rxcui = 'KEG1024' -- bismuth subgallate 59 MG / bismuth oxide 24 MG / zinc oxide 296 MG / balsam peru 49 MG Rectal Suppository
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10776' WHERE form_rxcui = 'KEG10780' -- nebivolol 5 MG / hydroCHLOROthiazide 25 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832' WHERE form_rxcui = 'KEG11124' -- paracetamol 120 MG / chlorpheniramine maleate 1 MG / pseudoephedrine HCl 10 MG in 5 ML Oral Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1136' WHERE form_rxcui = 'KEG1152' -- prednisoLONE hexanoate 1.5 MG / cinchocaine hydrochloride 5 MG per 1 GM Rectal Ointment
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11727' WHERE form_rxcui = 'KEG11743' -- perindopril arginine 5 MG / indapamide 1.25 MG / amLODIPine 5 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11727' WHERE form_rxcui = 'KEG11753' -- perindopril arginine 10 MG / indapamide 2.5 MG / amLODIPine 10 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI11727' WHERE form_rxcui = 'KEG11755' -- perindopril arginine 5 MG / indapamide 1.25 MG / amLODIPine 10 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI12068' WHERE form_rxcui = 'KEG12069' -- indapamide 1.5 MG / amLODIPine 5 MG Modified Release Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = '1008065' WHERE form_rxcui = 'KEG12133' -- ferrous ascorbate (equivalent to elemental iron 5 MG) / folic acid 0.5 MG Oral Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI281' WHERE form_rxcui = 'KEG1217' -- isophane (NPH) insulin, human 70 UNITS/ML / soluble insulin, human 30 UNITS/ML Suspension for Injection in 3 ML Cartridge
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1210' WHERE form_rxcui = 'KEG1253' -- thiamine HCL (vitamin B1) 100 MG / pyridoxine HCL (vitamin B6) 100 MG / cyanocobalamin (vitamin B12) 1 MG in 3 ML Injection
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8974' WHERE form_rxcui = 'KEG1312' -- carbonyl iron (equivalent to elemental Iron 100 MG) / folic acid 1.5 MG / vitamin B12 15 MCG / vitamin C 75 MG / zinc sulfate 61.8 MG Oral Capsule
UPDATE c_Drug_Formulation SET ingr_rxcui = '1007835' WHERE form_rxcui = 'KEG147' -- calcium citrate (equivalent to elemental calcium) 100 MG / cholecalciferol 200 IU in 5 ML Oral Suspension
UPDATE c_Drug_Formulation SET ingr_rxcui = '216525' WHERE form_rxcui = 'KEG1614' -- neomycin sulphate 3500 UNITS/ML / polymixin B sulphate 6000 UNITS/ML / dexamethasone 0.1 % Ophthalmic Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = '216525' WHERE form_rxcui = 'KEG1622' -- neomycin sulphate 3500 UNITS/MG / polymixin B sulphate 6000 UNITS/MG / dexamethasone 0.1 % Ophthalmic Ointment
UPDATE c_Drug_Formulation SET ingr_rxcui = '10831' WHERE form_rxcui = 'KEG3594' -- sulphamethoxazole 200 MG / trimethoprim 40 MG Dispersible Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832' WHERE form_rxcui = 'KEG3861' -- paracetamol 120 MG / chlorpheniramine maleate 1 MG / pseudoephedrine HCL 15 MG in 5 ML Oral Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = '10831' WHERE form_rxcui = 'KEG4013' -- sulphamethoxazole 100 MG / trimethoprim 20 MG Dispersible Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4094A' WHERE form_rxcui = 'KEG4094B' -- betamethasone sodium phosphate 0.1 % / neomycin 0.5 % OTIC Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4094A' WHERE form_rxcui = 'KEG4094C' -- betamethasone sodium phosphate 0.1 % / neomycin 0.5 % Nasal Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI4094A' WHERE form_rxcui = 'KEG4285' -- betamethasone sodium phosphate 0.1 % / neomycin 0.5 % Ophthalmic Ointment
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI3832' WHERE form_rxcui = 'KEG588' -- paracetamol 120 MG / chlorpheniramine maleate 2 MG / pseudoephedrine HCL 10 MG in 5 ML Oral Solution
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947' WHERE form_rxcui = 'KEG5950' -- ramipril 5 MG / hydroCHLOROthiazide 12.5 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947' WHERE form_rxcui = 'KEG5952' -- ramipril 10 MG / hydroCHLOROthiazide 25 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = '614534' WHERE form_rxcui = 'KEG6043' -- abacavir sulfate 60 MG / lamiVUDine 30 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = '1008065' WHERE form_rxcui = 'KEG7259' -- ferrous glycine sulphate (equivalent to ferrous iron) 100 MG / folic acid 0.5 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5947' WHERE form_rxcui = 'KEG7308' -- ramipril 10 MG / hydroCHLOROthiazide 12.5 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8199' WHERE form_rxcui = 'KEG8200' -- etophylline 231 MG / theophylline anhydrous 69 MG Sustained Release Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7742' WHERE form_rxcui = 'KEG9006' -- irbesartan 150 MG / amLODIPine besilate 10 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7742' WHERE form_rxcui = 'KEG9008' -- irbesartan 300 MG / amLODIPine besilate 5 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7742' WHERE form_rxcui = 'KEG9009' -- irbesartan 300 MG / amLODIPine besilate 10 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = '729717' WHERE form_rxcui = 'KEG9535' -- SITagliptin 50 MG / metFORMIN HCL 850 MG Oral Tablet

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI1616' WHERE form_rxcui = 'KEG1616' -- beclomethasone / miconazole / neomycin
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI10723' WHERE form_rxcui = 'KEG10723' -- metroNIDAZOLE 10 % / clotrimazole 2 % Vaginal Ointment
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI2484' WHERE form_rxcui = 'KEG2484' -- lamiVUDine 150 MG / zidovudine 300 MG / efavirenz 600 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI5249' WHERE form_rxcui = 'KEG5249' -- lidocaine 21.33 MG / adrenaline HCl 0.0125 MG in 1 ML Injection
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI7260' WHERE form_rxcui = 'KEG7260' -- ferrous glycine sulphate (equivalent to ferrous iron) 100 MG / folic acid 0.5 MG / zinc sulphate 61.8 MG Oral Tablet
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI8976' WHERE form_rxcui = 'KEG8976' -- iron 50 MG / folic acid 500 MCG / cyanocobalamin 6 MCG / zinc 11 MG in 5 ML Oral Suspension
UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI9944' WHERE form_rxcui = 'KEG9944' -- tinidazole 75 MG / diloxanide furoate 62.5 MG / simethicone 12.5 MG in 5 ML Oral Suspension

-- brand names at end in brackets
UPDATE c_Drug_Formulation 
SET ingr_tty = 'BN' -- select * from c_Drug_Formulation f 
WHERE form_tty = 'SBD'
AND ingr_tty != 'BN' 

-- Remove brand formulations pointing to generic ingredients
DELETE f -- select *
FROM c_Drug_Formulation f
where form_rxcui like 'KEB%'
and form_tty = 'SBD_KE'
AND NOT EXISTS (SELECT 1
	FROM c_Drug_Brand b WHERE b.brand_name_rxcui = f.ingr_rxcui)
AND NOT EXISTS (SELECT 1
	FROM c_Drug_Brand b WHERE b.brand_name_rxcui = REPLACE(f.form_rxcui,'KEB','KEBI'))
-- (18 row(s) affected)
