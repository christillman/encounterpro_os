CREATE TRIGGER tr_o_users_delete ON [dbo].[o_Users] 
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DELETE FROM o_User_Service_Lock
WHERE EXISTS (
	SELECT [user_id]
	FROM deleted d
	WHERE d.[user_id] = o_User_Service_Lock.[user_id]
	AND d.[computer_id] = o_User_Service_Lock.[computer_id] )


INSERT INTO o_User_Logins (
	[user_id] ,
	[computer_id] ,
	[office_id] ,
	[action] ,
	[scribe_for_user_id] )
SELECT [user_id] ,
	[computer_id] ,
	[office_id] ,
	'Logout' ,
	[scribe_for_user_id]
FROM deleted

