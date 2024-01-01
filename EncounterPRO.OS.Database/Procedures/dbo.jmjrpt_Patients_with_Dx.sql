
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_Patients_with_Dx]
Print 'Drop Procedure [dbo].[jmjrpt_Patients_with_Dx]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_Patients_with_Dx]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_Patients_with_Dx]
GO

-- Create Procedure [dbo].[jmjrpt_Patients_with_Dx]
Print 'Create Procedure [dbo].[jmjrpt_Patients_with_Dx]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_Patients_with_Dx
        @ps_assessment_id varchar(24)   
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @assessment_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @assessment_id = @ps_assessment_id
SELECT distinct 
p_Patient.billing_id As Bill_Id,
p_Patient.last_name + ',' +p_Patient.first_name AS Patient,
IsNULL(c_user.user_short_name,'') as Diagnosed_by, 
convert(varchar(10),p_Assessment.begin_date,101) AS Begin_Dx,
convert(varchar(10),p_Assessment.end_date,101) AS End_Dx,
IsNULL(p_Assessment.assessment_status,'Open') as Status
FROM
p_Assessment(NOLOCK)
JOIN p_Patient(NOLOCK) ON p_Patient.cpr_id = p_Assessment.cpr_id
JOIN p_Patient_Encounter(NOLOCK) ON p_Assessment.cpr_id = p_patient_encounter.cpr_id 
	AND p_Assessment.open_encounter_id = p_patient_encounter.encounter_id
JOIN c_user(NOLOCK) ON c_user.user_id = p_Assessment.diagnosed_by
WHERE Isnull(p_Assessment.assessment_status,'Open') <> 'CANCELLED'
AND p_Assessment.assessment_id = @assessment_id 
AND p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD(day,1,@end_date)
ORDER BY
Bill_Id,Patient,Begin_Dx,End_Dx,Status,Diagnosed_by

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_Patients_with_Dx]
	TO [cprsystem]
GO

