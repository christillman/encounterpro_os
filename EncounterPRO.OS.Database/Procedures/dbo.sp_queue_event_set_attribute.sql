
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_queue_event_set_attribute]
Print 'Drop Procedure [dbo].[sp_queue_event_set_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_queue_event_set_attribute]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_queue_event_set_attribute]
GO

-- Create Procedure [dbo].[sp_queue_event_set_attribute]
Print 'Create Procedure [dbo].[sp_queue_event_set_attribute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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

GO
GRANT EXECUTE
	ON [dbo].[sp_queue_event_set_attribute]
	TO [cprsystem]
GO

