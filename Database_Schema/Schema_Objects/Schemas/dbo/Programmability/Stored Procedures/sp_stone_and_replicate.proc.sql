/****** Object:  Stored Procedure dbo.sp_stone_and_replicate    Script Date: 7/25/2000 8:44:18 AM ******/
/****** Object:  Stored Procedure dbo.sp_stone_and_replicate    Script Date: 2/16/99 12:01:12 PM ******/
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

