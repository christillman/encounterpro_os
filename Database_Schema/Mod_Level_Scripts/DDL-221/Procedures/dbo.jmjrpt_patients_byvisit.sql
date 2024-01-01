
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_patients_byvisit]
Print 'Drop Procedure [dbo].[jmjrpt_patients_byvisit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patients_byvisit]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patients_byvisit]
GO

-- Create Procedure [dbo].[jmjrpt_patients_byvisit]
Print 'Create Procedure [dbo].[jmjrpt_patients_byvisit]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_patients_byvisit
    @ps_begin_date varchar(10),
    @ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date

SELECT  cp.description AS Visit,
cp.cpt_code as CPT,
Convert(varchar(10),encounter_date,101) As RecordDate,
p_patient.last_name + ', ' + p_patient.first_name AS Patient
FROM 
p_patient_encounter (NOLOCK)
JOIN p_patient (NOLOCK) ON p_patient.cpr_id = p_patient_encounter.cpr_id
JOIN p_Encounter_Charge (NOLOCK) ON p_Encounter_Charge.cpr_id = p_patient_encounter.cpr_id
	AND p_Encounter_Charge.encounter_id = p_patient_encounter.encounter_id
JOIN c_procedure cp (NOLOCK) ON cp.procedure_id = p_Encounter_Charge.procedure_id
WHERE p_patient_encounter.encounter_status = 'CLOSED'
AND p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND p_Encounter_Charge.bill_flag = 'Y' 
AND cp.procedure_category_id = 'VISIT' 
order by Visit asc,recorddate asc,patient asc 

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patients_byvisit]
	TO [cprsystem]
GO

