﻿CREATE PROCEDURE sp_get_treatment_results (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int )
AS
select	p_observation_result.treatment_id,
	p_observation_result.observation_id,
	p_observation_result.location,
	p_observation_result.result_sequence,
	p_observation_result.encounter_id,
	p_observation_result.attachment_id,
	convert(real,p_observation_result.result_value)as result_amount,
	p_observation_result.result_date_time,
	c_observation.description as observation_description,
	c_observation.collection_location_domain,
	c_observation.perform_location_domain,
	c_observation_result.result_unit,
	c_observation_result.result,
	c_observation_result.result_amount_flag,
	c_observation_result.abnormal_flag,
	c_observation_result.sort_sequence as result_sort_sequence,
	c_observation_result.status,
	c_Location.sort_sequence as location_sort_sequence,
	c_Location.description as location_description,
	c_treatment_type.treatment_type,
	c_treatment_type.sort_sequence as treatment_sort_sequence,
	c_treatment_type.icon,
	c_treatment_type.observation_type
from	p_observation_result (NOLOCK),
	c_observation_result (NOLOCK),
	c_observation (NOLOCK),
	c_Location (NOLOCK),
	c_treatment_type (NOLOCK),
	p_treatment_item (NOLOCK)
where p_observation_result.observation_id = c_observation_result.observation_id
and p_observation_result.result_sequence = c_observation_result.result_sequence
and p_observation_result.observation_id = c_Observation.observation_id
and p_observation_result.location = c_Location.location
and p_observation_result.cpr_id = @ps_cpr_id
and p_observation_result.treatment_id = @pl_treatment_id
and c_observation_result.result_type = 'PERFORM'
and p_treatment_item.treatment_type = c_treatment_type.treatment_type
and p_treatment_item.cpr_id = @ps_cpr_id
and p_treatment_item.treatment_id = @pl_treatment_id
ORDER BY c_treatment_type.sort_sequence,
	c_Observation.description,
	c_Observation.observation_id,
	c_Location.sort_sequence,
	c_Location.description,
	c_observation_result.sort_sequence,
	c_observation_result.result
