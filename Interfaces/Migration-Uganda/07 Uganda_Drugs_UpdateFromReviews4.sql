

insert into [2023_Review1_Discontinued] (
	 [NDA_MAL_HDP]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[SBD_Version Correction]
      ,[brand_form_RXCUI2_Correction]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[SCD_PSN_Version_Correction]
      ,[Comments: Ciru]
      ,[Reviewed]
)
SELECT distinct [NDA_MAL_HDP]
      ,[SBD_Version Correction]
      ,[brand_form_RXCUI2_Correction]
      ,[SBD_Version Correction]
      ,[brand_form_RXCUI2_Correction]
      ,[SCD_PSN_Version_Correction]
      ,[generic_form_RXCUI2_Correction]
      ,[SCD_PSN_Version_Correction]
      ,[Kenya Matches]
      ,4
from [08_01_2022_UgandaDrugs_Massaged_Review4] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null
-- 22

delete r
from [08_01_2022_UgandaDrugs_Massaged_Review4] r
left join [202303_UgandaNumbers] n 
	on n.[NDA] = r.NDA_MAL_HDP
where n.[NDA] is null

update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [brand_form_RXCUI2_Correction] = NULL
where [brand_form_RXCUI2_Correction] in ('N/A','NA')
or [brand_form_RXCUI2_Correction] like 'No %'

update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [generic_form_RXCUI2_Correction] = NULL
where [generic_form_RXCUI2_Correction] in ('N/A','NA')
or [generic_form_RXCUI2_Correction] like 'No %'

update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [SBD_Version Correction] = NULL
where [SBD_Version Correction] in ('N/A','NA')
or [SBD_Version Correction] like 'No %'


update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [brand_form_RXCUI2_Correction] = NULL
 -- select * from [08_01_2022_UgandaDrugs_Massaged_Review4]
where [brand_form_RXCUI2_Correction] like '[HN]%'


update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [generic_form_RXCUI2_Correction] = NULL, [Comments: Ciru] = isnull([Comments: Ciru],'') + '; generic form ' + [generic_form_RXCUI2_Correction]
 -- select * from [08_01_2022_UgandaDrugs_Massaged_Review4]
where [generic_form_RXCUI2_Correction] like '[HN]%'
or [generic_form_RXCUI2_Correction] like 'Obsol%'


select distinct r.[brand_form_RXCUI2_Correction] 
from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r
left join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_RXCUI2_Correction]
left join [dbo].[NewKenyaDrugs_Review123] n ON 'KEB' + n.[Kenya Retention No] = r.[brand_form_RXCUI2_Correction]
where f.form_rxcui is null 
and n.[Kenya Retention No] is null
order by r.[brand_form_RXCUI2_Correction]

insert into [Uganda_Drugs] (
 [NDA_MAL_HDP]
	,[ug_NAME OF DRUG]
	,[ug_GENERIC_NAME OF DRUG]
	,[ug_STRENGTH OF DRUG]
      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[date_added]
      ,[reviewed]
	  )
SELECT DISTINCT r.[NDA_MAL_HDP]
	,r.[ug_NAME OF DRUG]
	,r.[ug_GENERIC_NAME OF DRUG]
	,r.[ug_STRENGTH OF DRUG]
      ,r.[SBD_Version Correction]
      ,r.[brand_form_RXCUI2_Correction]
      ,r.[SCD_PSN_Version_Correction]
      ,r.[generic_form_RXCUI2_Correction]
      ,'2023-03-25'
      ,4
from [08_01_2022_UgandaDrugs_Massaged_Review4] r
left join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.NDA_MAL_HDP is null
order by r.[NDA_MAL_HDP]



select distinct r.[brand_form_RXCUI2_Correction] 
from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r
left join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_RXCUI2_Correction]
left join [dbo].[NewKenyaDrugs_Review123] n ON 'KEB' + n.[Kenya Retention No] = r.[brand_form_RXCUI2_Correction]
where f.form_rxcui is null and r.[brand_form_RXCUI2_Correction] is not null
and n.[Kenya Retention No] is null
order by r.[brand_form_RXCUI2_Correction]



-- [brand_form_rxcui] identified
UPDATE u
SET brand_form_RXCUI = f.form_rxcui, u.SBD_Version = f.form_descr, reviewed = 4
-- select  r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_RXCUI2_Correction], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[SBD_Version Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_RXCUI2_Correction]
where u.[brand_form_rxcui] is null and r.[brand_form_RXCUI2_Correction] is not null
AND u.SBD_Version IS  NULL
and u.reviewed = 0

