CREATE TRIGGER tr_p_observation_result_delete ON dbo.p_Observation_Result
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

RAISERROR ('Deleting Observation Result Records is not allowed', 16, -1)
ROLLBACK TRANSACTION
RETURN

