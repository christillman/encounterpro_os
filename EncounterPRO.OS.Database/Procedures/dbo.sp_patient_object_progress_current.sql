
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_patient_object_progress_current]
Print 'Drop Procedure [dbo].[sp_patient_object_progress_current]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_patient_object_progress_current]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_patient_object_progress_current]
GO

-- Create Procedure [dbo].[sp_patient_object_progress_current]
Print 'Create Procedure [dbo].[sp_patient_object_progress_current]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_patient_object_progress_current (
	@ps_cpr_id varchar(12))

AS

-- Exclude the progress records that have an empty value (short, long, attachment all null) and
-- are not 'created', 'closed', 'reviewed', or 'Refill%' progress types. The excluded records 
-- are largely meaningless and there is a problem with the RTF "xxx progress" command that
-- freezes EncounterPRO on the empty progress records

SELECT 
	[cpr_id] ,
	'Patient' as context_object,
	NULL as object_key,
	[patient_progress_sequence] as progress_sequence,
	[encounter_id] ,
	[user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	[progress] ,
	[attachment_id] ,
	[patient_workplan_item_id] ,
	[risk_level] ,
	[created] ,
	[created_by] 
FROM p_Patient_Progress WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
and not (
progress_value IS NULL
and progress IS NULL
and attachment_id IS NULL
and progress_type not in ('created', 'closed', 'reviewed')
and progress_type NOT LIKE 'Refill%'
)
union all
SELECT 
	[cpr_id] ,
	'Encounter' ,
	[encounter_id] ,
	[encounter_progress_sequence] ,
	[encounter_id] ,
	[user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	[progress] ,
	[attachment_id] ,
	[patient_workplan_item_id] ,
	[risk_level] ,
	[created] ,
	[created_by] 
FROM p_Patient_Encounter_Progress WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
and not (
progress_value IS NULL
and progress IS NULL
and attachment_id IS NULL
and progress_type not in ('created', 'closed', 'reviewed')
and progress_type NOT LIKE 'Refill%'
)
union all
SELECT 
	[cpr_id] ,
	'Assessment' ,
	[problem_id] ,
	[assessment_progress_sequence] ,
	[encounter_id] ,
	[user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	[progress] ,
	[attachment_id] ,
	[patient_workplan_item_id] ,
	[risk_level] ,
	[created] ,
	[created_by] 
FROM p_Assessment_Progress WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
and not (
progress_value IS NULL
and progress IS NULL
and attachment_id IS NULL
and progress_type not in ('created', 'closed', 'reviewed')
and progress_type NOT LIKE 'Refill%'
)
union all
SELECT 
	[cpr_id] ,
	'Treatment' ,
	[treatment_id] ,
	[treatment_progress_sequence] ,
	[encounter_id] ,
	[user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress_value] ,
	[progress] ,
	[attachment_id] ,
	[patient_workplan_item_id] ,
	[risk_level] ,
	[created] ,
	[created_by] 
FROM p_Treatment_Progress WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
and not (
progress_value IS NULL
and progress IS NULL
and attachment_id IS NULL
and progress_type not in ('created', 'closed', 'reviewed')
and progress_type NOT LIKE 'Refill%'
)
union all
SELECT 
	[cpr_id] ,
	'Observation' ,
	[observation_sequence] ,
	[Observation_comment_id] ,
	[encounter_id] ,
	[user_id] ,
	[comment_date_time] ,
	[comment_type] ,
	[comment_title] ,
	[short_comment] ,
	[comment] ,
	[attachment_id] ,
	CAST(NULL as int) ,
	CAST(NULL as int) ,
	[created] ,
	[created_by] 
FROM p_Observation_Comment WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND current_flag = 'Y'
and not (
short_comment IS NULL
and comment IS NULL
and attachment_id IS NULL
and comment_type not in ('created', 'closed', 'reviewed')
and comment_type NOT LIKE 'Refill%'
)

GO
GRANT EXECUTE
	ON [dbo].[sp_patient_object_progress_current]
	TO [cprsystem]
GO

