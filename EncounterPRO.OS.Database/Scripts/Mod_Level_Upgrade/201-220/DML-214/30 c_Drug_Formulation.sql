-- Corrections
UPDATE f
SET generic_form_rxcui = NULL
FROM c_Drug_Formulation f
JOIN c_Drug_Generic g on g.generic_rxcui = f.ingr_rxcui
WHERE generic_form_rxcui is not null
-- (66 row(s) affected)

-- These mass form_descr updates really exercise the trigger, so drop it temporarily

GO
IF OBJECT_ID ('tr_c_Drug_Formulation_insert_update', 'TR') IS NOT NULL
     DROP TRIGGER tr_c_Drug_Formulation_insert_update
GO


-- Update recommended in comments 11_26_2020 dose_unit assignment ^L0 corrections_RevisedJan2022.xlsx
UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr,'solution for injection','Injectable Solution')
where form_descr like '%solution for injection%'
-- (8 row(s) affected)

-- There is no generic formulation; the one that's there is a tab not supp
UPDATE c_Drug_Formulation 
SET generic_form_rxcui = NULL
where ingr_rxcui = 'KEBI441'
-- (1 row(s) affected)

UPDATE c_Drug_Formulation 
SET generic_form_rxcui = 'KEG5916'
where form_rxcui = 'KEB9632B'
-- (1 row(s) affected)


UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Oral Tablets', 'Oral Tablet')
WHERE form_descr LIKE '%Oral Tablets%'
-- (1 row affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Oral Extended Release Tablet', 'Extended Release Oral Tablet')
WHERE form_descr LIKE '%Oral Extended Release Tablet%'
-- (1 row affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Otic Drops Suspension', 'Otic Suspension')
WHERE form_descr LIKE '%Otic Drops Suspension%'
-- (1 row affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Otic Drops', 'Otic Solution')
WHERE form_descr LIKE '%Otic Drops%'
-- (8 rows affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Topical Liniment', 'Topical Ointment')
WHERE form_descr LIKE '%Topical Liniment%'
-- (1 row affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Transdermal Patch', 'Transdermal System')
WHERE form_descr LIKE '%Transdermal Patch%'
-- (15 rows affected)

UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, 'Vaginal Capsule', 'Vaginal Tablet')
WHERE form_descr LIKE '%Vaginal Capsule%'
-- (10 rows affected)

-- Missing dosage form in description
UPDATE c_Drug_Formulation
SET form_descr = 'terbutaline sulphate 2.5 MG / bromhexine HCl 4 MG / guaifenesin 100 MG in 10 ML Oral Solution' 
-- select form_descr from c_Drug_Formulation
WHERE form_rxcui = 'UGG6489'

UPDATE c_Drug_Formulation
SET form_descr = 'methylcobalamin 750 MCG / pregabalin 75 MG / folic acid 1.5 MG / vitamin B6 3 MG / alpha lipoic acid 100 MG Oral Capsule' 
-- select form_descr from c_Drug_Formulation
WHERE form_rxcui = 'KEG10300'

UPDATE c_Drug_Formulation
SET form_descr = 
'boswella serrata resin extract 100 MG / cyperus rotundus tub extract 100 MG / hyoscyamus niger sd extract 20 MG / oil of ricinus communis extract 3 MG / oroxylum indicum rt extract 223.8 MG / purified strychnos nux-vomica sd extract 25 MG / suvarna paan 0.05 MG / vitex negundo lf extract 500 MG / zingiber officinale 50 mg Oral Tablet'
WHERE form_rxcui = 'KEG1977'

-- RXNorm misspelling
UPDATE c_Drug_Formulation
SET form_descr = REPLACE(form_descr, 'Distintegrating Oral Tablet', 'Disintegrating Oral Tablet')
WHERE form_descr LIKE '%Distintegrating Oral Tablet%'
-- (12 row(s) affected)

-- Missing generic_rxcui
UPDATE c_Drug_Formulation SET ingr_rxcui ='136411' WHERE form_rxcui =  'KEG9757'
UPDATE c_Drug_Formulation SET ingr_rxcui ='8745' WHERE form_rxcui =  'KEG3929'
UPDATE c_Drug_Formulation SET ingr_rxcui ='9071' WHERE form_rxcui =  'KEG276'
UPDATE c_Drug_Formulation SET ingr_rxcui ='9071' WHERE form_rxcui =  'KEG3583'
UPDATE c_Drug_Formulation SET ingr_rxcui ='9071' WHERE form_rxcui =  'KEG743'
UPDATE c_Drug_Formulation SET ingr_rxcui ='9071' WHERE form_rxcui =  'KEG8302'
UPDATE c_Drug_Formulation SET ingr_rxcui ='KEGI1659' WHERE form_rxcui =  'KEG2970'
UPDATE c_Drug_Formulation SET ingr_rxcui ='1511' WHERE form_rxcui =  'KEG9105'
UPDATE c_Drug_Formulation SET ingr_rxcui ='2348' WHERE form_rxcui =  'KEG3772'
UPDATE c_Drug_Formulation SET ingr_rxcui ='2403' WHERE form_rxcui =  'KEG2154'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3264' WHERE form_rxcui =  'KEG1272'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3264' WHERE form_rxcui =  'KEG7469'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3355' WHERE form_rxcui =  'KEG6328'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3355' WHERE form_rxcui =  'KEG7201'
UPDATE c_Drug_Formulation SET ingr_rxcui ='39841' WHERE form_rxcui =  'KEG5197'
UPDATE c_Drug_Formulation SET ingr_rxcui ='4053' WHERE form_rxcui =  'KEG14059'
UPDATE c_Drug_Formulation SET ingr_rxcui ='4053' WHERE form_rxcui =  'KEG7731'
UPDATE c_Drug_Formulation SET ingr_rxcui ='54552' WHERE form_rxcui =  'KEG7402'
UPDATE c_Drug_Formulation SET ingr_rxcui ='67108' WHERE form_rxcui =  'KEG5870'
UPDATE c_Drug_Formulation SET ingr_rxcui ='689' WHERE form_rxcui =  'KEG12789'
UPDATE c_Drug_Formulation SET ingr_rxcui ='6902' WHERE form_rxcui =  'KEG10134'
UPDATE c_Drug_Formulation SET ingr_rxcui ='6902' WHERE form_rxcui =  'KEG4764'
UPDATE c_Drug_Formulation SET ingr_rxcui ='6932' WHERE form_rxcui =  'KEG7435'
UPDATE c_Drug_Formulation SET ingr_rxcui ='6932' WHERE form_rxcui =  'KEG8093'
UPDATE c_Drug_Formulation SET ingr_rxcui ='7213' WHERE form_rxcui =  'KEG305'
UPDATE c_Drug_Formulation SET ingr_rxcui ='7715' WHERE form_rxcui =  'KEG831'
UPDATE c_Drug_Formulation SET ingr_rxcui ='7812' WHERE form_rxcui =  'KEG15395'
UPDATE c_Drug_Formulation SET ingr_rxcui ='7812' WHERE form_rxcui =  'KEG2424'
UPDATE c_Drug_Formulation SET ingr_rxcui ='729455' WHERE form_rxcui =  'KEG11135'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3443' WHERE form_rxcui =  'KEG2135'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3498' WHERE form_rxcui =  'KEG938'
UPDATE c_Drug_Formulation SET ingr_rxcui ='8183' WHERE form_rxcui =  'KEG4693'
UPDATE c_Drug_Formulation SET ingr_rxcui ='3640' WHERE form_rxcui =  'KEG1917'
UPDATE c_Drug_Formulation SET ingr_rxcui ='820299' WHERE form_rxcui =  'KEG4377'
UPDATE c_Drug_Formulation SET ingr_rxcui ='40790' WHERE form_rxcui =  'KEG5358'
UPDATE c_Drug_Formulation SET ingr_rxcui ='4083' WHERE form_rxcui =  'KEG1182'
UPDATE c_Drug_Formulation SET ingr_rxcui ='42375' WHERE form_rxcui =  'KEG7572'
UPDATE c_Drug_Formulation SET ingr_rxcui ='17300' WHERE form_rxcui =  'KEG10530'
UPDATE c_Drug_Formulation SET ingr_rxcui ='190521' WHERE form_rxcui =  'KEG10941'
UPDATE c_Drug_Formulation SET ingr_rxcui ='20610' WHERE form_rxcui =  'KEG742'
UPDATE c_Drug_Formulation SET ingr_rxcui ='10689' WHERE form_rxcui =  'KEG10964'
UPDATE c_Drug_Formulation SET ingr_rxcui ='KEGI10561' WHERE form_rxcui =  'KEG11176'
UPDATE c_Drug_Formulation SET ingr_rxcui ='641' WHERE form_rxcui =  'KEG5881'
UPDATE c_Drug_Formulation SET ingr_rxcui ='114979' WHERE form_rxcui =  'KEG11031'
UPDATE c_Drug_Formulation SET ingr_rxcui ='283742' WHERE form_rxcui =  'KEG5571'
UPDATE c_Drug_Formulation SET ingr_rxcui ='1347' WHERE form_rxcui =  'KEG8625'
UPDATE c_Drug_Formulation SET ingr_rxcui ='1347' WHERE form_rxcui =  'KEG9490'

UPDATE c_Drug_Formulation SET ingr_rxcui = 'KEGI424' WHERE form_rxcui = 'KEG424'

UPDATE c_Drug_Formulation SET generic_form_rxcui = '309714' WHERE form_rxcui = 'KEB1668'
UPDATE Kenya_Drugs SET Corresponding_RXCUI = 'SCD-309714' where Retention_No = '1668'

UPDATE c_Drug_Formulation SET generic_form_rxcui = '1660014' WHERE generic_form_rxcui = 'KEGI1796'
UPDATE c_Drug_Formulation SET generic_form_rxcui = 'KEG4015' WHERE generic_form_rxcui = 'KEG7623' 
UPDATE c_Drug_Formulation SET generic_form_rxcui = 'KEG4495' WHERE generic_form_rxcui = 'KEG9133' 
UPDATE c_Drug_Formulation SET generic_form_rxcui = 'KEG5916' WHERE generic_form_rxcui = 'KEG9632B' 

-- stray slash in RXNORM RXNCONSO
UPDATE c_Drug_Formulation
SET form_descr = 'acetaminophen 325 MG / caffeine 30 MG / dihydrocodeine bitartrate 16 MG Oral Tablet'
WHERE form_rxcui = '1812164'

update c_Drug_Formulation set form_descr = 'aminophylline 25 MG/ML in 10 ML Injection'
where form_descr = 'aminophylline 250 MG in 10 ML Injection'
update c_Drug_Formulation set form_descr = 'fluconazole 2 MG/ML in 100 ML Injection'
where form_descr = 'fluconazole 200 MG per 100 ML Injection'
update c_Drug_Formulation set form_descr = 'levoFLOXacin 5 MG/ML in 100 ML Injection'
where form_descr = 'levofloxacin 500 MG in 100 ML Injection'
update c_Drug_Formulation set form_descr = 'levoFLOXacin 5 MG/ML in 50 ML Injection'
where form_descr = 'levofloxacin 250 MG in 50 ML Injection'
update c_Drug_Formulation set form_descr = 'potassium chloride 150 MG/ML in 10 mL Injection'
where form_descr = '10 ML potassium chloride 15 % (150 MG/ML) Injectable Solution'
update c_Drug_Formulation set form_descr = 'potassium chloride 100 MG/ML in 10 mL Injection'
where form_descr = '10 ML potassium chloride 10 % (100 MG/ML) Injectable Solution'

update c_Drug_Formulation set form_descr = 'testosterone 16.2 MG/GM in 1.25 GM Transdermal Gel'
where form_descr = 'testosterone 1.62 % (20.25MG / 1.25GM) Transdermal Gel'
update c_Drug_Formulation set form_descr = 'testosterone 16.2 MG/GM in 2.5 GM Transdermal Gel'
where form_descr = 'testosterone 1.62 % (40.5MG / 2.5GM) Transdermal Gel'
update c_Drug_Formulation set form_descr = 'testosterone 10 MG/GM in 2.5 GM Transdermal Gel'
where form_descr = 'testosterone 1 % (25 MG / 2.5 GM) Transdermal Gel'
update c_Drug_Formulation set form_descr = 'testosterone 10 MG/GM in 5 GM Transdermal Gel'
where form_descr = 'testosterone 1 % (50 MG / 5 GM) Transdermal Gel'
update c_Drug_Formulation set form_descr = 'ancrod 70 UNT/mL Injectable Solution'
where form_descr = 'ancrod 70 UNT / mL Injectable Solution'


UPDATE c_Drug_Formulation 
SET form_descr = REPLACE(form_descr, ' hydrochloride ', ' HCl ')
WHERE form_descr like '% hydrochloride %'

UPDATE f 
SET form_descr = replace(replace(replace(replace(replace(form_descr,
	' MG', ' mG'),  
	' MCG', ' mcG'),  
	'/MG', '/mG'),  
	'/ML', '/mL'),  
	' ML', ' mL'
	)
from c_Drug_Formulation f
where form_descr like '% MG%'
or form_descr like '% MCG%'
or form_descr like '% ML%'
or form_descr like '%/MG%'
or form_descr like '%/ML%'


UPDATE c_Drug_Formulation
SET form_descr = REPLACE(form_descr, ' HCI', ' HCl')
WHERE form_descr LIKE '% HCI%'

UPDATE c_Drug_Formulation
SET form_descr = REPLACE(form_descr,'  ','')
WHERE form_descr LIKE '%  %'

update c_Drug_Formulation 
set form_descr = replace(form_descr, ' per ', ' in ')
where (form_descr like '% per % ML%' or form_descr like '% per % OZ%')
and form_descr not like '% per 24%'
and form_tty like 'SCD%'
GO

CREATE TRIGGER tr_c_Drug_Formulation_insert_update
ON c_Drug_Formulation
FOR INSERT, UPDATE 
AS 
	BEGIN 
	IF EXISTS (SELECT 1 FROM c_Drug_Formulation f
				JOIN inserted i ON i.form_descr = f.form_descr
				WHERE i.form_rxcui != f.form_rxcui)
		BEGIN
		RAISERROR ('Not a unique value for form_descr', 16, 10)
		-- Force Violation of PRIMARY KEY to prevent insertion
		INSERT INTO c_Drug_Formulation (form_rxcui)
		SELECT f.form_rxcui FROM c_Drug_Formulation f
		JOIN inserted i ON i.form_descr = f.form_descr
		END
	END
  
GO

