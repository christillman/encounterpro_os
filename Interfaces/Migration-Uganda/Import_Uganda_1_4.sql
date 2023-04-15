select reviewed, count(*)
from uganda_drugs
group by reviewed

select reviewed, count(*)
from uganda_drugs_2
group by reviewed

update [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
set [Reviewed or Not Reviewed] = 4
where [Reviewed or Not Reviewed] = 5

select u.brand_form_RXCUI, u.SBD_Version, f.form_descr 
from uganda_drugs u
join c_Drug_Formulation f on f.form_rxcui = u.brand_form_RXCUI
where reviewed between 1 and 4
and u.SBD_Version != f.form_descr 
order by u.SBD_Version

drop table Uganda_Drugs_bak
select * into Uganda_Drugs_bak
from Uganda_Drugs

select count(*) 
from Uganda_Drugs

select count(*) 
from Uganda_Drugs
where date_added = '2023-03-25'
group by reviewed
having count(*) > 1

-- Existing brand formulations
update f
set valid_in = f.valid_in + 'ug;'
-- select * 
from uganda_drugs u
join c_Drug_Formulation f on f.form_rxcui = u.brand_form_RXCUI
where valid_in not like '%ug;%'
-- 41

-- Existing brand formulations going into c_Drug_Source_Formulation
insert into c_Drug_Source_Formulation
select * from uganda_drugs u
join c_Drug_Formulation f on f.form_rxcui = u.brand_form_RXCUI
left join c_Drug_Source_Formulation s ON s.brand_form_rxcui = u.brand_form_RXCUI
where reviewed between 1 and 4
-- 256
and s.brand_form_rxcui IS NULL
-- 19

-- Existing generic formulations
update f
set valid_in = f.valid_in + 'ug;'
-- select * 
from uganda_drugs u
join c_Drug_Formulation f on f.form_rxcui = u.generic_form_RXCUI
where valid_in not like '%ug;%'
-- 132

-- Existing generic formulations going into c_Drug_Source_Formulation
insert into c_Drug_Source_Formulation
select * from uganda_drugs u
join c_Drug_Formulation f on f.form_rxcui = u.generic_form_RXCUI
left join c_Drug_Source_Formulation s ON s.generic_form_RXCUI = u.generic_form_RXCUI
where reviewed between 1 and 4
-- 693
and s.generic_form_RXCUI IS NULL
-- 51

-- New Brand formulation
select u.brand_form_RXCUI, u.SBD_Version 
from uganda_drugs u
left join c_Drug_Formulation f on f.form_rxcui = u.brand_form_RXCUI
where reviewed between 1 and 4
and f.form_rxcui is NULL
and u.brand_form_RXCUI IS NOT NULL
and u.SBD_Version IS NOT NULL
order by u.SBD_Version
-- 157

-- New Generic formulation
select u.generic_form_RXCUI, u.SCD_PSN_Version
from uganda_drugs u
left join c_Drug_Formulation f on f.form_rxcui = u.generic_form_RXCUI
where reviewed between 1 and 4
and f.form_rxcui is NULL
and u.brand_form_RXCUI IS NULL
and u.SCD_PSN_Version IS NOT NULL
and u.generic_form_RXCUI IS NOT NULL
order by u.SCD_PSN_Version
 -- 7

select u.*
from uganda_drugs u
join [dbo].[202303_UgandaNumbers] n on n.nda = u.NDA_MAL_HDP
join uganda_drugs_2 u2 on n.nda = u2.NDA_MAL_HDP
where u.brand_form_RXCUI is null
and u.generic_form_RXCUI is null
and u.reviewed > 0

select * from uganda_drugs
where NDA_MAL_HDP = '3723'

select count(*) from [dbo].[202303_UgandaNumbers] n 
join uganda_drugs_2 u on n.nda = u.NDA_MAL_HDP
where u.NDA_MAL_HDP is null

select distinct [Corrected SCD_PSN_Version], SCD_PSN_Version
from uganda_drugs_2
where reviewed = 99
and [Corrected SCD_PSN_Version] != SCD_PSN_Version

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

select * 
into [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised-2superceded]
from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] u1
where exists (select 1 
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

delete u1
from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] u1
where exists (select 1 
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)


