
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_workplan_item_owned_by_2]
Print 'Drop Function [dbo].[fn_workplan_item_owned_by_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_workplan_item_owned_by_2]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_workplan_item_owned_by_2]
GO

-- Create Function [dbo].[fn_workplan_item_owned_by_2]
Print 'Create Function [dbo].[fn_workplan_item_owned_by_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_workplan_item_owned_by_2 (
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int,
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_dispatch_method varchar(24))

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_owned_by varchar(24),
		@ls_attending_doctor varchar(24),
		@ls_user_status varchar(8),
		@ll_relation_sequence int,
		@ls_document_sender_user_id varchar(24)

SET @ls_owned_by = NULL


IF LEFT(@ps_ordered_for, 1) = '!'
	BEGIN
	SELECT @ls_user_status = 'ROLE'
	FROM c_Role
	WHERE role_id = @ps_ordered_for
	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ps_ordered_for = NULL
		SET @ls_user_status = 'UNKNOWN'
		END
	END
ELSE
	BEGIN
	SELECT @ls_user_status = user_status
	FROM c_User
	WHERE [user_id] = @ps_ordered_for
	IF @@ROWCOUNT <> 1
		BEGIN
		SET @ps_ordered_for = NULL
		SET @ls_user_status = 'UNKNOWN'
		END
	END

IF (@ps_ordered_for IS NULL) OR (@ps_ordered_for = '#WORKPLAN_OWNER')
	BEGIN
	SELECT @ls_owned_by = owned_by
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id
	END
ELSE IF LEFT(@ps_ordered_for, 1) = '#'
	BEGIN
	SET @ls_owned_by = dbo.fn_special_user_resolution(@ps_ordered_for ,
													@ps_cpr_id ,
													@pl_encounter_id )

	IF @ls_owned_by IS NULL
		BEGIN
		IF @ps_ordered_for = '#DistList'
			SET @ls_owned_by = @ps_ordered_for
		END
	END


-- If we still don't have an owner, then make the ordered_for the owner if it's a valid workplan item owner
IF @ls_owned_by IS NULL and @ls_user_status IN ('OK', 'SYSTEM', 'ROLE')
	SET @ls_owned_by = @ps_ordered_for

-- If we still don't have an owner and the dispatch_method isn't local, then set the owner to the sending system user
IF @ls_owned_by IS NULL AND @ps_dispatch_method IS NOT NULL AND @ps_dispatch_method NOT IN ('Inbox', 'Tasks')
	BEGIN
	SET @ls_owned_by = dbo.fn_get_global_preference('SERVERCONFIG', 'Document Sender user_id')
	IF @ls_owned_by IS NULL
		SET @ls_owned_by = '#JMJ'
	END

-- And if all else fails, make the !Exception role the owner
IF @ls_owned_by IS NULL
	RETURN '!Exception'

RETURN @ls_owned_by 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_workplan_item_owned_by_2]
	TO [cprsystem]
GO

