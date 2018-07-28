CREATE TRIGGER tr_o_users_insert ON [dbo].[o_Users] 
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE u
SET scribe_for_user_id = COALESCE(i.scribe_for_user_id, i.user_id)
FROM o_Users u
	INNER JOIN inserted i
	ON u.user_id = i.user_id
	AND u.computer_id = i.computer_id

INSERT INTO o_User_Logins (
	[user_id] ,
	[computer_id] ,
	[office_id] ,
	[action],
	[scribe_for_user_id] )
SELECT [user_id] ,
	[computer_id] ,
	[office_id] ,
	'Login' ,
	COALESCE(scribe_for_user_id, [user_id])
FROM inserted

