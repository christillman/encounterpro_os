-------------------------------------------------------------------------------
-- New Datawindow Config Service
-------------------------------------------------------------------------------

DELETE FROM o_Service
WHERE service = 'Configure Datawindow'
GO

DELETE FROM o_Service_Attribute
WHERE service = 'Configure Datawindow'
GO

Insert into o_Service (
	service,
	description,
	button,
	icon,
	general_flag	,
	patient_flag	,
	encounter_flag	,
	assessment_flag	,
	treatment_flag	,
	observation_flag,	
	attachment_flag	,
	close_flag	,
	signature_flag	,
	owner_flag	,
	visible_flag,	
	secure_flag	,
	component_id	,
	status	,
	id	,
	owner_id	,
	last_updated	,
	definition	,
	default_expiration_time	,
	default_expiration_unit_id)
values (
	'Configure Datawindow',
	'Configure Datawindow',
	'button_wrench.bmp',
	'button_wrench.bmp',
	'Y',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'Y',
	'N',
	'SVC_Generic',
	'OK',
	'{025E4558-A8AC-4CA5-98EC-4575A4F96E2D}',
	0,
	getdate(),
	'Configure Datawindow',
	1,
	'DAY')
GO

INSERT INTO o_Service_Attribute (
	service,
	attribute,
	value)
VALUES (
	'Configure Datawindow',
	'window_class',
	'w_svc_config_datawindow')
GO


-------------------------------------------------------------------------------
-- New Datawindow config object type
-------------------------------------------------------------------------------

DELETE FROM c_Config_Object_Type
WHERE config_object_type = 'Datawindow'
GO

INSERT INTO [dbo].[c_Config_Object_Type]
	([config_object_type]
	,[description]
	,[base_table]
	,[config_object_key]
	,[config_object_prefix]
	,[version_control]
	,[created_by]
	,[configuration_service]
	,[object_encoding_method]
	,[auto_install_flag]
	,[concurrent_install_flag])
VALUES (
	'Datawindow',
	'Datawindow',
	'c_Config_Object',
	'config_object_id',
	'Dw',
	1,
	'#SYSTEM',
	'Configure Datawindow',
	'None',
	1,
	1 )
GO

-------------------------------------------------------------------------------
-- New config object param class
-------------------------------------------------------------------------------

DELETE FROM dbo.c_Component_Param_Class
WHERE param_class = 'u_param_config_object'
GO

INSERT INTO dbo.c_Component_Param_Class (
	param_class,
	description,
	Instructions)
VALUES (
	'u_param_config_object',
	'Config Object',
	'Use [SQL] to specify config object type'
	)
GO

-------------------------------------------------------------------------------
-- New Datawindow preferences
-------------------------------------------------------------------------------

-- Add preferences for Default Treatment Dashboard Datawindow
DELETE FROM c_Preference
WHERE preference_type = 'PREFERENCES'
AND preference_id = 'Default Treatment Dashboard Datawindow'
GO

INSERT INTO c_Preference (
	preference_type,
	preference_id,
	description,
	param_class,
	global_flag,
	office_flag,
	computer_flag,
	specialty_flag,
	user_flag,
	query,
	help,
	encrypted)
VALUES (
	'PREFERENCES',
	'Default Treatment Dashboard Datawindow',
	'Default Treatment Dashboard Datawindow',
	'u_param_config_object',
	'Y',
	'Y',
	'N',
	'Y',
	'N',
	'Datawindow',
	'Select datawindow config object to be used for treatment types for which no dashboard datawindow has been specified',
	'N'
	)
GO

-------------------------------------------------------------------------------
-- New PowerBuilder Library Component
-------------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Type]
WHERE component_type = 'PowerBuilder Library'
GO

INSERT INTO [dbo].[c_Component_Type]
           ([component_type]
           ,[description]
           ,[base_class]
           ,[status]
           ,[component_selection]
           ,plugin_type)
VALUES (
	'PowerBuilder Library',
	'PowerBuilder Library',
	'u_component_base_class',
	'OK',
	'Any',
	'PowerBuilder Library')	
GO

-------------------------------------------------------------------------------
-- New datawindow param class
-------------------------------------------------------------------------------

DELETE FROM dbo.c_Component_Param_Class
WHERE param_class = 'u_param_datawindow'
GO

