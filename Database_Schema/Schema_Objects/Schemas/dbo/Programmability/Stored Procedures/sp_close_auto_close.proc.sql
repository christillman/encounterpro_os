/****** Object:  Stored Procedure dbo.sp_close_auto_close    Script Date: 7/25/2000 8:44:13 AM ******/
/****** Object:  Stored Procedure dbo.sp_close_auto_close    Script Date: 2/16/99 12:00:40 PM ******/
CREATE PROCEDURE sp_close_auto_close (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24))
AS
DECLARE @ll_problem_id integer
DECLARE auto_close_diag CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT problem_id
	FROM p_Assessment p, c_Assessment_Definition c
	WHERE p.cpr_id = @ps_cpr_id
	AND p.assessment_id = c.assessment_id
	AND p.assessment_status IS NULL
	AND c.auto_close = 'Y'
OPEN auto_close_diag
FETCH auto_close_diag INTO @ll_problem_id
WHILE @@FETCH_STATUS = 0
	BEGIN 	EXECUTE sp_set_assessment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_problem_id = @ll_problem_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_progress_type = 'CLOSED',
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by
	FETCH auto_close_diag INTO @ll_problem_id
	END
CLOSE auto_close_diag
DEALLOCATE auto_close_diag

