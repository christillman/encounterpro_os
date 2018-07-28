CREATE PROCEDURE jmj_new_room (
	@ps_room_type varchar(12) ,
	@ps_room_name varchar(24) ,
	@ps_office_id varchar(4) ,
	@ps_room_id varchar(12) OUTPUT )
AS
DECLARE @ll_room_id int,
		@ls_room_id varchar(12),
		@ll_room_sequence int

SELECT @ll_room_id = count(*)
FROM o_Rooms

IF @ll_room_id iS NULL
	SET @ll_room_id = 1
ELSE
	SET @ll_room_id = @ll_room_id + 1 


WHILE 1 = 1
	BEGIN
	SET @ls_room_id = RIGHT('000000' + CAST(@ll_room_id AS varchar(8)), 6)

	IF NOT EXISTS(SELECT 1 FROM o_Rooms WHERE room_id = @ls_room_id)
		BREAK
	
	SET @ll_room_id = @ll_room_id + 1
	END

SELECT @ll_room_sequence = max(room_sequence)
FROM o_Rooms
WHERE room_type = @ps_room_type

IF @ll_room_sequence iS NULL
	SET @ll_room_sequence = 1
ELSE
	SET @ll_room_sequence = @ll_room_sequence + 1 

INSERT INTO o_Rooms (
	room_id,
	office_id,
	room_name,
	room_type,
	status,
	room_sequence)
VALUES (
	@ls_room_id,
	@ps_office_id,
	@ps_room_name,
	@ps_room_type,
	'OK',
	@ll_room_sequence)

IF @@ERROR <> 0
	RETURN

SET @ps_room_id = @ls_room_id

