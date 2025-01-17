

delete from c_Drug_Tall_man where spelling in ('cyclosPORIN', 'cycloSPORINE')

update c_Drug_Tall_man
set spelling = replace(spelling, 'prednisolone', 'prednisoLONE')
where spelling like '%prednisolone%'

update c_Drug_Tall_man
set spelling = 'methylprednisoLONE'
where spelling = 'methylPREDNISolone'

UPDATE c_Drug_Formulation
SET form_descr = replace(form_descr,'cyclosporine','ciclosPORIN') 
where form_descr like '%cyclosporine%'

UPDATE c_Drug_Formulation
SET form_descr = replace(form_descr,'cyclosporin','ciclosPORIN') 
where form_descr like '%cyclosporin%'

UPDATE f
SET form_descr = 
-- select form_descr, 
	b.brand_name + ' ' + dbo.fn_strength(form_descr) + ' ' + dbo.fn_std_dosage_form_descr(form_descr)
from c_Drug_Formulation f
join c_Drug_Brand b on b.brand_name_rxcui = f.ingr_rxcui
join c_Drug_Generic g on g.generic_rxcui = b.generic_rxcui
where f.form_descr like '%\[' + b.brand_name + '\]' escape '\'


declare @SQL nvarchar(max)
declare @tablename varchar(100)
declare @colname varchar(100)

drop table if exists #drive_update
create table #drive_update (tablename varchar(100), colname varchar(100))
insert into #drive_update values
('Uganda_Drugs', 'brand_name'),
('Uganda_Drugs', 'generic_name'),
('Uganda_Drugs', 'SCD_PSN_Version'),
('Uganda_Drugs', 'SBD_Version'),
('Kenya_Drugs', 'Ingredient'),
('Kenya_Drugs', 'SCD_PSN_Version'),
('Kenya_Drugs', 'SBD_Version'),
('c_Drug_Source_Formulation', 'active_ingredients'),
('c_Drug_Source_Formulation', 'source_brand_form_descr'),
('c_Drug_Source_Formulation', 'source_generic_form_descr'),
('c_Drug_Brand', 'brand_name'),
('c_Drug_Pack', 'descr'),
('c_Drug_Pack_Formulation', 'form_descr'),
('c_Drug_Definition', 'common_name'),
('c_Drug_Definition', 'generic_name'),
('c_Drug_Formulation', 'form_descr'),
('c_Drug_Generic', 'generic_name')


DECLARE cr_update CURSOR FOR 
select tablename, colname from #drive_update

OPEN cr_update

FETCH NEXT FROM cr_update INTO @tablename, @colname
 
WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @SQL = '
	UPDATE d
	SET d.'+@colname+' = replace( d.'+@colname+', t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS , t.spelling)
	from '+@tablename+' d
	join c_Drug_Tall_Man t ON d.'+@colname+' COLLATE SQL_Latin1_General_CP1_CI_AS like ''%'' + t.spelling + ''%''
	AND d.'+@colname+' COLLATE SQL_Latin1_General_CP1_CS_AS not like ''%'' + t.spelling + ''%''
	'
	exec sp_executeSQL @SQL
	-- Second time for multiple corrections in one record
	exec sp_executeSQL @SQL
	FETCH NEXT FROM cr_update INTO @tablename, @colname
	END

CLOSE cr_update
DEALLOCATE cr_update

