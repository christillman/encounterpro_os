
Print 'Drop Function dbo.fn_user_license_level'
GO
IF (EXISTS(SELECT 1
	FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.fn_user_license_level') 
	AND [type] = 'FN'))
DROP FUNCTION IF EXISTS dbo.fn_user_license_level
GO

Print 'Create Function dbo.fn_user_license_level'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION fn_user_license_level (
	@ps_user_id varchar(24) )

RETURNS int

-- Provider = 5427823
-- Extender = 183675
-- Staff = 0

AS

BEGIN

DECLARE @ll_user_license_level int,
		@ls_user_license varchar(255),
		@ls_license_flag char(1),
		@ls_user_status varchar(8),
		@ls_license_number varchar(40),
		@ls_certification_number varchar(40),
		@ls_upin varchar(24),
		@ls_email_address varchar(64),
		@ll_actor_id int,
		@lui_id uniqueidentifier,
		@ls_id varchar(36),
		@ls_checksum varchar(8)

SET @ls_user_license = dbo.fn_get_preference('LICENSE', 'User License', @ps_user_id, NULL)

SELECT @ls_license_flag = ISNULL(license_flag, 'S'),
		@ls_user_status = user_status,
		@ls_license_number = license_number,
		@ls_certification_number = certification_number,
		@ls_upin = upin,
		@ls_email_address = email_address,
		@ll_actor_id = actor_id,
		@lui_id = id
FROM c_User
WHERE user_id = @ps_user_id

SET @ls_id = CAST(@lui_id AS varchar(36))

-- Now construct the ID from @ls_user_license
SET @ls_checksum = CHAR(ASCII(SUBSTRING(@ls_id, 3, 1)) + 13)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 33, 1)) + 1)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 4, 1)) + 9)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(@ls_license_flag) - 4)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 36, 1)) + 8)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 18, 1)) + 18)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 34, 1)) + 2)
SET @ls_checksum = @ls_checksum + CHAR(ASCII(SUBSTRING(@ls_id, 35, 1)) + 22)

SET @ll_user_license_level = 0

IF @ls_checksum = @ls_user_license
	BEGIN
	IF @ls_license_flag = 'P'
		SET @ll_user_license_level = 5427823
	
	IF @ls_license_flag = 'E'
		SET @ll_user_license_level = 183675
	END

RETURN @ll_user_license_level

END


GO
GRANT EXECUTE ON [dbo].[fn_user_license_level] TO [cprsystem]
GO
