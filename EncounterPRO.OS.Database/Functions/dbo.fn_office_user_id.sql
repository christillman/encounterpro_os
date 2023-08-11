

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_office_user_id]
Print 'Drop Function [dbo].[fn_office_user_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_office_user_id]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_office_user_id]
GO

-- Create Function [dbo].[fn_office_user_id]
Print 'Create Function [dbo].[fn_office_user_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_office_user_id (
	@ps_office_id varchar(4)
	)

RETURNS varchar(24)

AS

BEGIN
DECLARE @ls_office_user_id varchar(24)

SELECT @ls_office_user_id = IsNull(min(user_id),'No actor_class = Office')
FROM c_User
WHERE office_id = @ps_office_id
AND actor_class = 'Office'

RETURN @ls_office_user_id

END


GO
GRANT EXECUTE ON [dbo].[fn_office_user_id] TO [cprsystem]
GO

