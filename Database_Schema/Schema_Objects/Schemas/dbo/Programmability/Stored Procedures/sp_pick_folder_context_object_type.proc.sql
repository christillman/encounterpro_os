CREATE PROCEDURE sp_pick_folder_context_object_type (
		@ps_folder varchar(40) = NULL)	
AS

DECLARE @ls_context_object varchar(24),
		@ls_context_object_type varchar(40)

DECLARE @types TABLE (
	context_object_type varchar(40) NOT NULL,
	description varchar(80) NOT NULL)

SELECT @ls_context_object = context_object,
		@ls_context_object_type = context_object_type
FROM c_Folder
WHERE folder = @ps_folder

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('No such folder (%s)',16,-1, @ps_folder)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ls_context_object_type IS NOT NULL
	BEGIN
	INSERT INTO @types (
		context_object_type,
		description)
	VALUES (
		@ls_context_object_type,
		dbo.fn_context_object_type_description(@ls_context_object, @ls_context_object_type)
			)
	END
ELSE
	BEGIN
	INSERT INTO @types (
		context_object_type,
		description)
	SELECT DISTINCT context_object_type,
					dbo.fn_context_object_type_description(@ls_context_object, context_object_type)
	FROM c_Folder_Selection
	WHERE Folder = @ps_folder
	AND context_object = @ls_context_object
	END

SELECT context_object_type,
		description,
		selected_flag=0
FROM @types
