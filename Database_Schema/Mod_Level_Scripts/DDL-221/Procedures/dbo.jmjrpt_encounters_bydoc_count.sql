
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_encounters_bydoc_count]
Print 'Drop Procedure [dbo].[jmjrpt_encounters_bydoc_count]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_encounters_bydoc_count]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_encounters_bydoc_count]
GO

-- Create Procedure [dbo].[jmjrpt_encounters_bydoc_count]
Print 'Create Procedure [dbo].[jmjrpt_encounters_bydoc_count]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE jmjrpt_encounters_bydoc_count @ps_begin_date varchar(10),@ps_end_date varchar(10)     
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)

Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date

SELECT	c_user.user_full_name As Provider, 
        Count(pe.encounter_id) As Encounters
	FROM p_Patient_Encounter pe (NOLOCK)
        JOIN c_user (NOLOCK) ON c_user.user_id = pe.attending_doctor
	WHERE
	c_user.user_id IN (SELECT user_id FROM c_user_role WHERE role_id='!PHYSICIAN')  
	AND bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND pe.encounter_date >= @begin_date 
	AND pe.encounter_date < DATEADD(day, 1, @end_date)
    group by c_user.user_full_name

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_encounters_bydoc_count]
	TO [cprsystem]
GO

