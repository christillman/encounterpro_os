CREATE FUNCTION fn_vfc_eligibility_date (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int )

RETURNS datetime

AS
BEGIN
DECLARE @ls_date varchar(40),
		@ldt_vfc_eligibility_date datetime

SELECT TOP 1 @ls_date = r.result_value
FROM p_Observation_Result r
	INNER JOIN fn_equivalent_observations('0^VFCEligCode') eq
	ON r.observation_id = eq.observation_id
WHERE cpr_id = @ps_cpr_id
AND result_unit = 'DATE'
AND result_value IS NOT NULL
AND ISDATE(result_value) = 1
AND current_flag = 'Y'
ORDER BY CASE WHEN r.treatment_id = @pl_treatment_id THEN 1 
		ELSE CASE WHEN r.encounter_id = @pl_encounter_id THEN 2 ELSE 3 END
		END DESC

IF @ls_date IS NULL
	SET @ls_date = dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', @pl_treatment_id, 'VFC Eligibility Date')

IF @ls_date IS NULL
	SET @ls_date = dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'VFC Eligibility Date')

IF @ls_date IS NULL
	SET @ls_date = dbo.fn_patient_object_property(@ps_cpr_id, 'Patient', NULL, 'VFC Eligibility Date')

IF ISDATE(@ls_date) = 1
	SET @ldt_vfc_eligibility_date = CAST(@ls_date AS datetime)

RETURN @ldt_vfc_eligibility_date 

END

