
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_medication_procs]
Print 'Drop Procedure [dbo].[sp_get_medication_procs]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_medication_procs]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_medication_procs]
GO

-- Create Procedure [dbo].[sp_get_medication_procs]
Print 'Create Procedure [dbo].[sp_get_medication_procs]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_medication_procs (
	@ps_drug_id varchar(24),
	@ps_dosage_form varchar(24) )
AS
SELECT DISTINCT c_Procedure.procedure_id,
		c_Procedure.description
FROM	c_Drug_Package
	JOIN c_Package ON c_Drug_Package.package_id = c_Package.package_id
	JOIN c_Package_Administration_Method 
		ON c_Package_Administration_Method.package_id = c_Package.package_id
	JOIN c_Administration_Method_Proc
		ON	c_Package_Administration_Method.administer_method = c_Administration_Method_Proc.administer_method
	JOIN c_Procedure 
		ON c_Administration_Method_Proc.procedure_id = c_Procedure.procedure_id
WHERE	c_Drug_Package.drug_id = @ps_drug_id
AND	c_Package.dosage_form = @ps_dosage_form

GO
GRANT EXECUTE
	ON [dbo].[sp_get_medication_procs]
	TO [cprsystem]
GO

