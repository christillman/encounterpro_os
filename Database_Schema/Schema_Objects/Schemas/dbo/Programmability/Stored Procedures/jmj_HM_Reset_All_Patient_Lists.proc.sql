CREATE PROCEDURE jmj_HM_Reset_All_Patient_Lists
AS

DECLARE @ll_maintenance_rule_id int

DECLARE lc_rules CURSOR LOCAL FAST_FORWARD FOR
	SELECT maintenance_rule_id
	FROM c_Maintenance_Patient_Class mc
	WHERE status = 'OK'
	AND NOT EXISTS (
		SELECT 1
		FROM c_Maintenance_Patient_Class mc2
		WHERE mc.maintenance_rule_id = mc2.filter_from_maintenance_rule_id)
		
OPEN lc_rules

FETCH lc_rules INTO @ll_maintenance_rule_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE dbo.jmj_HM_Reset_Patient_List @pl_maintenance_rule_id = @ll_maintenance_rule_id

	FETCH lc_rules INTO @ll_maintenance_rule_id
	END

CLOSE lc_rules
DEALLOCATE lc_rules



