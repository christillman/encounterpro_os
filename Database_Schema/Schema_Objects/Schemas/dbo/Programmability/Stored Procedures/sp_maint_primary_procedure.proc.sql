CREATE PROCEDURE sp_maint_primary_procedure (
	@pl_maintenance_rule_id int,
	@ps_procedure_id varchar(24) OUTPUT ,
	@ps_procedure_description varchar(80) OUTPUT )
AS
-- First get a list of the primary procedures
SELECT @ps_procedure_id = min(procedure_id)
FROM c_Maintenance_Procedure
WHERE maintenance_rule_id = @pl_maintenance_rule_id
AND primary_flag = 'Y'
IF @ps_procedure_id IS NULL
	SELECT @ps_procedure_id = min(procedure_id)
	FROM c_Maintenance_Procedure
	WHERE maintenance_rule_id = @pl_maintenance_rule_id
IF @ps_procedure_id IS NULL
	SELECT @ps_procedure_description = NULL
ELSE
	SELECT @ps_procedure_description = description
	FROM c_Procedure
	WHERE procedure_id = @ps_procedure_id

