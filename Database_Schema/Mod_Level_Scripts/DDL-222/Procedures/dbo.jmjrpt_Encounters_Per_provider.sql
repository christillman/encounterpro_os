
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_Encounters_Per_provider]
Print 'Drop Procedure [dbo].[jmjrpt_Encounters_Per_provider]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_Encounters_Per_provider]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_Encounters_Per_provider]
GO

-- Create Procedure [dbo].[jmjrpt_Encounters_Per_provider]
Print 'Create Procedure [dbo].[jmjrpt_Encounters_Per_provider]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE jmjrpt_Encounters_Per_provider
         @ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
        ,@ps_role_id varchar(24)     
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @role_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @role_id = @ps_role_id
SELECT convert(varchar(10),p_patient_encounter.encounter_date,101) AS Visit_Date
       ,c_Office.description As Office
       ,c_user.user_full_name As Provider 
       ,p_patient.first_name + ', ' + p_patient.last_name AS Name
       ,c_encounter_type.description As Type
       ,p_patient_encounter.encounter_description as chief_complaint
FROM
p_patient_encounter(NOLOCK)
inner join p_patient with (NOLOCK)
ON p_patient_encounter.cpr_id = p_patient.cpr_id
inner join c_encounter_type with (NOLOCK)
ON p_patient_encounter.encounter_type = c_encounter_type.encounter_type
inner join c_Office with (NOLOCK)
ON p_patient_encounter.office_id = c_Office.office_id
inner join c_user with (NOLOCK)
ON p_patient_encounter.attending_doctor = c_user.user_id
AND
c_user.user_id IN (SELECT [user_id] FROM c_user_role WHERE role_id = @role_id)
WHERE
p_patient_encounter.indirect_flag = 'D' AND
p_patient_encounter.encounter_date >= @begin_date AND
p_patient_encounter.encounter_date < DATEADD(day, 1, @end_date)
ORDER BY
Visit_Date ASC,c_Office.office_id,Name,Provider

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_Encounters_Per_provider]
	TO [cprsystem]
GO

