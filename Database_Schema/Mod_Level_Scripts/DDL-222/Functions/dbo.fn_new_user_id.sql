
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_new_user_id]
Print 'Drop Function [dbo].[fn_new_user_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_new_user_id]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_new_user_id]
GO

-- Create Function [dbo].[fn_new_user_id]
Print 'Create Function [dbo].[fn_new_user_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_new_user_id (
	@pl_owner_id int,
	@ps_user_full_name varchar(64),
	@ps_proposed_user_id varchar(24) )

RETURNS varchar(24)

AS
BEGIN

DECLARE @ll_counter int,
	@ls_counter varchar(8),
	@ls_user_id_base varchar(24),
	@ls_new_user_id varchar(24)

IF @ps_proposed_user_id IS NULL OR @ps_proposed_user_id = ''
	BEGIN
	IF @pl_owner_id IS NULL
		BEGIN
--		RAISERROR ('If proposed [user_id] is not supplied then owner_id must not be null',16,-1)
		RETURN NULL
		END

	IF @pl_owner_id IS NULL
		BEGIN
--		RAISERROR ('If proposed [user_id] is not supplied then user_full_name must not be null',16,-1)
		RETURN NULL
		END

	SET @ls_new_user_id = CAST(@pl_owner_id AS varchar(8)) + '^' + CAST(@ps_user_full_name as varchar(10))
	END
ELSE
	SET @ls_new_user_id = @ps_proposed_user_id

SET @ll_counter = 0
SET @ls_user_id_base = @ls_new_user_id

WHILE EXISTS(SELECT 1 FROM c_User WHERE [user_id] = @ls_new_user_id)
	BEGIN
	SET @ll_counter = @ll_counter + 1
	IF @ll_counter > 9999
		BEGIN
--		RAISERROR ('Maximum loop counter exceeded while determining unique user_id',16,-1)
		RETURN NULL
		END
	SET @ls_counter = CAST(@ll_counter AS varchar(8))
	SET @ls_new_user_id = LEFT(@ls_user_id_base, 24 - LEN(@ls_counter) - 1) + '-' + @ls_counter
	END

RETURN @ls_new_user_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_new_user_id]
	TO [cprsystem]
GO

