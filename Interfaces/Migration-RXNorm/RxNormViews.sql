
select * from rxnconso_full c
where (tty = 'PSN' OR (tty = 'SCD' 
						and not exists (select 1 from rxnconso_full f2
							where f2.rxcui = c.rxcui and f2.tty = 'PSN')))
and rxcui in (
'1549372',
'1000978',
'411846',
'1088455',
'1236182',
'198229',
'251135',
'836466',
'849329',
'854872',
'857705',
'992898',
'997550'
)
order by rxcui,tty,[str]

select c1.*
from rxnconso_full c
join RXNREL_FULL r ON r.RXCUI2 = c.rxcui
join rxnconso_full c1 ON r.RXCUI1 = c1.rxcui
where c.rxcui in (
'2284',
'257844',
'5542')
and c1.SAB = 'RXNORM'
and c.SAB = 'RXNORM'
and r.SAB = 'RXNORM'


select c1.*
from rxnconso c
join RXNREL r ON r.RXCUI2 = c.rxcui
join rxnconso c1 ON r.RXCUI1 = c1.rxcui
where c.rxcui in (
'2284',
'257844',
'5542')
and c1.SAB = 'RXNORM'
and c.SAB = 'RXNORM'
and r.SAB = 'RXNORM'


Cetrimides
Mefenamate
17-alpha-Hydroxyprogesterone
order by rxcui


CREATE VIEW vw_SCDC AS
SELECT c.rxcui as rxcui_scdc, 
	c1.rxcui as rxcui_scd, 
	'SCDC' AS TTY, 
	rtrim(CASE WHEN LEN(c.[str]) <= 1000 THEN c.[str] ELSE left(c.[str],997) + '...' END) as str_min
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'SCDC'
AND c.SAB = 'RXNORM'
AND r.rela = 'constitutes'
AND r.SAB = 'RXNORM'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'

CREATE VIEW vw_SCDC_full AS
SELECT c.rxcui as rxcui_scdc, 
	c1.rxcui as rxcui_scd, 
	'SCDC' AS TTY, 
	rtrim(CASE WHEN LEN(c.[str]) <= 1000 THEN c.[str] ELSE left(c.[str],997) + '...' END) as str_min
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'SCDC'
AND c.SAB = 'RXNORM'
AND r.rela = 'constitutes'
AND r.SAB = 'RXNORM'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'



CREATE VIEW vw_form_MIN AS
SELECT c1.rxcui AS form_rxcui, 
	c1.tty + '_' + c3.tty as form_tty, 
	c3.[str] as form_descr,
	c.rxcui AS ingr_rxcui,
	'MIN' AS ingr_tty
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN' -- prefer PSN
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 
UNION
SELECT c1.rxcui, 
	c1.tty, 
	rtrim(CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END) as str_scd,
	c.rxcui,
	'MIN' AS TTY
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'

select count(*) from vw_form_min where form_tty like '%PSN'

CREATE VIEW vw_form_MIN_full AS
SELECT c1.rxcui AS form_rxcui, 
	c1.tty + '_' + c3.tty as form_tty, 
	c3.[str] as form_descr,
	c.rxcui AS ingr_rxcui,
	'MIN' AS ingr_tty
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
JOIN interfaces..rxnconso_full c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN' -- prefer PSN
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 
UNION
SELECT c1.rxcui, 
	c1.tty, 
	rtrim(CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END) as str_scd,
	c.rxcui,
	'MIN' AS TTY
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY = 'MIN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredients_of'
AND c1.TTY = 'SCD'
AND c1.SAB = 'RXNORM'

create view vw_form_psn_in AS
SELECT 
	vw_SCDC.rxcui_scd as form_rxcui, 
	'SCD_PSN' as form_tty, 
	c3.[str] as form_descr,
	c.rxcui as ingr_rxcui, 
	'IN' AS ingr_tty
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN vw_SCDC ON vw_SCDC.rxcui_scdc = c1.rxcui
JOIN interfaces..rxnconso c3 ON c3.rxcui = vw_SCDC.rxcui_scd
WHERE c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c3.TTY = 'PSN'
AND c3.SAB = 'RXNORM' 
-- INs duplicate MINs, so avoid any for the same form_rxcui
AND NOT EXISTS (SELECT 1 FROM vw_form_min f
	WHERE f.form_rxcui = vw_SCDC.rxcui_scd)


create view vw_form_psn_in_full AS
SELECT 
	vw_SCDC_full.rxcui_scd as form_rxcui, 
	'SCD_PSN' as form_tty, 
	c3.[str] as form_descr,
	c.rxcui as ingr_rxcui, 
	'IN' AS ingr_tty
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
JOIN vw_SCDC_full ON vw_SCDC_full.rxcui_scdc = c1.rxcui
JOIN interfaces..rxnconso_full c3 ON c3.rxcui = vw_SCDC_full.rxcui_scd
WHERE c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c3.TTY = 'PSN'
AND c3.SAB = 'RXNORM' 
-- INs duplicate MINs, so avoid any for the same form_rxcui
AND NOT EXISTS (SELECT 1 FROM vw_form_min_full f
	WHERE f.form_rxcui = vw_SCDC_full.rxcui_scd)


select * 
into c_drug_Formulation3
from vw_form_psn_in_full
where ingr_rxcui in (
'2284',
'257844',
'5542')

