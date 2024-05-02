
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_get_global_preference]
Print 'Drop Function [dbo].[fn_get_global_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_get_global_preference]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_get_global_preference]
GO

-- Create Function [dbo].[fn_get_global_preference]
Print 'Create Function [dbo].[fn_get_global_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_get_global_preference (
	@ps_preference_type varchar(24),
	@ps_preference_id varchar(40)
	)

RETURNS varchar(255)

AS

BEGIN
/* 7.2.1.9: eliminate unused call to c_Database_Status */

DECLARE @ls_preference_value varchar(255),
		@ls_universal_flag char(1),
		@ll_error int,
		@ll_rowcount int

SET @ls_preference_value = NULL

/* Because universal_flag is inoperative (no Epro_Updates),
	and the results are the same for either 'N' or 'C',
	simplify the logic 
	*/

SELECT @ls_preference_value = preference_value
FROM o_preferences
WHERE preference_type = @ps_preference_type
AND preference_level = 'Global'
AND preference_key = 'Global'
AND preference_id = @ps_preference_id

/*

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value
END


SELECT @ls_universal_flag = universal_flag
FROM c_Preference
WHERE preference_id = @ps_preference_id

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value

IF @ll_rowcount = 0
	SET @ls_universal_flag = 'N'

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR
		
IF @ll_error <> 0
	RETURN @ls_preference_value

IF @ll_rowcount = 0
	RETURN @ls_preference_value



IF @ls_universal_flag = 'N'
	BEGIN
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_type = @ps_preference_type
	AND preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN @ls_preference_value
	END

IF @ls_universal_flag = 'C'
	BEGIN
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_type = @ps_preference_type
	AND preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

	SELECT @ll_rowcount = @@ROWCOUNT,
			@ll_error = @@ERROR
			
	IF @ll_error <> 0
		RETURN @ls_preference_value
	END
*/
/* This always returns null due to missing Epro_Updates (fn_get_universal_preference) */
/*
IF @ls_universal_flag = 'Y' OR (@ls_universal_flag = 'C' AND @ls_preference_value IS NULL)
	BEGIN
	SET @ls_preference_value = dbo.fn_get_universal_preference(@ps_preference_id)

	IF @ls_universal_flag = 'C' AND @ls_preference_value IS NOT NULL
		BEGIN
		-- We got a value from the Epro Server so cache it locally
		EXECUTE sp_set_preference
			@ps_preference_type = @ps_preference_type,
			@ps_preference_level = 'Global',
			@ps_preference_key = 'Global',
			@ps_preference_id = @ps_preference_id,
			@ps_preference_value = @ls_preference_value
		
		END
	END
*/

RETURN @ls_preference_value

END


GO
GRANT EXECUTE ON [dbo].[fn_get_global_preference] TO [cprsystem]
GO

