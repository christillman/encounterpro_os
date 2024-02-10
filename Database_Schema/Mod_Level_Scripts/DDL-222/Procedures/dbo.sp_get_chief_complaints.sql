
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_chief_complaints]
Print 'Drop Procedure [dbo].[sp_get_chief_complaints]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_chief_complaints]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_chief_complaints]
GO

-- Create Procedure [dbo].[sp_get_chief_complaints]
Print 'Create Procedure [dbo].[sp_get_chief_complaints]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 7/25/2000 8:43:41 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 2/16/99 12:00:45 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 10/26/98 2:20:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 10/4/98 6:28:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 9/24/98 3:05:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_chief_complaints    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_chief_complaints (
	@ps_user_id varchar(24) )
AS
IF EXISTS (SELECT * FROM u_Top_20 WHERE [user_id] = @ps_user_id AND top_20_code = 'COMPLAINT')
	SELECT	top_20_sequence,
		item_text,
		item_id,
		item_id2,
		item_id3,
		no_button = 'No',
		negative_flag = 0,
		selected_flag = 0
	FROM u_Top_20 (NOLOCK)
	WHERE [user_id] = @ps_user_id
	AND top_20_code = 'COMPLAINT'
ELSE
	SELECT	top_20_sequence,
		item_text,
		item_id,
		item_id2,
		item_id3,
		no_button = 'No',
		negative_flag = 0,
		selected_flag = 0
	FROM u_Top_20 (NOLOCK)
	WHERE [user_id] = '!DEFAULT'
	AND top_20_code = 'COMPLAINT'

GO
GRANT EXECUTE
	ON [dbo].[sp_get_chief_complaints]
	TO [cprsystem]
GO

