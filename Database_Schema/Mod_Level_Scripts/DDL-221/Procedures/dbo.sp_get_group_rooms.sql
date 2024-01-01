
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_group_rooms]
Print 'Drop Procedure [dbo].[sp_get_group_rooms]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_group_rooms]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_group_rooms]
GO

-- Create Procedure [dbo].[sp_get_group_rooms]
Print 'Create Procedure [dbo].[sp_get_group_rooms]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 8/17/98 4:16:41 PM ******/
CREATE PROCEDURE sp_get_group_rooms (
	@pl_group_id integer )
AS
SELECT o_Rooms.room_id,
	o_Rooms.room_name,
	o_Rooms.room_sequence,
	o_Rooms.room_type,
	o_Rooms.room_status
FROM o_Group_Rooms (NOLOCK)
	JOIN o_Rooms (NOLOCK) ON o_Group_Rooms.room_id = o_Rooms.room_id
WHERE o_Group_Rooms.group_id = @pl_group_id
GO
GRANT EXECUTE
	ON [dbo].[sp_get_group_rooms]
	TO [cprsystem]
GO

