
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_drug_packages]
Print 'Drop Procedure [dbo].[sp_get_drug_packages]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_drug_packages]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_drug_packages]
GO

-- Create Procedure [dbo].[sp_get_drug_packages]
Print 'Create Procedure [dbo].[sp_get_drug_packages]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_drug_packages    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_packages (
	@ps_drug_id varchar(24) )
AS
SELECT c_Drug_Package.package_id,
c_Drug_Package.sort_order,
c_Drug_Package.prescription_flag,
c_Drug_Package.default_dispense_amount,
c_Drug_Package.default_dispense_unit,
c_Drug_Package.take_as_directed,
c_Package.description
FROM c_Drug_Package
JOIN c_Package ON c_Drug_Package.package_id = c_Package.package_id
WHERE c_Drug_Package.drug_id = @ps_drug_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_drug_packages]
	TO [cprsystem]
GO

