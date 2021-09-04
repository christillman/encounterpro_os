
if not exists (select * from sys.columns where object_id = object_id('c_Vaccine_Disease') and
	 name = 'last_updated')
	BEGIN
	ALTER TABLE [dbo].[c_Vaccine_Disease] ADD last_updated datetime DEFAULT getdate()
	UPDATE c_Vaccine_Disease SET last_updated = '2010-01-01' WHERE 1=1
	END
go

