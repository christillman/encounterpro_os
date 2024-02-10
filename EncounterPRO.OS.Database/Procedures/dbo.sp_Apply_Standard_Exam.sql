
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Apply_Standard_Exam]
Print 'Drop Procedure [dbo].[sp_Apply_Standard_Exam]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Apply_Standard_Exam]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Apply_Standard_Exam]
GO

-- Create Procedure [dbo].[sp_Apply_Standard_Exam]
Print 'Create Procedure [dbo].[sp_Apply_Standard_Exam]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Apply_Standard_Exam (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@pl_encounter_id int,
	@pl_observation_sequence int,
	@pl_branch_id int = NULL,
	@pl_exam_sequence int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_count int,
		@ll_iterations int,
		@ll_max_iterations int,
		@ls_common_list_id varchar(24),
		@ls_root_observation_id varchar(24),
		@ll_result_count int

DECLARE @tmp_observation_results TABLE (
	branch_id int NOT NULL,
	parent_observation_id varchar(24) NULL,
	child_observation_id varchar(24) NULL,
	[user_id] varchar(24) NULL,
	result_sequence smallint NULL,
	location varchar(24) NULL,
	result_type varchar(12) NULL,
	result varchar(80) NULL,
	result_value varchar(40) NULL,
	long_result_value text NULL,
	result_unit varchar(24) NULL,
	abnormal_flag char(1) NULL,
	severity smallint NULL,
	result_flag char(1) NULL,
	observation_tag varchar(12) NULL,
	sort_sequence int NULL ,
	parent_branch_id int NULL ,
	depth smallint NOT NULL DEFAULT (0),
	in_results bit NOT NULL DEFAULT (0) )

SET @ls_root_observation_id = NULL
SET @ll_result_count = 0

IF @pl_branch_id IS NULL OR @pl_branch_id = 0
	SELECT @ls_root_observation_id = root_observation_id
	FROM u_Exam_Definition
	WHERE exam_sequence = @pl_exam_sequence
ELSE
	SELECT @ls_root_observation_id = parent_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = @pl_branch_id

-- If we don't have a root observation_id then just return
IF @ls_root_observation_id IS NULL
	RETURN 0

SELECT @ls_common_list_id = COALESCE(specialty_id, '$')
FROM c_User
WHERE [user_id] = @ps_user_id
IF @@ROWCOUNT = 0
	SET @ls_common_list_id = '$'

INSERT INTO @tmp_observation_results (
	branch_id ,
	parent_observation_id ,
	child_observation_id ,
	[user_id] ,
	result_sequence ,
	location ,
	result_type ,
	result ,
	result_value ,
	long_result_value ,
	result_unit ,
	abnormal_flag ,
	severity ,
	result_flag ,
	observation_tag,
	sort_sequence)
SELECT d.branch_id ,
	t.parent_observation_id ,
	t.child_observation_id ,
	d.[user_id] ,
	d.result_sequence ,
	d.location ,
	COALESCE(d.result_type, 'PERFORM') ,
	d.result ,
	d.result_value ,
	d.long_result_value ,
	d.result_unit ,
	d.abnormal_flag ,
	d.severity ,
	d.result_flag ,
	t.observation_tag,
	t.sort_sequence
FROM u_Exam_Default_Results d
	LEFT OUTER JOIN c_Observation_Tree t
	ON d.branch_id = t.branch_id
WHERE d.exam_sequence = @pl_exam_sequence
AND result_flag = 'Y'
AND [user_id] = @ps_user_id

-- If we didn't find any personal defaults, then look for common defaults
IF @@ROWCOUNT = 0
	BEGIN
	INSERT INTO @tmp_observation_results (
		branch_id ,
		parent_observation_id ,
		child_observation_id ,
		[user_id] ,
		result_sequence ,
		location ,
		result_type ,
		result ,
		result_value ,
		long_result_value ,
		result_unit ,
		abnormal_flag ,
		severity ,
		result_flag ,
		observation_tag,
		sort_sequence)
	SELECT d.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		d.[user_id] ,
		d.result_sequence ,
		d.location ,
		COALESCE(d.result_type, 'PERFORM') ,
		d.result ,
		d.result_value ,
		d.long_result_value ,
		d.result_unit ,
		d.abnormal_flag ,
		d.severity ,
		d.result_flag ,
		t.observation_tag,
		t.sort_sequence
	FROM u_Exam_Default_Results d
		LEFT OUTER JOIN c_Observation_Tree t
		ON d.branch_id = t.branch_id
	WHERE d.exam_sequence = @pl_exam_sequence
	AND result_flag = 'Y'
	AND [user_id] = @ls_common_list_id
	
	END


