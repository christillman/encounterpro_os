
-- Drop Procedure [dbo].[sp_get_open_assessments_treatments]
Print 'Drop Procedure [dbo].[sp_get_open_assessments_treatments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_open_assessments_treatments]') AND [type] = 'P'))
DROP PROCEDURE [dbo].[sp_get_open_assessments_treatments]
GO

-- Create Procedure [dbo].[sp_get_open_assessments_treatments]
Print 'Create Procedure [dbo].[sp_get_open_assessments_treatments]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_get_open_assessments_treatments] (
	@ps_cpr_id varchar(12)
	)
AS
SELECT  p_Assessment.diagnosis_sequence ,
           p_Assessment.assessment_type ,
           p_Assessment.assessment_id ,
           p_Assessment.assessment ,
           p_Assessment.begin_date ,
           p_Assessment.assessment_status ,
           p_Assessment.end_date ,
           p_Assessment.close_encounter_id ,
           p_Assessment.cpr_id ,
           p_Assessment.problem_id ,
           p_Assessment.open_encounter_id ,
           p_Assessment.diagnosed_by ,
	     p_Assessment_Treatment.treatment_id,
           c_Assessment_Type.icon_open ,
           c_Assessment_Type.icon_closed ,
           selected_flag=0,
           treatment_icon=convert(varchar(128), ''),
	   c_Assessment_Type.description as assessment_type_description
INTO #test
FROM p_Assessment      
	JOIN c_Assessment_Type ON p_Assessment.assessment_type = c_Assessment_Type.assessment_type
    LEFT OUTER JOIN p_Assessment_Treatment 
		ON p_Assessment.cpr_id = p_Assessment_Treatment.cpr_id
		AND p_Assessment.problem_id = p_Assessment_Treatment.problem_id
WHERE p_Assessment.cpr_id = @ps_cpr_id


select a.diagnosis_sequence ,
       a.assessment_type ,
       a.assessment_id ,
       a.assessment ,
       a.begin_date as assessment_begin_date,
       a.assessment_status ,
       a.end_date as assessment_end_date ,
       a.close_encounter_id as assessment_close_encounter_id,
       a.cpr_id ,
       a.problem_id ,
       a.open_encounter_id as assessment_open_encounter_id ,
       a.diagnosed_by ,
       CONVERT(int, NULL) as attachment_id ,
       a.treatment_id,
       b.open_encounter_id as treatment_open_encounter_id ,
       b.treatment_type ,
       b.treatment_description ,
       b.treatment_status ,
       b.end_date  as treatment_end_date,
       b.close_encounter_id as treatment_close_encounter_id ,
       b.begin_date as treatment_begin_date,
       a.icon_open ,
       a.icon_closed ,
       a.selected_flag,
       a.treatment_icon,
	a.assessment_type_description
FROM #test a
     LEFT OUTER JOIN p_treatment_item b 
		ON a.treatment_id = b.treatment_id
		and a.cpr_id = b.cpr_id    
ORDER BY a.assessment_type_description,a.begin_date,a.problem_id,b.begin_date,b.treatment_id asc

drop table #test

GO


GRANT EXECUTE
	ON [dbo].[sp_get_open_assessments_treatments]
	TO [cprsystem]
GO

