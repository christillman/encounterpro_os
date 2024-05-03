
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_get_specific_preference]
Print 'Drop Function [dbo].[fn_get_specific_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_get_specific_preference]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION IF EXISTS [dbo].[fn_get_specific_preference]
GO

-- Create Function [dbo].[fn_get_specific_preference]
Print 'Create Function [dbo].[fn_get_specific_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_get_specific_preference (
	@ps_preference_type varchar(24),
	@ps_preference_level varchar(12),
	@ps_preference_key varchar(40),
	@ps_preference_id varchar(40)
	)

RETURNS varchar(255)

AS

BEGIN

DECLARE @ls_preference_value varchar(255)

SELECT @ls_preference_value = NULL

SELECT @ls_preference_value = preference_value
FROM o_preferences
WHERE preference_type = @ps_preference_type
AND preference_level = @ps_preference_level
AND preference_key = @ps_preference_key
AND preference_id = @ps_preference_id


RETURN @ls_preference_value

END


GO
GRANT EXECUTE ON [dbo].[fn_get_specific_preference] TO [cprsystem]
GO

