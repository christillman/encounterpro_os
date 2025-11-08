
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_lookup_user_IDValue]
Print 'Drop Function [dbo].[fn_lookup_user_IDValue]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_user_IDValue]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_user_IDValue]
GO

-- Create Function [dbo].[fn_lookup_user_IDValue]
Print 'Create Function [dbo].[fn_lookup_user_IDValue]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_lookup_user_IDValue (
	@pl_owner_id int,
	@ps_IDDomain varchar(40),
	@ps_IDValue varchar(255) )

RETURNS varchar(255)

AS
BEGIN

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40),
	@ll_customer_id int,
	@ls_user_id varchar(255)

SET @ls_user_id = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain

-- If the progress_key is 'ID' then first look for the user in the c_User table
IF @ls_progress_key = 'ID'
	SELECT @ls_user_id = user_id
	FROM c_User
	WHERE ID = @ls_progress_key

IF @ls_user_id IS NULL
	BEGIN
	SELECT @ll_length = LEN(@ps_IDValue)

	IF @ll_length <= 40
		BEGIN

		SELECT @ls_progress_value = CONVERT(varchar(40), @ps_IDValue)

		SELECT TOP 1 @ls_user_id = [user_id]
		FROM c_User_Progress
		WHERE progress_type = 'ID'
		AND progress_key = @ls_progress_key
		AND progress_value = @ls_progress_value
		AND current_flag = 'Y'
		END
	ELSE
		SELECT TOP 1 @ls_user_id = [user_id]
		FROM c_User_Progress
		WHERE progress_type = 'ID'
		AND progress_key = @ls_progress_key
		AND CAST(progress AS varchar(255)) = @ps_IDValue
		AND current_flag = 'Y'
	END


RETURN @ls_user_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_user_IDValue]
	TO [cprsystem]
GO

