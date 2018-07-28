CREATE PROCEDURE jmj_process_ICD_Code_Change
	@ps_icd_9_code varchar(12),
	@ps_description varchar(80),
	@ps_from_description varchar(80) = NULL,
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_long_description text = NULL,
	@ps_operation varchar(24),
	@ps_from_icd_9_code varchar(12) = NULL
AS

--
-- @ps_operation = Type of code change
--       Options are:	New			This is a brand new code
--						Revise		This is an existing code but the description has been revised
--						CodeChange	An existing code has been changed to this new code
--						Delete		This code has been discontinued
--						Replaced	This code has been replaced by more detailed codes.  This code
--									is no longer assignable directly
--
-- New and Revised codes
-- 1) Add new assessment
-- 2) If new assessment does not have a treatment list then ...
--   2a) Find all assessments with the same ICD code which have a treatment list
--   2b) If none found and ICD has 5 digits, then find all assessments with the same 1st 4 digits of the ICD code which have a treatment list
--   2c) if any assessments found in 2a or 2b, then determine which assessment was most recently used.  If none have ever been used then
--       find which assessment was most recently created.
--   2d) Copy the treatment list from the assessment found in 2c to the new assessment
--
--
-- Deleted codes
-- 1) Update all existing assessments by adding the suffix " (deleted)"
--

IF @ps_icd_9_code IS NULL
	BEGIN
	RAISERROR ('icd_9_code cannot be NULL',16,-1)
	RETURN -1
	END

IF @ps_description IS NULL AND @ps_operation <> 'Replaced'
	BEGIN
	RAISERROR ('Description cannot be NULL unless the operation is "Replaced"',16,-1)
	RETURN -1
	END

IF @ps_assessment_category_id IS NULL
 SET @ps_assessment_category_id = 'AANEW'

DECLARE @ls_new_assessment_id varchar(24),
	@ls_existing_assessment_id varchar(24),
	@ls_deleted_suffix varchar(32),
	@ls_replaced_suffix varchar(32),
	@ll_count int,
	@ls_assessment_type varchar(24)

DECLARE @assessments TABLE (
	assessment_id varchar(24) NOT NULL,
	treatment_count int NULL,
	last_used datetime NULL)

SET @ls_deleted_suffix = ' (Deleted)'
SET @ls_replaced_suffix = ' (Replaced - Use detailed code)'

IF @ps_operation IN ('New', 'Revise')
	BEGIN
	IF @ps_assessment_type IS NULL
		BEGIN
		IF LEFT(@ps_icd_9_code, 2) = 'V2'
			SET @ls_assessment_type = 'WELL'
		ELSE
			SET @ls_assessment_type = 'SICK'
		END
	ELSE
		SET @ls_assessment_type = @ps_assessment_type
	
	-- If the description is supposed to be updated, then do it now
	IF @ps_operation = 'Revise' AND @ps_from_description IS NOT NULL
		BEGIN
		UPDATE c_Assessment_Definition
		SET description = @ps_description
		WHERE icd_9_code = COALESCE(@ps_from_icd_9_code, @ps_icd_9_code)
		AND description = @ps_from_description
		END
		
	EXECUTE sp_new_assessment
		@ps_assessment_type = @ls_assessment_type,
		@ps_icd_9_code = @ps_icd_9_code,
		@ps_assessment_category_id = @ps_assessment_category_id,
		@ps_description = @ps_description,
		@ps_long_description = @ps_long_description,
		@ps_assessment_id = @ls_new_assessment_id OUTPUT

	IF @ls_new_assessment_id IS NOT NULL
		BEGIN
		SELECT @ll_count = count(*)
		FROM u_Assessment_Treat_Definition
		WHERE assessment_id = @ls_new_assessment_id
		
		IF @ll_count = 0
			BEGIN
			IF @ps_from_icd_9_code IS NOT NULL
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd_9_code = @ps_from_icd_9_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd_9_code = @ps_icd_9_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0 AND LEN(@ps_icd_9_code) = 6 -- 5 digits plus the decimal point
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd_9_code = LEFT(@ps_icd_9_code, 5)
				GROUP BY u.assessment_id
				END
				
			-- If we found any assessments, then determine the latest one used
			IF (SELECT COUNT(*) FROM @assessments) > 0
				BEGIN
				UPDATE a
				SET last_used = x.last_used
				FROM @assessments a
					INNER JOIN (SELECT assessment_id, max(created) as last_used
								FROM p_Assessment
								GROUP BY assessment_id) x
					ON a.assessment_id = x.assessment_id
				
				SELECT TOP 1 @ls_existing_assessment_id = assessment_id
				FROM @assessments
				ORDER BY last_used desc
				
				EXECUTE jmj_copy_assessment_treatment_lists
					@ps_From_assessment_id = @ls_existing_assessment_id,
					@ps_To_assessment_id = @ls_new_assessment_id,
					@ps_Action = 'Ignore' -- Don't copy if there are already treatment list items for the new assesment				
				
				END
			
			END
		END
	END

IF @ps_operation IN ('CodeChange')
	BEGIN
	IF @ps_from_icd_9_code IS NOT NULL AND @ps_icd_9_code IS NOT NULL
		UPDATE c_Assessment_Definition
		SET icd_9_code = @ps_icd_9_code
		WHERE icd_9_code = @ps_from_icd_9_code
		AND (description = @ps_description OR definition = @ps_description)
	END

IF @ps_operation IN ('Delete')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_deleted_suffix)) + @ls_deleted_suffix
	WHERE icd_9_code = @ps_icd_9_code
	AND (description = @ps_description OR definition = @ps_description)
	AND RIGHT(description, LEN(@ls_deleted_suffix)) <> @ls_deleted_suffix

	END

IF @ps_operation IN ('Replaced')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_replaced_suffix)) + @ls_replaced_suffix
	WHERE icd_9_code = @ps_icd_9_code
	AND RIGHT(description, LEN(@ls_replaced_suffix)) <> @ls_replaced_suffix

	END

