
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_drug_categories]
Print 'Drop Procedure [dbo].[sp_get_drug_categories]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_drug_categories]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_drug_categories]
GO

-- Create Procedure [dbo].[sp_get_drug_categories]
Print 'Create Procedure [dbo].[sp_get_drug_categories]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_drug_categories    Script Date: 8/17/98 4:16:39 PM ******/
CREATE PROCEDURE sp_get_drug_categories (
	@ps_drug_id varchar(24) )
AS
SELECT	c_Drug_Category.drug_category_id,
	c_Drug_Category.description
FROM	c_Drug_Category
	JOIN c_Drug_Drug_Category ON c_Drug_Category.drug_category_id = c_Drug_Drug_Category.drug_category_id
WHERE c_Drug_Drug_Category.drug_id = @ps_drug_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_drug_categories]
	TO [cprsystem]
GO

