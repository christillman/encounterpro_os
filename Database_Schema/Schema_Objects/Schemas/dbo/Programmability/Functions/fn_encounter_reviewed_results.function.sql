CREATE FUNCTION fn_encounter_reviewed_results (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS

BEGIN

DECLARE @ll_encounter_results int


-- Finally, Count the results which were in effect at the time of the review
SELECT @ll_encounter_results = count(*)
FROM dbo.fn_encounter_reviewed_results_detail(@ps_cpr_id, @pl_encounter_id)


RETURN @ll_encounter_results

END