-- [brand_form_RXCUI2_Correction] identified
UPDATE u
SET brand_form_RXCUI = f.form_rxcui, u.SBD_Version = f.form_descr, reviewed = 4
-- select  r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_RXCUI2_Correction], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[SBD_Version Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_RXCUI2_Correction]
where u.[brand_form_rxcui] != r.[brand_form_RXCUI2_Correction]
and u.reviewed = 0

-- [brand_form_rxcui] identified
UPDATE u
SET brand_form_RXCUI = f.form_rxcui, u.SBD_Version = f.form_descr
-- select r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_RXCUI2_Correction], u.SBD_Version, f.form_descr, u.[ug_NAME OF DRUG], r.[ug_STRENGTH OF DRUG], r.[SBD_Version Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[brand_form_RXCUI2_Correction]
where u.[brand_form_rxcui] is null and r.[brand_form_RXCUI2_Correction] is not null
AND r.[SBD_Version Correction] IS NULL
and r.[brand_form_RXCUI2_Correction] != 'KEB8640' -- wrong mapping not corrected

-- brand_form_rxcui provided, not yet in c_Drug_Formulation
UPDATE u
SET brand_form_RXCUI = r.[brand_form_RXCUI2_Correction], u.SBD_Version = [SBD_Version Correction], reviewed = 4
-- select u.reviewed, r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_RXCUI2_Correction], u.SBD_Version, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[brand_form_RXCUI2_Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[brand_form_rxcui] is null and r.[brand_form_RXCUI2_Correction] is not null

-- brand_form_rxcui correction, not yet in c_Drug_Formulation
UPDATE u
SET brand_form_RXCUI = r.[brand_form_RXCUI2_Correction], u.SBD_Version = [SBD_Version Correction], reviewed = 4
-- select u.reviewed, r.[NDA_MAL_HDP], u.brand_form_RXCUI, r.[brand_form_RXCUI2_Correction], u.SBD_Version, u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], r.[brand_form_RXCUI2_Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[brand_form_rxcui] != r.[brand_form_RXCUI2_Correction]


-- [generic_form_RXCUI2_Correction] identified
UPDATE u
SET [generic_form_rxcui] = r.[generic_form_RXCUI2_Correction], u.SCD_PSN_Version = r.[SCD_PSN_Version_Correction], reviewed = 4
-- select r.[dosage form], r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[generic_form_RXCUI2_Correction], r.[SCD_PSN_Version_Correction], f.form_descr, u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[generic_form_RXCUI2_Correction]
where u.[generic_form_rxcui] is null and r.[generic_form_RXCUI2_Correction] is not null
and u.reviewed = 0


-- [generic_form_RXCUI2_Correction] identified as correction
UPDATE u
SET [generic_form_rxcui] = r.[generic_form_RXCUI2_Correction], u.SCD_PSN_Version = [SCD_PSN_Version_Correction], reviewed = 4
-- select u.reviewed, r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[generic_form_RXCUI2_Correction], u.SCD_PSN_Version, u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[generic_form_rxcui] is null and r.[generic_form_RXCUI2_Correction] is not null
and [SCD_PSN_Version_Correction] is not null
and u.reviewed in ( 0, 4)

-- [generic_form_rxcui] differs from [generic_form_RXCUI2_Correction]
UPDATE u
SET [generic_form_rxcui] = f.form_rxcui, u.SCD_PSN_Version = f.form_descr, reviewed = 4
-- select u.reviewed,  r.[NDA_MAL_HDP], u.[generic_form_rxcui], r.[generic_form_RXCUI2_Correction], u.SCD_PSN_Version, f.form_descr, u.[ug_GENERIC_NAME OF DRUG], u.[ug_STRENGTH OF DRUG]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
join c_Drug_Formulation f ON f.form_rxcui = r.[generic_form_RXCUI2_Correction]
where u.[generic_form_rxcui] != [generic_form_RXCUI2_Correction]
and u.reviewed in ( 0, 4)


update u 
set reviewed = 4
-- select r.*, u.* 
from Uganda_Drugs_2 u  
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where r.[Reviewed or Not Reviewed] != u.reviewed


-- Compare resulting columns for reviews items

select u.NDA_MAL_HDP, u.generic_form_rxcui, u.SCD_PSN_Version, r.[generic_form_RXCUI2_Correction], r.[SCD_PSN_Version_Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 4
and u.generic_form_rxcui != r.[generic_form_RXCUI2_Correction]
order by u.SBD_Version


select u.NDA_MAL_HDP, u.brand_form_rxcui, u.SBD_Version, r.[brand_form_RXCUI2_Correction], r.[SBD_Version Correction]
from [Uganda_Drugs] u
join [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.reviewed = 4
and u.brand_form_rxcui != r.[brand_form_RXCUI2_Correction]
order by u.SBD_Version

