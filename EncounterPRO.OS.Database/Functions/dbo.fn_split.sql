
Print 'Drop Function [dbo].[fn_split]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_split]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_split
go
Print 'Create Function [dbo].[fn_split]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_split (@str varchar(1000), @delimiter varchar(10))
RETURNS @t TABLE (substr varchar(1000))
AS
BEGIN
	WITH cte AS
	(
		SELECT 0 a, 1 b
		UNION ALL
		SELECT b, CHARINDEX(@delimiter, @str, b) + DATALENGTH(@delimiter)
		FROM CTE
		WHERE b > a
	)
	INSERT @t (substr) 
	SELECT LTRIM(SUBSTRING(@str, a,
		CASE WHEN b > DATALENGTH(@delimiter) 
			THEN b - a - DATALENGTH(@delimiter) 
			ELSE DATALENGTH(@str) - a + 1 END)) value      
		FROM cte WHERE a > 0 AND CHARINDEX(@delimiter, @str) > 0
	UNION ALL
	SELECT @str WHERE CHARINDEX(@delimiter, @str) = 0
	RETURN
END

go
/* test
select * from dbo.fn_split('ferric ammonium citrate 200 MG / thiamine HCl 2 MG / riboflavin 0.5 MG / nicotinamide 5 MG / pyridoxine 1 MG', ' / ')
select * from dbo.fn_split('ferrous fumarate 300 MG / folic acid 2.5 MG / vitamin B6 10 MG / vitamin B12 50 MCG / vitamin C 100 MG Oral Capsule', ' / ')
select * from dbo.fn_split('methylPREDNISolone sodium succinate 2 GM', ' / ')
*/

GO
GRANT SELECT ON [dbo].[fn_split] TO [cprsystem]
GO
