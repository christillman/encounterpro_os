
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_treatment_results_description]
Print 'Drop Procedure [dbo].[sp_get_treatment_results_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_results_description]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_results_description]
GO

-- Create Procedure [dbo].[sp_get_treatment_results_description]
Print 'Create Procedure [dbo].[sp_get_treatment_results_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_treatment_results_description (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_description varchar(255) OUTPUT )
AS

DECLARE @ls_root_observation_id varchar(24),
	@ls_composite_flag char(1),
	@ls_open_flag varchar(1),
	@ls_observation_type varchar(24)

SELECT @ls_root_observation_id = observation_id,
	@ls_open_flag = open_flag
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @ls_open_flag IS NULL
	BEGIN
	RAISERROR ('No such treatment (%s, %d)',16,-1, @ps_cpr_id, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ls_root_observation_id IS NULL
	BEGIN
	SELECT @ps_description = NULL
	RETURN
	END

SELECT @ls_composite_flag = composite_flag,
	@ls_observation_type = observation_type
FROM c_Observation
WHERE observation_id = @ls_root_observation_id

IF @ls_observation_type IS NULL
	BEGIN
	RAISERROR ('No such observation (%s)',16,-1, @ls_root_observation_id)
	ROLLBACK TRANSACTION
	RETURN
	END

select	p_observation_result.treatment_id,
	p_observation_result.observation_id,
	p_observation_result.location,
	p_observation_result.result_sequence,
	p_observation_result.encounter_id,
	p_observation_result.attachment_id,
	p_observation_result.attachment_id,
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
	c_observation_result.severity,
	c_observation_result.sort_sequence as result_sort_sequence,
	c_observation_result.status,
	c_Location.sort_sequence as location_sort_sequence,
	c_Location.description as location_description,
	c_treatment_type.treatment_type,
	c_treatment_type.sort_sequence as treatment_sort_sequence,
	c_treatment_type.icon
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
and p_treatment_item.cpr_id = @ps_cpr_id
and p_treatment_item.treatment_id = @pl_treatment_id
ORDER BY c_treatment_type.sort_sequence,
	c_Observation.description,
	c_Observation.observation_id,
	c_Location.sort_sequence,
	c_Location.description,
	c_observation_result.sort_sequence,
	c_observation_result.result

GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_results_description]
	TO [cprsystem]
GO

