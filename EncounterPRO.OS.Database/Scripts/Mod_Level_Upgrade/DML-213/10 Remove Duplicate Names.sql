/*


select form_rxcui from c_Drug_Formulation where form_descr in  (
SELECT form_descr FROM c_Drug_Formulation 
group by form_descr having count(*) > 1
)
and form_rxcui like 'UG%'
order by form_rxcui

UGG0187
UGG0434
UGG1485
UGG1488
UGG1777
UGG2016
UGG2385
UGG2415
UGG2783
UGG2998
UGG3163
UGG3569
UGG3808
UGG4413
UGG4413A
UGG4413B
UGG5282
UGG6454
UGG7013
UGGNL00011


select * from c_Drug_Formulation f
left join c_Drug_Generic g on g.generic_rxcui = f.ingr_rxcui
where f.form_rxcui in (
'KEG5958','KEG7623','KEG4015','KEG3091','KEG1306','KEG5916','KEG9632B','KEG7481','KEG1825',
'KEG7247','KEG6324','KEG15702A','403908'
)
order by form_descr

select * from c_Drug_Formulation f
left join c_Drug_Brand b on b.brand_name_rxcui = f.ingr_rxcui
where f.form_rxcui in (
'KEB15702A','403908','KEB7647'
)
*/
DELETE FROM c_Drug_Formulation 
	WHERE form_rxcui IN ('KEB15702B','KEB5216','KEB5912','KEB7647',
	'KEG5958','KEG7623','KEG3091','KEG1306','KEG9632B','KEG7481','KEG1825','KEG7247',
	'KEG6324')
UPDATE c_Drug_Formulation SET form_descr = 'traMADol HCL 50 MG/ML Injectable Solution' 
	WHERE form_rxcui = '849329'
UPDATE c_Drug_Formulation SET valid_in = 'us;ke;ug;' 
	WHERE form_rxcui = '1659595'

GO
-- Note, the DDL below needs to be here because we need to eliminate the duplicates
-- before asserting uniqueness. Separate scripts have been put into source, but not
-- in the DDL section of the mod which executes before DML.

IF OBJECT_ID ('tr_c_Drug_Formulation_insert_update', 'TR') IS NOT NULL
     DROP TRIGGER tr_c_Drug_Formulation_insert_update
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
  
  /*
  insert into c_Drug_Formulation (
  [form_rxcui]
      ,[form_tty]
      ,[form_descr]
      ,[ingr_rxcui]
      ,[ingr_tty]
      ,[valid_in]
      ,[generic_form_rxcui]
	  )
SELECT [form_rxcui] + 'A'
      ,[form_tty]
      ,[form_descr]
      ,[ingr_rxcui]
      ,[ingr_tty]
      ,[valid_in]
      ,[generic_form_rxcui] -- delete
  FROM [dbo].[c_Drug_Formulation] 
	WHERE form_rxcui IN ('KEB15702A')
*/
/*
1088455	SCD_PSN	alfuzosin HCl 2.5 MG Oral Tablet
KEG5958	SCD_KE	alfuzosin HCl 2.5 MG Oral Tablet
KEG4015	SCD_KE	amoxicillin 125 MG / flucloxacillin magnesium 125 MG in 5 ML Powder for Oral Suspension
KEG7623	SCD_KE	amoxicillin 125 MG / flucloxacillin magnesium 125 MG in 5 ML Powder for Oral Suspension
KEB15702A	SBD_KE	Beuflox-D 0.3 % / 0.1 % Ophthalmic Suspension
KEB15702B	SBD_KE	Beuflox-D 0.3 % / 0.1 % Ophthalmic Suspension
1236182	SCD_PSN	dihydrocodeine tartrate 30 MG Oral Tablet
KEG3091	SCD_KE	dihydrocodeine tartrate 30 MG Oral Tablet
105341	SCD	Diloxanide 500 MG Oral Tablet
KEB7647	SBD_KE	Diloxanide 500 MG Oral Tablet
997550	SCD_PSN	fexofenadine HCl 120 MG Oral Tablet
KEG1306	SCD_KE	fexofenadine HCl 120 MG Oral Tablet
KEG5916	SCD_KE	insulin glargine 100 UNITS/ML in 3 ML Cartridge
KEG9632B	SCD_KE	insulin glargine 100 UNITS/ML in 3 ML Cartridge
285018	SBD_PSN	Lantus 100 UNT/ML Injectable Solution
KEB5912	SBD_KE	Lantus 100 UNT/ML Injectable Solution
854872	SCD_PSN	RABEprazole sodium 10 MG Delayed Release Oral Tablet
KEG7481	SCD_KE	RABEprazole sodium 10 MG Delayed Release Oral Tablet
836466	SCD_PSN	traMADol HCl 50 MG Oral Capsule
KEG1825	SCD_KE	traMADol HCL 50 MG Oral Capsule
849329	SCD	tramadol HCl 50 MG/ML Injectable Solution
KEG7247	SCD_KE	traMADol HCL 50 MG/ML Injectable Solution
1659595	SBD_PSN	Unasyn 1.5 GM Injection
KEB5216	SBD_KE	Unasyn 1.5 GM Injection
1549372	SCD_PSN	xylometazoline HCl 0.1 % Nasal Solution
KEG6324	SCD_KE	xylometazoline HCl 0.1 % Nasal Solution
*/

