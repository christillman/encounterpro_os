IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_formulation_dosage_form_desc') AND type in (N'FN'))
DROP FUNCTION dbo.fn_formulation_dosage_form_desc
GO

CREATE FUNCTION dbo.fn_formulation_dosage_form_desc (@form_rxcui varchar(30))
RETURNS varchar(100) -- dosage_form 
AS BEGIN

DECLARE @dosage_form varchar(100)

;WITH candidates as (
	select f.form_descr, max(len(df.description)) as longest_match
	from c_Drug_Generic g
	join c_Drug_Formulation f ON f.ingr_rxcui = g.generic_rxcui
	left join c_Dosage_Form df ON f.form_descr LIKE '%' + df.description + '%'
	where f.form_rxcui = @form_rxcui
	and df.description is not null
	group by f.form_rxcui, f.form_descr
	)
select @dosage_form = df.description
from candidates c
left join c_Dosage_Form df ON c.form_descr LIKE '%' + df.description + '%'
where len(df.description) = longest_match

RETURN @dosage_form

END

-- select dbo.fn_formulation_dosage_form_desc ('KEG1977')


GO
GRANT EXECUTE ON [dbo].[fn_formulation_dosage_form_desc] TO [cprsystem]
GO
