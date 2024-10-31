
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_update_tallman]
Print 'Drop Procedure [dbo].[sp_update_tallman]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_tallman]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_update_tallman]
GO

-- Create Procedure [dbo].[sp_update_tallman]
Print 'Create Procedure [dbo].[sp_update_tallman]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_update_tallman 
AS
BEGIN

/*
select * from c_Drug_Tall_Man t
join c_Drug_Generic g 
	ON g.generic_name like '%[A-Za-z]' + t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
select * from c_Drug_Tall_Man t
join c_Drug_Generic g 
	ON g.generic_name like '%' + t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '[A-Za-z]%'

select * from c_Drug_Tall_Man t
join c_Drug_Brand b 
	ON b.brand_name like '%[A-Za-z]' + t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '%'
select * from c_Drug_Tall_Man t
join c_Drug_Brand b 
	ON b.brand_name like '%' + t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS + '[A-Za-z]%'
*/

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
('c_Drug_Pack', 'pack_descr'),
('c_Drug_Pack_Formulation', 'form_descr'),
('c_Drug_Definition', 'common_name'),
('c_Drug_Definition', 'generic_name'),
('c_Drug_Formulation', 'form_descr'),
('c_Drug_Generic', 'generic_name'),
('c_Synonym', 'term'),
('c_Synonym', 'alternate'),
('c_Synonym', 'preferred_term'),
('p_Treatment_Item','treatment_description')


DECLARE cr_update CURSOR FOR 
select tablename, colname from #drive_update

OPEN cr_update

FETCH NEXT FROM cr_update INTO @tablename, @colname
 
WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @SQL = '
	UPDATE '+@tablename+' 
	SET  '+@colname+' = dbo.fn_tallman('+@colname+') 
	WHERE '+@colname+' != dbo.fn_tallman('+@colname+') COLLATE SQL_Latin1_General_CP1_CS_AS
	'
	exec sp_executeSQL @SQL

	FETCH NEXT FROM cr_update INTO @tablename, @colname
	END

CLOSE cr_update
DEALLOCATE cr_update

UPDATE u
SET  item_text = dbo.fn_tallman(item_text) 
-- select item_text, dbo.fn_tallman(item_text) 
FROM u_Top_20 u
WHERE item_text != dbo.fn_tallman(item_text) COLLATE SQL_Latin1_General_CP1_CS_AS
AND top_20_code like '%med%'

END

GO
GRANT EXECUTE
	ON [dbo].[sp_update_tallman]
	TO [cprsystem]
GO
