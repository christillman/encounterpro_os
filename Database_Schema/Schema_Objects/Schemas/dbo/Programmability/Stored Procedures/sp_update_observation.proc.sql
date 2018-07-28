CREATE PROCEDURE sp_update_observation (
	@ps_observation_id varchar(24),
	@ps_collection_location_domain varchar(12) = 'NA',
	@ps_perform_location_domain varchar(12) = 'NA',
	@ps_collection_procedure_id varchar(24) = NULL,
	@ps_perform_procedure_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_composite_flag char(1) = 'N',
	@ps_exclusive_flag char(1) = 'N',
	@ps_in_context_flag char(1) = 'N',
	@ps_location_pick_flag char(1) = 'N',
	@ps_location_bill_flag char(1) = 'N',
	@ps_observation_type varchar(24) = 'Subjective',
	@ps_default_view char(1) = NULL,
	@ps_display_style varchar(255) = NULL,
	@ps_status varchar(12) = NULL )
AS

IF @ps_status = ''
	SET @ps_status = NULL

DECLARE @ls_old_description varchar(80)

SELECT @ls_old_description = description
FROM c_Observation
WHERE observation_id = @ps_observation_id

UPDATE c_Observation
SET	description = @ps_description,
	collection_location_domain = @ps_collection_location_domain,
	perform_location_domain = @ps_perform_location_domain,
	collection_procedure_id = @ps_collection_procedure_id,
	perform_procedure_id = @ps_perform_procedure_id,
	composite_flag = @ps_composite_flag,
	exclusive_flag = @ps_exclusive_flag,
	in_context_flag = @ps_in_context_flag,
	location_pick_flag = @ps_location_pick_flag,
	location_bill_flag = @ps_location_bill_flag,
	observation_type = @ps_observation_type,
	default_view = @ps_default_view,
	display_style = @ps_display_style,
	status = COALESCE(@ps_status, status)
WHERE	observation_id = @ps_observation_id

-- update treatment list
IF @ls_old_description <> @ps_description
BEGIN
UPDATE u_Assessment_Treat_Definition
SET treatment_description = @ps_description
WHERE EXISTS (
	SELECT u_assessment_treat_def_attrib.definition_id
	FROM u_Assessment_Treat_Def_Attrib
	WHERE attribute like '%observation_id'
	AND value = @ps_observation_id
	AND u_assessment_treat_definition.definition_id = u_assessment_treat_def_attrib.definition_id
	)

-- update top 20
UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_observation_id
AND top_20_code like 'TEST%'
END

