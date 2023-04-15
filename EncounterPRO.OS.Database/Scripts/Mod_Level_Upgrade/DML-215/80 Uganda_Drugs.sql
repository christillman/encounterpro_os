
DELETE FROM [Uganda_Drugs]

-- Includes reviewed 1 through 4

BULK INSERT [Uganda_Drugs]
FROM '\\localhost\attachments\Uganda_Drugs.txt'

-- Fix Unicode file marker
Update [Uganda_Drugs]
SET NDA_MAL_HDP = right(NDA_MAL_HDP,4) WHERE NDA_MAL_HDP LIKE 'n++%' 

SET NOCOUNT ON

declare @NDA_MAL_HDP varchar(12)
declare @SBD_Version varchar(300)
declare @brand_form_RXCUI varchar(20)
declare @SCD_PSN_Version varchar(300)
declare @generic_form_RXCUI varchar(20)
declare @generic_name varchar(200)
declare @generic_ingr_RXCUI varchar(200)
declare @brand_name varchar(200)
declare @brand_name_rxcui varchar(20)
declare @SQL nvarchar(max)

DECLARE cr_add CURSOR FOR 
SELECT [NDA_MAL_HDP]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[generic_name]
      ,[generic_ingr_RXCUI]
      ,[brand_name]
      ,[brand_name_RXCUI]
  FROM [dbo].[Uganda_Drugs]
where reviewed > 0
and ([SCD_PSN_Version] is not null
	OR [generic_form_RXCUI] is not null)
and ([generic_name] is not null
	OR [generic_ingr_RXCUI] is not null
	OR [generic_form_RXCUI] is not null)
order by [NDA_MAL_HDP]

OPEN cr_add

FETCH NEXT FROM cr_add INTO @NDA_MAL_HDP
      ,@SBD_Version
      ,@brand_form_RXCUI
      ,@SCD_PSN_Version
      ,@generic_form_RXCUI
      ,@generic_name
      ,@generic_ingr_RXCUI
      ,@brand_name
      ,@brand_name_RXCUI

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @SQL = 'exec sp_add_epro_drug '
	SET @SQL = @SQL + CASE WHEN @SBD_Version IS NULL THEN '1,''UG'',' ELSE '0,''UG'',' END
	SET @SQL = @SQL + '''' + @NDA_MAL_HDP + ''','
	SET @SQL = @SQL + CASE WHEN @SBD_Version IS NULL THEN '''No '',' ELSE '''' + replace(@SBD_Version,'''','''''') + ''',' END
	SET @SQL = @SQL + CASE WHEN @brand_form_RXCUI IS NULL THEN 'NULL,' ELSE '''' + @brand_form_RXCUI + ''',' END
	SET @SQL = @SQL + CASE WHEN @SCD_PSN_Version IS NULL THEN 'NULL,' ELSE '''' + replace(@SCD_PSN_Version,'''','''''') + ''','  END
	SET @SQL = @SQL + CASE WHEN @generic_form_RXCUI IS NULL THEN 'NULL,' ELSE '''' + @generic_form_RXCUI + ''',' END
	SET @SQL = @SQL + CASE WHEN @generic_name IS NULL THEN 'NULL,' ELSE '''' + replace(@generic_name,'''','''''') + ''','  END
	SET @SQL = @SQL + CASE WHEN @generic_ingr_RXCUI IS NULL THEN 'NULL,' ELSE '''' + @generic_ingr_RXCUI + ''',' END
	SET @SQL = @SQL + CASE WHEN @brand_name IS NULL THEN 'NULL,' ELSE '''' + replace(@brand_name,'''','''''') + ''','  END
	SET @SQL = @SQL + CASE WHEN @brand_name_RXCUI IS NULL THEN 'NULL' ELSE '''' + @brand_name_RXCUI + '''' END
	print @SQL
	exec sp_ExecuteSQL @SQL

	FETCH NEXT FROM cr_add INTO @NDA_MAL_HDP
		  ,@SBD_Version
		  ,@brand_form_RXCUI
		  ,@SCD_PSN_Version
		  ,@generic_form_RXCUI
		  ,@generic_name
		  ,@generic_ingr_RXCUI
		  ,@brand_name
		  ,@brand_name_RXCUI
	END

CLOSE cr_add
DEALLOCATE cr_add

