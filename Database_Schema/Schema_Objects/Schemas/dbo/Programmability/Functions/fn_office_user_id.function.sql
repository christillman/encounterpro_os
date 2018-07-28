CREATE FUNCTION fn_office_user_id (
	@ps_office_id varchar(4)
	)

RETURNS varchar(24)

AS

BEGIN
DECLARE @ls_office_user_id varchar(24)

SELECT @ls_office_user_id = min(user_id)
FROM c_User
WHERE office_id = @ps_office_id
AND actor_class = 'Office'

RETURN @ls_office_user_id

END


