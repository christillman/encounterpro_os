
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_top_20_for_edit]
Print 'Drop Procedure [dbo].[sp_get_top_20_for_edit]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_top_20_for_edit]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_top_20_for_edit]
GO

-- Create Procedure [dbo].[sp_get_top_20_for_edit]
Print 'Create Procedure [dbo].[sp_get_top_20_for_edit]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 7/25/2000 8:43:55 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 2/16/99 12:00:55 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 10/26/98 2:20:41 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 10/4/98 6:28:14 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 9/24/98 3:06:07 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_top_20_for_edit    Script Date: 8/17/98 4:16:47 PM ******/
CREATE PROCEDURE sp_get_top_20_for_edit (
	@ps_user_id varchar(24),
	@ps_top_20_code varchar(24) )
AS
SELECT	user_id,
	top_20_sequence,
	item_text,
	item_id,
	item_id2,
	item_id3,
	selected_flag = 0
FROM u_Top_20 (NOLOCK)
WHERE top_20_code = @ps_top_20_code
AND (user_id = @ps_user_id OR [user_id] = '!DEFAULT')
ORDER BY user_id, top_20_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_get_top_20_for_edit]
	TO [cprsystem]
GO

