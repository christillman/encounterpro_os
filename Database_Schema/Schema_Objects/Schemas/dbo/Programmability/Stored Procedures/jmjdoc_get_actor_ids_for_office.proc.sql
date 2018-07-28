CREATE PROCEDURE jmjdoc_get_actor_ids_for_office (
	@ps_office_id Varchar(24)
	)
AS

DECLARE @ls_user_id varchar(24)

SET @ls_user_id = dbo.fn_office_user_id(@ps_office_id)

EXECUTE jmjdoc_get_actor_ids
	@ps_user_id = @ls_user_id


