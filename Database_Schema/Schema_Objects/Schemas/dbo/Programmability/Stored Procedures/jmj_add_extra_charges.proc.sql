CREATE PROCEDURE jmj_add_extra_charges (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_procedure_id varchar(24) = NULL,
	@pl_treatment_id integer = NULL,
	@ps_created_by varchar(24) )
AS

DECLARE @ls_extra_procedure_id varchar(24)

DECLARE lc_extracharges CURSOR LOCAL FAST_FORWARD FOR
	SELECT extra_procedure_id
	FROM c_Procedure_extra_charge
	WHERE procedure_id = @ps_procedure_id
	AND order_flag = 'Auto'
	AND extra_procedure_id <> @ps_procedure_id
	ORDER BY sort_sequence

OPEN lc_extracharges

FETCH lc_extracharges INTO @ls_extra_procedure_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_add_encounter_charge 	@ps_cpr_id = @ps_cpr_id,
										@pl_encounter_id = @pl_encounter_id,
										@ps_procedure_id = @ls_extra_procedure_id,
										@pl_treatment_id = @pl_treatment_id,
										@ps_created_by = @ps_created_by,
										@ps_replace_flag = 'N',
										@ps_order_extra_charges = 'N'

	FETCH lc_extracharges INTO @ls_extra_procedure_id
	END

CLOSE lc_extracharges								
DEALLOCATE lc_extracharges								


