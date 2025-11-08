
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop View [dbo].[p_Observation_Comment]
Print 'Drop View [dbo].[p_Observation_Comment]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Observation_Comment]') AND [type]='V'))
DROP VIEW [dbo].[p_Observation_Comment]
GO
-- Create View [dbo].[p_Observation_Comment]
Print 'Create View [dbo].[p_Observation_Comment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[p_Observation_Comment]([cpr_id]
											  ,[observation_sequence]
											  ,[Observation_comment_id]
											  ,[observation_id]
											  ,[comment_date_time]
											  ,[comment_type]
											  ,[comment_title]
											  ,[short_comment]
											  ,[comment]
											  ,[abnormal_flag]
											  ,[severity]
											  ,[treatment_id]
											  ,[encounter_id]
											  ,[attachment_id]
											  ,[user_id]
											  ,[current_flag]
											  ,[root_observation_sequence]
											  ,[created_by]
											  ,[created]
											  ,[id])
AS
SELECT cpr_id
	  ,observation_sequence
	  ,Observation_comment_id = location_result_sequence
	  ,observation_id
	  ,comment_date_time = result_date_time
	  ,comment_type = result_type
	  ,comment_title = result
	  ,short_comment = result_value
	  ,comment = long_result_value
	  ,abnormal_flag
	  ,severity
	  ,treatment_id
	  ,encounter_id
	  ,attachment_id
	  ,user_id = observed_by
	  ,current_flag
	  ,root_observation_sequence
	  ,created_by
	  ,created
	  ,id
FROM dbo.p_Observation_Result
WHERE result_type IN ('Comment', 'Attachment')
GO
GRANT SELECT ON [dbo].[p_Observation_Comment] TO [cprsystem]
GO

