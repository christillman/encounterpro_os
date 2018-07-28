CREATE PROCEDURE sp_queue_event (
	@ps_event varchar(24),
	@pdt_start_date datetime = NULL,
	@pl_event_id integer OUTPUT )
AS

IF @pdt_start_date IS NULL
	SELECT @pdt_start_date = getdate()

INSERT INTO o_Event_Queue (
	event,
	event_date_time,
	start_date_time,
	event_status)
VALUES (
	@ps_event,
	getdate(),
	@pdt_start_date,
	'NOTREADY')
SELECT @pl_event_id = @@IDENTITY

