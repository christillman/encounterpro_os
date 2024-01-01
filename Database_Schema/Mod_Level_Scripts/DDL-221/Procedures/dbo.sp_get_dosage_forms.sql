
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_dosage_forms]
Print 'Drop Procedure [dbo].[sp_get_dosage_forms]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_dosage_forms]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_dosage_forms]
GO

-- Create Procedure [dbo].[sp_get_dosage_forms]
Print 'Create Procedure [dbo].[sp_get_dosage_forms]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_dosage_forms (
	@ps_drug_id varchar(24),
	@ps_administer_unit varchar(24) = NULL )
AS
IF @ps_administer_unit IS NULL
	SELECT DISTINCT c_Dosage_Form.dosage_form,
			c_Dosage_Form.description,
			selected_flag = 0
	FROM	c_Drug_Package (NOLOCK)
		JOIN c_Package (NOLOCK) ON c_Drug_Package.package_id = c_Package.package_id
		JOIN c_Dosage_Form (NOLOCK) ON c_Package.dosage_form = c_Dosage_Form.dosage_form
	WHERE	c_Drug_Package.drug_id = @ps_drug_id
ELSE
	SELECT DISTINCT c_Dosage_Form.dosage_form,
			c_Dosage_Form.description,
			selected_flag = 0
	FROM	c_Drug_Package (NOLOCK)
		JOIN c_Package (NOLOCK) ON c_Drug_Package.package_id = c_Package.package_id
		JOIN c_Dosage_Form (NOLOCK) ON c_Package.dosage_form = c_Dosage_Form.dosage_form
	WHERE	c_Drug_Package.drug_id = @ps_drug_id
	AND (c_Package.administer_unit = @ps_administer_unit
		OR EXISTS
			(
			SELECT c_Unit_Conversion.unit_from
			FROM c_Unit_Conversion
			WHERE ( c_Unit_Conversion.unit_from = c_Package.administer_unit
				  AND c_Unit_Conversion.unit_to = @ps_administer_unit )
			OR ( c_Unit_Conversion.unit_from = @ps_administer_unit
				  AND c_Unit_Conversion.unit_to = c_Package.administer_unit )
			)
		)

GO
GRANT EXECUTE
	ON [dbo].[sp_get_dosage_forms]
	TO [cprsystem]
GO

