-- need for country specific immunizations 
-- identified in Ciru email 26/2/2021
if not exists (select * from sys.columns where object_id = object_id('c_Immunization_Schedule') and
	 name = 'valid_in')
	ALTER TABLE [dbo].[c_Immunization_Schedule] ADD valid_in varchar(100)
go

-- set default
UPDATE [dbo].[c_Immunization_Schedule]
SET valid_in = 'us;ke;'