CREATE PROCEDURE jmjdoc_get_altuserids (
	@ps_user_id Varchar(24)
	)
AS

-- Filter the alternate ID's to identify the user.

SELECT COALESCE(progress_value,progress) as altidvalue,
	progress_key as altid
FROM c_User_Progress WITH (NOLOCK)
Where user_id=@ps_user_id
and progress_type = 'ID'
and current_flag = 'Y'


