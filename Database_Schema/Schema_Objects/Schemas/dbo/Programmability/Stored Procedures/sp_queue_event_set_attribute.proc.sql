/****** Object:  Stored Procedure dbo.sp_queue_event_set_attribute    Script Date: 7/25/2000 8:44:03 AM ******/
/****** Object:  Stored Procedure dbo.sp_queue_event_set_attribute    Script Date: 2/16/99 12:01:04 PM ******/
CREATE PROCEDURE sp_queue_event_set_attribute (
	@pl_event_id integer,
	@ps_attribute varchar(64),
	@ps_value varchar(255))
AS
DECLARE @li_attribute_sequence smallint
UPDATE o_Event_Queue_Attribute
SET value = @ps_value
WHERE event_id = @pl_event_id
AND attribute = @ps_attribute
IF @@ROWCOUNT <> 1
	BEGIN
	SELECT @li_attribute_sequence = max(attribute_sequence)
	FROM o_Event_Queue_Attribute
	WHERE event_id = @pl_event_id
	IF @li_attribute_sequence is null
		SELECT @li_attribute_sequence = 1
	ELSE
		SELECT @li_attribute_sequence = @li_attribute_sequence + 1
	INSERT INTO o_Event_Queue_Attribute (
		event_id,
		attribute_sequence,
		attribute,
		value)
	VALUES (
		@pl_event_id,
		@li_attribute_sequence,
		@ps_attribute,
		@ps_value)
	END

