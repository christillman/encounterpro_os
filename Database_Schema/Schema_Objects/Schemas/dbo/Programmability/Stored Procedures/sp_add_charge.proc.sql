CREATE PROCEDURE sp_add_charge (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_procedure_id varchar(24) = NULL,
	@pl_problem_id integer = NULL,
	@pl_treatment_id integer = NULL,
	@ps_created_by varchar(24) )
AS

-- This stored procecure is obsolete.  sp_add_encounter_charge should be used.


EXECUTE sp_add_encounter_charge
	@ps_cpr_id = @ps_cpr_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_procedure_id = @ps_procedure_id,
	@pl_treatment_id = @pl_treatment_id,
	@ps_created_by = @ps_created_by,
	@ps_replace_flag = 'N',
	@ps_procedure_type = NULL



