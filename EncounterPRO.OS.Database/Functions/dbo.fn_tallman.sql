
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO
Print 'Drop Function [dbo].[fn_tallman]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_tallman]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_tallman
go
Print 'Create Function [dbo].[fn_tallman]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_tallman (@drug_description varchar(1000))
RETURNS varchar(2000) 
AS BEGIN
	DECLARE @tallman_version varchar(2000) = @drug_description
	DECLARE @limit int = 15	
	DECLARE @spelling varchar(200)

 	IF NOT EXISTS (SELECT spelling from c_Drug_Tall_Man 
			WHERE @drug_description LIKE '%' + spelling COLLATE DATABASE_DEFAULT + '%'
			)
		RETURN @drug_description

	DECLARE cr_update CURSOR FOR 
	SELECT spelling from c_Drug_Tall_Man 
	WHERE @tallman_version LIKE '%' + spelling COLLATE DATABASE_DEFAULT + '%'	

	OPEN cr_update

	FETCH NEXT FROM cr_update INTO @spelling

	WHILE @@FETCH_STATUS = 0
		BEGIN
		SELECT @tallman_version = REPLACE(@tallman_version, @spelling, @spelling)
		FROM c_1_record
		WHERE (@tallman_version LIKE @spelling COLLATE DATABASE_DEFAULT + '%'
				AND @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE @spelling + '%')
			OR (@tallman_version LIKE '% ' + @spelling COLLATE DATABASE_DEFAULT + '%'
				AND @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + @spelling + '%')
			OR (@tallman_version LIKE '%(' + @spelling COLLATE DATABASE_DEFAULT + '%'
				AND @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '%(' + @spelling + '%')
			OR (@tallman_version = @spelling COLLATE DATABASE_DEFAULT
				AND @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS != @spelling)
			AND @tallman_version NOT LIKE '%[A-Za-z]' + @spelling COLLATE DATABASE_DEFAULT + '%'
			AND @tallman_version NOT LIKE '%' + @spelling COLLATE DATABASE_DEFAULT + '[A-Za-z]%'

		FETCH NEXT FROM cr_update INTO @spelling
		END

	CLOSE cr_update
	DEALLOCATE cr_update
	
	RETURN @tallman_version
END

go

/* test

select dbo.fn_tallman('acetaminophen / dextromethorphan / pseudoephedrine')
select dbo.fn_tallman('norvasc (Amlodipine)')
select dbo.fn_tallman('lactose')

*/

GRANT EXECUTE ON dbo.fn_tallman TO cprsystem