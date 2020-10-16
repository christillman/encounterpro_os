select '''' + [Kenya Drug Retention No] + '''', count(*)
 from [dbo].[09_18_2020 KenyaRetentionDrugsUpdate]
 group by [Kenya Drug Retention No]
 having count(*) > 1

 USE [EncounterPro_OS]
GO

DELETE FROM [Kenya_Drugs]

INSERT INTO [Kenya_Drugs] (
	[Retention_No]
      ,[SBD_Version]
      ,[SCD_PSN_Version]
      ,[Corresponding_RXCUI]
      ,[Notes]
      ,[dose_unit_Injections]
      ,[Ingredient]
	  )
SELECT left([Kenya Drug Retention No],21)
      ,[Kenya Drug in SBD Version]
      ,[Kenya Drug in SCD or PSN Version]
      ,CASE WHEN [Corresponding RXCUI] = 'No Corresponding SCD RXCUI' THEN NULL 
		WHEN len([Corresponding RXCUI]) > 20 THEN 'see Notes'
		ELSE left([Corresponding RXCUI],20) END
      ,CASE WHEN [Corresponding RXCUI] = 'No Corresponding SCD RXCUI' THEN [Notes] 
		WHEN len([Corresponding RXCUI]) > 20 
		THEN [Corresponding RXCUI] + '; ' + COALESCE([Notes],'')
		ELSE [Notes] END
      ,[dose_unit  (Injections)]
      ,[Ingredient]
  FROM [dbo].[09_18_2020 KenyaRetentionDrugsUpdate]

-- Replacing Kenya drugs

-- 09_18_2020 KenyaRetentionDrugsUpdate Spread sheet 
-- imported to [dbo].[09_18_2020 KenyaRetentionDrugsUpdate]
-- as a staging table using ImportKenya.ps1 and dbatools 
-- Then inserted to Kenya_Drugs with minimum mods 
--	(interfaces/Migration-RxNorm/AddKenyaDrugs.sql)

delete from [Kenya_Drugs]

BULK INSERT [Kenya_Drugs]
FROM '\\localhost\attachments\Kenya_Drugs.txt'

-- Data cleaning


-- These are existing formulations referred in the notes column
update Kenya_Drugs SET Corresponding_RXCUI = 'SCD-896771' WHERE notes like '%896771%'
update Kenya_Drugs SET Corresponding_RXCUI = 'PSN-855657' WHERE notes like '%855657%'
update Kenya_Drugs SET Corresponding_RXCUI = 'PSN-857296' WHERE notes like '%857296%'

-- missing space preceding MCG
UPDATE Kenya_Drugs
SET SCD_PSN_Version = REPLACE(SCD_PSN_Version,'MCG/',' MCG/') 
WHERE SCD_PSN_Version like '%MCG/%'
AND SCD_PSN_Version not like '% MCG/%'

-- '  ' -> ' '
UPDATE k
SET SCD_PSN_Version = 
	REPLACE(SCD_PSN_Version,'  ',' ') -- select *
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '%  %'
UPDATE k
SET SCD_PSN_Version = 
	REPLACE(SCD_PSN_Version,'  ',' ') -- select *
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '%  %'
UPDATE k
SET SBD_Version = 
	REPLACE(SBD_Version,'  ',' ') -- select *
FROM Kenya_Drugs k
WHERE SBD_Version LIKE '%  %'

-- ' MCG/ ACT' -> ' MCG/ACT'
UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,' MCG/ ACT',' MCG/ACT')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '% MCG/ ACT%'
UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,' MCG /ACT',' MCG/ACT')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '% MCG /ACT%'

-- 'MG/ ' -> 'MG / '
UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,'MG/ ','MG / ')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '%MG/ %'
UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,'MG/ ','MG / ')
FROM Kenya_Drugs k
WHERE SBD_Version LIKE '%MG/ %'

