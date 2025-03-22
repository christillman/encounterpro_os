
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_register_computer]
Print 'Drop Procedure [dbo].[sp_register_computer]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_register_computer]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_register_computer]
GO

-- Create Procedure [dbo].[sp_register_computer]
Print 'Create Procedure [dbo].[sp_register_computer]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_register_computer
	(
	@ps_office_id varchar(4) = NULL,
	@ps_logon_id varchar(40),
	@ps_computername varchar(40),
	@pl_computer_id int OUTPUT
	)
AS

SELECT @pl_computer_id = computer_id
FROM o_Computers
WHERE computername = @ps_computername 
AND office_id = @ps_office_id 
AND logon_id = @ps_logon_id 

IF @pl_computer_id IS NOT NULL
	RETURN

INSERT INTO o_Computers
	(
	computername,
	office_id,
	logon_id,
	status)
VALUES (
	@ps_computername,
	@ps_office_id,
	@ps_logon_id,
	'OK')

SELECT @pl_computer_id = @@IDENTITY


GO
GRANT EXECUTE
	ON [dbo].[sp_register_computer]
	TO [cprsystem]
GO

