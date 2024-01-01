
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_treatment_followup_workplan_items]
Print 'Drop Procedure [dbo].[sp_get_treatment_followup_workplan_items]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_followup_workplan_items]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_followup_workplan_items]
GO

-- Create Procedure [dbo].[sp_get_treatment_followup_workplan_items]
Print 'Create Procedure [dbo].[sp_get_treatment_followup_workplan_items]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_treatment_followup_workplan_items (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_workplan_type varchar(12))
AS

DECLARE @ll_patient_workplan_id int

SELECT @ll_patient_workplan_id = min(patient_workplan_id)
FROM p_Patient_Wp
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND workplan_type = @ps_workplan_type
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('No such followup workplan (%d)',16,-1, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END
SELECT p_Patient_Wp_Item.patient_workplan_item_id,
	p_Patient_Wp_Item.description,
	c_Treatment_Type.button
FROM p_Patient_Wp_Item
JOIN c_Treatment_Type ON p_Patient_Wp_Item.Ordered_Treatment_Type = c_Treatment_Type.treatment_type
WHERE p_Patient_Wp_Item.cpr_id = @ps_cpr_id
AND p_Patient_Wp_Item.patient_workplan_id = @ll_patient_workplan_id
AND p_patient_Wp_Item.item_type = 'Treatment'


GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_followup_workplan_items]
	TO [cprsystem]
GO

