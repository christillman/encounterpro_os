-- Revising Dosage Forms spread sheet
-- First assign from Revisign Dosage Forms sheet 1, assign first 
-- so higher priority sheets will override (below).
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_dose_unit') AND type in (N'V'))
DROP VIEW vw_dose_unit
GO
CREATE VIEW vw_dose_unit AS
SELECT p.dose_unit, f.form_rxcui, f.form_descr, f.dosage_form
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
-- where f.valid_in NOT IN ('Suppress','TPN Suppress','Retired')
GO

UPDATE vw_dose_unit SET dose_unit = 'TAB' 
WHERE form_descr like '%buccal tablet%'

UPDATE vw_dose_unit SET dose_unit = 'FILM'
WHERE form_descr like '% film'
OR form_descr like '% film, mucoadhesive'
OR form_descr like '%oral strip%' 

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
WHERE form_descr like '%UNT Inhalant Powder Cartridge%'

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%cartridge%' 
AND form_descr like '%MG%' 
AND form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'MCG'
WHERE form_descr like '%cartridge%' 
AND form_descr like '%MCG%' 
AND form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'Cartridge'
WHERE form_descr like '%cartridge%' 
AND dose_unit is null

UPDATE vw_dose_unit SET dose_unit = 'WAFER'
WHERE form_descr like '%oral wafer%'

UPDATE vw_dose_unit SET dose_unit = 'PACKE'
WHERE form_descr like '%granules%'

UPDATE vw_dose_unit SET dose_unit = 'TSP'
WHERE form_descr like '%Granules for Solution%'

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%dental cream%'

UPDATE vw_dose_unit SET dose_unit = 'STRIP'
WHERE form_descr like '%dental film%'

UPDATE vw_dose_unit SET dose_unit = 'DROPEAR'
WHERE  form_descr like '%Otic %' and dosage_form like '%Otic %' 

UPDATE vw_dose_unit SET dose_unit = 'APPLYAREA'
WHERE form_descr like '%Otic lotion%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE dosage_form IN (
	'Oral Solution', 'Oral Suspension','ER Suspension', 'Injectable Foam')

UPDATE vw_dose_unit SET dose_unit = 'ENEMA'
WHERE form_descr like '%enema%' 
AND NOT (form_descr like '%197 ml%' 
  or form_descr like '%118 ml%' 
  or form_descr like '%30 ml%' 
  or form_descr like '%59 ml%' 
  or form_descr like '%60 ml%')

UPDATE vw_dose_unit SET dose_unit = 'BOTTLE'
WHERE form_descr like '%enema%' 
AND (form_descr like '%197 ml%' 
  or form_descr like '%118 ml%' 
  or form_descr like '%30 ml%' 
  or form_descr like '%59 ml%' 
  or form_descr like '%60 ml%')

UPDATE vw_dose_unit SET dose_unit = 'DROP'
WHERE form_descr like '%eyelash topical solution%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
WHERE form_descr like '%follitropin%'

UPDATE vw_dose_unit SET dose_unit = 'CAP'
WHERE form_descr like '%inhalant powder capsule%'

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%inhalant suspension%'

UPDATE vw_dose_unit SET dose_unit = 'DEVI'
WHERE form_descr like '%intrauterine%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%irrigation solution%'

UPDATE vw_dose_unit SET dose_unit = 'APPLICATOR'
WHERE dosage_form IN ('Vaginal Foam', 'Vaginal Oint', 'Vag Gel')

UPDATE vw_dose_unit SET dose_unit = 'DEVI'
WHERE dosage_form IN ('Vaginal Ring')

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr LIKE '% lotion%'
AND form_descr not like '%otic lotion%'

UPDATE vw_dose_unit SET dose_unit = 'SPRAY'
WHERE form_descr like '% spray%' 

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '% spray%' 
AND (form_descr like '%UNT in %' or form_descr like '%rectal spray%')

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%shampoo%' or form_descr like '%conditioner%' or form_descr like '%soap%'

UPDATE vw_dose_unit SET dose_unit = 'MEDICATEDPAD'
WHERE form_descr like '%Pad' 
OR form_descr like '%Swab'

UPDATE vw_dose_unit SET dose_unit = 'PUFF'
WHERE dosage_form = 'Metered Inhaler'

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE dosage_form IN ('Oral Gel', 'Oral Foam', 'Nasal Gel')

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE dosage_form IN ('MucousMemSoln')

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%Periodontal Gel'

UPDATE vw_dose_unit SET dose_unit = 'INHALATION'
WHERE form_descr like '%Nasal Inhalant'

UPDATE vw_dose_unit SET dose_unit = 'NOSEPIECE'
WHERE form_descr like '%Nasal Powder'

UPDATE vw_dose_unit SET dose_unit = 'IMPL'
WHERE form_descr like '%drug implant%'

UPDATE vw_dose_unit SET dose_unit = 'INSERTEYE'
WHERE form_descr like '%ophthalmic drug implant%'

UPDATE vw_dose_unit SET dose_unit = 'APPLYEYE'
WHERE form_descr like '%ophthalmic gel%'
OR form_descr like '%ophthalmic ointment%'

UPDATE vw_dose_unit SET dose_unit = 'DROPEYE'
WHERE form_descr like '%ophthalmic emulsion%'
OR form_descr like '%ophthalmic gel forming solution%'
OR form_descr like '%ophthalmic solution%'
OR form_descr like '%ophthalmic suspension%'

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%oral cream%'

