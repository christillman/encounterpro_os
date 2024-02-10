
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_top_20_sort_update]
Print 'Drop Procedure [dbo].[sp_top_20_sort_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_top_20_sort_update]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_top_20_sort_update]
GO

-- Create Procedure [dbo].[sp_top_20_sort_update]
Print 'Create Procedure [dbo].[sp_top_20_sort_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_top_20_sort_update (
	@ps_top_20_user_id varchar(24),
	@ps_top_20_code varchar(64) ,
	@pl_top_20_sequence int ,
	@pl_new_sort_sequence int)
AS

UPDATE u_Top_20
SET sort_sequence = @pl_new_sort_sequence
WHERE [user_id] = @ps_top_20_user_id
AND top_20_code = @ps_top_20_code
AND top_20_sequence = @pl_top_20_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_top_20_sort_update]
	TO [cprsystem]
GO

