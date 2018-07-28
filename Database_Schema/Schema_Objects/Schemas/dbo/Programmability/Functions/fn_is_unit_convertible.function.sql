CREATE FUNCTION fn_is_unit_convertible (
	@ps_from_unit_id varchar(12),
	@ps_to_unit_id varchar(12))

RETURNS int

AS
BEGIN

DECLARE @ll_is_convertible int

IF @ps_from_unit_id = @ps_to_unit_id
	RETURN 1

IF EXISTS(
		SELECT 1
		FROM c_Unit_Conversion
		WHERE (unit_from = @ps_from_unit_id and unit_to = @ps_to_unit_id)
		OR (unit_from = @ps_to_unit_id and unit_to = @ps_from_unit_id) )
	RETURN 1
	
RETURN 0

END

