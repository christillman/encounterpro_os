CREATE FUNCTION fn_context_object_properties (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(12),
	@pl_object_key int )

RETURNS @properties TABLE (
	cpr_id varchar(12) NULL,
	encounter_id int NULL,
	context_object varchar(24) NOT NULL,
	object_key int NULL,
	context_object_type varchar(24) NULL)

AS
BEGIN
DECLARE @ls_context_object_type varchar(24),
		@ll_encounter_id int

SET @ls_context_object_type = NULL
SET @ll_encounter_id = NULL

IF @ps_context_object = 'General'
	SET @ls_context_object_type = 'General'

IF @ps_context_object = 'Patient'
	SET @ls_context_object_type = 'Patient'

IF @ps_context_object = 'Encounter'
	SELECT @ls_context_object_type = encounter_type,
			@ll_encounter_id = encounter_id
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	SELECT @ls_context_object_type = assessment_type,
			@ll_encounter_id = open_encounter_id
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SELECT @ls_context_object_type = treatment_type,
			@ll_encounter_id = open_encounter_id
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	SET @ls_context_object_type = 'Observation'

IF @ps_context_object = 'Attachment'
	SELECT @ls_context_object_type = attachment_type,
			@ll_encounter_id = encounter_id
	FROM p_Attachment
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_object_key

INSERT INTO @properties (
	cpr_id,
	encounter_id,
	context_object,
	object_key,
	context_object_type)
VALUES (
	@ps_cpr_id,
	@ll_encounter_id,
	@ps_context_object,
	@pl_object_key,
	@ls_context_object_type)

RETURN

END

