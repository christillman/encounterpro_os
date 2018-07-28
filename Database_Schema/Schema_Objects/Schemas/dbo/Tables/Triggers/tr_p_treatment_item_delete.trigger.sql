-- Trigger to delete treatment & it's references
CREATE TRIGGER tr_p_treatment_item_delete ON dbo.p_Treatment_Item
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_treatment_id int

SELECT @ls_cpr_id = max(cpr_id),
	@ll_treatment_id = max(treatment_id)
FROM deleted

RAISERROR ('Deleting Treatment Records is not allowed (%s, %d)', 16, -1, @ls_cpr_id, @ll_treatment_id )
ROLLBACK TRANSACTION
RETURN


