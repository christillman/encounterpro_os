CREATE PROCEDURE sp_clear_exam_defaults
	(
	@ps_user_id varchar(24),
	@pl_exam_sequence int,
	@pl_branch_id int
	)
AS

DECLARE @ll_count int

DECLARE @branches TABLE (
	branch_id int NOT NULL )

DECLARE @children TABLE (
	branch_id int NOT NULL )

IF @pl_branch_id = 0
	BEGIN
	DELETE FROM u_Exam_Default_Results
	WHERE exam_sequence = @pl_exam_sequence
	AND user_id = @ps_user_id
	END
ELSE
	BEGIN
	INSERT INTO @children (
		branch_id)
	VALUES (
		@pl_branch_id)

	SET @ll_count = 1

	-- First we have to delete from the specified branch_id
	WHILE @ll_count > 0
		BEGIN
		-- Delete the parents from the last iteration
		DELETE FROM @branches
		
		-- Move the children from the last iteration to the parents table
		INSERT INTO @branches (
			branch_id)
		SELECT branch_id
		FROM @children
		
		-- Delete the children from the last iteration
		DELETE FROM @children
		
		-- Find the children of the new parents
		INSERT INTO @children (
			branch_id )
		SELECT child.branch_id
		FROM c_Observation_Tree child
			INNER JOIN c_Observation_Tree parent
			ON parent.child_observation_id = child.parent_observation_id
			INNER JOIN @branches b
			ON b.branch_id = parent.branch_id
		
		-- Save how many children we found
		SET @ll_count = @@ROWCOUNT
		
		-- Delete the default results for all the parents
		DELETE FROM u
		FROM u_Exam_Default_Results u
			INNER JOIN @branches b
			ON u.branch_id = b.branch_id
		WHERE u.exam_sequence = @pl_exam_sequence
		AND u.[user_id] = @ps_user_id

		END
	END

