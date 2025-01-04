
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_Office_all]
Print 'Drop Trigger [dbo].[tr_c_Office_all]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Office_all]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_Office_all]
GO

-- Create Trigger [dbo].[tr_c_Office_all]
Print 'Create Trigger [dbo].[tr_c_Office_all]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER tr_c_Office_all ON dbo.c_Office
FOR INSERT, UPDATE
AS

DECLARE @ll_pms_owner_id int,
		@ls_office_id varchar(4), 
		@ls_billing_id varchar(24),
		@ls_user_id varchar(24),
		@ls_created_by varchar(24)


IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(billing_id)
	BEGIN
	SET @ls_created_by = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

	SELECT 	@ll_pms_owner_id = send_via_addressee
	FROM c_Document_Route
	WHERE document_route = dbo.fn_get_global_preference('Preferences', 'default_billing_system')

	IF @ll_pms_owner_id IS NOT NULL
		BEGIN
		DECLARE lc_mappings CURSOR LOCAL FAST_FORWARD FOR
			SELECT i.office_id, i.billing_id, u.user_id
			FROM inserted i
				INNER JOIN deleted d
				ON i.office_id = d.office_id
				INNER JOIN c_User u
				ON i.office_id = u.office_id
			WHERE i.billing_id IS NOT NULL
			AND u.actor_class = 'Office'
			AND u.status = 'OK'
			AND ISNULL(d.billing_id, '!NULL') <> ISNULL(i.billing_id, '!NULL')

		OPEN lc_mappings

		FETCH lc_mappings INTO @ls_office_id, @ls_billing_id, @ls_user_id
		WHILE @@FETCH_STATUS = 0
			BEGIN
			
			EXECUTE jmj_Set_User_IDValue	@ps_user_id = @ls_user_id,
											@pl_owner_id = @ll_pms_owner_id,
											@ps_IDDomain = 'FacilityID',
											@ps_IDValue = @ls_billing_id,
											@ps_created_by = @ls_created_by

			FETCH lc_mappings INTO @ls_office_id, @ls_billing_id, @ls_user_id
			END

		END

	END

GO

