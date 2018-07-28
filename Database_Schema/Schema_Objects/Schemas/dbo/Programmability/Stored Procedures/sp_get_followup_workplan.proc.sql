CREATE PROCEDURE sp_get_followup_workplan (
	@ps_workplan_type varchar(12),
	@pl_followup_workplan_id int OUTPUT)
AS
SELECT @pl_followup_workplan_id = min(workplan_id)
FROM c_Workplan
Where workplan_type = @ps_workplan_type

SELECT @pl_followup_workplan_id

