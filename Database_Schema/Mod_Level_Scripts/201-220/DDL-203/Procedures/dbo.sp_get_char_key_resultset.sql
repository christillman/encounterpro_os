
Print 'Drop Procedure [dbo].[sp_get_char_key_resultset]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_char_key_resultset]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_char_key_resultset]
GO

Print 'Create Procedure [dbo].[sp_get_char_key_resultset]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_char_key_resultset (
	@ps_table varchar(24),
	@ps_column varchar(24),
	@ps_seed varchar(24) )
AS

BEGIN

DECLARE @ls_new_suffix varchar(24)
DECLARE @ls_new_key varchar(24)
DECLARE @ls_sql varchar(500)
DECLARE @suffix smallint

CREATE TABLE #tempkey (maxkey varchar(24))

SET @ls_sql = 'INSERT INTO #tempkey (maxkey) SELECT max(' + @ps_column + ') '
	+ ' FROM ' + @ps_table 
	+ ' WHERE ' + @ps_column + ' LIKE ''' + @ps_seed + '%'' '

EXECUTE (@ls_sql)

IF (SELECT ISNULL(maxkey,'X') FROM #tempkey) = 'X'
	SET @ls_new_key = @ps_seed
ELSE IF (SELECT ISNULL(maxkey,'X') FROM #tempkey) = @ps_seed
	SET @ls_new_key = @ps_seed + '01'
ELSE
	BEGIN
		SELECT @suffix = convert(smallint,substring(maxkey, len(@ps_seed) + 1, 24))
		FROM #tempkey

		SET @ls_new_key =  @ps_seed + CASE WHEN @suffix < 10 
							THEN '0' + convert(varchar(2),@suffix + 1)
							ELSE  convert(varchar(2),@suffix + 1)
							END
	END

SELECT @ls_new_key AS new_key FROM c_1_record
END

GO
GRANT EXECUTE
	ON [dbo].[sp_get_char_key_resultset]
	TO [cprsystem]
GO
