
update r
set NDA_MAL_HDP = right('00' + NDA_MAL_HDP , 4)
-- select distinct NDA_MAL_HDP, right('00' + NDA_MAL_HDP , 4)
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
where len(NDA_MAL_HDP) <= 3

update [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set NDA_MAL_HDP = '8085' where NDA_MAL_HDP = '8085+A20:G20'

select * 
into [2023_Review1_Discontinued]
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null
-- 61 

delete r
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null


insert into [2023_Review1_Discontinued] (
	 [NDA_MAL_HDP]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[correction SBD_Version]
      ,[matching KE or US rxcui]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[Corrected SCD_PSN_Version]
      ,[Matching corrected US or KE generic_rxcui]
      ,[Ingredient]
      ,[generic_ingr_RXCUI]
      ,[Corrected Ingredient]
      ,[Corrected ingr_rxcui]
      ,[brand_name]
      ,[Corrected brand_name]
      ,[Corrected brand_name_rxcui]
      ,[notes]
      ,[Comments: Ciru]
      ,[Reviewed]
      ,[NDA]
)
SELECT [NDA_MAL_HDP]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[correction SBD_Version]
      ,[matching KE or US rxcui]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[Corrected SCD_PSN_Version]
      ,[Matching corrected US or KE generic_rxcui]
      ,[Ingredient]
      ,[generic_ingr_RXCUI]
      ,[Corrected Ingredient]
      ,[Corrected ingr_rxcui]
      ,[brand_name]
      ,[Corrected brand_name]
      ,[Corrected brand_name_rxcui]
      ,[notes]
      ,[Comments: Ciru]
      ,[Reviewed]
      ,[NDA] 
from Uganda_Drugs_2 r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null
-- 667

delete r
from Uganda_Drugs_2 r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null

select count(*)
from Uganda_Drugs r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
left join Uganda_Drugs_2 u2 
	on u2.NDA_MAL_HDP = r.NDA_MAL_HDP
where n.[NDA] is null and u2.NDA_MAL_HDP is null
-- 667

delete r
from Uganda_Drugs r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
left join Uganda_Drugs_2 u2 
	on u2.NDA_MAL_HDP = r.NDA_MAL_HDP
where n.[NDA] is null and u2.NDA_MAL_HDP is null

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [matching KE or US rxcui] = NULL
where [matching KE or US rxcui] in ('N/A','NA')
or [matching KE or US rxcui] like 'No %'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Matching corrected US or KE generic_rxcui] = NULL
where [Matching corrected US or KE generic_rxcui] in ('N/A','NA')
or [Matching corrected US or KE generic_rxcui] like 'No %'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [correction SBD_Version] = NULL
where [correction SBD_Version] in ('N/A','NA')
or [correction SBD_Version] like 'No %'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Corrected brand_name_rxcui] = NULL
where [Corrected brand_name_rxcui] in ('N/A','NA')
or [Corrected brand_name_rxcui] like 'No %'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Corrected brand_name] = NULL
where [Corrected brand_name] in ('N/A','NA')
or [Corrected brand_name] like 'No %'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Comments: Ciru] = NULL
where  [Comments: Ciru] like 'No longer%'

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [matching KE or US rxcui] = NULL, [Comments: Ciru] = isnull([Comments: Ciru],'') + '; brand form ' + [matching KE or US rxcui]
 -- select * from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [matching KE or US rxcui] like '[HN]%'
or [matching KE or US rxcui] like 'Obsol%'
-- Uganda NDA/MAL/HDP 4943 is for Nolvadex 20 MG oral tablet. Was it 10 MG on the spreadsheet Chris used?

update [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Matching corrected US or KE generic_rxcui] = NULL, [Comments: Ciru] = isnull([Comments: Ciru],'') + '; generic form ' + [Matching corrected US or KE generic_rxcui]
 -- select * from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Matching corrected US or KE generic_rxcui] like '[HN]%'
or [Matching corrected US or KE generic_rxcui] like 'Obsol%'


select distinct r.[matching KE or US rxcui] 
from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
left join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
left join [dbo].[NewKenyaDrugs_Review123] n ON 'KEB' + n.[Kenya Retention No] = r.[matching KE or US rxcui]
where f.form_rxcui is null 
and n.[Kenya Retention No] is null
order by r.[matching KE or US rxcui]

