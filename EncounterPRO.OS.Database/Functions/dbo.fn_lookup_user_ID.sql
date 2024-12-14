
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_lookup_user_ID]
Print 'Drop Function [dbo].[fn_lookup_user_ID]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_user_ID]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_user_ID]
GO

-- Create Function [dbo].[fn_lookup_user_ID]
Print 'Create Function [dbo].[fn_lookup_user_ID]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_lookup_user_ID (
	@ps_user_id varchar(24),
	@pl_owner_id int,
	@ps_IDDomain varchar(40))

RETURNS varchar(40)

AS
BEGIN

DECLARE @ll_length int,
	@ls_progress_value varchar(40),
	@ls_progress_key varchar(40)

SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain

-- If the progress_key is 'ID' then use the ID column from c_User
IF @ls_progress_key = 'ID'
	BEGIN
	SELECT @ls_progress_value = CAST(ID as varchar(40))
	FROM c_User
	WHERE [user_id] = @ps_user_id

	RETURN @ls_progress_value
	END

SELECT TOP 1 @ls_progress_value = progress_value
FROM c_User_Progress
WHERE [user_id] = @ps_user_id
AND progress_type = 'ID'
AND progress_key = @ls_progress_key
AND current_flag = 'Y'


RETURN @ls_progress_value

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_user_ID]
	TO [cprsystem]
GO

