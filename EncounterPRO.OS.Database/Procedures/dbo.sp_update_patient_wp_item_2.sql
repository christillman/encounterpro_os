SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_update_patient_wp_item_2]
Print 'Drop Procedure [dbo].[sp_update_patient_wp_item_2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_patient_wp_item_2]') AND [type]='P'))
DROP PROCEDURE [dbo].sp_update_patient_wp_item_2
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
