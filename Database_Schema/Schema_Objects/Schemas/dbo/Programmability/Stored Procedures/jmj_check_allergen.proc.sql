CREATE PROCEDURE jmj_check_allergen (
	@ps_cpr_id varchar(12),
	@ps_drug_id varchar(24) )

AS

DECLARE @ll_treatment_id int

SELECT @ll_treatment_id = max(tp.treatment_id)
FROM p_Treatment_Item tp
	INNER JOIN p_Treatment_Item tc
	ON tp.cpr_id = tc.cpr_id
	AND tp.treatment_id = tc.parent_treatment_id
WHERE tc.cpr_id = @ps_cpr_id
AND tc.drug_id = @ps_drug_id
AND tc.treatment_type = 'AllergyVialDefinition'
AND ISNULL(tc.treatment_status, 'OPEN') = 'OPEN'
AND ISNULL(tp.treatment_status, 'OPEN') = 'OPEN'


RETURN @ll_treatment_id

