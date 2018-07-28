CREATE TRIGGER tr_u_Ass_treat_def_attrib_insert ON dbo.u_Assessment_treat_def_attrib
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE d
SET treatment_key = CAST(i.value AS varchar(64))
FROM u_assessment_treat_definition d
	INNER JOIN inserted i
	ON d.definition_id = i.definition_id
WHERE i.attribute = dbo.fn_treatment_type_treatment_key(d.treatment_type)

UPDATE d
SET treatment_mode = CAST(i.value AS varchar(24))
FROM u_assessment_treat_definition d
	INNER JOIN inserted i
	ON d.definition_id = i.definition_id
WHERE i.attribute = 'treatment_mode'

