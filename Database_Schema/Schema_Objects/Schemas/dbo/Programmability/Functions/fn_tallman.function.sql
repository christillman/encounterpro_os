
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
RETURNS varchar(1000) 
AS BEGIN
	DECLARE @tallman_version varchar(1000)
	IF dbo.fn_needs_tallman(@drug_description) = 0
		RETURN @drug_description

	SELECT @tallman_version = REPLACE(@drug_description COLLATE SQL_Latin1_General_CP1_CI_AS, tm.spelling, tm.spelling)
	FROM c_Drug_Tall_Man tm
	WHERE (@drug_description COLLATE SQL_Latin1_General_CP1_CI_AS LIKE tm.spelling + '%'
			and @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE tm.spelling + '%')
		or (@drug_description COLLATE SQL_Latin1_General_CP1_CI_AS LIKE '% ' + tm.spelling + '%'
			and @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + tm.spelling + '%')

	/* May need more than one replacement! */
	WHILE dbo.fn_needs_tallman(@tallman_version) = 1
		SELECT @tallman_version = REPLACE(@tallman_version COLLATE SQL_Latin1_General_CP1_CI_AS, tm.spelling, tm.spelling)
		FROM c_Drug_Tall_Man tm
		WHERE (@tallman_version COLLATE SQL_Latin1_General_CP1_CI_AS LIKE tm.spelling + '%'
				and @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE tm.spelling + '%')
			or (@tallman_version COLLATE SQL_Latin1_General_CP1_CI_AS LIKE '% ' + tm.spelling + '%'
				and @tallman_version COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + tm.spelling + '%')
		
	RETURN @tallman_version
END

go
/* test
select descr, dbo.fn_tallman(descr) as sort_expression
from c_Drug_Formulation
where descr like 'actonel%' or descr like 'bleph%' 
order by dbo.fn_tallman(descr)
*/

GRANT EXECUTE ON dbo.fn_tallman TO cprsystem