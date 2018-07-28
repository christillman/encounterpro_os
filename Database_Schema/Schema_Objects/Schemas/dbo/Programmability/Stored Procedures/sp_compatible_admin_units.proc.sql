CREATE PROCEDURE sp_compatible_admin_units (
	@ps_drug_id varchar(24))
AS
SELECT DISTINCT p.administer_unit
INTO #tmp_admin_units
FROM c_Drug_Package d, c_Package p
WHERE d.package_id = p.package_id
AND d.drug_id = @ps_drug_id
SELECT u.unit_id,
	u.description,
	0 as selected_flag
FROM c_Unit u, #tmp_admin_units t
WHERE t.administer_unit = u.unit_id

