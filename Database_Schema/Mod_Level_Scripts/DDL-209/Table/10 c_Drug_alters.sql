


if exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'RXN_available_strength')
	ALTER TABLE c_Drug_Formulation 
	drop dosage_form ,
		dose_amount , 
		dose_unit 
