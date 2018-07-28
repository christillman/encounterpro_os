CREATE FUNCTION fn_last_treatment_for_patient (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int )

RETURNS int

AS
BEGIN
DECLARE @ll_last_treatment_id int

IF EXISTS(SELECT 1 FROM p_Treatment_Item WHERE cpr_id = @ps_cpr_id AND treatment_id = @pl_treatment_id)
	RETURN @pl_treatment_id

SELECT @ll_last_treatment_id = MAX(treatment_id)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id < @pl_treatment_id

RETURN @ll_last_treatment_id 

END

