


drop table if exists #generic_orig
select distinct generic_rxcui, generic_name, drug_id
into #generic_orig
FROM c_Drug_Generic g
-- (4093 rows affected)

drop table if exists #generic_mod
select distinct generic_rxcui, generic_name, drug_id
into #generic_mod
FROM c_Drug_Generic g
-- exclude vaccines and so on, to avoid erroneous splitting/re-joining 
WHERE generic_name NOT LIKE '%CHOLERA%'
AND generic_name NOT LIKE '%VACCINE%'
AND generic_name NOT LIKE '%VIRUS%'
AND generic_name NOT LIKE '%HEPATITIS%'
AND generic_name NOT LIKE '%COAGULATION%'
AND generic_name NOT LIKE '%tetanus%'
AND generic_name NOT LIKE '%RUBELLA%'
AND generic_name NOT LIKE '%MONOCLONAL%'
AND generic_name NOT LIKE '%RABIES%'
AND generic_name NOT LIKE '%antigen%'
AND generic_name not like '% Kit'
-- (4005 rows affected)

-- split out the existing names as a dictionary
drop table if exists #dictionary
select distinct generic_rxcui, trim(value) as generic_name
into #dictionary
from #generic_mod
cross apply string_split(generic_name,'/') 
-- (6958 rows affected)

-- Set lower case unless matching tall_man
UPDATE g
SET generic_name = lower(g.generic_name)
-- select generic_name, lower(generic_name)
FROM #dictionary g
left JOIN c_Drug_Tall_Man m ON g.generic_name = m.spelling COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE m.spelling IS NULL
-- ORDER BY generic_name
-- (6476 rows affected)

-- Must set the vitamins back to uppercase, and various acronyms
UPDATE g
SET generic_name = replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
	replace(replace(replace(
	generic_name,
	'vitamin b 12','vitamin B12'),
	'vitamin a','vitamin A'),
	'vitamin b','vitamin B'),
	'vitamin c','vitamin C'),
	'vitamin d','vitamin D'),
	'vitamin e','vitamin E'),
	'vitamin h','vitamin H'),
	'vitamin k','vitamin K'),
	'polymyxin b','polymyxin B'),
	't-lymph','T-lymph'),
	'lactobacillus','Lactobacillus'),
	'rhamnosus gg','rhamnosus GG'),
	'factor xiii','Factor XIII'),
	'factor viii','Factor VIII'),
	'factor vii','Factor VII'),
	'factor ix','Factor IX'),
	'factor x','Factor X'),
	'iron(iii)','iron (III)'),
	'(nph)','(NPH)'),
	'african','African'),
	'arizona','Arizona'),
	'atlantic','Atlantic'),
	'australian','Australian'),
	'austrian','Austrian'),
	'siberian','Siberian'),
	'european','European'),
	'canada','Canada'),
	'canadian','Canadian'),
	'california','California'),
	'english','English'),
	'german ','German '),
	'japanese','Japanese'),
	'jerusalem','Jerusalem'),
	'mexican','Mexican'),
	'pacific','Pacific'),
	'pau d''arco','Pau d''Arco'),
	'pepsin a','pepsin A'),
	'amphotericin b','amphotericin B'),
	'anamu preparation','ANAMU preparation'),
	'antithrombin iii','antithrombin III'),
	'angiotensin ii','angiotensin II'),
	'bacillus coagulans','Bacillus coagulans'),
	'b.pertussis','B. pertussis'),
	'type a','type A'),
	'type b','type B'),
	'hepatitis a','hepatitis A'),
	'hepatitis b','hepatitis B'),
	'bcg','BCG'),
	'bacillus calmette-guerin','Bacillus Calmette-Guerin'),
	'danish','Danish'),
	'tice ','Tice '),
	'korean','Korean'),
	'timothy','Timothy'),
	'johnson','Johnson'),
	'bifidobacterium','Bifidobacterium'),
	'bordetella','Bordetella'),
	'connaught','Connaught'),
	'mahoney','Mahoney'),
	'mef-1','MEF-1'),
	'saukett','Saukett'),
	'fab2','FAB2'),
	'fab fragments','Fab fragments'),
	'toxin a','toxin A'),
	'toxin b','toxin B'),
	'toxin c','toxin C'),
	'toxin d','toxin D'),
	'toxin e','toxin E'),
	'toxin f','toxin F'),
	'toxin g','toxin G'),
	'globulin iv','globulin IV'),
	'peruvian','Peruvian'),
	'centruroides','Centruroides'),
	'f(ab'')2','FAB2'),
	'coenzyme r','coenzyme R'),
	'coenzyme q','coenzyme Q'),
	'willebrand','Willebrand'),
	'fe heme','Fe-heme'),
	'ross','Ross'),
	'group a','group A'),
	'group b','group B'),
	'group c','group C'),
	'group y','group Y'),
	'gbm','GBM'),
	'hm175','HM175'),
	'p1a[8]','P1A[8]'),
	'c1','C1'),
	'g1','G1'),
	'g2','G2'),
	'g3','G3'),
	'g4','G4'),
	'g-f 20','G-F 20'),
	'immunoglobulin g','immunoglobulin G'),
	'kentucky','Kentucky'),
	'lombardy','Lombardy'),
	'l-ornithine-l-aspartate','L-ornithine-L-aspartate'),
	'l-histidine','L-histidine'),
	'l-lysine','L-lysine'),
	'l1 protein','L1 protein'),
	'rit 4385','RIT 4385'),
	'schwarz','Schwarz'),
	'jeryl lynn','Jeryl Lynn'),
	'wistar ra 27-3','Wistar RA 27-3'),
	'oka-merck','Oka-Merck'),
	'oka','Oka'),
	'enders','Enders'),
	'edmonston','Edmonston'),
	'crm197','CRM197'),
	'lp2086 a05','LP2086 A05'),
	'lp2086 b01','LP2086 B01'),
	'neisseria','Neisseria'),
	'w-135','W-135'),
	'north american','North American'),
	'american','American'),
	'russian','Russian'),
	'prussian','prussian'),
	'rho(d)','rho(D)'),
	'penicillin g','penicillin G'),
	'penicillin v','penicillin V'),
	'rimabotulinumtoxinb','rimabotulinumtoxinB'),
	'protein c','protein C'),
	'protein s','protein S'),
	'ra-223','RA-223'),
	'g1p','G1P'),
	'st. john''s wort extract','St. John''s Wort extract'),
	'6a','6A'),
	'6b','6B'),
	'7f','7F'),
	'9v','9V'),
	'10a','10A'),
	'11a','11A'),
	'12f','12F'),
	'15b','15B'),
	'17f','17F'),
	'18c','18C'),
	'19a','19A'),
	'19f','19F'),
	'22f','22F'),
	'23f','23F'),
	'bcg','BCG'),
	'sipuleucel-t','sipuleucel-T'),
	'estrogens, a','estrogens, A'),
	'estrogens, b','estrogens, B'),
	's typhi Ty 2','Salmonella typhi Ty 2'),
	'vi polysaccharide','Vi polysaccharide'),
	'glycoprotein e','glycoprotein E'),
	'varicella','Varicella'),
	'streptococcus','Streptococcus'),
	'haemophilus','Haemophilus'),
	'agkistrodon','Agkistrodon'),
	'crotalus','Crotalus'),
	'zinc-dtpa','Zinc-DTPA')
