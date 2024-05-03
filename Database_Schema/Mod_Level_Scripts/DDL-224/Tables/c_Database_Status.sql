
IF (select count(*) from syscolumns where name = 'vax_component_version') > 0
	ALTER TABLE c_Database_Status DROP COLUMN vax_component_version

IF (select count(*) from syscolumns where name = 'vax_component_id') > 0
	ALTER TABLE c_Database_Status DROP COLUMN vax_component_id

IF (select count(*) from syscolumns where name = 'client_link') = 0
	ALTER TABLE c_Database_Status ADD client_link varchar(500)

