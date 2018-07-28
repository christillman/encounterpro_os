CREATE FUNCTION fn_treatment_key_description (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_treatment_type varchar(24),
		@ls_treatment_key varchar(64),
		@ls_treatment_key_description varchar(80)


SELECT @ls_treatment_type = treatment_type
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

SET @ls_treatment_key = dbo.fn_treatment_key(@ps_cpr_id , @pl_treatment_id)



SET @ls_treatment_key_description = dbo.fn_treatment_type_key_description(@ls_treatment_type, @ls_treatment_key)

RETURN @ls_treatment_key_description 

END