-- 'UNITS / ML' -> 'UNITS/ML'
UPDATE k
SET SCD_PSN_Version = -- select SCD_PSN_Version,
	REPLACE(SCD_PSN_Version,'UNITS / ML','UNITS/ML')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '%UNITS / ML%'
-- (39 row(s) affected)

UPDATE k
SET SCD_PSN_Version = -- select SCD_PSN_Version,
	REPLACE(SCD_PSN_Version,'UNITS / MG','UNITS/MG')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version LIKE '%UNITS / MG%'

-- ' /{[^M0-9 ]}' -> '/ \1'
UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,' /',' / ')
FROM Kenya_Drugs k
WHERE PATINDEX('% /[^ ]%', SCD_PSN_Version) > 0
UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,' /',' / ')
FROM Kenya_Drugs k
WHERE PATINDEX('% /[^ ]%', SBD_Version) > 0

UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'Numlo-','Numlo ')
FROM Kenya_Drugs k
WHERE SBD_Version LIKE 'S-Numlo-%'

UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'Teltas-40 MG','Teltas 40 MG')
FROM Kenya_Drugs k
WHERE SBD_Version LIKE 'Teltas-40 MG%'

UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'Teltas-80 MG','Teltas 80 MG')
FROM Kenya_Drugs k
WHERE SBD_Version LIKE 'Teltas-80 MG%'

-- '{[A-Z]}-{[0-9]* MG}' -> '\1 \2'
UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'-',' ')
FROM Kenya_Drugs k
WHERE PATINDEX('%[A-Z]-[0-9]%', SBD_Version) > 0
-- these have dashes within the brand name
and SBD_Version not like 'Artequin%'
and SBD_Version not like 'Olme%'
and SBD_Version not like 'Teltas%'
and SBD_Version not like 'Ecee%'
and SBD_Version not like 'Insuman%'
and SBD_Version not like 'Levo-%'
and SBD_Version not like 'Postinor%'
and SBD_Version not like 'Ranferon%'
and SBD_Version not like 'Enril%'
and SBD_Version not like 'Diane%'
and SBD_Version not like 'Humalog%'
and SBD_Version not like 'Emcon%'
and SBD_Version not like 'Mixtard%'
and SBD_Version not like 'Enapril%'
and SBD_Version not like 'Novomix%'
and SBD_Version not like 'Microgynon%'
and SBD_Version not like 'Akuri%'
and SBD_Version not like 'Azil%'
and SBD_Version not like 'Calcinol%'
and SBD_Version not like 'Revoke%'
and SBD_Version not like 'Rifafour%'

-- extra spaces around dashes
UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,' - ','-')
FROM Kenya_Drugs k
WHERE SBD_Version like '% - %'
UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'- ','-')
FROM Kenya_Drugs k
WHERE SBD_Version like '%- %'

-- missing space after .
UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version,'H.Pylori','H. Pylori')
FROM Kenya_Drugs k
WHERE SBD_Version like '%H.Pylori%'

-- standardise like RXNORM

UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,'Pre Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SBD_Version like '%Pre Filled%'

UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,'Pre-Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SBD_Version like '%Pre-Filled%'

UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,'Pre Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version like '%Pre Filled%'

