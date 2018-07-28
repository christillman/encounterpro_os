CREATE FUNCTION fn_document_mapping_status (
	@pl_patient_workplan_item_id int)

RETURNS varchar(12)

AS
BEGIN
DECLARE @ls_status varchar(12),
		@ll_count int


IF EXISTS (SELECT 1
			FROM x_Document_Mapping x
				INNER JOIN c_XML_Code c
				ON x.code_id = c.code_id
			WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
			AND x.map_action = 'Fail'
			AND c.status = 'Unmapped')
	RETURN 'Failed'

IF EXISTS (SELECT 1
			FROM x_Document_Mapping x
			WHERE patient_workplan_item_id = @pl_patient_workplan_item_id)
	RETURN 'Success'

RETURN 'NA'

END
