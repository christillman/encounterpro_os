CREATE PROCEDURE jmj_set_maintenance_service_attribute (
	@pl_service_sequence int,
	@ps_attribute varchar(64),
	@ps_value varchar(255))
AS

DECLARE @ls_user_id varchar(24),
		@ll_rowcount int,
		@ll_error int

SELECT @ls_user_id = user_id
FROM o_Service_Schedule
WHERE service_sequence = @pl_service_sequence

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('Invalid service_sequence (%d)',16,-1, @pl_service_sequence)
	RETURN
	END


UPDATE o_Service_Schedule_Attribute
SET value = @ps_value
WHERE service_sequence = @pl_service_sequence
AND attribute = @ps_attribute

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount <> 1
	BEGIN
	INSERT INTO o_Service_Schedule_Attribute (
		user_id,
		service_sequence,
		attribute,
		value)
	VALUES (
		@ls_user_id,
		@pl_service_sequence,
		@ps_attribute,
		@ps_value)
	END

