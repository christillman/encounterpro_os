﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_patients_byvisit_avg]
Print 'Drop Procedure [dbo].[jmjrpt_patients_byvisit_avg]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patients_byvisit_avg]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patients_byvisit_avg]
GO

-- Create Procedure [dbo].[jmjrpt_patients_byvisit_avg]
Print 'Create Procedure [dbo].[jmjrpt_patients_byvisit_avg]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_patients_byvisit_avg
    @ps_begin_date varchar(10),
    @ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date
Declare @Count_sum decimal(10,3)
Select @Count_sum = (Select count(encounter_id) 
FROM p_patient_encounter pe WITH (NOLOCK)
WHERE pe.encounter_status = 'CLOSED'
AND pe.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date))

SELECT  cp.description AS Visit,
cp.cpt_code as CPT,
Round(((count(p_patient_encounter.encounter_id) / @Count_sum ) *100.00),3) As Percentage
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
group by cp.description,cp.cpt_code 
order by Visit asc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patients_byvisit_avg]
	TO [cprsystem]
GO

