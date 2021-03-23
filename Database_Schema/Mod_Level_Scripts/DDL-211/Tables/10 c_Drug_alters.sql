-- Add generic_form_rxcui
if not exists (select * from sys.columns where object_id = object_id('c_Drug_Formulation') and
	 name = 'generic_form_rxcui')
	ALTER TABLE c_Drug_Formulation ADD generic_form_rxcui varchar(20) NULL
