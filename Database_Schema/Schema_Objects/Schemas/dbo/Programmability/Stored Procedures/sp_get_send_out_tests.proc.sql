CREATE PROCEDURE sp_get_send_out_tests (
	@ps_cpr_id varchar(12) )
AS
SELECT	p_Treatment_Item.open_encounter_id,
	p_Treatment_Item.treatment_id, 	p_Patient_Encounter.encounter_date,
	p_Treatment_Item.treatment_description
FROM p_Treatment_Item WITH (NOLOCK),
	p_Patient_Encounter WITH (NOLOCK)
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Treatment_Item.open_encounter_id = p_Patient_Encounter.encounter_id
AND (p_Treatment_Item.treatment_status IS NULL
OR p_Treatment_Item.treatment_status IN ('COLLECTED', 'NEEDSAMPLE') )
and p_Treatment_Item.treatment_type = 'TEST'