update [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
set [Corrected Ingredient] = null
-- select * from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Corrected Ingredient] = 'Ampicillin / floxacillin'

select [Corrected Ingredient],Ingredient 
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Corrected Ingredient] != Ingredient

select [Corrected ingr_rxcui],[generic_ingr_RXCUI] 
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Corrected ingr_rxcui] != [generic_ingr_RXCUI]

select [Corrected brand_name],[brand_name] 
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Corrected brand_name] != [brand_name]

select [Matching corrected US or KE generic_rxcui],[generic_form_RXCUI] 
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Matching corrected US or KE generic_rxcui] != [generic_form_RXCUI]

select [Corrected SCD_PSN_Version], [SCD_PSN_Version]
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [Corrected SCD_PSN_Version] != [SCD_PSN_Version]

select [correction SBD_Version], [SBD_Version]
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised]
where [correction SBD_Version] != [SBD_Version]

select * from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] 
where [generic_ingr_RXCUI] = '6918'
select * from c_drug_Formulation
where [ingr_RXCUI] = '6918'

insert into [Uganda_Drugs] (
 [NDA_MAL_HDP]
	,[ug_NAME OF DRUG]
	,[ug_GENERIC_NAME OF DRUG]
	,[ug_STRENGTH OF DRUG]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[generic_name]
      ,[generic_ingr_RXCUI]
      ,[brand_name]
      ,[brand_name_RXCUI]
      ,[notes]
      ,[date_added]
      ,[reviewed]
	  )
SELECT DISTINCT r.[NDA_MAL_HDP]
	,r.[SCD_PSN_Version]
	,r.Ingredient
	,case when charindex('|',r.[notes]) > 1 then left(r.[notes],charindex('|',r.[notes])-1) else r.[notes] end
      ,IsNull([correction SBD_Version],r.[SBD_Version])
      ,IsNull(r.[matching KE or US rxcui], r.[brand_form_RXCUI])
      ,IsNull(r.[Corrected SCD_PSN_Version], r.[SCD_PSN_Version])
      ,IsNull(r.[Matching corrected US or KE generic_rxcui],r.[generic_form_RXCUI])
      ,IsNull(r.[Corrected Ingredient],r.Ingredient)
      ,r.[generic_ingr_RXCUI] -- [Corrected ingr_rxcui] not valid
      ,IsNull([Corrected brand_name],r.[brand_name])
      ,r.[Corrected brand_name_rxcui]
      ,r.[notes]
      ,'2023-03-25'
      ,1
