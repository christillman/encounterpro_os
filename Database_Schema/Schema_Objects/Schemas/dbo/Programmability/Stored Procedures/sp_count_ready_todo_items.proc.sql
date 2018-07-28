CREATE PROCEDURE sp_count_ready_todo_items (
	@ps_user_id varchar(24),
	@ps_in_office_flag char(1)
	)
AS

DECLARE @ll_count int

SELECT @ll_count = count(*)
FROM p_Patient_WP_Item
WHERE owned_by = @ps_user_id
AND in_office_flag = @ps_in_office_flag
AND active_service_flag = 'Y'
AND (@ps_user_id = '!Exception' OR ordered_service <> 'MESSAGE')

RETURN @ll_count
