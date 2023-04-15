
update r
set NDA_MAL_HDP = right('00' + NDA_MAL_HDP , 4)
-- select distinct NDA_MAL_HDP, right('00' + NDA_MAL_HDP , 4)
from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r
where len(NDA_MAL_HDP) <= 3


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
      ,[Comments: Ciru]
      ,[Reviewed]
)
SELECT distinct [NDA_MAL_HDP]
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
      ,[Comments: Ciru]
      ,3
from [06_27_2022_UgandaDrugs_Massaged_Review 3] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null
and r.NDA_MAL_HDP not like '%[ABC]%'
-- 43


delete r
from [06_27_2022_UgandaDrugs_Massaged_Review 3] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null
and r.NDA_MAL_HDP not like '%[ABC]%'


update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [matching KE or US rxcui] = NULL
where [matching KE or US rxcui] in ('N/A','NA')
or [matching KE or US rxcui] like 'No %'

update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [Matching corrected US or KE generic_rxcui] = NULL
where [Matching corrected US or KE generic_rxcui] in ('N/A','NA')
or [Matching corrected US or KE generic_rxcui] like 'No %'

update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [correction SBD_Version] = NULL
where [correction SBD_Version] in ('N/A','NA')
or [correction SBD_Version] like 'No %'

update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [Comments: Ciru] = NULL -- select * from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where  [Comments: Ciru] like 'No longer%'


update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [matching KE or US rxcui] = NULL
 -- select * from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [matching KE or US rxcui] like '[HN]%'


update [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
set [Matching corrected US or KE generic_rxcui] = NULL, [Comments: Ciru] = isnull([Comments: Ciru],'') + '; generic form ' + [Matching corrected US or KE generic_rxcui]
 -- select * from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [Matching corrected US or KE generic_rxcui] like '[HN]%'
or [Matching corrected US or KE generic_rxcui] like 'Obsol%'


select distinct r.[matching KE or US rxcui] 
from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r
left join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
left join [dbo].[NewKenyaDrugs_Review123] n ON 'KEB' + n.[Kenya Retention No] = r.[matching KE or US rxcui]
where f.form_rxcui is null 
and n.[Kenya Retention No] is null
order by r.[matching KE or US rxcui]

select [Corrected Ingredient],Ingredient 
from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [Corrected Ingredient] != Ingredient

select [Corrected ingr_rxcui],[generic_ingr_RXCUI] 
from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [Corrected ingr_rxcui] != [generic_ingr_RXCUI]

select [Matching corrected US or KE generic_rxcui],r.[generic_form_RXCUI], r.[Corrected SCD_PSN_Version], f.*
from [06_27_2022_UgandaDrugs_Massaged_Review 3] r
join c_Drug_Formulation f on (f.form_rxcui = r.[Matching corrected US or KE generic_rxcui]
	or f.form_rxcui = r.[generic_form_RXCUI])
where [Matching corrected US or KE generic_rxcui] != r.[generic_form_RXCUI]

select [Corrected SCD_PSN_Version], [SCD_PSN_Version]
from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [Corrected SCD_PSN_Version] != [SCD_PSN_Version]

select [correction SBD_Version], [SBD_Version]
from [06_27_2022_UgandaDrugs_Massaged_Review 3]
where [correction SBD_Version] != [SBD_Version]

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
      ,[date_added]
      ,[reviewed]
	  )
SELECT DISTINCT r.[NDA_MAL_HDP]
	,r.[SBD_Version]
	,r.Ingredient
	, 'strength'
      ,IsNull(r.[correction SBD_Version],r.[SBD_Version])
      ,IsNull(r.[matching KE or US rxcui], r.[brand_form_RXCUI])
      ,IsNull(r.[Corrected SCD_PSN_Version], r.[SCD_PSN_Version])
      ,IsNull(r.[Matching corrected US or KE generic_rxcui],r.[generic_form_RXCUI])
      ,IsNull(r.[Corrected Ingredient],r.Ingredient)
      ,r.[generic_ingr_RXCUI] -- [Corrected ingr_rxcui] not valid
      ,'2023-03-25'
      ,3
from [06_27_2022_UgandaDrugs_Massaged_Review 3] r
left join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.NDA_MAL_HDP is null
order by r.[NDA_MAL_HDP]




