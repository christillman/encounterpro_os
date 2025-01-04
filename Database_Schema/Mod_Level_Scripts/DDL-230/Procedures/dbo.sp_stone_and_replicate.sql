
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_stone_and_replicate]
Print 'Drop Procedure [dbo].[sp_stone_and_replicate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_stone_and_replicate]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_stone_and_replicate]
GO

-- Create Procedure [dbo].[sp_stone_and_replicate]
Print 'Create Procedure [dbo].[sp_stone_and_replicate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_stone_and_replicate (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer )
AS
DECLARE @ll_event_id integer,
	@ls_encounter_id varchar(24)

UPDATE p_Patient_Encounter
SET stone_flag = 'Y'
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND stone_flag = 'N'

IF @@ROWCOUNT <> 1 RETURN
EXECUTE sp_queue_event
		@ps_event = 'REPLICATE_ENCOUNTER',
		@pl_event_id = @ll_event_id OUTPUT
EXECUTE sp_queue_event_set_attribute
		@pl_event_id = @ll_event_id,
		@ps_attribute = 'CPR_ID',
		@ps_value = @ps_cpr_id
SELECT @ls_encounter_id = convert(varchar(24), @pl_encounter_id)
EXECUTE sp_queue_event_set_attribute
		@pl_event_id = @ll_event_id,
		@ps_attribute = 'ENCOUNTER_ID',
		@ps_value = @ls_encounter_id
EXECUTE sp_queue_event_set_ready
		@pl_event_id = @ll_event_id

GO
GRANT EXECUTE
	ON [dbo].[sp_stone_and_replicate]
	TO [cprsystem]
GO