UPDATE k
SET SCD_PSN_Version = -- select 
	REPLACE(SCD_PSN_Version,'Pre-Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SCD_PSN_Version like '%Pre-Filled%'

UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,'Pre Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SBD_Version like '%Pre Filled%'

UPDATE k
SET SBD_Version = -- select 
	REPLACE(SBD_Version,'Pre-Filled','Prefilled')
FROM Kenya_Drugs k
WHERE SBD_Version like '%Pre-Filled%'

-- Apply tallman function
UPDATE Kenya_Drugs
SET SCD_PSN_Version = dbo.fn_tallman(SCD_PSN_Version)
WHERE dbo.fn_needs_tallman(SCD_PSN_Version) = 1

-- Generic included in brand name
/* Ciru has changed these purposely for clarity
UPDATE k
SET SBD_Version = -- select 
	LEFT(SBD_Version,charindex(' (',SBD_Version)-1)
FROM Kenya_Drugs k
WHERE SBD_Version like '% (' + SCD_PSN_Version + ')%'
-- (1 row(s) affected)

UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version, ' (' + SUBSTRING(SBD_Version, 
			charindex('(',SBD_Version) + 1,
			charindex(')',SBD_Version) - charindex('(',SBD_Version) - 1
			) + ')', '')
FROM Kenya_Drugs k
WHERE charindex('(',SBD_Version) > 0 
	AND SCD_PSN_Version LIKE
		LTRIM(RTRIM(SUBSTRING(SBD_Version, 
			charindex('(',SBD_Version) + 1,
			charindex(')',SBD_Version) - charindex('(',SBD_Version) - 1
			))) + '%'
-- (117 row(s) affected)


UPDATE k
SET SBD_Version = -- select SBD_Version,
	REPLACE(SBD_Version, ' (' + SUBSTRING(SBD_Version, 
			charindex('(',SBD_Version) + 1,
			charindex(')',SBD_Version) - charindex('(',SBD_Version) - 1
			) + ')', '')
FROM Kenya_Drugs k
WHERE charindex('(',SBD_Version) > 0 
AND SCD_PSN_Version LIKE
		SUBSTRING(REPLACE(SBD_Version,'( (','('), 
			charindex('(',SBD_Version) + 1,6) + '%'
AND SBD_Version NOT LIKE '%(MIU)%'
AND SBD_Version NOT LIKE 'Candid-V6%'
-- (22 row(s) affected)
*/

UPDATE Kenya_Drugs
SET SBD_Version = 'Amdocal Plus 25 Oral Tablet'
WHERE SBD_Version = 'Amdocal Plus 25'


-- Ventolin Rotacaps 100/128
UPDATE Kenya_Drugs
SET Retention_No = -- select Retention_No,
	Retention_No + '-' + left(right(SBD_Version,12),3) 
FROM Kenya_Drugs
WHERE SBD_Version LIKE 'Ventolin Rotacaps%'
AND SCD_PSN_Version LIKE '%{%'
OR SCD_PSN_Version LIKE '%GPCK%'
AND Retention_No NOT LIKE '%-' + left(right(SBD_Version,12),3) 
-- (2 row(s) affected) 

-- Some have duplicate retention numbers, need to differentiate
UPDATE Kenya_Drugs
SET Retention_No = Retention_No + 'PF' -- select Retention_No, SBD_Version
FROM Kenya_Drugs
WHERE Retention_No IN ('2132', '11179', '229', '281', '282', '283', '289', '297', '5916')
AND SBD_Version LIKE '%Pre%Filled%'

UPDATE Kenya_Drugs
SET Retention_No = Retention_No + 'V' -- select Retention_No, SBD_Version
FROM Kenya_Drugs
WHERE Retention_No IN ('283', '289', '297', '5907')
AND SBD_Version LIKE '%Vial%'

UPDATE Kenya_Drugs
SET Retention_No = Retention_No + '-4ML' -- select Retention_No, SBD_Version
FROM Kenya_Drugs
WHERE Retention_No IN ('1239', '1246')
AND SBD_Version LIKE '%4 ML%'

UPDATE Kenya_Drugs
SET Retention_No = Retention_No + 'Eye' -- select Retention_No, SBD_Version
FROM Kenya_Drugs
WHERE Retention_No IN ('515', '516')
AND SBD_Version LIKE '%Eye%'

UPDATE Kenya_Drugs
SET Retention_No = Retention_No + 'IM' -- select Retention_No, SBD_Version
FROM Kenya_Drugs
WHERE Retention_No IN ('5650', '7754')
AND SBD_Version LIKE '%Intramusc%'

-- A few are duplicate brand formulations, need to differentiate
UPDATE Kenya_Drugs
SET SBD_Version = 'Artefan 60 MG / 360 MG Oral Tablet'
WHERE SBD_Version = 'Artefan Oral Tablet'
AND SCD_PSN_Version = 'artemether 60 MG / lumefantrine 360 MG Oral Tablet'

UPDATE Kenya_Drugs
SET SBD_Version = 'Artefan 20 MG / 120 MG Oral Tablet'
WHERE SBD_Version = 'Artefan Oral Tablet'
AND SCD_PSN_Version = 'artemether 20 MG / lumefantrine 120 MG Oral Tablet'

UPDATE Kenya_Drugs
SET SBD_Version = 'Safeguard 50 MG / 200 MG Oral Tablet'
WHERE SBD_Version = 'Safeguard Oral Tablet'
AND SCD_PSN_Version = 'diclofenac sodium 50 MG / misoprostol 200 MCG Oral Tablet'

UPDATE Kenya_Drugs
SET SBD_Version = 'Safeguard 75 MG / 200 MG Oral Tablet'
WHERE SBD_Version = 'Safeguard Oral Tablet'
AND SCD_PSN_Version = 'diclofenac sodium 75 MG / misoprostol 200 MCG Oral Tablet'

-- One needs to have a unique Id
UPDATE Kenya_Drugs
SET Retention_No = '7782-0.5'
WHERE SBD_Version = 'Rivotril 0.5 MG Oral Tablet'
-- (1 row(s) affected)

/*
select * from Kenya_Drugs where Retention_No like '%Not%'
Retention_No	SBD_Version	SCD_PSN_Version	Corresponding_RXCUI
Not in Retention List	No corresponding brand name drug formulation in kenya drug set	cloNIDine HCl 0.15 MG Oral Tablet	PSN-1233709
Not in Retention List	No corresponding brand name drug formulation in kenya drug set	cloNIDine HCl 0.1 MG Oral Tablet	PSN-884173
Not in Retention List	No corresponding brand name drug formulation in kenya drug set	cloNIDine HCl 0.2 MG Oral Tablet	PSN-884185
Not in Retention List	No corresponding brand name drug formulation in kenya drug set	cloNIDine HCl 0.3 MG Oral Tablet	PSN-884189
Not in Retention List	Dixarit 0.025 MG Oral Tablet	cloNIDine HCl 0.025 MG Oral Tablet	PSN-892791
*/

/* Not in standard RXNORM format
SCD
3090	Atropine Sulfate 0.6 MG/ML Injection	1 ML atropine sulfate 0.6 MG/ML Injection
10769	Grani-Denk 1 MG/ML Injection	1 ML granisetron HCL 1 MG/ML Injection
13983	Vermor 10 MG/ML Injection	1 ML morphine sulphate 10 MG/ML Injection
2174	Trofentyl 50 MCG/ML Injection	2 ML fentaNYL citrate 50 MCG/ML Injection
7201	Diclomol 25 MG/ML Injection	3 ML diclofenac sodium 25 MG/ML Injection
SBD
6901	10 ML Bimonate 8.4 % w/v Injection	sodium bicarbonate 8.4 % in 10 ML Injection
Both
3597	1 ML Heparin Sodium-Fresenius 5000 UNITS/ML Injection	1 ML heparin sodium 5000 UNITS/ML Injection
1191	1 ML Primolut Depot 250 MG/ML Solution for Injection	1 ML hydroxyprogesterone caproate 250 MG/ML Solution for Injection
3597-5ML	5 ML Heparin Sodium-Fresenius 5000 UNITS/ML Injection	5 ML heparin sodium 5000 UNITS/ML Injection
*/

-- Preferred PSN terminology
UPDATE Kenya_Drugs
SET SCD_PSN_Version =
--SELECT SCD_PSN_Version,
substring(SCD_PSN_Version,6,charindex('/ML ',SCD_PSN_Version) - 2)
	+ 'in ' + left(SCD_PSN_Version,5)
	+ substring(SCD_PSN_Version,charindex('/ML ',SCD_PSN_Version)+4,500)
from Kenya_Drugs
where PATINDEX('[0-9] ML%', SCD_PSN_Version) > 0

UPDATE Kenya_Drugs
SET SBD_Version =
--SELECT SBD_Version,charindex('/ML ',SBD_Version) ,
 substring(SBD_Version,7,charindex('/ML ',SBD_Version) - 3)
	+ 'in ' + left(SBD_Version,6)
	+ substring(SBD_Version,charindex('/ML ',SBD_Version)+4,500) 
from Kenya_Drugs
where PATINDEX('[0-9][0-9] ML%', SBD_Version) > 0

UPDATE Kenya_Drugs
SET SBD_Version =
--SELECT SBD_Version,
substring(SBD_Version,6,charindex('/ML ',SBD_Version) - 2)
	+ 'in ' + left(SBD_Version,5)
	+ substring(SBD_Version,charindex('/ML ',SBD_Version)+4,500)
from [dbo].Kenya_Drugs
where PATINDEX('[0-9] ML%', SBD_Version) > 0

-- note in SBD, retention no is NULL
UPDATE Kenya_Drugs 
SET Retention_No = '867Cap',	
	SBD_Version = 'Braxidin 2.5 MG / 5 MG Oral Capsule'
where SCD_PSN_Version = 
'clidinium bromide 2.5 MG / chlordiazePOXIDE HCl 5 MG Oral Capsule'

-- Missing spaces around slash for combination drugs
UPDATE Kenya_Drugs 
SET SCD_PSN_Version = REPLACE (SCD_PSN_Version,'umeclidinium bromide/vilanterol trifenatate','umeclidinium bromide / vilanterol trifenatate')
where SCD_PSN_Version LIKE  '%umeclidinium bromide/vilanterol trifenatate%'

/*
UPDATE k
SET SCD_PSN_Version = -- select SCD_PSN_Version,
	substring(SCD_PSN_Version,1,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)) 
		+ ' / ' + substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)+2,500)
FROM Kenya_Drugs k
WHERE PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version) > 0 
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-5,9) != ' UNITS/ML'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-5,9) != ' UNITS/MG'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-2,4) != ' MG/'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-3,5) != ' MCG/'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-10,12) != ' Micrograms/'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-1,4) != ' w/w'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-2,6) != ' IU/ML'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-13,26) != ' Intramuscular/Intravenous'
and substring(SCD_PSN_Version,PATINDEX('%[a-z]/[a-z]%',SCD_PSN_Version)-11,26) != ' Intravenous/Intramuscular'

*/

/*
cd C:\attachments
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO_OS

%PATH_TO_BCP% Kenya_Drugs out Kenya_Drugs.txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
*/

/*
 select * from Kenya_Drugs
 where [Retention_No]
 in (
 '00nobrandfound',
'1239',
'1246',
'229',
'281',
'282',
'283',
'289',
'297',
'4558-BPCK',
'515',
'516',
'5650',
'5907',
'5916',
'No Retention No',
'Not in Retention List. No Retention Number. Let us include it in list anyway, but keep a note for ourselves that  this drug is not in the Retention list.'
)
order by [Retention_No]

Retention_No	SBD_Version	SCD_PSN_Version	Corresponding_RXCUI
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 1 MG Oral Tablet	SCD-855288
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 3 MG Oral Tablet	SCD-855318
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 2 MG Oral Tablet	SCD-855302
00nobrandfound	No available brand drug found. Lets keep generic	valsartan 160 MG / hydroCHLOROthiazide 25 MG Oral Tablet	SCD-349353
00nobrandfound	No available brand drug found. Lets keep generic	valsartan 320 MG / hydroCHLOROthiazide 12.5 MG Oral Tablet	SCD-636042
No Retention No	No corresponding brand name drug formulation in kenya drug set	leuprolide acetate 11.25 MG in 1 ML (1 month) Prefilled Syringe	PSN-1115447
No Retention No	No corresponding brand name drug formulation in kenya drug set	leuprolide acetate 3.75 MG in 1 ML (1 month) Prefilled Syringe	PSN-1115457
*/