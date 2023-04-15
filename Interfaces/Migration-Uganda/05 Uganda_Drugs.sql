
-- Add lines to process_Uganda.sh for re-wrapped drug names
select distinct
	'sed ''s/' + replace(replace(u.[Generic Name of Drug],'/',' *\/ *'),'  ',' ')
	 + '/' + replace(UPPER(g.generic_name),'/','\/') + '/g'' | \'
from UgandaJun2022 u
join c_Drug_Generic g on replace(g.generic_name,' ','') = replace(u.[Generic Name of Drug],' ','')
where g.generic_name != u.[Generic Name of Drug]
order by 1

-- Add lines to process_Uganda.sh for spacing problems around the /
select u.[Generic Name of Drug],
	'sed ''s/' + replace(replace(replace(u.[Generic Name of Drug],'/',' *\/ *'),'  ',' '),' * ',' *')
	 + '/' + replace(replace(u.[Generic Name of Drug],'/',' \/ ')  + '/g'' | \','  ',' ')
from UgandaJun2022 u
where u.[Generic Name of Drug] like '%[A-Z]/%' 
	OR u.[Generic Name of Drug] like '%/[A-Z]%'
order by 1

-- Iterate to eliminate above problems

UPDATE UgandaJun2022
SET [NDA REGISTRATION NUMBER] = right([NDA REGISTRATION NUMBER],4)
WHERE [NDA REGISTRATION NUMBER] LIKE '0%'
AND len([NDA REGISTRATION NUMBER]) = 5

--drop table #form_equiv
create table #form_equiv (generic_rxcui varchar(30), generic_name varchar(1000), form_name varchar(1000), long_name varchar(1000))
INSERT INTO #form_equiv
SELECT generic_rxcui, generic_name, dbo.fn_ingredients(form_descr) AS form_name, '' as long_name
FROM c_Drug_Generic g
JOIN c_Drug_Formulation f ON f.ingr_rxcui = g.generic_rxcui
WHERE generic_name != dbo.fn_ingredients(form_descr)
-- AND dbo.fn_ingredients(form_descr) LIKE '%' + generic_name + '%'
and len(generic_name) < len(dbo.fn_ingredients(form_descr))
and f.form_descr not like '%(%'
and f.form_descr not like '% as %'
and f.form_descr not like '% atten %'
and f.form_descr not like '% virus %'
and f.form_descr not like '% vaccine %'
-- prevent duplicates
and generic_rxcui not in ('KEGI3456','11258','1008584','KEGI8701','1008064','683','42954')
GROUP BY generic_rxcui, generic_name, dbo.fn_ingredients(form_descr)
-- (1519 rows affected)

update #form_equiv
SET form_name = 'methohexital sodium'
where form_name = 'methohexital sodium Variable Concentration Multi-Use Injectable Solution'

update #form_equiv
SET long_name = replace(replace(form_name,' HCl',' hydrochloride'),' HBr',' hydrobromide')
where form_name like '% HCl%'
or form_name like '% HBr%'
-- (617 rows affected)

update #form_equiv
SET long_name = replace(replace(form_name,' Cl',' chloride'),' Br',' bromide')
from #form_equiv
where form_name like '% Cl%'
or form_name like '% Br%'
-- (62 rows affected)

update #form_equiv
SET form_name = replace(form_name,' equivalent','')
from #form_equiv
where form_name like '% equivalent%'
/*
generics without forms
select '('''+g.generic_rxcui+''','''+replace(g.generic_name,'''','''''')+''',''''),'
from c_Drug_Generic g
left join #form_equiv e on e.generic_rxcui = g.generic_rxcui
where e.generic_rxcui is null
and g.generic_name not like '%/%'
order by g.generic_name
*/
/*
select distinct generic_rxcui, generic_name, form_name 
from #form_equiv
order by generic_name, form_name


select distinct [GENERIC NAME OF DRUG],
'(''' + g.generic_rxcui + ''', ''' + dbo.fn_first_words([GENERIC NAME OF DRUG],1) + ''',''' + [GENERIC NAME OF DRUG] + '''),'
from UgandaJun2022 u
left join c_Drug_Generic g on g.generic_name = dbo.fn_first_words([GENERIC NAME OF DRUG],1)
where ([GENERIC NAME OF DRUG] LIKE '% HCL'
OR [GENERIC NAME OF DRUG] LIKE '% HBR'
OR [GENERIC NAME OF DRUG] LIKE '% AN *HYDROUS'
OR [GENERIC NAME OF DRUG] LIKE '% CRYSTALS'
OR [GENERIC NAME OF DRUG] LIKE '% DIHYDRATE'
OR [GENERIC NAME OF DRUG] LIKE '% DIHYDROCHLORIDE'
OR [GENERIC NAME OF DRUG] LIKE '% DIPROPRIONATE'
OR [GENERIC NAME OF DRUG] LIKE '% DIPROPIONATE'
OR [GENERIC NAME OF DRUG] LIKE '% ENANTHATE'
OR [GENERIC NAME OF DRUG] LIKE '% HEMIFUMARATE'
OR [GENERIC NAME OF DRUG] LIKE '% HEMIHYDRATE'
OR [GENERIC NAME OF DRUG] LIKE '% HEXANOATE'
OR [GENERIC NAME OF DRUG] LIKE '% HYDROBROMIDE'
OR [GENERIC NAME OF DRUG] LIKE '% HYDROCHLORIDE'
OR [GENERIC NAME OF DRUG] LIKE '% MALEATE'
OR [GENERIC NAME OF DRUG] LIKE '% MONOHYDRATE'
OR [GENERIC NAME OF DRUG] LIKE '% MONOHYDROCHLO *RIDE'
OR [GENERIC NAME OF DRUG] LIKE '% PALMITATE'
OR [GENERIC NAME OF DRUG] LIKE '% PROPRIONATE'
OR [GENERIC NAME OF DRUG] LIKE '% PROPIONATE'
OR [GENERIC NAME OF DRUG] LIKE '% SULPHONATE'
OR [GENERIC NAME OF DRUG] LIKE '% TRIHYDRATE'
OR [GENERIC NAME OF DRUG] LIKE '% VALERATE')
and [GENERIC NAME OF DRUG] not in (select form_name from #form_equiv)
order by [GENERIC NAME OF DRUG]
*/
/*
select * from #form_equiv where form_name in (
select form_name from #form_equiv
group by form_name having count(*) > 1
) 
order by form_name
*/

insert into #form_equiv (generic_rxcui, generic_name, form_name, long_name) VALUES 
('KEGI15339', 'BENZHEXOL','BENZHEXOL HCL','BENZHEXOL HYDROCHLORIDE'),
('3289', 'DEXTROMETHORPHAN','DEXTROMETHORPHAN HCL','DEXTROMETHORPHAN HYDROCHLORIDE'),
('31555', 'NEBIVOLOL','NEBIVOLOL HCL','NEBIVOLOL HYDROCHLORIDE'),
('33738', 'PIOGLITAZONE','PIOGLITAZONE HCL','PIOGLITAZONE HYDROCHLORIDE')

insert into #form_equiv (generic_rxcui, generic_name, form_name) VALUES 
('8340', 'PIPERAZINE','ACEFYLINE PIPERAZINE'),
('17300', 'ALFUZOSIN','ALFUZOSIN HYDROCHLORIDE'),
('438399', 'AMBROXOL','AMBROXOL HYDROCHLORIDE'),
('704', 'AMITRIPTYLINE','AMITRIPTYLINE HYDROCHLORIDE'),
('17767', 'AMLODIPINE','AMLODIPINE MESILATE MONOHYDRATE'),
('KEGI8142', 'AMODIAQUINE','AMODIAQUINE HYDROCHLORIDE'),
('723', 'AMOXICILLIN','AMOXICILLIN SODIUM'),
('723', 'AMOXICILLIN','AMOXICILLIN TRIHYDRATE'),
('733', 'AMPICILLIN','AMPICILLIN SODIUM'),
('733', 'AMPICILLIN','AMPICILLIN TRIHYDRATE'),
('83367', 'ATORVASTATIN','ATORVASTATIN CALCIUM TRIHYDRATE'),
('18603', 'AZELASTINE','AZELASTINE HYDROCHLORIDE'),
('18631', 'AZITHROMYCIN','AZITHROMYCIN DIHYDRATE'),
('18631', 'AZITHROMYCIN','AZITHROMYCIN MONOHYDRATE'),
('1514', 'BETAMETHASONE','BETAMETHASONE DIPROPRIONATE'),
('1514', 'BETAMETHASONE','BETAMETHASONE DISODIUM PHOSPHATE'),
('19484', 'BISOPROLOL','BISOPROLOL HEMIFUMARATE'),
('75207', 'BOSENTAN','BOSENTAN MONOHYDRATE'),
('1753', 'BROMHEXINE','BROMHEXINE HYDROCHLORIDE'),
('1815', 'BUPIVACAINE','BUPIVACAINE HYDROCHLORIDE'),
('29365', 'CALCIPOTRIENE','CALCIPOTRIENE MONOHYDRATE'),
('2176', 'CEFACLOR','CEFACLOR MONOHYDRATE'),
('KEGI1420', 'CEFALEXIN','CEFALEXIN MONOHYDRATE'),
('20481', 'CEFEPIME','CEFEPIME HYDROCHLORIDE'),
('25033', 'CEFIXIME','CEFIXIME TRIHYDRATE'),
('2231', 'CEPHALEXIN','CEPHALEXIN MONOHYDRATE'),
('20610', 'CETIRIZINE','CETIRIZINE HYDROCHLORIDE'),
('2400', 'CHLORPHENIRAMINE','CHLORPHENIRAMINE HYDROCHLORIDE'),
('2403', 'CHLORPROMAZINE','CHLORPROMAZINE HYDROCHLORIDE'),
('2551', 'CIPROFLOXACIN','CIPROFLOXACIN HYDROCHLORIDE'),
('2582', 'CLINDAMYCIN','CLINDAMYCIN HYDROCHLORIDE'),
('3001', 'CYCLOPENTOLATE','CYCLOPENTOLATE HYDROCHLORIDE'),
('3013', 'CYPROHEPTADINE','CYPROHEPTADINE HYDROCHLORIDE'),
('KEGI15680', 'DAPOXETINE','DAPOXETINE HYDROCHLORIDE'),
('3361', 'DICYCLOMINE','DICYCLOMINE HYDROCHLORIDE'),
('3443', 'DILTIAZEM','DILTIAZEM HYDROCHLORIDE'),
('72962', 'DOCETAXEL','DOCETAXEL TRIHYDRATE'),
('1433868', 'DOLUTEGRAVIR','DOLUTEGRAVIR SODIUM'),
('3626', 'DOMPERIDONE','DOMPERIDONE MALEATE'),
('3628', 'DOPAMINE','DOPAMINE HYDROCHLORIDE'),
('60207', 'DORZOLAMIDE','DORZOLAMIDE HYDROCHLORIDE'),
('3639', 'DOXORUBICIN','DOXORUBICIN HYDROCHLORIDE'),
('3640', 'DOXYCYCLINE','DOXYCYCLINE HYDROCHLORIDE'),
('KEGI5481', 'DROTAVERINE','DROTAVERINE HYDROCHLORIDE'),
('306266', 'ENTECAVIR','ENTECAVIR MONOHYDRATE'),
('3966', 'EPHEDRINE','EPHEDRINE HYDROCHLORIDE'),
('3995', 'EPIRUBICIN','EPIRUBICIN HYDROCHLORIDE'),
('337525', 'ERLOTINIB','ERLOTINIB HYDROCHLORIDE'),
('283742', 'ESOMEPRAZOLE','ESOMEPRAZOLE MAGNESIUM TRIHYDRATE'),
('4083', 'ESTRADIOL','ESTRADIOL HEMIHYDRATE'),
('4110', 'ETHAMBUTOL','ETHAMBUTOL HYDROCHLORIDE'),
('87636', 'FEXOFENADINE','FEXOFENADINE HYDROCHLORIDE'),
('KEGI1534', 'FLUCLOXACILLIN','FLUCLOXACILLIN SODIUM'),
('4493', 'FLUOXETINE','FLUOXETINE HYDROCHLORIDE'),
('4815', 'GLYBURIDE','GLYBURIDE / METFORMIN HYDROCHLORIDE'),
('26237', 'GRANISETRON','GRANISETRON HYDROCHLORIDE'),
('5470', 'HYDRALAZINE','HYDRALAZINE HYDROCHLORIDE'),
('KEGI1191B', 'HYDROXYPROGESTERONE','HYDROXYPROGESTERONE HEXANOATE'),
('51499', 'IRINOTECAN','IRINOTECAN HYDROCHLORIDE TRIHYDRATE'),
('1649480', 'IVABRADINE','IVABRADINE HYDROCHLORIDE'),
('6130', 'KETAMINE','KETAMINE HYDROCHLORIDE'),
('KEGI10680', 'LEVAMISOLE','LEVAMISOLE HYDROCHLORIDE'),
('356887', 'LEVOCETIRIZINE','LEVOCETIRIZINE HYDROCHLORIDE'),
('82122', 'LEVOFLOXACIN','LEVOFLOXACIN HEMIHYDRATE'),
('6387', 'LIDOCAINE','LIDOCAINE HYDROCHLORIDE'),
('29046', 'LISINOPRIL','LISINOPRIL DIHYDRATE'),
('28872', 'LOMEFLOXACIN','LOMEFLOXACIN HYDROCHLORIDE'),
('6468', 'LOPERAMIDE','LOPERAMIDE HYDROCHLORIDE'),
('29561', 'MEROPENEM','MEROPENEM TRIHYDRATE'),
('6809', 'METFORMIN','METFORMIN HYDROCHLORIDE'),
('6915', 'METOCLOPRAMIDE','METOCLOPRAMIDE HYDROCHLORIDE'),
('108118', 'MOMETASONE','MOMETASONE FUROATE MONOHYDRATE'),
('139462', 'MOXIFLOXACIN','MOXIFLOXACIN HYDROCHLORIDE'),
('7242', 'NALOXONE','NALOXONE HYDROCHLORIDE'),
('7243', 'NALTREXONE','NALTREXONE HYDROCHLORIDE'),
('662281', 'NILOTINIB','NILOTINIB HYDROCHLORIDE MONOHYDRATE'),
('7514', 'NORETHINDRONE','NORETHINDRONE ENANTHATE'),
('135391', 'OLOPATADINE','OLOPATADINE HYDROCHLORIDE'),
('26225', 'ONDANSETRON','ONDANSETRON HYDROCHLORIDE'),
('26225', 'ONDANSETRON','ONDANSETRON HYDROCHLORIDE DIHYDRATE'),
('7812', 'OXYMETAZOLINE','OXYMETAZOLINE HYDROCHLORIDE'),
('70561', 'PALONOSETRON','PALONOSETRON HYDROCHLORIDE'),
('KEGI477', 'PEFLOXACIN','PEFLOXACIN MESILATE DIHYDRATE'),
('KEGI11621', 'PHLOROGLUCINOL','PHLOROGLUCINOL DIHYDRATE'),
('7531', 'NORTRIPTYLINE','NORTRIPTYLINE HYDROCHLORIDE'),
('8745', 'PROMETHAZINE','PROMETHAZINE HYDROCHLORIDE'),
('8787', 'PROPRANOLOL','PROPRANOLOL HYDROCHLORIDE'),
('9071', 'QUININE','QUININE HYDROCHLORIDE'),
('9143', 'RANITIDINE','RANITIDINE HYDROCHLORIDE'),
('1102270', 'RILPIVIRINE','RILPIVIRINE HYDROCHLORIDE'),
('42316', 'TACROLIMUS','TACROLIMUS MONOHYDRATE'),
('77492', 'TAMSULOSIN','TAMSULOSIN HYDROCHLORIDE'),
('37801', 'TERBINAFINE','TERBINAFINE HYDROCHLORIDE'),
('1721603', 'TENOFOVIR ALAFENAMIDE','TENOFOVIR ALAFENAMIDE HEMIFUMARATE'),
('10395', 'TETRACYCLINE','TETRACYCLINE HYDROCHLORIDE'),
('73137', 'TIROFIBAN','TIROFIBAN HYDROCHLORIDE'),
('10689', 'TRAMADOL','TRAMADOL HYDROCHLORIDE'),
('10800', 'TRIFLUOPERAZINE','TRIFLUOPERAZINE HYDROCHLORIDE'),
('10811', 'TRIHEXYPHENIDYL','TRIHEXYPHENIDYL HYDROCHLORIDE'),
('10849', 'TRIPROLIDINE','TRIPROLIDINE HYDROCHLORIDE'),
('11124', 'VANCOMYCIN','VANCOMYCIN HYDROCHLORIDE'),
('306674', 'VARDENAFIL','VARDENAFIL MONOHYDROCHLORIDE TRIHYDRATE'),
('39841', 'XYLOMETAZOLINE','XYLOMETAZOLINE HYDROCHLORIDE')

-- drop table #ug_ingr
CREATE TABLE #ug_ingr (nda varchar(5), sort_order int, ingr varchar(1000), strg varchar(1000), epro_df varchar(100))

DECLARE @no varchar(5), @ingr varchar(1000), @strg varchar(1000), @df varchar(100)
DECLARE crs_ug CURSOR FOR 
	SELECT u.[NDA REGISTRATION NUMBER], u.[GENERIC NAME OF DRUG] , u.[STRENGTH OF DRUG], u.[DOSAGE FORM]
	from UgandaJun2022 u
	--where u.[GENERIC NAME OF DRUG] not like '%/%'

OPEN crs_ug
FETCH NEXT FROM crs_ug INTO @no, @ingr, @strg, @df
	
WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #ug_ingr
		select @no, sort_order, LTRIM(ingredient), LTRIM(strength), dbo.fn_ug_dosage_form(@df)
		from dbo.fn_ug_ingredient_list(@ingr, @strg)
		FETCH NEXT FROM crs_ug INTO @no, @ingr, @strg, @df
	END

CLOSE crs_ug
DEALLOCATE crs_ug

-- drop table #generic_form_ug
SELECT nda, STUFF((
	SELECT  ' / ' + lower(ingr) + ' ' + strg
	FROM #ug_ingr calc
	WHERE calc.NDA = base.NDA
	ORDER BY ingr
	FOR XML PATH('')), 1, 3, '') + ' ' + epro_df AS formulation
	INTO #generic_form_ug
FROM #ug_ingr base
GROUP BY NDA, epro_df



-- drop table #ep_ingr
CREATE TABLE #ep_ingr (form_rxcui varchar(30), sort_order int, ingr varchar(1000), strg varchar(1000), epro_df varchar(100))

DECLARE @form_rxcui varchar(30), @form_descr varchar(1000)
DECLARE crs_ep CURSOR FOR 
	SELECT form_rxcui, form_descr 
	from c_Drug_Formulation f
	join c_Drug_Generic g ON g.generic_rxcui = f.ingr_rxcui

OPEN crs_ep
FETCH NEXT FROM crs_ep INTO @form_rxcui, @form_descr

WHILE @@FETCH_STATUS = 0
	BEGIN
		-- print @form_rxcui
		INSERT INTO #ep_ingr
		select @form_rxcui, sort_order, LTRIM(ingredient), LTRIM(strength), dosage_form
		from dbo.fn_ingredient_list(@form_descr)
		FETCH NEXT FROM crs_ep INTO @form_rxcui, @form_descr
	END

CLOSE crs_ep
DEALLOCATE crs_ep

delete from #ep_ingr 
where strg = 'error'
--order by form_rxcui



-- drop table #generic_form_ep
SELECT form_rxcui, STUFF((
	SELECT  ' / ' + lower(ingr) + ' ' + strg
	FROM #ep_ingr calc
	WHERE calc.form_rxcui = base.form_rxcui
	ORDER BY ingr
	FOR XML PATH('')), 1, 3, '') + ' ' + epro_df AS formulation
	INTO #generic_form_ep
FROM #ep_ingr base
GROUP BY form_rxcui, epro_df

-- select * FROM #generic_form_ep

/*
select distinct strg
from #ug_ingr 
order by strg

with min_ingr as (
select nda, min(ingr) as ingr
from #ug_ingr
group by nda
)
select * from #ug_ingr i
join min_ingr m on m.nda = i.nda
	and i.ingr = m.ingr
-- 977
*/

-- drop table #ingr

SELECT nda, STUFF((
	SELECT  ' / ' + ingr
	FROM #ug_ingr calc
	WHERE calc.NDA = base.NDA
	ORDER BY ingr
	FOR XML PATH('')), 1, 3, '') AS ingredients
INTO #ingr
FROM #ug_ingr base
GROUP BY NDA
-- (3779 rows affected)

/*
select distinct ingredients 
from #ingr
order by ingredients
*/

DELETE FROM [Uganda_Drugs];

Insert into [Uganda_Drugs] (
	 [NDA_MAL_HDP]
      ,[ug_NAME OF DRUG]
      ,[ug_GENERIC_NAME OF DRUG]
      ,[ug_STRENGTH OF DRUG]
      ,[notes]
)
select u.[NDA Registration Number] as [NDA_MAL_HDP], 
	CASE WHEN u.[Name of Drug] = u.[Generic Name of Drug] THEN 'No Brand' 
		ELSE u.[Name of Drug] END,
	u.[Generic Name of Drug],
	u.[STRENGTH OF DRUG],
	u.[Dosage Form] + ' | ' + u.[Pack Size]
from UgandaJun2022 u

-- UPDATE [Uganda_Drugs] SET [generic_ingr_RXCUI] = NULL
UPDATE u 
SET [generic_ingr_RXCUI] = g.[generic_RXCUI],
	[generic_name] = g.[generic_name]
 -- select u.[NDA_MAL_HDP], count(*) 
from [Uganda_Drugs] u
JOIN c_Drug_Generic g on g.generic_name = u.[ug_GENERIC_NAME OF DRUG]
-- 1914

UPDATE u 
SET [generic_ingr_RXCUI] = g.[generic_RXCUI],
	[generic_name] = g.[generic_name]
 -- select g.[generic_name], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
JOIN c_Drug_Generic g on REPLACE(g.generic_name,' ','') = REPLACE(u.[ug_GENERIC_NAME OF DRUG],' ','')
WHERE u.[generic_ingr_RXCUI] IS NULL
-- 6


UPDATE u 
SET proposed_ingredients = i.ingredients
-- select distinct  u.[ug_GENERIC_NAME OF DRUG], i.ingredients
from [Uganda_Drugs_2] u
JOIN #ingr i ON u.NDA_MAL_HDP = i.nda
WHERE u.[generic_ingr_RXCUI] IS NULL

UPDATE u 
SET [generic_ingr_RXCUI] = g.[generic_RXCUI],
	[generic_name] = g.[generic_name]
 -- select distinct g.[generic_name], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
JOIN #ingr i ON u.NDA_MAL_HDP = i.nda
JOIN c_Drug_Generic g on g.generic_name = i.ingredients
WHERE u.[generic_ingr_RXCUI] IS NULL
-- (148 rows affected)



UPDATE u 
SET [generic_ingr_RXCUI] = e.[generic_RXCUI],
	[generic_name] = e.[generic_name]
 -- select distinct e.[generic_name], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
JOIN #form_equiv e on u.[ug_GENERIC_NAME OF DRUG] = e.form_name
WHERE u.[generic_ingr_RXCUI] IS NULL
-- (501 rows affected) + (171 rows affected)

UPDATE u 
SET [generic_ingr_RXCUI] = e.[generic_RXCUI],
	[generic_name] = e.[generic_name]
 -- select distinct e.[generic_name], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
JOIN #form_equiv e on u.[ug_GENERIC_NAME OF DRUG] = e.long_name
WHERE u.[generic_ingr_RXCUI] IS NULL
-- (202 rows affected) + 6

WITH generic_matches as (
	select u.NDA_MAL_HDP, g.[generic_RXCUI],g.generic_name, [ug_GENERIC_NAME OF DRUG]
	from [Uganda_Drugs] u
	JOIN #generic_form_ug i ON u.NDA_MAL_HDP = i.nda
	JOIN c_Drug_Formulation fg 
		on dbo.fn_ingredients(fg.form_descr) = dbo.fn_ingredients(i.formulation)
	JOIN c_Drug_Generic g ON g.generic_rxcui = fg.ingr_rxcui
	WHERE u.[generic_ingr_RXCUI] IS NULL
	group by u.NDA_MAL_HDP, g.[generic_RXCUI],g.generic_name, [ug_GENERIC_NAME OF DRUG]
)
UPDATE u 
SET [generic_ingr_RXCUI] = i.[generic_RXCUI],
	[generic_name] = i.[generic_name]
--  select distinct i.[generic_name], u.[ug_GENERIC_NAME OF DRUG]
from [Uganda_Drugs] u
JOIN generic_matches i ON u.NDA_MAL_HDP = i.NDA_MAL_HDP
WHERE u.[generic_ingr_RXCUI] IS NULL
-- (17 rows affected)

UPDATE u 
SET [generic_form_RXCUI] = fg.[form_RXCUI],
	[SCD_PSN_Version] = fg.form_descr,
	[generic_ingr_RXCUI] = g.[generic_RXCUI],
	[generic_name] = g.[generic_name]
 -- select u.[NDA_MAL_HDP] 
 -- select *
from [Uganda_Drugs] u
JOIN #generic_form_ug i ON u.NDA_MAL_HDP = i.nda
JOIN #generic_form_ep ep on ep.formulation = i.formulation
JOIN c_Drug_Formulation fg on fg.form_rxcui= ep.form_rxcui
JOIN c_Drug_Generic g ON g.generic_rxcui = fg.ingr_rxcui
WHERE u.[generic_form_RXCUI] IS NULL
-- (1139 rows affected)


UPDATE u 
SET proposed_generic_form_descr = i.formulation
-- select distinct  u.[ug_GENERIC_NAME OF DRUG], i.formulation
from [Uganda_Drugs_2] u
JOIN #generic_form_ug i ON u.NDA_MAL_HDP = i.nda
WHERE u.[generic_form_RXCUI] IS NULL


UPDATE u 
SET [brand_form_RXCUI] = fb.[form_RXCUI],
	[SBD_Version] = fb.form_descr,
	[brand_name_RXCUI] = b.[brand_name_RXCUI],
	[brand_name] = b.[brand_name]
-- select u.[NDA_MAL_HDP] , u.[ug_NAME OF DRUG] , b.brand_name , fb.*
from [Uganda_Drugs] u
join c_Drug_Formulation fg on fg.form_rxcui= u.[generic_form_RXCUI]
JOIN c_Drug_Brand b ON b.generic_rxcui = fg.ingr_rxcui
JOIN c_Drug_Formulation fb ON fb.generic_form_rxcui = fg.form_rxcui
	and fb.ingr_rxcui = b.brand_name_rxcui
WHERE u.[ug_NAME OF DRUG] like b.brand_name + ' %'
AND u.[brand_form_RXCUI] IS NULL
-- (98 rows affected)

select form_rxcui, form_descr from c_Drug_Formulation where [generic_form_RXCUI] in (
select  u.[generic_form_RXCUI] , [Matching corrected US or KE generic_rxcui] , u.*
from [Uganda_Drugs] u
join [05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
--join [06_07_2022_UgandaDrugs_Massaged_Review 2] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[generic_form_RXCUI] != [Matching corrected US or KE generic_rxcui]
and [Matching corrected US or KE generic_rxcui] != 'NULL'

alter table Uganda_Drugs drop constraint DF__Uganda_Dr__revie__3469E43F
go
select * into #ug_drugs from  Uganda_Drugs 

insert into Uganda_Drugs (
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
)
SELECT [NDA_MAL_HDP]
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
	  from #ug_drugs

select * from uganda_drugs
order by NDA_MAL_HDP

update u 
set reviewed = 1
from Uganda_Drugs u
join [dbo].[05_02_2022_UgandaDrugs_Massaged_Review 1-Revised] r on r.NDA_MAL_HDP = u.NDA_MAL_HDP

and (u.generic_ingr_RXCUI = [Corrected ingr_rxcui] or [Corrected ingr_rxcui] is null
	or u.generic_ingr_RXCUI = r.generic_ingr_RXCUI)

select * from 
[Uganda_Drugs] u
join [06_07_2022_UgandaDrugs_Massaged_Review 2] r on r.[NDA_MAL_HDP] = u.NDA_MAL_HDP
where u.[generic_form_RXCUI] = [Matching corrected US or KE generic_rxcui]
and (u.generic_ingr_RXCUI != [Corrected ingr_rxcui])

select distinct [ug_GENERIC_NAME OF DRUG] 
from [Uganda_Drugs]
where generic_name is  null

select * 
from #form_equiv
where form_name like '%AMOXYCILLIN%'

select * from c_Drug_Generic g
JOIN c_Drug_Formulation fg on fg.ingr_rxcui = g.generic_rxcui
where generic_rxcui IN ('KEGI424',	'KEGI1147')

      ,[SBD_Version]
      ,[brand_form_RXCUI]
      ,[SCD_PSN_Version]
      ,[generic_form_RXCUI]
      ,[generic_name]
      ,[generic_ingr_RXCUI]
      ,[brand_name]
      ,[brand_name_RXCUI]


join c_Drug_Brand b on u.[Name of Drug] like b.brand_name + '%' 

left left join c_Drug_Formulation fb on b.brand_name_rxcui = fb.ingr_rxcui
left join c_Drug_Formulation fg on fg.form_rxcui = fb.generic_form_rxcui


select distinct g.generic_name, u.[Generic Name of Drug], u.[Name of Drug], b.brand_name 
from UgandaJun2022 u
join c_Drug_Brand b on u.[Name of Drug] like b.brand_name + '%'
join c_Drug_Generic g on b.generic_rxcui = g.generic_rxcui
--join c_Synonym s on replace(g.generic_name,s.term,s.alternate) = u.[Generic Name of Drug]
where g.generic_name != u.[Generic Name of Drug]
order by 1


-- look for non-matching strength formulations
select * from [Uganda_Drugs] g
JOIN [Uganda_Drugs] g2 ON g2.generic_ingr_RXCUI = g.generic_ingr_RXCUI
	AND g2.NDA_MAL_HDP = g.NDA_MAL_HDP
	AND g.generic_form_RXCUI != g2.generic_form_RXCUI
WHERE g.SCD_PSN_Version like '%' + left(g.notes,6) + '%'
AND g2.SCD_PSN_Version not like '%' + left(g2.notes,6) + '%'
order by 1,2

drop table #rejects
select distinct g.*
--into #rejects
from [Uganda_Drugs] g
WHERE g.SCD_PSN_Version not like '%' + left(g.notes,6) + '%'
AND EXISTS (SELECT 1 
	FROM [Uganda_Drugs] g2 
	WHERE g2.generic_ingr_RXCUI = g.generic_ingr_RXCUI
	AND g2.NDA_MAL_HDP = g.NDA_MAL_HDP
	AND g.generic_form_RXCUI != g2.generic_form_RXCUI
	AND g2.SCD_PSN_Version like '%' + left(g2.notes,6) + '%'
	)

DELETE g 
FROM [Uganda_Drugs] g
JOIN #rejects r ON r.NDA_MAL_HDP = g.NDA_MAL_HDP
AND g.generic_form_RXCUI = r.generic_form_RXCUI
AND g.SCD_PSN_Version = r.SCD_PSN_Version

SELECT * 
FROM #rejects r
WHERE NOT EXISTS (SELECT 1 
FROM [Uganda_Drugs] g
	WHERE r.NDA_MAL_HDP = g.NDA_MAL_HDP 
	)

WITH mults AS (
	select NDA_MAL_HDP
	from [Uganda_Drugs]
	group by NDA_MAL_HDP
	having count(*) > 1
)
SELECT NDA_MAL_HDP, brand_form_RXCUI, SBD_Version, notes
FROM [Uganda_Drugs]
WHERE NDA_MAL_HDP IN (SELECT NDA_MAL_HDP FROM mults)
ORDER BY 1,2

select * from #rejects where NDA_MAL_HDP in ('2256','2239','2055','0614')


select * from Uganda_Drugs order by NDA_MAL_HDP

/*
Albuterol	SALBUTAMOL
Acetaminophen	PARACETAMOL
Beclomethasone	BECLOMETASONE
Carbocysteine	CARBOCISTEINE
Chorionic Gonadotropin	CHORIONIC GONADOTROPHIN
citocoline	CITICOLINE
desloratadine	DESLORATIDINE
EPINEPHrine	ADRENALINE
Ethamsylate	ETAMSYLATE
*/


-- drop table #ug_brand
CREATE TABLE #ug_brand (nda varchar(5), ingr varchar(1000), brand varchar(1000), strg varchar(1000), epro_df varchar(100))

DECLARE @brand varchar(1000)
DECLARE @no varchar(5), @ingr varchar(1000), @drug_name varchar(1000), @strg varchar(1000), @df varchar(100)
DECLARE crs_ug CURSOR FOR 
	SELECT u.[NDA REGISTRATION NUMBER], u.[GENERIC NAME OF DRUG] ,  u.[NAME OF DRUG] , u.[STRENGTH OF DRUG], u.[DOSAGE FORM]
	from UgandaJun2022 u
	-- where u.[NAME OF DRUG] not like '% %'

OPEN crs_ug
FETCH NEXT FROM crs_ug INTO @no, @ingr, @drug_name, @strg, @df
WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF charindex(' ', @drug_name) <= 1
			SET @brand = @drug_name
		ELSE
			SET @brand = left(@drug_name, charindex(' ', @drug_name) -1 )
		INSERT INTO #ug_brand
		select @no, LTRIM(ingredient), @brand, LTRIM(strength), dbo.fn_ug_dosage_form(@df)
		from dbo.fn_ug_ingredient_list(@ingr, @strg)
		FETCH NEXT FROM crs_ug INTO @no, @ingr, @drug_name, @strg, @df
	END

CLOSE crs_ug
DEALLOCATE crs_ug

-- drop table #brand_form_ug
SELECT nda, brand + ' ' + STUFF((
	SELECT  ' / ' + strg
	FROM #ug_brand calc
	WHERE calc.NDA = base.NDA
	ORDER BY ingr
	FOR XML PATH('')), 1, 3, '') + ' ' + epro_df AS formulation
	INTO #brand_form_ug
FROM #ug_brand base
GROUP BY NDA, brand, epro_df




UPDATE u 
SET proposed_brand_form_descr = i.formulation
-- select distinct  u.[ug_NAME OF DRUG], u.[ug_STRENGTH OF DRUG], i.formulation
from [Uganda_Drugs_2] u
JOIN #brand_form_ug i ON u.NDA_MAL_HDP = i.nda
WHERE u.[brand_form_RXCUI] IS NULL
AND LEFT(u.[ug_NAME OF DRUG],9) != LEFT(u.[ug_GENERIC_NAME OF DRUG],9)
AND u.[ug_NAME OF DRUG] != 'No Brand'

select * from [Uganda_Drugs_2] 
order by NDA_MAL_HDP