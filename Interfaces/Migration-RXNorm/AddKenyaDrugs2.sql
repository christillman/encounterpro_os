select '''' + [Kenya Drug Retention No] + '''', count(*)
 from [dbo].[11_17_2020 KenyaRetentionDrugsAdditions]
 group by [Kenya Drug Retention No]
 having count(*) > 1


DELETE FROM [[11_17_2020 KenyaRetentionDrugsAdditions]]

INSERT INTO [[11_17_2020 KenyaRetentionDrugsAdditions]] (
	[[Kenya Drug Retention No]]
      ,[[Kenya Drug in SBD Version]]
      ,[[Kenya Drug in SCD or PSN Version]]
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
  FROM [dbo].[11_17_2020 KenyaRetentionDrugsAdditions]

-- Replacing Kenya drugs

-- 09_18_2020 KenyaRetentionDrugsUpdate Spread sheet 
-- imported to [dbo].[11_17_2020 KenyaRetentionDrugsAdditions]
-- as a staging table using ImportKenya.ps1 and dbatools 
-- Then inserted to [11_17_2020 KenyaRetentionDrugsAdditions] with minimum mods 
--	(interfaces/Migration-RxNorm/AddKenyaDrugs.sql)

--delete from [[11_17_2020 KenyaRetentionDrugsAdditions]]

--BULK INSERT [[11_17_2020 KenyaRetentionDrugsAdditions]]
--FROM '\\localhost\attachments\[11_17_2020 KenyaRetentionDrugsAdditions].txt'

-- Data cleaning


-- missing space preceding MCG
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SCD or PSN Version] = REPLACE([Kenya Drug in SCD or PSN Version],'MCG/',' MCG/') 
WHERE [Kenya Drug in SCD or PSN Version] like '%MCG/%'
AND [Kenya Drug in SCD or PSN Version] not like '% MCG/%'

-- '  ' -> ' '
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = 
	REPLACE([Kenya Drug in SCD or PSN Version],'  ',' ') -- select *
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '%  %'
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = 
	REPLACE([Kenya Drug in SCD or PSN Version],'  ',' ') -- select *
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '%  %'
UPDATE k
SET [Kenya Drug in SBD Version] = 
	REPLACE([Kenya Drug in SBD Version],'  ',' ') -- select *
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] LIKE '%  %'

-- ' MCG/ ACT' -> ' MCG/ACT'
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],' MCG/ ACT',' MCG/ACT')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '% MCG/ ACT%'
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],' MCG /ACT',' MCG/ACT')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '% MCG /ACT%'

-- 'MG/ ' -> 'MG / '
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],'MG/ ','MG / ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '%MG/ %'
UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],'MG/ ','MG / ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] LIKE '%MG/ %'

-- 'UNITS / ML' -> 'UNITS/ML'
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select [Kenya Drug in SCD or PSN Version],
	REPLACE([Kenya Drug in SCD or PSN Version],'UNITS / ML','UNITS/ML')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '%UNITS / ML%'
-- (39 row(s) affected)

UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select [Kenya Drug in SCD or PSN Version],
	REPLACE([Kenya Drug in SCD or PSN Version],'UNITS / MG','UNITS/MG')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] LIKE '%UNITS / MG%'

-- ' /{[^M0-9 ]}' -> '/ \1'
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],' /',' / ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE PATINDEX('% /[^ ]%', [Kenya Drug in SCD or PSN Version]) > 0
UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],' /',' / ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE PATINDEX('% /[^ ]%', [Kenya Drug in SBD Version]) > 0

UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'Numlo-','Numlo ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] LIKE 'S-Numlo-%'

UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'Teltas-40 MG','Teltas 40 MG')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] LIKE 'Teltas-40 MG%'

UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'Teltas-80 MG','Teltas 80 MG')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] LIKE 'Teltas-80 MG%'

-- '{[A-Z]}-{[0-9]* MG}' -> '\1 \2'
UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'-',' ')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE PATINDEX('%[A-Z]-[0-9]%', [Kenya Drug in SBD Version]) > 0
-- these have dashes within the brand name
and [Kenya Drug in SBD Version] not like 'Artequin%'
and [Kenya Drug in SBD Version] not like 'Olme%'
and [Kenya Drug in SBD Version] not like 'Teltas%'
and [Kenya Drug in SBD Version] not like 'Ecee%'
and [Kenya Drug in SBD Version] not like 'Insuman%'
and [Kenya Drug in SBD Version] not like 'Levo-%'
and [Kenya Drug in SBD Version] not like 'Postinor%'
and [Kenya Drug in SBD Version] not like 'Ranferon%'
and [Kenya Drug in SBD Version] not like 'Enril%'
and [Kenya Drug in SBD Version] not like 'Diane%'
and [Kenya Drug in SBD Version] not like 'Humalog%'
and [Kenya Drug in SBD Version] not like 'Emcon%'
and [Kenya Drug in SBD Version] not like 'Mixtard%'
and [Kenya Drug in SBD Version] not like 'Enapril%'
and [Kenya Drug in SBD Version] not like 'Novomix%'
and [Kenya Drug in SBD Version] not like 'Microgynon%'
and [Kenya Drug in SBD Version] not like 'Akuri%'
and [Kenya Drug in SBD Version] not like 'Azil%'
and [Kenya Drug in SBD Version] not like 'Calcinol%'
and [Kenya Drug in SBD Version] not like 'Revoke%'
and [Kenya Drug in SBD Version] not like 'Rifafour%'

