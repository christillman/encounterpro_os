
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_post_attachments]
Print 'Drop Procedure [dbo].[sp_get_post_attachments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_post_attachments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_post_attachments]
GO

-- Create Procedure [dbo].[sp_get_post_attachments]
Print 'Create Procedure [dbo].[sp_get_post_attachments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_post_attachments (
	@ps_cpr_id varchar(12),
	@ps_treatment_list_id varchar(24))
AS
SELECT	p_Treatment_Item.treatment_type,
	p_Treatment_Item.open_encounter_id,
	p_Treatment_Item.treatment_id, 	p_Patient_Encounter.encounter_date,
	p_Treatment_Item.treatment_description,
	c_Treatment_Type.attachment_folder
FROM p_Treatment_Item 
	JOIN p_Patient_Encounter ON p_Treatment_Item.open_encounter_id = p_Patient_Encounter.encounter_id
	JOIN c_Treatment_Type_list ON p_Treatment_Item.treatment_type = c_Treatment_Type_List.treatment_type
	JOIN c_Treatment_Type ON c_Treatment_Type.treatment_type = c_Treatment_Type_List.treatment_type
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND (p_Treatment_Item.treatment_status IS NULL
	OR p_Treatment_Item.treatment_status NOT IN ('CLOSED','MODIFIED','CANCELLED') 
	)
AND c_Treatment_Type_list.treatment_list_id = @ps_treatment_list_id


GO
GRANT EXECUTE
	ON [dbo].[sp_get_post_attachments]
	TO [cprsystem]
GO

