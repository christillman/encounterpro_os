
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_add_encounter_charge]
Print 'Drop Procedure [dbo].[sp_add_encounter_charge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_add_encounter_charge]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_encounter_charge]
GO

-- Create Procedure [dbo].[sp_add_encounter_charge]
Print 'Create Procedure [dbo].[sp_add_encounter_charge]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_add_encounter_charge (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_procedure_id varchar(24) = NULL,
	@pl_treatment_id integer = NULL,
	@ps_created_by varchar(24),
	@ps_replace_flag char(1),
	@ps_procedure_type varchar(12) = NULL ,
	@pl_units integer = 1,
	@ps_order_extra_charges char(1) = 'Y')
AS

-- This procedure adds a record to p_Encounter_Charge
-- and then sets it to be billed with the appropriate assessments

DECLARE @ll_encounter_charge_id integer,
	    @ll_procedure_charge_count integer,
	    @ll_procedure_billed_count integer,
	    @ll_count integer,
	    @ls_assessment_bill_flag char(1),
	    @ls_default_bill_flag char(1),
	    @ls_charge_bill_flag char(1),
	    @lm_charge money,
	    @ls_procedure_type varchar(12),
	    @li_exists smallint,
	    @ll_problem_id int,
	    @ls_current_bill_flag char(1),
	    @ls_new_flag char(1),
	    @ll_units int,
		@ls_cpt_code varchar(12),
		@ls_modifier varchar(2),
		@ls_other_modifiers varchar(12),
		@ls_treatment_procedure_id varchar(24),
		@ls_well_flag char(1),
		@ls_sick_flag char(1),
		@ls_procedure_well_encounter_flag char(1),
		@ls_bill_assessment_id varchar(24),
		@ls_payer_assessment_auto_bill char(1),
		@ls_bill_assessment_well_encounter_flag char(1),
		@ll_accumulate_encounter_charge_id int,
		@ls_exclusive_link char(1),
		@ls_authority_type varchar(24)

-- Make sure the @pl_units is valid
IF @pl_units IS NULL OR @pl_units <= 0
	SET @pl_units = 1

SELECT @ls_payer_assessment_auto_bill = COALESCE(a.bill_procedure_assessment, ac.bill_procedure_assessment)
FROM p_Patient_Authority p
	INNER JOIN c_Authority a
	ON p.authority_id = a.authority_id
	INNER JOIN c_Authority_Category ac
	ON a.authority_category = ac.authority_category
WHERE p.cpr_id = @ps_cpr_id
AND p.authority_type = 'PAYOR'
AND p.authority_sequence = 1

IF @ls_payer_assessment_auto_bill IS NULL OR @ls_payer_assessment_auto_bill NOT IN ('Y', 'A', 'C', 'B')
	SET @ls_payer_assessment_auto_bill = 'N'

SELECT @ls_treatment_procedure_id = procedure_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

SELECT @ls_well_flag = well_flag,
	@ls_sick_flag = sick_flag
FROM dbo.fn_encounter_well_sick_status(@ps_cpr_id, @pl_encounter_id)

IF @ps_procedure_id IS NULL
	SET @ps_procedure_id = @ls_treatment_procedure_id

