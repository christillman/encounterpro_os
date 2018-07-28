CREATE TRIGGER tr_o_computers_update ON dbo.o_Computers
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(last_spid)
	BEGIN
	DELETE u
	FROM o_Users u
		INNER JOIN inserted i
		ON u.spid = i.last_spid
	WHERE u.computer_id <> i.computer_id
	END

