
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_planned_referrals]
Print 'Drop Procedure [dbo].[sp_get_planned_referrals]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_planned_referrals]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_planned_referrals]
GO

-- Create Procedure [dbo].[sp_get_planned_referrals]
Print 'Create Procedure [dbo].[sp_get_planned_referrals]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_planned_referrals (
	@ps_cpr_id varchar(12))
AS
SELECT p_Treatment_Item.treatment_id,
	p_Treatment_Item.begin_date,
	c_Specialty.description
FROM p_Treatment_Item
	JOIN c_Specialty ON p_Treatment_Item.specialty_id = c_Specialty.specialty_id
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.treatment_type = 'REFERRAL'
AND p_Treatment_Item.treatment_status NOT IN ('CLOSED', 'CANCELLED', 'MODIFIED')


GO
GRANT EXECUTE
	ON [dbo].[sp_get_planned_referrals]
	TO [cprsystem]
GO

