CREATE PROCEDURE sp_check_maintenance_rule_overlap (
	@pl_age int,
	@ps_unit varchar(24),
	@pdt_age_date datetime output,
	@pl_age_range_id int output )
AS
DECLARE @ldt_fixed_date datetime

SELECT @ldt_fixed_date = convert(datetime, '1/1/1980')

SELECT @pdt_age_date = CASE @ps_unit
			WHEN 'YEAR' THEN dateadd(year, @pl_age, @ldt_fixed_date)
			WHEN 'MONTH' THEN dateadd(month, @pl_age, @ldt_fixed_date)
			WHEN 'DAY' THEN dateadd(day, @pl_age, @ldt_fixed_date)
			END


select @pl_age_range_id = c_Age_Range.age_range_id
FROM c_Age_Range
WHERE @pdt_age_date >= CASE age_from_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, @ldt_fixed_date)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, @ldt_fixed_date)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, @ldt_fixed_date)
			END
AND @pdt_age_date < CASE age_to_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, @ldt_fixed_date)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, @ldt_fixed_date)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, @ldt_fixed_date)
			END

