DROP PROCEDURE [jmjsys_sync_codes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_codes] 
AS

SET NOCOUNT ON

DECLARE @ll_error int

EXECUTE jmjsys_sync_table @ps_tablename = 'c_XML_Class', 
						@ps_sync_type = 'New and Updated',
						@ps_overwrite_collisions = 'Y'
IF @ll_error <> 0
	RETURN -1

EXECUTE jmjsys_sync_table @ps_tablename = 'c_XML_Class_Selection', 
						@ps_sync_type = 'New and Updated',
						@ps_overwrite_collisions = 'Y'
IF @ll_error <> 0
	RETURN -1

EXECUTE jmjsys_sync_table @ps_tablename = 'c_XML_Code_Domain', 
						@ps_sync_type = 'New and Updated',
						@ps_overwrite_collisions = 'Y'
IF @ll_error <> 0
	RETURN -1

EXECUTE jmjsys_sync_table @ps_tablename = 'c_XML_Code_Domain_Item', 
						@ps_sync_type = 'New and Updated',
						@ps_overwrite_collisions = 'Y'
IF @ll_error <> 0
	RETURN -1

EXECUTE jmjsys_sync_table @ps_tablename = 'c_XML_Code', 
						@ps_sync_type = 'New Only'
IF @ll_error <> 0
	RETURN -1


RETURN 1

GO
GRANT EXECUTE ON [jmjsys_sync_codes] TO [cprsystem] AS [dbo]
GO
