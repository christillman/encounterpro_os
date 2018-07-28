CREATE PROCEDURE dbo.sp_new_treatment_def (
		@pl_definition_id int OUTPUT,
		@ps_assessment_id varchar(24),
		@ps_treatment_type varchar(24),
		@ps_treatment_description varchar(255),
		@pl_followup_workplan_id int,
		@ps_user_id varchar(24),
		@pi_sort_sequence smallint,
		@ps_instructions varchar(50),
		@pl_parent_definition_id int,
		@ps_child_flag  char(1),
		@ps_treatment_mode varchar(24) = NULL)
AS

INSERT INTO u_Assessment_Treat_Definition (
	assessment_id,
	treatment_type,
	treatment_description,
	followup_workplan_id,
	user_id,
	sort_sequence,
	instructions,
	parent_definition_id,
	child_flag,
	treatment_mode )
VALUES (
	@ps_assessment_id,
	@ps_treatment_type,
	@ps_treatment_description,
	@pl_followup_workplan_id,
	@ps_user_id,
	@pi_sort_sequence,
	@ps_instructions,
	@pl_parent_definition_id,
	@ps_child_flag,
	@ps_treatment_mode );

SELECT @pl_definition_id = SCOPE_IDENTITY()

RETURN @pl_definition_id
