
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjrpt_drug_allergy]
Print 'Drop Procedure [dbo].[jmjrpt_drug_allergy]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_drug_allergy]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_drug_allergy]
GO

-- Create Procedure [dbo].[jmjrpt_drug_allergy]
Print 'Create Procedure [dbo].[jmjrpt_drug_allergy]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE jmjrpt_drug_allergy
	@ps_drug_allergy varchar(24)
     
AS
Declare @drug_allergy varchar(24)
select @drug_allergy = @ps_drug_allergy

If @drug_allergy = '%drug_allergy%'
begin
	select ca.description, cd.generic_name,cd.common_name
	from c_allergy_drug with (nolock)
	JOIN c_assessment_definition ca with (nolock) ON c_allergy_drug.assessment_id = ca.assessment_id
	JOIN c_drug_definition cd with (nolock) ON c_allergy_drug.drug_id = cd.drug_id
	order by ca.description, cd.generic_name
end
else
begin
	select ca.description, cd.generic_name,cd.common_name
	from c_allergy_drug with (nolock)
	JOIN c_assessment_definition ca with (nolock) ON c_allergy_drug.assessment_id = ca.assessment_id
	JOIN c_drug_definition cd with (nolock) ON c_allergy_drug.drug_id = cd.drug_id
	where c_allergy_drug.assessment_id = @drug_allergy
	order by ca.description, cd.generic_name
end

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_drug_allergy]
	TO [cprsystem]
GO

