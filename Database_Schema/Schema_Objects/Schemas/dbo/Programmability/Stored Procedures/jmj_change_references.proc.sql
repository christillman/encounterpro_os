CREATE PROCEDURE [dbo].[jmj_change_references] (
	@ps_module_type [varchar] (24) ,
	@ps_object_id [varchar] (40) ,
	@ps_new_object_id [varchar] (40) ,
	@ps_user_id [varchar] (24) )
AS

DECLARE @ls_attribute_pattern varchar(40)

IF @ps_module_type NOT IN ('Report', 'Observation Tree', 'Encounter Type', 'Assessment Definition', 'Treatment Type')
	BEGIN
	RAISERROR ('Invalid Module Type (%s)', 16, -1, @ps_module_type)
	RETURN
	END 

IF @ps_module_type = 'Report'
	BEGIN
	SET @ls_attribute_pattern = '%report_id'
	END

IF @ps_module_type = 'Observation Tree'
	BEGIN
	SET @ls_attribute_pattern = '%observation_id'
	END

IF @ps_module_type = 'Encounter Type'
	BEGIN
	SET @ls_attribute_pattern = '%encounter_type'
	END

IF @ps_module_type = 'Assessment Definition'
	BEGIN
	SET @ls_attribute_pattern = '%assessment_id'
	END

IF @ps_module_type = 'Treatment Type'
	BEGIN
	SET @ls_attribute_pattern = '%treatment_type'
	END



UPDATE c_display_script_cmd_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE o_Preferences
SET preference_value = @ps_new_object_id
WHERE preference_id LIKE @ls_attribute_pattern
AND preference_value = @ps_object_id

UPDATE c_Chart_Section_Page_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE c_Treatment_Type_Service_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE c_Workplan_Item_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE c_Menu_Item_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE o_Service_Attribute
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id

UPDATE u_assessment_treat_def_attrib
SET value = @ps_new_object_id
WHERE attribute LIKE @ls_attribute_pattern
AND value = @ps_object_id




