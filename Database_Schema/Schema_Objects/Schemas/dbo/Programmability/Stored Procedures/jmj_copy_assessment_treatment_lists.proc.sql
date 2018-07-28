CREATE PROCEDURE jmj_copy_assessment_treatment_lists
	@ps_From_assessment_id varchar(24),
	@ps_To_assessment_id varchar(24),
	@ps_Action varchar(12) = 'Ignore'
AS

Declare @ls_From_user_id varchar(24)
Declare @ls_To_user_id varchar(24)


DECLARE lc_users CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT user_id
	FROM u_Assessment_Treat_Definition
	WHERE assessment_id = @ps_From_assessment_id

OPEN lc_users
FETCH lc_users INTO @ls_From_user_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	
	EXECUTE jmj_copy_assessment_treatment_list
		@ps_From_assessment_id = @ps_From_assessment_id,
		@ps_From_user_id = @ls_From_user_id,
		@ps_To_assessment_id = @ps_To_assessment_id,
		@ps_To_user_id = @ls_From_user_id,
		@ps_Action = @ps_action
	
	FETCH lc_users INTO @ls_From_user_id
	END

CLOSE lc_users
DEALLOCATE lc_users


