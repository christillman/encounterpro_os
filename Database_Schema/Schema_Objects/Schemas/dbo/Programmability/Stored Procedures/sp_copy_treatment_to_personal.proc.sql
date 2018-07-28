CREATE PROCEDURE sp_copy_treatment_to_personal (
	@ps_user_id varchar(24),
	@pl_definition_id int,
	@pl_parent_definition_id int = NULL,
	@pl_new_definition_id int OUTPUT )
AS

INSERT INTO u_Assessment_Treat_Definition (
	assessment_id,
	treatment_type,
	treatment_description,
	workplan_id,
	followup_workplan_id,
	user_id,
	sort_sequence,
	instructions,
	parent_definition_id )
SELECT	assessment_id,
	treatment_type,
	treatment_description,
	workplan_id,
	followup_workplan_id,
	@ps_user_id,
	sort_sequence,
	instructions,
	@pl_parent_definition_id
FROM u_Assessment_Treat_Definition def
WHERE def.definition_id = @pl_definition_id

SELECT @pl_new_definition_id = @@IDENTITY
IF @pl_new_definition_id IS NOT NULL
BEGIN
INSERT INTO u_Assessment_Treat_Def_Attrib (
       definition_id,
	attribute,
	value )
SELECT @pl_new_definition_id,
	attribute,
	value
FROM u_Assessment_Treat_Def_Attrib
WHERE definition_id = @pl_definition_id
END


