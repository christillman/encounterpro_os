
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_patient_encounter_delete]
Print 'Drop Trigger [dbo].[tr_p_patient_encounter_delete]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_patient_encounter_delete]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_patient_encounter_delete]
GO

-- Create Trigger [dbo].[tr_p_patient_encounter_delete]
Print 'Create Trigger [dbo].[tr_p_patient_encounter_delete]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
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
GO

