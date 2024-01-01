
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_PatientActivity_bydate]
Print 'Drop Procedure [dbo].[jmjrpt_PatientActivity_bydate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_PatientActivity_bydate]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_PatientActivity_bydate]
GO

-- Create Procedure [dbo].[jmjrpt_PatientActivity_bydate]
Print 'Create Procedure [dbo].[jmjrpt_PatientActivity_bydate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_PatientActivity_bydate @ps_cpr_id varchar(12), @ps_encounter_date varchar(10)
AS
Declare @ls_cpr_id varchar(12)
Declare @encounterdate varchar(10)
Select @ls_cpr_id = @ps_cpr_id
Select @encounterdate = @ps_encounter_date
SELECT	cu.user_full_name AS User_Name,
	cr.description AS Role,
        pi.description AS Service,
        Count(pi.description) As Count,
        SUM(DateDiff(minute,pi.begin_date,pi.end_date)) As Minutes
    FROM p_Patient_WP_ITEM pi (NOLOCK)
	JOIN c_user cu (NOLOCK) ON cu.user_id = pi.completed_by
    JOIN c_user_role cur (NOLOCK) ON cu.user_id = cur.user_id
    JOIN c_role cr (NOLOCK) ON cur.role_id = cr.role_id
	WHERE DateDiff(day,pi.begin_date,@encounterdate) = 0
		AND pi.cpr_id = @ls_cpr_id
    group by cu.user_full_name,cr.description,pi.description,pi.begin_date
    order by pi.begin_date asc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_PatientActivity_bydate]
	TO [cprsystem]
GO

