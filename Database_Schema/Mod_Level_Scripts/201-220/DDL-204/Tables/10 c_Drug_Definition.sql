
if not exists (select * from sys.columns where object_id = object_id('c_drug_definition') and
	 name = 'fda_generic_available')
	BEGIN
		alter table c_drug_definition
		add fda_generic_available smallint default 0
		alter table c_drug_definition
		add available_strengths varchar(80) -- populate from Rxterms STRENGTH column for similar drugs
	END
	