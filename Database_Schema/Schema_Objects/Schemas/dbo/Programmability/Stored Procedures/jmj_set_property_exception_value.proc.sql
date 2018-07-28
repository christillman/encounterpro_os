CREATE PROCEDURE [dbo].[jmj_set_property_exception_value] (
	@pl_spid int,
	@ps_datatype varchar(12),
	@ps_select varchar(4000) )
AS

DECLARE @ll_error int,
		@ll_rowcount int,
		@ls_sql varchar(4000)

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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1


RETURN 1

