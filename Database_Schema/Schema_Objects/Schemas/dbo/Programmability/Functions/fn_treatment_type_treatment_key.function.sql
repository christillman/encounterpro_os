CREATE FUNCTION fn_treatment_type_treatment_key (
	@ps_treatment_type varchar(24) )

RETURNS varchar(64)

AS
BEGIN
DECLARE @ls_component_id varchar(24),
		@ls_treatment_key varchar(64)

SELECT @ls_component_id = component_id
FROM c_Treatment_Type
WHERE treatment_type = @ps_treatment_type

IF @@ROWCOUNT <> 1
	SET @ls_component_id = NULL

SET @ls_treatment_key = CASE @ls_component_id
		WHEN 'TREAT_IMMUNIZATION' THEN 'drug_id'
		WHEN 'TREAT_MATERIAL' THEN 'material_id'
		WHEN 'TREAT_MEDICATION' THEN 'drug_id'
		WHEN 'TREAT_OFFICEMED' THEN 'drug_id'
		WHEN 'TREAT_PROCEDURE' THEN 'procedure_id'
		WHEN 'TREAT_TEST' THEN 'observation_id'
		WHEN 'TREAT_ACTIVITY' THEN 'treatment_description'
		ELSE 'treatment_type' END

RETURN @ls_treatment_key 

END