IF @ps_procedure_id IS NULL
	BEGIN
	RAISERROR ('Cannot find procedure_id',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END


-- Get the billing flags based on the primary PAYOR authority
SELECT @ls_cpt_code = c.cpt_code,
	@ls_modifier = c.modifier,
	@ls_other_modifiers = c.other_modifiers,
	@ll_units = c.units,
	@lm_charge = c.charge,
	@ls_authority_type = authority_type
FROM c_Procedure_Coding c
	INNER JOIN p_Patient_Authority a
	ON a.authority_id = c.authority_id
WHERE a.cpr_id = @ps_cpr_id
AND a.authority_sequence = 1
AND a.authority_type = 'PAYOR'
AND c.procedure_id = @ps_procedure_id

-- If we didn't find any authority specific billing info then get it from c_Procedure
IF @ls_authority_type IS NULL
	SELECT @ls_cpt_code = cpt_code,
		@ls_modifier = modifier,
		@ls_other_modifiers = other_modifiers,
		@ll_units = units,
		@lm_charge = charge
	FROM c_Procedure
	WHERE procedure_id = @ps_procedure_id

-- Make sure the units from the definition is valid
IF @ll_units IS NULL OR @ll_units <= 0
	SET @ll_units = 1

-- Multiply the passed in units by the units from the definition
SET @ll_units = @ll_units * @pl_units


-- Get some more info from the c_Procedure table
SELECT 	@ls_procedure_type = COALESCE(@ps_procedure_type, procedure_type),
	@ls_default_bill_flag = default_bill_flag,
	@ls_procedure_well_encounter_flag = ISNULL(well_encounter_flag, 'A'),
	@ls_bill_assessment_id = bill_assessment_id
FROM c_Procedure
WHERE procedure_id = @ps_procedure_id

-- If the replace flag is Y then don't allow more than one charge of any given type
IF @ps_replace_flag = 'Y' AND @ls_procedure_type <> 'DRUGHCPCS'
	BEGIN
	DELETE ac
	FROM p_Encounter_Assessment_Charge ac
		INNER JOIN p_Encounter_Charge c
		ON ac.cpr_id = c.cpr_id
		AND ac.encounter_id = c.encounter_id
		AND ac.encounter_charge_id = c.encounter_charge_id
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.procedure_type = @ls_procedure_type

	DELETE p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND procedure_type = @ls_procedure_type
	END	


-- Count how many times this procedure is already billed in this encounter
SELECT @ll_procedure_billed_count = count(*)
FROM p_Encounter_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND procedure_id = @ps_procedure_id
AND bill_flag = 'Y'

-- Count how many charge records there are for this procedure, regardless of whether or not they are billed
SELECT @ll_procedure_charge_count = count(*)
FROM p_Encounter_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND procedure_id = @ps_procedure_id

--------------------------------------------------------------------------
-- Now we have all the information we need to determine whether or not to
-- create a new charge record and what the bill flag should be
--------------------------------------------------------------------------

-- First set the charge_bill_flag to the default value which is 'Y' for every
-- default_bill_flag value except 'N'
SET @ls_charge_bill_flag = CASE @ls_default_bill_flag WHEN 'N' THEN 'N' ELSE 'Y' END

-- By default, don't create a new charge record
SET @ls_new_flag = 'N'

	
IF @ls_default_bill_flag = '1'
	BEGIN
	-- Only bill this procedure_id if it is not yet billed for this encounter
	IF @ll_procedure_billed_count = 0
		SET @ls_new_flag = 'Y'
	END

IF @ls_default_bill_flag = '2'
	BEGIN
	-- When the default bill flag = '2' that means only bill on the second or subsequent
	-- charge.  To do this we must create a record for the first charge that doesn't get billed
	-- or displayed in EncounterPRO.  Setting the bill_flag to 'X' will accomplish this.
	IF @ll_procedure_charge_count = 0 
		BEGIN
		SET @ls_charge_bill_flag = 'X'
		SET @ls_new_flag = 'Y'
		END
	ELSE
		BEGIN
		IF @ll_procedure_billed_count = 0
			SET @ls_new_flag = 'Y'
		ELSE
			BEGIN
			-- Find the procedure charge that is already billed for this encounter
			SELECT @ll_encounter_charge_id = min(encounter_charge_id)
			FROM p_Encounter_Charge
			WHERE cpr_id = @ps_cpr_id
			AND encounter_id = @pl_encounter_id
			AND procedure_id = @ps_procedure_id
			AND bill_flag = 'Y'
			
			-- Accumulate these units into the existing billed charge record
			UPDATE p_Encounter_Charge
			SET units = ISNULL(units, 0) + @ll_units
			WHERE cpr_id = @ps_cpr_id
			AND encounter_id = @pl_encounter_id
			AND encounter_charge_id = @ll_encounter_charge_id
			END
		END
	END

IF @ls_default_bill_flag = 'A'
	BEGIN
	-- Set the charge_bill_flag to 'A' so that we accumulate the treatment
	-- specific charges in non-visible charge records.  These will then be
	-- accumulated across treatments into a billed charge record
	SET @ls_charge_bill_flag = 'A'

	-- Accumulating charges passed in without a treatment ID should accumulate with the treatment_id = -1
	IF @pl_treatment_id IS NULL
		SET @pl_treatment_id = -1

	-- Count how many times this procedure is already billed in this encounter
	SELECT @ll_procedure_billed_count = count(*)
	FROM p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND procedure_id = @ps_procedure_id
	AND treatment_id = @pl_treatment_id
	AND bill_flag = 'A'

	-- When the default bill flag = 'A' that means accumulate the charges into a single billed charge record
	IF @ll_procedure_billed_count = 0
		SET @ls_new_flag = 'Y'
	ELSE
		BEGIN
		-- Find the procedure charge that is already billed for this encounter/treatment
		SELECT @ll_encounter_charge_id = min(encounter_charge_id)
		FROM p_Encounter_Charge
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND procedure_id = @ps_procedure_id
		AND treatment_id = @pl_treatment_id
		AND bill_flag = 'A'
		
		-- Accumulate these units into the existing billed charge record
		UPDATE p_Encounter_Charge
		SET units = ISNULL(units, 0) + @ll_units
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND encounter_charge_id = @ll_encounter_charge_id
		END
	END

IF @ls_default_bill_flag IN ('Y', 'N')
	BEGIN
	-- In this case create a new charge record as long as the charge has not yet been created for this treatment
	-- See if this charge is already billed for this treatment (or encounter if no treatment is specified)
	SELECT @ll_encounter_charge_id = min(encounter_charge_id)
	FROM p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND procedure_id = @ps_procedure_id
	AND ISNULL(treatment_id, -1) = ISNULL(@pl_treatment_id, -1)

	IF @ll_encounter_charge_id IS NULL
		SET @ls_new_flag = 'Y'
	END



-- If we need to create a new charge record, insert the record and get the encounter_charge_id
IF @ls_new_flag = 'Y'
	BEGIN
	-- Create the new charge record
	INSERT INTO p_Encounter_Charge (
		cpr_id,
		encounter_id,
		procedure_type,
		treatment_id,
		procedure_id,
		cpt_code,
		charge,
		units,
		modifier,
		other_modifiers,
		created_by,
		bill_flag )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@ls_procedure_type,
		@pl_treatment_id,
		@ps_procedure_id,
		@ls_cpt_code,
		@lm_charge,
		@ll_units,
		@ls_modifier,
		@ls_other_modifiers,
		@ps_created_by,
		@ls_charge_bill_flag )

	SET	@ll_encounter_charge_id = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
	-- If we're not supposed to create a new record, but we found a matching existing record and the bill flag is not what it should be
	-- then update the bill_flag
	IF @ll_encounter_charge_id IS NOT NULL
		BEGIN
		SELECT @ls_current_bill_flag = bill_flag
		FROM p_Encounter_Charge
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND encounter_charge_id = @ll_encounter_charge_id

		IF @ls_charge_bill_flag = 'Y' AND @ls_current_bill_flag = 'N'
			BEGIN
			UPDATE p_Encounter_Charge
			SET bill_flag = 'Y'
			WHERE cpr_id = @ps_cpr_id
			AND encounter_id = @pl_encounter_id
			AND encounter_charge_id = @ll_encounter_charge_id
			END
		END
	END

