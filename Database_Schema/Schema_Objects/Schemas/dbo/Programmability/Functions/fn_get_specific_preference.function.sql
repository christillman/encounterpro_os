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

-- See if there's a user preference
SELECT @ls_preference_value = preference_value
FROM o_preferences
WHERE preference_type = @ps_preference_type
AND preference_level = @ps_preference_level
AND preference_key = @ps_preference_key
AND preference_id = @ps_preference_id


RETURN @ls_preference_value

END


