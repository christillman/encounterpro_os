/****** Object:  Stored Procedure dbo.sp_log_message    Script Date: 7/25/2000 8:43:58 AM ******/
/****** Object:  Stored Procedure dbo.sp_log_message    Script Date: 2/16/99 12:00:58 PM ******/
CREATE PROCEDURE sp_log_message (
	@pl_subscription_id int,
	@ps_message_type varchar(24),
	@pl_message_size int,
	@ps_status varchar(12),
	@ps_direction char(1),
	@pl_message_id int OUTPUT )
AS
INSERT INTO o_Message_Log (
	subscription_id,
	message_type,
	message_size,
	direction,
	status )
VALUES (
	@pl_subscription_id,
	@ps_message_type,
	@pl_message_size,
	@ps_direction,
	@ps_status )
SELECT @pl_message_id = @@IDENTITY

