
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_treatment_attachment_id]
Print 'Drop Procedure [dbo].[sp_get_treatment_attachment_id]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_attachment_id]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_attachment_id]
GO

-- Create Procedure [dbo].[sp_get_treatment_attachment_id]
Print 'Create Procedure [dbo].[sp_get_treatment_attachment_id]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_treatment_attachment_id (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@pl_attachment_id int OUTPUT )
AS

DECLARE @lb_default_grant bit

SELECT @pl_attachment_id = attachment_id,
	@lb_default_grant = default_grant
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @lb_default_grant IS NULL OR @pl_attachment_id <= 0 	
	SELECT @pl_attachment_id = NULL

GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_attachment_id]
	TO [cprsystem]
GO

