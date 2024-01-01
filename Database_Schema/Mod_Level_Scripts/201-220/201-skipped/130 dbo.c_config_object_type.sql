
if not exists (select * from sys.columns where object_id = object_id('c_Config_Object_Type') and
	 name = 'object_class')
ALTER TABLE [dbo].[c_Config_Object_Type]
	ADD [object_class] varchar(128) NULL
GO


