CREATE PROCEDURE sp_get_dosage_forms (
	@ps_drug_id varchar(24),
	@ps_administer_unit varchar(24) = NULL )
AS
IF @ps_administer_unit IS NULL
	SELECT DISTINCT c_Dosage_Form.dosage_form,
			c_Dosage_Form.description,
			selected_flag = 0
	FROM	c_Drug_Package (NOLOCK),
		c_Package (NOLOCK),
		c_Dosage_Form (NOLOCK)
	WHERE	c_Drug_Package.drug_id = @ps_drug_id
	AND	c_Drug_Package.package_id = c_Package.package_id
	AND	c_Package.dosage_form = c_Dosage_Form.dosage_form
ELSE
	SELECT DISTINCT c_Dosage_Form.dosage_form,
			c_Dosage_Form.description,
			selected_flag = 0
	FROM	c_Drug_Package (NOLOCK),
		c_Package (NOLOCK),
		c_Dosage_Form (NOLOCK)
	WHERE	c_Drug_Package.drug_id = @ps_drug_id
	AND	c_Drug_Package.package_id = c_Package.package_id
	AND	c_Package.dosage_form = c_Dosage_Form.dosage_form
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

