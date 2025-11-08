
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Report_Definition]') AND ([type]='U')))
ALTER TABLE [dbo].[c_Report_Definition]
	DROP
	CONSTRAINT IF EXISTS [DF__c_Report_Def_created_by]
GO

-- Drop Function [dbo].[fn_current_epro_user]
Print 'Drop Function [dbo].[fn_current_epro_user]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_current_epro_user]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_current_epro_user]
GO

-- Create Function [dbo].[fn_current_epro_user]
Print 'Create Function [dbo].[fn_current_epro_user]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION dbo.fn_current_epro_user ( )

RETURNS varchar(255)

AS
BEGIN

DECLARE @ls_logged_in_user_id varchar(255)

SET @ls_logged_in_user_id = (SELECT logged_in_user_id FROM dbo.fn_current_epro_user_context())

RETURN @ls_logged_in_user_id 

END
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Report_Definition]') AND ([type]='U')))
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report_Def_created_by]
	DEFAULT ([dbo].[fn_current_epro_user]()) FOR [created_by]
GO
GRANT EXECUTE
	ON [dbo].[fn_current_epro_user]
	TO [cprsystem]
GO