from [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
left join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.NDA_MAL_HDP is null
order by r.[NDA_MAL_HDP]

-- [Corrected ingr_rxcui] identified
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[Corrected ingr_rxcui], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[Corrected ingr_rxcui]
where u.[generic_ingr_RXCUI] is null and r.[Corrected ingr_rxcui] is not null
and u.reviewed <= 1

-- [generic_ingr_RXCUI] identified
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[generic_ingr_RXCUI], r.[generic_ingr_RXCUI], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[generic_ingr_RXCUI]
where u.[generic_ingr_RXCUI] is null and r.[generic_ingr_RXCUI] is not null
and u.reviewed <= 1

-- [Corrected ingr_rxcui] differs from [generic_ingr_RXCUI]
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[generic_ingr_RXCUI], r.[Corrected ingr_rxcui], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[Corrected ingr_rxcui]
where u.[generic_ingr_RXCUI] != r.[Corrected ingr_rxcui] 
and u.reviewed <= 1

-- [Corrected brand_name_rxcui] identified
UPDATE u
SET brand_name_RXCUI = b.brand_name_rxcui, brand_name = b.brand_name
-- select u.brand_name_RXCUI, r.[Corrected brand_name_rxcui], u.brand_name, b.brand_name, u.[ug_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Brand b ON b.brand_name_rxcui = r.[Corrected brand_name_rxcui]
where u.brand_name_RXCUI is null and r.[Corrected brand_name_rxcui] is not null
and u.reviewed = 1

-- [brand_name] identified
UPDATE u
SET brand_name_RXCUI = b.brand_name_RXCUI, brand_name = b.brand_name
-- select u.brand_name_RXCUI, r.brand_name, u.brand_name, b.brand_name, u.[ug_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Brand b ON b.brand_name = r.brand_name
where u.brand_name is null and r.brand_name is not null
and r.brand_name NOT IN ('Cipro', 'Ibu')
and u.reviewed = 1

-- [Corrected brand_name] differs from u.brand_name
UPDATE u
SET brand_name_RXCUI = b.brand_name_RXCUI, brand_name = b.brand_name
-- select u.brand_name_RXCUI, r.[Corrected brand_name], u.brand_name, b.brand_name, u.[ug_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Brand b ON b.brand_name = r.[Corrected brand_name]
where (u.brand_name != r.[Corrected brand_name]
 or u.brand_name is null )
and u.reviewed = 1

-- [brand_form_rxcui] identified
UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = f.form_descr
-- select  r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[matching KE or US rxcui], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
where u.[brand_form_rxcui] is null and r.[matching KE or US rxcui] is not null
AND u.SBD_Version IS  NULL
and u.reviewed = 1

-- brand_form_rxcui provided, not yet in c_Drug_Formulation
UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = [correction SBD_Version]
-- select distinct r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[matching KE or US rxcui], u.SBD_Version, [correction SBD_Version], u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[matching KE or US rxcui]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[brand_form_rxcui] is null and r.[matching KE or US rxcui] is not null
and u.reviewed = 1

-- brand_form_rxcui correction, not yet in c_Drug_Formulation
UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = [correction SBD_Version], reviewed = 1
-- select u.reviewed, r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[matching KE or US rxcui], u.SBD_Version, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[matching KE or US rxcui]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[brand_form_rxcui] != r.[matching KE or US rxcui]
and u.reviewed = 1


-- [generic_form_RXCUI2_Correction] identified
UPDATE u
SET [generic_form_rxcui] = r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version = r.[Corrected SCD_PSN_Version]
-- select distinct r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, f.form_descr, r.[Corrected SCD_PSN_Version], u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[Matching corrected US or KE generic_rxcui]
where u.[generic_form_rxcui] is null and r.[Matching corrected US or KE generic_rxcui] is not null
and u.reviewed = 1


-- [generic_form_RXCUI2_Correction] identified as correction
UPDATE u
SET [generic_form_rxcui] = r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version = [Corrected SCD_PSN_Version]
-- select r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[generic_form_rxcui] is null and r.[Matching corrected US or KE generic_rxcui] is not null
and [Corrected SCD_PSN_Version] is not null
and u.reviewed = 1

-- [generic_form_rxcui] differs from [generic_form_RXCUI2_Correction]
UPDATE u
SET [generic_form_rxcui] = f.form_rxcui, u.SCD_PSN_Version = f.form_descr, reviewed = 1
-- select  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, f.form_descr, u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[Matching corrected US or KE generic_rxcui]
where u.[generic_form_rxcui] != [Matching corrected US or KE generic_rxcui]

-- Compare resulting columns for reviews items

select u.NDA_MAL_HDP, u.generic_form_rxcui, u.SCD_PSN_Version, r.[Matching corrected US or KE generic_rxcui], r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 1
and u.generic_form_rxcui != r.[Matching corrected US or KE generic_rxcui]
order by u.SBD_Version

select u.NDA_MAL_HDP, u.generic_ingr_RXCUI, r.generic_ingr_RXCUI, u.SCD_PSN_Version, r.[Matching corrected US or KE generic_rxcui]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 1
and u.generic_ingr_RXCUI != r.[Corrected ingr_rxcui]
order by u.SBD_Version

select u.NDA_MAL_HDP, u.brand_form_rxcui, u.SBD_Version, r.[matching KE or US rxcui], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 1
and u.brand_form_rxcui != r.[matching KE or US rxcui]
order by u.SBD_Version

select u.NDA_MAL_HDP, u.brand_name_rxcui, u.brand_name, r.[Corrected brand_name_rxcui], r.[Corrected brand_name]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 1
and u.brand_name_rxcui != r.[Corrected brand_name_rxcui]
order by u.SBD_Version

-- [Corrected brand_name] differs from u.brand_name, not in c_Drug_Brand
UPDATE u
SET brand_name = r.[Corrected brand_name]
-- select u.NDA_MAL_HDP, u.brand_name_RXCUI, r.[Corrected brand_name], u.brand_name, u.[ug_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where (u.brand_name != r.[Corrected brand_name]
 or u.brand_name is null )
and r.[Corrected brand_name] is not null
and u.reviewed = 1