-- Now, if we have a charge record in hand, run through the logic to connect it to the right assessments
IF @ll_encounter_charge_id IS NOT NULL
	BEGIN
	-- If this is a treatment charge, then follow the steps in the Billing Algorithm section 10	
	IF @pl_treatment_id IS NOT NULL
		BEGIN
		-- New Treatment Charge

		-- 10.b
		-- Find all assessments associated with this treatment which are not already recorded in p_Encounter_Assessment
		DECLARE lc_assessments CURSOR LOCAL FAST_FORWARD FOR
			SELECT problem_id
			FROM p_Assessment_Treatment
			WHERE cpr_id = @ps_cpr_id
			AND treatment_id = @pl_treatment_id
			AND NOT EXISTS (
				SELECT 1
				FROM p_Encounter_Assessment
				WHERE p_Assessment_Treatment.cpr_id = p_Encounter_Assessment.cpr_id
				AND p_Assessment_Treatment.problem_id = p_Encounter_Assessment.problem_id
				AND p_Encounter_Assessment.cpr_id = @ps_cpr_id
				AND p_Encounter_Assessment.encounter_id = @pl_encounter_id )

		OPEN lc_assessments

		FETCH lc_assessments INTO @ll_problem_id

		WHILE @@FETCH_STATUS = 0
			BEGIN
			-- Set the billing for the associated assessments
			EXECUTE sp_set_assessment_billing
						@ps_cpr_id = @ps_cpr_id,
						@pl_encounter_id = @pl_encounter_id,
						@pl_problem_id = @ll_problem_id,
						@ps_bill_flag  = NULL,
						@ps_created_by = @ps_created_by
			
			FETCH lc_assessments INTO @ll_problem_id
			END

		CLOSE lc_assessments
		DEALLOCATE lc_assessments


		-- See if there is a primary charge for the treatment, which isn't this charge
		IF EXISTS (	SELECT 1
					FROM p_Treatment_Item t
						INNER JOIN p_Encounter_Charge c
						ON t.cpr_id = c.cpr_id
						AND t.treatment_id = c.treatment_id
						AND t.procedure_id = c.procedure_id
					WHERE t.cpr_id = @ps_cpr_id
					AND t.treatment_id = @pl_treatment_id
					AND t.procedure_id <> @ps_procedure_id )
			BEGIN
			-- 10.c
			-- If this is not the primary treatment charge, and this treatment has
			-- a primary treatment charge, then associate this charge with each
			-- assessment-billing record that is associated with the primary
			-- treatment charge
			INSERT INTO p_Encounter_Assessment_Charge (
				cpr_id,
				encounter_id,
				problem_id,
				encounter_charge_id,
				bill_flag,
				created_by)
			SELECT	pea.cpr_id,
				pea.encounter_id,
				pea.problem_id,
				@ll_encounter_charge_id,
				pea.bill_flag,
				@ps_created_by
			FROM p_Treatment_Item t
				INNER JOIN p_Encounter_Charge c
				ON t.cpr_id = c.cpr_id
				AND t.treatment_id = c.treatment_id
				AND t.procedure_id = c.procedure_id
				INNER JOIN p_Encounter_Assessment_Charge pea
				ON c.cpr_id = pea.cpr_id
				AND c.encounter_id = pea.encounter_id
				AND c.encounter_charge_id = pea.encounter_charge_id
			WHERE t.cpr_id = @ps_cpr_id
			AND t.treatment_id = @pl_treatment_id
			AND NOT EXISTS (
				SELECT 1
				FROM p_Encounter_Assessment_Charge pac
				WHERE pac.cpr_id = pea.cpr_id
				AND pac.encounter_id = pea.encounter_id
				AND pac.problem_id = pea.problem_id
				AND pac.encounter_charge_id = @ll_encounter_charge_id)
			END
		ELSE
			BEGIN
			-- 10.d
			-- If this is the primary treatment charge, or there is no primary treatment
			-- charge, associate this charge with each assessment-billing record where 
			-- the bill_flag = Y and the assessment is associated with this treatment.
			INSERT INTO p_Encounter_Assessment_Charge (
				cpr_id,
				encounter_id,
				problem_id,
				encounter_charge_id,
				bill_flag,
				created_by)
			SELECT	@ps_cpr_id,
				@pl_encounter_id,
				pat.problem_id,
				@ll_encounter_charge_id,
				'Y',
				@ps_created_by
			FROM p_Assessment_Treatment pat
				INNER JOIN p_Encounter_Assessment pea
				ON pat.cpr_id = pea.cpr_id
				AND pat.problem_id = pea.problem_id
			WHERE pat.cpr_id = @ps_cpr_id
			AND pat.treatment_id = @pl_treatment_id
			AND pea.cpr_id = @ps_cpr_id
			AND pea.encounter_id = @pl_encounter_id
			AND pea.bill_flag = 'Y'
			AND NOT EXISTS (
				SELECT 1
				FROM p_Encounter_Assessment_Charge pac
				WHERE pac.cpr_id = @ps_cpr_id
				AND pac.encounter_id = @pl_encounter_id
				AND pac.problem_id = pat.problem_id
				AND pac.encounter_charge_id = @ll_encounter_charge_id)
			END


		-- Billing Algorithm 10.e
		-- If no billed assessment-billing records have been associated with this
		-- charge, then associate this charge with each assessment-billing record
		-- which represents an actual diagnosis, where the bill_flag = Y, and
		-- where the c_Assessment_Type.well_encounter_flag for the existing
		-- assessment-billing record matches c_Procedure.well_encounter_flag for
		-- this charge.  An A in either field always matches.
		SELECT @ll_count = count(*)
		FROM p_Encounter_Assessment_Charge
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND encounter_charge_id = @ll_encounter_charge_id
		AND bill_flag = 'Y'

		IF @ll_count = 0
			BEGIN
			INSERT INTO p_Encounter_Assessment_Charge (
				cpr_id,
				encounter_id,
				problem_id,
				encounter_charge_id,
				bill_flag,
				created_by)
			SELECT	@ps_cpr_id,
				@pl_encounter_id,
				a.problem_id,
				@ll_encounter_charge_id,
				'Y',
				@ps_created_by
			FROM p_Encounter_Assessment a
				INNER JOIN c_Assessment_Definition ad
				ON a.assessment_id = ad.assessment_id
				INNER JOIN c_Assessment_Type t
				ON ad.assessment_type = t.assessment_type
			WHERE a.cpr_id = @ps_cpr_id
			AND a.encounter_id = @pl_encounter_id
			AND a.problem_id > 0  -- represents an actual diagnosis
			AND a.bill_flag = 'Y'
			AND dbo.fn_compare_well_encounter_flag(t.well_encounter_flag, @ls_procedure_well_encounter_flag) = 1  -- well_encounter_flags match
			AND NOT EXISTS (
				SELECT 1
				FROM p_Encounter_Assessment_Charge pac
				WHERE pac.cpr_id = @ps_cpr_id
				AND pac.encounter_id = @pl_encounter_id
				AND pac.problem_id = a.problem_id
				AND pac.encounter_charge_id = @ll_encounter_charge_id)
			END


		-- 10.g
		-- If the If the Payer-Assessment-Auto-Bill property is Y, A, C or B and the charge has
		-- an Auto-Billed-Assessment, then see if the new charge is already associated with an assessment-billing
		-- record with the same assessment_id as the Auto-Billed-Assessment.  If no such assessment-billing
		-- record exists, then do the following:
		-- i.	Create a new assessment-billing record for the Auto-Billed-Assessment
		-- ii.	If the Payer-Assessment-Auto-Bill property is Y or A, then disassociate the new charge from all
		--      assessments where the c_Assessment_Type.well_encounter_flag for the existing assessment-billing record
		--      does not match the c_Assessment_Type.well_encounter_flag for the new assessment-billing record.
		-- iii.	If the Payer-Assessment-Auto-Bill property is C or B. then disassociate the new charge from all assessments
		-- iv.	Associate the new charge with the assessment-billing record created in (i).  

		IF @ls_payer_assessment_auto_bill <> 'N' AND @ls_bill_assessment_id IS NOT NULL AND @ls_charge_bill_flag = 'Y' 
			BEGIN
			-- Make sure the bill_assessment_id is valid and get the well_encounter_flag for it
			SELECT @ls_bill_assessment_well_encounter_flag = coalesce(at.well_encounter_flag, 'A')
			FROM c_Assessment_Definition a
				INNER JOIN c_Assessment_Type at
				ON a.assessment_type = at.assessment_type
			WHERE a.assessment_id = @ls_bill_assessment_id
			
			IF @ls_bill_assessment_well_encounter_flag IS NOT NULL
				BEGIN
				-- 10.g.i  Create a new assessment-billing record for the Auto-Billed-Assessment
				IF @ls_payer_assessment_auto_bill IN ('A', 'B')
					SET @ls_exclusive_link = 'Y' -- the auto-billed assessment is exclusively linked to the charge
				ELSE
					SET @ls_exclusive_link = 'N'
				
				EXECUTE sp_set_assessment_billing
							@ps_cpr_id = @ps_cpr_id,
							@pl_encounter_id = @pl_encounter_id,
							@pl_problem_id = NULL,
							@ps_assessment_id = @ls_bill_assessment_id,
							@ps_bill_flag  = NULL,
							@ps_created_by = @ps_created_by,
							@ps_exclusive_link = @ls_exclusive_link


				-- 10.g.ii - the charge IS NOT exclusively linked to the assessment
				IF @ls_payer_assessment_auto_bill NOT IN ('C', 'B')
					BEGIN
					DELETE ac
					FROM p_Encounter_Assessment_Charge ac
						INNER JOIN p_Encounter_Assessment a
						ON ac.cpr_id = a.cpr_id
						AND ac.encounter_id = a.encounter_id
						AND ac.problem_id = a.problem_id
						INNER JOIN c_Assessment_Definition ad
						ON a.assessment_id = ad.assessment_id
						INNER JOIN c_Assessment_Type at
						ON ad.assessment_type = at.assessment_type
					WHERE ac.cpr_id = @ps_cpr_id
					AND ac.encounter_id = @pl_encounter_id
					AND ac.encounter_charge_id = @ll_encounter_charge_id
					AND dbo.fn_compare_well_encounter_flag(at.well_encounter_flag, @ls_bill_assessment_well_encounter_flag) = 0
					END

				-- 10.g.iii - the charge IS exclusively linked to the assessment
				IF @ls_payer_assessment_auto_bill IN ('C', 'B')
					BEGIN
					DELETE ac
					FROM p_Encounter_Assessment_Charge ac
						INNER JOIN p_Encounter_Assessment a
						ON ac.cpr_id = a.cpr_id
						AND ac.encounter_id = a.encounter_id
						AND ac.problem_id = a.problem_id
						INNER JOIN c_Assessment_Definition ad
						ON a.assessment_id = ad.assessment_id
						INNER JOIN c_Assessment_Type at
						ON ad.assessment_type = at.assessment_type
					WHERE ac.cpr_id = @ps_cpr_id
					AND ac.encounter_id = @pl_encounter_id
					AND ac.encounter_charge_id = @ll_encounter_charge_id
					END
				
				-- 10.g.iv   Associate the assessment with this charge
				INSERT INTO p_Encounter_Assessment_Charge (
					cpr_id,
					encounter_id,
					problem_id,
					encounter_charge_id,
					bill_flag,
					created_by)
				SELECT	a.cpr_id,
					a.encounter_id,
					a.problem_id,
					@ll_encounter_charge_id,
					'Y',
					@ps_created_by
				FROM p_Encounter_Assessment a
				WHERE a.cpr_id = @ps_cpr_id
				AND a.encounter_id = @pl_encounter_id
				AND a.assessment_id = @ls_bill_assessment_id
				AND a.bill_flag = 'Y'
				AND NOT EXISTS (
					SELECT 1
					FROM p_Encounter_Assessment_Charge pac
					WHERE pac.cpr_id = a.cpr_id
					AND pac.encounter_id = a.encounter_id
					AND pac.problem_id = a.problem_id
					AND pac.encounter_charge_id = @ll_encounter_charge_id)
				
				END -- If @ls_bill_assessment_id is valid
			END -- Billing Algorithm Section 10.f
		END -- IF @pl_treatment_id IS NOT NULL
	ELSE
		BEGIN
		-- New Non-Treatment Charge
		EXECUTE @ll_count = jmj_link_non_treatment_charge
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_encounter_charge_id = @ll_encounter_charge_id,
			@ps_created_by = @ps_created_by
		END


	END -- Link new charge to assessments

