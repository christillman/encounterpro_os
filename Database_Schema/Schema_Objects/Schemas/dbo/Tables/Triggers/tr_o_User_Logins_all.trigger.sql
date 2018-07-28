CREATE TRIGGER tr_o_User_Logins_all ON dbo.o_User_Logins
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE l
SET session_id = x.session_id
FROM o_User_Logins l
	INNER JOIN (SELECT l1.user_id,
						l1.action_id,
						max(l2.action_id) as session_id
				FROM inserted l1
					INNER JOIN o_User_Logins l2
					ON l2.user_id = l1.user_id
					AND l2.computer_id = l1.computer_id
					AND l2.action = 'Login'
					AND l2.action_id <= l1.action_id
				GROUP BY l1.user_id, l1.action_id ) x
	ON l.user_id = x.user_id
	AND l.action_id = x.action_id
WHERE l.session_id IS NULL


UPDATE l
SET session_start_time = l2.action_time
FROM o_User_Logins l
	INNER JOIN inserted i
	ON i.user_id = l.user_id
	AND i.action_id = l.action_id
	INNER JOIN o_User_Logins l2
	ON l.user_id = l2.user_id
	AND l.session_id = l2.action_id
