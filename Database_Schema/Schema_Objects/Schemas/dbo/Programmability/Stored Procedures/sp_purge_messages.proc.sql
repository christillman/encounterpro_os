/****** Object:  Stored Procedure dbo.sp_purge_messages    Script Date: 7/25/2000 8:44:03 AM ******/
/****** Object:  Stored Procedure dbo.sp_purge_messages    Script Date: 2/16/99 12:01:04 PM ******/
CREATE PROCEDURE sp_purge_messages (
	@pdt_date datetime )
AS
DELETE FROM o_Message_Log
WHERE status IN ('SENT', 'RECEIVED')
AND message_date_time < @pdt_date

