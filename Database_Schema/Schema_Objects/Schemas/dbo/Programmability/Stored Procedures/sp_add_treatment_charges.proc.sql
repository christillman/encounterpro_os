﻿CREATE PROCEDURE sp_add_treatment_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_treatment_id integer,
	@ps_created_by varchar(24) )
AS

DECLARE @ls_procedure_id varchar(24),
		@ls_observation_id varchar(24),
		@ls_collection_procedure_id varchar(24),
		@ls_perform_procedure_id varchar(24)

-- If there is no encounter_id, then we have nothing to do here
IF @pl_encounter_id IS NULL
	RETURN

SELECT @ls_procedure_id = procedure_id,
		@ls_observation_id = observation_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @@ROWCOUNT = 0
	BEGIN
	RAISERROR ('Invalid Treatment (%s, %d)',16,-1, @ps_cpr_id, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ls_procedure_id IS NOT NULL
	BEGIN
	EXECUTE sp_add_encounter_charge  
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_procedure_id = @ls_procedure_id,
			@pl_treatment_id = @pl_treatment_id,
			@ps_created_by = @ps_created_by,
			@ps_replace_flag = 'N'
	END

IF @ls_observation_id IS NOT NULL
	EXECUTE jmj_set_treatment_observation_billing
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_treatment_id = @pl_treatment_id,
		@ps_created_by = @ps_created_by

