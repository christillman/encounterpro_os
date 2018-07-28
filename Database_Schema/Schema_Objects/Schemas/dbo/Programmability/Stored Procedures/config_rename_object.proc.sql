CREATE PROCEDURE config_rename_object (
	@pui_config_object_id uniqueidentifier ,
	@ps_new_description varchar(80))
AS

DECLARE @ll_return int ,
		@ll_error int ,
		@ll_rowcount int,
		@ls_config_object_type varchar(24),
		@ls_config_object_id varchar(40)


IF @pui_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config object id',16,-1)
	RETURN -1
	END

SET @ls_config_object_type = CAST(@pui_config_object_id AS varchar(40))


-- Validate config object
SELECT @ls_config_object_type = o.config_object_type
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Cannot find config object (%s)',16,-1, @ls_config_object_type)
	RETURN -1
	END

BEGIN TRANSACTION

UPDATE o
SET description = @ps_new_description
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE v
SET description = @ps_new_description
FROM dbo.c_Config_Object_Version v
WHERE v.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ls_config_object_type = 'Report'
	BEGIN
	UPDATE r
	SET description = @ps_new_description
	FROM dbo.c_Report_Definition r
	WHERE r.report_id = @pui_config_object_id

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END

	-- If we're attaching an rtf script that was only just now created then assume that we're
	-- copying/creating an RTF report and rename the RTF script to match the report name
	UPDATE d
	SET description = r.description,
		display_script = CAST(r.description AS varchar(40))
	FROM c_Display_Script d
		INNER JOIN (SELECT report_id, display_script_id = CAST(value AS int)
					FROM dbo.c_Report_Attribute
					WHERE report_id = @pui_config_object_id
					AND attribute IN ('display_script_id', 'xml_script_id')
					AND ISNUMERIC(value) = 1
					) x
		ON d.display_script_id = x.display_script_id
		INNER JOIN c_Report_Definition r
		ON r.report_id = x.report_id
		CROSS JOIN c_Database_Status s
	WHERE s.customer_id = r.owner_id



	END

COMMIT TRANSACTION

RETURN 1

