CREATE PROCEDURE sp_count_patient_messages (
	@ps_cpr_id varchar(24),
	@pi_message_count smallint OUTPUT,
	@pi_todo_count smallint OUTPUT )
AS

SELECT @pi_message_count = count(*)
FROM p_Patient_WP_item (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND ordered_service = 'MESSAGE'

SELECT @pi_todo_count = count(*)
FROM p_Patient_WP_item (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND ordered_service <> 'MESSAGE'
AND active_service_flag = 'Y'

