CREATE PROCEDURE jmj_new_maintenance_schedule (
	@ps_user_id varchar(24),
	@ps_service varchar(24),
	@ps_schedule_type varchar(24),
	@ps_schedule_interval varchar(40),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_service_sequence int,
		@ll_error int,
		@ll_rowcount int

INSERT INTO o_Service_Schedule (
	user_id,
	service,
	schedule_type,
	schedule_interval,
	created_by,
	status )
VALUES (
	@ps_user_id,
	@ps_service,
	@ps_schedule_type,
	@ps_schedule_interval,
	@ps_created_by,
	'NA' )

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	RETURN -1
	END

SET @ll_service_sequence = SCOPE_IDENTITY()

RETURN @ll_service_sequence

