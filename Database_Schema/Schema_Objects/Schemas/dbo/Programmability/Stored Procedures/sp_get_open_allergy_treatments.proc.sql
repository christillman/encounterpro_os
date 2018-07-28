CREATE PROCEDURE sp_get_open_allergy_treatments (
	@ps_cpr_id varchar(12)
)

AS

SELECT cpr_id,
	open_encounter_id,
	treatment_id,
	treatment_type,
	treatment_description,
	begin_date	
FROM p_Treatment_Item a
WHERE treatment_type = 'AllergyInjections'
AND cpr_id = @ps_cpr_id
AND ISNULL(treatment_status, 'OPEN') = 'OPEN'

