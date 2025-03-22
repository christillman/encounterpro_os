if not exists (select * from sys.columns 
		where object_id = object_id('c_Synonym') and
		name = 'preferred_term')
	ALTER TABLE c_Synonym ADD preferred_term varchar(250)