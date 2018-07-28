CREATE PROCEDURE dbo.xml_set_document_mapping (
	@pl_patient_workplan_item_id int ,
	@pl_code_id int ,
	@ps_map_action varchar(12))

AS

IF @pl_patient_workplan_item_id > 0 
	AND @pl_code_id > 0 
	AND @ps_map_action IS NOT NULL
	AND NOT EXISTS (
		SELECT 1 
		FROM x_Document_Mapping 
		WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
		AND code_id = @pl_code_id)
	INSERT INTO x_Document_Mapping (
		patient_workplan_item_id,
		code_id,
		map_action)
	VALUES (
		@pl_patient_workplan_item_id,
		@pl_code_id,
		@ps_map_action)


