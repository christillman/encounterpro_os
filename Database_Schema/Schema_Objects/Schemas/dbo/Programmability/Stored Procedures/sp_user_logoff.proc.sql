CREATE PROCEDURE sp_user_logoff (
	@ps_user_id varchar(24),
	@pl_computer_id int = NULL )
AS

IF @pl_computer_id IS NULL
	BEGIN
	DELETE FROM o_User_Service_Lock
	WHERE user_id = @ps_user_id

	DELETE FROM o_Users
	WHERE user_id = @ps_user_id
	END
ELSE
	BEGIN
	DELETE FROM o_User_Service_Lock
	WHERE user_id = @ps_user_id
	AND computer_id = @pl_computer_id

	DELETE FROM o_Users
	WHERE user_id = @ps_user_id
	AND computer_id = @pl_computer_id
	END

