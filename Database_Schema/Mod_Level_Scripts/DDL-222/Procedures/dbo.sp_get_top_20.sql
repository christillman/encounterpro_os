
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_top_20]
Print 'Drop Procedure [dbo].[sp_get_top_20]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_top_20]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_top_20]
GO

-- Create Procedure [dbo].[sp_get_top_20]
Print 'Create Procedure [dbo].[sp_get_top_20]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_top_20 (
	@ps_user_id varchar(24),
	@ps_top_20_code varchar(24),
	@ps_icon_bitmap varchar(64) = NULL )
AS

IF @ps_icon_bitmap IS NULL
	SELECT @ps_icon_bitmap = domain_item_bitmap
	FROM c_Domain
	WHERE domain_id = 'TOP_20_CODE'
	AND domain_item = @ps_top_20_code

SELECT user_id,
	top_20_code,
	top_20_sequence,
	item_text,
	item_id,
	item_id2,
	item_id3,
	sort_sequence,
	@ps_icon_bitmap as icon_bitmap,
	selected_flag = 0
FROM u_Top_20 (NOLOCK)
WHERE [user_id] = COALESCE(@ps_user_id, '$')
AND top_20_code = @ps_top_20_code

GO
GRANT EXECUTE
	ON [dbo].[sp_get_top_20]
	TO [cprsystem]
GO

