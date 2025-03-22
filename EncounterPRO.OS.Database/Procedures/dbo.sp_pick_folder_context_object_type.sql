
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_pick_folder_context_object_type]
Print 'Drop Procedure [dbo].[sp_pick_folder_context_object_type]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_pick_folder_context_object_type]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_pick_folder_context_object_type]
GO

-- Create Procedure [dbo].[sp_pick_folder_context_object_type]
Print 'Create Procedure [dbo].[sp_pick_folder_context_object_type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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

IF @ls_context_object IS NULL
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
GO
GRANT EXECUTE
	ON [dbo].[sp_pick_folder_context_object_type]
	TO [cprsystem]
GO

