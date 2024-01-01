


if exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'dosage_form')
	ALTER TABLE c_Drug_Formulation 
	drop column dosage_form ,
		dose_amount , 
		dose_unit 

ALTER TABLE [dbo].[c_Drug_Generic] ALTER COLUMN [generic_rxcui] VARCHAR(20)