-- extra spaces around dashes
UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],' - ','-')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '% - %'
UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'- ','-')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%- %'

-- missing space after .
UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version],'H.Pylori','H. Pylori')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%H.Pylori%'

-- standardise like RXNORM

UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],'Pre Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%Pre Filled%'

UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],'Pre-Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%Pre-Filled%'

UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],'Pre Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] like '%Pre Filled%'

UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select 
	REPLACE([Kenya Drug in SCD or PSN Version],'Pre-Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SCD or PSN Version] like '%Pre-Filled%'

UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],'Pre Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%Pre Filled%'

UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	REPLACE([Kenya Drug in SBD Version],'Pre-Filled','Prefilled')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '%Pre-Filled%'

-- Apply tallman function
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SCD or PSN Version] = dbo.fn_tallman([Kenya Drug in SCD or PSN Version])
WHERE dbo.fn_needs_tallman([Kenya Drug in SCD or PSN Version]) = 1

-- Generic included in brand name
/* Ciru has changed these purposely for clarity
UPDATE k
SET [Kenya Drug in SBD Version] = -- select 
	LEFT([Kenya Drug in SBD Version],charindex(' (',[Kenya Drug in SBD Version])-1)
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE [Kenya Drug in SBD Version] like '% (' + [Kenya Drug in SCD or PSN Version] + ')%'
-- (1 row(s) affected)

UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version], ' (' + SUBSTRING([Kenya Drug in SBD Version], 
			charindex('(',[Kenya Drug in SBD Version]) + 1,
			charindex(')',[Kenya Drug in SBD Version]) - charindex('(',[Kenya Drug in SBD Version]) - 1
			) + ')', '')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE charindex('(',[Kenya Drug in SBD Version]) > 0 
	AND [Kenya Drug in SCD or PSN Version] LIKE
		LTRIM(RTRIM(SUBSTRING([Kenya Drug in SBD Version], 
			charindex('(',[Kenya Drug in SBD Version]) + 1,
			charindex(')',[Kenya Drug in SBD Version]) - charindex('(',[Kenya Drug in SBD Version]) - 1
			))) + '%'
-- (117 row(s) affected)


UPDATE k
SET [Kenya Drug in SBD Version] = -- select [Kenya Drug in SBD Version],
	REPLACE([Kenya Drug in SBD Version], ' (' + SUBSTRING([Kenya Drug in SBD Version], 
			charindex('(',[Kenya Drug in SBD Version]) + 1,
			charindex(')',[Kenya Drug in SBD Version]) - charindex('(',[Kenya Drug in SBD Version]) - 1
			) + ')', '')
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE charindex('(',[Kenya Drug in SBD Version]) > 0 
AND [Kenya Drug in SCD or PSN Version] LIKE
		SUBSTRING(REPLACE([Kenya Drug in SBD Version],'( (','('), 
			charindex('(',[Kenya Drug in SBD Version]) + 1,6) + '%'
AND [Kenya Drug in SBD Version] NOT LIKE '%(MIU)%'
AND [Kenya Drug in SBD Version] NOT LIKE 'Candid-V6%'
-- (22 row(s) affected)
*/

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] = 'Amdocal Plus 25 Oral Tablet'
WHERE [Kenya Drug in SBD Version] = 'Amdocal Plus 25'


-- Ventolin Rotacaps 100/128
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = -- select [Kenya Drug Retention No],
	[Kenya Drug Retention No] + '-' + left(right([Kenya Drug in SBD Version],12),3) 
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug in SBD Version] LIKE 'Ventolin Rotacaps%'
AND [Kenya Drug in SCD or PSN Version] LIKE '%{%'
OR [Kenya Drug in SCD or PSN Version] LIKE '%GPCK%'
AND [Kenya Drug Retention No] NOT LIKE '%-' + left(right([Kenya Drug in SBD Version],12),3) 
-- (2 row(s) affected) 

