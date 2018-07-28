/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 7/25/2000 8:43:46 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 2/16/99 12:00:48 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 10/26/98 2:20:34 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 10/4/98 6:28:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 9/24/98 3:06:02 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_group_rooms    Script Date: 8/17/98 4:16:41 PM ******/
CREATE PROCEDURE sp_get_group_rooms (
	@pl_group_id integer )
AS
SELECT o_Rooms.room_id,
	o_Rooms.room_name,
	o_Rooms.room_sequence,
	o_Rooms.room_type,
	o_Rooms.room_status
FROM o_Group_Rooms (NOLOCK),
	o_Rooms (NOLOCK)
WHERE o_Group_Rooms.group_id = @pl_group_id
AND o_Group_Rooms.room_id = o_Rooms.room_id

