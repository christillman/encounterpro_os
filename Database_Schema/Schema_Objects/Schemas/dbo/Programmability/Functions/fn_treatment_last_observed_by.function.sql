CREATE FUNCTION dbo.fn_treatment_last_observed_by (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int)

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_last_observed_by varchar(24)


SELECT @ls_last_observed_by = r.observed_by
FROM p_Observation_Result r
WHERE r.cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND r.location_result_sequence = (SELECT MAX(location_result_sequence) 
                                                FROM p_Observation_Result
                                                WHERE cpr_id = @ps_cpr_id
                                                AND treatment_id = @pl_treatment_id
                                                AND current_flag = 'Y')


RETURN @ls_last_observed_by 

END

