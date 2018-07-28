CREATE PROCEDURE sp_new_patient_address (
	@ps_cpr_id varchar(12),
	@ps_description varchar(40),
	@ps_address_line_1 varchar(40) = NULL,
	@ps_address_line_2 varchar(40) = NULL,
	@ps_city varchar(40) = NULL,
	@ps_state varchar(2) = NULL,
	@ps_zip varchar(10) = NULL,
	@ps_country varchar(2) = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ll_owner_id int,
		@ll_count int,
		@ll_error int,
		@ll_rowcount int,
		@ls_current_address_line_1 varchar(40) ,
		@ls_current_address_line_2 varchar(40) ,
		@ls_current_city varchar(40) ,
		@ls_current_state varchar(2) ,
		@ls_current_zip varchar(10) ,
		@ls_current_country varchar(2) 

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- The caller must specify an actor class
IF @ps_cpr_id IS NULL
	BEGIN
	RAISERROR ('No cpr_id specified',16,-1)
	RETURN
	END

-- Set the default description
IF @ps_description IS NULL
	SET @ps_description = 'Address'

-- Make sure this address represents a change to what we already have
SELECT @ls_current_address_line_1 = address_line_1,
		@ls_current_address_line_2 = address_line_2,
		@ls_current_city = city,
		@ls_current_state = state,
		@ls_current_zip = zip,
		@ls_current_country = country
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('cpr_id not found (%s)',16,-1, @ps_cpr_id)
	RETURN
	END

IF ISNULL(@ls_current_address_line_1, '!NULL') <> ISNULL(@ps_address_line_1, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'address_line_1',
		@ps_progress = @ps_address_line_1,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_address_line_2, '!NULL') <> ISNULL(@ps_address_line_2, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'address_line_2',
		@ps_progress = @ps_address_line_2,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_city, '!NULL') <> ISNULL(@ps_city, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'city',
		@ps_progress = @ps_city,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_state, '!NULL') <> ISNULL(@ps_state, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'state',
		@ps_progress = @ps_state,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_zip, '!NULL') <> ISNULL(@ps_zip, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'zip',
		@ps_progress = @ps_zip,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

IF ISNULL(@ls_current_country, '!NULL') <> ISNULL(@ps_country, '!NULL')
	EXECUTE dbo.sp_Set_Patient_Progress
		@ps_cpr_id = @ps_cpr_id,
		@ps_progress_type = 'Modify',
		@ps_progress_key = 'country',
		@ps_progress = @ps_country,
		@ps_user_id = @ps_created_by,
		@ps_created_by = @ps_created_by

