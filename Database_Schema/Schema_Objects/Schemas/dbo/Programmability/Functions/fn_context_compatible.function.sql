CREATE FUNCTION fn_context_compatible (
	@ps_existing_context varchar(12),
	@ps_new_context varchar(12) )

RETURNS bit

AS
BEGIN
DECLARE @li_compatible bit

SET @li_compatible = 0

-- If the two contexts are the same then they're compatible
IF @ps_existing_context = @ps_new_context
	SET @li_compatible = 1

-- The general context is compatible with everything
IF @ps_new_context = 'General'
	SET @li_compatible = 1

-- If the existing context isn't general then it's always compatible with 'Patient'
IF @ps_existing_context <> 'General' AND @ps_new_context = 'Patient'
	SET @li_compatible = 1


RETURN @li_compatible 

END