/*
SELECT f.form_rxcui, g.generic_rxcui, g.drug_id, generic_name  
from c_Drug_Generic g
join c_Drug_Formulation f on f.ingr_rxcui = g.generic_rxcui
where generic_name in (
SELECT generic_name FROM c_Drug_Generic
group by generic_name having count(*) > 1
)
and g.generic_rxcui like 'KE%'
order by generic_name, g.generic_rxcui
*/

/*
1008837	RXNG1008837	Hepatitis A Vaccine (Inactivated) Strain HM175 / Hepatitis B Surface Antigen Vaccine
KEGI7697A	KEGI7697A	Hepatitis A Vaccine (Inactivated) Strain HM175 / Hepatitis B Surface Antigen Vaccine
1007640	RXNG1007640	Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine
KEGI10093	KEGI10093	Human-Bovine Reassortant Rotavirus Strain G1 Vaccine / Human-Bovine Reassortant Rotavirus Strain G2 Vaccine / Human-Bovine Reassortant Rotavirus Strain G3 Vaccine / Human-Bovine Reassortant Rotavirus Strain G4 Vaccine / Human-Bovine Reassortant Rotavirus Strain P1A[8] Vaccine
1008395	RXNG1008395	meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
KEGI12367	KEGI12367	meningococcal group A polysaccharide / meningococcal group C polysaccharide / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP W-135 / MENINGOCOCCAL POLYSACCHARIDE VACCINE GROUP Y
1008034	RXNG1008034	Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine
KEGI6896	KEGI6896	Neisseria meningitidis serogroup A capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup C capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup W-135 capsular polysaccharide diphtheria toxoid protein conjugate vaccine / Neisseria meningitidis serogroup Y capsular polysaccharide diphtheria toxoid protein conjugate vaccine
1006915	RXNG1006915	poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)
KEGI7884B	KEGI7884B	poliovirus vaccine inactivated, type 1 (Mahoney) / poliovirus vaccine inactivated, type 2 (MEF-1) / poliovirus vaccine inactivated, type 3 (Saukett)
1008803	RXNG1008803	Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine
KEGI2911	KEGI2911	Streptococcus pneumoniae serotype 1 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 14 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 18C capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 19F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 23F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 3 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 4 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 5 capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6A capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 6B capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 7F capsular antigen diphtheria CRM197 protein conjugate vaccine / Streptococcus pneumoniae serotype 9V capsular antigen diphtheria CRM197 protein conjugate vaccine
*/

UPDATE c_Drug_Formulation SET ingr_rxcui = '1006915'
WHERE form_rxcui IN ('KEG7884A', 'KEG7884B')

DELETE FROM c_Drug_Generic 
	WHERE generic_rxcui IN ('KEGI7884B','KEGI7697A','KEGI10093','KEGI12367','KEGI6896','KEGI2911')

-- Because a unique index fails if the column is over 900 bytes, 
-- create a checksum column and a unique index on that.
if exists (select * from sys.columns where object_id = object_id('c_Drug_Generic') and
	 name = 'uq_name_checksum')
	BEGIN
	ALTER TABLE c_Drug_Generic DROP CONSTRAINT uq_generic_name 
	ALTER TABLE c_Drug_Generic DROP COLUMN uq_name_checksum
	END

GO
ALTER TABLE c_Drug_Generic ADD uq_name_checksum AS (CHECKSUM(generic_name)
	) PERSISTED,	
	CONSTRAINT uq_generic_name UNIQUE (uq_name_checksum)
GO

if exists (select * from sys.indexes where object_id = object_id('c_Drug_Brand') and
	 name = 'uq_brand_name')
	 DROP INDEX c_Drug_Brand.uq_brand_name

CREATE UNIQUE INDEX uq_brand_name ON c_Drug_Brand (brand_name)