INSERT INTO dbo.c_Component_Param_Class (
	param_class,
	description,
	Instructions)
VALUES (
	'u_param_datawindow',
	'Datawindow',
	'Select datawindow object from a library'
	)
GO

-------------------------------------------------------------------------------
-- New Controller Config Service
-------------------------------------------------------------------------------

DELETE FROM o_Service
WHERE service = 'Configure Controller'
GO

DELETE FROM o_Service_Attribute
WHERE service = 'Configure Controller'
GO

Insert into o_Service (
	service,
	description,
	button,
	icon,
	general_flag	,
	patient_flag	,
	encounter_flag	,
	assessment_flag	,
	treatment_flag	,
	observation_flag,	
	attachment_flag	,
	close_flag	,
	signature_flag	,
	owner_flag	,
	visible_flag,	
	secure_flag	,
	component_id	,
	status	,
	id	,
	owner_id	,
	last_updated	,
	definition	,
	default_expiration_time	,
	default_expiration_unit_id)
values (
	'Configure Controller',
	'Configure Controller',
	'button_controllers.gif',
	'button_controllers.gif',
	'Y',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'Y',
	'N',
	'SVC_Generic',
	'OK',
	'{42391874-811C-4E9D-86B5-985A7B3A49F8}',
	0,
	getdate(),
	'Configure Controller',
	1,
	'DAY')
GO

INSERT INTO o_Service_Attribute (
	service,
	attribute,
	value)
VALUES (
	'Configure Controller',
	'window_class',
	'w_svc_config_controller')
GO


-------------------------------------------------------------------------------
-- New Datawindow config object type
-------------------------------------------------------------------------------

DELETE FROM c_Config_Object_Type
WHERE config_object_type = 'Controller'
GO

INSERT INTO [dbo].[c_Config_Object_Type]
	([config_object_type]
	,[description]
	,[base_table]
	,[config_object_key]
	,[config_object_prefix]
	,[version_control]
	,[created_by]
	,[configuration_service]
	,[object_encoding_method]
	,[auto_install_flag]
	,[concurrent_install_flag])
VALUES (
	'Controller',
	'Controller',
	'c_Config_Object',
	'config_object_id',
	'Ctrl',
	1,
	'#SYSTEM',
	'Configure Controller',
	'None',
	1,
	1 )
GO


-------------------------------------------------------------------------------
-- New config object components
-------------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Definition]
WHERE component_id = 'Cfg Report'
GO

INSERT INTO [dbo].[c_Component_Definition]
           ([component_id]
           ,[component_type]
           ,[system_id]
           ,[system_type]
           ,[system_category]
           ,[component_install_type]
           ,[component]
           ,[description]
           ,[normal_version]
           ,[id]
           ,[status]
           ,[owner_id]
           ,[last_updated]
			)
VALUES (
	'Cfg Report',
	'Config Object',
	'Cfg Report',
	'ClientModule',
	'Config Object Component',
	'Client',
	'Config Object',
	'Report Config Object',
	1,
	'{BA0EBB76-F23D-4DF8-B5A8-A676814E543B}',
	'OK',
	0,
	getdate()
	)
GO

DELETE FROM [dbo].[c_Component_Version]
WHERE component_id = 'Cfg Report'
GO

INSERT INTO [dbo].[c_Component_Version]
	([component_id]
	,[version]
	,[description]
	,[component_type]
	,[component_class]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[release_status]
	,[release_status_date_time]
	,[min_build]
	,[min_modification_level]
	,[id]
	,[installer]
	,[independence]
	,[system_id]
	,[build]
	,[build_name]
	,[compile]
	,[compile_name]
	,[last_updated]
	)
VALUES (
	'Cfg Report',
	1,	
	'Report Config Object',
	'Config Object',
	'u_component_config_object_report',
	0,
	getdate(),
	'#SYSTEM',
	'OK',
	getdate(),
	'Production',
	'1/1/2011',
	50000,
	200,
	'{0F489E9C-A08D-4593-84A2-1F798991E3B9}',
	'BuiltIn',
	'Single',
	'Cfg Report',
	0,
	'1',
	1,
	'1.1',
	getdate()
	)
GO

