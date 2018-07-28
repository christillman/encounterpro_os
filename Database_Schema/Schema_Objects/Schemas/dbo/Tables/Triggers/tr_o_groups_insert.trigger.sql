CREATE TRIGGER tr_o_groups_insert ON dbo.o_Groups
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

INSERT INTO o_Group_Rooms (
	group_id,
	room_id )
SELECT group_id,
	'REMOTE'
FROM inserted