SET @ll_count = 1
SET @ll_iterations = 0
SET @ll_max_iterations = 12

-- Go up the tree gathering all the parents
WHILE @ll_count > 0 AND @ll_iterations < @ll_max_iterations
	BEGIN
	UPDATE @tmp_observation_results
	SET depth = depth + 1

	INSERT INTO @tmp_observation_results (
		branch_id ,
		parent_observation_id ,
		child_observation_id,
		observation_tag,
		sort_sequence )
	SELECT DISTINCT t.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		t.observation_tag,
		t.sort_sequence
	FROM c_Observation_Tree t
		INNER JOIN @tmp_observation_results o
		ON o.parent_observation_id = t.child_observation_id
	WHERE o.depth = 1
	AND o.parent_observation_id <> @ls_root_observation_id
	AND NOT EXISTS (
		SELECT branch_id
		FROM @tmp_observation_results x
		WHERE t.branch_id = x.branch_id)

	SELECT @ll_count = @@ROWCOUNT
	
	SET @ll_iterations = @ll_iterations + 1

	END

-- Then mark the root
UPDATE @tmp_observation_results
SET depth = 0

IF @pl_branch_id IS NULL
	UPDATE @tmp_observation_results
	SET in_results = 1,
		depth = 1
	WHERE parent_observation_id = @ls_root_observation_id
	OR parent_observation_id IS NULL
ELSE
	UPDATE @tmp_observation_results
	SET in_results = 1,
		depth = 1
	WHERE branch_id = @pl_branch_id

-- Then go back down the tree marking the children of the root and adding
-- any siblings with the same child_observation_id so that the 
-- child_ordinal calculations work out in the data collections screens
SET @ll_count = 1
SET @ll_iterations = 0
WHILE @ll_count > 0 AND @ll_iterations < @ll_max_iterations
	BEGIN
	SET @ll_iterations = @ll_iterations + 1

	UPDATE child
	SET in_results = 1,
		depth = @ll_iterations + 1,
		parent_branch_id = parent.branch_id
	FROM @tmp_observation_results child
		INNER JOIN @tmp_observation_results parent
		ON parent.child_observation_id = child.parent_observation_id
	WHERE parent.depth = @ll_iterations

	SELECT @ll_count = @@ROWCOUNT
	
	INSERT INTO @tmp_observation_results (
		branch_id ,
		parent_observation_id ,
		child_observation_id,
		depth,
		in_results,
		observation_tag,
		sort_sequence,
		parent_branch_id )
	SELECT DISTINCT t.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		0,
		1,
		t.observation_tag,
		t.sort_sequence,
		o.parent_branch_id
	FROM c_Observation_Tree t
		INNER JOIN @tmp_observation_results o
		ON o.parent_observation_id = t.parent_observation_id
		AND o.child_observation_id = t.child_observation_id
		AND o.branch_id <> t.branch_id
	WHERE o.depth = @ll_iterations
	AND NOT EXISTS (
		SELECT branch_id
		FROM @tmp_observation_results x
		WHERE t.branch_id = x.branch_id)
	
	END


DECLARE	@ll_branch_id int ,
	@ls_parent_observation_id varchar(24),
	@ls_child_observation_id varchar(24),
	@ls_user_id varchar(24),
	@li_result_sequence smallint,
	@ls_location varchar(24),
	@ls_result_value varchar(40),
	@ls_long_result_value varchar(4000),
	@ls_result_unit varchar(12),
	@ll_parent_branch_id int,
	@ls_description varchar(80),
	@ll_branch_sort_sequence int,
	@ls_result varchar(80),
	@ls_result_type varchar(12),
	@ls_abnormal_flag char(1),
	@li_severity smallint,
	@ll_observation_sequence int,
	@ll_parent_observation_sequence int,
	@ls_observation_tag varchar(12)

DECLARE lc_results CURSOR LOCAL FAST_FORWARD FOR
	SELECT 	branch_id ,
		parent_observation_id ,
		child_observation_id ,
		[user_id] ,
		result_sequence ,
		location ,
		result_type ,
		result ,
		result_value ,
		CAST(long_result_value AS varchar(4000)),
		result_unit ,
		abnormal_flag ,
		severity ,
		parent_branch_id,
		observation_tag
	FROM @tmp_observation_results
	WHERE in_results = 1
	ORDER BY depth, sort_sequence, branch_id

OPEN lc_results

