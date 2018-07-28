CREATE FUNCTION fn_defaults_from_actuals (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence integer,
	@pl_branch_id int )

RETURNS @actual_results TABLE (
	branch_id int NULL,
	observation_sequence int NULL,
	observation_id varchar(24) NOT NULL,
	location varchar(24) NULL,
	result_sequence smallint NULL,
	result_value varchar(40) NULL,
	result_unit varchar(12) NULL,
	sort_sequence smallint NULL,
	long_result_value text NULL,
	result_type varchar(12) NULL,
	result varchar(80) NULL,
	abnormal_flag char(1) NULL,
	severity smallint NULL )

AS

BEGIN

DECLARE @branches TABLE (
	branch_sequence int IDENTITY(1, 1) NOT NULL,
	branch_id int NOT NULL,
	child_observation_id varchar(24) NOT NULL,
	sort_sequence smallint NULL )

DECLARE @patient_results TABLE (
	location varchar(24) NOT NULL,
	result_sequence smallint NOT NULL,
	location_result_sequence int NOT NULL,
	result_date_time datetime NULL)

DECLARE @ll_count int,
		@ll_iterations int,
		@ll_branch_id int,
		@ll_branch_sequence int,
		@ll_observation_sequence int,
		@ls_parent_observation_id varchar(24),
		@ls_child_observation_id varchar(24)


-- First insert the results from this observation_sequence
INSERT INTO @patient_results (
	location,
	result_sequence,
	location_result_sequence )
SELECT location,
	result_sequence,
	max(location_result_sequence) as location_result_sequence
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id	
AND observation_sequence = @pl_observation_sequence
GROUP BY location,
	result_sequence

INSERT INTO @actual_results (
	branch_id ,
	observation_sequence ,
	observation_id ,
	location ,
	result_sequence ,
	result_type ,
	result ,
	result_value ,
	long_result_value ,
	result_unit ,
	abnormal_flag ,
	severity )
SELECT COALESCE(@pl_branch_id, 0) ,
	r.observation_sequence ,
	r.observation_id ,
	r.location ,
	r.result_sequence ,
	r.result_type ,
	r.result ,
	r.result_value ,
	r.long_result_value ,
	r.result_unit ,
	r.abnormal_flag ,
	r.severity
FROM p_Observation_Result r
	INNER JOIN @patient_results x
	ON x.location_result_sequence = r.location_result_sequence
WHERE r.cpr_id = @ps_cpr_id
AND r.observation_sequence = @pl_observation_sequence
AND r.result_date_time IS NOT NULL
AND r.result_type IN ('PERFORM', 'Comment')
AND r.current_flag = 'Y'

SELECT @ls_parent_observation_id = observation_id
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence

-- Get the branches for this parent
INSERT INTO @branches (
	branch_id,
	child_observation_id,
	sort_sequence)
SELECT branch_id,
		child_observation_id,
		sort_sequence
FROM c_Observation_Tree
WHERE parent_observation_id = @ls_parent_observation_id
ORDER BY sort_sequence

-- Then insert the results for each of this observation's children
DECLARE lc_children CURSOR LOCAL STATIC FOR
	SELECT observation_sequence,
			observation_id
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND parent_observation_sequence = @pl_observation_sequence
	ORDER BY observation_sequence

OPEN lc_children

FETCH lc_children INTO @ll_observation_sequence, @ls_child_observation_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Get the first branch that matches the child observation_id
	SELECT @ll_branch_sequence = min(branch_sequence)
	FROM @branches
	WHERE child_observation_id = @ls_child_observation_id

	-- If we found one, then get the results for this child	
	IF 	@ll_branch_sequence IS NOT NULL
		BEGIN
		SELECT @ll_branch_id = branch_id
		FROM @branches
		WHERE branch_sequence = @ll_branch_sequence

		-- Insert the results from this child observation
		INSERT INTO @actual_results (
			branch_id ,
			observation_sequence ,
			observation_id ,
			location ,
			result_sequence ,
			result_type ,
			result ,
			result_value ,
			long_result_value ,
			result_unit ,
			abnormal_flag ,
			severity ,
			sort_sequence )
		SELECT branch_id ,
			observation_sequence ,
			observation_id ,
			location ,
			result_sequence ,
			result_type ,
			result ,
			result_value ,
			long_result_value ,
			result_unit ,
			abnormal_flag ,
			severity ,
			sort_sequence
		FROM dbo.fn_defaults_from_actuals(@ps_cpr_id, @ll_observation_sequence, @ll_branch_id)
		
		-- Delete this branch so the next time the same observation is found it uses the next branch
		DELETE @branches
		WHERE branch_sequence = @ll_branch_sequence
		END
		
	FETCH lc_children INTO @ll_observation_sequence, @ls_child_observation_id
	END
	
CLOSE lc_children
DEALLOCATE lc_children

RETURN
END

