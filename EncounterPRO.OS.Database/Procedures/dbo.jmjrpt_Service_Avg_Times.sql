
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_Service_Avg_Times]
Print 'Drop Procedure [dbo].[jmjrpt_Service_Avg_Times]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_Service_Avg_Times]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_Service_Avg_Times]
GO

-- Create Procedure [dbo].[jmjrpt_Service_Avg_Times]
Print 'Create Procedure [dbo].[jmjrpt_Service_Avg_Times]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE jmjrpt_Service_Avg_Times
        @ps_SERVICE varchar(24)   
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @SERVICE varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @SERVICE = @ps_SERVICE

SELECT c_User.user_short_name as Provider
,o_Service.description as service_description
,Avg(datediff(minute,p_Patient_WP_Item.begin_date,p_Patient_WP_Item.end_date)) AS Avg_Minutes
FROM
p_Patient_WP_Item (NOLOCK) 
JOIN p_Patient_Encounter (NOLOCK) ON p_Patient_Encounter.cpr_id = p_Patient_WP_Item.cpr_id
	AND p_Patient_Encounter.encounter_id = p_Patient_WP_Item.encounter_id
JOIN c_Encounter_Type (NOLOCK) ON c_Encounter_Type.encounter_type = p_Patient_Encounter.encounter_type
JOIN c_User (NOLOCK) ON c_User.user_id = p_Patient_WP_Item.owned_by 
JOIN p_Patient (NOLOCK) ON p_Patient.cpr_id = p_Patient_WP_Item.cpr_id
JOIN o_Service (NOLOCK) ON o_Service.service = p_Patient_WP_Item.ordered_service
WHERE
p_Patient_WP_Item.ordered_service LIKE @SERVICE AND
p_Patient_WP_Item.item_type = 'Service' AND
p_Patient_WP_Item.Status = 'COMPLETED' AND
p_Patient_Encounter.encounter_date >= @begin_date AND
p_Patient_Encounter.encounter_date < DATEADD(day, 1, @end_date)
Group by c_User.user_short_name,o_Service.description
Order by Provider asc

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_Service_Avg_Times]
	TO [cprsystem]
GO

