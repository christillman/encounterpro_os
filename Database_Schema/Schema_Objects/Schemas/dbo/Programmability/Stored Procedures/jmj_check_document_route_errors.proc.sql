CREATE PROCEDURE jmj_check_document_route_errors (
	@pl_patient_workplan_item_id int,
	@ps_ordered_for varchar(24),
	@ps_document_route varchar(24))
AS

SELECT error_id ,
	severity ,
	severity_text ,
	error_text ,
	allow_override
FROM dbo.fn_check_document_route_errors(@pl_patient_workplan_item_id, @ps_ordered_for, @ps_document_route)


