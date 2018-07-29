
if not exists (select * from sys.columns where object_id = object_id('c_Config_Object') and
	 name = 'installed_local_key')
ALTER TABLE [dbo].[c_Config_Object]
	ADD [installed_local_key] int NULL
GO


