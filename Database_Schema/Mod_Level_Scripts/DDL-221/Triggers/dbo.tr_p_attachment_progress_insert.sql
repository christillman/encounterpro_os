
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_attachment_progress_insert]
Print 'Drop Trigger [dbo].[tr_p_attachment_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_attachment_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_attachment_progress_insert]
GO

-- Create Trigger [dbo].[tr_p_attachment_progress_insert]
Print 'Create Trigger [dbo].[tr_p_attachment_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_attachment_progress_insert ON dbo.p_Attachment_Progress
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_attachment_folder varchar(40)

DECLARE
	 @ATTACHMENT_FOLDER_flag SMALLINT
	,@ATTACHMENT_TAG_flag SMALLINT
	,@Canceled_flag SMALLINT
	,@CANCELLED_flag SMALLINT
	,@CHANGED_flag SMALLINT
	,@Closed_flag SMALLINT
	,@COLLECTED_flag SMALLINT
	,@COMPLETED_flag SMALLINT
	,@CONSOLIDATED_flag SMALLINT
	,@DECEASED_flag SMALLINT
	,@DELETED_flag SMALLINT
	,@DISPATCHED_flag SMALLINT
	,@DOLATER_flag SMALLINT
	,@ESCALATE_flag SMALLINT
	,@EXPIRE_flag SMALLINT
	,@Incoming_flag SMALLINT
	,@MODIFIED_flag SMALLINT
	,@Modify_flag SMALLINT
	,@MOVED_flag SMALLINT
	,@NEEDSAMPLE_flag SMALLINT
	,@Posted_flag SMALLINT
	,@Property_flag SMALLINT
	,@REDIAGNOSED_flag SMALLINT
	,@ReOpen_flag SMALLINT
	,@Revert_flag SMALLINT
	,@Runtime_Configured_flag SMALLINT
	,@skipped_flag SMALLINT
	,@STARTED_flag SMALLINT
	,@TEXT_flag SMALLINT
	,@ToBePosted_flag SMALLINT
	,@storage_flag_flag SMALLINT
	,@attachment_file_flag SMALLINT
	,@attachment_file_path_flag SMALLINT