-------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Definition]
WHERE component_id = 'Cfg Controller'
GO

INSERT INTO [dbo].[c_Component_Definition]
           ([component_id]
           ,[component_type]
           ,[system_id]
           ,[system_type]
           ,[system_category]
           ,[component_install_type]
           ,[component]
           ,[description]
           ,[normal_version]
           ,[id]
           ,[status]
           ,[owner_id]
           ,[last_updated]
			)
VALUES (
	'Cfg Controller',
	'Config Object',
	'Cfg Controller',
	'ClientModule',
	'Config Object Component',
	'Client',
	'Config Object',
	'Controller Config Object',
	1,
	'{CECB9ACE-47A8-4561-8265-DBC535D1388A}',
	'OK',
	0,
	getdate()
	)
GO

DELETE FROM [dbo].[c_Component_Version]
WHERE component_id = 'Cfg Controller'
GO

INSERT INTO [dbo].[c_Component_Version]
	([component_id]
	,[version]
	,[description]
	,[component_type]
	,[component_class]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[release_status]
	,[release_status_date_time]
	,[min_build]
	,[min_modification_level]
	,[id]
	,[installer]
	,[independence]
	,[system_id]
	,[build]
	,[build_name]
	,[compile]
	,[compile_name]
	,[last_updated]
	)
VALUES (
	'Cfg Controller',
	1,	
	'Controller Config Object',
	'Config Object',
	'u_component_config_object_controller',
	0,
	getdate(),
	'#SYSTEM',
	'OK',
	getdate(),
	'Production',
	'1/1/2011',
	50000,
	200,
	'{273CD010-16F9-41E4-BA9C-084522B63741}',
	'BuiltIn',
	'Single',
	'Cfg Controller',
	0,
	'1',
	1,
	'1.1',
	getdate()
	)
GO

-------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Definition]
WHERE component_id = 'Cfg Datawindow'
GO

INSERT INTO [dbo].[c_Component_Definition]
           ([component_id]
           ,[component_type]
           ,[system_id]
           ,[system_type]
           ,[system_category]
           ,[component_install_type]
           ,[component]
           ,[description]
           ,[normal_version]
           ,[id]
           ,[status]
           ,[owner_id]
           ,[last_updated]
			)
VALUES (
	'Cfg Datawindow',
	'Config Object',
	'Cfg Datawindow',
	'ClientModule',
	'Config Object Component',
	'Client',
	'Config Object',
	'Datawindow Config Object',
	1,
	'{064D02D4-F50E-40E5-8B8C-E996D1DC4BB2}',
	'OK',
	0,
	getdate()
	)
GO

DELETE FROM [dbo].[c_Component_Version]
WHERE component_id = 'Cfg Datawindow'
GO

INSERT INTO [dbo].[c_Component_Version]
	([component_id]
	,[version]
	,[description]
	,[component_type]
	,[component_class]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[release_status]
	,[release_status_date_time]
	,[min_build]
	,[min_modification_level]
	,[id]
	,[installer]
	,[independence]
	,[system_id]
	,[build]
	,[build_name]
	,[compile]
	,[compile_name]
	,[last_updated]
	)
VALUES (
	'Cfg Datawindow',
	1,	
	'Datawindow Config Object',
	'Config Object',
	'u_component_config_object_datawindow',
	0,
	getdate(),
	'#SYSTEM',
	'OK',
	getdate(),
	'Production',
	'1/1/2011',
	50000,
	200,
	'{C4D81DE9-DE55-4989-ACBE-5CF098C4B504}',
	'BuiltIn',
	'Single',
	'Cfg Datawindow',
	0,
	'1',
	1,
	'1.1',
	getdate()
	)
GO

-------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Definition]
WHERE component_id = 'Cfg Menu'
GO

INSERT INTO [dbo].[c_Component_Definition]
           ([component_id]
           ,[component_type]
           ,[system_id]
           ,[system_type]
           ,[system_category]
           ,[component_install_type]
           ,[component]
           ,[description]
           ,[normal_version]
           ,[id]
           ,[status]
           ,[owner_id]
           ,[last_updated]
			)
