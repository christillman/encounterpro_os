
Print 'Drop Function [dbo].[fn_needs_tallman]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_needs_tallman]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION dbo.fn_needs_tallman
go
Print 'Create Function [dbo].[fn_needs_tallman]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_needs_tallman (@drug_description varchar(1000))
RETURNS bit
AS BEGIN
	DECLARE @needs_tallman_version bit
	IF NOT EXISTS (SELECT 1
				FROM c_Drug_Tall_Man tm
		WHERE 
		-- avoid infinite loop when a term matches two spellings i.e. cyclosporin / cyclosporine
		LEN(@drug_description) = LEN(tm.spelling)
		and (
		 (@drug_description COLLATE SQL_Latin1_General_CP1_CI_AS LIKE tm.spelling + '%'
				and @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE tm.spelling + '%')
			or (@drug_description COLLATE SQL_Latin1_General_CP1_CI_AS LIKE '% ' + tm.spelling + '%'
				and @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + tm.spelling + '%')
			)
	)
		RETURN 0

	RETURN 1
END


go

GRANT EXECUTE ON dbo.fn_needs_tallman TO cprsystem