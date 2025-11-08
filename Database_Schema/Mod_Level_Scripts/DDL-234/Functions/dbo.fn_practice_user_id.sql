
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_practice_user_id]
Print 'Drop Function [dbo].[fn_practice_user_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_practice_user_id]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_practice_user_id]
GO

-- Create Function [dbo].[fn_practice_user_id]
Print 'Create Function [dbo].[fn_practice_user_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_practice_user_id()
RETURNS varchar(255)

AS
BEGIN

DECLARE @ls_practice_user_id varchar(255)

SET @ls_practice_user_id = NULL

SELECT @ls_practice_user_id = [user_id]
FROM c_User u
	CROSS JOIN c_Database_Status s
WHERE u.actor_class = 'Practice'
AND u.owner_id = s.customer_id


RETURN @ls_practice_user_id

END


GO
GRANT EXECUTE
	ON [dbo].[fn_practice_user_id]
	TO [cprsystem]
GO

