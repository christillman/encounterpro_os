
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_top_20_delete]
Print 'Drop Procedure [dbo].[sp_top_20_delete]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_top_20_delete]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_top_20_delete]
GO

-- Create Procedure [dbo].[sp_top_20_delete]
Print 'Create Procedure [dbo].[sp_top_20_delete]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_top_20_delete (
	@ps_top_20_user_id varchar(24),
	@ps_top_20_code varchar(64) ,
	@pl_top_20_sequence int )
AS

DELETE u_Top_20
WHERE [user_id] = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code
AND top_20_sequence = @pl_top_20_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_top_20_delete]
	TO [cprsystem]
GO

