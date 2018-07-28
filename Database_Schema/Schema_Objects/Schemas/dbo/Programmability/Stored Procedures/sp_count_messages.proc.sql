CREATE PROCEDURE sp_count_messages (
	@ps_user_id varchar(24),
	@pi_message_count smallint OUTPUT,
	@pi_todo_count smallint OUTPUT )
AS

SELECT @pi_message_count = count(*)
FROM p_Patient_WP_Item (NOLOCK)
WHERE owned_by = @ps_user_id
AND ordered_service = 'MESSAGE'
AND active_service_flag = 'Y'

SELECT @pi_todo_count = count(*)
FROM p_Patient_WP_item (NOLOCK)
WHERE owned_by = @ps_user_id
AND ordered_service <> 'MESSAGE'
AND active_service_flag = 'Y'
AND in_office_flag = 'N'

