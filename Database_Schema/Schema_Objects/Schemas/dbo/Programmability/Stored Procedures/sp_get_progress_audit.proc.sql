CREATE PROCEDURE sp_get_progress_audit (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)
AS


 SELECT [cpr_id] ,
		[context_object] ,
		[object_key] ,
		[progress_sequence] ,
		[encounter_id] ,
		[user_id] ,
		[progress_date_time] ,
		[progress_type] ,
		[progress_key] ,
		[progress_value] ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by]
FROM dbo.fn_progress_all(@ps_cpr_id,
					@ps_context_object,
					@pl_object_key)

