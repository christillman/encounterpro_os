CREATE PROCEDURE jmjdoc_get_progress (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(48),
	@ps_attachments_only_flag char(1) = 'N' )
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
		progress_value = COALESCE(CAST([progress] AS varchar(4000)), [progress_value]) ,
		[progress] ,
		[attachment_id] ,
		[patient_workplan_item_id] ,
		[risk_level] ,
		[created] ,
		[created_by]
FROM dbo.fn_progress(@ps_cpr_id,
					@ps_context_object,
					@pl_object_key,
					@ps_progress_type,
					@ps_progress_key,
					@ps_attachments_only_flag)
WHERE progress_type not in ('modify','created','closed','cancelled','assessment','reviewed','modified')



