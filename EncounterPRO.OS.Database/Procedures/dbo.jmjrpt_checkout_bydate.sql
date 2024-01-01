
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_checkout_bydate]
Print 'Drop Procedure [dbo].[jmjrpt_checkout_bydate]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_checkout_bydate]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_checkout_bydate]
GO

-- Create Procedure [dbo].[jmjrpt_checkout_bydate]
Print 'Create Procedure [dbo].[jmjrpt_checkout_bydate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_checkout_bydate @ps_discharge_date varchar(10)
AS
Declare @dischargedate varchar(10)
Select @dischargedate = @ps_discharge_date
SELECT   co.description As Location,
       	 (p.last_name + ',' + p.first_name) As Patient,
         p.billing_id As Bill_ID,
	     user_short_name AS Provider,
         pe.billing_posted AS Post,
         pe.bill_flag As Bill,
         ce.description         
FROM p_Patient_Encounter pe (NOLOCK)
	 JOIN p_patient p (NOLOCK) ON p.cpr_id = pe.cpr_id
     JOIN c_office co (NOLOCK) ON co.office_id = pe.office_id
	 JOIN c_encounter_type ce (NOLOCK) ON ce.encounter_type = pe.encounter_type 
     JOIN c_User (NOLOCK) ON pe.attending_doctor = c_User.user_id 
  	WHERE 
	encounter_status = 'CLOSED'
	AND pe.discharge_date BETWEEN @dischargedate AND DATEADD( day, 1, @dischargedate)
    order by pe.office_id,pe.attending_doctor,pe.encounter_type

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_checkout_bydate]
	TO [cprsystem]
GO

