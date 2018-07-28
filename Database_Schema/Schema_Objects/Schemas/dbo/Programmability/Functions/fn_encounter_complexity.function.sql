CREATE FUNCTION fn_encounter_complexity (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS

BEGIN


DECLARE @ll_encounter_complexity int

SELECT @ll_encounter_complexity = SUM(complexity)
FROM dbo.fn_encounter_complexity_detail(@ps_cpr_id, @pl_encounter_id)

RETURN @ll_encounter_complexity
END

