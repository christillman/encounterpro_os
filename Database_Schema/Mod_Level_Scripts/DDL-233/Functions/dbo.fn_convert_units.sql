
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_convert_units]
Print 'Drop Function [dbo].[fn_convert_units]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_convert_units]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_convert_units]
GO

-- Create Function [dbo].[fn_convert_units]
Print 'Create Function [dbo].[fn_convert_units]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_convert_units (
	@pr_amount real,
	@ps_from_unit_id varchar(12),
	@ps_to_unit_id varchar(12))

RETURNS real

AS
BEGIN

DECLARE @lr_to_amount real,
		@lr_conversion_factor real = 0.0,
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

IF @lr_conversion_factor != 0.0
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
	
	IF @lr_conversion_factor = 0.0
		RETURN @lr_to_amount
	
	SET @lr_to_amount = (@pr_amount - @lr_conversion_difference) / @lr_conversion_factor
	
	END


RETURN @lr_to_amount 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_convert_units]
	TO [cprsystem]
GO

