
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- -- Drop Trigger [dbo].[tr_o_Active_Services_all]
Print 'Drop Trigger [dbo].[tr_o_Active_Services_all]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_Active_Services_all]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_Active_Services_all]
GO

-- Create Trigger [dbo].[tr_o_Active_Services_all]
Print 'Create Trigger [dbo].[tr_o_Active_Services_all]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_Active_Services_all ON dbo.o_Active_Services
FOR INSERT, UPDATE, DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

EXECUTE sp_table_update @ps_table_name = 'o_Active_Services'

GO

