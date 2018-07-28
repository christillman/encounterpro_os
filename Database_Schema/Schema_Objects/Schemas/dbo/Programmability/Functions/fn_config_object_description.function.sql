CREATE FUNCTION fn_config_object_description (
	@pui_config_object_id uniqueidentifier)

RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_description varchar(80)

IF @pui_config_object_id IS NOT NULL
	BEGIN
	SELECT @ls_description = object_type_prefix + ': ' + description
	FROM dbo.fn_object_info(@pui_config_object_id)

	IF @@ROWCOUNT = 1
		RETURN @ls_description
	END

SET @ls_description = NULL

RETURN @ls_description
END
