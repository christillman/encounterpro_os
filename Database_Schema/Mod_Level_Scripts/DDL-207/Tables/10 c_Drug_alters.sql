
alter table c_Drug_Brand
	ALTER column brand_name varchar(200) null

if not exists (select * from sys.columns where object_id = object_id('c_Drug_Definition') and
	 name = 'is_generic')
	alter table c_Drug_Definition
		ADD is_generic bit null

if  exists (select * from sys.columns where object_id = object_id('c_Package') and name = 'id')
	begin
		 alter table c_package drop constraint DF__c_Package__id__127EAEC5
		 alter table c_package drop column id
	end

if  exists (select * from sys.columns where object_id = object_id('c_Drug_Administration') and name = 'id')
	begin
		 drop index c_Drug_Administration.idx_drugadmin_id
		 alter table c_Drug_Administration drop constraint DF_c_Drug_Administration_id
		 alter table c_Drug_Administration drop column id
	end

if not exists (select * from sys.columns where object_id = object_id('c_Drug_Administration') and
	 name = 'form_rxcui')
	alter table c_Drug_Administration
		ADD form_rxcui varchar(10) null

if not exists (select * from sys.columns where object_id = object_id('c_Dosage_Form') and
	 name = 'rxcui')
	alter table c_Dosage_Form
		ADD rxcui varchar(10) null

if not exists (select * from sys.columns where object_id = object_id('c_Office') and
	 name = 'country')
	alter table c_Office
		ADD country varchar(40) null
