-- Revising Dosage Forms spread sheet
-- First assign from Revisign Dosage Forms sheet 1, assign first 
-- so higher priority sheets will override (below).
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'vw_dose_unit') AND type in (N'V'))
DROP VIEW vw_dose_unit
GO
CREATE VIEW vw_dose_unit AS
SELECT p.dose_unit, p.administer_method, f.form_rxcui, f.form_descr, f.dosage_form
from c_Drug_Formulation f
join c_Drug_Package dp ON dp.form_rxcui = f.form_rxcui
join c_Package p on p.package_id = dp.package_id
-- where f.valid_in NOT IN ('Suppress','TPN Suppress','Retired')
GO

UPDATE vw_dose_unit SET dose_unit = 'TAB' 
WHERE form_descr like '%buccal tablet%'

UPDATE vw_dose_unit SET dose_unit = 'STRIP'
WHERE form_descr like '% film'
OR form_descr like '% film, mucoadhesive'
OR form_descr like '%oral strip%' 

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
WHERE form_descr like '%Inhalant Powder%' 
OR form_descr like '%Inhalation Powder%'

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
WHERE form_descr like '%Granules for %Solution%'

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

UPDATE vw_dose_unit SET dose_unit = 'MG'
WHERE form_descr like '%inhalant suspension%'
OR form_descr like '%inhalation suspension%'

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

UPDATE vw_dose_unit SET dose_unit = 'ACTUATNASAL'
WHERE dosage_form IN ('Nasal Gel')
AND form_descr like '%ACTUAT%'

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

UPDATE vw_dose_unit SET dose_unit = 'CM'
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
OR form_descr like '%Powder for Inhalation Solution%'

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

UPDATE vw_dose_unit SET dose_unit = 'GRAM'
WHERE dosage_form IN ('Nasal Ointment')

-- Heparin and Insulin should override all others
UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%heparin%'
and form_descr like '%injection%'

UPDATE vw_dose_unit SET dose_unit = 'UNIT'
where form_descr like '%insulin%'
or form_descr like '%afrezza%'


