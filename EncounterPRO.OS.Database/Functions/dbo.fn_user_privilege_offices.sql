
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_user_privilege_offices]
Print 'Drop Function [dbo].[fn_user_privilege_offices]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_privilege_offices]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_privilege_offices]
GO

-- Create Function [dbo].[fn_user_privilege_offices]
Print 'Create Function [dbo].[fn_user_privilege_offices]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_user_privilege_offices (
	@ps_user_id varchar(24),
	@ps_privilege_id varchar(24)
	)

RETURNS @offices TABLE (
	office_id varchar(4) NOT NULL,
	office_nickname varchar(24) NOT NULL)
AS

BEGIN

DECLARE @ls_secure_flag char(1),
		@ll_rowcount int,
		@ll_error int

SELECT @ls_secure_flag = secure_flag
FROM c_Privilege
WHERE privilege_id = @ps_privilege_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	RETURN

IF @ls_secure_flag = 'Y'
	BEGIN
	INSERT INTO @offices (
		office_id,
		office_nickname)
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND [user_id] = @ps_user_id
		AND privilege_id = @ps_privilege_id
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	UNION
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND [user_id] = @ps_user_id
		AND privilege_id = 'Super User'
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	END
ELSE
	BEGIN
	INSERT INTO @offices (
		office_id,
		office_nickname)
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
	WHERE o.status = 'OK'
	AND NOT EXISTS (
		SELECT 1
		FROM o_User_Privilege p
		WHERE p.office_id = o.office_id
		AND p.user_id = @ps_user_id
		AND p.privilege_id = @ps_privilege_id
		AND p.access_flag = 'R' )
	UNION
	SELECT o.office_id,
		o.office_nickname
	FROM c_Office o
		INNER JOIN o_User_Privilege p
		ON o.office_id = p.office_id
		AND [user_id] = @ps_user_id
		AND privilege_id = 'Super User'
	WHERE o.status = 'OK'
	AND p.access_flag = 'G'
	END

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_user_privilege_offices] TO [cprsystem]
GO

