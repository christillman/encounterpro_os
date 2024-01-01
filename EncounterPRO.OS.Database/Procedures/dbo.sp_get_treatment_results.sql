
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_treatment_results]
Print 'Drop Procedure [dbo].[sp_get_treatment_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_results]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_results]
GO

-- Create Procedure [dbo].[sp_get_treatment_results]
Print 'Create Procedure [dbo].[sp_get_treatment_results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_treatment_results (
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
from	p_observation_result (NOLOCK) 
	JOIN c_observation_result (NOLOCK) ON p_observation_result.observation_id = c_observation_result.observation_id
		and p_observation_result.result_sequence = c_observation_result.result_sequence
	JOIN c_observation (NOLOCK) ON p_observation_result.observation_id = c_Observation.observation_id
	JOIN c_Location (NOLOCK) ON p_observation_result.location = c_Location.location
	JOIN p_Treatment_Item (NOLOCK) ON p_treatment_item.cpr_id = p_observation_result.cpr_id
		AND p_treatment_item.treatment_id = p_observation_result.treatment_id
	JOIN c_treatment_type (NOLOCK) ON p_treatment_item.treatment_type = c_treatment_type.treatment_type 
where p_observation_result.cpr_id = @ps_cpr_id
and p_observation_result.treatment_id = @pl_treatment_id
and c_observation_result.result_type = 'PERFORM'
ORDER BY c_treatment_type.sort_sequence,
	c_Observation.description,
	c_Observation.observation_id,
	c_Location.sort_sequence,
	c_Location.description,
	c_observation_result.sort_sequence,
	c_observation_result.result

GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_results]
	TO [cprsystem]
GO

