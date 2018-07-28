CREATE FUNCTION fn_age_range_compare (
	@pl_age_range_id int,
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS int

AS
BEGIN

DECLARE @ll_result int,
		@ll_age_from int,
		@ls_age_from_unit_id varchar(24),
		@ll_age_to int,
		@ls_age_to_unit_id varchar(24),
		@ll_compare_from int,
		@ll_compare_to int

SELECT @ll_age_from = age_from,
		@ls_age_from_unit_id = age_from_unit,
		@ll_age_to = age_to,
		@ls_age_to_unit_id = age_to_unit
FROM c_Age_Range
WHERE age_range_id = @pl_age_range_id

IF @@ROWCOUNT = 1
	BEGIN
	SET @ll_compare_from = dbo.fn_interval_compare(@ll_age_from, @ls_age_from_unit_id, @pdt_begin_date, @pdt_end_date)
	
	-- If the upper bound is null then there is no limit
	IF @ll_age_to IS NULL OR @ls_age_to_unit_id IS NULL
		SET @ll_compare_to = -1
	ELSE
		SET @ll_compare_to = dbo.fn_interval_compare(@ll_age_to, @ls_age_to_unit_id, @pdt_begin_date, @pdt_end_date)
	
	SET @ll_result = 0
	IF @ll_compare_from < 0
		SET @ll_result = -1
	
	IF @ll_compare_to >= 0
		SET @ll_result = 1
	
	END
ELSE
	SET @ll_result = NULL


RETURN @ll_result 

END
