CREATE PROCEDURE sp_new_patient_communication (
	@ps_cpr_id varchar(12),
	@ps_communication_type varchar(24) = NULL,
	@ps_communication_value varchar(80) = NULL,
	@ps_note varchar(80) = NULL,
	@ps_created_by varchar(24),
	@ps_communication_name varchar(24) = NULL )
AS

DECLARE @ll_owner_id int,
		@ll_count int,
		@ls_progress_type varchar(24),
		@ls_current_value varchar(80)

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @ps_cpr_id IS NULL
	BEGIN
	RAISERROR ('No cpr_id specified',16,-1)
	RETURN
	END

-- Check to see if we have enough information
IF @ps_communication_type IS NULL
	BEGIN
	RAISERROR ('No communication type specified',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ps_communication_name IS NULL
	SET @ps_communication_name = @ps_communication_type

SET @ls_progress_type = 'Communication ' + @ps_communication_type

SELECT @ls_current_value = COALESCE(progress_value, CAST(progress AS varchar(80)))
FROM p_Patient_Progress
WHERE cpr_id = @ps_cpr_id
AND progress_type = @ls_progress_type
AND progress_key = @ps_communication_name
AND current_flag = 'Y'

IF ISNULL(@ls_current_value, '!NULL') = ISNULL(@ps_communication_value, '!NULL')
	RETURN


EXECUTE dbo.sp_Set_Patient_Progress
	@ps_cpr_id = @ps_cpr_id,
	@ps_progress_type = @ls_progress_type,
	@ps_progress_key = @ps_communication_name,
	@ps_progress = @ps_communication_value,
	@ps_user_id = @ps_created_by,
	@ps_created_by = @ps_created_by

