

DELETE FROM o_Service
WHERE service IN ('Config_Country','Config_ID Document','Config_Locality')

INSERT
	INTO o_Service(
	service,
	description,
	button,
	icon,
	general_flag,
	component_id,
	status,
	owner_id,
	definition,
	default_expiration_time,
	default_expiration_unit_id,
	default_context_object)
VALUES
	('Config_Country',
	'Configure Countries',
	'button_wrench.bmp',
	'button_wrench.bmp',
	'Y',
	'svc_config',
	'OK',
	1,
	'Countries Configuration',
	3,
	'MONTH',
	'General');

-- select * FROM o_Service
-- WHERE service like 'Config_%' order by service

INSERT
	INTO dbo.o_Service(
	service,
	description,
	button,
	icon,
	general_flag,
	component_id,
	status,
	owner_id,
	definition,
	default_expiration_time,
	default_expiration_unit_id,
	default_context_object)
VALUES
	('Config_ID Document',
	'Configure ID Documents',
	'button_wrench.bmp',
	'button_wrench.bmp',
	'Y',
	'svc_config',
	'OK',
	1,
	'ID Document Configuration',
	3,
	'MONTH',
	'General');

INSERT
	INTO dbo.o_Service(
	service,
	description,
	button,
	icon,
	general_flag,
	component_id,
	status,
	owner_id,
	definition,
	default_expiration_time,
	default_expiration_unit_id,
	default_context_object)
VALUES
	('Config_Locality',
	'Configure Localities',
	'button_wrench.bmp',
	'button_wrench.bmp',
	'Y',
	'svc_config',
	'OK',
	1,
	'Localities Configuration',
	3,
	'MONTH',
	'General');
GO

DELETE FROM [o_Service_Attribute]
WHERE service IN ('Config_Country','Config_ID Document','Config_Locality')

INSERT INTO [o_Service_Attribute]
           ([service]
           ,[attribute]
           ,[value])
     VALUES
           ('Config_Country'
           ,'window_class'
           ,'w_pick_list_members')

INSERT INTO [o_Service_Attribute]
           ([service]
           ,[attribute]
           ,[value])
     VALUES
           ('Config_ID Document'
           ,'window_class'
           ,'w_pick_list_members')

INSERT INTO [o_Service_Attribute]
           ([service]
           ,[attribute]
           ,[value])
     VALUES
           ('Config_Locality'
           ,'window_class'
           ,'w_pick_list_members')

GO
