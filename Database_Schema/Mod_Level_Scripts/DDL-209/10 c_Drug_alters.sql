


if exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'RXN_available_strength')
	ALTER TABLE c_Drug_Formulation 
	drop dosage_form ,
		dose_amount , 
		dose_unit 


UPDATE c_Drug_Generic
SET generic_name = dbo.fn_tallman(generic_name)
WHERE dbo.fn_needs_tallman(generic_name) = 1

ALTER TABLE [dbo].[c_Drug_Generic] ALTER COLUMN [generic_rxcui] VARCHAR(20)