select distinct r.[matching KE or US rxcui] 
from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r
left join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
left join [dbo].[NewKenyaDrugs_Review123] n ON 'KEB' + n.[Kenya Retention No] = r.[matching KE or US rxcui]
where f.form_rxcui is null and r.[matching KE or US rxcui] is not null
and n.[Kenya Retention No] is null
order by r.[matching KE or US rxcui]


-- [Corrected ingr_rxcui] identified
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[Corrected ingr_rxcui], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[Corrected ingr_rxcui]
where u.[generic_ingr_RXCUI] is null and r.[Corrected ingr_rxcui] is not null

-- [generic_ingr_RXCUI] identified
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[generic_ingr_RXCUI], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[generic_ingr_RXCUI]
where u.[generic_ingr_RXCUI] is null and r.[generic_ingr_RXCUI] is not null

-- [Corrected ingr_rxcui] differs from [generic_ingr_RXCUI]
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, u.generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[generic_ingr_RXCUI], r.[Corrected ingr_rxcui], u.generic_name, g.generic_name, r.[Corrected Ingredient], u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[Corrected ingr_rxcui]
where u.[generic_ingr_RXCUI] != r.[Corrected ingr_rxcui] 

-- [matching KE or US rxcui] identified
UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = r.[correction SBD_Version]
-- select  r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[matching KE or US rxcui], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
where u.[brand_form_rxcui] is null and r.[matching KE or US rxcui] is not null

-- [brand_form_rxcui] identified
UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = r.[correction SBD_Version]
-- select distinct r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[matching KE or US rxcui], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
where u.[brand_form_rxcui] is null and r.[matching KE or US rxcui] is not null

UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = r.[correction SBD_Version]
-- select r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_rxcui], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[matching KE or US rxcui], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[matching KE or US rxcui]
where r.[matching KE or US rxcui] != u.[brand_form_rxcui]


UPDATE u
SET brand_form_RXCUI = r.[matching KE or US rxcui], u.SBD_Version = [correction SBD_Version]
-- select r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_rxcui], u.SBD_Version, [correction SBD_Version], u.[ug_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[matching KE or US rxcui], r.[Comments: Ciru]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[brand_form_rxcui] is null and r.[matching KE or US rxcui] is not null

-- [Matching corrected US or KE generic_rxcui] identified
UPDATE u
SET [generic_form_rxcui] = f.form_rxcui, u.SCD_PSN_Version = f.form_descr
-- select  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, f.form_descr, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[Matching corrected US or KE generic_rxcui]
where u.[generic_form_rxcui] is null and r.[Matching corrected US or KE generic_rxcui] is not null

-- [generic_form_rxcui] identified
UPDATE u
SET [generic_form_rxcui] = f.form_rxcui, u.SCD_PSN_Version = f.form_descr
-- select  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[generic_form_rxcui], u.SCD_PSN_Version, f.form_descr, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[generic_form_rxcui]
where u.[generic_form_rxcui] is null and r.[generic_form_rxcui] is not null
and [Corrected SCD_PSN_Version] is null

-- [Matching corrected US or KE generic_rxcui] identified as correction
UPDATE u
SET [generic_form_rxcui] = r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version = [Corrected SCD_PSN_Version]
-- select  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[generic_form_rxcui] is null and r.[Matching corrected US or KE generic_rxcui] is not null
and [Corrected SCD_PSN_Version] is not null

-- [generic_form_rxcui] differs from [Matching corrected US or KE generic_rxcui]
UPDATE u
SET [generic_form_rxcui] = r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version = r.[Corrected SCD_PSN_Version]
-- select  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[Matching corrected US or KE generic_rxcui], u.SCD_PSN_Version, f.form_descr, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG], r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[Matching corrected US or KE generic_rxcui]
where u.[generic_form_rxcui] != [Matching corrected US or KE generic_rxcui]


-- Update from original Uganda export [UgandaDrugs-Dec2021]
-- [generic_ingr_RXCUI] identified
UPDATE u
SET [generic_ingr_RXCUI] = g.generic_rxcui, generic_name = g.generic_name
-- select u.[NDA_MAL_HDP], u.[generic_ingr_RXCUI], r.[generic_ingr_RXCUI], u.generic_name, g.generic_name, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[20220114ImportUgandaDrugs] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Generic g ON g.generic_rxcui = r.[generic_ingr_RXCUI]
where u.[generic_ingr_RXCUI] is null and r.[generic_ingr_RXCUI] is not null

