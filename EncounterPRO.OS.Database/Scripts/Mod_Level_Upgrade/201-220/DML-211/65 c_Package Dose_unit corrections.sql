/* 
select distinct i.dose_unit 
from [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
where dose_unit not in (select unit_id from c_Unit)

update [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary]
set dose_unit = CASE dose_unit
	 WHEN 'ACTUATION' THEN 'ACTUAT'
	 WHEN 'GM' THEN 'GRAM'
	 WHEN 'GRAMS' THEN 'GRAM'
	 WHEN 'IMPLANT' THEN 'IMPL'
	 WHEN 'INTERNATIONAL UNITS' THEN 'IU'
	 WHEN 'UNITS' THEN 'UNIT'
	 ELSE dose_unit END

SELECT 'UPDATE c_Package SET dose_unit = ''' + i.dose_unit
	+ ''' WHERE package_id = ''' + p.package_id + ''''
-- select form_rxcui, p.dose_unit, i.dose_unit 
from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
where p.dose_unit is null and i.dose_unit is not null
and i.dose_unit NOT IN ('RETIRED','SUPPRESS')
-- (173 rows)
*/

UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK804171'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591964'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792488'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK830243'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK830252'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792490'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK798426'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK798428'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK798429'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK798430'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK830245'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK830253'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK855200'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854232'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854236'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854239'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854242'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854249'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115257'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115447'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115454'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115457'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115462'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115467'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115472'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1946519'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1946521'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK993452'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727531'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727355'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727357'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727361'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727537'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727542'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727544'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727545'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727625'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727703'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727705'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727816'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727954'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK752884'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK752889'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK752894'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK752899'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758025'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758027'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758028'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758029'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758032'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758159'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758160'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758162'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758164'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK758169'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727360'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK763564'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK763565'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727535'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK795748'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727539'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727619'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727757'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727762'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK727813'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK731326'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK731328'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK825325'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK825333'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK825334'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK825335'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK802652'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK803369'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK803371'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK809158'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK809159'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK834357'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854245'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854247'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854252'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854253'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861358'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861366'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK848160'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK848164'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854228'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854235'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854238'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK898316'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854241'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK854248'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861356'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861360'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861363'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861365'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1047437'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1090558'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1090560'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1000153'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1000154'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1000156'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1090559'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1145929'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1145932'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1244060'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1244062'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1244063'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1244064'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1300781'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1369783'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1369787'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1369791'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1433768'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1433771'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441527'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441530'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1482813'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1482814'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1546172'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1546181'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1546187'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115259'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115449'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115456'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115459'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551887'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551888'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591961'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115464'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591967'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591970'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591973'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1591976'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115468'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1115473'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1605074'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1314133'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1605066'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1605071'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727574'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1876502'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726844'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726846'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792483'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792485'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792493'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1792495'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1801186'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1810484'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1810489'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1855523'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1855524'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1862220'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1864423'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1864425'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921009'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921010'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921016'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921017'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1925254'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1925255'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1925256'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1925257'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1946520'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK2045501'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK2045502'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1946522'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK901644'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK829987'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK901640'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK829989'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1928339'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK727575'

/*
-- do not erase current values, these are not in the Kenya set
select form_rxcui, p.dose_unit, i.dose_unit 
from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
where p.dose_unit is not null and i.dose_unit is null
and (i.[Status in Kenya Drug Set] in (
'RETIRED CONCEPT',
'Suppress. Not sure if found in Kenya Drug Set or Not.',
'This SBD concept not in retention drugs in Kenya',
'This SCD concept not in retention drugs in Kenya')
or  i.dose_unit  IN ('RETIRED','SUPPRESS'))
-- (446 rows)

select count(*) from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
where p.dose_unit is null and i.dose_unit is null
-- 71


SELECT 'UPDATE c_Package SET dose_unit = ''' + i.dose_unit
	+ ''' WHERE package_id = ''' + p.package_id + ''''
from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
where p.dose_unit != i.dose_unit 
-- and i.dose_unit NOT IN ('RETIRED','SUPPRESS') -- 529
-- 593
*/

UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1000126'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1000128'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1001433'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1011809'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1011814'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1041530'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK104208'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1045456'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1045460'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1046398'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1046406'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1046408'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1046410'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK105641'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK108515'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1086259'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK108911'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1090635'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1094083'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1099648'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1099650'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1100742'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1100746'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1116294'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK1189657'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK1189673'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1193358'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1193360'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1193362'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1232653'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1234256'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1244233'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1244638'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293443'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293446'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293464'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293466'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1293628'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1293648'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293736'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1293739'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1298948'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1298953'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1300890'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1304995'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1306074'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1306076'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1357886'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1357888'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1361568'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1361577'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1361853'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362048'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362052'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362054'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362055'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362057'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362059'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362060'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362062'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362063'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1362065'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1376084'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1431642'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1431647'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441402'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441407'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441411'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441413'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441416'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441418'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441422'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1441424'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1486165'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK151114'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544378'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544385'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544387'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544389'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544395'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544397'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544399'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1544401'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1547445'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1547450'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1549708'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551295'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551300'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551304'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1551306'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1594589'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1594591'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1594593'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1594658'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1594663'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1594759'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1595029'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1595035'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1599787'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649591'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649600'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649601'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649944'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649946'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649963'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649964'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649994'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1649996'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650003'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650004'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650011'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650012'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650894'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650896'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650899'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650901'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650922'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650922'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1650940'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653142'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653144'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653165'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653166'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653223'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1653225'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654006'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654008'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654035'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654037'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654040'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654041'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654169'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1654186'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1655726'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1655728'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1656760'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1657016'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1657026'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657703'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657705'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657722'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657723'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657750'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657974'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657976'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657979'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657980'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657981'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1657982'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1658142'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1658144'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1658156'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1658157'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1658244'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1658262'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658634'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658637'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658647'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658659'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658707'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1658719'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1659260'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1659263'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1661424'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1661427'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1661432'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1661483'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1662278'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1662280'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1662285'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1662286'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1663224'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1663244'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1663248'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1665057'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1665061'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1666372'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1666441'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1666613'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1666622'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1667993'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670192'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670195'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670197'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670200'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670201'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670351'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1670353'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718900'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718902'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718906'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718907'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718909'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1718910'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719003'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719005'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719015'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719286'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719290'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719291'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719646'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719669'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719772'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719803'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719847'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1719862'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1720026'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1720960'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1720975'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1720977'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1722939'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1722941'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723156'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723160'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723187'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723189'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723193'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1723194'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723206'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723208'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723209'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723210'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723232'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1723234'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1724666'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1724668'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726319'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726324'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726333'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726492'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726992'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1726997'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1727000'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1727001'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1727569'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1727572'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1728050'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1728055'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1728056'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1729418'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1729422'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1730076'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1730078'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1730196'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1731582'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1731584'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1731590'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1731591'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1731999'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1732182'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1732183'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1732186'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1732187'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1734399'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1734683'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1734686'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1734919'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1734921'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1735500'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736541'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736543'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736546'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736547'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1736776'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1736781'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736919'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736921'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1736931'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1737850'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1737852'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1738353'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1738357'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1740467'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1740865'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741261'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741263'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741267'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741268'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741270'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1741271'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743726'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743729'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743779'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743781'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743833'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743855'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1743856'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1743994'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1747179'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1747181'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1747185'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1747187'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1747192'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1788984'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1790208'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1790219'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791229'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791232'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791233'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1791395'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1791403'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1791404'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1791408'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1791409'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791588'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791591'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791593'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791595'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791597'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791599'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791701'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791736'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791840'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791842'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791854'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791859'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1791861'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1792144'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1792780'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1792785'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1796672'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1796676'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1796690'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1796692'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1796730'
UPDATE c_Package SET dose_unit = 'UNIT' WHERE package_id = 'PK1798389'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799228'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799230'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799694'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799696'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799697'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799704'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799706'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1799724'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799725'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799761'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799886'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799890'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799958'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1799959'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1805011'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1805012'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1805015'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1805016'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1807896'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808217'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808219'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808222'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808223'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808224'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808225'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808234'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1808235'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1809097'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1809102'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1809104'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1809421'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1809456'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1809728'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1812168'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1812170'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1812945'
UPDATE c_Package SET dose_unit = 'ML' WHERE package_id = 'PK1812951'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1813508'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1813513'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1859368'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1859370'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1859372'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1859373'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1859374'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK1859375'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1859553'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860132'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860135'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860136'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860139'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860239'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860241'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860463'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1860466'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1863343'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1864324'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1864326'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1868469'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1868482'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1868485'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1868486'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1868494'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1868497'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1868562'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1868565'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1872979'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1872980'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1876368'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921238'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1921240'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK1923484'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1928853'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1928858'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1928862'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK1928864'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1939322'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1947301'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK198219'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK198379'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK199212'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1992545'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK1992547'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1994347'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1994352'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK199584'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK199585'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK199727'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK199739'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK1999185'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK199947'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK199958'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK199965'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK2000011'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK2000013'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK2002002'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK200317'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK200318'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK200321'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK2003344'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK204401'
UPDATE c_Package SET dose_unit = 'VIAL' WHERE package_id = 'PK2044429'
UPDATE c_Package SET dose_unit = 'VIAL' WHERE package_id = 'PK2044431'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK204504'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK204520'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK205175'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK205296'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK206535'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK206536'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK206537'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK206819'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK206820'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK207014'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK207194'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK207198'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK207199'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK207200'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK207201'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK208104'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK208135'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK208137'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK208312'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK208452'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK209217'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK210676'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK211544'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK212844'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK213298'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK213638'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK237205'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK238014'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK238100'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK238101'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK238175'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK238720'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK240448'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK240754'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK240793'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK241162'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK242969'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK245319'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK245961'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK248009'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK248661'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK251817'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK253010'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK253113'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK262197'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK282485'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK282533'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK282561'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK282609'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK284397'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK284425'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK308516'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK308517'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK308869'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK308870'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK309279'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK309594'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK309650'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK309710'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK309953'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK309985'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK309986'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK309987'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK310592'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK311447'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK311448'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK311450'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK311451'
UPDATE c_Package SET dose_unit = 'GRAM' WHERE package_id = 'PK311452'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK311670'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK311700'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK311702'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312004'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312068'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312069'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312070'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312071'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK312083'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK312424'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK312507'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK312521'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK312903'
UPDATE c_Package SET dose_unit = 'MEQ' WHERE package_id = 'PK312973'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK314008'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK314152'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK314192'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK315105'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK315188'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK315199'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK317106'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK351154'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK351270'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK351290'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK352076'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK352297'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK352334'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK413132'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK435151'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK483017'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK486133'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK486419'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK543218'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK544915'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK562352'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK562675'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK603566'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK616366'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK643193'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK644301'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK646830'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK647121'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800188'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800858'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800929'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800933'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800976'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK800979'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK801024'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK801133'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK801136'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK801142'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK801145'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK801391'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK801413'
UPDATE c_Package SET dose_unit = 'SUPPRESS' WHERE package_id = 'PK801417'
UPDATE c_Package SET dose_unit = 'RETIRED' WHERE package_id = 'PK807383'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK828265'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK828267'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK829926'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK829928'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK847703'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK849329'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK849501'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK849503'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK849876'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK855911'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK856443'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK857705'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK858599'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK858603'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK858607'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK860005'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861672'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK861674'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK866508'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK884221'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK884223'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK884225'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK884227'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK885205'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK885207'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK892652'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK903694'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK966571'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK979113'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK979115'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK979432'
UPDATE c_Package SET dose_unit = 'MCG' WHERE package_id = 'PK979434'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK991065'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK991069'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK992460'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK992462'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK992858'
UPDATE c_Package SET dose_unit = 'MG' WHERE package_id = 'PK992876'