-- Some have duplicate retention numbers, need to differentiate
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = [Kenya Drug Retention No] + 'PF' -- select [Kenya Drug Retention No], [Kenya Drug in SBD Version]
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug Retention No] IN ('2132', '11179', '229', '281', '282', '283', '289', '297', '5916')
AND [Kenya Drug in SBD Version] LIKE '%Pre%Filled%'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = [Kenya Drug Retention No] + 'V' -- select [Kenya Drug Retention No], [Kenya Drug in SBD Version]
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug Retention No] IN ('283', '289', '297', '5907')
AND [Kenya Drug in SBD Version] LIKE '%Vial%'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = [Kenya Drug Retention No] + '-4ML' -- select [Kenya Drug Retention No], [Kenya Drug in SBD Version]
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug Retention No] IN ('1239', '1246')
AND [Kenya Drug in SBD Version] LIKE '%4 ML%'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = [Kenya Drug Retention No] + 'Eye' -- select [Kenya Drug Retention No], [Kenya Drug in SBD Version]
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug Retention No] IN ('515', '516')
AND [Kenya Drug in SBD Version] LIKE '%Eye%'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = [Kenya Drug Retention No] + 'IM' -- select [Kenya Drug Retention No], [Kenya Drug in SBD Version]
FROM [11_17_2020 KenyaRetentionDrugsAdditions]
WHERE [Kenya Drug Retention No] IN ('5650', '7754')
AND [Kenya Drug in SBD Version] LIKE '%Intramusc%'

-- A few are duplicate brand formulations, need to differentiate
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] = 'Artefan 60 MG / 360 MG Oral Tablet'
WHERE [Kenya Drug in SBD Version] = 'Artefan Oral Tablet'
AND [Kenya Drug in SCD or PSN Version] = 'artemether 60 MG / lumefantrine 360 MG Oral Tablet'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] = 'Artefan 20 MG / 120 MG Oral Tablet'
WHERE [Kenya Drug in SBD Version] = 'Artefan Oral Tablet'
AND [Kenya Drug in SCD or PSN Version] = 'artemether 20 MG / lumefantrine 120 MG Oral Tablet'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] = 'Safeguard 50 MG / 200 MG Oral Tablet'
WHERE [Kenya Drug in SBD Version] = 'Safeguard Oral Tablet'
AND [Kenya Drug in SCD or PSN Version] = 'diclofenac sodium 50 MG / misoprostol 200 MCG Oral Tablet'

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] = 'Safeguard 75 MG / 200 MG Oral Tablet'
WHERE [Kenya Drug in SBD Version] = 'Safeguard Oral Tablet'
AND [Kenya Drug in SCD or PSN Version] = 'diclofenac sodium 75 MG / misoprostol 200 MCG Oral Tablet'

-- One needs to have a unique Id
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug Retention No] = '7782-0.5'
WHERE [Kenya Drug in SBD Version] = 'Rivotril 0.5 MG Oral Tablet'
-- (1 row(s) affected)

