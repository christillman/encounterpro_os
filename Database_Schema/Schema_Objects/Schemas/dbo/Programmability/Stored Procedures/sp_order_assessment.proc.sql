CREATE PROCEDURE sp_order_assessment (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_assessment_id varchar(24),
	@pdt_begin_date datetime = NULL,
	@ps_diagnosed_by varchar(24),
	@ps_created_by varchar(24),
	@pl_problem_id int OUTPUT )
AS


DECLARE @ls_assessment_type varchar(24),
	@ls_assessment varchar(80)

SELECT @ls_assessment_type = assessment_type,
	@ls_assessment = description
FROM c_Assessment_Definition
WHERE assessment_id = @ps_assessment_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Assessment not found (%s)',16,-1, @ps_assessment_id)
	ROLLBACK TRANSACTION
	RETURN
	END


IF @pdt_begin_date IS NULL
	SELECT @pdt_begin_date = getdate()

EXECUTE sp_get_next_key
	@ps_cpr_id = @ps_cpr_id,
	@ps_key_id = 'PROBLEM_ID',
	@pl_key_value = @pl_problem_id OUTPUT

INSERT INTO p_Assessment (
	cpr_id,
	problem_id,
	diagnosis_sequence,
	open_encounter_id,
	begin_date,
	assessment_type,
	assessment_id,
	assessment,
	diagnosed_by,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@pl_problem_id,
	1,
	@pl_encounter_id,
	@pdt_begin_date,
	@ls_assessment_type,
	@ps_assessment_id,
	@ls_assessment,
	@ps_diagnosed_by,
	getdate(),
	@ps_created_by )


