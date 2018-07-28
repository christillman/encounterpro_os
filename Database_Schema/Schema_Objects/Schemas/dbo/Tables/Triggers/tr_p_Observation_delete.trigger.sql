CREATE TRIGGER tr_p_Observation_delete ON dbo.p_Observation
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

RAISERROR ('Deleting Observation Records is not allowed', 16, -1)
ROLLBACK TRANSACTION
RETURN

