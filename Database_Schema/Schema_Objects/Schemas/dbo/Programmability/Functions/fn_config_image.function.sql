CREATE FUNCTION dbo.fn_config_image (
	@pui_config_object_id uniqueidentifier
	)
RETURNS xml

AS
BEGIN

DECLARE @lx_xml xml,
		@lx_objectdata xml,
		@ls_config_object_type varchar(24),
		@ll_version int


SELECT @ls_config_object_type = config_object_type,
		@ll_version = installed_version
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

SET @lx_objectdata = NULL

IF @ls_config_object_type = 'Vaccine Schedule'
	SET @lx_objectdata = dbo.fn_config_image_vaccine_schedule()


SET @lx_xml = CONVERT(xml, '<EPConfigObjects ObjectEncodingMethod="SQL">
' + (SELECT 	[config_object_id] ,
				[config_object_type] ,
				[context_object] ,
				[description] ,
				[long_description] ,
				[config_object_category] ,
				[owner_id] ,
				[owner_description] ,
				[created] ,
				[created_by] ,
				[status] ,
				[copyright_status] ,
				[copyable]
	FROM c_Config_Object
	WHERE config_object_id = @pui_config_object_id
	FOR XML RAW ('ConfigObject'))
+ '
' + (SELECT 	[config_object_id] ,
				[version] ,
				[description] ,
				[version_description] ,
				[config_object_type] ,
				[owner_id] ,
				[created] ,
				[created_by] ,
				[created_from_version] ,
				[status] ,
				[status_date_time] ,
				[release_status] ,
				[release_status_date_time] ,
				[object_encoding_method]
	FROM c_Config_Object_Version
	WHERE config_object_id = @pui_config_object_id
	AND version = @ll_version
	FOR XML RAW ('ConfigObjectVersion'))
+ CAST(@lx_objectdata AS varchar(max))
+ '
</EPConfigObjects>')



RETURN @lx_xml

END


