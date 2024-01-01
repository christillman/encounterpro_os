
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_procedure_count]
Print 'Drop Procedure [dbo].[sp_get_procedure_count]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_procedure_count]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_procedure_count]
GO

-- Create Procedure [dbo].[sp_get_procedure_count]
Print 'Create Procedure [dbo].[sp_get_procedure_count]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 8/17/98 4:16:44 PM ******/
CREATE PROCEDURE sp_get_procedure_count (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pi_procedure_count smallint OUTPUT )
AS
SELECT @pi_procedure_count = count(*)
FROM 	p_Encounter_Charge WITH (NOLOCK)
 	JOIN p_Treatment_Item WITH (NOLOCK) ON p_Treatment_Item.treatment_id = p_Encounter_Charge.treatment_id
WHERE p_Encounter_Charge.cpr_id = @ps_cpr_id
AND p_Encounter_Charge.encounter_id = @pl_encounter_id
AND p_Treatment_Item.cpr_id = @ps_cpr_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_procedure_count]
	TO [cprsystem]
GO