/*
select * from [11_17_2020 KenyaRetentionDrugsAdditions] where [Kenya Drug Retention No] like '%Not%'
[Kenya Drug Retention No]	[Kenya Drug in SBD Version]	[Kenya Drug in SCD or PSN Version]	Corresponding_RXCUI
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
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SCD or PSN Version] =
--SELECT [Kenya Drug in SCD or PSN Version],
substring([Kenya Drug in SCD or PSN Version],6,charindex('/ML ',[Kenya Drug in SCD or PSN Version]) - 2)
	+ 'in ' + left([Kenya Drug in SCD or PSN Version],5)
	+ substring([Kenya Drug in SCD or PSN Version],charindex('/ML ',[Kenya Drug in SCD or PSN Version])+4,500)
from [11_17_2020 KenyaRetentionDrugsAdditions]
where PATINDEX('[0-9] ML%', [Kenya Drug in SCD or PSN Version]) > 0

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] =
--SELECT [Kenya Drug in SBD Version],charindex('/ML ',[Kenya Drug in SBD Version]) ,
 substring([Kenya Drug in SBD Version],7,charindex('/ML ',[Kenya Drug in SBD Version]) - 3)
	+ 'in ' + left([Kenya Drug in SBD Version],6)
	+ substring([Kenya Drug in SBD Version],charindex('/ML ',[Kenya Drug in SBD Version])+4,500) 
from [11_17_2020 KenyaRetentionDrugsAdditions]
where PATINDEX('[0-9][0-9] ML%', [Kenya Drug in SBD Version]) > 0

UPDATE [11_17_2020 KenyaRetentionDrugsAdditions]
SET [Kenya Drug in SBD Version] =
--SELECT [Kenya Drug in SBD Version],
substring([Kenya Drug in SBD Version],6,charindex('/ML ',[Kenya Drug in SBD Version]) - 2)
	+ 'in ' + left([Kenya Drug in SBD Version],5)
	+ substring([Kenya Drug in SBD Version],charindex('/ML ',[Kenya Drug in SBD Version])+4,500)
from [dbo].[11_17_2020 KenyaRetentionDrugsAdditions]
where PATINDEX('[0-9] ML%', [Kenya Drug in SBD Version]) > 0

-- note in SBD, retention no is NULL
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions] 
SET [Kenya Drug Retention No] = '867Cap',	
	[Kenya Drug in SBD Version] = 'Braxidin 2.5 MG / 5 MG Oral Capsule'
where [Kenya Drug in SCD or PSN Version] = 
'clidinium bromide 2.5 MG / chlordiazePOXIDE HCl 5 MG Oral Capsule'

-- Missing spaces around slash for combination drugs
UPDATE [11_17_2020 KenyaRetentionDrugsAdditions] 
SET [Kenya Drug in SCD or PSN Version] = REPLACE ([Kenya Drug in SCD or PSN Version],'umeclidinium bromide/vilanterol trifenatate','umeclidinium bromide / vilanterol trifenatate')
where [Kenya Drug in SCD or PSN Version] LIKE  '%umeclidinium bromide/vilanterol trifenatate%'

/*
UPDATE k
SET [Kenya Drug in SCD or PSN Version] = -- select [Kenya Drug in SCD or PSN Version],
	substring([Kenya Drug in SCD or PSN Version],1,PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])) 
		+ ' / ' + substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])+2,500)
FROM [11_17_2020 KenyaRetentionDrugsAdditions] k
WHERE PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version]) > 0 
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-5,9) != ' UNITS/ML'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-5,9) != ' UNITS/MG'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-2,4) != ' MG/'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-3,5) != ' MCG/'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-10,12) != ' Micrograms/'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-1,4) != ' w/w'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-2,6) != ' IU/ML'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-13,26) != ' Intramuscular/Intravenous'
and substring([Kenya Drug in SCD or PSN Version],PATINDEX('%[a-z]/[a-z]%',[Kenya Drug in SCD or PSN Version])-11,26) != ' Intravenous/Intramuscular'

*/

/*
cd C:\attachments
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO_OS

%PATH_TO_BCP% [11_17_2020 KenyaRetentionDrugsAdditions] out [11_17_2020 KenyaRetentionDrugsAdditions].txt -S %MSSQLSERVER% -d EncounterPro_OS -T -c
*/

/*
 select * from [11_17_2020 KenyaRetentionDrugsAdditions]
 where [[Kenya Drug Retention No]]
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
order by [[Kenya Drug Retention No]]

[Kenya Drug Retention No]	[Kenya Drug in SBD Version]	[Kenya Drug in SCD or PSN Version]	Corresponding_RXCUI
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 1 MG Oral Tablet	SCD-855288
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 3 MG Oral Tablet	SCD-855318
00nobrandfound	NEED TO VERIFY IF APPROVED IN KENYA	warfarin sodium 2 MG Oral Tablet	SCD-855302
00nobrandfound	No available brand drug found. Lets keep generic	valsartan 160 MG / hydroCHLOROthiazide 25 MG Oral Tablet	SCD-349353
00nobrandfound	No available brand drug found. Lets keep generic	valsartan 320 MG / hydroCHLOROthiazide 12.5 MG Oral Tablet	SCD-636042
No Retention No	No corresponding brand name drug formulation in kenya drug set	leuprolide acetate 11.25 MG in 1 ML (1 month) Prefilled Syringe	PSN-1115447
No Retention No	No corresponding brand name drug formulation in kenya drug set	leuprolide acetate 3.75 MG in 1 ML (1 month) Prefilled Syringe	PSN-1115457
*/

-- already there
delete from [11_17_2020 KenyaRetentionDrugsAdditions]
where [Kenya Drug Retention No] = '467' 

select 'INSERT INTO Kenya_Drugs ([Retention_No],[SBD_Version],[SCD_PSN_Version],[Corresponding_RXCUI],[Ingredient]
	  ) VALUES (''' + [Kenya Drug Retention No] 
	  + ''', ''' + [Kenya Drug in SBD Version]
	  + ''', ''' + [Kenya Drug in SCD or PSN Version]
	  + ''', ' + CASE WHEN [Corresponding RXCUI] = 'No Corresponding SCD RXCUI' THEN 'NULL' 
		ELSE '''' + [Corresponding RXCUI]+ '''' END +
	  + ', ''' + replace([Generic Ingredients],'/',' / ') + ''')
	  '
	from [11_17_2020 KenyaRetentionDrugsAdditions]

select '''' + [Kenya Drug Retention No] + ''',' from [11_17_2020 KenyaRetentionDrugsAdditions]