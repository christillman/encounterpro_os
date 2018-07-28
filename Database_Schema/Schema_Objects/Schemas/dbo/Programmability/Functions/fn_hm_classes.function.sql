CREATE FUNCTION dbo.fn_hm_classes (
	@ps_maintenance_rule_type varchar(24) )

RETURNS @classes TABLE (
	[maintenance_rule_id] [int] NOT NULL,
	[description] [varchar](80) NOT NULL,
	[last_reset] [datetime] NULL,
	[patients] [int] NOT NULL DEFAULT (0),
	[compliant_patients] [int] NOT NULL DEFAULT (0),
	[measured_patients] [int] NOT NULL DEFAULT (0),
	[controlled_patients] [int] NOT NULL DEFAULT (0))

AS
BEGIN

INSERT INTO @classes (
	maintenance_rule_id,
	description,
	last_reset)
SELECT maintenance_rule_id,
	description,
	last_reset
FROM dbo.c_Maintenance_Patient_Class
WHERE (@ps_maintenance_rule_type IS NULL OR maintenance_rule_type = @ps_maintenance_rule_type)

DECLARE @counts TABLE (
	maintenance_rule_id int NOT NULL,
	is_controlled char(1) NOT NULL,
	patient_count int NOT NULL)

INSERT INTO @counts (
	maintenance_rule_id,
	is_controlled,
	patient_count)
SELECT c.maintenance_rule_id,
	c.is_controlled,
	patient_count = count(*)
FROM dbo.p_Maintenance_Class c
	INNER JOIN p_Patient p
	ON c.cpr_id = p.cpr_id
WHERE c.current_flag = 'Y'
AND c.in_class_flag = 'Y'
AND p.patient_status = 'Active'
GROUP BY c.maintenance_rule_id, c.is_controlled

-- Count the total patients as the sum for all three is_controlled states
UPDATE c
SET patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT maintenance_rule_id, patient_count = sum(patient_count)
		FROM @counts
		GROUP BY maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id

-- Count the measured patients as the sum for is_controlled IN ('Y', 'N')
UPDATE c
SET measured_patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT maintenance_rule_id, patient_count = sum(patient_count)
		FROM @counts
		WHERE is_controlled IN ('Y', 'N')
		GROUP BY maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id

-- Count the controlled patients as the count of patients where is_controlled = 'Y'
UPDATE c
SET controlled_patients = x.patient_count
FROM @classes c
	INNER JOIN @counts x
	ON c.maintenance_rule_id = x.maintenance_rule_id
WHERE x.is_controlled = 'Y'

-- Count the compliant patients as the count of patients where on_protocol_flag = 'Y'
UPDATE c
SET compliant_patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT mc.maintenance_rule_id, patient_count = count(*)
		FROM dbo.p_Maintenance_Class mc
			INNER JOIN p_Patient p
			ON mc.cpr_id = p.cpr_id
		WHERE mc.current_flag = 'Y'
		AND mc.in_class_flag = 'Y'
		AND mc.on_protocol_flag = 'Y'
		AND p.patient_status = 'Active'
		GROUP BY mc.maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id



RETURN
END
