CREATE FUNCTION fn_hm_class_patients (
	@pl_maintenance_rule_id int )

RETURNS @patients TABLE (
	cpr_id varchar(12) NOT NULL,
	on_protocol_flag char(1) NOT NULL,
	is_controlled char(1) NOT NULL)

AS
BEGIN

INSERT INTO @patients (
	cpr_id,
	on_protocol_flag,
	is_controlled )
SELECT cpr_id,
		on_protocol_flag,
		is_controlled
FROM p_Maintenance_Class
WHERE maintenance_rule_id = @pl_maintenance_rule_id
AND in_class_flag = 'Y'
AND current_flag = 'Y'

RETURN
END
