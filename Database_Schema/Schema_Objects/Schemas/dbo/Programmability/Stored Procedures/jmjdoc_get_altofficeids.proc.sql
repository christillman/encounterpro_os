CREATE PROCEDURE jmjdoc_get_altofficeids (
	@ps_office_id Varchar(24)
	)
AS

DECLARE @ls_user_id varchar(24)

select @ls_user_id = user_id
FROM c_User WITH (NOLOCK)
WHERE office_id = @ps_office_id
AND actor_class = 'Office'

-- Filter the alternate ID's to identify the user.

SELECT COALESCE(progress_value,progress) as altidvalue,
	progress_key as altid
FROM c_User_Progress WITH (NOLOCK)
Where user_id=@ls_user_id
and progress_type = 'ID'
and current_flag = 'Y'


