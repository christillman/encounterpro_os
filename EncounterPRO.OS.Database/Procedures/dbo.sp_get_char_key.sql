
Print 'Drop Procedure [dbo].[sp_get_char_key]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_char_key]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_char_key]
GO

Print 'Create Procedure [dbo].[sp_get_char_key]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_char_key (
	@ps_table varchar(24),
	@ps_column varchar(24),
	@ps_seed varchar(24),
	@ps_new_key varchar(24) OUTPUT )
AS

BEGIN

DECLARE @ls_new_suffix varchar(24)
DECLARE @ls_sql varchar(500)
DECLARE @suffix smallint

CREATE TABLE #tempkey (maxkey varchar(24))

SET @ls_sql = 'INSERT INTO #tempkey (maxkey) SELECT max(' + @ps_column + ') '
	+ ' FROM ' + @ps_table 
	+ ' WHERE ' + @ps_column + ' LIKE ''' + @ps_seed + '%'' '

EXECUTE (@ls_sql)

IF (SELECT ISNULL(maxkey,'X') FROM #tempkey) = 'X'
	SET @ps_new_key = @ps_seed
ELSE IF (SELECT ISNULL(maxkey,'X') FROM #tempkey) = @ps_seed
	SET @ps_new_key = @ps_seed + '01'
ELSE
	BEGIN
		SELECT @suffix = convert(smallint,substring(maxkey, len(@ps_seed) + 1, 24))
		FROM #tempkey

		SET @ps_new_key =  @ps_seed + CASE WHEN @suffix < 10 
							THEN '0' + convert(varchar(2),@suffix + 1)
							ELSE  convert(varchar(2),@suffix + 1)
							END
	END

END

GO
GRANT EXECUTE
	ON [dbo].[sp_get_char_key]
	TO [cprsystem]
GO

