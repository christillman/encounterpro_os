﻿CREATE PROCEDURE sp_change_room
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_room_id varchar(12)
	)
AS
DECLARE @li_count smallint

SELECT @li_count = count(*)
FROM o_Rooms
WHERE o_Rooms.room_id = @ps_room_id
IF @li_count <> 1
	BEGIN
	RAISERROR ('No such room (%s)',16,-1, @ps_room_id)
	ROLLBACK TRANSACTION
	return
	END

UPDATE p_Patient_Encounter
SET patient_location = @ps_room_id,
	next_patient_location = NULL
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such encounter (%s, %d)',16,-1, @ps_cpr_id, @pl_encounter_id)
	ROLLBACK TRANSACTION
	return
	END
