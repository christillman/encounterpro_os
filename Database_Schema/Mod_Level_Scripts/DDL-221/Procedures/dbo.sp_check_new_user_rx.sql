
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_check_new_user_rx]
Print 'Drop Procedure [dbo].[sp_check_new_user_rx]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_check_new_user_rx]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_check_new_user_rx]
GO

-- Create Procedure [dbo].[sp_check_new_user_rx]
Print 'Create Procedure [dbo].[sp_check_new_user_rx]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_check_new_user_rx    Script Date: 10/4/98 6:28:02 PM ******/
CREATE PROCEDURE sp_check_new_user_rx (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_user_id varchar(24),
	@pi_new_user_rx_count smallint OUTPUT )
AS
SELECT @pi_new_user_rx_count = count(*)
FROM 	p_Treatment_Item  WITH (NOLOCK)
	JOIN c_Drug_Package WITH (NOLOCK) ON p_Treatment_Item.drug_id = c_Drug_Package.drug_id
		AND p_Treatment_Item.package_id = c_Drug_Package.package_id
Where p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.open_encounter_id = @pl_encounter_id
AND p_Treatment_Item.ordered_by = @ps_user_id
AND p_Treatment_Item.treatment_type = 'MEDICATION'
AND p_Treatment_Item.treatment_status IS NULL
AND c_Drug_Package.prescription_flag = 'Y'
AND p_Treatment_Item.signature_attachment_sequence IS NULL

GO
GRANT EXECUTE
	ON [dbo].[sp_check_new_user_rx]
	TO [cprsystem]
GO

