CREATE PROCEDURE sp_get_performed_history (
	@ps_cpr_id varchar(12) )
AS
select	p_observation_result.treatment_id,
	p_observation_result.observation_id,
	p_observation_result.location,
	p_observation_result.result_sequence,
	p_observation_result.encounter_id,
	p_observation_result.attachment_id,
	convert(real,p_observation_result.result_value),
	p_observation_result.result_date_time,
	c_observation.description,
	c_observation.collection_location_domain,
	c_observation.perform_location_domain,
	c_observation_result.result_unit,
	c_observation_result.result,
	c_observation_result.result_amount_flag,
	c_observation_result.abnormal_flag,
	c_observation_result.sort_sequence,
	c_observation_result.status,
	c_Location.sort_sequence,
	c_Location.description,
	c_treatment_type.treatment_type,
	c_treatment_type.sort_sequence,
	c_treatment_type.icon,
	p_Treatment_Item.attachment_id,
	p_Treatment_Item.send_out_flag,
	p_Treatment_Item.begin_date,
	p_Treatment_Item.ordered_by
from	p_observation_result (NOLOCK),
	c_observation_result (NOLOCK),
	c_observation (NOLOCK),
	c_Location (NOLOCK),
	c_treatment_type (NOLOCK),
	p_observation (NOLOCK),
	p_Treatment_Item (NOLOCK)
where p_Treatment_Item.cpr_id = @ps_cpr_id
and p_observation.cpr_id = @ps_cpr_id
and p_observation.treatment_id = p_Treatment_Item.treatment_id
and p_observation_result.cpr_id = @ps_cpr_id
and p_observation_result.treatment_id = p_observation.treatment_id
and p_observation_result.observation_sequence = p_observation.observation_sequence
and p_observation_result.observation_id = p_observation.observation_id
and p_observation_result.observation_id = c_observation_result.observation_id
and p_observation_result.result_sequence = c_observation_result.result_sequence
and p_observation.observation_id = c_Observation.observation_id
and p_treatment_item.treatment_type = c_treatment_type.treatment_type 
and c_Observation.perform_location_domain = c_Location.location_domain
and p_observation_result.location = c_Location.location
and p_Treatment_Item.treatment_status = 'CLOSED'
and p_Treatment_Item.treatment_type = 'TEST'
and c_observation_result.result_type = 'PERFORM'
ORDER BY p_Treatment_Item.begin_date desc,
	c_treatment_type.sort_sequence,
	p_observation_result.treatment_id,
	p_observation_result.observation_id,
	c_Location.sort_sequence,
	c_observation_result.sort_sequence

