
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_drop_triggers]
Print 'Drop Procedure [dbo].[sp_drop_triggers]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_drop_triggers]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_drop_triggers]
GO

-- Create Procedure [dbo].[sp_drop_triggers]
Print 'Create Procedure [dbo].[sp_drop_triggers]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_drop_triggers (
	@ps_table varchar(64) )
AS

DECLARE @Trigger sysname
DECLARE lc_triggers CURSOR FOR
	select o.name COLLATE DATABASE_DEFAULT
	from sysobjects o WITH (NOLOCK) 
		JOIN sysobjects d WITH (NOLOCK) ON o.deltrig = d.id
	where o.type = 'TR'
	and d.type = 'U'
	and d.name COLLATE DATABASE_DEFAULT = @ps_table
OPEN lc_triggers
FETCH NEXT FROM lc_triggers INTO @Trigger
WHILE (@@fetch_status = 0)
BEGIN
	IF EXISTS (	SELECT *
			FROM sysobjects WITH (NOLOCK)
			WHERE id = object_id(@Trigger)
			AND sysstat & 0xf = 8
			)
	BEGIN
		EXEC ('DROP TRIGGER ' + @Trigger)
	END
	FETCH NEXT FROM lc_triggers INTO @Trigger
END
DEALLOCATE lc_triggers


GO
GRANT EXECUTE
	ON [dbo].[sp_drop_triggers]
	TO [cprsystem]
GO