/*
select count(*) from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
where p.dose_unit = i.dose_unit 
-- 1694

select  [Status in Kenya Drug Set], count(*)
from [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary]
group by [Status in Kenya Drug Set]

SELECT 'UPDATE c_Drug_Formulation SET valid_in = ''us;ke;'' WHERE form_rxcui IN ('
union
select distinct  '''' + f.form_rxcui + ''','
from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
	join c_Drug_Formulation f on f.form_rxcui = i.form_rxcui2
where i.[Status in Kenya Drug Set] in (
'brand drug concept (SBD) PRESENT IN retention drugs in Kenya',
'generic drug concept (SCD) PRESENT IN retention drugs in Kenya',
'include in drug set')
and i.dose_unit NOT IN ('RETIRED','SUPPRESS')
and f.valid_in = 'us;'
-- 432 -- 614
*/

UPDATE c_Drug_Formulation SET valid_in = 'us;ke;' WHERE form_rxcui IN (
'792577',
'352044',
'727822',
'847627',
'1870207',
'205175',
'803364',
'805007',
'829762',
'242800',
'284192',
'854228',
'1796672',
'861379',
'1659929',
'1734683',
'803194',
'1799704',
'312521',
'992460',
'543218',
'727347',
'1115457',
'1870205',
'747260',
'798482',
'1010688',
'309090',
'312068',
'1860466',
'1597101',
'1115462',
'1719646',
'1807452',
'1860139',
'1551300',
'1727572',
'854239',
'647121',
'1661427',
'616238',
'861385',
'1734917',
'1726844',
'1743729',
'239200',
'991065',
'1743726',
'847241',
'1658142',
'349274',
'644301',
'1115259',
'847628',
'861381',
'1726997',
'1743833',
'204441',
'204520',
'1314133',
'1859374',
'1594334',
'204430',
'207194',
'1658058',
'1723232',
'1736546',
'731348',
'1946520',
'1115257',
'1926456',
'1657976',
'1665444',
'727316',
'848164',
'854242',
'1597103',
'253113',
'803369',
'1605066',
'1719015',
'848160',
'1010759',
'313115',
'731281',
'744808',
'859867',
'892531',
'1665229',
'727995',
'1726992',
'1876502',
'861363',
'1731582',
'207014',
'854248',
'1012066',
'1292440',
'312772',
'898589',
'1799694',
'1807637',
'731345',
'1115454',
'1795610',
'204504',
'1737852',
'1946522',
'1099648',
'1799706',
'284419',
'798430',
'1098137',
'1870225',
'1099048',
'238720',
'1099056',
'1650899',
'1652640',
'208137',
'861473',
'1743779',
'1010671',
'1654184',
'1792144',
'1795609',
'847703',
'1860241',
'1000154',
'260265',
'1876705',
'854249',
'1099052',
'1441422',
'208135',
'311282',
'790245',
'1734686',
'581531',
'1668238',
'807239',
'847199',
'1000126',
'1657658',
'1859553',
'1864324',
'238755',
'285018',
'1605172',
'1660014',
'1190112',
'1649944',
'1658244',
'1719862',
'1654179',
'1807638',
'1657974',
'1659260',
'1727569',
'1860482',
'805008',
'802652',
'797638',
'104897',
'1737850',
'311670',
'1657981',
'854236',
'1115467',
'1799886',
'1876710',
'1921466',
'238014',
'731328',
'763103',
'803367',
'1658156',
'239998',
'643193',
'1655960',
'847254',
'861365',
'309915',
'1115472',
'1300191',
'1659131',
'253010',
'803371',
'1441402',
'1115449',
'1115473',
'1799725',
'1990857',
'311036',
'861360',
'1795607',
'311026',
'898591',
'1012404',
'1244205',
'1658144',
'1658157',
'1743781',
'284441',
'727634',
'1653223',
'1666320',
'1868486',
'1991328',
'1358617',
'861463',
'1663224',
'1665060',
'1731995',
'1807459',
'1870232',
'1435115',
'1665212',
'1665697',
'205259',
'311683',
'861356',
'351154',
'1721314',
'1864423',
'1000128',
'1661432',
'1734919',
'283402',
'1652646',
'1737581',
'309336',
'1868473',
'1860239',
'847261',
'1658262',
'309339',
'313572',
'1860132',
'1090559',
'1665507',
'1807630',
'1809456',
'1665214',
'992858',
'1098122',
'1657982',
'1791408',
'584201',
'798428',
'1659988',
'1921465',
'309101',
'1719013',
'1799696',
'847621',
'1039654',
'1658066',
'1658060',
'1115459',
'1652242',
'1594418',
'727360',
'727759',
'1115456',
'1724666',
'1726846',
'1946521',
'1726204',
'1668240',
'731227',
'866508',
'1795346',
'1659149',
'1605171',
'1798389',
'1866559',
'1922512',
'1492043',
'207436',
'312507',
'349273',
'760039',
'861383',
'1010033',
'1358610',
'1864425',
'240754',
'1736931',
'1000153',
'1719286',
'1870230',
'727386',
'1665515',
'1807627',
'309953',
'1807633',
'1860135',
'540930',
'545837',
'1807896',
'1860136',
'1872979',
'1859375',
'727619',
'760029',
'1115447',
'1809728',
'1653142',
'1665210',
'727820',
'854255',
'1099060',
'486515',
'727539',
'790247',
'805010',
'284195',
'798479',
'854256',
'1730076',
'1860486',
'199739',
'1719291',
'1724668',
'731181',
'901640',
'1650922',
'2002419',
'483017',
'896854',
'1486496',
'1946772',
'804981',
'1010751',
'1736541',
'252484',
'1551306',
'835809',
'1860463',
'1989112',
'239212',
'1658065',
'885205',
'1115468',
'1657663',
'1868028',
'284193',
'1734921',
'1809421',
'1946519',
'1807636',
'1653225',
'1723160',
'211544',
'798426',
'1358612',
'1727001',
'1115464',
'847626',
'1741268',
'562724',
'284194',
'1099058',
'1807632',
'1665701',
'106892',
'1654169',
'309594',
'731334',
'797641',
'809158',
'200321',
'313920',
'798477',
'1809083',
'1872980',
'283504',
'1654171',
'727821',
'1665227',
'1807646',
'979432',
'830460',
'854232',
'1605071',
'1727000',
'309778',
'849501',
'309335',
'352045',
'603536',
'795144',
'847232',
'1661424',
'1743855',
'805009',
'894912',
'1659137',
'1795344',
'1795612',
'1653144',
'313002',
'1994311',
'1116294',
'1191234',
'1736919',
'798429',
'752388',
'1012068',
'1665052',
'859203',
'1799890',
'240912',
'312821',
'847630',
'1799724',
'727373',
'731333',
'834357',
'1795477',
'835945',
'727762',
'1594432',
'1650940',
'798481',
'1099054',
'238175',
'314097',
'809159',
'835840',
'865098')
-- (432 row(s) affected)

/*
select f.* from c_Drug_Package dp
join c_Package p on p.package_id = dp.package_id
join [dbo].[08_14_2020_Injectables Present and Not Present in KE_Formulary] i
	on i.form_rxcui2 = dp.form_rxcui
	join c_Drug_Formulation f on f.form_rxcui = i.form_rxcui2
where (i.[Status in Kenya Drug Set] in (
'RETIRED CONCEPT',
'Suppress. Not sure if found in Kenya Drug Set or Not.',
'This SBD concept not in retention drugs in Kenya',
'This SCD concept not in retention drugs in Kenya')
or  i.dose_unit  IN ('RETIRED','SUPPRESS'))
and f.valid_in  like '%ke;%'
-- 3
*/

EXEC sp_add_missing_drug_defn_pkg_adm_method