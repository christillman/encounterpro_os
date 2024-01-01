
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_compatible_admin_units]
Print 'Drop Procedure [dbo].[sp_compatible_admin_units]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_compatible_admin_units]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_compatible_admin_units]
GO

-- Create Procedure [dbo].[sp_compatible_admin_units]
Print 'Create Procedure [dbo].[sp_compatible_admin_units]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_compatible_admin_units (
	@ps_drug_id varchar(24))
AS
SELECT DISTINCT p.administer_unit
INTO #tmp_admin_units
FROM c_Drug_Package d
JOIN c_Package p ON d.package_id = p.package_id
WHERE d.drug_id = @ps_drug_id

SELECT u.unit_id,
	u.description,
	0 as selected_flag
FROM c_Unit u
JOIN #tmp_admin_units t
ON t.administer_unit = u.unit_id

GO
GRANT EXECUTE
	ON [dbo].[sp_compatible_admin_units]
	TO [cprsystem]
GO

