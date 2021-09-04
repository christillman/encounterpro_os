DROP TRIGGER [dbo].[tr_p_patient_encounter_delete]
GO
CREATE TRIGGER [dbo].[tr_p_patient_encounter_delete]
    ON [dbo].[p_Patient_Encounter]
    AFTER DELETE
    AS 
BEGIN

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_encounter_id int

SELECT @ls_cpr_id = max(cpr_id),
	@ll_encounter_id = max(encounter_id)
FROM deleted

RAISERROR ('Deleting Encounter Records is not allowed (%s, %d)', 16, -1, @ls_cpr_id, @ll_encounter_id )
ROLLBACK TRANSACTION
RETURN

END



