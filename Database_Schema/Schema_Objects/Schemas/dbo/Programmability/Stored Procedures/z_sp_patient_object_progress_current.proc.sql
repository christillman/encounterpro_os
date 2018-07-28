create proc [dbo].[z_sp_patient_object_progress_current] (
	@ps_cpr_id varchar(12))
AS
/*
DECLARE @progress TABLE (
	[cpr_id] [varchar] (12)  NOT NULL ,
	[context_object] [varchar] (24) NOT NULL ,
	[object_key] [int] NULL ,
	[progress_sequence] [int] NOT NULL ,
	[encounter_id] [int] NULL ,
	[user_id] [varchar] (24)  NOT NULL ,
	[progress_date_time] [datetime] NOT NULL ,
	[progress_type] [varchar] (24)  NULL ,
	[progress_key] [varchar] (48)  NULL ,
	[progress_value] [varchar] (40) NULL ,
	[progress] [text]  NULL ,
	[attachment_id] [int] NULL ,
	[patient_workplan_item_id] [int] NULL ,
	[risk_level] [int] NULL ,
	[created] [datetime] NULL ,
	[created_by] [varchar] (24)  NULL )
*/

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

/*
-- Mark
-- Workaround a bug which causes Epro to freeze on the "xxx progress" rtf command.
DELETE
FROM @progress
WHERE progress_value IS NULL
and progress IS NULL
and attachment_id IS NULL
and progress_type not in ('created', 'closed', 'reviewed')
and progress_type NOT LIKE 'Refill%'

*/
