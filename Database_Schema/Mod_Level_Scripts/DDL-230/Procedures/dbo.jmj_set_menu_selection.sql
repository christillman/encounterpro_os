
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_set_menu_selection]
Print 'Drop Procedure [dbo].[jmj_set_menu_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_menu_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_menu_selection]
GO

-- Create Procedure [dbo].[jmj_set_menu_selection]
Print 'Create Procedure [dbo].[jmj_set_menu_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_set_menu_selection (
	@ps_menu_context varchar(12),
	@ps_menu_key varchar(64),
	@ps_office_id varchar(4) = NULL,
	@ps_user_id varchar(24) = NULL,
	@pl_menu_id int)
AS

DECLARE @ll_rowcount int,
		@ll_error int

IF @pl_menu_id IS NULL
	BEGIN
	DELETE o_Menu_Selection
	WHERE menu_context = @ps_menu_context
	AND menu_key = @ps_menu_key
	AND ISNULL(office_id, '!NUL') = ISNULL(@ps_office_id, '!NUL')
	AND ISNULL(user_id, '!NULL') = ISNULL(@ps_user_id, '!NULL')

	RETURN
	END
ELSE
	BEGIN
	UPDATE o_Menu_Selection
	SET menu_id = @pl_menu_id
	WHERE menu_context = @ps_menu_context
	AND menu_key = @ps_menu_key
	AND ISNULL(office_id, '!NUL') = ISNULL(@ps_office_id, '!NUL')
	AND ISNULL(user_id, '!NULL') = ISNULL(@ps_user_id, '!NULL')

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
	END


IF @ll_error <> 0
	RETURN

IF @ll_rowcount > 0
	RETURN

INSERT INTO o_Menu_Selection (
	menu_context,
	menu_key,
	office_id,
	user_id,
	menu_id)
VALUES (
	@ps_menu_context,
	@ps_menu_key,
	@ps_office_id,
	@ps_user_id,
	@pl_menu_id)

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_menu_selection]
	TO [cprsystem]
GO

