
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_set_property_exception_value]
Print 'Drop Procedure [dbo].[jmj_set_property_exception_value]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_property_exception_value]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_property_exception_value]
GO

-- Create Procedure [dbo].[jmj_set_property_exception_value]
Print 'Create Procedure [dbo].[jmj_set_property_exception_value]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[jmj_set_property_exception_value] (
	@pl_spid int,
	@ps_datatype varchar(12),
	@ps_select nvarchar(max) )
AS

DECLARE @ls_sql nvarchar(max)

-- Make sure there is a record in the X table
IF NOT EXISTS (SELECT 1 FROM x_Property_Exception WHERE spid = @pl_spid)
	INSERT INTO x_Property_Exception (
		spid)
	VALUES (
		@pl_spid)

UPDATE x SET property_value_binary = a.binarydata
FROM x_Property_Exception x  
	CROSS JOIN (SELECT binarydata = signature_stamp FROM c_User a  WHERE (a.user_id = 'CONFIGPEDSD')) a
WHERE x.spid = 60

SET @ls_sql = 'UPDATE x SET property_value_' + @ps_datatype + ' = v.value'
SET @ls_sql = @ls_sql + ' FROM x_Property_Exception x '
SET @ls_sql = @ls_sql + '       CROSS JOIN (' + @ps_select + ') v'
SET @ls_sql = @ls_sql + ' WHERE x.spid = ' + CAST(@pl_spid AS varchar(12))

EXECUTE (@ls_sql)

IF @@ERROR <> 0
	RETURN -1


RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_set_property_exception_value]
	TO [cprsystem]
GO

