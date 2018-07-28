CREATE PROCEDURE dbo.sp_insert_assessment_treat_def
	(@ps_assessment  varchar(24),
	@ps_treatment_type varchar(24),
	@ps_treatment_desc varchar(255),
	@ps_user_id varchar(24),
	@pi_sort_sequence  integer,
	@ps_instructions varchar(50),
	@pl_parent_definition_id integer,
	@pc_child_flag char,
	@pl_followup_workplan_id int,
	@pl_definition_id integer OUTPUT)
AS

IF @pl_definition_id IS NULL Or @pl_definition_id = 0
	BEGIN
	INSERT INTO dbo.u_Assessment_Treat_Definition
	(
	assessment_id,
	treatment_type,
	treatment_description,
	user_id,
	sort_sequence,
	instructions,
	parent_definition_id,
	followup_workplan_id,
	child_flag
	)
	VALUES
	(
	@ps_assessment,
	@ps_treatment_type,
	@ps_treatment_desc,
	@ps_user_id,
	@pi_sort_sequence,
	@ps_instructions,
	@pl_parent_definition_id,
	@pl_followup_workplan_id,
	@pc_child_flag
	)

	SELECT @pl_definition_id = @@IDENTITY
	END
ELSE
	BEGIN
	UPDATE dbo.u_Assessment_Treat_Definition
	SET followup_workplan_id = @pl_followup_workplan_id
	WHERE definition_id = @pl_definition_id
	END
SELECT @pl_definition_id