UPDATE vw_dose_unit SET dose_unit = 'DROP'
WHERE form_descr like '%oral drops%'

UPDATE vw_dose_unit SET dose_unit = 'TBL'
WHERE form_descr like '%oral flakes%'

UPDATE vw_dose_unit SET dose_unit = 'LOZG'
WHERE form_descr like '%lozenge%'

UPDATE vw_dose_unit SET dose_unit = 'LOZG'
WHERE form_descr like '%lozenge%'

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%oral ointment%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE dosage_form in ('Oral Suspension','Pwdrr Oral Susp')

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%rectal suspension%'

UPDATE vw_dose_unit SET dose_unit = 'INCH'
WHERE form_descr like '%oral paste%'

UPDATE vw_dose_unit SET dose_unit = 'GRAM'
WHERE form_descr like '%oral powder%'
AND form_descr like '%GM %'

UPDATE vw_dose_unit SET dose_unit = 'PACKE'
WHERE form_descr like '%oral powder%'
AND form_descr not like '%GM %'

UPDATE vw_dose_unit SET dose_unit = 'TSP'
WHERE form_descr like '%oral rinse%'
OR form_descr like '%mouthwash%'

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%Powder for Inhalant Solution%'

UPDATE vw_dose_unit SET dose_unit = 'PACKE'
WHERE form_descr like '%Powder for Nasal Solution%'

UPDATE vw_dose_unit SET dose_unit = 'GRAM'
WHERE form_descr like '%Powder for Oral Solution%'
AND form_descr like '%GM%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%Powder for Oral Solution%'
AND form_descr like '%GM%'
AND form_descr not like '%MG%'

UPDATE vw_dose_unit SET dose_unit = 'SCOOP'
WHERE form_descr like '%Powder for Oral Solution%'
AND form_descr like '%scoop%'

UPDATE vw_dose_unit SET dose_unit = 'MEQ'
WHERE form_descr like '%Powder for Oral Solution%'
AND form_descr like '%MEQ%'

UPDATE vw_dose_unit SET dose_unit = 'APPLICATOR'
WHERE form_descr like '%rectal cream%'
OR form_descr like '%rectal gel%'

UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%rectal foam%'
OR form_descr like '%rectal lotion%'
OR form_descr like '%rectal spray%'

UPDATE vw_dose_unit SET dose_unit = 'ACTUAT'
WHERE form_descr like '%rectal foam%'
AND form_descr like '%actuat%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%rectal solution%'

UPDATE vw_dose_unit SET dose_unit = 'MCG'
WHERE form_descr like '%sublingual powder%'

UPDATE vw_dose_unit SET dose_unit = 'ACTUAT'
WHERE form_descr like '%Topical solution%'
AND form_descr like '%ACTUAT%'

UPDATE vw_dose_unit SET dose_unit = 'DROP'
WHERE form_descr like '%Topical solution%'
AND (form_descr like '%wart%' 
	OR form_descr like '%corn%' 
	OR form_descr like '%callus%')

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%Topical solution%'
AND (form_descr like '%rogaine%' OR form_descr like '%minoxidil%')
 
UPDATE vw_dose_unit SET dose_unit = 'APPLY'
WHERE form_descr like '%Topical spray%'
AND form_descr like '%UNT in %'

UPDATE vw_dose_unit SET dose_unit = 'TUBEORPACKE'
WHERE form_descr like '%transdermal gel%'

UPDATE vw_dose_unit SET dose_unit = 'ACTUAT'
WHERE form_descr like '%transdermal gel pump%'

UPDATE vw_dose_unit SET dose_unit = 'PATCH'
WHERE form_descr like '%transdermal sys%'

UPDATE vw_dose_unit SET dose_unit = 'ACTIVATION'
WHERE form_descr like '%transdermal sys%'
AND form_descr like '%activation%'

UPDATE vw_dose_unit SET dose_unit = 'INSERT'
WHERE form_descr like '%vaginal Ovule%'
OR form_descr like '%vaginal Pessary%'
OR form_descr like '%vaginal tablet%'

-- Inhalant Solution sheet 4

-- Suppress Anesthesia '562366'
-- Suppress Anesthesia '1549678'
-- Suppress Anesthesia '542358'
-- Suppress Anesthesia '542347'
-- Suppress Anesthesia '200243'
-- Suppress Anesthesia '997625'
-- Suppress Anesthesia '208919'
-- Suppress Anesthesia '542355'
-- Suppress Anesthesia '541963'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1442605'
UPDATE vw_dose_unit SET dose_unit = 'TSP' WHERE form_rxcui = '748308'
-- Retired 358992
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312818'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '207406'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '1314768'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '487056'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '861964'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '1596030'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '213194'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '1314763'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '348719'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '582595'
UPDATE vw_dose_unit SET dose_unit = 'AMP' WHERE form_rxcui = '861966'
UPDATE vw_dose_unit SET dose_unit = 'CARTRIDGE' WHERE form_rxcui = '250983'
UPDATE vw_dose_unit SET dose_unit = 'CARTRIDGE' WHERE form_rxcui = '1046920'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '857795'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '857799'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '205532'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861599'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861597'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '310133'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '863968'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1245026'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '707347'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1495050'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1146217'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '312988'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '312997'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '724592'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '724590'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1244968'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1115812'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '706943'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '204918'
-- Retired 1945738
-- Retired 1362214
-- Retired 1190803
-- Retired 1190944
-- Retired 1362218
-- Retired 857668
-- Retired 857666
UPDATE vw_dose_unit SET dose_unit = 'TSP' WHERE form_rxcui = '701961'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '352051'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '307718'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '307719'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '245314'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '351137'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '351136'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '630208'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '668956'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '212349'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '901610'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '695935'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '901614'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '831246'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '310014'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1437704'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1246319'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1992566'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1437702'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '836358'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '349590'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '311286'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '242754'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1855389'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1992571'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '979489'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '979379'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1246321'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '352132'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '261136'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '833470'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1855391'

