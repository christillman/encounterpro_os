
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_document_set_recipient]
Print 'Drop Procedure [dbo].[jmj_document_set_recipient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_document_set_recipient]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_document_set_recipient]
GO

-- Create Procedure [dbo].[jmj_document_set_recipient]
Print 'Create Procedure [dbo].[jmj_document_set_recipient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_document_set_recipient (
	@pl_patient_workplan_item_id int,
	@ps_ordered_for varchar(24),
	@ps_dispatch_method varchar(24),
	@ps_address_attribute varchar(64),
	@ps_address_value varchar(255),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ls_last_ordered_for varchar(24),
		@ls_last_dispatch_method varchar(24),
		@ll_last_attachment_id int,
		@ls_cpr_id varchar(12),
		@ls_ordered_by varchar(12)

SELECT @ls_last_ordered_for = ordered_for,
		@ls_last_dispatch_method = dispatch_method,
		@ll_last_attachment_id = attachment_id,
		@ls_cpr_id = cpr_id,
		@ls_ordered_by = ordered_by
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @@ERROR <> 0
	RETURN -1

IF @ls_ordered_by IS NULL
	BEGIN
	RAISERROR ('Document record not found (%d)',16,-1, @pl_patient_workplan_item_id)
	RETURN -1
	END

IF ISNULL(@ls_last_ordered_for, '!NULL') <> ISNULL(@ps_ordered_for, '!NULL')
	OR ISNULL(@ls_last_dispatch_method, '!NULL') <> ISNULL(@ps_dispatch_method, '!NULL')
	BEGIN
	UPDATE p_Patient_WP_Item
	SET ordered_for = @ps_ordered_for,
		dispatch_method = @ps_dispatch_method,
		attachment_id = NULL -- Null out any existing attachment because it will need to be recreated
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

	IF @@ERROR <> 0
		RETURN -1

	IF @ll_last_attachment_id > 0
		BEGIN
		-- Delete the existing attachment because it is no longer valid
		EXECUTE [dbo].[sp_set_attachment_progress] 
		   @ps_cpr_id = @ls_cpr_id
		  ,@pl_attachment_id = @ll_last_attachment_id
		  ,@pl_patient_workplan_item_id = @pl_patient_workplan_item_id
		  ,@ps_user_id = @ps_user_id
		  ,@ps_progress_type = 'DELETED'
		  ,@ps_progress = 'Attachment Deleted'
		  ,@ps_created_by = @ps_created_by

		-- Null out the attachment_id for this document
		EXEC sp_add_workplan_item_attribute
			@ps_cpr_id = @ls_cpr_id,
			@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
			@ps_attribute = 'attachment_id',
			@ps_value = NULL,
			@ps_user_id = @ps_user_id,
			@ps_created_by = @ps_created_by
		END

	END

-- If an address attribute was passed in then set it
IF LEN(@ps_address_attribute) > 0 AND LEN(@ps_address_value) > 0
	BEGIN
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ls_cpr_id,
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
		@ps_attribute = @ps_address_attribute,
		@ps_value = @ps_address_value,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by
	END

RETURN 1
GO
GRANT EXECUTE
	ON [dbo].[jmj_document_set_recipient]
	TO [cprsystem]
GO