-- If this is a new treatment charge and it is the
-- the primary charge for the treatment and it is billed, then add the "Auto" extra charges
IF @ls_new_flag = 'Y'
	AND @pl_treatment_id IS NOT NULL
	AND @ls_charge_bill_flag = 'Y'
	AND @ps_order_extra_charges = 'Y'
	BEGIN
	IF @ps_procedure_id = @ls_treatment_procedure_id 
		OR EXISTS (	SELECT 1
					FROM p_Treatment_Item t
						INNER JOIN c_Observation o
						ON t.observation_id = o.observation_id
					WHERE cpr_id = @ps_cpr_id
					AND treatment_id = @pl_treatment_id
					AND (o.collection_procedure_id = @ps_procedure_id
					OR o.perform_procedure_id = @ps_procedure_id))
		BEGIN
		-- If the billed charge is directly from a treatment charge, then bill any "extra charges"
		EXECUTE jmj_add_extra_charges 	@ps_cpr_id = @ps_cpr_id,
										@pl_encounter_id = @pl_encounter_id,
										@ps_procedure_id = @ps_procedure_id,
										@pl_treatment_id = @pl_treatment_id,
										@ps_created_by = @ps_created_by
		END
	END

-- Finally, if this was an accumulating charge, then recalculate the accumulate record
IF @ls_charge_bill_flag = 'A'
	BEGIN
	SELECT @ll_accumulate_encounter_charge_id = min(encounter_charge_id)
	FROM p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND procedure_id = @ps_procedure_id
	AND treatment_id IS NULL
	AND bill_flag = 'Y'
	
	IF @ll_accumulate_encounter_charge_id IS NULL
		BEGIN
		-- Create the new charge record
		INSERT INTO p_Encounter_Charge (
			cpr_id,
			encounter_id,
			procedure_type,
			treatment_id,
			procedure_id,
			cpt_code,
			charge,
			units,
			modifier,
			other_modifiers,
			created_by,
			bill_flag )
		VALUES (
			@ps_cpr_id,
			@pl_encounter_id,
			@ls_procedure_type,
			NULL,
			@ps_procedure_id,
			@ls_cpt_code,
			@lm_charge,
			0,
			@ls_modifier,
			@ls_other_modifiers,
			@ps_created_by,
			'Y' )

		SET	@ll_accumulate_encounter_charge_id = SCOPE_IDENTITY()
		END
	
	UPDATE c
	SET units = (SELECT SUM(units)
				FROM p_Encounter_Charge
				WHERE cpr_id = @ps_cpr_id
				AND encounter_id = @pl_encounter_id
				AND procedure_id = @ps_procedure_id
				AND treatment_id IS NOT NULL
				AND bill_flag = 'A')
	FROM p_Encounter_Charge c
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND encounter_charge_id = @ll_accumulate_encounter_charge_id
	
	-- Link the accumulate charge to any assessments linked to the constituent treatments
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT DISTINCT	ac.cpr_id,
		ac.encounter_id,
		ac.problem_id,
		@ll_accumulate_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Charge c
		INNER JOIN p_Encounter_Assessment_Charge ac
		ON ac.cpr_id = c.cpr_id
		AND ac.encounter_id = c.encounter_id
		AND ac.encounter_charge_id = c.encounter_charge_id
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.procedure_id = @ps_procedure_id
	AND c.treatment_id IS NOT NULL
	AND c.bill_flag = 'A'
	AND ac.bill_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Encounter_Assessment_Charge pac
		WHERE pac.cpr_id = ac.cpr_id
		AND pac.encounter_id = ac.encounter_id
		AND pac.problem_id = ac.problem_id
		AND pac.encounter_charge_id = @ll_accumulate_encounter_charge_id)

	
	END

RETURN @ll_encounter_charge_id

GO
GRANT EXECUTE
	ON [dbo].[sp_add_encounter_charge]
	TO [cprsystem]
GO

