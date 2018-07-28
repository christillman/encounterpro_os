CREATE PROCEDURE sp_set_treatment_billing (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_problem_id integer = NULL,
	@pl_treatment_id integer,
	@ps_procedure_type varchar(12) = '%',
	@ps_bill_flag char(1),
	@ps_created_by varchar(24) )
AS

-- @ps_problem_id is obsolete and not used

DECLARE @ls_bill_flag char(1),
	@ll_encounter_charge_id integer,
	@li_charge_count smallint,
	@ls_procedure_id varchar(24)

DECLARE lc_charges CURSOR FOR
	SELECT encounter_charge_id,
		bill_flag
	FROM p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND treatment_id = @pl_treatment_id
	AND procedure_type LIKE @ps_procedure_type

SELECT @li_charge_count = 0

OPEN lc_charges

FETCH lc_charges INTO @ll_encounter_charge_id, @ls_bill_flag

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @li_charge_count = @li_charge_count + 1

	EXECUTE sp_set_charge_billing
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_encounter_charge_id = @ll_encounter_charge_id,
		@ps_bill_flag = @ps_bill_flag,
 		@ps_created_by = @ps_created_by

	FETCH lc_charges INTO @ll_encounter_charge_id, @ls_bill_flag
	END

CLOSE lc_charges

DEALLOCATE lc_charges

-- If we didn't find any charges but the user wants to bill this treatment, find the
-- appropriate charge based on the procedure_type
IF @li_charge_count = 0 AND @ps_bill_flag = 'Y'
	BEGIN
	IF @ps_procedure_type = 'PROCEDURE'
		BEGIN
		SELECT @ls_procedure_id = procedure_id
		FROM p_Treatment_Item
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		
		IF @ls_procedure_id IS NOT NULL
			EXECUTE sp_add_encounter_charge
				@ps_cpr_id = @ps_cpr_id,
				@pl_encounter_id = @pl_encounter_id,
				@pl_treatment_id = @pl_treatment_id,
				@ps_procedure_id = @ls_procedure_id,
				@ps_created_by = @ps_created_by,
				@ps_replace_flag = 'N'
		END
	ELSE IF @ps_procedure_type = 'TESTPERFORM'
		BEGIN
		SELECT @ls_procedure_id = o.perform_procedure_id
		FROM p_Treatment_Item t
			INNER JOIN c_Observation o
			ON t.observation_id = o.observation_id
		WHERE t.cpr_id = @ps_cpr_id
		AND t.treatment_id = @pl_treatment_id
		
		IF @ls_procedure_id IS NOT NULL
			EXECUTE sp_add_encounter_charge
				@ps_cpr_id = @ps_cpr_id,
				@pl_encounter_id = @pl_encounter_id,
				@pl_treatment_id = @pl_treatment_id,
				@ps_procedure_id = @ls_procedure_id,
				@ps_created_by = @ps_created_by,
				@ps_replace_flag = 'N'
		END
	ELSE IF @ps_procedure_type = 'TESTCOLLECT'
		BEGIN
		SELECT @ls_procedure_id = o.collection_procedure_id
		FROM p_Treatment_Item t
			INNER JOIN c_Observation o
			ON t.observation_id = o.observation_id
		WHERE t.cpr_id = @ps_cpr_id
		AND t.treatment_id = @pl_treatment_id
		
		IF @ls_procedure_id IS NOT NULL
			EXECUTE sp_add_encounter_charge
				@ps_cpr_id = @ps_cpr_id,
				@pl_encounter_id = @pl_encounter_id,
				@pl_treatment_id = @pl_treatment_id,
				@ps_procedure_id = @ls_procedure_id,
				@ps_created_by = @ps_created_by,
				@ps_replace_flag = 'N'
		END
	END

