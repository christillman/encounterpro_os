
if not exists (select * from sys.columns where object_id = object_id('c_Component_Type') and
	 name = 'plugin_type')
ALTER TABLE [dbo].[c_Component_Type]
	ADD [plugin_type] varchar(40) NULL
GO


