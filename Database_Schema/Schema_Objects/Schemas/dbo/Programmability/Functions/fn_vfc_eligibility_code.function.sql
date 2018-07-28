CREATE FUNCTION fn_vfc_eligibility_code (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_vfc_eligibility_code varchar(80)

SELECT TOP 1 @ls_vfc_eligibility_code = r.result
FROM p_Observation_Result r
	INNER JOIN fn_equivalent_observations('0^VFCEligCode') eq
	ON r.observation_id = eq.observation_id
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
AND result_unit is NULL
ORDER BY CASE WHEN r.treatment_id = @pl_treatment_id THEN 1 
		ELSE CASE WHEN r.encounter_id = @pl_encounter_id THEN 2 ELSE 3 END
		END DESC,r.location_result_sequence DESC

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Treatment', @pl_treatment_id, 'VFC Eligibility Code') AS varchar(80))

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'VFC Eligibility Code') AS varchar(80))

IF @ls_vfc_eligibility_code IS NULL
	SET @ls_vfc_eligibility_code = CAST(dbo.fn_patient_object_property(@ps_cpr_id, 'Patient', NULL, 'VFC Eligibility Code') AS varchar(80))

RETURN @ls_vfc_eligibility_code 

END

