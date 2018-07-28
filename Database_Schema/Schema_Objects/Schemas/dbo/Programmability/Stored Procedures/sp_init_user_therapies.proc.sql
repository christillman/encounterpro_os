CREATE PROCEDURE sp_init_user_therapies (
	@ps_user_id varchar(24),
	@ps_assessment_id varchar(24),
	@ps_common_list_id varchar(24),
	@pl_old_parent_definition_id int = NULL ,
	@pl_new_parent_definition_id int = NULL )
AS

DECLARE @ll_definition_id int,
		@ls_treatment_type varchar(24),
		@ls_treatment_description varchar(80),
		@ll_workplan_id int,
		@ll_followup_workplan_id int,
		@li_sort_sequence smallint,
		@ls_instructions varchar(50),
		@ls_child_flag char(1),
		@ll_new_definition_id int

-- First, get a list of all the treatment definitions for the common list
-- Note that we'll either get all the root records (parent_definition_id = NULL)
-- or we'll get all the child records for the specified parent.
DECLARE lc_defs CURSOR LOCAL FOR
SELECT	definition_id,
	treatment_type,
	treatment_description,
	workplan_id,
	followup_workplan_id,
	sort_sequence,
	instructions,
	child_flag 
FROM u_Assessment_Treat_Definition def
WHERE def.user_id = @ps_common_list_id
AND def.assessment_id = @ps_assessment_id
AND ((def.parent_definition_id is null AND @pl_old_parent_definition_id IS NULL)
	 OR (def.parent_definition_id = @pl_old_parent_definition_id) )

OPEN lc_defs

FETCH lc_defs INTO
	@ll_definition_id,
	@ls_treatment_type,
	@ls_treatment_description,
	@ll_workplan_id,
	@ll_followup_workplan_id,
	@li_sort_sequence,
	@ls_instructions,
	@ls_child_flag 

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Copy the definition record
	INSERT INTO u_Assessment_Treat_Definition (
		assessment_id,
		treatment_type,
		treatment_description,
		workplan_id,
		followup_workplan_id,
		[user_id],
		sort_sequence,
		instructions,
		parent_definition_id,
		child_flag )
	VALUES (
		@ps_assessment_id,
		@ls_treatment_type,
		@ls_treatment_description,
		@ll_workplan_id,
		@ll_followup_workplan_id,
		@ps_user_id,
		@li_sort_sequence,
		@ls_instructions,
		@pl_new_parent_definition_id,
		@ls_child_flag  )

	SET @ll_new_definition_id = @@IDENTITY

	-- Copy the attributes
	INSERT INTO u_Assessment_Treat_Def_Attrib (
		definition_id,
		attribute,
		value )
	SELECT @ll_new_definition_id,
			attribute,
			value
	FROM u_Assessment_Treat_Def_Attrib
	WHERE definition_id = @ll_definition_id
	
	-- Now recursively call this SP to get any child treatments of this treatment
	EXECUTE sp_init_user_therapies
		@ps_user_id = @ps_user_id,
		@ps_assessment_id = @ps_assessment_id,
		@ps_common_list_id = @ps_common_list_id,
		@pl_old_parent_definition_id = @ll_definition_id,
		@pl_new_parent_definition_id = @ll_new_definition_id

	FETCH lc_defs INTO
		@ll_definition_id,
		@ls_treatment_type,
		@ls_treatment_description,
		@ll_workplan_id,
		@ll_followup_workplan_id,
		@li_sort_sequence,
		@ls_instructions,
		@ls_child_flag 

	END
CLOSE lc_defs
DEALLOCATE lc_defs