update [dbo].[Uganda_Drugs] set brand_form_RXCUI = NULL, 
	SBD_Version = null
	--select * from [Uganda_Drugs]
where NDA_MAL_HDP = '3867'

-- Compare resulting columns for reviews items

select u.NDA_MAL_HDP, u.generic_form_rxcui, u.SCD_PSN_Version, r.[Matching corrected US or KE generic_rxcui], r.SCD_PSN_Version, r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 3
and u.generic_form_rxcui != r.[Matching corrected US or KE generic_rxcui]
order by u.SBD_Version

select u.NDA_MAL_HDP, u.generic_ingr_RXCUI, r.generic_ingr_RXCUI, u.SCD_PSN_Version, r.[Corrected SCD_PSN_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 3
and u.generic_ingr_RXCUI != r.[Corrected ingr_rxcui]
order by u.SBD_Version

select u.NDA_MAL_HDP, u.brand_form_rxcui, u.SBD_Version, r.[matching KE or US rxcui], r.[correction SBD_Version]
from [Uganda_Drugs] u
join [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 3
and u.brand_form_rxcui != r.[matching KE or US rxcui]
order by u.SBD_Version


-- [generic_form_rxcui] identified
UPDATE u
SET [generic_form_rxcui] = f.form_rxcui, u.SCD_PSN_Version = f.form_descr
-- select 'OR (f.form_rxcui='''+f.form_rxcui+''' AND u.NDA_MAL_HDP=''' + u.NDA_MAL_HDP + ''')', r.[NDA_MAL_HDP], f.form_descr, u.[ug_GENERIC_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[20220114ImportUgandaDrugs] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[generic_form_rxcui]
where u.[generic_form_rxcui] is null and r.[generic_form_rxcui] is not null
AND (
 (f.form_rxcui='1232154' AND u.NDA_MAL_HDP='9779')
OR (f.form_rxcui='KEG3675' AND u.NDA_MAL_HDP='0712')
OR (f.form_rxcui='UGG3204' AND u.NDA_MAL_HDP='3204')
OR (f.form_rxcui='246656' AND u.NDA_MAL_HDP='0460')
OR (f.form_rxcui='KEG6385' AND u.NDA_MAL_HDP='1011')
OR (f.form_rxcui='KEG3517' AND u.NDA_MAL_HDP='4536')
OR (f.form_rxcui='562508' AND u.NDA_MAL_HDP='0915')
OR (f.form_rxcui='313799' AND u.NDA_MAL_HDP='0124')
OR (f.form_rxcui='KEG1293' AND u.NDA_MAL_HDP='7355')
OR (f.form_rxcui='KEG1505' AND u.NDA_MAL_HDP='2812')
OR (f.form_rxcui='KEG1358' AND u.NDA_MAL_HDP='0959')
OR (f.form_rxcui='847731' AND u.NDA_MAL_HDP='0959')
OR (f.form_rxcui='847731' AND u.NDA_MAL_HDP='3963')
OR (f.form_rxcui='847731' AND u.NDA_MAL_HDP='9353')
OR (f.form_rxcui='847731' AND u.NDA_MAL_HDP='6557')
OR (f.form_rxcui='KEG129' AND u.NDA_MAL_HDP='4553')
OR (f.form_rxcui='617312' AND u.NDA_MAL_HDP='0069')
OR (f.form_rxcui='617310' AND u.NDA_MAL_HDP='0070')
OR (f.form_rxcui='864681' AND u.NDA_MAL_HDP='4620')
OR (f.form_rxcui='1190655' AND u.NDA_MAL_HDP='6562')
OR (f.form_rxcui='1190655' AND u.NDA_MAL_HDP='9804')
OR (f.form_rxcui='1190655' AND u.NDA_MAL_HDP='2610')
OR (f.form_rxcui='KEG261' AND u.NDA_MAL_HDP='0499')
OR (f.form_rxcui='198501' AND u.NDA_MAL_HDP='0343')
OR (f.form_rxcui='198501' AND u.NDA_MAL_HDP='0698')
OR (f.form_rxcui='198501' AND u.NDA_MAL_HDP='3233')
OR (f.form_rxcui='198501' AND u.NDA_MAL_HDP='2197')
OR (f.form_rxcui='199433' AND u.NDA_MAL_HDP='2509')
OR (f.form_rxcui='259034' AND u.NDA_MAL_HDP='6243')
OR (f.form_rxcui='197407' AND u.NDA_MAL_HDP='3867')
OR (f.form_rxcui='308720' AND u.NDA_MAL_HDP='3331')
OR (f.form_rxcui='1657066' AND u.NDA_MAL_HDP='4275')
OR (f.form_rxcui='656659' AND u.NDA_MAL_HDP='6528')
OR (f.form_rxcui='349253' AND u.NDA_MAL_HDP='6527')
OR (f.form_rxcui='308805' AND u.NDA_MAL_HDP='4927')
OR (f.form_rxcui='KEG6822' AND u.NDA_MAL_HDP='0572')
OR (f.form_rxcui='KEG108' AND u.NDA_MAL_HDP='7360')
OR (f.form_rxcui='308976' AND u.NDA_MAL_HDP='2239')
OR (f.form_rxcui='402505' AND u.NDA_MAL_HDP='1650')
OR (f.form_rxcui='KEG1312' AND u.NDA_MAL_HDP='8353')
OR (f.form_rxcui='KEG13074' AND u.NDA_MAL_HDP='6843')
OR (f.form_rxcui='KEG13074' AND u.NDA_MAL_HDP='6845')
OR (f.form_rxcui='309096' AND u.NDA_MAL_HDP='4380')
OR (f.form_rxcui='KEG14014' AND u.NDA_MAL_HDP='0720')
OR (f.form_rxcui='KEG13592' AND u.NDA_MAL_HDP='6386')
OR (f.form_rxcui='310587' AND u.NDA_MAL_HDP='7907')
OR (f.form_rxcui='KEG10287' AND u.NDA_MAL_HDP='0685')
OR (f.form_rxcui='KEG10285' AND u.NDA_MAL_HDP='0687')
OR (f.form_rxcui='861495' AND u.NDA_MAL_HDP='4097')
OR (f.form_rxcui='861448' AND u.NDA_MAL_HDP='5055')
OR (f.form_rxcui='309362' AND u.NDA_MAL_HDP='0609')
OR (f.form_rxcui='KEG6292' AND u.NDA_MAL_HDP='3545')
OR (f.form_rxcui='309367' AND u.NDA_MAL_HDP='2428')
OR (f.form_rxcui='309367' AND u.NDA_MAL_HDP='2016')
OR (f.form_rxcui='KEG6405' AND u.NDA_MAL_HDP='3289')
OR (f.form_rxcui='KEG6487' AND u.NDA_MAL_HDP='0857')
OR (f.form_rxcui='KEG6455' AND u.NDA_MAL_HDP='1627')
OR (f.form_rxcui='197533' AND u.NDA_MAL_HDP='0692')
OR (f.form_rxcui='KEG16545' AND u.NDA_MAL_HDP='9641')
OR (f.form_rxcui='KEG2325' AND u.NDA_MAL_HDP='6692')
OR (f.form_rxcui='KEG2338' AND u.NDA_MAL_HDP='0107')
OR (f.form_rxcui='607573' AND u.NDA_MAL_HDP='1853')
OR (f.form_rxcui='KEG14269' AND u.NDA_MAL_HDP='1463')
OR (f.form_rxcui='KEG11542' AND u.NDA_MAL_HDP='0056')
OR (f.form_rxcui='855657' AND u.NDA_MAL_HDP='2525')
OR (f.form_rxcui='855657' AND u.NDA_MAL_HDP='3844')
OR (f.form_rxcui='857703' AND u.NDA_MAL_HDP='1485')
OR (f.form_rxcui='857705' AND u.NDA_MAL_HDP='5127')
OR (f.form_rxcui='KEG2129' AND u.NDA_MAL_HDP='2478')
OR (f.form_rxcui='KEG4514' AND u.NDA_MAL_HDP='3535')
OR (f.form_rxcui='KEG4522' AND u.NDA_MAL_HDP='1492')
OR (f.form_rxcui='KEG4522' AND u.NDA_MAL_HDP='1451')
OR (f.form_rxcui='KEG2132A' AND u.NDA_MAL_HDP='5318')
OR (f.form_rxcui='197606' AND u.NDA_MAL_HDP='5207')
OR (f.form_rxcui='KEG3101' AND u.NDA_MAL_HDP='4952')
OR (f.form_rxcui='KEG3172' AND u.NDA_MAL_HDP='4951')
OR (f.form_rxcui='KEG938' AND u.NDA_MAL_HDP='4033')
OR (f.form_rxcui='1860485' AND u.NDA_MAL_HDP='0737')
OR (f.form_rxcui='1433873' AND u.NDA_MAL_HDP='0204')
OR (f.form_rxcui='310027' AND u.NDA_MAL_HDP='1155')
OR (f.form_rxcui='310027' AND u.NDA_MAL_HDP='5295')
OR (f.form_rxcui='284207' AND u.NDA_MAL_HDP='4035')
OR (f.form_rxcui='KEG7754' AND u.NDA_MAL_HDP='3175')
OR (f.form_rxcui='996097' AND u.NDA_MAL_HDP='0576')
OR (f.form_rxcui='KEG5870' AND u.NDA_MAL_HDP='4879')
OR (f.form_rxcui='854235' AND u.NDA_MAL_HDP='4877')
OR (f.form_rxcui='854238' AND u.NDA_MAL_HDP='4874')
OR (f.form_rxcui='854241' AND u.NDA_MAL_HDP='4876')
OR (f.form_rxcui='606726' AND u.NDA_MAL_HDP='0938')
OR (f.form_rxcui='433733' AND u.NDA_MAL_HDP='0360')
OR (f.form_rxcui='995607' AND u.NDA_MAL_HDP='8193')
OR (f.form_rxcui='KEG4560' AND u.NDA_MAL_HDP='3319')
OR (f.form_rxcui='KEG7260' AND u.NDA_MAL_HDP='3465')
OR (f.form_rxcui='310385' AND u.NDA_MAL_HDP='6454')
OR (f.form_rxcui='KEG551A' AND u.NDA_MAL_HDP='0053')
OR (f.form_rxcui='KEG3506' AND u.NDA_MAL_HDP='0203')
OR (f.form_rxcui='310467' AND u.NDA_MAL_HDP='8212')
OR (f.form_rxcui='KEG601' AND u.NDA_MAL_HDP='4358')
OR (f.form_rxcui='1658156' AND u.NDA_MAL_HDP='1328')
OR (f.form_rxcui='1658142' AND u.NDA_MAL_HDP='1769')
OR (f.form_rxcui='KEG5976' AND u.NDA_MAL_HDP='7191')
OR (f.form_rxcui='847239' AND u.NDA_MAL_HDP='5104')
OR (f.form_rxcui='KEG5916' AND u.NDA_MAL_HDP='7910')
OR (f.form_rxcui='847230' AND u.NDA_MAL_HDP='7911')
OR (f.form_rxcui='311041' AND u.NDA_MAL_HDP='7909')
OR (f.form_rxcui='242120' AND u.NDA_MAL_HDP='3440')
OR (f.form_rxcui='1741267' AND u.NDA_MAL_HDP='6949')
OR (f.form_rxcui='KEG6431' AND u.NDA_MAL_HDP='5150')
OR (f.form_rxcui='203088' AND u.NDA_MAL_HDP='5299')
OR (f.form_rxcui='KEG553' AND u.NDA_MAL_HDP='2395')
OR (f.form_rxcui='KEG9258' AND u.NDA_MAL_HDP='6654')
OR (f.form_rxcui='391937' AND u.NDA_MAL_HDP='7589')
OR (f.form_rxcui='KEG2260' AND u.NDA_MAL_HDP='6316')
OR (f.form_rxcui='UGG7518' AND u.NDA_MAL_HDP='7518')
OR (f.form_rxcui='105510' AND u.NDA_MAL_HDP='2306')
OR (f.form_rxcui='804156' AND u.NDA_MAL_HDP='2070')
OR (f.form_rxcui='892246' AND u.NDA_MAL_HDP='0832')
OR (f.form_rxcui='966221' AND u.NDA_MAL_HDP='2199')
OR (f.form_rxcui='1010671' AND u.NDA_MAL_HDP='1012')
OR (f.form_rxcui='1662285' AND u.NDA_MAL_HDP='0866')
OR (f.form_rxcui='311373' AND u.NDA_MAL_HDP='3694')
OR (f.form_rxcui='311372' AND u.NDA_MAL_HDP='7525')
OR (f.form_rxcui='692783' AND u.NDA_MAL_HDP='7439')
OR (f.form_rxcui='692783' AND u.NDA_MAL_HDP='3098')
OR (f.form_rxcui='KEG12063' AND u.NDA_MAL_HDP='7784')
OR (f.form_rxcui='KEG9496' AND u.NDA_MAL_HDP='1244')
OR (f.form_rxcui='979480' AND u.NDA_MAL_HDP='4634')
OR (f.form_rxcui='311666' AND u.NDA_MAL_HDP='2753')
OR (f.form_rxcui='866412' AND u.NDA_MAL_HDP='6032')
OR (f.form_rxcui='866436' AND u.NDA_MAL_HDP='6392')
OR (f.form_rxcui='311724' AND u.NDA_MAL_HDP='7152')
OR (f.form_rxcui='242438' AND u.NDA_MAL_HDP='1182')
OR (f.form_rxcui='1731993' AND u.NDA_MAL_HDP='9794')
OR (f.form_rxcui='485020' AND u.NDA_MAL_HDP='3753')
OR (f.form_rxcui='485023' AND u.NDA_MAL_HDP='3883')
OR (f.form_rxcui='387013' AND u.NDA_MAL_HDP='0322')
OR (f.form_rxcui='311943' AND u.NDA_MAL_HDP='2497')
OR (f.form_rxcui='198034' AND u.NDA_MAL_HDP='3714')
OR (f.form_rxcui='997653' AND u.NDA_MAL_HDP='4615')
OR (f.form_rxcui='359822' AND u.NDA_MAL_HDP='6787')
OR (f.form_rxcui='KEG844' AND u.NDA_MAL_HDP='6785')
OR (f.form_rxcui='KEG3500' AND u.NDA_MAL_HDP='3801')
OR (f.form_rxcui='KEG3500' AND u.NDA_MAL_HDP='2360')
OR (f.form_rxcui='KEG4304' AND u.NDA_MAL_HDP='3833')
OR (f.form_rxcui='312055' AND u.NDA_MAL_HDP='3657')
OR (f.form_rxcui='312055' AND u.NDA_MAL_HDP='0141')
OR (f.form_rxcui='312068' AND u.NDA_MAL_HDP='6736')
OR (f.form_rxcui='1111339' AND u.NDA_MAL_HDP='1864')
OR (f.form_rxcui='KEG4897' AND u.NDA_MAL_HDP='8264')
OR (f.form_rxcui='1740467' AND u.NDA_MAL_HDP='7317')
OR (f.form_rxcui='KEG2067' AND u.NDA_MAL_HDP='0897')
OR (f.form_rxcui='UGG8252A' AND u.NDA_MAL_HDP='8252')
OR (f.form_rxcui='UGG8252B' AND u.NDA_MAL_HDP='8252')
OR (f.form_rxcui='UGG8692' AND u.NDA_MAL_HDP='8692')
OR (f.form_rxcui='KEG1035' AND u.NDA_MAL_HDP='5377')
OR (f.form_rxcui='KEG146' AND u.NDA_MAL_HDP='4964')
OR (f.form_rxcui='KEG10886' AND u.NDA_MAL_HDP='3787')
OR (f.form_rxcui='KEG9110' AND u.NDA_MAL_HDP='9619')
OR (f.form_rxcui='KEG11621' AND u.NDA_MAL_HDP='9534')
OR (f.form_rxcui='KEG14159' AND u.NDA_MAL_HDP='3711')
OR (f.form_rxcui='1376336' AND u.NDA_MAL_HDP='0588')
OR (f.form_rxcui='728231' AND u.NDA_MAL_HDP='6929')
OR (f.form_rxcui='KEG15379' AND u.NDA_MAL_HDP='7342')
OR (f.form_rxcui='1043563' AND u.NDA_MAL_HDP='0419')
OR (f.form_rxcui='1043570' AND u.NDA_MAL_HDP='0418')
OR (f.form_rxcui='KEG5158' AND u.NDA_MAL_HDP='1990')
OR (f.form_rxcui='250511' AND u.NDA_MAL_HDP='1989')
OR (f.form_rxcui='312950' AND u.NDA_MAL_HDP='3368')
OR (f.form_rxcui='312950' AND u.NDA_MAL_HDP='1478')
OR (f.form_rxcui='KEG1637' AND u.NDA_MAL_HDP='0906')
OR (f.form_rxcui='KEG12154' AND u.NDA_MAL_HDP='9504')
OR (f.form_rxcui='1807632' AND u.NDA_MAL_HDP='5472')
OR (f.form_rxcui='1807633' AND u.NDA_MAL_HDP='7354')
OR (f.form_rxcui='KEG5884' AND u.NDA_MAL_HDP='4127')
OR (f.form_rxcui='1799212' AND u.NDA_MAL_HDP='8823')
OR (f.form_rxcui='597747' AND u.NDA_MAL_HDP='6294')
OR (f.form_rxcui='313189' AND u.NDA_MAL_HDP='9585')
OR (f.form_rxcui='KEG1699' AND u.NDA_MAL_HDP='0914')
OR (f.form_rxcui='1597126' AND u.NDA_MAL_HDP='7120')
OR (f.form_rxcui='KEG4064' AND u.NDA_MAL_HDP='0879')
OR (f.form_rxcui='198371' AND u.NDA_MAL_HDP='8331')
OR (f.form_rxcui='198372' AND u.NDA_MAL_HDP='1219')
OR (f.form_rxcui='806573' AND u.NDA_MAL_HDP='1366')
OR (f.form_rxcui='1085728' AND u.NDA_MAL_HDP='9219')
OR (f.form_rxcui='858751' AND u.NDA_MAL_HDP='7011')
OR (f.form_rxcui='349480' AND u.NDA_MAL_HDP='3846')
OR (f.form_rxcui='349478' AND u.NDA_MAL_HDP='3789')
OR (f.form_rxcui='349479' AND u.NDA_MAL_HDP='3802')
OR (f.form_rxcui='KEG17278' AND u.NDA_MAL_HDP='0658')
OR (f.form_rxcui='KEG13379' AND u.NDA_MAL_HDP='0654')
OR (f.form_rxcui='KEG14512' AND u.NDA_MAL_HDP='0657')
OR (f.form_rxcui='237735' AND u.NDA_MAL_HDP='2401')
OR (f.form_rxcui='387790' AND u.NDA_MAL_HDP='3032')
OR (f.form_rxcui='1363493' AND u.NDA_MAL_HDP='5414')
OR (f.form_rxcui='KEG9416' AND u.NDA_MAL_HDP='3504')
OR (f.form_rxcui='351114' AND u.NDA_MAL_HDP='6116')
OR (f.form_rxcui='351114' AND u.NDA_MAL_HDP='8207')
OR (f.form_rxcui='KEG540A' AND u.NDA_MAL_HDP='0051')
OR (f.form_rxcui='KEG547' AND u.NDA_MAL_HDP='0055')
)


-- [brand_form_rxcui] identified
UPDATE u
SET brand_form_RXCUI = f.form_rxcui, u.SBD_Version = f.form_descr
-- select ''''+f.form_rxcui+''',', r.[NDA_MAL_HDP], f.form_descr, u.[ug_NAME OF DRUG], [ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[20220114ImportUgandaDrugs] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_rxcui]
where u.[brand_form_rxcui] is null and r.[brand_form_rxcui] is not null
and r.[brand_form_rxcui] != 'KEB8640' -- wrong mapping not corrected
and r.brand_name NOT IN ('ASP','Atrop','Cipro','Digox','Ery','Letroz','Nurifer','Terbin','Urso','Vitamin C')
AND u.[ug_NAME OF DRUG] NOT LIKE 'DICLOFENAC%'
AND u.[ug_NAME OF DRUG] != 'No Brand'
and f.form_rxcui in (

select [NDA_MAL_HDP], SBD_Version, [ug_NAME OF DRUG], [ug_STRENGTH OF DRUG] from Uganda_Drugs_2
where brand_form_RXCUI IN (
'KEB11680',
'KEB805',
'KEB4813',
'KEB14266',
'UGB0526',
'KEB13054',
'KEB822',
'KEB2676',
'1597127',
'KEB7994',
'KEB14269',
'KEB1360',
'UGB1182',
'KEB2338',
'KEB2325',
'KEB9581',
'824186',
'824190',
'UGB0588',
'KEB9110',
'KEB5976',
'1657068',
'1657074',
'KEB15658',
'KEB6822',
'213272',
'KEB5674A',
'KEB261',
'KEB1035',
'KEB3172',
'KEB938',
'KEB3101',
'KEB2142',
'KEB12154',
'213560',
'213707',
'KEB9416',
'1116639',
'KEB6402',
'KEB6405',
'KEB6292',
'KEB6455',
'KEB6487',
'KEB5193',
'UGB3569',
'402097',
'KEB10737',
'KEB540A',
'KEB547',
'KEB1505',
'KEB3715',
'KEB146',
'KEB1782',
'KEB241',
'KEB1493',
'KEB6385',
'KEB866',
'KEB1013',
'KEB2067',
'KEB8543',
'KEB2846',
'KEB2850',
'KEB6996',
'KEB3137',
'KEB3138',
'KEB4632',
'UGB1485',
'KEB7201',
'KEB7204',
'KEB4321',
'544840',
'KEB9301',
'UGB5316',
'KEB2132A',
'KEB11542',
'KEB5158',
'KEB1783',
'1102277',
'KEB3967',
'1658157',
'1799218',
'KEB5884',
'KEB1785',
'KEB10495',
'KEB10494',
'1232159',
'KEB553',
'KEB7260',
'KEB4560',
'KEB9496',
'KEB551A',
'UGB4536',
'KEB7818',
'KEB3055',
'KEB3056',
'KEB3051',
'KEB118',
'KEB108',
'KEB9632B',
'KEB144',
'1591949',
'KEB3785',
'KEB12071',
'758555',
'1250723',
'KEB1637',
'744846',
'KEB12503',
'KEB15752',
'KEB12504',
'KEB14014',
'KEB13592',
'KEB1295',
'KEB1296',
'KEB1163',
'KEB6431',
'1043567',
'1043574',
'KEB4304',
'KEB5799',
'285018',
'KEB5916PF',
'KEB10218',
'KEB4572',
'KEB297PF',
'404639',
'404637',
'404638',
'UGB7518',
'KEB4036',
'KEB601',
'617314',
'617318',
'KEB9258',
'KEB6502',
'KEB6499',
'KEB12063',
'UGB3694',
'KEB12950',
'UGB7439',
'UGB1012',
'UGB6454',
'KEB3133',
'KEB5326',
'KEB1279',
'KEB1277',
'KEB1036',
'KEB6494',
'807283',
'KEB7820',
'KEB3342',
'KEB3340',
'UGB3098',
'616450',
'616449',
'KEB7228',
'KEB6127',
'KEB849',
'KEB844',
'KEB845',
'KEB10944',
'615979',
'1743279',
'KEB13071',
'900577',
'KEB5445',
'KEB6093',
'KEB7123',
'KEB2260',
'KEB1699',
'UGB8692',
'1111341',
'KEB11621',
'KEB14159',
'UGB2753',
'824876',
'794610',
'KEB16545',
'UGB0434',
'KEB1179',
'UGB2990',
'KEB11824',
'KEB11823',
'KEB12396',
'UGB3204',
'KEB3349',
'207194',
'KEB3506',
'KEB2953',
'KEB10287',
'KEB7754',
'KEB423',
'KEB10886',
'KEB6245',
'861715',
'KEB5805',
'KEB7593',
'1002300',
'1860486',
'KEB3657',
'308971',
'KEB2207',
'1433879',
'KEB10765',
'KEB13141',
'KEB4064',
'261360',
'UGB7190',
'1858267',
'KEB13983',
'213270',
'KEB4522',
'855659',
'KEB1472',
'KEB1472',
'KEB1472',
'KEB1472',
'KEB5963',
'KEB143',
'KEB4650',
'KEB4655',
'KEB1041',
'KEB15379',
'KEB3675',
'KEB3681',
'KEB3684',
'KEB4096',
'KEB10760',
'351945'
)

update Uganda_Drugs_2 
set brand_form_RXCUI = NULL, sbd_version = null
where NDA_MAL_HDP in (
'3012','3415',
'5112','7517','5176',
'5486','2568','8685')
