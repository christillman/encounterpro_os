CREATE FUNCTION fn_user_property (
	@ps_user_id varchar(24),
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_property varchar(255),
		@ll_progress_sequence int

SELECT @ll_progress_sequence = max(user_progress_sequence)
FROM c_User_Progress
WHERE user_id = @ps_user_id
AND progress_type = @ps_progress_type
AND progress_key = @ps_progress_key
AND current_flag = 'Y'

SELECT @ls_property = COALESCE(progress_value, CAST(progress as varchar(255)))
FROM c_User_Progress
WHERE user_id = @ps_user_id
AND user_progress_sequence = @ll_progress_sequence

RETURN @ls_property 

END
