CREATE FUNCTION fn_config_object_context_object (
	@pui_config_object_id uniqueidentifier)

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_context_object varchar(24)

-- First see if it's in the c_Config_Object table
SELECT @ls_context_object = context_object
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

IF @@ROWCOUNT = 1
	RETURN @ls_context_object

-- See if it's a report
SELECT @ls_context_object = report_type
FROM c_Report_Definition
WHERE report_id = @pui_config_object_id

IF @@ROWCOUNT = 1
	RETURN @ls_context_object

SET @ls_context_object = NULL

RETURN @ls_context_object
END
