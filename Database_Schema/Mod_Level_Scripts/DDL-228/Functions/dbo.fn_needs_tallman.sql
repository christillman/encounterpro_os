
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
	IF EXISTS (SELECT 1
		FROM c_Drug_Tall_Man tm
		WHERE 
		(
		 (@drug_description LIKE tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
				AND @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE tm.spelling + '%')
			OR (@drug_description LIKE '% ' + tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
				AND @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + tm.spelling + '%')
			OR (@drug_description LIKE '%(' + tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
				AND @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '%(' + tm.spelling + '%')
			OR (@drug_description = tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS
				AND @drug_description COLLATE SQL_Latin1_General_CP1_CS_AS != tm.spelling)
			)
		AND @drug_description NOT LIKE '%[A-Za-z]' + tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
		AND @drug_description NOT LIKE '%' + tm.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '[A-Za-z]%'
		)
		RETURN 1

	RETURN 0
END

/*
 select dbo.fn_needs_tallman('bromhexine / guaifenesin / terbutaline')
 select dbo.fn_needs_tallman('norVASC (Amlodipine)')

select *
from c_Drug_Tall_Man t 
where (		 ('bromhexine / guaifenesin / terbutaline' COLLATE SQL_Latin1_General_CP1_CI_AS LIKE t.spelling + '%'
				and 'bromhexine / guaifenesin / terbutaline' COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE t.spelling + '%')
			or ('bromhexine / guaifenesin / terbutaline' COLLATE SQL_Latin1_General_CP1_CI_AS LIKE '% ' + t.spelling + '%'
				and 'bromhexine / guaifenesin / terbutaline' COLLATE SQL_Latin1_General_CP1_CS_AS NOT LIKE '% ' + t.spelling + '%')
)
*/

go

GRANT EXECUTE ON dbo.fn_needs_tallman TO cprsystem