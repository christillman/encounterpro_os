
Print 'Drop Function dbo.fn_next_country_id'
GO
IF (EXISTS(SELECT 1
	FROM sys.objects WHERE [object_id] = OBJECT_ID(N'dbo.fn_next_country_id') 
	AND [type] = 'FN'))
DROP FUNCTION IF EXISTS dbo.fn_next_country_id
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

DECLARE @new_code varchar(7)
 
;WITH no_listings AS (
	SELECT source_id
	FROM c_Drug_Source_Formulation
	WHERE source_id like 'NL%'
	AND [country_code] = @country_code
)
SELECT @new_code = 'NL' -- no listing
	+ IsNull(right(
		'00000' + convert(varchar(5),
			max(convert(integer,right(source_id,5))) 
				+ 1
		),5),
		'00001')
FROM no_listings

RETURN @new_code

END

/*
	select dbo.fn_next_country_id('KE')
	select dbo.fn_next_country_id('UG')
*/

GO
GRANT EXECUTE ON [dbo].[fn_next_country_id] TO [cprsystem]
GO
