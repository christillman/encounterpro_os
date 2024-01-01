SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_patient_waits_exam]
Print 'Drop Procedure [dbo].[jmjrpt_patient_waits_exam]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_waits_exam]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_waits_exam]
GO

-- Create Procedure [dbo].[jmjrpt_patient_waits_exam]
Print 'Create Procedure [dbo].[jmjrpt_patient_waits_exam]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_patient_waits_exam
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date

--CALCULATE PHYSICIAN TIME IN EXAM ROOM
SELECT uof.description As Office
	,CAST(AVG(DATEDIFF(minute, wp.begin_date, wp.end_date))AS VARCHAR) + ' minute(s) average exam time.'
FROM p_patient_WP_item wp WITH (NOLOCK)
	JOIN p_Patient_Encounter i WITH (NOLOCK) ON i.cpr_id = wp.cpr_id
		AND i.encounter_id = wp.encounter_id 
	JOIN c_office uof  WITH (NOLOCK) ON uof.office_id = i.office_id
WHERE i.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND i.indirect_flag='D'
AND wp.ordered_service='EXAM'
AND wp.status='COMPLETED'
Group by uof.description
Order by office asc
GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_waits_exam]
	TO [cprsystem]
GO