-- Nasal Solution Sheet 5
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '313000'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '313967'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '806140'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '806757'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1046602'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1232712'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1232714'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1232716'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1232718'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1234563'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1313882'
UPDATE vw_dose_unit SET dose_unit = 'DROPS' WHERE form_rxcui = '1549386'
UPDATE vw_dose_unit SET dose_unit = 'DROPS' WHERE form_rxcui = '1549388'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1995288'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1995293'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1014132'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1014137'
UPDATE vw_dose_unit SET dose_unit = 'PACKE' WHERE form_rxcui = '1542919'
UPDATE vw_dose_unit SET dose_unit = 'PACKE' WHERE form_rxcui = '1804375'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '284453'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '707329'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '707333'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '806727'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '849520'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '849522'
UPDATE vw_dose_unit SET dose_unit = 'SPRAY' WHERE form_rxcui = '1000987'


-- Injection forms are tricky
UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE dosage_form = 'Injectable Soln'
AND form_descr like '%extract%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
WHERE form_descr like '%UNT Injection%'

UPDATE vw_dose_unit SET dose_unit = 'MCG'
WHERE form_descr like '%Injection%' 
and  form_descr like '%MCG%'
and form_descr not like '%ML%' 
and form_descr not like '%extract%'

UPDATE vw_dose_unit SET dose_unit = 'CELLS'
WHERE form_descr like '%inje%'
  and form_descr like '%cells%'
  and form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%inje%'
and form_descr like '%immune globulin%'
AND form_descr like '%MG%'

UPDATE vw_dose_unit SET dose_unit = 'GRAM'
WHERE form_descr like '%inje%'
and form_descr like '%immune globulin%'
AND form_descr like '%GM%'

UPDATE vw_dose_unit SET dose_unit = 'ML'
WHERE form_descr like '%injection%'
and form_descr like '%immune globulin%'
and (form_descr like '%UNT in%' 
or form_descr like '%UNT/ML%')

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%injection%'
and form_descr like '%MG%' 
and form_descr not like '%extract%' 
and form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'GRAM'
WHERE form_descr like '%injection%'
and form_descr like '%GM%' 
and form_descr not like '%extract%' 
and form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%prefilled%'
and form_descr like '% UNT %' 
and form_descr not like '%ML%' 
and form_descr not like '%GM%' 
and form_descr not like '%MG%' 
and form_descr not like '%MCG%'

UPDATE vw_dose_unit SET dose_unit = 'MCG'
where form_descr like '%prefilled%'
and form_descr like '%immune globulin%'
and form_descr like '%MCG%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%UNT prefilled%'
or form_descr like '%UNT (%' 

UPDATE vw_dose_unit SET dose_unit = 'MG'
where form_descr like '%prefilled%'
and form_descr like '%MG%' 
and form_descr not like '%extract%' 
and form_descr not like '%ML%'

UPDATE vw_dose_unit SET dose_unit = 'MCG'
where form_descr like '%prefilled%'
and form_descr like '%MCG%' 
and form_descr not like '%extract%' 
and form_descr not like '%ML%'

UPDATE p
SET dose_unit = 'DROP'
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where f.form_rxcui IN ('313000', '313967', '806140', '806757', 
'1046602', '1232712', '1232714', '1232716', '1232718', '1234563', 
'1313882', '1549386', '1549388')

UPDATE p
SET dose_unit = 'MG'
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where f.form_rxcui IN ('1995288', '1995293')

UPDATE p
SET dose_unit = 'ML'
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where f.form_rxcui IN ('1014132', '1014137')

UPDATE p
SET dose_unit = 'PACKE'
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where f.form_rxcui IN ('1542919', '1804375')

UPDATE p
SET dose_unit = 'SPRAY'
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
where f.form_rxcui IN ('284453', '707329', '707333', '806727', '849520', '849522', '1000987')

UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313812'
-- Suppress 349408
-- Suppress 352211
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309065'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1093280'
-- Suppress 1242617
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1998783'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191222'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '789980'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190776'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1049633'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1114874'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313996'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897745'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '896771'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '285018'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '545837'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '892531'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1495293'
-- 855856
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1433251'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '102787'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '104084'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '104897'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313920'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '105648'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '106892'
-- 1741409
-- Retired 151114
-- Suppress 197435
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '197989'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '198207'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '198368'
-- Suppress 198412
-- Suppress 199211
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '199317'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '199407'
-- Suppress 199408
-- Retired 199584
-- Retired 199585
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1861411'
UPDATE vw_dose_unit SET dose_unit = 'RETIRED ' WHERE form_rxcui = '199727'
-- Retired 199947
-- Suppress 199958
-- Retired 199965
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '200101'
-- Suppress 200238
-- TPN 200317
-- TPN 200318
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '201860'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '204416'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '204430'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '204441'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '204445'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '204466'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '204490'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '204491'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '204508'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '204509'
-- Suppress 204536
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '204870'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '205259'
-- Retired 205296
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '205821'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '205885'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205912'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205913'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205917'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205918'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205921'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205922'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205923'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '205924'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1722916'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206289'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206344'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206417'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1739890'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206423'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206620'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206715'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206813'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206819'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206820'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206831'
-- Suppress 206967
-- Suppress 206970
-- Suppress 206972
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '207029'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '207035'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '207193'
-- Suppress 207315
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '207351'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '207390'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '207391'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '207468'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '207834'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '207836'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '208325'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '209704'
-- Suppress 210677
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '210972'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '212075'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '212218'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '212219'
-- Suppress 1858963
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '213093'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '213442'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '213475'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '213570'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '213841'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '237210'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '237649'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '237650'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '237656'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '237786'
-- Suppress 238013
-- Suppress 238082
-- Suppress 238083
-- Suppress 238084
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '238090'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '238100'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '238101'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '238133'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '238212'
-- 1796384
UPDATE vw_dose_unit SET dose_unit = 'GRAMS' WHERE form_rxcui = '238719'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239177'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239178'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239189'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239200'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239204'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239208'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239209'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '239212'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '239998'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '239999'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '240000'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '240377'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '240416'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '240637'
-- Suppress 240738
-- Suppress 1743994
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '240912'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '241975'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '241999'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '242120'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '242706'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309072'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '245256'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '245385'
-- Retired 245961
-- Retired 248009
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '248110'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '248288'
UPDATE vw_dose_unit SET dose_unit = 'RETIRED ' WHERE form_rxcui = '248661'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '249220'
-- Suppress 251272
-- Retired 251817
-- Suppress 251934
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '252016'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '252484'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '253014'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '259111'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '260265'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '261105'
-- TPN 262197
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '282486'
-- Retired 282533
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '283504'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '284019'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '604377'
-- 598014
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '284989'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '307816'
-- 307874
-- 307922
-- 307923
-- 307924
-- 307937
-- 307966
-- 307987
-- 308004
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '308260'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '308395'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '308866'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '242800'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309090'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309101'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '105174'
-- TPN 309279
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309311'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '309541'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '199710'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '309778'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309845'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309914'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309915'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310132'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310187'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310189'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310190'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310191'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310248'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '310587'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311033'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311034'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311036'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311040'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311041'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311048'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '311078'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '311282'
-- Suppress 311422
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '311625'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '311700'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '311702'
-- Suppress 311935
-- Suppress 311936
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312127'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312128'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870937'
-- Suppress 312249
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312370'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312447'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312644'
-- Suppress 312736
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312772'
-- 1661345
-- 1666309
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '313002'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '313016'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313324'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313416'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '313532'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '313572'
-- 1666323
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '313650'
UPDATE vw_dose_unit SET dose_unit = 'ACTUATION' WHERE form_rxcui = '313919'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '706461'
-- 542925
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '314099'
-- Suppress 315105
-- Retired 315188
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '347043'
-- Suppress 349407
-- Suppress 349409
-- Suppress 349410
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361563'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '351297'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '351859'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '351926'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361569'
-- Suppress 352212
-- Suppress 352213
-- Suppress 352214
-- Retired 604379
UPDATE vw_dose_unit SET dose_unit = 'RETIRED ' WHERE form_rxcui = '413132'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361572'
-- 1192860
-- Suppress 435151
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '484322'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '485193'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '485210'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '485356'
-- 1192862
-- Suppress 540930
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '542438'
-- 1722407
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '543688'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '543732'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '543739'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '545289'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '545293'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '545835'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '562411'
-- TPN 562675
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727518'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '578803'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '578806'
-- 1722406
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '582971'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '582976'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '582984'
-- Suppress 597195
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '597823'
-- 1741407
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727517'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '351125'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '604806'
-- 1796379
-- 1661332
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '615882'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '616238'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '617247'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '617262'
-- 1718962
-- 1718993
-- Suppress 637197
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '637549'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '637550'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '645884'
UPDATE vw_dose_unit SET dose_unit = 'ACTUATION' WHERE form_rxcui = '688596'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '205964'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '706943'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '722289'
-- 1720165
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '725108'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '727505'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '727507'
-- 1593154
-- 1659998
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727634'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727782'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727820'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727821'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '727822'
-- 1661563
UPDATE vw_dose_unit SET dose_unit = 'MEQ' WHERE form_rxcui = '727995'
-- 1659988
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '729234'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731281'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305910'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305908'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305892'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731538'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731541'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731564'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731566'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731567'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731568'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731570'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '731571'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '745302'
-- 150889
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '745462'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '745560'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '747260'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '751566'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '751568'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '751570'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '752388'
-- 1661566
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762833'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762836'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762839'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762843'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762849'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762852'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762859'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762868'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762875'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '762897'
-- 1233622
-- 1666317
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '763489'
UPDATE vw_dose_unit SET dose_unit = 'MEQ' WHERE form_rxcui = '792577'
UPDATE vw_dose_unit SET dose_unit = 'MEQ' WHERE form_rxcui = '792582'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '562724'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '795144'
-- 795461
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '796918'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798408'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798415'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798477'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798479'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798481'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '798482'
-- TPN 800188
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800209'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800216'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800237'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800269'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800341'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800396'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800401'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800406'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800411'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800416'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800434'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800440'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800445'
-- TPN 800563
-- Suppress 800584
-- Suppress 800588
-- TPN 800611
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800633'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800637'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800644'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800648'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800786'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800790'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800808'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800812'
-- Suppress 800858
-- TPN 800862
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800925'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800928'
-- TPN 800929
-- TPN 800933
-- TPN SUPPRESS 800976
-- TPN SUPPRESS 800979
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800985'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800988'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '800998'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801005'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801009'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801010'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801013'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801016'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801019'
-- Retired 801024
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801029'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801032'
-- TPN 801067
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801109'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801112'
-- TPN 801133
-- TPN 801136
UPDATE vw_dose_unit SET dose_unit = 'RETIRED ' WHERE form_rxcui = '801142'
-- Retired 801145
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801177'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801357'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801364'
-- Retired 801391
-- TPN 801395
-- TPN 801398
-- TPN 801403
-- TPN 801405
-- TPN 801413
-- TPN 801417
-- TPN 801644
-- TPN 801648
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801868'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801881'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '801907'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '803058'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '803062'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '803194'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '803239'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '804981'
-- TPN 805127
-- TPN 805131
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '806573'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '806575'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807222'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807225'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807239'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807273'
-- TPN 807371
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807379'
UPDATE vw_dose_unit SET dose_unit = 'RETIRED ' WHERE form_rxcui = '807383'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807396'
-- Suppress 809871
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1654171'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1654179'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658163'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '825160'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '828527'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '829762'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830460'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830463'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830467'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830470'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '830477'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830651'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830680'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '830731'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '831074'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '831290'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '831426'
-- Suppress 832082
-- Suppress 832086
-- Suppress 833532
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835809'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835811'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835829'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835831'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835840'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '835842'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '836306'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '836307'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '836634'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '836635'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '836636'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847187'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847199'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847230'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847232'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847239'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847241'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '847245'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '847247'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847254'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847259'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '847261'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '847348'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847617'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847626'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847627'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847629'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847630'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '847781'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '849851'
-- 852584
-- 852604
-- Suppress 853004
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '854166'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '854255'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '854256'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '854302'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '855613'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '856696'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '856698'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '857237'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '857886'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '857962'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858048'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858051'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858052'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858053'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858054'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858055'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858056'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858057'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858073'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '858074'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '859203'
-- Suppress 859437
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '859824'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '859867'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '859871'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '860096'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '860192'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '860195'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '860749'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '860751'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861520'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861522'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1812079'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '309696'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1812194'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '863538'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '864110'
-- Suppress 864714
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '865098'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '865129'
-- 867153
-- 867175
-- 867181
-- Suppress 867381
-- Suppress 880859
-- 883497
-- 883499
-- 884079
-- 884183
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '884254'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '886622'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '886627'
-- 889527
-- 889530
-- 889532
-- 889536
-- 889538
-- 889540
-- 889556
-- 889558
-- 889560
-- 889563
-- 889565
-- 889567
-- 889577
-- 889579
-- 889585
-- 889594
-- 889596
-- 889606
-- 889611
-- 889618
-- 889628
-- 889630
-- 889632
-- 889639
-- 889642
-- 889645
-- 889656
-- 889658
-- 889664
-- 889666
-- 889668
-- 892475
-- 892481
-- 894776
-- 894778
-- 894792
-- 894794
-- 894818
-- 894923
-- 894928
-- 894956
-- 894958
-- 894978
-- 894980
-- 895038
-- 895050
-- 895067
-- 895069
-- 895077
-- 895079
-- 895191
-- 895193
-- 895275
-- 895277
-- 895286
-- 895288
-- 895295
-- 895298
-- 895306
-- 895308
-- 895360
-- 895362
-- 895364
-- 895376
-- 895378
-- 895380
-- 895396
-- 895447
-- 895449
-- 895457
-- 895468
-- 895470
-- 895472
-- 895474
-- 895476
-- 895478
-- 895480
-- 895600
-- 895602
-- 895604
-- 895610
-- 895612
-- 895614
-- 895675
-- 895677
-- 895679
-- 895681
-- 895685
-- 895687
-- 895691
-- 895694
-- 895700
-- 895706
-- 895708
-- 895710
-- 895723
-- 895725
-- 895728
-- 895909
-- 895912
-- 895914
-- 896076
-- 896078
-- 896080
-- 896086
-- 896088
-- 896114
-- 896123
-- 896125
-- 896133
-- 896146
-- 896148
-- 896150
-- 896154
-- 896156
-- 896158
-- 896167
-- 896171
-- 896173
-- 896182
-- 896195
-- 896196
-- 896198
-- 896201
-- 896205
-- 896208
-- 896211
-- 896253
-- 896255
-- 896257
-- 896261
-- 896263
-- 896265
-- 896277
-- 896279
-- 896281
-- 896286
-- 896288
-- 896290
-- 896296
-- 896298
-- 896302
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '896854'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '896856'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '896872'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897044'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897122'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897126'
-- 897311
-- 897313
-- 897315
-- 897323
-- 897325
-- 897327
-- 897331
-- 897339
-- 897341
-- 897343
-- 897345
-- 897349
-- 897351
-- 897353
-- 897357
-- 897359
-- 897364
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '897366'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '897368'
-- 897372
-- 897374
-- 897376
-- 897380
-- 897382
-- 897384
-- 897398
-- 897400
-- 897402
-- 897412
-- 897414
-- 897496
-- 897510
-- 897512
-- 897533
-- 897557
-- 897859
-- 897947
-- 897949
-- 897951
-- 897955
-- 897957
-- 897959
-- 897963
-- 897966
-- 897968
-- 897973
-- 897975
-- 897977
-- 897980
-- 897982
-- 897993
-- 897995
-- 897998
-- 898006
-- 898021
-- 898130
-- 898134
-- 898136
-- 898335
-- 898337
-- 898339
-- 898398
-- 898400
-- 898409
-- 898415
-- 898422
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1726673'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1726676'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '899350'
-- 899541
-- 899546
-- 899561
-- 899563
-- 899568
-- 899570
-- 899572
-- 899583
-- 899588
-- 899590
-- 899592
-- 899600
-- 899602
-- 899604
-- 899618
-- 899634
-- 899636
-- 899678
-- 899680
-- 899686
-- 899692
-- 899696
-- 899698
-- 899769
-- 899779
-- 899781
-- 899960
-- 899962
-- 899966
-- 899968
-- 899970
-- 899974
-- 899976
-- 899978
-- 899982
-- 899984
-- 900006
-- 900010
-- 900012
-- 900014
-- 900030
-- 900036
-- 900040
-- 900042
-- 900054
-- 900056
-- 900058
-- 900074
-- 900077
-- 900088
-- 900091
-- 900102
-- 900118
-- 900120
-- 900122
-- 900155
-- 900161
-- 900163
-- 900718
-- 900720
-- 900722
-- 900738
-- 900740
-- 900742
-- 900845
-- 900859
-- 900876
-- 900896
-- 900905
-- 900927
-- 900940
-- 900942
-- 900955
-- 900957
-- 900960
-- 900966
-- 900971
-- 900981
-- 901023
-- 901029
-- 901031
-- 901033
-- 901354
-- 901356
-- 901473
-- 901475
-- 901477
-- 901493
-- 901495
-- 901503
-- 284511
-- 728491
-- 902638
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '904415'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '904440'
-- 904851
-- 904853
-- 905077
-- 905079
-- 905081
-- 905111
-- 905141
-- 905264
-- 905267
-- 905290
-- 905294
-- 966666
-- 966668
-- 966687
-- 966689
-- 966691
-- Suppress 966768
-- 966952
-- 966954
-- 966960
-- 967041
-- 967045
-- 967047
-- 967055
-- 967057
-- 967059
-- 967541
-- 967543
-- 967545
-- 967872
-- 967904
-- 967910
-- 967928
-- 967930
-- 967951
-- 967953
-- 967955
-- 968015
-- 968111
-- 968146
-- 968149
-- 968153
-- 968200
-- 968350
-- 968400
-- 968452
-- 968456
-- 968458
-- 968482
-- 968484
-- 968486
-- 968534
-- 968540
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '977842'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978713'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978715'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978725'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978727'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978733'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978735'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978736'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978737'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978738'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978739'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978740'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978741'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978744'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978745'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978746'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978747'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978755'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978757'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978759'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978760'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978777'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '978778'
-- Suppress 990982
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '992403'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '992801'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '992803'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '992805'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '992807'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '992809'
-- 992836
-- 992850
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '995270'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '995285'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '995906'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '996559'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '996828'
-- 999387
-- 999393
-- 999400
-- 999402
-- 999418
-- 999425
-- 999427
-- 999430
-- 999432
-- 999441
-- 999443
-- 999447
-- 999449
-- 999453
-- 999456
-- 999460
-- 999462
-- 999466
-- 999468
-- 999490
-- 999492
-- 999498
-- 999501
-- 999503
-- 999511
-- 999513
-- 1000015
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1000107'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1000131'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1000133'
-- 1000163
-- 1006294
-- 1006305
-- 1006333
-- 1006335
-- 1006337
-- 1006355
-- 1006357
-- 1006359
-- 1006363
-- 1006365
-- 1006367
-- 1006474
-- 1006476
-- 1006478
-- 1006480
-- 1006484
-- 1006486
-- 1006488
-- 1006490
-- 1006492
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1009456'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1009459'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010033'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010035'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010671'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010673'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010745'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010749'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010751'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010755'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010759'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010763'
-- 1010862
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010900'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1010902'
-- 1010924
-- 1011993
-- 1012039
-- 1012045
-- 1012049
-- 1012053
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012066'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012068'
-- 1012106
-- 1012154
-- 1012174
-- 1012320
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012377'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012381'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012384'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012388'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012396'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012400'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012404'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012406'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012413'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012417'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012455'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012457'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1012465'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012722'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012724'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012726'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012737'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012739'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1012741'
-- 1013869
-- 1013871
-- 1013873
-- 1013875
-- 1013878
-- 1013880
-- 1013885
-- 1013887
-- 1013889
-- 1013900
-- 1013902
-- 1013904
-- 1013910
-- 1013912
-- 1013925
-- 1013927
-- 1013942
-- 1013947
-- 1013951
-- 1013953
-- 1013957
-- 1013959
-- 1013961
-- 1013966
-- 1013968
-- 1013970
-- 1013972
-- 1013974
-- 1013976
-- 1013980
-- 1013984
-- 1013991
-- 1014203
-- 1014205
-- 1014222
-- 1014225
-- 1014266
-- 1014268
-- 1014307
-- 1014309
-- 1014311
-- 1014313
-- 1014320
-- 1014324
-- 1014326
-- 1014335
-- 1014337
-- 1014345
-- 1014347
-- 1014349
-- 1014357
-- TPN 1014427
-- TPN 1014431
-- 1014444
-- 1014446
-- 1014682
-- 1014684
-- 1014686
-- 1014689
-- 1014697
-- 1014699
-- 1014701
-- 1014703
-- 1014716
-- 1014718
-- 1014720
-- 1014724
-- 1014726
-- 1014730
-- 1014765
-- 1014771
-- 1014773
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1040025'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1041495'
UPDATE vw_dose_unit SET dose_unit = 'DROP' WHERE form_rxcui = '1041497'
-- 1043675
-- 1043685
-- 1043787
-- 1043789
-- 1043793
-- 1043795
-- 1044209
-- 1044213
-- 1044222
-- 1044224
-- 1044226
-- 1044228
-- 1044230
-- 1044242
-- 1044244
-- 1044252
-- 1044254
-- 1044267
-- 1044300
-- 1044316
-- 1044320
-- 1044324
-- 1044327
-- 1044337
-- 1044339
-- 1044343
-- 1044347
-- 1044355
-- 1044357
-- 1044385
-- 1044387
-- 1044392
-- 1044398
-- 1044400
-- 1044404
-- 1044486
-- 1044490
-- 1044494
-- 1044502
-- 1044504
-- 1044507
-- 1044512
-- 1044517
-- 1044519
-- 1044523
-- 1044526
-- 1044528
-- 1044614
-- 1045583
-- 1045587
-- 1045589
-- 1045591
-- 1045595
-- 1045597
-- 1045602
-- 1045632
-- 1046209
-- 1046211
-- 1046217
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085750'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085752'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085754'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085756'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085992'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085994'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085996'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1085998'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1087391'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1087395'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1087964'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1087968'
UPDATE vw_dose_unit SET dose_unit = 'TPN ' WHERE form_rxcui = '1090635'
UPDATE vw_dose_unit SET dose_unit = 'TPN ' WHERE form_rxcui = '1094083'
-- 1726260
-- 1726268
-- 1190112
-- 1098122
-- 1098137
-- 1922334
-- Suppress 1100742
-- Suppress 1100746
-- 1115276
-- 1115278
-- 1115281
-- 1115829
-- 1115835
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1812095'
-- 1116983
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1117522'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1117525'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1189629'
-- TPN 1189640
-- TPN 1189645
-- Retired 1189657
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1189668'
-- Retired 1189673
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1189683'
-- 1719240
-- 1666311
-- 1666320
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1190439'
-- Suppress 1190748
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1190750'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1190916'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1190919'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191126'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191128'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191138'
-- 1990857
-- 1719235
-- 1488302
-- 1095283
-- 1193018
-- 1193022
-- 1193026
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '825157'
-- 1232567
-- 1232570
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1232574'
-- 1232576
-- 1232580
-- 1232582
-- 1232595
-- 1232597
-- 1232599
-- 1232601
-- 1232614
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1232651'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658174'
-- Suppress 1234995
-- 1719611
-- 1232190
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1244205'
-- Suppress 1244233
-- Suppress 1244638
-- 1190179
-- 1248595
-- 1248605
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1251596'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1292826'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1292828'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1292879'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1292881'
-- Suppress 1293443
-- Suppress 1293446
-- Suppress 1293464
-- Suppress 1293466
-- TPN 1293736
-- TPN 1293739
-- 1294639
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1297542'
-- 1297555
-- 1297559
-- 1297562
-- 1297568
-- 1297582
-- 1297843
-- 1299998
-- 1300000
-- 1300002
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1300189'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1300191'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1304559'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1304564'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1305200'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1305205'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1305217'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1305222'
-- 1670387
-- 1666303
-- 1719608
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358510'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358512'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358610'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358612'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358617'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1358619'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361029'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361038'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361048'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361226'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361568'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361574'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361577'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361607'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1361615'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362048'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362052'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362054'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362055'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362057'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362059'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362060'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362062'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362063'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362065'
-- 1095281
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1362831'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1365979'
-- 1660001
-- 1801186
-- Suppress 1429282
-- Suppress 1429284
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1441402'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1441411'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1441416'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1441422'
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1442605'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1597103'
-- 1369810
-- Suppress 1486165
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1486496'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1242131'
-- 1719228
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1490057'
-- 1718965
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658125'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1490667'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1491629'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1491634'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1542385'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544378'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544385'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544387'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544389'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544395'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544397'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544399'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544401'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544403'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1544758'
-- TPN 1547445
-- TPN 1547450
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1547459'
-- TPN 1549708
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658127'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658147'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658148'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1654184'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '388911'
-- Retired 415314
-- Suppress 1594589
-- Suppress 1594591
-- Suppress 1594593
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1594757'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658159'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1598268'
-- Suppress 1599836
-- Suppress 1599841
-- Suppress 1601982
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1604539'
-- 1922329
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1608811'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1608815'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1648160'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1648162'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650966'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650968'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650971'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650972'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650973'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650974'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650975'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1650976'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1652239'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1652242'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1652639'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1652640'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1652827'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1652830'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1652833'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1652834'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1653202'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1653204'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '351993'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '284419'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1594432'
-- Suppress 1654849
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1654862'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1655956'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1655959'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1655960'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1655967'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1655968'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658165'
-- 1661352
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1656760'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658058'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658060'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658065'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658066'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658100'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658102'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658105'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658106'
-- 238271
-- 630936
-- 1809535
-- 1809531
-- 1809538
-- 1809542
-- 1809545
-- 486166
-- 615869
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658239'
-- 630939
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658634'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658637'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658647'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658659'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658690'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658692'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658707'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658717'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658719'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1658720'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1659195'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1659197'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1659263'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '825161'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '825159'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658175'
-- 615136
-- 727866
-- 1743999
-- 1726257
-- 1726266
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '731380'
-- 1666328
-- 1484963
-- 1718970
-- 1719231
-- 1743374
-- 753990
-- 314097
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736646'
-- 1718975
-- 1666306
-- Suppress 1666831
-- Suppress 1666837
-- TPN 1667993
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1670011'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1670016'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1670021'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1670023'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736642'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736648'
-- Suppress 1718913
-- Retired 415379
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '213040'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1658423'
-- 1656599
-- 1719246
-- 1729091
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1719222'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1719225'
-- 1593156
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '763141'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '240906'
-- 745309
-- 1656595
-- 1490491
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '763138'
-- 1490493
-- 1670392
-- 723871
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1720878'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1720881'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1721684'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1721685'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1721690'
-- 1484958
-- 1990862
UPDATE vw_dose_unit SET dose_unit = 'VIAL' WHERE form_rxcui = '1722719'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1116927'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1726097'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1726102'
-- 1719243
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '312814'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '313578'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '731381'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1726293'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1726296'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1726313'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '731383'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '898572'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728050'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728351'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728355'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '898578'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1117765'
-- Suppress 1729336
-- Suppress 1730194
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1731315'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1731317'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1732157'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1732161'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1732165'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1734377'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1734383'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1735490'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1735496'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1735501'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1735537'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790353'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790374'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790379'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736645'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736640'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736647'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1736863'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1657862'
-- Suppress 1788947
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1657867'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1927885'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1927890'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1743547'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1743549'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743938'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743941'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743950'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743953'
-- 1666314
-- 1729086
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1747179'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1747185'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1747192'
-- Suppress 1747294
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '206422'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1789950'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1789953'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1789956'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1789958'
-- 1246829
-- 1369805
-- 1192858
-- 1192861
-- 1362072
-- 1659991
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003670'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003664'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003668'
-- Suppress 1791721
-- Suppress 1791723
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1794184'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1794448'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1794552'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1794554'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795477'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795480'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795481'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795496'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795498'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795514'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795518'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795519'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795607'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795609'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795610'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795612'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795616'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795618'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1795621'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1604544'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '2002420'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1798389'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1799310'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1799416'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1799424'
-- Suppress 1799697
-- 1488304
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1801193'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1801611'
-- 1737559
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1593738'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '312807'
-- 901808
-- 1098124
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861447'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861459'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861463'
-- 1098139
-- 1190113
-- 582692
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1858995'
-- Suppress 1859009
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1860167'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1860172'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1865295'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1866543'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1866551'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1866559'
UPDATE vw_dose_unit SET dose_unit = 'MEQ' WHERE form_rxcui = '1868473'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1876705'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1876710'
-- 1812593
-- 1812598
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1922516'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1922518'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1926331'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1926332'
-- Suppress 1926818
-- Suppress 1926823
-- Suppress 1926825
-- Suppress 1926827
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1242136'
-- 901812
-- 1661335
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790382'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1928532'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1928537'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1942743'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1942748'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1946730'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1946772'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1986354'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1986356'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1986825'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1986830'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790383'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790506'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1992160'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1992169'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1992171'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1992536'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '1992538'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1994311'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1994316'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1996291'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1996293'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1996297'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1996298'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '2002419'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790508'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '2002739'
-- Suppress 2003344
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790512'
-- 1718996
-- 1720166
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '2043306'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '2043308'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '2043311'
UPDATE vw_dose_unit SET dose_unit = 'UNITS ' WHERE form_rxcui = '2043312'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1594418'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1594334'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '795143'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '807277'
-- Suppress 1794440
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1790513'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1117759'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1597101'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305888'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305891'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305907'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '1305909'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003660'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003663'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003667'
UPDATE vw_dose_unit SET dose_unit = 'APPLY' WHERE form_rxcui = '2003669'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1242106'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1242503'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665685'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665687'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665690'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665691'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665697'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665698'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665699'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665700'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665701'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1665702'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '860792'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861473'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861476'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861493'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861494'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861529'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '861617'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1927893'
UPDATE vw_dose_unit SET dose_unit = 'ML' WHERE form_rxcui = '1927894'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1657864'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1657868'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731537'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728791'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '894911'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731995'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731993'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '894912'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728800'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731520'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1733080'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731530'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1232113'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728789'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732138'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1729197'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '2003714'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '998212'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728805'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731545'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731998'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731517'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728999'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732014'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732006'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '998213'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732136'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1442790'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1728783'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1731522'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732003'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1732011'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '894914'
-- 1731986
-- 1731990
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724383'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897653'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897756'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724338'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724644'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724276'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897757'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724352'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897758'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '897753'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1872271'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724340'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1724341'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1049289'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1723740'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1723776'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1292887'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743869'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743871'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743877'
UPDATE vw_dose_unit SET dose_unit = 'MCG' WHERE form_rxcui = '1743879'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870631'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870633'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870650'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870676'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870681'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870685'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1870686'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '197736'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '242816'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310473'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310474'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310476'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '310477'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190538'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190540'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190542'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190546'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190551'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190552'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190793'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1190795'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1666781'
UPDATE vw_dose_unit SET dose_unit = 'UNITS' WHERE form_rxcui = '1859000'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191234'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1659929'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1855730'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1191250'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1495298'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1855732'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1791703'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1860480'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1860619'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1001405'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1918045'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1860485'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '312199'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1860482'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '1860486'
UPDATE vw_dose_unit SET dose_unit = 'MG' WHERE form_rxcui = '583218'


-- Heparin and Insulin should override all others
UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%heparin%'
and form_descr like '%injection%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%insulin%'
or form_descr like '%afrezza%'
