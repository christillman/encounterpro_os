CREATE FUNCTION fn_get_current_treatment (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int)

RETURNS int

AS
BEGIN

DECLARE @ll_parent_treatment_id int,
		@ll_treatment_id int

SET @ll_treatment_id = @pl_treatment_id
SET @ll_parent_treatment_id = 0

WHILE 1=1
	BEGIN
	SELECT @ll_parent_treatment_id = min(treatment_id)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND original_treatment_id = @ll_treatment_id
	
	IF @ll_parent_treatment_id IS NULL
		BREAK
	ELSE
		SET @ll_treatment_id = @ll_parent_treatment_id
	END

RETURN @ll_treatment_id

END

