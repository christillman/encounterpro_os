CREATE PROCEDURE sp_set_message_status
	(
	@ps_id varchar(40),
	@ps_message_type varchar(24),
	@ps_status varchar(12),
	@ps_comments varchar(1024),
	@ps_created_by varchar(24)
	)
AS

DECLARE @lu_id uniqueidentifier

SET @lu_id = CAST(@ps_id AS uniqueidentifier)

UPDATE o_Message_Log
SET status = @ps_status,
	comments = @ps_comments
WHERE id = @lu_id
AND message_type = @ps_message_type


