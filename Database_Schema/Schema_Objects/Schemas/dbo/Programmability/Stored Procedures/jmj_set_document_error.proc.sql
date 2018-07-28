CREATE PROCEDURE jmj_set_document_error (
	@pl_patient_workplan_item_id int,
	@ps_operation varchar(12),
	@ps_user_id varchar(24),
	@pl_computer_id int = NULL )
AS

DECLARE 	@ls_temp varchar(255),
			@ll_max_retries int,
			@ll_retries int,
			@ls_progress_type varchar(24)

SET @ls_progress_type = @ps_operation + ' Error'

EXECUTE sp_set_workplan_item_progress
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_user_id = @ps_user_id,
	@ps_progress_type = @ls_progress_type,
	@pdt_progress_date_time = NULL,
	@ps_created_by = @ps_user_id,
	@pl_computer_id = @pl_computer_id

SET @ls_temp = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'document_max_retries')
IF @ls_temp IS NULL
	SET @ls_temp = dbo.fn_get_global_preference('SYSTEM', 'document_max_retries_default')

IF ISNUMERIC(@ls_temp) > 0
	SET @ll_max_retries = CAST(@ls_temp AS int)

IF @ll_max_retries IS NULL OR @ll_max_retries <= 0
	SET @ll_max_retries = 5

-- If we've reached our max retries then change the owner to the exception handler
SELECT @ll_retries = retries
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_retries >= @ll_max_retries OR @ps_operation = 'Mapping'
	BEGIN
	EXECUTE sp_set_workplan_item_progress
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@ps_progress_type = 'Error',
		@pdt_progress_date_time = NULL,
		@ps_created_by = @ps_user_id,
		@pl_computer_id = @pl_computer_id

	IF @ps_operation = 'Mapping'
		EXECUTE sp_add_workplan_item_attribute
			@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
			@ps_attribute = 'error_message',
			@ps_value = 'Failed Mappings',
			@ps_user_id = @ps_user_id,
			@ps_created_by = @ps_user_id
	END
ELSE
	UPDATE p_Patient_WP_Item
	SET retries = ISNULL(@ll_retries, 0) + 1
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
