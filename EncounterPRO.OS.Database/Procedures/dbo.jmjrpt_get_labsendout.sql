
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_get_labsendout]
Print 'Drop Procedure [dbo].[jmjrpt_get_labsendout]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_get_labsendout]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_get_labsendout]
GO

-- Create Procedure [dbo].[jmjrpt_get_labsendout]
Print 'Create Procedure [dbo].[jmjrpt_get_labsendout]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE jmjrpt_get_labsendout
	@ps_cpr_id varchar(12),
        @pi_encounter_id Integer
AS
Declare @cprid varchar(12)
Declare @encounterid Integer

Select @cprid = @ps_cpr_id
Select @encounterid = @pi_encounter_id

CREATE TABLE #jmc_flow1 (treat_type varchar(24),treat_descrip varchar(80), assess varchar(80) NULL, icd10 varchar(12) NULL) ON [PRIMARY]
Declare @icd10 varchar(12), @assessment varchar(80)
Declare @assessment_id varchar(24)
Declare @treatment_type varchar(24),@treatment_description varchar(80) 
Declare @treatment_id Integer
Declare @item_id Integer
Declare @mycount Integer
Declare jmc_curse1 cursor LOCAL FAST_FORWARD for 
 SELECT p_Treatment_Item.treatment_id, 
        p_Treatment_Item.treatment_type, 
        p_Treatment_Item.treatment_description
        from p_Treatment_Item With (NOLOCK)
		JOIN c_Treatment_Type With (NOLOCK) ON p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type
        Where p_Treatment_Item.cpr_id = @cprid 
	AND p_Treatment_Item.open_encounter_id = @encounterid 
	AND (IsNULL(p_Treatment_Item.treatment_status,'Open') = 'Open') AND 
        ((p_Treatment_Item.treatment_mode LIKE '%Send%') OR (p_Treatment_Item.treatment_mode LIKE '%Refer%') OR 
        (p_Treatment_Item.treatment_id in (
			select p_Treatment_Progress.treatment_id 
			FROM p_Treatment_Progress with (NOLOCK)
            Where p_Treatment_Progress.cpr_id = @cprid and p_Treatment_Progress.encounter_id  = @encounterid
            AND (p_Treatment_Progress.progress_key like '%Referred%' or p_Treatment_Progress.progress_key like '%Specimen Sent%')))) 
     AND c_Treatment_Type.observation_type = 'Lab/Test' 
	 ORDER BY p_Treatment_Item.treatment_id
Declare jmc_curse2 cursor for 
 SELECT p_Treatment_Item.treatment_id, 
 	p_Treatment_Item.treatment_type, 
 	p_Treatment_Item.treatment_description 
        from p_Treatment_Item With (NOLOCK)
		JOIN c_Treatment_Type With (NOLOCK) ON p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type
 		JOIN c_workplan ON c_Treatment_Type.workplan_id = c_workplan.workplan_id 
 	Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid 
 	AND (IsNULL(p_Treatment_Item.treatment_status,'Open') = 'Open')
 	AND ((p_Treatment_Item.treatment_mode Is NULL) OR (p_Treatment_Item.treatment_mode = '')
        OR (p_Treatment_Item.treatment_id in (select p_Treatment_Progress.treatment_id FROM p_Treatment_Progress with (NOLOCK)
            Where p_Treatment_Progress.cpr_id = @cprid and p_Treatment_Progress.treatment_id = p_Treatment_Item.treatment_id
            AND (p_Treatment_Progress.progress_key like '%Referred%' or p_Treatment_Progress.progress_key like '%Specimen Sent%'))))
 	AND c_Treatment_Type.observation_type = 'Lab/Test' 
 	AND ((c_workplan.description LIKE '%Send%') OR (c_workplan.description LIKE '%Refer%')) 
 	ORDER BY p_Treatment_Item.treatment_id

SELECT @mycount =  (Select count(p_Treatment_Item.treatment_id) From p_Treatment_Item (NOLOCK), c_Treatment_Type Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND (p_Treatment_Item.treatment_status IS NULL OR p_Treatment_Item.treatment_status <> 'CANCELLED') AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test')
If @mycount > 0
 BEGIN
 open jmc_curse1
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse1
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    ORDER BY p_assessment.begin_date desc, p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd10 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd10) 
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse1
 END
