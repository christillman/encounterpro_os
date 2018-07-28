CREATE FUNCTION fn_treatment_key (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int )

RETURNS varchar(64)

AS
BEGIN
DECLARE @ls_treatment_key varchar(64)

SELECT @ls_treatment_key = CASE dbo.fn_treatment_type_treatment_key(treatment_type)
		WHEN 'procedure_id' THEN procedure_id
		WHEN 'material_id' THEN CONVERT(varchar(40), material_id)
		WHEN 'drug_id' THEN drug_id
		WHEN 'observation_id' THEN observation_id
		WHEN 'treatment_description' THEN CAST(treatment_description AS varchar(64))
		WHEN 'treatment_type'  THEN treatment_type
		ELSE null END
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

RETURN @ls_treatment_key 

END

