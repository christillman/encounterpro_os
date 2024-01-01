
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_hcpcs]
Print 'Drop Procedure [dbo].[sp_get_hcpcs]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_hcpcs]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_hcpcs]
GO

-- Create Procedure [dbo].[sp_get_hcpcs]
Print 'Create Procedure [dbo].[sp_get_hcpcs]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_hcpcs    Script Date: 7/25/2000 8:43:46 AM ******/
CREATE PROCEDURE sp_get_hcpcs (
	@ps_drug_id varchar(24) )
AS
SELECT	c_Drug_HCPCS.hcpcs_sequence,
	c_Drug_HCPCS.administer_amount,
	c_Drug_HCPCS.administer_unit,
	c_Drug_HCPCS.hcpcs_procedure_id,
	c_Procedure.description,
	c_Procedure.cpt_code, 	selected_flag = 0
FROM c_Drug_HCPCS
JOIN c_Procedure ON c_Drug_HCPCS.hcpcs_procedure_id = c_Procedure.procedure_id
WHERE c_Drug_HCPCS.drug_id = @ps_drug_id
AND c_Procedure.status = 'OK'

GO
GRANT EXECUTE
	ON [dbo].[sp_get_hcpcs]
	TO [cprsystem]
GO