select * 
into [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised-3superceded]
from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] u1
where exists (select 1 
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

delete u1
from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] u1
where exists (select 1 
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

select * 
into [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 2-3superceded]
from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u1
where exists (select 1 
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

delete u1
from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u1
where exists (select 1 
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)
	

select * 
into [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 2-4superceded]
from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u1
where exists (select 1 
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

delete u1
from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2] u1
where exists (select 1 
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)
	

select * 
into [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 3-4superceded]
from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u1
where exists (select 1 
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
	)

delete u1
from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3] u1
where exists (select 1 
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4] u2
	where u2.NDA_MAL_HDP = u1.NDA_MAL_HDP
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

	  
with correct_SBD as (
	select r.[NDA_MAL_HDP], r.[correction SBD_Version]
	from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
	where [correction SBD_Version] is not null
	union 
	select [NDA_MAL_HDP], [correction SBD_Version]
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2]
	where [correction SBD_Version] is not null
	
	union 
	select [NDA_MAL_HDP], [correction SBD_Version]
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
	where [correction SBD_Version] is not null
	
	union 
	select [NDA_MAL_HDP], [SBD_Version Correction]
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
	where [SBD_Version Correction] is not null
)
update u SET SBD_Version = r.[correction SBD_Version]
-- select r.[NDA_MAL_HDP], r.[correction SBD_Version]
from correct_SBD r
join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.SBD_Version is null

  
with correct_SBD as (
	select r.[NDA_MAL_HDP], r.[matching KE or US rxcui]
	from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
	where [matching KE or US rxcui] is not null
	union 
	select [NDA_MAL_HDP], [matching KE or US rxcui]
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2]
	where [matching KE or US rxcui] is not null
	union 
	select [NDA_MAL_HDP], [matching KE or US rxcui]
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
	where [matching KE or US rxcui] is not null	
	union 
	select [NDA_MAL_HDP], [brand_form_RXCUI2_Correction]
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
	where [brand_form_RXCUI2_Correction] is not null
)
update u SET brand_form_RXCUI = r.[matching KE or US rxcui]
-- select r.[NDA_MAL_HDP], r.[matching KE or US rxcui]
from correct_SBD r
join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.brand_form_RXCUI is null


with correct_SCD as (
	select r.[NDA_MAL_HDP], [Corrected SCD_PSN_Version]
	from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
	where [Corrected SCD_PSN_Version] is not null
	union 
	select [NDA_MAL_HDP], [Corrected SCD_PSN_Version]
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2]
	where [Corrected SCD_PSN_Version] is not null
	union 
	select [NDA_MAL_HDP], [Corrected SCD_PSN_Version]
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
	where [Corrected SCD_PSN_Version] is not null	
	union 
	select [NDA_MAL_HDP], [SCD_PSN_Version_Correction]
	from [dbo].[08_01_2022_UgandaDrugs_Massaged_Review4]
	where [SCD_PSN_Version_Correction] is not null
)
update u SET SCD_PSN_Version = r.[Corrected SCD_PSN_Version]
-- select r.[NDA_MAL_HDP], r.[Corrected SCD_PSN_Version]
from correct_SCD r
join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.SCD_PSN_Version is null

update [06_07_2022_UgandaDrugs_Massaged_Review 2]
set [Corrected ingr_rxcui] = NULL
where [Corrected ingr_rxcui] = 'No matches to rxnorm ingredient or kenya ingredient'

with correct_ingr_rxci as (
	select r.[NDA_MAL_HDP], r.[Corrected ingr_rxcui]
	from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
	where [Corrected ingr_rxcui] is not null
	union 
	select [NDA_MAL_HDP], [Corrected ingr_rxcui]
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2]
	where [Corrected ingr_rxcui] is not null
	union 
	select [NDA_MAL_HDP], [Corrected ingr_rxcui]
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
	where [Corrected ingr_rxcui] is not null	
)
update u SET generic_ingr_RXCUI = r.[Corrected ingr_rxcui]
-- select r.[NDA_MAL_HDP], r.[Corrected ingr_rxcui]
from correct_ingr_rxci r
join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.generic_ingr_RXCUI is null


with ingr as (
	select r.[NDA_MAL_HDP], r.[Corrected Ingredient]
	from [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r
	where [Corrected Ingredient] is not null
	union 
	select [NDA_MAL_HDP], [Corrected Ingredient]
	from [dbo].[06_07_2022_UgandaDrugs_Massaged_Review 2]
	where [Corrected Ingredient] is not null
	union 
	select [NDA_MAL_HDP], [Corrected Ingredient]
	from [dbo].[06_27_2022_UgandaDrugs_Massaged_Review 3]
	where [Corrected Ingredient] is not null	
)
update u SET generic_name = r.[Corrected Ingredient]
-- select r.[NDA_MAL_HDP], r.[Corrected Ingredient]
from ingr r
join [Uganda_Drugs] u 
	on u.NDA_MAL_HDP = r.NDA_MAL_HDP
where u.generic_name is null


select * 
into uganda_drugs_bak2
from uganda_drugs