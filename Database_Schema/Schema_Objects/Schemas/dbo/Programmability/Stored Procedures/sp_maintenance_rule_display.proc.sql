/****** Object:  Stored Procedure dbo.sp_maintenance_rule_display    Script Date: 11/16/2000 4:13:15 PM ******/
CREATE PROCEDURE sp_maintenance_rule_display (
	@ps_maintenance_rule_type varchar(24) = 'Rule' )
AS

-- First get a list of the primary assessments
SELECT maintenance_rule_id,
	min(assessment_id) as assessment_id,
	min(CONVERT(varchar(80), '')) as description
INTO #tmp_maint_assmnts
FROM c_Maintenance_Assessment
WHERE primary_flag = 'Y'
GROUP BY maintenance_rule_id

INSERT INTO #tmp_maint_assmnts (
	maintenance_rule_id,
	assessment_id,
	description)
SELECT maintenance_rule_id,
	min(assessment_id) as assessment_id,
	min(CONVERT(varchar(80), '')) as description
FROM c_Maintenance_Assessment
WHERE maintenance_rule_id NOT IN (select maintenance_rule_id FROM #tmp_maint_assmnts)
GROUP BY maintenance_rule_id

-- Then update the assessment description
UPDATE #tmp_maint_assmnts
SET description = a.description
FROM c_Assessment_Definition a
WHERE a.assessment_id = #tmp_maint_assmnts.assessment_id

-- Then get a list of the primary procedures
SELECT maintenance_rule_id,
	min(procedure_id) as procedure_id,
	min(CONVERT(varchar(80), '')) as description
INTO #tmp_maint_rprocs
FROM c_Maintenance_procedure
WHERE primary_flag = 'Y'
GROUP BY maintenance_rule_id

INSERT INTO #tmp_maint_rprocs (
	maintenance_rule_id,
	procedure_id,
	description)
SELECT maintenance_rule_id,
	min(procedure_id) as procedure_id,
	min(CONVERT(varchar(80), '')) as description
FROM c_Maintenance_procedure
WHERE maintenance_rule_id NOT IN (select maintenance_rule_id FROM #tmp_maint_rprocs)
GROUP BY maintenance_rule_id

-- Then update the assessment description
UPDATE #tmp_maint_rprocs
SET description = p.description
FROM c_Procedure p
WHERE p.procedure_id = #tmp_maint_rprocs.procedure_id

-- Then get the maintenance rules with the primary assessments and procedures
SELECT m.maintenance_rule_id,
	m.assessment_flag,
	m.sex,
	m.race,
	m.description,
	ar.age_from,
	ar.age_from_unit,
	ar.age_to,
	ar.age_to_unit,
	ar.description as age_range_description,
	m.interval,
	m.interval_unit,
	m.warning_days,
	CASE assessment_flag WHEN 'Y' then a.assessment_id ELSE NULL END as assessment_id,
	CASE assessment_flag WHEN 'Y' then a.description ELSE NULL END as assessment_description,
	p.procedure_id,
	p.description as procedure_description,
	m.age_range_id,
	selected_flag=0,
	m.status
FROM c_Maintenance_Rule m
	INNER JOIN c_Age_Range ar
	ON m.age_range_id = ar.age_range_id
	LEFT OUTER JOIN #tmp_maint_assmnts a
	ON m.maintenance_rule_id = a.maintenance_rule_id
	LEFT OUTER JOIN #tmp_maint_rprocs p
	ON m.maintenance_rule_id = p.maintenance_rule_id
WHERE m.maintenance_rule_type = @ps_maintenance_rule_type

