
if not exists (select * from sys.columns where object_id = object_id('c_Treatment_Type') and
	 name = 'dashboard_datawindow_config_object_id')
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD [dashboard_datawindow_config_object_id] UNIQUEIDENTIFIER NULL
GO


