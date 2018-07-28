CREATE TRIGGER tr_p_patient_alias_delete ON dbo.p_Patient_Alias
FOR DELETE
AS


DECLARE @ls_cpr_id varchar(12)

SELECT @ls_cpr_id = max(cpr_id)
FROM deleted

RAISERROR ('Deleting Patient Alias Records is not allowed (%s)', 16, -1, @ls_cpr_id )
ROLLBACK TRANSACTION
RETURN

