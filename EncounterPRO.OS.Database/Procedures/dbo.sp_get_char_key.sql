
Print 'Drop Procedure [dbo].[sp_get_char_key]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_char_key]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_char_key]
GO

Print 'Create Procedure [dbo].[sp_get_char_key]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_char_key (
	@ps_table varchar(24),
	@ps_column varchar(24),
	@ps_seed varchar(24) )
AS

BEGIN

DECLARE @ll_last_key int
DECLARE @ls_sql varchar(500)
DECLARE @suffix smallint

CREATE TABLE #tempkey (maxkey varchar(24))

SET @ls_sql = 'INSERT INTO #tempkey (maxkey) SELECT max(' + @ps_column + ') '
	+ ' FROM ' + @ps_table 
	+ ' WHERE ' + @ps_column + ' LIKE ''' + @ps_seed + '%'' '

EXECUTE (@ls_sql)

IF (SELECT count(*) FROM #tempkey) = 0 
	SELECT @ps_seed
ELSE IF (SELECT maxkey FROM #tempkey) = @ps_seed
	SELECT @ps_seed + '01'
ELSE
	BEGIN
		SELECT @suffix = convert(smallint,substring(maxkey, len(@ps_seed) + 1, 24))
		FROM #tempkey

		SELECT @ps_seed + CASE WHEN @suffix < 10 THEN '0' + convert(varchar(2),@suffix + 1)
			ELSE  convert(varchar(2),@suffix + 1) END
	END
END

GO
GRANT EXECUTE
	ON [dbo].[sp_get_char_key]
	TO [cprsystem]
GO

-- EXEC sp_get_char_key 'c_Authority', 'authority_id', 'Guardian'