-- need for country specific immunizations 
-- identified in Ciru email 26/2/2021
ALTER TABLE [dbo].[c_Immunization_Schedule]
ADD valid_in varchar(100)
go

-- set default
UPDATE [dbo].[c_Immunization_Schedule]
SET valid_in = 'us;ke;'