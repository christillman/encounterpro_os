CREATE FUNCTION dbo.fn_workplan_item_owned_by (
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int,
	@pl_patient_workplan_item_id int,
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24) )

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_dispatch_method varchar(24)

SELECT @ls_dispatch_method = dispatch_method
FROM p_Patient_WP_Item
WHERE @pl_patient_workplan_item_id = @pl_patient_workplan_item_id

RETURN dbo.fn_workplan_item_owned_by_2(@ps_ordered_for, @pl_patient_workplan_id, @ps_cpr_id, @pl_encounter_id, @ps_ordered_by, @ls_dispatch_method)

END

