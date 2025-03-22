
CREATE PROCEDURE jmj_set_user_checksum 
	(
	@ps_user_id varchar(24) ,
	@ps_auth varchar(24) = NULL
	)

AS

EXECUTE jmj_set_checksum
	@ps_user_id = @ps_user_id,
	@ps_module = 'User License',
	@ps_auth = @ps_auth
