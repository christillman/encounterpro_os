CREATE TRIGGER tr_p_patient_delete ON dbo.p_Patient
FOR DELETE
AS


DECLARE @ls_cpr_id varchar(12)

SELECT @ls_cpr_id = max(cpr_id)
FROM deleted

RAISERROR ('Deleting Patient Records is not allowed (%s)', 16, -1, @ls_cpr_id )
ROLLBACK TRANSACTION
RETURN

