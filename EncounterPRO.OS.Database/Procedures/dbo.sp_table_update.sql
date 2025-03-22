
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_table_update]
Print 'Drop Procedure [dbo].[sp_table_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_table_update]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_table_update]
GO

-- Create Procedure [dbo].[sp_table_update]
Print 'Create Procedure [dbo].[sp_table_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_table_update (
	@ps_table_name varchar(64),
	@ps_updated_by varchar(24) = NULL )
AS

IF @ps_updated_by IS NULL 
	UPDATE c_Table_Update
	SET last_updated = dbo.get_client_datetime(),
		updated_by = original_login()
	WHERE table_name = @ps_table_name
ELSE
	UPDATE c_Table_Update
	SET last_updated = dbo.get_client_datetime(),
		updated_by = @ps_updated_by
	WHERE table_name = @ps_table_name

IF @@ROWCOUNT <> 1
	INSERT INTO c_Table_Update (
		table_name,
		last_updated,
		updated_by)
	VALUES (
		@ps_table_name,
		dbo.get_client_datetime(),
		@ps_updated_by)


GO
GRANT EXECUTE
	ON [dbo].[sp_table_update]
	TO [cprsystem]
GO

