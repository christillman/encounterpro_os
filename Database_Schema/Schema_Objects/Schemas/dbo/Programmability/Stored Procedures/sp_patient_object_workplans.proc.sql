CREATE PROCEDURE sp_patient_object_workplans (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )

AS

SELECT 
	[patient_workplan_id] ,
	[cpr_id] ,
	[workplan_id] ,
	[workplan_type] ,
	[in_office_flag] ,
	[mode] ,
	[last_step_dispatched] ,
	[last_step_date] ,
	[encounter_id] ,
	[problem_id] ,
	[treatment_id] ,
	[observation_sequence] ,
	[attachment_id] ,
	[description] ,
	[ordered_by] ,
	[owned_by] ,
	[parent_patient_workplan_item_id] ,
	[status] ,
	[created_by] ,
	[created] ,
	[id] 
FROM dbo.fn_patient_object_workplans(@ps_cpr_id, @ps_context_object, @pl_object_key)