create view vw_form_scd_in AS
SELECT 
	vw_SCDC.rxcui_scd as form_rxcui, 
	'SCD' as form_tty, 
	c3.[str] as form_descr,
	c.rxcui as ingr_rxcui, 
	'IN' AS ingr_tty
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
JOIN vw_SCDC ON vw_SCDC.rxcui_scdc = c1.rxcui
JOIN interfaces..rxnconso c3 ON c3.rxcui = vw_SCDC.rxcui_scd
WHERE c.TTY = 'IN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SCDC'
AND c1.SAB = 'RXNORM' 
AND c3.TTY = 'SCD'
AND c3.SAB = 'RXNORM' 
-- INs duplicate MINs, so avoid any for the same form_rxcui
AND NOT EXISTS (SELECT 1 FROM vw_form_min f
	WHERE f.form_rxcui = vw_SCDC.rxcui_scd)

create view vw_brand_forms as
SELECT r.RXCUI2 as rxcui_sbd, r.RXCUI1 as rxcui_scd
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY IN ('SBD')
AND c.SAB = 'RXNORM'
AND c1.TTY IN ('SCD')
AND c1.SAB = 'RXNORM'
AND r.rela = 'tradename_of'
AND c.SUPPRESS = 'N'
AND c1.SUPPRESS = 'N'


create view vw_brand_forms_full as
SELECT r.RXCUI2 as rxcui_sbd, r.RXCUI1 as rxcui_scd
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.rxcui1
WHERE c.TTY IN ('SBD')
AND c.SAB = 'RXNORM'
AND c1.TTY IN ('SCD')
AND c1.SAB = 'RXNORM'
AND r.rela = 'tradename_of'
AND c.SUPPRESS = 'N'
AND c1.SUPPRESS = 'N'


create view vw_form_psn_bn AS
SELECT c1.rxcui as form_rxcui, 
	c1.tty + '_' + c3.tty as form_tty, 
	CASE WHEN LEN(c3.[str]) <= 1000 THEN c3.[str] ELSE left(c3.[str],997) + '...' END as form_descr,
	c.rxcui as ingr_rxcui,
	'BN' AS ingr_tty
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.RXCUI1
JOIN interfaces..rxnconso c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
JOIN vw_brand_forms bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 


create view vw_form_sbd_bn AS
SELECT c1.rxcui as form_rxcui, 
	c1.tty as form_tty, 
	CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END as form_descr,
	c.rxcui as ingr_rxcui,
	'BN' AS ingr_tty
FROM interfaces..rxnconso c
JOIN interfaces..rxnrel r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso c1 ON c1.rxcui = r.RXCUI1
JOIN vw_brand_forms bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 

create view vw_form_psn_bn_full AS
SELECT c1.rxcui as form_rxcui, 
	c1.tty + '_' + c3.tty as form_tty, 
	CASE WHEN LEN(c3.[str]) <= 1000 THEN c3.[str] ELSE left(c3.[str],997) + '...' END as form_descr,
	c.rxcui as ingr_rxcui,
	'BN' AS ingr_tty
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.RXCUI1
JOIN interfaces..rxnconso_full c3 
	ON c3.rxcui = c1.rxcui and c3.tty = 'PSN'
JOIN vw_brand_forms_full bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 
AND c3.SAB = 'RXNORM' 

create view vw_form_sbd_bn_full AS
SELECT c1.rxcui as form_rxcui, 
	c1.tty as form_tty, 
	CASE WHEN LEN(c1.[str]) <= 1000 THEN c1.[str] ELSE left(c1.[str],997) + '...' END as form_descr,
	c.rxcui as ingr_rxcui,
	'BN' AS ingr_tty
FROM interfaces..rxnconso_full c
JOIN interfaces..rxnrel_full r ON r.RXCUI2 = c.RXCUI
JOIN interfaces..rxnconso_full c1 ON c1.rxcui = r.RXCUI1
JOIN vw_brand_forms_full bf ON bf.rxcui_sbd = c1.rxcui
WHERE c.TTY = 'BN'
AND c.SAB = 'RXNORM'
AND r.rela = 'ingredient_of'
AND c1.TTY = 'SBD'
AND c1.SAB = 'RXNORM' 

insert into c_drug_Formulation3
select * from vw_form_psn_bn
where ingr_rxcui IN (
'218486',
'727279')

insert into c_drug_Formulation3
select * from vw_form_sbd_bn
where ingr_rxcui IN (
-- '218486',
-- '727279'),
'1086383',
'1087205',
'1087246',
'1087282',
'1087299',
'1087396',
'1088927',
'1090912',
'1095605',
'1293415',
'1372721',
'1423388',
'219298',
'219301',
'404991',
'404993',
'68728',
'802647',
'802648',
'826624',
'877478',
'881173',
'92573',
'978677',
'999736')
order by ingr_rxcui

insert into c_drug_Formulation3
select * from vw_form_sbd_bn_full
where ingr_rxcui IN (
'215824')

--(4 row(s) affected)

--(26 row(s) affected)

--(1 row(s) affected)
1372721 Hematogen


select '''' + form_rxcui + ''','
from c_drug_Formulation3

/*
SET PATH_TO_BCP="C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\130\Tools\Binn\bcp.exe"
SET MSSQLSERVER=DESKTOP-GU15HUD\ENCOUNTERPRO

%PATH_TO_BCP% c_Drug_Formulation3 out c_Drug_Formulation3.txt -S %MSSQLSERVER% -d interfaces -T -c

*/

select * from vw_form_psn_in_full
where ingr_rxcui in('87636')

select * from RXNCONSO_FULL
where rxcui = '199534'
and sab = 'RXNORM'