CREATE PROCEDURE jmj_set_service_error (
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24),
	@ps_manual_service_flag char(1) = 'N',
	@pl_computer_id int = NULL )
AS

DECLARE 	@ls_temp varchar(255),
			@ll_max_retries int,
			@ll_retries int

EXECUTE sp_set_workplan_item_progress
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_user_id = @ps_user_id,
	@ps_progress_type = 'Error',
	@pdt_progress_date_time = NULL,
	@ps_created_by = @ps_created_by,
	@pl_computer_id = @pl_computer_id

SET @ls_temp = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'max_retries')
IF @ls_temp IS NULL
	SET @ls_temp = dbo.fn_get_global_preference('SYSTEM', 'service_max_retries_default')

IF ISNUMERIC(@ls_temp) > 0
	SET @ll_max_retries = CAST(@ls_temp AS int)

IF @ll_max_retries IS NULL OR @ll_max_retries <= 0
	SET @ll_max_retries = 5

-- If this is a manual service OR this is the #MAINTENANCE user, then cancel the service outright so there are no retries
IF @ps_manual_service_flag = 'Y' OR @ps_user_id = '#MAINTENANCE'
	BEGIN
	EXECUTE sp_set_workplan_item_progress
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@ps_progress_type = 'Cancelled',
		@pdt_progress_date_time = NULL,
		@ps_created_by = @ps_created_by,
		@pl_computer_id = @pl_computer_id
	END
ELSE
	BEGIN
	-- If we've reached our max retries then change the owner to the exception handler
	
	SELECT @ll_retries = retries
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	
	IF @ll_retries >= @ll_max_retries
		BEGIN
		EXECUTE sp_set_workplan_item_progress
			@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
			@ps_user_id = '!Exception',
			@ps_progress_type = 'Change Owner',
			@pdt_progress_date_time = NULL,
			@ps_created_by = @ps_created_by,
			@pl_computer_id = @pl_computer_id
		END
	END
