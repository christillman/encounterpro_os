CREATE PROCEDURE sp_get_rooms_in_type (
	@ps_room_type varchar(24) )
AS
SELECT room_id,
	room_name
FROM o_Rooms WITH (NOLOCK)
WHERE room_type = @ps_room_type

