--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
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


-- Set the owner back to the ordered_for if the service is reverted

IF @Resend_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Ordered'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Resend'
	AND		p_Patient_WP_Item.item_type = 'Document'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Reset_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Ordered'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Reset'
	AND		p_Patient_WP_Item.item_type = 'Document'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Revert_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = p_Patient_WP_Item.ordered_for
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Revert To Original Owner'
END

-- Set the owner back to the ordered_for if the service is reverted

IF @Transfer_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = inserted.user_id,
		status = CASE status WHEN 'Started' THEN 'Dispatched' ELSE status END
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Transfer'
END

-- Increment the retries if there is an error

IF @ERROR_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	retries = COALESCE(retries, 0) + 1
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'ERROR'
END

-- Update the parent workplan item escalation date

IF @Skipped_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	status = 'Skipped'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'SKIPPED'
END

-- Update the parent workplan item escalation date

IF @DOLATER_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	in_office_flag = 'N'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'DOLATER'
END

-- Update the parent workplan item escalation date

IF @ESCALATE_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	escalation_date = inserted.progress_date_time
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'ESCALATE'
END

-- Update the parent workplan item expiration date

IF @Expire_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	expiration_date = inserted.progress_date_time
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'EXPIRE'
END

-- Update the parent workplan item status

IF @Expired_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = inserted.progress_type
		,end_date =  inserted.progress_date_time
		,completed_by = inserted.user_id
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'EXPIRED'
END

-- Update the parent workplan item dispatched records


IF @DISPATCHED_flag > 0 OR @CONSOLIDATED_flag > 0
BEGIN
	UPDATE	wi
	SET	status = i.progress_type,
		dispatch_date =  i.progress_date_time,
		owned_by = dbo.fn_workplan_item_owned_by_2
			(	 wi.ordered_for
				,wi.patient_workplan_id
				,wi.cpr_id
				,wi.encounter_id
				,wi.ordered_by
				,wi.dispatch_method
			)
	FROM 	p_Patient_WP_Item wi
	INNER JOIN inserted i
	ON i.patient_workplan_id = wi.patient_workplan_id
	AND i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE i.progress_type IN ('DISPATCHED', 'CONSOLIDATED')
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

-- Update the status for Document status changes
IF @Sent_flag > 0 
BEGIN
	UPDATE 	wi
	SET	 status = i.progress_type,
		dispatch_date = COALESCE(wi.dispatch_date, i.progress_date_time)
	FROM 	p_Patient_WP_Item wi
		INNER JOIN inserted i
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
		INNER JOIN inserted i
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
		INNER JOIN inserted i
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
		INNER JOIN inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Document Created'
	AND		wi.item_type = 'Document'

	-- Keep this for backwards compatibility
	UPDATE 	wi
	SET	 begin_date = i.progress_date_time,
		status = wi.status
	FROM 	p_Patient_WP_Item wi
		INNER JOIN inserted i
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
		INNER JOIN inserted i
		ON i.patient_workplan_item_id = wi.patient_workplan_item_id
	WHERE 	i.progress_type = 'Creating'
	AND		wi.item_type = 'Document'
END

-- Update the parent workplan item started records

IF @STARTED_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = inserted.progress_type
		,begin_date =  COALESCE(p_Patient_WP_Item.begin_date, inserted.progress_date_time)
		,owned_by = CASE WHEN end_date IS NULL THEN inserted.user_id ELSE p_Patient_WP_Item.owned_by END
		,auto_perform_flag = 'N'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'STARTED'
END

-- Update the parent workplan item completed records

IF @COMPLETED_flag > 0 
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = inserted.progress_type
		,end_date =  inserted.progress_date_time
		,completed_by = inserted.user_id
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type IN ('COMPLETED')
	AND		p_Patient_WP_Item.status <> 'Cancelled'
END

-- Update the parent workplan item cancelled records

IF @CANCELLED_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = inserted.progress_type
		,end_date =  inserted.progress_date_time
		,completed_by = inserted.user_id
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type IN ('CANCELLED')
END

IF @Uncancel_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	 status = 'Completed'
		,end_date =  inserted.progress_date_time
		,completed_by = inserted.user_id
	FROM 	inserted
	WHERE 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type IN ('Uncancel')
	AND 	p_Patient_WP_Item.status IN ('CANCELLED')
END

-- Update the parent workplan item runtime_configured_flag

IF @Runtime_Configured_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	runtime_configured_flag = 'Y'
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Runtime_Configured'
END


-- Update the owner_id

IF @Owner_flag > 0
BEGIN
	UPDATE 	p_Patient_WP_Item
	SET	owned_by = inserted.user_id
	FROM 	inserted
	WHERE 	inserted.patient_workplan_id = p_Patient_WP_Item.patient_workplan_id
	AND 	inserted.patient_workplan_item_id = p_Patient_WP_Item.patient_workplan_item_id
	AND 	inserted.progress_type = 'Change Owner'
END


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

