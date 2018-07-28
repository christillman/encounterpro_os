CREATE PROCEDURE jmj_set_incoming_attachment_ready (
	@pl_attachment_id int,
	@pl_interfaceserviceid int,
	@pl_transportsequence int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	)
AS

-- This procedure sets the status of an attachment to 'OK' and creates an 'Incoming' workflow record
-- in p_Patient_WP_Item table.

DECLARE @ll_error int,
		@ll_rowcount int,
		@ll_patient_workplan_item_id int,
		@ls_document_user_id varchar(24),
		@ls_status varchar(12),
		@ls_description varchar(80)

IF @pl_attachment_id IS NULL
	BEGIN
	RAISERROR('Attachment_id is NULL', 16, -1)
	RETURN -1
	END

SET @ls_document_user_id = dbo.fn_get_global_preference('SYSTEM', 'Document Server user_id')
IF @ls_document_user_id IS NULL
	SET @ls_document_user_id = '#JMJ'

SELECT @ls_status = status, 
		@ls_description = attachment_tag
FROM p_Attachment
WHERE attachment_id = @pl_attachment_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 0
	BEGIN
	RAISERROR('Attachment_id not found (%d)', 16, -1, @pl_attachment_id)
	RETURN -1
	END

IF @ls_status <> 'New'
	BEGIN
	RAISERROR('Attachment status is not ''New'' (%d)', 16, -1, @pl_attachment_id)
	RETURN -1
	END

BEGIN TRANSACTION


INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	item_number,
	item_type,
	description,
	attachment_id,
	ordered_by,
	ordered_for,
	status,
	created_by)
VALUES	(
	0,
	@pl_interfaceserviceid,  -- repurposeing workplan_id and item_number to hold the interface/route that this document came through
	@pl_transportsequence,
	'Incoming',
	@ls_description,
	@pl_attachment_id,
	@ps_user_id,
	@ls_document_user_id,
	'Ready',
	@ps_created_by )


SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ll_patient_workplan_item_id = SCOPE_IDENTITY()

INSERT INTO p_Attachment_Progress (
	attachment_id,
	patient_workplan_item_id,
	user_id,
	progress_date_time,
	progress_type,
	created,
	created_by )
VALUES (
	@pl_attachment_id,
	@ll_patient_workplan_item_id,
	@ps_user_id,
	getdate(),
	'Incoming',
	getdate(),
	@ps_created_by )

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

RETURN 1



