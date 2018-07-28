CREATE TRIGGER tr_o_event_queue_delete ON dbo.o_Event_Queue
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DELETE FROM o_Event_Queue_Attribute
FROM deleted
WHERE deleted.event_id = o_Event_Queue_Attribute.event_id
