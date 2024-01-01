
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_obj_list_results]
Print 'Drop Procedure [dbo].[sp_get_obj_list_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_obj_list_results]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_obj_list_results]
GO

-- Create Procedure [dbo].[sp_get_obj_list_results]
Print 'Create Procedure [dbo].[sp_get_obj_list_results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_obj_list_results (
	@ps_cpr_id varchar(12),
	@ps_obj_list_id varchar(24),
	@pdt_from_date datetime )
AS
SELECT p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.encounter_date,
	p_Observation_Result.observation_id,
	p_Observation_Result.result_sequence,
	p_Observation_Result.location,
	convert(real,p_Observation_Result.result_value) as result_amount,
	p_Observation_Result.result_unit,
	1 as item_index
FROM p_Observation_Result (NOLOCK)
	JOIN c_Observation_Tree (NOLOCK) ON p_Observation_Result.result_sequence = c_Observation_Tree.result_sequence
		AND p_Observation_Result.location = c_Observation_Tree.location
		AND p_Observation_Result.observation_id = c_Observation_Tree.child_observation_id
	JOIN p_Patient_Encounter (NOLOCK) ON p_Observation_Result.encounter_id = p_Patient_Encounter.encounter_id
		AND p_Observation_Result.cpr_id = p_Patient_Encounter.cpr_id
WHERE c_Observation_Tree.parent_observation_id = @ps_obj_list_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.encounter_date >= @pdt_from_date
UNION
SELECT p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.encounter_date,
	p_Observation_Result.observation_id,
	p_Observation_Result.result_sequence,
	p_Observation_Result.location,
	convert(real,p_Observation_Result.result_value) as result_amount,
	p_Observation_Result.result_unit,
	2 as item_index
FROM p_Observation_Result (NOLOCK)
	JOIN c_Observation_Tree (NOLOCK) ON p_Observation_Result.result_sequence = c_Observation_Tree.result_sequence
		AND p_Observation_Result.location = c_Observation_Tree.location
		AND p_Observation_Result.observation_id = c_Observation_Tree.child_observation_id
	JOIN p_Patient_Encounter (NOLOCK) ON p_Observation_Result.encounter_id = p_Patient_Encounter.encounter_id
		AND p_Observation_Result.cpr_id = p_Patient_Encounter.cpr_id
WHERE c_Observation_Tree.parent_observation_id = @ps_obj_list_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.encounter_date >= @pdt_from_date

GO
GRANT EXECUTE
	ON [dbo].[sp_get_obj_list_results]
	TO [cprsystem]
GO

