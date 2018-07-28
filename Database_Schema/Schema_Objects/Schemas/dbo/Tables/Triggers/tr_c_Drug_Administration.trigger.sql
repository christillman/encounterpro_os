CREATE TRIGGER tr_c_Drug_Administration ON c_Drug_Administration
FOR  DELETE 
AS

DELETE A
FROM u_assessment_treat_def_attrib  A
	INNER JOIN deleted d
	ON A.value = CONVERT(varchar(12),d.administration_sequence)
	INNER JOIN u_assessment_treat_def_attrib B
	ON B.definition_id = A.definition_id
	AND B.value = d.drug_id
WHERE A.attribute = 'administration_sequence'
AND B.attribute = 'drug_id'
