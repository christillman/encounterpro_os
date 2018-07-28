CREATE FUNCTION fn_context_object_type_description (
	@ps_context_object varchar(24),
	@ps_context_object_type varchar(40))

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_description varchar(80)

SET @ls_description = NULL

IF @ps_context_object = 'General'
	SET @ls_description = 'General'

IF @ps_context_object = 'Patient'
	SET @ls_description = 'Patient'

IF @ps_context_object = 'Encounter'
	SELECT @ls_description = description
	FROM c_Encounter_Type
	WHERE encounter_type = @ps_context_object_type

IF @ps_context_object = 'Assessment'
	SELECT @ls_description = description
	FROM c_Assessment_Type
	WHERE assessment_type = @ps_context_object_type

IF @ps_context_object = 'Treatment'
	SELECT @ls_description = description
	FROM c_Treatment_Type
	WHERE treatment_type = @ps_context_object_type

IF @ps_context_object = 'Observation'
	SET @ls_description = 'Observation'

IF @ps_context_object = 'Attachment'
	SELECT @ls_description = description
	FROM c_Attachment_Type
	WHERE attachment_type = @ps_context_object_type

IF @ls_description IS NULL
	SET @ls_description = @ps_context_object_type

RETURN @ls_description 

END

