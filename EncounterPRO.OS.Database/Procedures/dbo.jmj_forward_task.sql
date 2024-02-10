
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_forward_task]
Print 'Drop Procedure [dbo].[jmj_forward_task]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_forward_task]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_forward_task]
GO

-- Create Procedure [dbo].[jmj_forward_task]
Print 'Create Procedure [dbo].[jmj_forward_task]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_forward_task (
	@pl_patient_workplan_item_id integer,
	@ps_to_user_id varchar(24),
	@ps_new_description varchar(80) = NULL,
	@ps_new_message text = NULL ,
	@ps_created_by varchar(24),
	@ps_user_id varchar(24) )
AS

-- The point of jmj_forward_task is to log three seperate attributes (description, task_message, forwarded_to_user_id)
-- with the same created date.  This will allow EncounterPRO to construct a history of the task
-- and correctly associate changes of the description/message with the forwarding event.

DECLARE @ll_actor_id int,
		@ldt_datetime datetime

SET @ldt_datetime = getdate()

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE [user_id] = @ps_user_id


-- change the description if we have a new one
IF @ps_new_description IS NOT NULL
	EXECUTE sp_add_workplan_item_attribute
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_attribute = 'message_subject',
		@ps_value = @ps_new_description,
		@ps_created_by = @ps_created_by,
		@ps_user_id = @ps_user_id,
		@pdt_created = @ldt_datetime

-- Add the new message to the recipient
IF @ps_new_message IS NOT NULL
	EXECUTE sp_add_workplan_item_attribute
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_attribute = 'task_message',
		@ps_value = @ps_new_message,
		@ps_created_by = @ps_created_by,
		@ps_user_id = @ps_user_id,
		@pdt_created = @ldt_datetime

EXECUTE sp_add_workplan_item_attribute
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_attribute = 'forwarded_to_user_id',
	@ps_value = @ps_to_user_id,
	@ps_created_by = @ps_created_by,
	@ps_user_id = @ps_user_id,
	@pdt_created = @ldt_datetime

GO
GRANT EXECUTE
	ON [dbo].[jmj_forward_task]
	TO [cprsystem]
GO

