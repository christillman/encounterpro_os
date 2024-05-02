
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_get_universal_preference]
Print 'Drop Function [dbo].[fn_get_universal_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_get_universal_preference]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_get_universal_preference]
GO

-- Create Function [dbo].[fn_get_universal_preference]
Print 'Create Function [dbo].[fn_get_universal_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_get_universal_preference (
	@ps_preference_id varchar(40)
	)

RETURNS varchar(255)

AS

BEGIN

DECLARE @ls_preference_value varchar(255),
		@ls_universal_flag char(1),
		@ll_customer_id int,
		@ll_error int,
		@ll_rowcount int

SELECT @ls_preference_value = NULL

--SELECT @ll_customer_id = customer_id
--FROM c_Database_Status

--SELECT @ls_preference_value = preference_value
--FROM jmjtech.EproUpdates.dbo.Epro_Preference
--WHERE preference_id = @ps_preference_id
--AND owner_id = @ll_customer_id
--AND current_flag = 'Y'

--SELECT @ll_rowcount = @@ROWCOUNT,
--		@ll_error = @@ERROR
		
--IF @ll_error <> 0
--	RETURN @ls_preference_value

--IF @ll_rowcount = 0
--	BEGIN
--	SELECT @ls_preference_value = preference_value
--	FROM jmjtech.EproUpdates.dbo.Epro_Preference
--	WHERE preference_id = @ps_preference_id
--	AND owner_id = 0
--	AND current_flag = 'Y'

--	SELECT @ll_rowcount = @@ROWCOUNT,
--			@ll_error = @@ERROR
			
--	IF @ll_error <> 0
--		RETURN @ls_preference_value
--	END

RETURN @ls_preference_value

END


GO
GRANT EXECUTE ON [dbo].[fn_get_universal_preference] TO [cprsystem]
GO