/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@Canceled_flag = SUM( CHARINDEX( 'Canceled', inserted.progress_type ) )
	,@CANCELLED_flag = SUM( CHARINDEX( 'CANCELLED', inserted.progress_type ) )
	,@CHANGED_flag = SUM( CHARINDEX( 'CHANGED', inserted.progress_type ) )
	,@Closed_flag = SUM( CHARINDEX( 'Closed', inserted.progress_type ) )
	,@COLLECTED_flag = SUM( CHARINDEX( 'COLLECTED', inserted.progress_type ) )
	,@COMPLETED_flag = SUM( CHARINDEX( 'COMPLETED', inserted.progress_type ) )
	,@CONSOLIDATED_flag = SUM( CHARINDEX( 'CONSOLIDATED', inserted.progress_type ) )
	,@DECEASED_flag = SUM( CHARINDEX( 'DECEASED', inserted.progress_type ) )
	,@DELETED_flag = SUM( CHARINDEX( 'DELETED', inserted.progress_type ) )
	,@DISPATCHED_flag = SUM( CHARINDEX( 'DISPATCHED', inserted.progress_type ) )
	,@DOLATER_flag = SUM( CHARINDEX( 'DOLATER', inserted.progress_type ) )
	,@ESCALATE_flag = SUM( CHARINDEX( 'ESCALATE', inserted.progress_type ) )
	,@EXPIRE_flag = SUM( CHARINDEX( 'EXPIRE', inserted.progress_type ) )
	,@Incoming_flag = SUM( CHARINDEX( 'Incoming', inserted.progress_type ) )
	,@MODIFIED_flag = SUM( CHARINDEX( 'MODIFIED', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
	,@MOVED_flag = SUM( CHARINDEX( 'MOVED', inserted.progress_type ) )
	,@NEEDSAMPLE_flag = SUM( CHARINDEX( 'NEEDSAMPLE', inserted.progress_type ) )
	,@Posted_flag = SUM( CHARINDEX( 'Posted', inserted.progress_type ) )
	,@Property_flag = SUM( CHARINDEX( 'Property', inserted.progress_type ) )
	,@REDIAGNOSED_flag = SUM( CHARINDEX( 'REDIAGNOSED', inserted.progress_type ) )
	,@ReOpen_flag = SUM( CHARINDEX( 'ReOpen', inserted.progress_type ) )
	,@Revert_flag = SUM( CHARINDEX( 'Revert To Original Owner', inserted.progress_type ) )
	,@Runtime_Configured_flag = SUM( CHARINDEX( 'Runtime_Configured', inserted.progress_type ) )
	,@skipped_flag = SUM( CHARINDEX( 'Skipped', inserted.progress_type ) )
	,@STARTED_flag = SUM( CHARINDEX( 'STARTED', inserted.progress_type ) )
	,@TEXT_flag = SUM( CHARINDEX( 'TEXT', inserted.progress_type ) )
	,@ToBePosted_flag = SUM( CHARINDEX( 'ToBePosted', inserted.progress_type ) )
	,@storage_flag_flag = SUM( CHARINDEX( 'storage_flag', inserted.progress_type ) )
	,@attachment_file_flag = SUM( CHARINDEX( 'attachment_file', inserted.progress_type ) )
	,@attachment_file_path_flag = SUM( CHARINDEX( 'attachment_file_path', inserted.progress_type ) )
FROM inserted

IF @Incoming_flag > 0
BEGIN
	UPDATE a
	SET status = 'Incoming'
	FROM p_Attachment a
		INNER JOIN inserted i
		ON i.attachment_id = a.attachment_id
	AND i.progress_type = 'Incoming'
END

IF @Posted_flag > 0
BEGIN
	UPDATE a
	SET status = 'Posted'
	FROM p_Attachment a
		INNER JOIN inserted i
		ON i.attachment_id = a.attachment_id
	AND i.progress_type = 'Posted'
END

IF @storage_flag_flag > 0
BEGIN
	UPDATE p_Attachment
	SET storage_flag = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'storage_flag'
END

IF @attachment_file_flag > 0
BEGIN
	UPDATE p_Attachment
	SET attachment_file = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'attachment_file'
END

IF @attachment_file_path_flag > 0
BEGIN
	UPDATE p_Attachment
	SET attachment_file_path = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'attachment_file_path'
END

IF @TEXT_flag > 0
BEGIN
	UPDATE p_Attachment
	SET attachment_text = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'TEXT'
END

IF @ATTACHMENT_FOLDER_flag > 0
BEGIN
	UPDATE p_Attachment
	SET attachment_folder = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'ATTACHMENT_FOLDER'
END

IF @ATTACHMENT_TAG_flag > 0
BEGIN
	UPDATE p_Attachment
	SET attachment_tag = p_Attachment_Progress.progress
	FROM inserted
	JOIN p_Attachment ON inserted.attachment_id = p_Attachment.attachment_id
	JOIN p_Attachment_Progress ON inserted.attachment_id = p_Attachment_Progress.attachment_id
		AND inserted.attachment_progress_sequence = p_Attachment_Progress.attachment_progress_sequence
	WHERE inserted.progress_type = 'ATTACHMENT_TAG'
END

IF @ToBePosted_flag > 0
BEGIN
	SET @ls_attachment_folder = dbo.fn_get_global_preference('SERVERCONFIG', 'Incoming Document Attachment Folder')
	
	UPDATE a
	SET attachment_folder = @ls_attachment_folder,
		status = 'OK'
	FROM p_Attachment a
		INNER JOIN inserted i
		ON i.attachment_id = a.attachment_id
	AND i.progress_type = 'ToBePosted'
END

UPDATE t1
SET current_flag = 'N'
FROM p_Attachment_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.attachment_id = t2.attachment_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_date_time = t2.progress_date_time
WHERE t1.attachment_progress_sequence < t2.attachment_progress_sequence
OR t1.progress IS NULL


IF @DELETED_flag > 0
BEGIN
	-- Update the status of the attachment to deleted
	UPDATE p_Attachment
	SET status = inserted.progress_type
	FROM inserted
	WHERE inserted.attachment_id = p_Attachment.attachment_id
	AND inserted.progress_type = 'DELETED'
	
	
	-- Now remove the attachment from each patient object where it is attached.  Do this
	-- by calling the sp_remove_attachment stored procedure for each deleted attachment
	DECLARE @ls_cpr_id varchar(12),
			@ll_attachment_id int,
			@ls_user_id varchar(24),
			@ls_created_by varchar(24)
	
	DECLARE lc_deleted CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
		SELECT cpr_id, attachment_id, user_id, created_by
		FROM inserted
		WHERE progress_type = 'DELETED'
	
	OPEN lc_deleted
	
	FETCH lc_deleted INTO @ls_cpr_id, @ll_attachment_id, @ls_user_id, @ls_created_by
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
		
		EXECUTE sp_remove_attachment
					@ps_cpr_id = @ls_cpr_id,
					@pl_attachment_id = @ll_attachment_id,
					@ps_user_id = @ls_user_id,
					@ps_created_by = @ls_created_by,
					@ps_context_object = NULL,
					@pl_object_key = NULL

		FETCH lc_deleted INTO @ls_cpr_id, @ll_attachment_id, @ls_user_id, @ls_created_by
		END
	
	CLOSE lc_deleted
	DEALLOCATE lc_deleted
		
END




GO