-- select generic_name, lower(generic_name)
FROM #dictionary g
-- (6958 rows affected)

-- inadvertant capitalising of Conjugate when doing protein C
UPDATE g
SET generic_name = replace(generic_name,'protein Co','protein co')
FROM #dictionary g
WHERE generic_name like '%protein Co%' 
-- (1 rows affected)

UPDATE d
SET d.generic_name = replace( d.generic_name, t.spelling COLLATE SQL_Latin1_General_CP1_CI_AS , t.spelling)
from #dictionary d
join c_Drug_Tall_Man t ON d.generic_name COLLATE SQL_Latin1_General_CP1_CI_AS like '%' + t.spelling + '%'
AND d.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS not like '%' + t.spelling + '%'
-- (112 rows affected)

drop table if exists #drive_update
select d.generic_name as old, d.generic_name as new
into #drive_update
from #dictionary d

-- Handle instances where substitute is different characters (not covered above)
insert into #drive_update values
('b.pertussis','B. pertussis'), 
('f(ab'')2','FAB2'), 
('fe heme','Fe-heme'), 
('iron(iii)','iron (III)'), 
('s typhi Ty 2','Salmonella typhi Ty 2'),
('vitamin b 12','vitamin B12')


DECLARE @old varchar(200), @new varchar(200)
DECLARE cr_update CURSOR FOR 
select old, new from #drive_update

OPEN cr_update

FETCH NEXT FROM cr_update INTO @old, @new
 
WHILE @@FETCH_STATUS = 0
	BEGIN

	UPDATE  o
	set generic_name =  replace(generic_name, @old, @new)
	from #generic_orig o 
	where o.generic_name like '%' + @old + '%'	

	FETCH NEXT FROM cr_update INTO @old, @new
	END

CLOSE cr_update
DEALLOCATE cr_update

/*
select * from #generic_orig
order by generic_name
 -- (4086 rows affected)
*/

UPDATE g
SET generic_name = o.generic_name
-- select g.generic_name, o.generic_name 
from #generic_orig o
join c_Drug_Generic g on g.drug_id = o.drug_id
where g.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS != o.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS
-- (2035 rows affected)

UPDATE d
SET generic_name = CASE WHEN LEN(o.generic_name) <= 500 THEN o.generic_name ELSE left(o.generic_name,497) + '...' END
-- select g.drug_id, g.generic_name, o.generic_name 
from #generic_orig o
join c_Drug_Definition d on d.drug_id = o.drug_id
where d.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS != o.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS
-- (2015 rows affected)

UPDATE d
SET common_name = CASE WHEN LEN(o.generic_name) <= 80 THEN o.generic_name ELSE left(o.generic_name,77) + '...' END
-- select d.drug_id, d.common_name, o.generic_name 
from #generic_orig o
join c_Drug_Definition d on d.drug_id = o.drug_id
where d.common_name COLLATE SQL_Latin1_General_CP1_CS_AS != o.generic_name COLLATE SQL_Latin1_General_CP1_CS_AS
-- (2161 rows affected)
