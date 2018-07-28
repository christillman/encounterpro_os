

CREATE FUNCTION fn_current_epro_user ( )

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_logged_in_user_id varchar(24)

SET @ls_logged_in_user_id = (SELECT logged_in_user_id FROM dbo.fn_current_epro_user_context())

RETURN @ls_logged_in_user_id 

END
