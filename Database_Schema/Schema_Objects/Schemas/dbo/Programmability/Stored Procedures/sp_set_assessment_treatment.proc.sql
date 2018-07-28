CREATE PROCEDURE sp_set_assessment_treatment (
	@ps_cpr_id varchar(12),
	@pl_problem_id int ,
	@pl_treatment_id int ,
	@pl_encounter_id int ,
	@ps_created_by varchar(24) )
AS

IF NOT EXISTS (select * 
				from p_Assessment_Treatment 
				WHERE cpr_id = @ps_cpr_id
				AND problem_id = @pl_problem_id
				AND treatment_id = @pl_treatment_id )
	INSERT INTO p_Assessment_Treatment (
		cpr_id,
		problem_id,
		treatment_id,
		encounter_id,
		created,
		created_by,
		id)
	VALUES (
		@ps_cpr_id,
		@pl_problem_id,
		@pl_treatment_id,
		@pl_encounter_id,
		getdate(),
		@ps_created_by,
		newid())

