DROP PROCEDURE IF EXISTS [sp_last_child_select]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [sp_last_child_select] (
	@child varchar(500),
	@parent varchar(500),
	@skip_parent bit,
	@grandparent varchar(500),
	@skip_grandparent bit
	)
AS
BEGIN

-- Suppress the annoying repeated encounter type used in an assessment description

DECLARE @sql nvarchar(max)
DECLARE @covered_term varchar(500)
DECLARE @child_term varchar(500)
DECLARE @parent_term varchar(500)
DECLARE @skip_parent_term bit
DECLARE @grandparent_term varchar(500)
DECLARE @skip_grandparent_term bit
DECLARE @excluding varchar(90)
DECLARE @found integer
DECLARE @lvl integer

SELECT coalesce(long_description,description) as descr
INTO #descr
FROM c_Assessment_Definition
WHERE icd10_code is not null 
AND coalesce(long_description,description) LIKE '%' + replace(replace(@child,'[','\['),']','\]') + '%' ESCAPE '\' 
AND coalesce(long_description,description) LIKE '%' + CASE WHEN @skip_parent = 1 OR charindex('/', @parent) > 0 THEN '' ELSE replace(replace(@parent,'[','\['),']','\]') + '%' END ESCAPE '\' 
AND coalesce(long_description,description) LIKE '%' + CASE WHEN @skip_grandparent = 1 OR charindex('/', @grandparent) > 0 THEN '' ELSE replace(replace(@grandparent,'[','\['),']','\]') + '%' END ESCAPE '\' 

SELECT @child_term = parent, 
	@skip_parent_term = skip_parent,
	@parent_term = grandparent, 
	@skip_grandparent_term = skip_grandparent,
	@lvl = lvl, 
	@excluding = excluding
FROM c_Assessment_Tree
WHERE term = @child
AND parent = @parent
AND grandparent = @grandparent

SET @found = @@rowcount

IF @child = 'unspecified'
	BEGIN
	-- Eliminate the other terms on the same level, 
	-- so all that is left is the truly unspecified ones
	DECLARE lc_covered CURSOR LOCAL FAST_FORWARD FOR
		SELECT term
		FROM c_Assessment_Tree
		WHERE lvl = @lvl
		AND parent = @parent
		AND grandparent = @grandparent
		AND term != @child

	OPEN lc_covered

	FETCH lc_covered INTO @covered_term

	WHILE @@FETCH_STATUS = 0
		BEGIN
		DELETE FROM #descr
		WHERE descr LIKE '%' + replace(replace(@covered_term,'[','\['),']','\]') + '%' ESCAPE '\'
		FETCH lc_covered INTO @covered_term
		END

	CLOSE lc_covered
	DEALLOCATE lc_covered
	END

IF @found > 1  print 'more levels'

WHILE @lvl > 0 AND @found > 0
	BEGIN
	print @child_term + '|' + @parent_term + '|' + convert(varchar(3),@lvl)  + '|' + convert(varchar(3),@found) 
	-- Skip collective levels (with slashes)
	IF @skip_parent_term = 0 AND charindex('/', @child_term) = 0
		BEGIN
		DELETE FROM #descr
		WHERE descr NOT LIKE '%' + replace(replace(@child_term,'[','\['),']','\]') + '%' ESCAPE '\'
		END

	IF @skip_grandparent_term = 0 AND charindex('/', @parent_term) = 0
		BEGIN
		DELETE FROM #descr
		WHERE descr NOT LIKE '%' + replace(replace(@parent_term,'[','\['),']','\]') + '%' ESCAPE '\' 
		END

	IF @excluding IS NOT NULL
		BEGIN
		DELETE FROM #descr
		WHERE descr LIKE '%' + @excluding + '%' ESCAPE '\' 
		END

	SELECT @child_term = parent, 
		@skip_parent_term = skip_parent,
		@parent_term = grandparent, 
		@skip_grandparent_term = skip_grandparent,
		@lvl = lvl, 
		@excluding = excluding
	FROM c_Assessment_Tree
	WHERE term = @child_term
	AND parent = @parent_term
	AND lvl < @lvl

	SET @found = @@rowcount


	END

select distinct [dbo].[fn_excl_enc_type](descr) as last_child
from #descr
order by last_child

END
GO
