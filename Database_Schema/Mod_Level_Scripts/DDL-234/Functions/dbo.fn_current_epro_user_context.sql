
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_current_epro_user_context]
Print 'Drop Function [dbo].[fn_current_epro_user_context]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_current_epro_user_context]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_current_epro_user_context]
GO

-- Create Function [dbo].[fn_current_epro_user_context]
Print 'Create Function [dbo].[fn_current_epro_user_context]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_current_epro_user_context ( )

RETURNS @user_context TABLE (
	[computer_id] [int] NULL ,
	[logged_in_user_id] [varchar] (255) NULL ,
	[scribe_for_user_id] [varchar] (255) NULL ,
	[computername] [varchar] (40) NULL ,
	[windows_logon_id] [varchar] (255) NULL,
	[office_id] [varchar] (4) NULL )

AS

BEGIN

DECLARE @ll_computer_id int,
		@ls_system_user varchar(255),
		@ls_computername varchar(40),
		@ls_logged_in_user_id varchar(255),
		@ls_scribe_for_user_id varchar(255),
		@ls_office_id varchar(4)

SET @ls_system_user = ORIGINAL_LOGIN()
SET @ls_computername = HOST_NAME()

-- Trim off the domain if there is one
SET @ls_system_user = RIGHT(@ls_system_user, LEN(@ls_system_user) - CHARINDEX ('\', @ls_system_user) )

-- Look up the computer_id
SET @ll_computer_id = (SELECT max(computer_id) FROM o_Computers WHERE computername = @ls_computername AND logon_id = @ls_system_user)

-- Look up the [user_id] last logged in at this computer_id
SET @ls_logged_in_user_id = (SELECT TOP 1 [user_id] FROM o_Users WHERE computer_id = @ll_computer_id ORDER BY login_date desc)

-- Look up the scribe_for_user_id and office_id
SELECT @ls_scribe_for_user_id = scribe_for_user_id ,
		@ls_office_id = office_id
FROM o_Users WHERE computer_id = @ll_computer_id
AND [user_id] = @ls_logged_in_user_id

INSERT INTO @user_context (
	computer_id,
	logged_in_user_id,
	scribe_for_user_id,
	computername,
	windows_logon_id,
	office_id )
VALUES (
	@ll_computer_id,
	COALESCE(@ls_logged_in_user_id, '#Unknown'),
	COALESCE(@ls_scribe_for_user_id, '#Unknown'),
	@ls_computername,
	@ls_system_user,
	@ls_office_id )


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_current_epro_user_context] TO [cprsystem]
GO

