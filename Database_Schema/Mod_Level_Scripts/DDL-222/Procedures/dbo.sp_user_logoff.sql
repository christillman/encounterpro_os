
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_user_logoff]
Print 'Drop Procedure [dbo].[sp_user_logoff]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_user_logoff]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_user_logoff]
GO

-- Create Procedure [dbo].[sp_user_logoff]
Print 'Create Procedure [dbo].[sp_user_logoff]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_user_logoff (
	@ps_user_id varchar(24),
	@pl_computer_id int = NULL )
AS

IF @pl_computer_id IS NULL
	BEGIN
	DELETE FROM o_User_Service_Lock
	WHERE [user_id] = @ps_user_id

	DELETE FROM o_Users
	WHERE [user_id] = @ps_user_id
	END
ELSE
	BEGIN
	DELETE FROM o_User_Service_Lock
	WHERE [user_id] = @ps_user_id
	AND computer_id = @pl_computer_id

	DELETE FROM o_Users
	WHERE [user_id] = @ps_user_id
	AND computer_id = @pl_computer_id
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_user_logoff]
	TO [cprsystem]
GO

