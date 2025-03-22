
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_next_box_item]
Print 'Drop Procedure [dbo].[sp_get_next_box_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_next_box_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_next_box_item]
GO

-- Create Procedure [dbo].[sp_get_next_box_item]
Print 'Create Procedure [dbo].[sp_get_next_box_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_next_box_item (
	@pl_box_id integer,
	@pl_next_box_item integer OUTPUT )
AS

UPDATE o_Box
SET last_item = last_item + 1
WHERE box_id = @pl_box_id

IF @@ROWCOUNT = 0
	SELECT @pl_next_box_item = 0
ELSE
	SELECT @pl_next_box_item = last_item
	FROM o_Box
	WHERE box_id = @pl_box_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_next_box_item]
	TO [cprsystem]
GO

