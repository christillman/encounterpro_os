CREATE TRIGGER tr_p_Observation_insert ON dbo.p_Observation
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12), 
		@ll_treatment_id int, 
		@ll_encounter_id int,
		@ls_created_by varchar(24)

DECLARE lc_bill_treatment_observation CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT i.cpr_id, 
					i.treatment_id,
					i.encounter_id,
					i.created_by
	FROM inserted i
		INNER JOIN p_Treatment_Item t
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
	WHERE ISNULL(t.treatment_status, 'OPEN') = 'OPEN'
	AND (t.bill_observation_collect = 1 OR t.bill_observation_perform = 1)
	AND i.parent_observation_sequence IS NULL

OPEN lc_bill_treatment_observation

FETCH lc_bill_treatment_observation INTO @ls_cpr_id , 
						@ll_treatment_id ,
						@ll_encounter_id ,
						@ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN

	EXECUTE jmj_set_treatment_observation_billing
			@ps_cpr_id = @ls_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@pl_treatment_id = @ll_treatment_id,
			@ps_created_by = @ls_created_by

	FETCH lc_bill_treatment_observation INTO @ls_cpr_id , 
							@ll_treatment_id ,
							@ll_encounter_id ,
							@ls_created_by
	END

CLOSE lc_bill_treatment_observation
DEALLOCATE lc_bill_treatment_observation
	


