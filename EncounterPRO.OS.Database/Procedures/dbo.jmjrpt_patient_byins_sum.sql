
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_patient_byins_sum]
Print 'Drop Procedure [dbo].[jmjrpt_patient_byins_sum]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_byins_sum]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_byins_sum]
GO

-- Create Procedure [dbo].[jmjrpt_patient_byins_sum]
Print 'Create Procedure [dbo].[jmjrpt_patient_byins_sum]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_patient_byins_sum
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Declare @Count_sum decimal(10,3)

select c_authority.name,
count(p_patient_encounter.encounter_id) As Count
from 
p_patient_encounter(NOLOCK)
JOIN p_patient  (NOLOCK) ON p_patient.cpr_id = p_patient_encounter.cpr_id
left outer join p_patient_authority WITH (NOLOCK) 
On p_patient_authority.cpr_id = p_patient.cpr_id
and p_patient_authority.authority_type = 'PAYOR'
left outer join c_authority WITH (NOLOCK)
On c_authority.authority_id = p_patient_authority.authority_id
where p_patient_encounter.encounter_status = 'CLOSED'
AND p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
Group by c_authority.name
order by c_authority.name

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_byins_sum]
	TO [cprsystem]
GO

