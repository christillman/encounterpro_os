
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_get_preference]
Print 'Drop Function [dbo].[fn_get_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_get_preference]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION IF EXISTS [dbo].[fn_get_preference]
GO

-- Create Function [dbo].[fn_get_preference]
Print 'Create Function [dbo].[fn_get_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_get_preference (
	@ps_preference_type varchar(24),
	@ps_preference_id varchar(40),
	@ps_user_id varchar(40) = NULL,
	@pl_computer_id int = NULL
	)

RETURNS varchar(255)

AS

BEGIN

/* 7.2.1.9: c_Preference flags are not used 
	or returned by this procedure. The universal_flag
	preference isn't applicable to EncounterPro OS.
	*/

DECLARE @ls_preference_value varchar(255)
/* ,
		@ls_global_flag char(1),
		@ls_office_flag char(1),
		@ls_computer_flag char(1),
		@ls_specialty_flag char(1),
		@ls_user_flag char(1),
		@ls_universal_flag char(1)

SELECT @ls_preference_value = NULL

SELECT @ps_preference_type = COALESCE(@ps_preference_type, preference_type),
		@ls_global_flag = global_flag ,
		@ls_office_flag = office_flag ,
		@ls_computer_flag = computer_flag ,
		@ls_specialty_flag = specialty_flag ,
		@ls_user_flag = user_flag ,
		@ls_universal_flag = universal_flag
FROM c_Preference
WHERE preference_id = @ps_preference_id

IF @ls_universal_flag IN ('C', 'Y')
	RETURN dbo.fn_get_global_preference(@ps_preference_type, @ps_preference_id)
*/

-- See if there's a user preference
SELECT @ls_preference_value = preference_value
FROM o_preferences
WHERE preference_level = 'User'
AND preference_key = @ps_user_id
AND preference_id = @ps_preference_id

-- If not, then see if there's a specialty preference
IF @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences p
		INNER JOIN c_User u
		ON p.preference_key = u.specialty_id
	WHERE p.preference_level = 'Specialty'
	AND u.user_id = @ps_user_id
	AND p.preference_id = @ps_preference_id

-- If not, then see if there's a computer preference
IF @pl_computer_id IS NOT NULL AND @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_level = 'Computer'
	AND preference_key = CAST(@pl_computer_id AS varchar(40))
	AND preference_id = @ps_preference_id

-- If not, then see if there's an office preference
IF @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences p
		INNER JOIN o_Users u
		ON p.preference_key = u.office_id
	WHERE p.preference_level = 'Office'
	AND u.user_id = @ps_user_id
	AND p.preference_id = @ps_preference_id

-- If not, then see if there's a global preference
IF @ls_preference_value IS NULL
	SELECT @ls_preference_value = preference_value
	FROM o_preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = @ps_preference_id

RETURN @ls_preference_value

END


GO
GRANT EXECUTE ON [dbo].[fn_get_preference] TO [cprsystem]
GO

