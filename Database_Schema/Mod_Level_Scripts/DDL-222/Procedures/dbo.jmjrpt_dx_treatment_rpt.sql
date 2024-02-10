
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_dx_treatment_rpt]
Print 'Drop Procedure [dbo].[jmjrpt_dx_treatment_rpt]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_dx_treatment_rpt]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_dx_treatment_rpt]
GO

-- Create Procedure [dbo].[jmjrpt_dx_treatment_rpt]
Print 'Create Procedure [dbo].[jmjrpt_dx_treatment_rpt]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_dx_treatment_rpt
	@ps_assessment_id varchar(24)
        ,@ps_speciality varchar(24)
AS
Declare @assessment_id varchar(24)
Declare @speciality_id varchar(24)
Select @assessment_id = @ps_assessment_id
Select @speciality_id = @ps_speciality

SELECT u.treatment_type as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and [user_id] = @speciality_id
and (parent_definition_id is NULL or parent_definition_id = '')
and u.treatment_type != '!COMPOSITE'
union
SELECT '!-' + cast(u.definition_id AS varchar) as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and [user_id] = @speciality_id
and (parent_definition_id is NULL or parent_definition_id = '')
and u.treatment_type = '!COMPOSITE'
union
SELECT '!-' + cast(u.parent_definition_id AS varchar) + '-' + u.treatment_type as sort_type
       ,u.treatment_description
FROM   u_assessment_treat_definition u WITH (NOLOCK)
inner join c_assessment_definition ac WITH (NOLOCK)
on u.assessment_id = ac.assessment_id
WHERE u.assessment_id = @assessment_id
and [user_id] = @speciality_id
and u.parent_definition_id in 
(select ue.definition_id 
FROM   u_assessment_treat_definition ue WITH (NOLOCK) 
Where [user_id] = '$PEDS')
order by sort_type


GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_dx_treatment_rpt]
	TO [cprsystem]
GO