VALUES (
	'Cfg Menu',
	'Config Object',
	'Cfg Menu',
	'ClientModule',
	'Config Object Component',
	'Client',
	'Config Object',
	'Menu Config Object',
	1,
	'{05D8F38F-6F77-4D3B-965E-CFC4F8418881}',
	'OK',
	0,
	getdate()
	)
GO

DELETE FROM [dbo].[c_Component_Version]
WHERE component_id = 'Cfg Menu'
GO

INSERT INTO [dbo].[c_Component_Version]
	([component_id]
	,[version]
	,[description]
	,[component_type]
	,[component_class]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[release_status]
	,[release_status_date_time]
	,[min_build]
	,[min_modification_level]
	,[id]
	,[installer]
	,[independence]
	,[system_id]
	,[build]
	,[build_name]
	,[compile]
	,[compile_name]
	,[last_updated]
	)
VALUES (
	'Cfg Menu',
	1,	
	'Menu Config Object',
	'Config Object',
	'u_component_config_object_menu',
	0,
	getdate(),
	'#SYSTEM',
	'OK',
	getdate(),
	'Production',
	'1/1/2011',
	50000,
	200,
	'{7DC662FE-EB67-4014-A27A-DB6A875C8058}',
	'BuiltIn',
	'Single',
	'Cfg Menu',
	0,
	'1',
	1,
	'1.1',
	getdate()
	)
GO

-------------------------------------------------------------------------

DELETE FROM [dbo].[c_Component_Definition]
WHERE component_id = 'Cfg Vaccine Schedule'
GO

INSERT INTO [dbo].[c_Component_Definition]
           ([component_id]
           ,[component_type]
           ,[system_id]
           ,[system_type]
           ,[system_category]
           ,[component_install_type]
           ,[component]
           ,[description]
           ,[normal_version]
           ,[id]
           ,[status]
           ,[owner_id]
           ,[last_updated]
			)
VALUES (
	'Cfg Vaccine Schedule',
	'Config Object',
	'Cfg Vaccine Schedule',
	'ClientModule',
	'Config Object Component',
	'Client',
	'Config Object',
	'Vaccine Schedule Config Object',
	1,
	'{574BEF11-C706-4702-9605-B22A9D771C77}',
	'OK',
	0,
	getdate()
	)
GO

DELETE FROM [dbo].[c_Component_Version]
WHERE component_id = 'Cfg Vaccine Schedule'
GO

INSERT INTO [dbo].[c_Component_Version]
	([component_id]
	,[version]
	,[description]
	,[component_type]
	,[component_class]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[release_status]
	,[release_status_date_time]
	,[min_build]
	,[min_modification_level]
	,[id]
	,[installer]
	,[independence]
	,[system_id]
	,[build]
	,[build_name]
	,[compile]
	,[compile_name]
	,[last_updated]
	)
VALUES (
	'Cfg Vaccine Schedule',
	1,	
	'Vaccine Schedule Config Object',
	'Config Object',
	'u_component_config_object_vaccine_schedule',
	0,
	getdate(),
	'#SYSTEM',
	'OK',
	getdate(),
	'Production',
	'1/1/2011',
	50000,
	200,
	'{F9BA33D6-CB40-418D-82B7-80594D68240E}',
	'BuiltIn',
	'Single',
	'Cfg Vaccine Schedule',
	0,
	'1',
	1,
	'1.1',
	getdate()
	)
GO

-----------------------------------------------------------------------
-----------------------------------------------------------------------

UPDATE t
SET object_component_id = 'Cfg Report'
FROM dbo.c_config_object_type t
WHERE config_object_type IN ('Datafile', 'Report')
GO

UPDATE t
SET object_component_id = 'Cfg Vaccine Schedule'
FROM dbo.c_config_object_type t
WHERE config_object_type IN ('Vaccine Schedule')
GO

UPDATE t
SET object_component_id = 'Cfg Menu'
FROM dbo.c_config_object_type t
WHERE config_object_type IN ('Menu')
GO

UPDATE t
SET object_component_id = 'Cfg Datawindow'
FROM dbo.c_config_object_type t
WHERE config_object_type IN ('Datawindow')
GO

UPDATE t
SET object_component_id = 'Cfg Controller'
FROM dbo.c_config_object_type t
WHERE config_object_type IN ('Controller')
GO


-------------------------------------------------------------------------------
-- New Controller Config Service
-------------------------------------------------------------------------------

