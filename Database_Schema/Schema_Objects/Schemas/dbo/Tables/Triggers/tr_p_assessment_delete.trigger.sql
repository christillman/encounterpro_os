CREATE TRIGGER tr_p_assessment_delete ON dbo.p_Assessment
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int

SELECT @ls_cpr_id = max(cpr_id),
	@ll_problem_id = max(problem_id)
FROM deleted

RAISERROR ('Deleting Assessment Records is not allowed (%s, %d)', 16, -1, @ls_cpr_id, @ll_problem_id )
ROLLBACK TRANSACTION
RETURN

