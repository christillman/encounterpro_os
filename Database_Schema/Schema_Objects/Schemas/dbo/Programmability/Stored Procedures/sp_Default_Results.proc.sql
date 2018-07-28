CREATE PROCEDURE sp_Default_Results (
	@pl_branch_id int = NULL,
	@pl_exam_sequence int,
	@ps_user_id varchar(24) )
AS

DECLARE @ll_count int,
		@ll_iterations int,
		@ll_max_iterations int,
		@ls_common_list_id varchar(24),
		@ls_root_observation_id varchar(24)

DECLARE @tmp_observation_results TABLE (
	branch_id int NOT NULL,
	parent_observation_id varchar(24) NULL,
	child_observation_id varchar(24) NULL,
	[user_id] varchar(24) NULL,
	result_sequence smallint NULL,
	location varchar(24) NULL,
	result_value varchar(40) NULL,
	result_unit varchar(24) NULL,
	result_flag char(1) NULL,
	sort_sequence int NULL ,
	parent_branch_id int NULL ,
	depth smallint NOT NULL DEFAULT (0),
	in_results bit NOT NULL DEFAULT (0) )

SET @ls_root_observation_id = NULL

IF @pl_branch_id IS NULL OR @pl_branch_id = 0
	SELECT @ls_root_observation_id = root_observation_id
	FROM u_Exam_Definition
	WHERE exam_sequence = @pl_exam_sequence
ELSE
	SELECT @ls_root_observation_id = parent_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = @pl_branch_id

IF @ls_root_observation_id IS NULL
	BEGIN
	-- Return an empty result set
	SELECT 	branch_id ,
		parent_observation_id ,
		child_observation_id ,
		[user_id] ,
		result_sequence ,
		location ,
		result_value ,
		result_unit ,
		parent_branch_id
	FROM @tmp_observation_results
	
	RETURN
	END

SELECT @ls_common_list_id = COALESCE(specialty_id, '$')
FROM c_User
WHERE user_id = @ps_user_id
IF @@ROWCOUNT = 0
	SET @ls_common_list_id = '$'

INSERT INTO @tmp_observation_results (
	branch_id ,
	parent_observation_id ,
	child_observation_id ,
	[user_id] ,
	result_sequence ,
	location ,
	result_value ,
	result_unit ,
	result_flag ,
	sort_sequence)
SELECT d.branch_id ,
	t.parent_observation_id ,
	t.child_observation_id ,
	d.[user_id] ,
	d.result_sequence ,
	d.location ,
	d.result_value ,
	d.result_unit ,
	d.result_flag ,
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
		result_value ,
		result_unit ,
		result_flag ,
		sort_sequence)
	SELECT d.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		d.[user_id] ,
		d.result_sequence ,
		d.location ,
		d.result_value ,
		d.result_unit ,
		d.result_flag ,
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
		sort_sequence )
	SELECT DISTINCT t.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
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
		sort_sequence,
		parent_branch_id )
	SELECT DISTINCT t.branch_id ,
		t.parent_observation_id ,
		t.child_observation_id ,
		0,
		1,
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

-- Then return the records which were in the results tree
SELECT 	branch_id ,
	parent_observation_id ,
	child_observation_id ,
	[user_id] ,
	result_sequence ,
	location ,
	result_value ,
	result_unit ,
	parent_branch_id
FROM @tmp_observation_results
WHERE in_results = 1
ORDER BY depth, sort_sequence, branch_id


