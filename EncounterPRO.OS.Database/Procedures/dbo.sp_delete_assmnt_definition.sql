
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_delete_assmnt_definition]
Print 'Drop Procedure [dbo].[sp_delete_assmnt_definition]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_delete_assmnt_definition]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_delete_assmnt_definition]
GO

-- Create Procedure [dbo].[sp_delete_assmnt_definition]
Print 'Create Procedure [dbo].[sp_delete_assmnt_definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_delete_assmnt_definition (
	@ps_assessment_id varchar(24) )
AS
UPDATE c_Assessment_Definition
SET status = 'NA'
WHERE assessment_id = @ps_assessment_id
DELETE FROM u_Top_20
WHERE item_id = @ps_assessment_id
AND top_20_code like 'ASS%'

GO
GRANT EXECUTE
	ON [dbo].[sp_delete_assmnt_definition]
	TO [cprsystem]
GO

