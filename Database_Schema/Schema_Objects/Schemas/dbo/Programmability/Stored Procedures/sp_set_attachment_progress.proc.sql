CREATE PROCEDURE sp_set_attachment_progress (
	@ps_cpr_id varchar(12),
	@pl_attachment_id int = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@ps_user_id varchar(24),
	@pdt_progress_date_time datetime = NULL,
	@ps_progress_type varchar(24),
	@ps_progress text = NULL ,
	@ps_created_by varchar(24) )
AS

DECLARE @ll_attachment_progress_sequence int


IF @pdt_progress_date_time IS NULL
	SET @pdt_progress_date_time = getdate()

INSERT INTO p_Attachment_Progress (
	attachment_id,
	cpr_id,
	patient_workplan_item_id,
	user_id,
	progress_date_time,
	progress_type,
	progress,
	created,
	created_by )
VALUES (
	@pl_attachment_id,
	@ps_cpr_id,
	@pl_patient_workplan_item_id,
	@ps_user_id,
	@pdt_progress_date_time,
	@ps_progress_type,
	@ps_progress,
	getdate(),
	@ps_created_by )

SET @ll_attachment_progress_sequence = SCOPE_IDENTITY()

RETURN @ll_attachment_progress_sequence



