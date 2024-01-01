
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_finished_services]
Print 'Drop Procedure [dbo].[sp_finished_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_finished_services]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_finished_services]
GO

-- Create Procedure [dbo].[sp_finished_services]
Print 'Create Procedure [dbo].[sp_finished_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_finished_services (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pi_count smallint OUTPUT )
AS
SELECT @pi_count = count(i.patient_workplan_item_id)
FROM p_Patient_Encounter e
JOIN p_Patient_WP_Item i ON i.patient_workplan_id = e.patient_workplan_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
AND i.cpr_id = @ps_cpr_id
AND i.status = 'COMPLETED'

GO
GRANT EXECUTE
	ON [dbo].[sp_finished_services]
	TO [cprsystem]
GO

