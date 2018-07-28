/****** Object:  Stored Procedure dbo.sp_queue_event_set_ready    Script Date: 7/25/2000 8:44:04 AM ******/
/****** Object:  Stored Procedure dbo.sp_queue_event_set_ready    Script Date: 2/16/99 12:01:04 PM ******/
CREATE PROCEDURE sp_queue_event_set_ready (
	@pl_event_id integer)
AS
UPDATE o_Event_Queue
SET event_status = 'READY'
WHERE event_id = @pl_event_id

