CREATE PROCEDURE sp_maint_primary_assessment (
	@pl_maintenance_rule_id int,
	@ps_assessment_id varchar(24) OUTPUT ,
	@ps_assessment_description varchar(80) OUTPUT )
AS
-- First get a list of the primary assessments
SELECT @ps_assessment_id = min(assessment_id)
FROM c_Maintenance_Assessment
WHERE maintenance_rule_id = @pl_maintenance_rule_id
AND primary_flag = 'Y'
IF @ps_assessment_id IS NULL
	SELECT @ps_assessment_id = min(assessment_id)
	FROM c_Maintenance_Assessment
	WHERE maintenance_rule_id = @pl_maintenance_rule_id
IF @ps_assessment_id IS NULL
	SELECT @ps_assessment_description = NULL
ELSE
	SELECT @ps_assessment_description = description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_assessment_id

