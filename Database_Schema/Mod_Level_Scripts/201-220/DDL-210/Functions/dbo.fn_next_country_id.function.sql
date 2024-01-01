
Print 'Drop Function dbo.fn_next_country_id'
GO
IF (EXISTS(SELECT 1
	FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.fn_next_country_id') 
	AND [type]='FN'))
DROP Function dbo.fn_next_country_id
GO

Print 'Create Function dbo.fn_next_country_id'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION dbo.fn_next_country_id (
	@country_code varchar(2)
	)
RETURNS varchar(20)
AS BEGIN
RETURN
	'NL' -- no listing
	+ right(
		'00000' + convert(varchar(5),
			(SELECT count(*) FROM Kenya_Drugs 
			WHERE Retention_No like 'NL%') 
				+ 1
	),5)
END