Else
 SELECT @mycount = (Select count(p_Treatment_Item.treatment_id) from p_Treatment_Item (NOLOCK), c_Treatment_Type,c_workplan Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND (p_Treatment_Item.treatment_status IS NULL OR p_Treatment_Item.treatment_status <> 'CANCELLED') AND ((p_Treatment_Item.treatment_mode Is NULL) OR (p_Treatment_Item.treatment_mode = '')) AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test' AND c_Treatment_Type.workplan_id = c_workplan.workplan_id AND ((c_workplan.description LIKE '%Send%') OR (c_workplan.description LIKE '%Refer%'))) 
 BEGIN
 open jmc_curse2
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse2
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    WHERE p_assessment.assessment_status in ('','REDIAGNOSED')
                    OR p_assessment.assessment_status is NULL
		    ORDER BY p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd10 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd10)
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse2 
 END


Declare jmc_curse3 cursor LOCAL FAST_FORWARD for 
 SELECT p_Treatment_Item.treatment_id, 
        p_Treatment_Item.treatment_type, 
        p_Treatment_Item.treatment_description
        from p_Treatment_Item With (NOLOCK)
		JOIN c_Treatment_Type With (NOLOCK) ON p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type
        JOIN p_patient_wp With (NOLOCK) ON p_patient_wp.cpr_id =  p_Treatment_Item.cpr_id 
			AND p_patient_wp.encounter_id = p_Treatment_Item.open_encounter_id
			AND p_patient_wp.treatment_id = p_Treatment_Item.treatment_id
		JOIN p_patient_wp_item With (NOLOCK) ON p_patient_wp_item.cpr_id = p_patient_wp.cpr_id
			AND p_patient_wp_item.encounter_id = p_patient_wp.encounter_id
			AND p_patient_wp_item.patient_workplan_id = p_patient_wp.patient_workplan_id
        Where p_Treatment_Item.cpr_id = @cprid 
		AND p_Treatment_Item.open_encounter_id = @encounterid 
		AND (isnull(p_Treatment_Item.treatment_status,'Open') <> 'CANCELLED') 
		AND c_Treatment_Type.observation_type = 'Lab/Test'
		AND (p_patient_wp_item.ordered_service = 'REFER_TREATMENT'
			OR (p_patient_wp_item.ordered_service = 'SPECIMEN'
				AND p_patient_wp_item.description like '%Refer Out%')
				)
	ORDER BY p_Treatment_Item.treatment_id 


SELECT @mycount =  (Select count(p_Treatment_Item.treatment_id) From p_Treatment_Item (NOLOCK), c_Treatment_Type Where p_Treatment_Item.cpr_id = @cprid AND p_Treatment_Item.open_encounter_id = @encounterid AND p_Treatment_Item.treatment_type = c_Treatment_Type.treatment_type AND c_Treatment_Type.observation_type = 'Lab/Test' AND (isNull(p_Treatment_Item.treatment_status,'Open') <> 'CANCELLED'))
If @mycount > 0
 BEGIN
 open jmc_curse3
 
 WHILE @mycount > 0
 BEGIN
  FETCH NEXT FROM jmc_curse3
  into @treatment_id,@treatment_type,@treatment_description
  Select @assessment_id = (SELECT TOP 1 assessment_id FROM p_assessment
                    INNER JOIN p_assessment_treatment ON p_assessment.problem_id = p_assessment_treatment.problem_id AND (p_assessment.cpr_id = @cprid) AND (p_assessment_treatment.cpr_id = @cprid) AND (p_assessment_treatment.treatment_id = @treatment_id) 
                    ORDER BY p_assessment.begin_date desc, p_assessment.diagnosis_sequence)
  Select @assessment = (Select description from c_assessment_definition where assessment_id = @assessment_id)   
  Select @icd10 = (Select icd10_code from c_assessment_definition where assessment_id = @assessment_id)  
  Insert into #jmc_flow1
  VALUES(@treatment_type,@treatment_description,@assessment,@icd10) 
  Select @mycount = @mycount - 1
 END
 CLOSE jmc_curse3
 END

SELECT distinct treat_type AS 'Type'
      ,treat_descrip AS 'Treatment requested'
      ,assess AS 'Assessment'
      ,icd10 AS 'icd10'
FROM #jmc_flow1

DEALLOCATE jmc_curse1
DEALLOCATE jmc_curse2
DEALLOCATE jmc_curse3
DROP TABLE #jmc_flow1


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_get_labsendout]
	TO [cprsystem]
GO

