
-- DROP TRIGGER [dbo].[tr_patient_wp_item_progress_insert]

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_patient_wp_item_progress_insert]
Print 'Drop Trigger [dbo].[tr_patient_wp_item_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_patient_wp_item_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_patient_wp_item_progress_insert]
GO

-- DROP PROCEDURE [dbo].sp_update_patient_wp_item_1

-- Drop Procedure [dbo].[sp_update_patient_wp_item_1]
Print 'Drop Procedure [dbo].[sp_update_patient_wp_item_1]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_patient_wp_item_1]') AND [type]='P'))
DROP PROCEDURE [dbo].sp_update_patient_wp_item_1
GO

-- DROP PROCEDURE [dbo].sp_update_patient_wp_item_2

-- Drop Procedure [dbo].[sp_update_patient_wp_item_2]
Print 'Drop Procedure [dbo].[sp_update_patient_wp_item_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_patient_wp_item_2]') AND [type]='P'))
DROP PROCEDURE [dbo].sp_update_patient_wp_item_2
GO

DROP TYPE IF EXISTS [tab_p_Patient_WP_Item_Progress]

SET ANSI_NULLS ON

SET QUOTED_IDENTIFIER ON

CREATE TYPE [tab_p_Patient_WP_Item_Progress]
	AS TABLE (
	[patient_workplan_id] [int] NOT NULL,
	[patient_workplan_item_id] [int] NOT NULL,
	[patient_workplan_item_prog_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[user_id] [varchar](255) NOT NULL,
	[progress_date_time] [datetime] NOT NULL,
	[progress_type] [varchar](24) NOT NULL,
	[created] [datetime] NULL,
	[created_by] [varchar](255) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[computer_id] [int] NULL,
	PRIMARY KEY NONCLUSTERED 
	(
		[patient_workplan_item_id] ASC,
		[patient_workplan_item_prog_id] ASC
	)
) 


-- Create Procedure [dbo].[sp_update_patient_wp_item_1]
Print 'Create Procedure [dbo].[sp_update_patient_wp_item_1]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_update_patient_wp_item_1
(
	@inserted tab_p_Patient_WP_Item_Progress READONLY,
	 @DOLATER_flag int
	,@ERROR_flag int
	,@ESCALATE_flag int
	,@EXPIRE_flag int
	,@EXPIRED_flag int
	,@Revert_flag int
	,@Resend_flag int
	,@Reset_flag int
	,@skipped_flag int
	,@Transfer_flag int
)
AS

-- Set the owner back to the ordered_for if the service is reverted
IF @Resend_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Ordered'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Resend'
	AND		p_Patient_WP_Item.item_type = 'Document'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Reset_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Ordered'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Reset'
	AND		p_Patient_WP_Item.item_type = 'Document'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Revert_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = p_Patient_WP_Item.ordered_for
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Revert To Original Owner'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Transfer_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = i.user_id,
		status = CASE status WHEN 'Started' THEN 'Dispatched' ELSE status END
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Transfer'
END

-- Increment the retries if there is an error

IF @ERROR_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	retries = COALESCE(retries, 0) + 1
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'ERROR'
END

-- Update the parent workplan item escalation date

IF @Skipped_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Skipped'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'SKIPPED'
END

-- Update the parent workplan item escalation date

IF @DOLATER_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	in_office_flag = 'N'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'DOLATER'
END

-- Update the parent workplan item escalation date

IF @ESCALATE_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	escalation_date = i.progress_date_time
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'ESCALATE'
END

-- Update the parent workplan item expiration date

IF @Expire_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	expiration_date = i.progress_date_time
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'EXPIRE'
END

-- Update the parent workplan item status

IF @Expired_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = i.progress_type
		,end_date =  i.progress_date_time
		,completed_by = i.user_id
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'EXPIRED'
END

GO
GRANT EXECUTE
	ON [dbo].[sp_update_patient_wp_item_1]
	TO [cprsystem]
GO

-- Create Procedure [dbo].[sp_update_patient_wp_item_2]
Print 'Create Procedure [dbo].[sp_update_patient_wp_item_2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_update_patient_wp_item_2
(
	@inserted tab_p_Patient_WP_Item_Progress READONLY
	,@CANCELLED_flag int
	,@COMPLETED_flag int
	,@Created_flag int
	,@Creating_flag int
	,@ERROR_flag int
	,@Owner_flag int
	,@Ready_flag int
	,@Runtime_Configured_flag int
	,@Sent_flag int
	,@skipped_flag int
	,@STARTED_flag int
	,@Uncancel_flag int
)
AS


-- Update the status for Document status changes
IF @Sent_flag > 0 
BEGIN
	UPDATE 	wi
	SET	 status = i.progress_type,
		dispatch_date = COALESCE(wi.dispatch_date, i.progress_date_time)
	FROM 	p_Patient_WP_Item wi
	INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Sent'
	AND		wi.item_type = 'Document'
END

-- Update the status for Document status changes
IF @ERROR_flag > 0
BEGIN
	UPDATE 	wi
	SET	 status = i.progress_type
	FROM 	p_Patient_WP_Item wi
		INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Error'
	AND		wi.item_type IN ('Document', 'Incoming')

	-- If the error document is a "Billing Data" document, then set the encounter billing_status to 'E'
	UPDATE e
	SET billing_posted = 'E'
	FROM p_Patient_Encounter e
	INNER JOIN p_Patient_WP_Item wi
		ON e.cpr_id = wi.cpr_id
		AND e.encounter_id = wi.encounter_id
	INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	INNER JOIN p_Patient_WP_Item_Attribute a
		ON i.patient_workplan_item_id = a.patient_workplan_item_id
	WHERE 	i.progress_type = 'Error'
	AND wi.item_type = 'Document'
	AND a.attribute = 'Purpose'
	AND a.value = 'Billing Data'
END

-- Update the status for Document status changes
IF @Created_flag > 0
BEGIN
	UPDATE 	wi
	SET	 begin_date = i.progress_date_time,
		status = 'Ordered'
	FROM 	p_Patient_WP_Item wi
	INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Document Created'
	AND		wi.item_type = 'Document'

	-- Keep this for backwards compatibility
	UPDATE 	wi
	SET	 begin_date = i.progress_date_time,
		status = wi.status
	FROM 	p_Patient_WP_Item wi
	INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Created'
	AND		wi.item_type = 'Document'
END

-- Update the status for Document status changes
IF @Creating_flag > 0
BEGIN
	UPDATE 	wi
	SET	 status = 'Creating'
	FROM 	p_Patient_WP_Item wi
	INNER JOIN @inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Creating'
	AND		wi.item_type = 'Document'
END

-- Update the parent workplan item started records

IF @STARTED_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = i.progress_type
		,begin_date =  COALESCE(p_Patient_WP_Item.begin_date, i.progress_date_time)
		,owned_by = CASE WHEN end_date IS NULL THEN i.user_id ELSE p_Patient_WP_Item.owned_by END
		,auto_perform_flag = 'N'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'STARTED'
END

-- Update the parent workplan item completed records

IF @COMPLETED_flag > 0 
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = i.progress_type
		,end_date =  i.progress_date_time
		,completed_by = i.user_id
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type IN ('COMPLETED')
	AND		p_Patient_WP_Item.status <> 'Cancelled'
END

-- Update the parent workplan item cancelled records

IF @CANCELLED_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = i.progress_type
		,end_date =  i.progress_date_time
		,completed_by = i.user_id
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type IN ('CANCELLED')
END

IF @Uncancel_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = 'Completed'
		,end_date =  i.progress_date_time
		,completed_by = i.user_id
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type IN ('Uncancel')
	AND 	p_Patient_WP_Item.status IN ('CANCELLED')
END

-- Update the parent workplan item runtime_configured_flag

IF @Runtime_Configured_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	runtime_configured_flag = 'Y'
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Runtime_Configured'
END


-- Update the owner_id

IF @Owner_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = i.user_id
	FROM 	@inserted i
	JOIN	p_Patient_WP_Item 
	 	ON		i.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
		AND 	i.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	WHERE 	i.progress_type = 'Change Owner'
END

GO
GRANT EXECUTE
	ON [dbo].[sp_update_patient_wp_item_2]
	TO [cprsystem]
GO


-- Create Trigger [dbo].[tr_patient_wp_item_progress_insert]
Print 'Create Trigger [dbo].[tr_patient_wp_item_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[tr_patient_wp_item_progress_insert]
    ON [dbo].[p_Patient_WP_Item_Progress]
    AFTER INSERT
    AS 
BEGIN
IF @@ROWCOUNT = 0
	RETURN

DECLARE @inserted tab_p_Patient_WP_Item_Progress
INSERT INTO @inserted
SELECT * FROM inserted

DECLARE
	 @ATTACHMENT_FOLDER_flag int
	,@ATTACHMENT_TAG_flag int
	,@CANCELLED_flag int
	,@CHANGED_flag int
	,@Closed_flag int
	,@COLLECTED_flag int
	,@COMPLETED_flag int
	,@CONSOLIDATED_flag int
	,@Created_flag int
	,@Creating_flag int
	,@DECEASED_flag int
	,@DELETED_flag int
	,@DISPATCHED_flag int
	,@DOLATER_flag int
	,@ERROR_flag int
	,@ESCALATE_flag int
	,@EXPIRE_flag int
	,@EXPIRED_flag int
	,@MODIFIED_flag int
	,@Modify_flag int
	,@MOVED_flag int
	,@NEEDSAMPLE_flag int
	,@Owner_flag int
	,@Property_flag int
	,@Ready_flag int
	,@REDIAGNOSED_flag int
	,@ReOpen_flag int
	,@Revert_flag int
	,@Resend_flag int
	,@Reset_flag int
	,@Runtime_Configured_flag int
	,@Sent_flag int
	,@Signed_flag int
	,@skipped_flag int
	,@STARTED_flag int
	,@Success_flag int
	,@TEXT_flag int
	,@Transfer_flag int
	,@Uncancel_flag int

DECLARE  @ls_cpr_id varchar(12)
		,@ll_patient_workplan_id int
		,@ll_patient_workplan_item_id int
		,@ll_encounter_id int
		,@ls_created_by varchar(24)
		,@ls_started_by varchar(24)
		,@ls_wp_owned_by varchar(24)
		,@ll_isvalid int
		,@ls_attending_doctor varchar(24)


/*
	This query sets a numeric flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@CANCELLED_flag = SUM( CHARINDEX( 'CANCELLED', inserted.progress_type ) )
	,@CHANGED_flag = SUM( CHARINDEX( 'CHANGED', inserted.progress_type ) )
	,@Closed_flag = SUM( CHARINDEX( 'Closed', inserted.progress_type ) )
	,@COLLECTED_flag = SUM( CHARINDEX( 'COLLECTED', inserted.progress_type ) )
	,@COMPLETED_flag = SUM( CHARINDEX( 'COMPLETED', inserted.progress_type ) )
	,@CONSOLIDATED_flag = SUM( CHARINDEX( 'CONSOLIDATED', inserted.progress_type ) )
	,@Created_flag = SUM( CHARINDEX( 'Created', inserted.progress_type ) )
	,@Creating_flag = SUM( CHARINDEX( 'Creating', inserted.progress_type ) )
	,@DECEASED_flag = SUM( CHARINDEX( 'DECEASED', inserted.progress_type ) )
	,@DELETED_flag = SUM( CHARINDEX( 'DELETED', inserted.progress_type ) )
	,@DISPATCHED_flag = SUM( CHARINDEX( 'DISPATCHED', inserted.progress_type ) )
	,@DOLATER_flag = SUM( CHARINDEX( 'DOLATER', inserted.progress_type ) )
	,@ERROR_flag = SUM( CHARINDEX( 'ERROR', inserted.progress_type ) )
	,@ESCALATE_flag = SUM( CHARINDEX( 'ESCALATE', inserted.progress_type ) )
	,@EXPIRE_flag = SUM( CHARINDEX( 'EXPIRE', inserted.progress_type ) )
	,@EXPIRED_flag = SUM( CHARINDEX( 'EXPIRED', inserted.progress_type ) )
	,@MODIFIED_flag = SUM( CHARINDEX( 'MODIFIED', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
	,@MOVED_flag = SUM( CHARINDEX( 'MOVED', inserted.progress_type ) )
	,@NEEDSAMPLE_flag = SUM( CHARINDEX( 'NEEDSAMPLE', inserted.progress_type ) )
	,@Owner_flag = SUM( CHARINDEX( 'Change Owner', inserted.progress_type ) )
	,@Property_flag = SUM( CHARINDEX( 'Property', inserted.progress_type ) )
	,@Ready_flag = SUM( CHARINDEX( 'Ready', inserted.progress_type ) )
	,@REDIAGNOSED_flag = SUM( CHARINDEX( 'REDIAGNOSED', inserted.progress_type ) )
	,@ReOpen_flag = SUM( CHARINDEX( 'ReOpen', inserted.progress_type ) )
	,@Revert_flag = SUM( CHARINDEX( 'Revert To Original Owner', inserted.progress_type ) )
	,@Resend_flag = SUM( CHARINDEX( 'Resend', inserted.progress_type ) )
	,@Reset_flag = SUM( CHARINDEX( 'Reset', inserted.progress_type ) )
	,@Runtime_Configured_flag = SUM( CHARINDEX( 'Runtime_Configured', inserted.progress_type ) )
	,@Sent_flag = SUM( CHARINDEX( 'Sent', inserted.progress_type ) )
	,@Signed_flag = SUM( CHARINDEX( 'Signed', inserted.progress_type ) )
	,@skipped_flag = SUM( CHARINDEX( 'Skipped', inserted.progress_type ) )
	,@STARTED_flag = SUM( CHARINDEX( 'STARTED', inserted.progress_type ) )
	,@Success_flag = SUM( CHARINDEX( 'Success', inserted.progress_type ) )
	,@TEXT_flag = SUM( CHARINDEX( 'TEXT', inserted.progress_type ) )
	,@Transfer_flag = SUM( CHARINDEX( 'Transfer', inserted.progress_type ) )
	,@Uncancel_flag = SUM( CHARINDEX( 'Uncancel', inserted.progress_type ) )
FROM inserted

EXEC sp_update_patient_wp_item_1 @inserted,
	@DOLATER_flag
	,@ERROR_flag
	,@ESCALATE_flag
	,@EXPIRE_flag
	,@EXPIRED_flag
	,@Revert_flag
	,@Resend_flag
	,@Reset_flag
	,@skipped_flag
	,@Transfer_flag

-- Update the parent workplan item dispatched records
IF @DISPATCHED_flag > 0 OR @CONSOLIDATED_flag > 0
BEGIN
	-- dbo.fn_workplan_item_owned_by_2 was being nasty in SQL Server 2019, running it out of 
	-- memory when combined into the update. Needed to use a cursor and variables.
	DECLARE @progress_type varchar(24),
		@progress_date_time datetime,
		@patient_workplan_item_id int,
		@ordered_for varchar(24),
		@patient_workplan_id int,
		@cpr_id varchar(12),
		@encounter_id int,
		@ordered_by varchar(24),
		@dispatch_method varchar(24),
		@owned_by varchar(24)

	DECLARE lc_owner CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING
	FOR
	SELECT i.progress_type,
		i.progress_date_time
		,wi.patient_workplan_item_id
		,wi.ordered_for
					,wi.patient_workplan_id
					,wi.cpr_id
					,wi.encounter_id
					,wi.ordered_by
					,wi.dispatch_method
	FROM 	p_Patient_WP_Item wi
	INNER JOIN @inserted i
		ON i.patient_workplan_id = wi.patient_workplan_id
		AND i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE i.progress_type IN ('DISPATCHED', 'CONSOLIDATED')

	OPEN lc_owner
	FETCH lc_owner INTO
		@progress_type,
		@progress_date_time,
		@patient_workplan_item_id,
		@ordered_for,
		@patient_workplan_id,
		@cpr_id,
		@encounter_id,
		@ordered_by,
		@dispatch_method
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @owned_by = dbo.fn_workplan_item_owned_by_2
					(	@ordered_for
						,@patient_workplan_id
						,@cpr_id
						,@encounter_id
						,@ordered_by
						,@dispatch_method
					) 

		UPDATE	p_Patient_WP_Item
		SET	status = @progress_type,
			dispatch_date =  @progress_date_time,
			owned_by = @owned_by
		WHERE patient_workplan_id = @patient_workplan_id
		AND patient_workplan_item_id = @patient_workplan_item_id

		FETCH lc_owner INTO
			@progress_type,
			@progress_date_time,
			@patient_workplan_item_id,
			@ordered_for,
			@patient_workplan_id,
			@cpr_id,
			@encounter_id,
			@ordered_by,
			@dispatch_method
	END

	CLOSE lc_owner
	DEALLOCATE lc_owner

END

-- Set the ready status
IF @Ready_flag > 0
BEGIN
	UPDATE 	wi
	SET	 status = i.progress_type,
		dispatch_date = COALESCE(wi.dispatch_date, i.progress_date_time)
	FROM 	p_Patient_WP_Item wi
	INNER JOIN inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Ready'
	AND		wi.item_type = 'Document'
END

-- Set the success status
IF @Success_flag > 0
BEGIN
	UPDATE 	wi
	SET	 status = 'Completed',
		dispatch_date = COALESCE(wi.dispatch_date, i.progress_date_time)
	FROM 	p_Patient_WP_Item wi
		INNER JOIN inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Success'
	AND		wi.item_type = 'Document'

	-- If the error document is a "Billing Data" document, then set the encounter billing_status to 'A' (Accepted)
	UPDATE e
	SET billing_posted = 'A'
	FROM p_Patient_Encounter e
	INNER JOIN p_Patient_WP_Item wi
		ON e.cpr_id = wi.cpr_id
		AND e.encounter_id = wi.encounter_id
	INNER JOIN inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	INNER JOIN p_Patient_WP_Item_Attribute a
		ON i.patient_workplan_item_id = a.patient_workplan_item_id
	WHERE 	i.progress_type = 'Success'
	AND wi.item_type = 'Document'
	AND a.attribute = 'Purpose'
	AND a.value = 'Billing Data'
END

EXEC sp_update_patient_wp_item_2 @inserted
	,@CANCELLED_flag
	,@COMPLETED_flag
	,@Created_flag
	,@Creating_flag
	,@ERROR_flag
	,@Owner_flag
	,@Ready_flag
	,@Runtime_Configured_flag
	,@Sent_flag
	,@skipped_flag
	,@STARTED_flag
	,@Uncancel_flag


-- Set the WP status from 'Pending' to 'Current' for dispatched/started wp items 

IF @DISPATCHED_flag > 0 OR @STARTED_flag > 0
BEGIN

	DECLARE lc_set_wp_status CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING
	FOR
		SELECT	 i.cpr_id
			,i.encounter_id
			,i.patient_workplan_id
			,i.created_by
			,i.user_id
			,COALESCE( ur.user_id, wp.owned_by )
		FROM	inserted i
		INNER JOIN p_Patient_WP wp
		ON	i.patient_workplan_id = wp.patient_workplan_id
		LEFT OUTER JOIN c_user_role ur
		ON	wp.owned_by = ur.role_id
		AND	i.user_id = ur.user_id
		WHERE 	i.progress_type IN ('DISPATCHED','STARTED')
		AND 	wp.status = 'Pending'
	
	OPEN lc_set_wp_status
	
	FETCH lc_set_wp_status INTO
		 @ls_cpr_id
		,@ll_encounter_id
		,@ll_patient_workplan_id
		,@ls_created_by
		,@ls_started_by
		,@ls_wp_owned_by
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE  sp_set_workplan_status
			 @ps_cpr_id = @ls_cpr_id
			,@pl_encounter_id = @ll_encounter_id
			,@pl_patient_workplan_id = @ll_patient_workplan_id
			,@ps_progress_type = 'Current'
			,@ps_owned_by = @ls_wp_owned_by
			,@ps_created_by = @ls_created_by
	
		FETCH lc_set_wp_status INTO
			 @ls_cpr_id
			,@ll_encounter_id
			,@ll_patient_workplan_id
			,@ls_created_by
			,@ls_started_by
			,@ls_wp_owned_by
	END
	
	CLOSE lc_set_wp_status
	
	DEALLOCATE lc_set_wp_status
END	

END
GO

