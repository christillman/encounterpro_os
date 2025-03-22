
if not exists (select * from sys.columns 
		where object_id = object_id('c_Drug_Pack') and
		name = 'pack_rxcui')
	begin
	exec sp_rename 'c_Drug_Pack.rxcui', 'pack_rxcui'
	exec sp_rename 'c_Drug_Pack.tty', 'pack_tty'
	exec sp_rename 'c_Drug_Pack.descr', 'pack_descr'
	end