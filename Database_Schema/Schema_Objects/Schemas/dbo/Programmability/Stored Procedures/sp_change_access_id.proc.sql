/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 7/25/2000 8:43:35 AM ******/
/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 2/16/99 12:00:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 10/26/98 2:20:27 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 10/4/98 6:28:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 9/24/98 3:05:54 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_access_id    Script Date: 8/17/98 4:16:33 PM ******/
CREATE PROCEDURE sp_change_access_id (
	@ps_user_id varchar(24),
	@ps_access_id varchar(24),
	@pi_success smallint OUTPUT )
AS
DECLARE @li_count smallint
SELECT @li_count = count(*)
FROM c_User
WHERE access_id = @ps_access_id
AND user_id <> @ps_user_id
IF @li_count > 0
	SELECT @pi_success = 0
ELSE
	BEGIN
	UPDATE c_User
	SET access_id = @ps_access_id
	WHERE user_id = @ps_user_id
	SELECT @pi_success = 1
	END

