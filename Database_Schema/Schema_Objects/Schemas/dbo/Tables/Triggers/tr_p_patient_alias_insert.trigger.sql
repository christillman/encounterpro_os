CREATE TRIGGER tr_p_patient_alias_insert ON dbo.p_Patient_Alias
FOR INSERT
AS

UPDATE a
SET current_flag = 'N'
FROM p_Patient_Alias a
	INNER JOIN inserted i
	ON a.cpr_id = i.cpr_id
	AND a.alias_type = i.alias_type
WHERE a.alias_sequence < i.alias_sequence
AND i.current_flag = 'Y'
AND a.current_flag = 'Y'

UPDATE p
SET last_name = i.last_name,
	first_name = i.first_name,
	middle_name = i.middle_name,
	name_prefix = i.name_prefix,
	name_suffix = i.name_suffix,
	degree = i.degree
FROM p_Patient p
	INNER JOIN inserted i
	ON p.cpr_id = i.cpr_id
WHERE i.current_flag = 'Y'
AND i.alias_type = 'Primary'

