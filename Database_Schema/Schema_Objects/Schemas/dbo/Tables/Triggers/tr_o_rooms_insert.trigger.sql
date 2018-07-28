CREATE TRIGGER tr_o_rooms_insert ON dbo.o_rooms
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE o_Rooms
SET dirty_flag = CASE room_type WHEN '$EXAMINATION' THEN 'Y' ELSE 'N' END
WHERE dirty_flag IS NULL OR dirty_flag NOT IN ('Y', 'N')

