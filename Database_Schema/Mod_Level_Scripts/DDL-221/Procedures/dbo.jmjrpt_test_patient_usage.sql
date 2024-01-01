
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_test_patient_usage]
Print 'Drop Procedure [dbo].[jmjrpt_test_patient_usage]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_test_patient_usage]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_test_patient_usage]
GO

-- Create Procedure [dbo].[jmjrpt_test_patient_usage]
Print 'Create Procedure [dbo].[jmjrpt_test_patient_usage]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_test_patient_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10),
        @ps_observation_id varchar(24) 
AS
Declare @begin_date varchar(10), @end_date varchar(10),@observation_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT pp.last_name + ', ' + pp.first_name As Patient
,pp.billing_id AS Bill_ID
,Convert(varchar(10),i.result_expected_date,101) AS Date
FROM p_observation i WITH (NOLOCK)
JOIN p_patient pp WITH (NOLOCK) ON pp.cpr_id = i.cpr_id
WHERE observation_id = @observation_id 
AND i.result_expected_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
order by Patient,Date asc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_test_patient_usage]
	TO [cprsystem]
GO