DELETE FROM o_Service
WHERE service = 'Configure Menu'
GO

DELETE FROM o_Service_Attribute
WHERE service = 'Configure Menu'
GO

Insert into o_Service (
	service,
	description,
	button,
	icon,
	general_flag	,
	patient_flag	,
	encounter_flag	,
	assessment_flag	,
	treatment_flag	,
	observation_flag,	
	attachment_flag	,
	close_flag	,
	signature_flag	,
	owner_flag	,
	visible_flag,	
	secure_flag	,
	component_id	,
	status	,
	id	,
	owner_id	,
	last_updated	,
	definition	,
	default_expiration_time	,
	default_expiration_unit_id)
values (
	'Configure Menu',
	'Configure Menu',
	'button_menus.gif',
	'button_menus.gif',
	'Y',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'Y',
	'N',
	'SVC_Generic',
	'OK',
	'{9A943390-78E2-4869-83C0-E3CE70C39834}',
	0,
	getdate(),
	'Configure Menu',
	1,
	'DAY')
GO

INSERT INTO o_Service_Attribute (
	service,
	attribute,
	value)
VALUES (
	'Configure Menu',
	'window_class',
	'w_svc_config_menu')
GO


------------------------------------------------------------------------

UPDATE dbo.c_Config_Object_Type
SET version_control = 1,
	configuration_service = 'Configure Menu'
WHERE config_object_type = 'Menu'
GO


-------------------------------------------------------------------------------
-- New Datawindow Display Service
-------------------------------------------------------------------------------

DELETE FROM o_Service
WHERE service = 'Show Datawindow'
GO

DELETE FROM o_Service_Attribute
WHERE service = 'Show Datawindow'
GO

Insert into o_Service (
	service,
	description,
	button,
	icon,
	general_flag	,
	patient_flag	,
	encounter_flag	,
	assessment_flag	,
	treatment_flag	,
	observation_flag,	
	attachment_flag	,
	close_flag	,
	signature_flag	,
	owner_flag	,
	visible_flag,	
	secure_flag	,
	component_id	,
	status	,
	id	,
	owner_id	,
	last_updated	,
	definition	,
	default_expiration_time	,
	default_expiration_unit_id)
values (
	'Show Datawindow',
	'Show Datawindow',
	'button17.bmp',
	'button17.bmp',
	'Y',
	'Y',
	'Y',
	'Y',
	'Y',
	'Y',
	'Y',
	'N',
	'N',
	'N',
	'Y',
	'N',
	'SVC_Generic',
	'OK',
	'{FAA1FCB3-0A6A-416B-B8BF-8A80AA7060B2}',
	0,
	getdate(),
	'Show Datawindow',
	1,
	'DAY')
GO

INSERT INTO o_Service_Attribute (
	service,
	attribute,
	value)
VALUES (
	'Show Datawindow',
	'window_class',
	'w_svc_datawindow')
GO

-------------------------------------------------------------------------------
-- New Database Config Service
-------------------------------------------------------------------------------

DELETE FROM o_Service
WHERE service = 'Configure Database'
GO

DELETE FROM o_Service_Attribute
WHERE service = 'Configure Database'
GO

Insert into o_Service (
	service,
	description,
	button,
	icon,
	general_flag	,
	patient_flag	,
	encounter_flag	,
	assessment_flag	,
	treatment_flag	,
	observation_flag,	
	attachment_flag	,
	close_flag	,
	signature_flag	,
	owner_flag	,
	visible_flag,	
	secure_flag	,
	component_id	,
	status	,
	id	,
	owner_id	,
	last_updated	,
	definition	,
	default_expiration_time	,
	default_expiration_unit_id)
values (
	'Configure Database',
	'Configure Database',
	'button_data_server.bmp',
	'button_data_server.bmp',
	'Y',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'N',
	'Y',
	'N',
	'SVC_Generic',
	'OK',
	'{994EC745-CBF4-4471-A430-6EF927D51955}',
	0,
	getdate(),
	'Configure Database',
	1,
	'DAY')
GO

INSERT INTO o_Service_Attribute (
	service,
	attribute,
	value)
VALUES (
	'Configure Database',
	'window_class',
	'w_svc_config_database')
GO

