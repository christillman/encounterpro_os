CREATE FUNCTION fn_convert_units (
	@pr_amount real,
	@ps_from_unit_id varchar(12),
	@ps_to_unit_id varchar(12))

RETURNS real

AS
BEGIN

DECLARE @lr_to_amount real,
		@lr_conversion_factor real,
		@lr_conversion_difference real

SET @lr_to_amount = NULL

-- If the units are the same then just echo the amount
IF @ps_from_unit_id = @ps_to_unit_id
	RETURN @pr_amount

SELECT @lr_conversion_factor = conversion_factor,
		@lr_conversion_difference = conversion_difference
FROM c_Unit_Conversion
WHERE unit_from = @ps_from_unit_id
AND unit_to = @ps_to_unit_id

IF @@ROWCOUNT = 1
	BEGIN
	SET @lr_to_amount = (@pr_amount * @lr_conversion_factor) + @lr_conversion_difference
	END
ELSE
	BEGIN
	SELECT @lr_conversion_factor = conversion_factor,
			@lr_conversion_difference = conversion_difference
	FROM c_Unit_Conversion
	WHERE unit_from = @ps_to_unit_id
	AND unit_to = @ps_from_unit_id
	
	IF @@ROWCOUNT = 0
		RETURN @lr_to_amount
	
	SET @lr_to_amount = (@pr_amount - @lr_conversion_difference) / @lr_conversion_factor
	
	END


RETURN @lr_to_amount 

END
