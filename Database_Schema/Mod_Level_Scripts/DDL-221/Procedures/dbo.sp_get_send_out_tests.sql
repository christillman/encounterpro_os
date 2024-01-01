
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_send_out_tests]
Print 'Drop Procedure [dbo].[sp_get_send_out_tests]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_send_out_tests]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_send_out_tests]
GO

-- Create Procedure [dbo].[sp_get_send_out_tests]
Print 'Create Procedure [dbo].[sp_get_send_out_tests]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_send_out_tests (
	@ps_cpr_id varchar(12) )
AS
SELECT	p_Treatment_Item.open_encounter_id,
	p_Treatment_Item.treatment_id, 	p_Patient_Encounter.encounter_date,
	p_Treatment_Item.treatment_description
FROM p_Treatment_Item WITH (NOLOCK)
	JOIN p_Patient_Encounter WITH (NOLOCK) ON p_Treatment_Item.open_encounter_id = p_Patient_Encounter.encounter_id
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND (p_Treatment_Item.treatment_status IS NULL
	OR p_Treatment_Item.treatment_status IN ('COLLECTED', 'NEEDSAMPLE') 
	)
and p_Treatment_Item.treatment_type = 'TEST'


GO
GRANT EXECUTE
	ON [dbo].[sp_get_send_out_tests]
	TO [cprsystem]
GO

