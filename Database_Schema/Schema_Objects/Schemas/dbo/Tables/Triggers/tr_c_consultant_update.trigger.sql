CREATE TRIGGER tr_c_consultant_update ON dbo.c_Consultant
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(description)
	UPDATE u
	SET user_full_name = CAST(i.description AS varchar(64))
	FROM c_User u
		INNER JOIN inserted i
		ON u.user_id = i.consultant_id


IF UPDATE(first_name) OR UPDATE(last_name)
	UPDATE u
	SET user_short_name = CAST(CASE WHEN i.first_name IS NULL THEN '' ELSE LEFT(i.first_name, 1) + '. ' END + i.last_name AS varchar(12))
	FROM c_User u
		INNER JOIN inserted i
		ON u.user_id = i.consultant_id


