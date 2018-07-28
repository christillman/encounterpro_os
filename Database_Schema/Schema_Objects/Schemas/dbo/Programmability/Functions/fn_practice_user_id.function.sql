CREATE FUNCTION fn_practice_user_id()
RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_practice_user_id varchar(24)

SET @ls_practice_user_id = NULL

SELECT @ls_practice_user_id = [user_id]
FROM c_User u
	CROSS JOIN c_Database_Status s
WHERE u.actor_class = 'Practice'
AND u.owner_id = s.customer_id


RETURN @ls_practice_user_id

END


