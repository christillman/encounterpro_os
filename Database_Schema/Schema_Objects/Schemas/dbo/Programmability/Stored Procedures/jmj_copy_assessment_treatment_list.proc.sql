CREATE PROCEDURE jmj_copy_assessment_treatment_list
	@ps_From_assessment_id varchar(24),
	@ps_From_user_id varchar(24),
	@ps_To_assessment_id varchar(24),
	@ps_To_user_id varchar(24),
	@ps_Action varchar(12) = 'Ignore'
AS

--
--
-- @ps_Action = Action to take if there are already treatments for the specified @ps_To_assessment_id/@ps_To_user_id
--       Options are:	Replace		Remove the existing treatments and replace them with the "From" treatments
--						Append		Leave all the existing treatments in place and add all the "From" treatments
--						Merge		Leave all the existing treatments in place and add any "From" treatments where the 
--									treatment_type/treatment_key don't already exist.
--						Ignore		Leave all the existing treatments in place.  Do not add any of the "From" treatments
--
--

IF @ps_From_assessment_id IS NULL
	BEGIN
	RAISERROR ('From_assessment_id cannot be NULL',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_From_user_id IS NULL
	BEGIN
	RAISERROR ('From_user_id cannot be NULL',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_To_assessment_id IS NULL
	BEGIN
	RAISERROR ('To_assessment_id cannot be NULL',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_To_user_id IS NULL
	BEGIN
	RAISERROR ('To_user_id cannot be NULL',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_From_assessment_id = @ps_To_assessment_id AND @ps_From_user_id = @ps_To_user_id
	BEGIN
	RAISERROR ('The treatment list may not be copied to itself',16,-1)
	ROLLBACK TRANSACTION
	RETURN -1
	END


DECLARE @ll_definition_id int,
		@ll_new_definition_id int,
		@ll_from_count int,
		@ll_existing_count int,
		@ls_treatment_type varchar(24),
		@ls_treatment_key_name varchar(40),
		@ls_treatment_key varchar(128),
		@ll_same_treatment int


-- See if there are any treatments to copy
SELECT @ll_from_count = count(*)
FROM u_Assessment_Treat_Definition
WHERE assessment_id = @ps_From_assessment_id
AND user_id = @ps_From_user_id

IF @ll_from_count = 0
	RETURN 0

-- See if there are already treatments in the target list
SELECT @ll_existing_count = count(*)
FROM u_Assessment_Treat_Definition
WHERE assessment_id = @ps_To_assessment_id
AND user_id = @ps_To_user_id

IF @ll_existing_count > 0 AND @ps_Action = 'Ignore'
	RETURN 0

IF @ll_existing_count > 0 AND @ps_Action = 'Replace'
	DELETE
	FROM u_Assessment_Treat_Definition
	WHERE assessment_id = @ps_To_assessment_id
	AND user_id = @ps_To_user_id

DECLARE @parents TABLE (
	old_definition_id int NOT NULL,
	new_definition_id int NOT NULL)

DECLARE @trts TABLE (
	definition_id int NOT NULL )

INSERT INTO @trts (
	definition_id )
SELECT definition_id
FROM u_Assessment_Treat_Definition
WHERE assessment_id = @ps_From_assessment_id
AND user_id = @ps_From_user_id


DECLARE lc_trt CURSOR LOCAL FAST_FORWARD FOR
	SELECT definition_id
	FROM @trts

OPEN lc_trt
FETCH lc_trt INTO @ll_definition_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Reset the same_treatment count to zero
	SET @ll_same_treatment = 0
	
	-- If the @ps_Action is 'Merge', then see if this treatment already exists
	IF @ps_action = 'Merge'
		BEGIN
		SELECT @ls_treatment_type = treatment_type,
				@ls_treatment_key_name = dbo.fn_treatment_type_treatment_key(treatment_type)
		FROM u_Assessment_Treat_Definition
		WHERE definition_id = @ll_definition_id

		SELECT @ls_treatment_key = max(value)
		FROM u_Assessment_Treat_Def_Attrib
		WHERE definition_id = @ll_definition_id
		AND attribute = @ls_treatment_key_name
		
		IF @ls_treatment_key IS NOT NULL
			BEGIN
			-- If we found a treatment key attribute/value, then count how many
			-- treatments in the target list have the same treatment_type/treatment_key
			SELECT @ll_same_treatment = count(*)
			FROM u_Assessment_Treat_Definition d
				INNER JOIN u_Assessment_Treat_Def_Attrib a
				ON d.definition_id = a.definition_id
			WHERE d.assessment_id = @ps_To_assessment_id
			AND d.user_id = @ps_To_user_id
			AND d.treatment_type = @ls_treatment_type
			AND a.attribute = @ls_treatment_key_name
			AND a.value = @ls_treatment_key
			END
		END

	-- If the same_treatment count is zero, then either the ps_action is not 'Merge', or
	-- we found no existing treatments with the same treatment_type/treatment_key
	IF @ll_same_treatment = 0
		BEGIN
		INSERT INTO u_Assessment_Treat_Definition (
			assessment_id,
			treatment_type,
			treatment_description,
			workplan_id,
			followup_workplan_id,
			user_id,
			sort_sequence,
			instructions,
			parent_definition_id,
			child_flag)
		SELECT @ps_To_assessment_id,
			treatment_type,
			treatment_description,
			workplan_id,
			followup_workplan_id,
			@ps_To_user_id,
			sort_sequence,
			instructions,
			parent_definition_id,
			child_flag
		FROM u_Assessment_Treat_Definition
		WHERE definition_id = @ll_definition_id
		
		SET @ll_new_definition_id = SCOPE_IDENTITY()
		
		INSERT INTO u_Assessment_Treat_Def_Attrib (
			definition_id,
			attribute,
			value)
		SELECT @ll_new_definition_id,
			attribute,
			value
		FROM u_Assessment_Treat_Def_Attrib
		WHERE definition_id = @ll_definition_id
		
		INSERT INTO @parents (
			old_definition_id,
			new_definition_id )
		VALUES (
			 @ll_definition_id,
			 @ll_new_definition_id)
		END
	
	FETCH lc_trt INTO @ll_definition_id
	END

CLOSE lc_trt
DEALLOCATE lc_trt

-- Finally, update the parent definition id values
UPDATE d
SET parent_definition_id = x2.new_definition_id
FROM u_Assessment_Treat_Definition d
	INNER JOIN @parents x1
	ON d.definition_id = x1.new_definition_id
	INNER JOIN @parents x2
	ON d.parent_definition_id = x2.old_definition_id




