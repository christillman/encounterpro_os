
-- Originally added to c_Immunization_Schedule which is not in use ... get rid of it
if exists (select * from sys.columns where object_id = object_id('c_Immunization_Schedule') and
	 name = 'valid_in')
	ALTER TABLE [dbo].[c_Immunization_Schedule] DROP COLUMN valid_in 
go

-- need for country specific immunizations 
-- identified in Ciru email 26/2/2021
if not exists (select * from sys.columns where object_id = object_id('c_Immunization_Dose_Schedule') and
	 name = 'valid_in')
	ALTER TABLE [dbo].[c_Immunization_Dose_Schedule] ADD valid_in varchar(100)
go

UPDATE [c_Immunization_Dose_Schedule]
SET valid_in = 'us;'
WHERE valid_in IS NULL