CREATE PROCEDURE jmj_new_log_message
	(
	@ps_severity varchar(12),
	@ps_caller varchar(40),
	@ps_script varchar(40),
	@ps_message varchar(255),
	@ps_log_data text = NULL,
	@ps_created_by varchar(24) = NULL
	)
AS

DECLARE @ll_computer_id int,
		@ls_system_user varchar(40),
		@ls_computername varchar(40),
		@ll_log_id int

SET @ls_system_user = SYSTEM_USER
SET @ls_computername = HOST_NAME()

-- Look up the computer_id
SET @ll_computer_id = (SELECT max(computer_id) FROM o_Computers WHERE computername = @ls_computername AND logon_id = @ls_system_user)

IF @ps_created_by IS NULL
	BEGIN
	SET @ps_created_by = dbo.fn_current_epro_user()
	IF @ps_created_by IS NULL
		SET @ps_created_by = '#SYSTEM'
	END

INSERT INTO o_Log (
	severity,
	log_date_time,
	caller,
	script,
	message,
	computer_id,
	computername,
	windows_logon_id,
	log_data,
	user_id,
	scribe_user_id)
VALUES (
	@ps_severity,
	getdate(),
	@ps_caller,
	@ps_script,
	@ps_message,
	@ll_computer_id,
	@ls_computername,
	@ls_system_user,
	@ps_log_data,
	@ps_created_by,
	@ps_created_by)


SET @ll_log_id = SCOPE_IDENTITY()

RETURN @ll_log_id

