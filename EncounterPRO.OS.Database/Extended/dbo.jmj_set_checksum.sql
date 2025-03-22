

CREATE PROCEDURE jmj_set_checksum 
	(
	@ps_user_id varchar(24) ,
	@ps_module varchar(40) ,
	@ps_auth varchar(24) = NULL
	)

AS

DECLARE @ls_checksum varchar(8)

IF @ps_auth IS NULL
	BEGIN
	EXEC sp_set_preference 'LICENSE', 'User', @ps_user_id, @ps_module, @ps_user_id
	RETURN
	END

SET @ls_checksum = dbo.fn_user_checksum(@ps_user_id, @ps_auth)

IF @ls_checksum IS NOT NULL
	EXEC sp_set_preference 'LICENSE', 'User', @ps_user_id, @ps_module, @ls_checksum

