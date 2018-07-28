CREATE PROCEDURE jmj_treatment_type_default_modes (
	@ps_treatment_type varchar(24))
AS


SELECT o.office_id,
		office_description = o.description,
		m.treatment_mode,
		selected_flag=0
FROM c_Office o
	LEFT OUTER JOIN o_Treatment_Type_Default_Mode m
	ON o.office_id = m.office_id
	AND m.treatment_key = '!Default'
	AND m.treatment_type = @ps_treatment_type
WHERE o.status = 'OK'


