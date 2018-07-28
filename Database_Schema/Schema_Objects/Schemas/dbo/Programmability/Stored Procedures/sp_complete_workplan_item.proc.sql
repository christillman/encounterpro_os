CREATE PROCEDURE sp_complete_workplan_item
	(
	@pl_patient_workplan_item_id int,
	@ps_completed_by varchar(24),
	@ps_progress_type varchar(24) = 'COMPLETED',
	@pdt_progress_date_time datetime = NULL,
	@ps_created_by varchar(24)
	)
AS


-- All of the logic for this procedure has been assumed by sp_set_workplan_item_progress.  This
-- stored procedure is kept for backward compatibility.
EXECUTE sp_set_workplan_item_progress
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_user_id = @ps_completed_by,
	@ps_progress_type = @ps_progress_type,
	@pdt_progress_date_time = @pdt_progress_date_time,
	@ps_created_by = @ps_created_by

