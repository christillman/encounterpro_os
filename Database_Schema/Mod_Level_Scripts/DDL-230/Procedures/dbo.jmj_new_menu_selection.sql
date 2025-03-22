
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_menu_selection]
Print 'Drop Procedure [dbo].[jmj_new_menu_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_menu_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_menu_selection]
GO

-- Create Procedure [dbo].[jmj_new_menu_selection]
Print 'Create Procedure [dbo].[jmj_new_menu_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_menu_selection
	(
	@pl_menu_id int,
	@ps_office_id varchar(4) = NULL,
	@ps_menu_context varchar(12),
	@ps_menu_key varchar(64) = NULL,
	@ps_user_id varchar(24) = NULL
	)
AS

DECLARE @ll_owner_id int,
		@ll_room_menu_selection_id int

IF @pl_menu_id IS NULL
	BEGIN
	RAISERROR ('menu_id cannot be null',16,-1)
	RETURN -1
	END

IF @ps_menu_context IS NULL
	BEGIN
	RAISERROR ('menu_context cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_owner_id = customer_id
FROM dbo.c_database_status

SELECT @ll_room_menu_selection_id = min(room_menu_selection_id)
FROM dbo.o_menu_selection
WHERE menu_context = @ps_menu_context
AND ISNULL(office_id, '!NULL') = @ps_office_id
AND ISNULL(menu_key, '!NULL') = @ps_menu_key
AND ISNULL(user_id, '!NULL') = @ps_user_id
AND status = 'OK'

IF @@ERROR <> 0
	RETURN

IF @ll_room_menu_selection_id > 0
	UPDATE dbo.o_menu_selection
	SET menu_id = @pl_menu_id
	WHERE room_menu_selection_id = @ll_room_menu_selection_id
ELSE
	BEGIN
	INSERT INTO dbo.o_menu_selection
		(office_id
		,menu_context
		,menu_key
		,user_id
		,menu_id
		,sort_sequence
		,owner_id
		,status)
	VALUES (
		@ps_office_id,
		@ps_menu_context,
		@ps_menu_key,
		@ps_user_id,
		@pl_menu_id,
		1,
		@ll_owner_id,
		'OK')

	SET @ll_room_menu_selection_id = SCOPE_IDENTITY()
	END

RETURN @ll_room_menu_selection_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_menu_selection]
	TO [cprsystem]
GO