FETCH lc_results INTO @ll_branch_id  ,
						@ls_parent_observation_id ,
						@ls_child_observation_id ,
						@ls_user_id ,
						@li_result_sequence ,
						@ls_location ,
						@ls_result_type ,
						@ls_result ,
						@ls_result_value ,
						@ls_long_result_value ,
						@ls_result_unit ,
						@ls_abnormal_flag ,
						@li_severity ,
						@ll_parent_branch_id ,
						@ls_observation_tag

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ll_observation_sequence = NULL
	SET @ll_parent_observation_sequence = NULL
	
	IF @ll_parent_branch_id IS NULL
		SET @ll_parent_observation_sequence = @pl_observation_sequence
	ELSE
		SELECT @ll_parent_observation_sequence = observation_sequence
		FROM p_Observation
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND observation_id = @ls_parent_observation_id
		AND original_branch_id = @ll_parent_branch_id
	
	IF @ll_parent_observation_sequence IS NOT NULL
		BEGIN
		SELECT @ll_observation_sequence = observation_sequence
		FROM p_Observation
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND observation_id = @ls_child_observation_id
		AND original_branch_id = @ll_branch_id
		
		IF @@ROWCOUNT = 0
			BEGIN
			SELECT @ls_description = COALESCE(t.description, o.description),
					@ll_branch_sort_sequence = t.sort_sequence
			FROM c_Observation_Tree t
				INNER JOIN c_Observation o
				ON t.child_observation_id = o.observation_id
			WHERE t.branch_id = @ll_branch_id
			
			IF @@ROWCOUNT = 1
				BEGIN
				INSERT INTO p_Observation
						(
						cpr_id,
						observation_id,
						description,
						treatment_id,
						encounter_id,
						result_expected_date,
						observation_tag,
						parent_observation_sequence,
						observed_by,
						branch_sort_sequence,
						created,
						created_by,
						original_branch_id
						)
				VALUES (
						@ps_cpr_id,
						@ls_child_observation_id,
						@ls_description,
						@pl_treatment_id,
						@pl_encounter_id,
						getdate(),
						@ls_observation_tag,
						@ll_parent_observation_sequence,
						@ps_user_id,
						@ll_branch_sort_sequence,
						getdate(),
						@ps_created_by,
						@ll_branch_id
						)
				
				SET @ll_observation_sequence = SCOPE_IDENTITY()
				END
			END

		IF @ll_observation_sequence IS NOT NULL AND @li_result_sequence IS NOT NULL
			BEGIN
			SELECT @ls_result = COALESCE(@ls_result, result),
					@ls_result_type = COALESCE(@ls_result_type, result_type),
					@ls_abnormal_flag = COALESCE(@ls_abnormal_flag, abnormal_flag),
					@li_severity = COALESCE(@li_severity, severity)
			FROM c_Observation_Result
			WHERE observation_id = @ls_child_observation_id
			AND result_sequence = @li_result_sequence
			
			INSERT INTO p_Observation_Result
				(
				cpr_id,
				observation_sequence,
				location,
				encounter_id,
				treatment_id,
				observation_id,
				result_sequence,
				result_type,
				result,
				result_date_time,
				result_value,
				long_result_value,
				result_unit,
				abnormal_flag,
				severity,
				observed_by,
				current_flag,
				created,
				created_by
				)
			VALUES (
				@ps_cpr_id,
				@ll_observation_sequence,
				@ls_location,
				@pl_encounter_id,
				@pl_treatment_id,
				@ls_child_observation_id,
				@li_result_sequence, 
				@ls_result_type,
				@ls_result,
				getdate(),
				@ls_result_value,
				@ls_long_result_value,
				@ls_result_unit,
				@ls_abnormal_flag,
				@li_severity,
				@ps_user_id,
				'Y',
				getdate(),
				@ps_created_by
				)
			
			SET @ll_result_count = @ll_result_count + 1
			END
		END
		
	FETCH lc_results INTO @ll_branch_id  ,
							@ls_parent_observation_id ,
							@ls_child_observation_id ,
							@ls_user_id ,
							@li_result_sequence ,
							@ls_location ,
							@ls_result_type ,
							@ls_result ,
							@ls_result_value ,
							@ls_long_result_value ,
							@ls_result_unit ,
							@ls_abnormal_flag ,
							@li_severity ,
							@ll_parent_branch_id ,
							@ls_observation_tag
	END

CLOSE lc_results
DEALLOCATE lc_results

RETURN @ll_result_count

GO
GRANT EXECUTE
	ON [dbo].[sp_Apply_Standard_Exam]
	TO [cprsystem]
GO

