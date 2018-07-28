/****** Object:  View dbo.c_Maintenance_Rule    Script Date: 7/25/2000 8:42:39 AM ******/
CREATE VIEW dbo.c_Maintenance_Rule
AS
SELECT [maintenance_rule_id],
		[maintenance_rule_type],
		[assessment_flag],
		[sex],
		[race],
		[description],
		[age_range_id],
		[interval],
		[interval_unit],
		[warning_days],
		[status],
		[last_updated],
		[id],
		[owner_id],
		[last_reset]
FROM c_Maintenance_Patient_Class
WHERE maintenance_rule_type = 'Rule'
