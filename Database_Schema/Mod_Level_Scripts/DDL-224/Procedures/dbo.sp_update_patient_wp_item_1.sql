SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_update_patient_wp_item_1]
Print 'Drop Procedure [dbo].[sp_update_patient_wp_item_1]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_patient_wp_item_1]') AND [type]='P'))
DROP PROCEDURE IF EXISTS [dbo].sp_update_patient_wp_item_1
GO

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
