
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_objective_treatments]
Print 'Drop Procedure [dbo].[sp_get_objective_treatments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_objective_treatments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_objective_treatments]
GO

-- Create Procedure [dbo].[sp_get_objective_treatments]
Print 'Create Procedure [dbo].[sp_get_objective_treatments]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_objective_treatments    Script Date: 8/17/98 4:16:42 PM ******/
CREATE PROCEDURE sp_get_objective_treatments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_treatment_type varchar(24))
AS
SELECT	p_treatment_item.treatment_id,
	p_treatment_item.begin_date,
	c_user.user_id,
	c_user.user_short_name
FROM p_treatment_item (NOLOCK)
JOIN c_user (NOLOCK) ON p_treatment_item.ordered_by = c_user.user_id
WHERE p_treatment_item.cpr_id = @ps_cpr_id
AND p_treatment_item.open_encounter_id = @pl_encounter_id
AND p_treatment_item.treatment_type = @ps_treatment_type
ORDER BY p_treatment_item.treatment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_objective_treatments]
	TO [cprsystem]
GO

