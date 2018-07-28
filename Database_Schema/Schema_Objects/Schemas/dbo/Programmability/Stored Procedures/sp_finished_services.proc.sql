CREATE PROCEDURE sp_finished_services (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pi_count smallint OUTPUT )
AS
SELECT @pi_count = count(i.patient_workplan_item_id)
FROM p_Patient_Encounter e, p_Patient_WP_Item i
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
AND i.cpr_id = @ps_cpr_id
AND i.patient_workplan_id = e.patient_workplan_id
AND i.status = 'COMPLETED'

