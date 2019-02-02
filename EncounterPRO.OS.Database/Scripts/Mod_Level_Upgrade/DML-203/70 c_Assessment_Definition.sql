-- ICD10_who additions
UPDATE d
SET icd10_who_code = w.code
FROM c_Assessment_Definition d
JOIN icd10_who w ON w.code = d.icd10_code

INSERT INTO c_Assessment_Definition 
(
	[assessment_id]    -- use "WHO-" + icd10_who
	,[icd10_who_code]
    ,[assessment_type]  -- assign according to first 3 ICD10 characters
    ,[assessment_category_id]  --  assign according to first 3 ICD10 characters
    ,[description]    -- truncated ICD10 description
    ,[long_description]  -- ICD10 description
	,[risk_level]
	,[acuteness]  -- defaults to Acute
	,[source]
)
SELECT 'WHO-' + code, 
	code, 
	(SELECT max(assessment_type) 
		FROM c_Assessment_Category ac
		WHERE icd.code BETWEEN ac.icd10_start AND ac.icd10_end + 'ZZZ'),
	(SELECT max(assessment_category_id) 
		FROM c_Assessment_Category ac
		WHERE icd.code BETWEEN ac.icd10_start AND ac.icd10_end + 'ZZZ'),
	CASE WHEN len(descr) <= 80 THEN replace(descr,'"','') ELSE substring(replace(descr,'"',''),1,77) + '...' END,
	CASE WHEN len(descr) <= 80 THEN NULL ELSE replace(descr,'"','') END,
	2,
	'',
	'WHO'
FROM icd10_who icd
WHERE NOT EXISTS (SELECT 1 FROM c_Assessment_Definition m WHERE m.icd10_who_code = icd.code)
AND icd.active = 'Y'
ORDER BY code
-- 9080


-- pre- Ciru feedback updates
UPDATE c_Assessment_Definition 
SET description = replace(description,'small pox','Smallpox')
WHERE description like 'small pox%'

-- cleanup
DELETE FROM c_Assessment_Definition WHERE assessment_id = '0^11772'

-- orphaned category, leftover from script, "copy" literally in values
DELETE FROM c_Assessment_Definition
WHERE assessment_category_id = 'ZZZGICOPY'

-- orphaned category, apparent typo (1 record)
UPDATE c_Assessment_Definition 
SET assessment_category_id = 'WOUND'
WHERE assessment_category_id = 'WOUNDP'

-- Just really superior descriptions
UPDATE c_Assessment_Definition 
SET description = long_description
-- SELECT description, long_description FROM c_Assessment_Definition
WHERE assessment_id IN (
'DEMO6674',
'DEMO6674Q',
'DEMO1409',
'DEMO1409A',
'DEMO4831',
'DEMO4831A',
'DEMO6525Q',
'DEMO6528Q',
'DEMO6637Q',
'DEMO6638Q',
'DEMO6639Q',
'DEMO6641Q',
'DEMO6636Q',
'DEMO11416aQ',
'DEMO11416bQ',
'DEMO11416cQ',
'DEMO11416dQ',
'DEMO11416eQ',
'DEMO11416fQ',
'DEMO11416gQ',
'DEMO11416hQ',
'DEMO9434'
)

-- Spelling corrections
UPDATE c_Assessment_Definition 
SET description = 'Newborn affected by maternal injury' 
WHERE description = 'Newborn affected my maternal injury'

UPDATE c_Assessment_Definition 
SET description = REPLACE(description,'localizes','localized')
WHERE description LIKE '%localizes%'

UPDATE c_Assessment_Definition 
SET long_description = REPLACE(long_description,'localizes','localized')
WHERE long_description LIKE '%localizes%'

UPDATE icd10cm_codes
SET descr = REPLACE(descr,'localizes','localized')
WHERE descr LIKE '%localizes%'


-- Reset some 'AANEW'
UPDATE c_Assessment_Definition 
SET assessment_category_id ='NOEAR' 
WHERE assessment_id = '0^V72.19^0'
UPDATE c_Assessment_Definition 
SET assessment_category_id ='YMMM' 
WHERE assessment_id = '981^V58.32^0'

-- Added source column population
UPDATE c_Assessment_Definition 
SET [source] = CASE WHEN assessment_id LIKE 'ICD-%' THEN 'MainT'
				WHEN assessment_id LIKE 'Dx-%' THEN 'Dx'
				ELSE 'Orig' END
WHERE 1=1

-- Ciru updates 18/12/2018 
-- Initial_Assessment_Definition_table_with_comments.ods

-- Deletions

--		Multiple replacements in child tables

IF EXISTS (SELECT * FROM u_assessment_treat_definition
	WHERE assessment_id = 'DEMO6767')
	BEGIN
EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$', 'ICD-H60531', '$', 'Append';
EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$', 'ICD-H60532', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$', 'ICD-H60533', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$', 'ICD-H60539', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$FP', 'ICD-H60531', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$FP', 'ICD-H60532', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$FP', 'ICD-H60533', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$FP', 'ICD-H60539', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$NEUROLOGY', 'ICD-H60531', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$NEUROLOGY', 'ICD-H60532', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$NEUROLOGY', 'ICD-H60533', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$NEUROLOGY', 'ICD-H60539', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$PEDS', 'ICD-H60531', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$PEDS', 'ICD-H60532', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$PEDS', 'ICD-H60533', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6767', '$PEDS', 'ICD-H60539', '$PEDS', 'Append';
	END

IF EXISTS (SELECT * FROM u_assessment_treat_definition
	WHERE assessment_id = 'DEMO6768')
	BEGIN
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$', 'ICD-H60541', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$', 'ICD-H60542', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$', 'ICD-H60543', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$', 'ICD-H60549', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$FP', 'ICD-H60541', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$FP', 'ICD-H60542', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$FP', 'ICD-H60543', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$FP', 'ICD-H60549', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$NEUROLOGY', 'ICD-H60541', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$NEUROLOGY', 'ICD-H60542', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$NEUROLOGY', 'ICD-H60543', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$NEUROLOGY', 'ICD-H60549', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$PEDS', 'ICD-H60541', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$PEDS', 'ICD-H60542', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$PEDS', 'ICD-H60543', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6768', '$PEDS', 'ICD-H60549', '$PEDS', 'Append';
	END

IF EXISTS (SELECT * FROM u_assessment_treat_definition
	WHERE assessment_id = 'DEMO6769')
	BEGIN
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$', 'ICD-H60551', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$', 'ICD-H60552', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$', 'ICD-H60553', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$', 'ICD-H60559', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$FP', 'ICD-H60551', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$FP', 'ICD-H60552', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$FP', 'ICD-H60553', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$FP', 'ICD-H60559', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$NEUROLOGY', 'ICD-H60551', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$NEUROLOGY', 'ICD-H60552', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$NEUROLOGY', 'ICD-H60553', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$NEUROLOGY', 'ICD-H60559', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$PEDS', 'ICD-H60551', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$PEDS', 'ICD-H60552', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$PEDS', 'ICD-H60553', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO6769', '$PEDS', 'ICD-H60559', '$PEDS', 'Append';
	END

DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO6767'
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO6768'
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO6769'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H60541'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO6768'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H60542'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO6768'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H60543'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO6768'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H60549'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO6768'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO6768'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO6767', 'DEMO6768', 'DEMO6769')

IF EXISTS (SELECT * FROM u_assessment_treat_definition
	WHERE assessment_id = 'DEMO197')
	BEGIN
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$', 'ICD-M2681', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$', 'ICD-M2682', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$FP', 'ICD-M2681', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$FP', 'ICD-M2682', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$NEUROLOGY', 'ICD-M2681', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$NEUROLOGY', 'ICD-M2682', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$PEDS', 'ICD-M2681', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'DEMO197', '$PEDS', 'ICD-M2682', '$PEDS', 'Append';
	END

DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO197'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-M2681'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO197'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-M2682'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO197'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO197'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO197')

IF EXISTS (SELECT * FROM u_assessment_treat_definition
	WHERE assessment_id = 'HEARMIX')
	BEGIN
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$', ' ICD-H9072', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$', 'ICD-H906', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$', 'ICD-H9071', '$', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$FP', ' ICD-H9072', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$FP', 'ICD-H906', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$FP', 'ICD-H9071', '$FP', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$NEUROLOGY', ' ICD-H9072', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$NEUROLOGY', 'ICD-H906', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$NEUROLOGY', 'ICD-H9071', '$NEUROLOGY', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$PEDS', ' ICD-H9072', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$PEDS', 'ICD-H906', '$PEDS', 'Append';
	EXEC jmj_copy_assessment_treatment_list 'HEARMIX', '$PEDS', 'ICD-H9071', '$PEDS', 'Append';
	END

DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'HEARMIX'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H906'
FROM c_Common_Assessment
WHERE assessment_id = 'HEARMIX'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H9071'
FROM c_Common_Assessment
WHERE assessment_id = 'HEARMIX'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H9072'
FROM c_Common_Assessment
WHERE assessment_id = 'HEARMIX'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'HEARMIX'

-- Just use one of them for top 20 list
UPDATE u_top_20
SET item_id = 'ICD-H906'
WHERE item_id = 'HEARMIX'
AND top_20_code = 'ASSESSMENT_SICK'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('HEARMIX')



INSERT INTO c_Common_Assessment
SELECT specialty_id, 'DEMO11414'
FROM c_Common_Assessment
WHERE assessment_id = 'PREC'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'DEMO11415'
FROM c_Common_Assessment
WHERE assessment_id = 'PREC'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'PREC'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('PREC')



INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H5021'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11441'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-H5022'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11441'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11441'

-- Just use one of them for top 20 list
UPDATE u_top_20
SET item_id = 'ICD-H5021'
WHERE item_id = 'DEMO11441'
AND top_20_code = 'ASSESSMENT_SICK'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO11441')


INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O2640'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11340'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O2641'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11340'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O2642'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11340'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O2643'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11340'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO11340'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO11340')



INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O98011'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10762'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O98012'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10762'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-O98013'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10762'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10762'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO10762')



INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1500XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1501XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'DEMO3140'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1510XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1511XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1580XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1581XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'DEMO3141'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'
AND NOT EXISTS (SELECT 1 FROM c_Common_Assessment WHERE assessment_id = 'DEMO3141')

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1590XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1591XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO9938'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO9938')



INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1510XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10660'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1511XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10660'

INSERT INTO c_Common_Assessment
SELECT specialty_id, 'ICD-T1512XA'
FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10660'

DELETE FROM c_Common_Assessment
WHERE assessment_id = 'DEMO10660'

DELETE FROM c_Assessment_Definition
WHERE assessment_id IN ('DEMO10660')



--			Single replacements in child tables

UPDATE u_assessment_treat_definition set assessment_id = '0^288.50^0' WHERE assessment_id = 'DEMO249'
UPDATE u_assessment_treat_definition set assessment_id = '0^V72.11^1' WHERE assessment_id = '0^V72.11^0'
UPDATE u_assessment_treat_definition set assessment_id = '0^V85.52^0' WHERE assessment_id = '981^V85.2^0'
UPDATE u_assessment_treat_definition set assessment_id = '0^V85.53^0' WHERE assessment_id = '981^V85.3^0'
UPDATE u_assessment_treat_definition set assessment_id = '0^V85.54^0' WHERE assessment_id = '981^V85.4^0'
UPDATE u_assessment_treat_definition set assessment_id = '2209^278.02^0' WHERE assessment_id = '0^11958'
UPDATE u_assessment_treat_definition set assessment_id = '981^277.30^0' WHERE assessment_id = 'DEMO4806'
UPDATE u_assessment_treat_definition set assessment_id = '981^608.20^0' WHERE assessment_id = 'TESTTORS'
UPDATE u_assessment_treat_definition set assessment_id = '981^995.20^0' WHERE assessment_id = 'REAM'
UPDATE u_assessment_treat_definition set assessment_id = '981^995.20^0' WHERE assessment_id = '981^995.20^1'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO102' WHERE assessment_id = 'DEMO10257'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO1033' WHERE assessment_id = 'DEMO11050'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO10742' WHERE assessment_id = 'DEMO10186'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO11144' WHERE assessment_id = 'DEMO1067'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO11144' WHERE assessment_id = 'DEMO11145'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO1269' WHERE assessment_id = '0^11578'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO1461' WHERE assessment_id = 'DEMO10620'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO1855' WHERE assessment_id = 'DEMO10539'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO281' WHERE assessment_id = 'DEMO11398'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO3026' WHERE assessment_id = 'BITEIN'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO3820' WHERE assessment_id = 'DEMO10652'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO3820' WHERE assessment_id = 'DEMO10651'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO4792' WHERE assessment_id = 'DEMO10476'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO4868' WHERE assessment_id = 'DEMO10277'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO495' WHERE assessment_id = 'DEMO11456'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO510' WHERE assessment_id = 'DEMO9973'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO6437' WHERE assessment_id = 'DEMO10666'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO6593' WHERE assessment_id = 'DEMO11448'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO760' WHERE assessment_id = 'DEMO761'
UPDATE u_assessment_treat_definition set assessment_id = 'DEMO9069' WHERE assessment_id = 'SPEECH'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-A86' WHERE assessment_id = 'DEMO7172'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-C44201' WHERE assessment_id = 'DEMO394'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-C4489' WHERE assessment_id = 'DEMO8373'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-C4490' WHERE assessment_id = 'CASKI'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-D490' WHERE assessment_id = 'DEMO8913'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-D569' WHERE assessment_id = 'THAL'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-E213' WHERE assessment_id = 'DEMO4671'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-E860' WHERE assessment_id = 'DEHY'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-F17200' WHERE assessment_id = 'TOB'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-G9340' WHERE assessment_id = 'DEMO7337'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-H109' WHERE assessment_id = '0^Conjunctivit^0'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-H16229' WHERE assessment_id = 'DEMO11449'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-H5350' WHERE assessment_id = 'DEMO11447'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-I421' WHERE assessment_id = 'DEMO1752'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-I82A19' WHERE assessment_id = 'DEMO356'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-J09X2' WHERE assessment_id = '981^488.1^1'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K2270' WHERE assessment_id = 'DEMO11490'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K280' WHERE assessment_id = '0^11600'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K283' WHERE assessment_id = '0^11605'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K284' WHERE assessment_id = '0^11606'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K2901' WHERE assessment_id = '0^11586'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-K8020' WHERE assessment_id = '0^11582'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-L519' WHERE assessment_id = 'ERYM'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-M799' WHERE assessment_id = 'DEMO3828'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-N4403' WHERE assessment_id = 'DEMO8978'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-N4404' WHERE assessment_id = 'DEMO8977'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-N6481' WHERE assessment_id = 'DEMO745'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-O903' WHERE assessment_id = '00014xxx'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P006' WHERE assessment_id = 'DEMO6504Q'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P120' WHERE assessment_id = 'CAP'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P120' WHERE assessment_id = 'CAPQ'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P120' WHERE assessment_id = 'CEPH'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P120' WHERE assessment_id = 'CEPHQ'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P121' WHERE assessment_id = 'CHI'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-P121' WHERE assessment_id = 'CHIQ'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R042' WHERE assessment_id = 'HEMOP'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R067' WHERE assessment_id = 'DEMO2115'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10811' WHERE assessment_id = '0^11563'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10812' WHERE assessment_id = '0^11564'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10813' WHERE assessment_id = '0^11565'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10814' WHERE assessment_id = '0^11566'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10815' WHERE assessment_id = '0^11567'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10816' WHERE assessment_id = '0^11568'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10817' WHERE assessment_id = '0^11569'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R10817' WHERE assessment_id = '0^11570'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1084' WHERE assessment_id = '0^11561'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1084' WHERE assessment_id = '0^11562'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R159' WHERE assessment_id = 'ENC'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1901' WHERE assessment_id = '0^11552'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1902' WHERE assessment_id = '0^11553'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1903' WHERE assessment_id = '0^11554'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1904' WHERE assessment_id = '0^11555'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1905' WHERE assessment_id = '0^11556'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1906' WHERE assessment_id = '0^11557'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1907' WHERE assessment_id = '0^11558'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1907' WHERE assessment_id = '0^11559'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1931' WHERE assessment_id = '0^11571'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1932' WHERE assessment_id = '0^11572'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1933' WHERE assessment_id = '0^11573'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1934' WHERE assessment_id = '0^11574'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1935' WHERE assessment_id = '0^11575'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1936' WHERE assessment_id = '0^11576'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R1937' WHERE assessment_id = '0^11577'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R194' WHERE assessment_id = '0^11581'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-R319' WHERE assessment_id = 'HEMU'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T360X5A' WHERE assessment_id = 'DEMO9952'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T362X5A' WHERE assessment_id = 'DEMO9954'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T367X5A' WHERE assessment_id = 'DEMO9953'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T39091A' WHERE assessment_id = 'DEMO9853'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T398X1A' WHERE assessment_id = 'DEMO9858'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T398X1A' WHERE assessment_id = 'DEMO9864'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T3991XA' WHERE assessment_id = 'DEMO9859'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T403X1A' WHERE assessment_id = 'DEMO9851'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T423X2A' WHERE assessment_id = 'DEMO9976'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T45515A' WHERE assessment_id = '0001125x'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T466X5A' WHERE assessment_id = '0001126x'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T50901A' WHERE assessment_id = 'DEMO9904'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T8069XA' WHERE assessment_id = 'DEMO11339'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T8110XA' WHERE assessment_id = 'DEMO3386'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T8544XA' WHERE assessment_id = 'DEMO747'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-T887XXA' WHERE assessment_id = 'DEMO10324'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-Z189' WHERE assessment_id = 'FB'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-Z30430' WHERE assessment_id = 'DEMO1158'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-Z30430' WHERE assessment_id = 'DEMO9448'
UPDATE u_assessment_treat_definition set assessment_id = 'ICD-Z317' WHERE assessment_id = 'DEMO9466'


UPDATE c_Common_Assessment set assessment_id = '0^288.50^0' WHERE assessment_id = 'DEMO249'
UPDATE c_Common_Assessment set assessment_id = '0^V72.11^1' WHERE assessment_id = '0^V72.11^0'
UPDATE c_Common_Assessment set assessment_id = '0^V85.52^0' WHERE assessment_id = '981^V85.2^0'
UPDATE c_Common_Assessment set assessment_id = '0^V85.53^0' WHERE assessment_id = '981^V85.3^0'
UPDATE c_Common_Assessment set assessment_id = '0^V85.54^0' WHERE assessment_id = '981^V85.4^0'
UPDATE c_Common_Assessment set assessment_id = '2209^278.02^0' WHERE assessment_id = '0^11958'
UPDATE c_Common_Assessment set assessment_id = '981^277.30^0' WHERE assessment_id = 'DEMO4806'
UPDATE c_Common_Assessment set assessment_id = '981^608.20^0' WHERE assessment_id = 'TESTTORS'
UPDATE c_Common_Assessment set assessment_id = '981^995.20^0' WHERE assessment_id = 'REAM'
UPDATE c_Common_Assessment set assessment_id = '981^995.20^0' WHERE assessment_id = '981^995.20^1'
UPDATE c_Common_Assessment set assessment_id = 'DEMO102' WHERE assessment_id = 'DEMO10257' AND specialty_id = '$DERM'
DELETE FROM c_Common_Assessment WHERE assessment_id = 'DEMO10257'
UPDATE c_Common_Assessment set assessment_id = 'DEMO1033' WHERE assessment_id = 'DEMO11050'
UPDATE c_Common_Assessment set assessment_id = 'DEMO10742' WHERE assessment_id = 'DEMO10186' AND specialty_id != '$OBGYN'
DELETE FROM c_Common_Assessment WHERE assessment_id = 'DEMO10186'

DELETE FROM c_Common_Assessment WHERE assessment_id = 'DEMO1067'
DELETE FROM c_Common_Assessment WHERE assessment_id = 'DEMO11145'
DELETE FROM c_Common_Assessment WHERE assessment_id = '0^11578'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO10620'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO10539'

UPDATE c_Common_Assessment set assessment_id = 'DEMO3026' WHERE assessment_id = 'BITEIN' AND specialty_id != '$DERM'
DELETE FROM c_Common_Assessment where assessment_id = 'BITEIN'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO10652'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO10651'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO11456'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO9973'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO10666'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO761'
UPDATE c_Common_Assessment set assessment_id = 'ICD-C44201' WHERE assessment_id = 'DEMO394'
UPDATE c_Common_Assessment set assessment_id = 'ICD-C4489' WHERE assessment_id = 'DEMO8373'
UPDATE c_Common_Assessment set assessment_id = 'ICD-C4490' WHERE assessment_id = 'CASKI'
UPDATE c_Common_Assessment set assessment_id = 'ICD-D490' WHERE assessment_id = 'DEMO8913'
UPDATE c_Common_Assessment set assessment_id = 'ICD-D569' WHERE assessment_id = 'THAL'
UPDATE c_Common_Assessment set assessment_id = 'ICD-E213' WHERE assessment_id = 'DEMO4671'
UPDATE c_Common_Assessment set assessment_id = 'ICD-E860' WHERE assessment_id = 'DEHY'
UPDATE c_Common_Assessment set assessment_id = 'ICD-F17200' WHERE assessment_id = 'TOB'
UPDATE c_Common_Assessment set assessment_id = 'ICD-G9340' WHERE assessment_id = 'DEMO7337'
UPDATE c_Common_Assessment set assessment_id = 'ICD-H109' WHERE assessment_id = '0^Conjunctivit^0'
UPDATE c_Common_Assessment set assessment_id = 'ICD-H16229' WHERE assessment_id = 'DEMO11449'
UPDATE c_Common_Assessment set assessment_id = 'ICD-H5350' WHERE assessment_id = 'DEMO11447'
UPDATE c_Common_Assessment set assessment_id = 'ICD-I421' WHERE assessment_id = 'DEMO1752'
UPDATE c_Common_Assessment set assessment_id = 'ICD-I82A19' WHERE assessment_id = 'DEMO356'
UPDATE c_Common_Assessment set assessment_id = 'ICD-J09X2' WHERE assessment_id = '981^488.1^1'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K2270' WHERE assessment_id = 'DEMO11490'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K280' WHERE assessment_id = '0^11600'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K283' WHERE assessment_id = '0^11605'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K284' WHERE assessment_id = '0^11606'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K2901' WHERE assessment_id = '0^11586'
UPDATE c_Common_Assessment set assessment_id = 'ICD-K8020' WHERE assessment_id = '0^11582'
UPDATE c_Common_Assessment set assessment_id = 'ICD-L519' WHERE assessment_id = 'ERYM'
UPDATE c_Common_Assessment set assessment_id = 'ICD-M799' WHERE assessment_id = 'DEMO3828'
UPDATE c_Common_Assessment set assessment_id = 'ICD-N4403' WHERE assessment_id = 'DEMO8978'
UPDATE c_Common_Assessment set assessment_id = 'ICD-N4404' WHERE assessment_id = 'DEMO8977'
UPDATE c_Common_Assessment set assessment_id = 'ICD-N6481' WHERE assessment_id = 'DEMO745'
UPDATE c_Common_Assessment set assessment_id = 'ICD-O903' WHERE assessment_id = '00014xxx'
UPDATE c_Common_Assessment set assessment_id = 'ICD-P006' WHERE assessment_id = 'DEMO6504Q'
UPDATE c_Common_Assessment set assessment_id = 'ICD-P120' WHERE assessment_id = 'CAP'
UPDATE c_Common_Assessment set assessment_id = 'ICD-P120' WHERE assessment_id = 'CAPQ' AND specialty_id = '$OBGYN'
DELETE FROM c_Common_Assessment where assessment_id = 'CAPQ'
DELETE FROM c_Common_Assessment where assessment_id = 'CEPH'
DELETE FROM c_Common_Assessment where assessment_id = 'CEPHQ'
UPDATE c_Common_Assessment set assessment_id = 'ICD-P121' WHERE assessment_id = 'CHI'
DELETE FROM c_Common_Assessment where assessment_id = 'CHIQ'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R042' WHERE assessment_id = 'HEMOP'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R067' WHERE assessment_id = 'DEMO2115'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10811' WHERE assessment_id = '0^11563'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10812' WHERE assessment_id = '0^11564'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10813' WHERE assessment_id = '0^11565'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10814' WHERE assessment_id = '0^11566'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10815' WHERE assessment_id = '0^11567'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10816' WHERE assessment_id = '0^11568'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R10817' WHERE assessment_id = '0^11569'
DELETE FROM c_Common_Assessment where assessment_id = '0^11570'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1084' WHERE assessment_id = '0^11561'
DELETE FROM c_Common_Assessment where assessment_id = '0^11562'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R159' WHERE assessment_id = 'ENC'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1901' WHERE assessment_id = '0^11552'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1902' WHERE assessment_id = '0^11553'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1903' WHERE assessment_id = '0^11554'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1904' WHERE assessment_id = '0^11555'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1905' WHERE assessment_id = '0^11556'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1906' WHERE assessment_id = '0^11557'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1907' WHERE assessment_id = '0^11558'
DELETE FROM c_Common_Assessment where assessment_id = '0^11559'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1931' WHERE assessment_id = '0^11571'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1932' WHERE assessment_id = '0^11572'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1933' WHERE assessment_id = '0^11573'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1934' WHERE assessment_id = '0^11574'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1935' WHERE assessment_id = '0^11575'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1936' WHERE assessment_id = '0^11576'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R1937' WHERE assessment_id = '0^11577'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R194' WHERE assessment_id = '0^11581'
UPDATE c_Common_Assessment set assessment_id = 'ICD-R319' WHERE assessment_id = 'HEMU'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T360X5A' WHERE assessment_id = 'DEMO9952'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T362X5A' WHERE assessment_id = 'DEMO9954'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T367X5A' WHERE assessment_id = 'DEMO9953'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T39091A' WHERE assessment_id = 'DEMO9853'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T398X1A' WHERE assessment_id = 'DEMO9858'
DELETE FROM c_Common_Assessment where assessment_id = 'DEMO9864'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T3991XA' WHERE assessment_id = 'DEMO9859'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T403X1A' WHERE assessment_id = 'DEMO9851'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T423X2A' WHERE assessment_id = 'DEMO9976'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T45515A' WHERE assessment_id = '0001125x'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T466X5A' WHERE assessment_id = '0001126x'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T50901A' WHERE assessment_id = 'DEMO9904'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T8069XA' WHERE assessment_id = 'DEMO11339'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T8110XA' WHERE assessment_id = 'DEMO3386'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T8544XA' WHERE assessment_id = 'DEMO747'
UPDATE c_Common_Assessment set assessment_id = 'ICD-T887XXA' WHERE assessment_id = 'DEMO10324'
UPDATE c_Common_Assessment set assessment_id = 'ICD-Z189' WHERE assessment_id = 'FB'
UPDATE c_Common_Assessment set assessment_id = 'ICD-Z30430' WHERE assessment_id = 'DEMO1158'
UPDATE c_Common_Assessment set assessment_id = 'ICD-Z30430' WHERE assessment_id = 'DEMO9448'
UPDATE c_Common_Assessment set assessment_id = 'ICD-Z317' WHERE assessment_id = 'DEMO9466'

UPDATE u_top_20 SET item_id = 'ICD-R1084' WHERE item_id = '0^11561' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = '0^V85.52^0' WHERE item_id = '981^V85.2^0' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = '0^V85.53^0' WHERE item_id = '981^V85.3^0' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = '0^V85.54^0' WHERE item_id = '981^V85.4^0' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-E860' WHERE item_id = 'DEHY' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'DEMO4868' WHERE item_id = 'DEMO10277' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-T887XXA' WHERE item_id = 'DEMO10324' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'DEMO6437' WHERE item_id = 'DEMO10666' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-H5350' WHERE item_id = 'DEMO11447' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'DEMO6593' WHERE item_id = 'DEMO11448' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-H16229' WHERE item_id = 'DEMO11449' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-Z30430' WHERE item_id = 'DEMO9448' and top_20_code like '%assess%'
UPDATE u_top_20 SET item_id = 'ICD-L519' WHERE item_id = 'ERYM' and top_20_code like '%assess%'

UPDATE p_Assessment
SET assessment_id = 'ICD-R1084'
WHERE assessment_id = '0^11561'

UPDATE p_Encounter_Assessment
SET assessment_id = 'ICD-R1084'
WHERE assessment_id = '0^11561'

DELETE FROM c_Assessment_Definition
WHERE Assessment_id IN (
'DEMO249','0^V72.11^0','981^V85.2^0','981^V85.3^0','981^V85.4^0',
'0^11958','DEMO4806','TESTTORS','REAM','981^995.20^1','DEMO10257',
'DEMO11050','DEMO10186','DEMO1067','DEMO11145','0^11578','DEMO10620',
'DEMO10539','DEMO11398','BITEIN','DEMO10652','DEMO10651','DEMO10476',
'DEMO10277','DEMO11456','DEMO9973','DEMO10666','DEMO11448','DEMO761',
'SPEECH','DEMO7172','DEMO394','DEMO8373','CASKI','DEMO8913','THAL',
'DEMO4671','DEHY','TOB','DEMO7337','0^Conjunctivit^0','DEMO11449',
'DEMO11447','DEMO1752','DEMO356','981^488.1^1','DEMO11490','0^11600',
'0^11605','0^11606','0^11586','0^11582','ERYM','DEMO3828','DEMO8978',
'DEMO8977','DEMO745','00014xxx','DEMO6504Q','CAP','CAPQ','CEPH',
'CEPHQ','CHI','CHIQ','HEMOP','DEMO2115','0^11563','0^11564',
'0^11565','0^11566','0^11567','0^11568','0^11569','0^11570',
'0^11561','0^11562','ENC','0^11552','0^11553','0^11554','0^11555',
'0^11556','0^11557','0^11558','0^11559','0^11571','0^11572',
'0^11573','0^11574','0^11575','0^11576','0^11577','0^11581','HEMU',
'DEMO9952','DEMO9954','DEMO9953','DEMO9853','DEMO9858','DEMO9864',
'DEMO9859','DEMO9851','DEMO9976','0001125x','0001126x','DEMO9904',
'DEMO11339','DEMO3386','DEMO747','DEMO10324','FB','DEMO1158',
'DEMO9448','DEMO9466')



--			Delete elsewhere

DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11176'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11154'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11159'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3585'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'HEARSA'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'FORMU'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO1460'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'HEPCONT'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO2730'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3601'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3229'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3108'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3580'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3920'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO395'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3587'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3610'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3588'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11177'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11179'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = '000195x'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO1074'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO905b'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3584'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11178'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11180'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3586'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11155'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO180'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO10305'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO10442'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO398'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO1073'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO2774'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO3084'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11151'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO904b'; 
DELETE FROM u_assessment_treat_definition
WHERE assessment_id = 'DEMO11150'; 


DELETE FROM c_Maintenance_Assessment
WHERE assessment_id = '981^687.02^0'

DELETE FROM p_Encounter_Assessment
WHERE assessment_id = '981^687.02^0'

DELETE FROM c_Common_Assessment
WHERE assessment_id
IN (
'DEMO4372','DEMO180','DEMO3920','DEMO395','DEMO398','0^11593','981^687.02^0',
'DEMO10026Q','DEMO1020','DEMO10280','DEMO10297','DEMO10298','DEMO10305',
'DEMO10306','DEMO10307','DEMO10308','DEMO10309','DEMO10311','DEMO10312',
'DEMO10968','DEMO11341','DEMO11521','DEMO1460','DEMO3580','DEMO3582','DEMO3584'
,'DEMO3585','DEMO3586','DEMO3587','DEMO3588','DEMO3601','DEMO3610','DEMO412'
,'DEMO9908','DEMO9914','DEMO9917','DEMO9939','DEMO9941','DEMO9946','DEMO9949'
,'DEMO9958','DEMO9961','DEMO9972','DEMO9974','DEMO9977','FORMU','HEARSA',
'HEMU1','HEMU2','HEPCONT','DEMO904b','DEMO905b','DEMO909','DEMO10733',
'DEMO11176','DEMO11177','DEMO11178','DEMO10727','DEMO10728','DEMO947',
'DEMO949','DEMO10862','DEMO10863','DEMO10864','DEMO958','DEMO959','DEMO11143'
,'DEMO1074','DEMO11150','DEMO1073','DEMO11154','DEMO11155','DEMO11159'
,'DEMO11192','DEMO11194','DEMO11195','DEMO11151','DEMO11179','DEMO11180'
,'DEMO2390','DEMO2406','DEMO2639','DEMO2730','DEMO3084','DEMO3085','DEMO3086'
,'DEMO3087','DEMO3088','DEMO3089','DEMO10442','DEMO2708','DEMO2774','DEMO3108'
,'DEMO3229','DEMO11434','000195x','0001123x'
)

DELETE FROM u_top_20
WHERE top_20_code like '%assess%'
AND item_id
IN (
'DEMO4372','DEMO180','DEMO3920','DEMO395','DEMO398','0^11593','981^687.02^0',
'DEMO10026Q','DEMO1020','DEMO10280','DEMO10297','DEMO10298','DEMO10305',
'DEMO10306','DEMO10307','DEMO10308','DEMO10309','DEMO10311','DEMO10312',
'DEMO10968','DEMO11341','DEMO11521','DEMO1460','DEMO3580','DEMO3582','DEMO3584'
,'DEMO3585','DEMO3586','DEMO3587','DEMO3588','DEMO3601','DEMO3610','DEMO412'
,'DEMO9908','DEMO9914','DEMO9917','DEMO9939','DEMO9941','DEMO9946','DEMO9949'
,'DEMO9958','DEMO9961','DEMO9972','DEMO9974','DEMO9977','FORMU','HEARSA',
'HEMU1','HEMU2','HEPCONT','DEMO904b','DEMO905b','DEMO909','DEMO10733',
'DEMO11176','DEMO11177','DEMO11178','DEMO10727','DEMO10728','DEMO947',
'DEMO949','DEMO10862','DEMO10863','DEMO10864','DEMO958','DEMO959','DEMO11143'
,'DEMO1074','DEMO11150','DEMO1073','DEMO11154','DEMO11155','DEMO11159'
,'DEMO11192','DEMO11194','DEMO11195','DEMO11151','DEMO11179','DEMO11180'
,'DEMO2390','DEMO2406','DEMO2639','DEMO2730','DEMO3084','DEMO3085','DEMO3086'
,'DEMO3087','DEMO3088','DEMO3089','DEMO10442','DEMO2708','DEMO2774','DEMO3108'
,'DEMO3229','DEMO11434','000195x','0001123x'
)

DELETE FROM c_Assessment_Definition
WHERE assessment_id 
IN (
'DEMO4372','DEMO180','DEMO3920','DEMO395','DEMO398','0^11593','981^687.02^0',
'DEMO10026Q','DEMO1020','DEMO10280','DEMO10297','DEMO10298','DEMO10305',
'DEMO10306','DEMO10307','DEMO10308','DEMO10309','DEMO10311','DEMO10312',
'DEMO10968','DEMO11341','DEMO11521','DEMO1460','DEMO3580','DEMO3582','DEMO3584'
,'DEMO3585','DEMO3586','DEMO3587','DEMO3588','DEMO3601','DEMO3610','DEMO412'
,'DEMO9908','DEMO9914','DEMO9917','DEMO9939','DEMO9941','DEMO9946','DEMO9949'
,'DEMO9958','DEMO9961','DEMO9972','DEMO9974','DEMO9977','FORMU','HEARSA',
'HEMU1','HEMU2','HEPCONT','DEMO904b','DEMO905b','DEMO909','DEMO10733',
'DEMO11176','DEMO11177','DEMO11178','DEMO10727','DEMO10728','DEMO947',
'DEMO949','DEMO10862','DEMO10863','DEMO10864','DEMO958','DEMO959','DEMO11143'
,'DEMO1074','DEMO11150','DEMO1073','DEMO11154','DEMO11155','DEMO11159'
,'DEMO11192','DEMO11194','DEMO11195','DEMO11151','DEMO11179','DEMO11180'
,'DEMO2390','DEMO2406','DEMO2639','DEMO2730','DEMO3084','DEMO3085','DEMO3086'
,'DEMO3087','DEMO3088','DEMO3089','DEMO10442','DEMO2708','DEMO2774','DEMO3108'
,'DEMO3229','DEMO11434','000195x','0001123x'
)


--			Not used elsewhere


DELETE FROM c_Assessment_Definition
WHERE assessment_id 
IN (
'DEMO7446','0^323.41^0','981^323.1^0','981^323.2^0','0^12161',
'0^12159','DEMO11429dQ','DEMO11429Q','00011x','DEMO9795',
'0^11601','0^11603','0^11604','0^11607','0^11608','0^11609',
'0^11610','0^11611','0^11753','0^11769','0^11770','0^11909',
'0^11910','0^11911','0^11912','0^11945','0^11949','0^12054',
'0^12115','0^12294','0^12297','0^12313','0^284.1^0','0^327.5^0',
'0^793.89^2','000177x','981^346.23','981^346.24','981^346.25',
'981^346.26','981^346.27','981^769.70^0','981^997.31^2',
'CAPSULE','COLONOSCOPY','DEMO10137','DEMO11036','DEMO1124',
'DEMO11416i','DEMO11416iQ','DEMO11461','DEMO11464','DEMO11465',
'DEMO11467','DEMO11468','DEMO11469','DEMO11470','DEMO11471',
'DEMO11472','DEMO11491','DEMO11492','DEMO11493','DEMO11494',
'DEMO11495','DEMO11496','DEMO11499','DEMO11502','DEMO11503',
'DEMO11504','DEMO11506','DEMO11507','DEMO11508','DEMO11508Q',
'DEMO11509','DEMO11509a','DEMO11511','DEMO11520','DEMO11522',
'DEMO11523','DEMO11524','DEMO11525','DEMO11526','DEMO11527',
'DEMO11528a','DEMO11530','DEMO11532','DEMO11533','DEMO11538',
'DEMO11539','DEMO11540','DEMO11541','DEMO11542','DEMO11543',
'DEMO11544','DEMO11545','DEMO11549','DEMO11550','DEMO1164',
'DEMO1190a','DEMO1272','DEMO2065','DEMO2697','DEMO2734',
'DEMO2996','DEMO3581','DEMO3654','DEMO443c','DEMO443x2c',
'DEMO443x3c','DEMO443x5c','DEMO443x6c','DEMO443x7c','DEMO443x8c',
'DEMO443x9c','DEMO4869','DEMO5013','DEMO5014','DEMO5940',
'DEMO6029','DEMO6504','DEMO7466','DEMO7593','DEMO7610',
'DEMO7630','DEMO872','DEMO874c','DEMO875ac','DEMO875c',
'DEMO876c','DEMO877c','DEMO877w2c','DEMO877w3c','DEMO877w4c',
'DEMO877w5c','DEMO877w6c','DEMO877w7c','DEMO877w8c','DEMO877w9c',
'DEMO877z2c','DEMO877z3c','DEMO877z4c','DEMO877z5c','DEMO877z6c',
'DEMO877z7c','DEMO877z8c','DEMO877z9c','DEMO9010','DEMO9010A',
'DEMO9031A','DEMO9032','DEMO9032A','DEMO9033','DEMO9033A',
'DEMO9060','DEMO9126','DEMO9142','DEMO9218','DEMO9463',
'DEMO9464','DEMO9465','DEMO9855','DEMO9856','DEMO9861',
'DEMO9862','DEMO9865','DEMO9866','DEMO9867','DEMO9868',
'DEMO9869','DEMO9870','DEMO9871','DEMO9872','DEMO9873',
'DEMO9874','DEMO9875','DEMO9876','DEMO9877','DEMO9878',
'DEMO9879','DEMO9880','DEMO9881','DEMO9884','DEMO9885',
'DEMO9886','DEMO9887','DEMO9888','DEMO9890','DEMO9891',
'DEMO9892','DEMO9893','DEMO9894','DEMO9895','DEMO9896',
'DEMO9897','DEMO9898','DEMO9899','DEMO9900','DEMO9901',
'DEMO9902','DEMO9903','DEMO9905','DEMO9906','DEMO9907',
'DEMO9909','DEMO9910','DEMO9911','DEMO9916','EGD','ERCP',
'FLEXSIG','GICT','GIRADS','GIUS','PPI','SMALLBOWEL','DEMO570A',
'DEMO10702','DEMO906','0^649.61^0','0^649.62^0','0^649.64^0',
'DEMO10831','DEMO10838','DEMO10832','DEMO10833','DEMO10834',
'DEMO10835','DEMO10836','DEMO10837','DEMO10873','DEMO10917',
'DEMO10918','DEMO10919','DEMO11160','DEMO11161','DEMO10996',
'DEMO11193','DEMO2407','DEMO2658','DEMO2381','DEMO2392',
'DEMO2401','DEMO2410','DEMO2411','DEMO2412','DEMO2733',
'DEMO2530','DEMO2529','DEMO3090','DEMO2631','DEMO2694',
'DEMO2695','DEMO2696','DEMO2705','DEMO2951','DEMO4935','DEMO4937',
'DEMO3309','DEMO9445X','DEMO9224','0^12078','DEMO9124','0^11602',
'DEMO2632')


-- Updates

update c_Assessment_Definition set last_updated=getdate(), description ='Tuberculosis of other male genital organs' where assessment_id = 'DEMO4063'
update c_Assessment_Definition set last_updated=getdate(), description ='Tuberculosis of skin and subcutaneous tissue' where assessment_id = 'DEMO4066'
update c_Assessment_Definition set last_updated=getdate(), description ='Pulmonary tularemia' where assessment_id = 'DEMO4085'
update c_Assessment_Definition set last_updated=getdate(), description ='Other symptomatic neurosyphilis' where assessment_id = 'DEMO4376'
update c_Assessment_Definition set last_updated=getdate(), description ='Syphilis of liver and other viscera' where assessment_id = 'DEMO4381'
update c_Assessment_Definition set last_updated=getdate(), description ='Gonococcal infection of other musculoskeletal tissue' where assessment_id = 'DEMO4411'
update c_Assessment_Definition set last_updated=getdate(), description ='Tick-borne viral encephalitis, unspecified' where assessment_id = 'ENCEPH'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified viral infection of central nervous system' where assessment_id = 'DEMO588'
update c_Assessment_Definition set last_updated=getdate(), description ='West Nile virus infection with encephalitis' where assessment_id = '0^11637'
update c_Assessment_Definition set last_updated=getdate(), description ='West Nile virus infection with other neurologic manifestation' where assessment_id = '0^11638'
update c_Assessment_Definition set last_updated=getdate(), description ='West Nile virus infection with other complications' where assessment_id = '0^11639'
update c_Assessment_Definition set last_updated=getdate(), description ='Other viral warts' where assessment_id = 'WARTP'
update c_Assessment_Definition set last_updated=getdate(), description ='Viral wart, unspecified' where assessment_id = 'WART'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic viral hepatitis B without delta-agent' where assessment_id = '0^11644'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic viral hepatitis C' where assessment_id = 'DEMO4248'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic pulmonary coccidioidomycosis' where assessment_id = 'COCCID'
update c_Assessment_Definition set last_updated=getdate(), description ='Cutaneous coccidioidomycosis' where assessment_id = 'COCCIB'
update c_Assessment_Definition set last_updated=getdate(), description ='Allergic bronchopulmonary aspergillosis' where assessment_id = 'DEMO5015'
update c_Assessment_Definition set last_updated=getdate(), description ='Mycoplasma pneumoniae [M. pneumoniae] as the cause of diseases classified els…' where assessment_id = 'DEMO583'
update c_Assessment_Definition set last_updated=getdate(), description ='Klebsiella pneumoniae [K. pneumoniae] as the cause of diseases classified els…' where assessment_id = 'DEMO4156'
update c_Assessment_Definition set last_updated=getdate(), description ='Other viral agents as the cause of diseases classified elsewhere' where assessment_id = 'DEMO4281'
update c_Assessment_Definition set last_updated=getdate(), description ='Malignant neoplasm of unspecified part of unspecified adrenal gland' where assessment_id = 'NUEROB'
update c_Assessment_Definition set last_updated=getdate(), description ='Refractory anemia with excess of blasts 2' where assessment_id = '0^238.73^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Refractory cytopenia with multilineage dysplasia and ring sideroblasts' where assessment_id = '0^238.72^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Myelodysplastic syndrome with isolated del(5q) chromosomal abnormality' where assessment_id = '0^238.74^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic myeloproliferative disease' where assessment_id = '0^238.76^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Essential (hemorrhagic) thrombocythemia' where assessment_id = '981^238.71^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other sickle-cell disorders with crisis, unspecified' where assessment_id = 'DEMO7447'
update c_Assessment_Definition set last_updated=getdate(), description ='Other constitutional aplastic anemia' where assessment_id = '0^284.09^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Decreased white blood cell count, unspecified' where assessment_id = '0^288.50^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Androgen insensitivity syndrome, unspecified' where assessment_id = '981^259.50^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified disorder of calcium metabolism' where assessment_id = 'DEMO4792'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified metabolic disorders' where assessment_id = 'DEMO4778'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified mental disorders due to known physiological condition' where assessment_id = 'DEMO9612'
update c_Assessment_Definition set last_updated=getdate(), description ='Disorganized schizophrenia' where assessment_id = 'DEMO9618'
update c_Assessment_Definition set last_updated=getdate(), description ='Catatonic schizophrenia' where assessment_id = 'DEMO9619'
update c_Assessment_Definition set last_updated=getdate(), description ='Residual schizophrenia' where assessment_id = 'DEMO9623'
update c_Assessment_Definition set last_updated=getdate(), description ='Other schizophrenia' where assessment_id = 'DEMO9625'
update c_Assessment_Definition set last_updated=getdate(), description ='Schizotypal disorder' where assessment_id = 'DEMO9687'
update c_Assessment_Definition set last_updated=getdate(), description ='Delusional disorders' where assessment_id = 'DEMO9644'
update c_Assessment_Definition set last_updated=getdate(), description ='Brief psychotic disorder' where assessment_id = 'DEMO9646'
update c_Assessment_Definition set last_updated=getdate(), description ='Shared psychotic disorder' where assessment_id = 'DEMO9643'
update c_Assessment_Definition set last_updated=getdate(), description ='Schizoaffective disorder, unspecified' where assessment_id = 'DEMO9624'
update c_Assessment_Definition set last_updated=getdate(), description ='Bipolar disorder, unspecified' where assessment_id = 'DEMO9632'
update c_Assessment_Definition set last_updated=getdate(), description ='Paranoid personality disorder' where assessment_id = 'DEMO9681'
update c_Assessment_Definition set last_updated=getdate(), description ='Enuresis not due to a substance or known physiological condition' where assessment_id = 'ENURESIS'
update c_Assessment_Definition set last_updated=getdate(), description ='Postimmunization acute disseminated encephalitis, myelitis and encephalomyelitis' where assessment_id = '0^323.52^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Encephalitis and encephalomyelitis in diseases classified elsewhere' where assessment_id = '981^323.01^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Drug induced subacute dyskinesia' where assessment_id = '0^333.85^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Drug induced acute dystonia' where assessment_id = '0^333.72^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Spasmodic torticollis' where assessment_id = 'DEMO7224'
update c_Assessment_Definition set last_updated=getdate(), description ='Idiopathic orofacial dystonia' where assessment_id = 'DEMO7223'
update c_Assessment_Definition set last_updated=getdate(), description ='Other dystonia' where assessment_id = '0^333.79^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Extrapyramidal and movement disorder, unspecified' where assessment_id = 'DEMO309'
update c_Assessment_Definition set last_updated=getdate(), acuteness='Chronic' where assessment_id = 'DEMO7325'
update c_Assessment_Definition set last_updated=getdate(), description ='Insomnia, unspecified' where assessment_id = 'DEMO201'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified disorders of brain' where assessment_id = 'DEMO7193'
update c_Assessment_Definition set last_updated=getdate(), description ='Stenosis of unspecified lacrimal sac' where assessment_id = 'DEMO6437'
update c_Assessment_Definition set last_updated=getdate(), description ='Nodular corneal degeneration, unspecified eye' where assessment_id = 'DEMO6310'
update c_Assessment_Definition set last_updated=getdate(), description ='Recession of chamber angle, unspecified eye' where assessment_id = 'DEMO5479'
update c_Assessment_Definition set last_updated=getdate(), description ='Coloboma of optic disc, unspecified eye' where assessment_id = 'DEMO6489'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified disorders of binocular movement' where assessment_id = 'DEMO6593'
update c_Assessment_Definition set last_updated=getdate(), description ='Other noninfective acute otitis externa, unspecified ear' where assessment_id = 'DEMO6765'
update c_Assessment_Definition set last_updated=getdate(), description ='Sensorineural hearing loss, bilateral' where assessment_id = '0^389.18^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified rheumatic heart diseases' where assessment_id = 'DEMO10541'
update c_Assessment_Definition set last_updated=getdate(), description ='Other pulmonary embolism without acute cor pulmonale' where assessment_id = 'DEMO1512'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified pulmonary heart diseases' where assessment_id = 'DEMO1569'
update c_Assessment_Definition set last_updated=getdate(), description ='Other diseases of pulmonary vessels' where assessment_id = 'DEMO1635'
update c_Assessment_Definition set last_updated=getdate(), description ='Disease of pulmonary vessels, unspecified' where assessment_id = 'DEMO1637'
update c_Assessment_Definition set last_updated=getdate(), description ='Other nonrheumatic pulmonary valve disorders' where assessment_id = 'DEMO1744'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified atherosclerosis of native arteries of extremities, unspecified ex…' where assessment_id = 'DEMO1855'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute embolism and thrombosis of unspecified deep veins of unspecified lower …' where assessment_id = '0^11657'
update c_Assessment_Definition set last_updated=getdate(), description ='Postthrombotic syndrome without complications of unspecified extremity' where assessment_id = 'DEMO10113'
update c_Assessment_Definition set last_updated=getdate(), description ='Postthrombotic syndrome with ulcer of unspecified lower extremity' where assessment_id = 'DEMO10123'
update c_Assessment_Definition set last_updated=getdate(), description ='Postthrombotic syndrome with inflammation of unspecified lower extremity' where assessment_id = 'DEMO10127'
update c_Assessment_Definition set last_updated=getdate(), description ='Postthrombotic syndrome with ulcer and inflammation of unspecified lower extr…' where assessment_id = 'DEMO10128'
update c_Assessment_Definition set last_updated=getdate(), description ='Postthrombotic syndrome with other complications of unspecified lower extremity' where assessment_id = 'DEMO10135'
update c_Assessment_Definition set last_updated=getdate(), description ='Compression of vein' where assessment_id = 'DEMO10116'
update c_Assessment_Definition set last_updated=getdate(), description ='Venous insufficiency (chronic) (peripheral)' where assessment_id = 'DEMO376'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic venous hypertension (idiopathic) without complications of unspecified…' where assessment_id = 'DEMO10138'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic venous hypertension (idiopathic) with ulcer of unspecified lower extr…' where assessment_id = 'DEMO10140'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic venous hypertension (idiopathic) with inflammation of unspecified low…' where assessment_id = 'DEMO10142'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic venous hypertension (idiopathic) with ulcer and inflammation of unspe…' where assessment_id = 'DEMO10145'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic venous hypertension (idiopathic) with other complications of unspecif…' where assessment_id = 'DEMO10148'
update c_Assessment_Definition set last_updated=getdate(), description ='Other hypotension' where assessment_id = 'DEMO1969'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified disorders of nose and nasal sinuses' where assessment_id = '0^478.19^3'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute pulmonary edema' where assessment_id = 'DEMO5012'
update c_Assessment_Definition set last_updated=getdate(), description ='Pulmonary eosinophilia, not elsewhere classified' where assessment_id = 'DEMO5011'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified interstitial pulmonary diseases' where assessment_id = 'DEMO181'
update c_Assessment_Definition set last_updated=getdate(), description ='Hemothorax' where assessment_id = 'DEMO5000'
update c_Assessment_Definition set last_updated=getdate(), description ='Postprocedural pneumothorax' where assessment_id = 'DEMO5002'
update c_Assessment_Definition set last_updated=getdate(), description ='Ventilator associated pneumonia' where assessment_id = '981^997.31^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute and chronic respiratory failure, unspecified whether with hypoxia or hy…' where assessment_id = 'DEMO5017a'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute bronchospasm' where assessment_id = '981^519.11^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other diseases of bronchus, not elsewhere classified' where assessment_id = '0^519.19^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Disturbances in tooth formation' where assessment_id = 'DEMO7580'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified diseases of hard tissues of teeth' where assessment_id = '0^521.89^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Localized gingival recession, unspecified' where assessment_id = '0^11668'
update c_Assessment_Definition set last_updated=getdate(), description ='Generalized gingival recession, unspecified' where assessment_id = '0^11669'
update c_Assessment_Definition set last_updated=getdate(), description ='Generalized gingival recession, minimal' where assessment_id = '0^11665'
update c_Assessment_Definition set last_updated=getdate(), description ='Generalized gingival recession, moderate' where assessment_id = '0^11666'
update c_Assessment_Definition set last_updated=getdate(), description ='Generalized gingival recession, severe' where assessment_id = '0^11667'
update c_Assessment_Definition set last_updated=getdate(), description ='Recurrent oral aphthae' where assessment_id = 'DEMO8091'
update c_Assessment_Definition set last_updated=getdate(), description ='Cellulitis and abscess of mouth' where assessment_id = 'DEMO7686'
update c_Assessment_Definition set last_updated=getdate(), description ='Oral mucositis (ulcerative), unspecified' where assessment_id = '0^528.00^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Oral mucositis (ulcerative) due to other drugs' where assessment_id = '0^528.02^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Oral mucositis (ulcerative) due to radiation' where assessment_id = '0^528.01^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other oral mucositis (ulcerative)' where assessment_id = '0^528.09^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other lesions of oral mucosa' where assessment_id = 'DEMO7698'
update c_Assessment_Definition set last_updated=getdate(), description ='Other gastritis without bleeding' where assessment_id = 'DEMO7797a'
update c_Assessment_Definition set last_updated=getdate(), description ='Bilateral inguinal hernia, with obstruction, without gangrene, recurrent' where assessment_id = 'DEMO7856'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified diseases of anus and rectum' where assessment_id = 'DEMO7955'
update c_Assessment_Definition set last_updated=getdate(), description ='Other peritonitis' where assessment_id = '0^11950'
update c_Assessment_Definition set last_updated=getdate(), description ='Calculus of bile duct with acute cholecystitis without obstruction' where assessment_id = 'DEMO8037'
update c_Assessment_Definition set last_updated=getdate(), description ='Calculus of bile duct with chronic cholecystitis without obstruction' where assessment_id = 'DEMO8038'
update c_Assessment_Definition set last_updated=getdate(), description ='Postgastric surgery syndromes' where assessment_id = 'DEMO7911'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified contact dermatitis due to plants, except food' where assessment_id = 'DEMO281'
update c_Assessment_Definition set last_updated=getdate(), description ='Unilateral primary osteoarthritis, unspecified hip' where assessment_id = 'DEMO3556'
update c_Assessment_Definition set last_updated=getdate(), description ='Other unilateral secondary osteoarthritis of hip' where assessment_id = 'DEMO3607'
update c_Assessment_Definition set last_updated=getdate(), description ='Osteoarthritis of hip, unspecified' where assessment_id = '0^12160'
update c_Assessment_Definition set last_updated=getdate(), description ='Unilateral primary osteoarthritis, unspecified knee' where assessment_id = 'DEMO3598'
update c_Assessment_Definition set last_updated=getdate(), description ='Other unilateral secondary osteoarthritis of knee' where assessment_id = 'DEMO3608'
update c_Assessment_Definition set last_updated=getdate(), description ='Osteoarthritis of knee, unspecified' where assessment_id = '0^12152'
update c_Assessment_Definition set last_updated=getdate(), description ='Osteoarthritis of first carpometacarpal joint, unspecified' where assessment_id = '0^12150'
update c_Assessment_Definition set last_updated=getdate(), description ='Valgus deformity, not elsewhere classified, unspecified knee' where assessment_id = 'GENU'
update c_Assessment_Definition set last_updated=getdate(), description ='Other anomalies of dental arch relationship' where assessment_id = '0^524.29^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Intervertebral disc disorders with myelopathy, lumbar region' where assessment_id = 'DEMO3709'
update c_Assessment_Definition set last_updated=getdate(), description ='Panniculitis affecting regions of neck and back, cervical region' where assessment_id = 'DEMO3724'
update c_Assessment_Definition set last_updated=getdate(), description ='Panniculitis, unspecified' where assessment_id = 'DEMO3820'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, unspecified site, initial encounter for fracture' where assessment_id = 'DEMO10440'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, unspecified site, subsequent encounter for fracture wi…' where assessment_id = 'DEMO11429gQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, right humerus, subsequent encounter for fracture with …' where assessment_id = 'DEMO11429aQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, right ulna, subsequent encounter for fracture with rou…' where assessment_id = 'DEMO11429bQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, hip, unspecified, initial encounter for fracture' where assessment_id = 'DEMO3925'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, hip, unspecified, subsequent encounter for fracture wi…' where assessment_id = 'DEMO11429cQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, unspecified tibia and fibula, subsequent encounter for…' where assessment_id = 'DEMO11429fQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Pathological fracture, other site, subsequent encounter for fracture with rou…' where assessment_id = 'DEMO11429hQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Atypical femoral fracture, unspecified, subsequent encounter for fracture wit…' where assessment_id = 'DEMO11429eQ'
update c_Assessment_Definition set last_updated=getdate(), description ='Obstructive and reflux uropathy, unspecified' where assessment_id = '0^12035'
update c_Assessment_Definition set last_updated=getdate(), description ='Disorder of kidney and ureter, unspecified' where assessment_id = 'DEMO305'
update c_Assessment_Definition set last_updated=getdate(), description ='Cystitis, unspecified with hematuria' where assessment_id = 'DEMO9983'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified disorders of bladder' where assessment_id = 'DEMO7030'
update c_Assessment_Definition set last_updated=getdate(), description ='Nonspecific urethritis' where assessment_id = 'DEMO605'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified disorders of breast' where assessment_id = 'DEMO740'
update c_Assessment_Definition set last_updated=getdate(), description ='Female acute pelvic peritonitis' where assessment_id = 'DEMO760'
update c_Assessment_Definition set last_updated=getdate(), description ='Complete uterovaginal prolapse' where assessment_id = 'DEMO785'
update c_Assessment_Definition set last_updated=getdate(), description ='Other female genital prolapse' where assessment_id = '0^11709'
update c_Assessment_Definition set last_updated=getdate(), description ='Benign endometrial hyperplasia' where assessment_id = '0^11710'
update c_Assessment_Definition set last_updated=getdate(), description ='Endometrial intraepithelial neoplasia [EIN]' where assessment_id = '0^11712'
update c_Assessment_Definition set last_updated=getdate(), description ='Dysmenorrhea, unspecified' where assessment_id = 'DYSMENOR'
update c_Assessment_Definition set last_updated=getdate(), description ='Female infertility of tubal origin' where assessment_id = 'DEMO864'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified tubal pregnancy without intrauterine pregnancy' where assessment_id = 'DEMO11408'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified tubal pregnancy with intrauterine pregnancy' where assessment_id = 'DEMO11409'
update c_Assessment_Definition set last_updated=getdate(), description ='Damage to pelvic organs following (induced) termination of pregnancy' where assessment_id = 'DEMO443x3b'
update c_Assessment_Definition set last_updated=getdate(), description ='Pre-existing hypertension with pre-eclampsia, unspecified trimester' where assessment_id = 'DEMO899'
update c_Assessment_Definition set last_updated=getdate(), description ='Pre-existing hypertension with pre-eclampsia, unspecified trimester' where assessment_id = 'DEMO899a'
update c_Assessment_Definition set last_updated=getdate(), description ='Gestational [pregnancy-induced] hypertension without significant proteinuria,…' where assessment_id = 'DEMO10683a'
update c_Assessment_Definition set last_updated=getdate(), description ='Mild hyperemesis gravidarum' where assessment_id = 'DEMO10695'
update c_Assessment_Definition set last_updated=getdate(), description ='Late vomiting of pregnancy' where assessment_id = 'DEMO10701'
update c_Assessment_Definition set last_updated=getdate(), description ='Other vomiting complicating pregnancy' where assessment_id = 'DEMO10704'
update c_Assessment_Definition set last_updated=getdate(), description ='Vomiting of pregnancy, unspecified' where assessment_id = 'DEMO10706'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified infection of urinary tract in pregnancy, unspecified trimester' where assessment_id = 'DEMO919'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified infection of urinary tract in pregnancy, third trimester' where assessment_id = 'DEMO10731'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal hypotension syndrome, unspecified trimester' where assessment_id = 'DEMO1077'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal hypotension syndrome, third trimester' where assessment_id = 'DEMO11175'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy related peripheral neuritis, third trimester' where assessment_id = 'DEMO10729'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy related peripheral neuritis, unspecified trimester' where assessment_id = 'DEMO918'
update c_Assessment_Definition set last_updated=getdate(), description ='Uterine size-date discrepancy, third trimester' where assessment_id = '0^649.63^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Uterine size-date discrepancy, unspecified trimester' where assessment_id = '0^649.60^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified pregnancy related conditions, third trimester' where assessment_id = 'DEMO10741'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy related conditions, unspecified, unspecified trimester' where assessment_id = 'DEMO10744'
update c_Assessment_Definition set last_updated=getdate(), description ='Quadruplet pregnancy, unspecified number of placenta and unspecified number o…' where assessment_id = 'DEMO10830'
update c_Assessment_Definition set last_updated=getdate(), description ='Continuing pregnancy after spontaneous abortion of one fetus or more, unspeci…' where assessment_id = 'DEMO946'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal care for other malpresentation of fetus, not applicable or unspecified' where assessment_id = 'DEMO10865'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal care for disproportion due to inlet contraction of pelvis' where assessment_id = 'DEMO962'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal care for abnormality of vagina, unspecified trimester' where assessment_id = 'DEMO6117'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal care for abnormality of vagina, third trimester' where assessment_id = 'DEMO10920'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary inadequate contractions' where assessment_id = 'DEMO11043'
update c_Assessment_Definition set last_updated=getdate(), description ='Secondary uterine inertia' where assessment_id = 'DEMO1065'
update c_Assessment_Definition set last_updated=getdate(), description ='Other uterine inertia' where assessment_id = 'DEMO11046'
update c_Assessment_Definition set last_updated=getdate(), description ='Precipitate labor' where assessment_id = 'DEMO1033'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypertonic, incoordinate, and prolonged uterine contractions' where assessment_id = 'DEMO1034'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormality of forces of labor, unspecified' where assessment_id = 'DEMO1037'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified obstructed labor' where assessment_id = 'DEMO11038'
update c_Assessment_Definition set last_updated=getdate(), description ='Postpartum coagulation defects' where assessment_id = 'DEMO11144'
update c_Assessment_Definition set last_updated=getdate(), description ='Other pulmonary complications of anesthesia during labor and delivery' where assessment_id = 'DEMO11152'
update c_Assessment_Definition set last_updated=getdate(), description ='Cardiac complications of anesthesia during labor and delivery' where assessment_id = 'DEMO11156'
update c_Assessment_Definition set last_updated=getdate(), description ='Central nervous system complications of anesthesia during labor and delivery' where assessment_id = 'DEMO11158'
update c_Assessment_Definition set last_updated=getdate(), description ='Pyrexia during labor, not elsewhere classified' where assessment_id = 'DEMO10997'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication of labor and delivery, unspecified' where assessment_id = 'DEMO1083'
update c_Assessment_Definition set last_updated=getdate(), description ='Pyrexia of unknown origin following delivery' where assessment_id = 'DEMO1093'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified puerperal infections' where assessment_id = 'DEMO11202'
update c_Assessment_Definition set last_updated=getdate(), description ='Other pulmonary complications of anesthesia during the puerperium' where assessment_id = 'DEMO11153'
update c_Assessment_Definition set last_updated=getdate(), description ='Postpartum acute kidney failure' where assessment_id = 'DEMO1078'
update c_Assessment_Definition set last_updated=getdate(), description ='Other complications of the puerperium, not elsewhere classified' where assessment_id = 'DEMO10730'
update c_Assessment_Definition set last_updated=getdate(), description ='Nonpurulent mastitis associated with the puerperium' where assessment_id = 'DEMO11287'
update c_Assessment_Definition set last_updated=getdate(), description ='Nonpurulent mastitis associated with lactation' where assessment_id = 'DEMO11290'
update c_Assessment_Definition set last_updated=getdate(), description ='Diseases of the circulatory system complicating pregnancy, unspecified trimester' where assessment_id = 'DEMO1367'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified diseases and conditions complicating pregnancy, childbirth an…' where assessment_id = 'DEMO10742'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by premature rupture of membranes' where assessment_id = 'DEMO6517'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by malpresentation before labor' where assessment_id = 'DEMO6523'
update c_Assessment_Definition set last_updated=getdate(), description ='Transitory neonatal hyperthyroidism' where assessment_id = 'THYNEO'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoxic ischemic encephalopathy [HIE], unspecified' where assessment_id = '981^768.70^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other congenital malformations of anterior segment of eye' where assessment_id = 'DEMO5745'
update c_Assessment_Definition set last_updated=getdate(), description ='Other congenital malformations of posterior segment of eye' where assessment_id = 'DEMO5750'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital glaucoma' where assessment_id = 'DEMO5724'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital malformation of eye, unspecified' where assessment_id = 'DEMO5760'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital malformation of peripheral vascular system, unspecified' where assessment_id = 'DEMO2082'
update c_Assessment_Definition set last_updated=getdate(), description ='Dysphagia, unspecified' where assessment_id = 'DEMO9071'
update c_Assessment_Definition set last_updated=getdate(), description ='Other ascites' where assessment_id = 'DEMO7946'
update c_Assessment_Definition set last_updated=getdate(), description ='Intra-abdominal and pelvic swelling, mass and lump, unspecified site' where assessment_id = 'DEMO441'
update c_Assessment_Definition set last_updated=getdate(), description ='Abdominal rigidity, unspecified site' where assessment_id = 'DEMO1269'
update c_Assessment_Definition set last_updated=getdate(), description ='Halitosis' where assessment_id = '0^784.99^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified abnormalities of gait and mobility' where assessment_id = 'DEMO648'
update c_Assessment_Definition set last_updated=getdate(), description ='Other speech disturbances' where assessment_id = 'DEMO9069'
update c_Assessment_Definition set last_updated=getdate(), description ='Systemic inflammatory response syndrome (SIRS) of non-infectious origin witho…' where assessment_id = 'DEMO11426'
update c_Assessment_Definition set last_updated=getdate(), description ='Severe sepsis without septic shock' where assessment_id = '0^995.92^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other abnormal glucose' where assessment_id = '0^790.29^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified abnormal immunological findings in serum' where assessment_id = 'DEMO1329'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal immunological finding in serum, unspecified' where assessment_id = 'DEMO11120'
update c_Assessment_Definition set last_updated=getdate(), description ='Other abnormal and inconclusive findings on diagnostic imaging of breast' where assessment_id = '0^793.89^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal findings on diagnostic imaging of skull and head, not elsewhere clas…' where assessment_id = 'DEMO1294'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified open wound of scalp, initial encounter' where assessment_id = 'SCALPWO'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration with foreign body of scalp, initial encounter' where assessment_id = 'SCALPWOA'
update c_Assessment_Definition set last_updated=getdate(), description ='Sprain of jaw, bilateral, initial encounter' where assessment_id = 'TMJST'
update c_Assessment_Definition set last_updated=getdate(), description ='Concussion without loss of consciousness, initial encounter' where assessment_id = 'DEMO2775'
update c_Assessment_Definition set last_updated=getdate(), description ='Sprain of unspecified parts of thorax, initial encounter' where assessment_id = 'STRBAC'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of fifth lumbar vertebra, subsequent encounter for fract…' where assessment_id = 'DEMO11429g'
update c_Assessment_Definition set last_updated=getdate(), description ='Sprain of ligaments of lumbar spine, initial encounter' where assessment_id = 'STRLUM'
update c_Assessment_Definition set last_updated=getdate(), description ='Sprain of other parts of lumbar spine and pelvis, initial encounter' where assessment_id = 'STRLS'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced fracture of lateral end of unspecified clavicle, initial encount…' where assessment_id = 'DEMO2335'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced fracture of lateral end of unspecified clavicle, initial encount…' where assessment_id = 'DEMO2339'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced fracture of lateral end of unspecified clavicle, subsequent enco…' where assessment_id = 'DEMO11429h'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle, fascia and tendon at shoulder and upper arm lev…' where assessment_id = 'SPRARM'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle, fascia and tendon at shoulder and upper arm lev…' where assessment_id = 'SPRSHO'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of lower end of humerus, unspecified arm, subsequent e…' where assessment_id = 'DEMO11429a'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified forearm, initial encounter for closed fra…' where assessment_id = 'FXHUM'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified forearm, initial encounter for open fract…' where assessment_id = 'DEMO2657'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified forearm, subsequent encounter for open fr…' where assessment_id = 'DEMO11429'
update c_Assessment_Definition set last_updated=getdate(), description ='Other dislocation of unspecified ulnohumeral joint, initial encounter' where assessment_id = 'NURSEMAID'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscles, fascia and tendons at forearm level, unspecifi…' where assessment_id = 'SPRELB'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of left wrist and hand, subsequent encounter for fractur…' where assessment_id = 'DEMO11429b'
update c_Assessment_Definition set last_updated=getdate(), description ='Sprain of other part of unspecified wrist and hand, initial encounter' where assessment_id = 'SPRFIN'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle, fascia and tendon at wrist and hand level, unsp…' where assessment_id = 'SPRHAN'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle, fascia and tendon at wrist and hand level, unsp…' where assessment_id = 'SPRWRI'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced intertrochanteric fracture of unspecified femur, initial encount…' where assessment_id = 'DEMO2468'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced intertrochanteric fracture of unspecified femur, initial encount…' where assessment_id = 'DEMO2471'
update c_Assessment_Definition set last_updated=getdate(), description ='Nondisplaced intertrochanteric fracture of unspecified femur, subsequent enco…' where assessment_id = 'DEMO11429c'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscles, fascia and tendons at thigh level, unspecified…' where assessment_id = 'SPRHIP'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of lower end of unspecified femur, subsequent encounte…' where assessment_id = 'DEMO11429e'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified lower leg, initial encounter for closed f…' where assessment_id = 'DEMO2531'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified lower leg, initial encounter for open fra…' where assessment_id = 'DEMO2528'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified fracture of unspecified lower leg, subsequent encounter for open …' where assessment_id = 'DEMO11429d'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle(s) and tendon(s) at lower leg level, unspecified…' where assessment_id = 'KNEECOL'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle and tendon at ankle and foot level, unspecified …' where assessment_id = 'SPRANK'
update c_Assessment_Definition set last_updated=getdate(), description ='Strain of unspecified muscle and tendon at ankle and foot level, unspecified …' where assessment_id = 'SPRFOO'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of phalanx of unspecified toe, subsequent encounter fo…' where assessment_id = 'DEMO11429f'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of phalanx of unspecified toe, subsequent encounter fo…' where assessment_id = 'DEMO3940'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of phalanx of unspecified toe, subsequent encounter fo…' where assessment_id = 'DEMO3939'
update c_Assessment_Definition set last_updated=getdate(), description ='Other physeal fracture of phalanx of unspecified toe, sequela' where assessment_id = 'DEMO2956'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified multiple injuries, initial encounter' where assessment_id = 'INSECTBITE'
update c_Assessment_Definition set last_updated=getdate(), description ='Injury, unspecified, initial encounter' where assessment_id = 'DEMO2630'
update c_Assessment_Definition set last_updated=getdate(), description ='Foreign body in cornea, left eye, initial encounter' where assessment_id = 'DEMO3140'
update c_Assessment_Definition set last_updated=getdate(), description ='Foreign body in conjunctival sac, left eye, initial encounter' where assessment_id = 'CONJUNSAC'
update c_Assessment_Definition set last_updated=getdate(), description ='Foreign body in other and multiple parts of external eye, left eye, initial e…' where assessment_id = 'DEMO3141'
update c_Assessment_Definition set last_updated=getdate(), description ='Foreign body on external eye, part unspecified, left eye, initial encounter' where assessment_id = 'FORBODYEYE'
update c_Assessment_Definition set last_updated=getdate(), description ='Poisoning by barbiturates, undetermined, initial encounter' where assessment_id = 'DEMO510'
update c_Assessment_Definition set last_updated=getdate(), description ='Adverse effect of unspecified drugs, medicaments and biological substances, i…' where assessment_id = '981^995.20^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Toxic effect of other specified substances, undetermined, initial encounter' where assessment_id = 'DEMO3308'
update c_Assessment_Definition set last_updated=getdate(), description ='Heat syncope, initial encounter' where assessment_id = 'SYNCO'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxiation due to unspecified cause, initial encounter' where assessment_id = 'DEMO3336'
update c_Assessment_Definition set last_updated=getdate(), description ='Motion sickness, initial encounter' where assessment_id = 'MOTSICK'
update c_Assessment_Definition set last_updated=getdate(), description ='Anaphylactic shock, unspecified, initial encounter' where assessment_id = 'DEMO10323'
update c_Assessment_Definition set last_updated=getdate(), description ='Anaphylactic shock, unspecified, initial encounter' where assessment_id = 'SHOCK'
update c_Assessment_Definition set last_updated=getdate(), description ='Angioneurotic edema, initial encounter' where assessment_id = 'ANGI'
update c_Assessment_Definition set last_updated=getdate(), description ='Arthus phenomenon, initial encounter' where assessment_id = '0^995.21^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Embolism due to vascular prosthetic devices, implants and grafts, initial enc…' where assessment_id = 'DEMO1509'
update c_Assessment_Definition set last_updated=getdate(), description ='Unspecified adverse effect of drug or medicament, sequela' where assessment_id = 'DEMO2992'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified complications of surgical and medical care, not elsewhere cla…' where assessment_id = 'DEMO3390'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for general adult medical examination without abnormal findings' where assessment_id = '981^V72.62^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for examination of ears and hearing with other abnormal findings' where assessment_id = '0^V72.19^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for gynecological examination (general) (routine) without abnormal …' where assessment_id = 'DEMO1206'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antibody response examination' where assessment_id = '981^V72.61^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for administrative examinations, unspecified' where assessment_id = 'DEMO9553'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for follow-up examination after completed treatment for conditions …' where assessment_id = 'EXAMFOLLOW'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for screening for other viral diseases' where assessment_id = 'DEMO9307'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for screening for malignant neoplasm of colon' where assessment_id = 'DEMO10238'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for screening for malignant neoplasm of cervix' where assessment_id = 'DEMO10319'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for screening for malignant neoplasm of vagina' where assessment_id = 'DEMO9336'
update c_Assessment_Definition set last_updated=getdate(), description ='Contact with and (suspected) exposure to other communicable diseases' where assessment_id = 'DEMO11389'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for initial prescription of contraceptive pills' where assessment_id = 'DEMO9444'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for initial prescription of other contraceptives' where assessment_id = 'DEMO9445'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for other procreative investigation and testing' where assessment_id = 'DEMO9467'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening for raised alphafetoprotein level' where assessment_id = 'DEMO1175'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening for malformations' where assessment_id = 'DEMO9473'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening for fetal growth retardation' where assessment_id = 'DEMO9474'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening for isoimmunization' where assessment_id = 'DEMO9475'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening for Streptococcus B' where assessment_id = '000193x'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for other specified antenatal screening' where assessment_id = 'DEMO1176'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for antenatal screening, unspecified' where assessment_id = 'DEMO1183'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for cosmetic surgery' where assessment_id = 'DEMO9213'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of unspecified artificial arm, unspecifi…' where assessment_id = 'DEMO9219'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of unspecified artificial arm, unspecifi…' where assessment_id = 'DEMO9220'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of artificial eye, unspecified' where assessment_id = 'DEMO9221'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of external breast prosthesis, unspecifi…' where assessment_id = 'DEMO9223'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of other external prosthetic devices' where assessment_id = 'DEMO9225'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of unspecified external prosthetic device' where assessment_id = 'DEMO9226'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adjustment and management of other part of cardiac pacemaker' where assessment_id = 'DEMO1457'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adjustment and management of other cardiac device' where assessment_id = 'DEMO1458'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adjustment and management of vascular access device' where assessment_id = 'DEMO9258'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adjustment and management of cerebrospinal fluid drainage device' where assessment_id = 'DEMO9227'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adjustment and management of neuropacemaker (brain) (peripheral…' where assessment_id = 'DEMO9228'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of spectacles and contact lenses' where assessment_id = 'DEMO9230'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of other devices related to nervous syst…' where assessment_id = 'DEMO9229'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of dental prosthetic device' where assessment_id = 'DEMO9222'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of orthodontic device' where assessment_id = 'DEMO9232'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of other gastrointestinal appliance and …' where assessment_id = 'ICD-Z4659'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of urinary device' where assessment_id = 'DEMO9234'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of insulin pump' where assessment_id = 'ICD-Z4681'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of non-vascular catheter' where assessment_id = 'DEMO9259'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of other specified devices' where assessment_id = 'DEMO4861'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the sense organs' where assessment_id = 'DEMO9265c'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the nervous system' where assessment_id = 'DEMO9265d'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the circulatory system' where assessment_id = 'DEMO9265e'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the respiratory system' where assessment_id = 'DEMO9265f'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the teeth or oral cavity' where assessment_id = 'ICD-Z48814'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the digestive system' where assessment_id = 'DEMO9265g'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the genitourinary system' where assessment_id = 'DEMO9265h'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for surgical aftercare following surgery on the skin and subcutaneo…' where assessment_id = 'DEMO9265i'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of extracorporeal dialysis catheter' where assessment_id = 'DEMO9279'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for fitting and adjustment of peritoneal dialysis catheter' where assessment_id = 'DEMO9280'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for adequacy testing for peritoneal dialysis' where assessment_id = 'DEMO9277'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified problems related to psychosocial circumstances' where assessment_id = 'DEMO1424'
update c_Assessment_Definition set last_updated=getdate(), description ='Other specified problems related to psychosocial circumstances' where assessment_id = 'DEMO1424A'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 19.9 or less, adult' where assessment_id = '0^12098'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 24.0-24.9, adult' where assessment_id = '0^12099'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 25.0-25.9, adult' where assessment_id = '0^12100'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 26.0-26.9, adult' where assessment_id = '0^12101'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 27.0-27.9, adult' where assessment_id = '0^12102'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 28.0-28.9, adult' where assessment_id = '0^12103'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 29.0-29.9, adult' where assessment_id = '0^12104'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 30.0-30.9, adult' where assessment_id = '0^12105'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 31.0-31.9, adult' where assessment_id = '0^12106'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 32.0-32.9, adult' where assessment_id = '0^12107'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 33.0-33.9, adult' where assessment_id = '0^12108'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 34.0-34.9, adult' where assessment_id = '0^12109'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 35.0-35.9, adult' where assessment_id = '0^12110'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 36.0-36.9, adult' where assessment_id = '0^12111'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 37.0-37.9, adult' where assessment_id = '0^12112'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 38.0-38.9, adult' where assessment_id = '0^12113'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) 39.0-39.9, adult' where assessment_id = '0^12114'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) pediatric, less than 5th percentile for age' where assessment_id = '0^V85.51^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) pediatric, 5th percentile to less than 85th percentile …' where assessment_id = '0^V85.52^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) pediatric, 85th percentile to less than 95th percentile…' where assessment_id = '0^V85.53^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Body mass index (BMI) pediatric, greater than or equal to 95th percentile for…' where assessment_id = '0^V85.54^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for issue of repeat prescription' where assessment_id = 'DEMO4868'
update c_Assessment_Definition set last_updated=getdate(), description ='Long term (current) use of anticoagulants' where assessment_id = 'DEMO1461'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other malignant neoplasm of rectum, rectosigmoid junction…' where assessment_id = 'DEMO8999'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of diseases of the blood and blood-forming organs and certai…' where assessment_id = 'DEMO9017'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other endocrine, nutritional and metabolic disease' where assessment_id = 'DEMO5161'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other mental and behavioral disorders' where assessment_id = 'DEMO9065'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other venous thrombosis and embolism' where assessment_id = 'DEMO1439'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other venous thrombosis and embolism' where assessment_id = 'DEMO1439A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of other diseases of the circulatory system' where assessment_id = '0^11764A'
update c_Assessment_Definition set last_updated=getdate(), description ='Presence of other cardiac implants and grafts' where assessment_id = 'DEMO1442'
update c_Assessment_Definition set last_updated=getdate(), description ='Cataract extraction status, unspecified eye' where assessment_id = 'DEMO9118'
update c_Assessment_Definition set last_updated=getdate(), description ='History of uterine scar from previous surgery' where assessment_id = 'DEMO9123'
update c_Assessment_Definition set last_updated=getdate(), description ='Dependence on aspirator' where assessment_id = 'DEMO9125'
update c_Assessment_Definition set last_updated=getdate(), description ='Dependence on respirator [ventilator] status' where assessment_id = '0^12075'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Syphilitic Parkinsonism' where assessment_id = 'DEMO4371'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal diagnostic imaging, head', long_description='Abnormal diagnostic imaging, head' where assessment_id = 'DEMO2133'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal mammogram NEC', long_description='Abnormal mammogram NEC' where assessment_id = 'DEMO10588'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Hoffa''s disease' where assessment_id = 'DEMO4777'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal radiologic (X-ray) breast', long_description='Abnormal radiologic (X-ray) breast' where assessment_id = '0^793.89^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Abortion induced complicated by chemical damage of pelvic organ', long_description='Abortion induced complicated by chemical damage of pelvic organ' where assessment_id = 'DEMO877w3b'
update c_Assessment_Definition set last_updated=getdate(), description ='Abortion induced complicated by laceration of pelvic organ', long_description='Abortion induced complicated by laceration of pelvic organ' where assessment_id = 'DEMO877z3b'
update c_Assessment_Definition set last_updated=getdate(), description ='Abortion induced complicated by perforation of pelvic organ', long_description='Abortion induced complicated by perforation of pelvic organ' where assessment_id = 'DEMO443x3r'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Paranoid state, simple' where assessment_id = 'DEMO9640'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Acute paranoid reaction' where assessment_id = 'DEMO9650'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Psychosis, paranoid, psychogenic' where assessment_id = 'DEMO9651'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Toxic myelitis' where assessment_id = '0^323.72^0'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Toxic metabolic encephalopathy' where assessment_id = '0^349.82^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Adhesions, cervicovaginal, postpartal', long_description='Adhesions, cervicovaginal, postpartal' where assessment_id = 'DEMO11274'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Sensory hearing loss, bilateral' where assessment_id = '981^389.11^0'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Neural hearing loss, bilateral' where assessment_id = '981^389.12^0'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Rheumatic disease of pulmonary valve' where assessment_id = 'DEMO1350'
update c_Assessment_Definition set last_updated=getdate(), description ='Anastomosis retinal and choroidal vessels', long_description='Anastomosis retinal and choroidal vessels' where assessment_id = 'DEMO5749'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Aplasia, cementum' where assessment_id = 'DEMO7578'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Dilaceration, tooth' where assessment_id = 'DEMO7579'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Odontoclasia' where assessment_id = 'DEMO10560'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Ulcer, aphthous, recurrent' where assessment_id = 'APT'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Canker sore' where assessment_id = 'DEMO7681'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Stomatitis, aphthous' where assessment_id = 'DEMO7682'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Stomatitis herpetiformis' where assessment_id = 'DEMO7683'
update c_Assessment_Definition set last_updated=getdate(), description ='Angioedema', long_description ='Angioedema' where assessment_id = 'DEMO3338'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Fistula, oral' where assessment_id = 'DEMO7680'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Cellulitis, mouth floor' where assessment_id = 'DEMO7685'
update c_Assessment_Definition set last_updated=getdate(), description ='Anomaly of artery or vein NOS', long_description='Anomaly of artery or vein NOS' where assessment_id = 'DEMO5998'
update c_Assessment_Definition set last_updated=getdate(), description ='Aphthae oral recurrent', long_description='Aphthae oral recurrent' where assessment_id = 'DEMO7679'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Gastric mucosal hypertrophy' where assessment_id = 'DEMO7798'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Granuloma, rectum' where assessment_id = 'DEMO7954'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Proctitis NOS' where assessment_id = 'DEMO7956'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Hypertrophy of anal papillae' where assessment_id = 'DEMO7957'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Peritonitis, pneumococcal' where assessment_id = 'DEMO7927'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Dumping syndrome' where assessment_id = 'DEMO7910'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Postgastrectomy syndrome' where assessment_id = 'DEMO7912'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Postvagotomy syndrome' where assessment_id = 'DEMO7913'
update c_Assessment_Definition set last_updated=getdate(), description ='Arrested active phase of labor', long_description='Arrested active phase of labor' where assessment_id = 'DEMO1031'
update c_Assessment_Definition set last_updated=getdate(), description ='Atony of uterus without hemorrhage', long_description='Atony of uterus without hemorrhage' where assessment_id = 'DEMO11048'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Hyperemia, bladder' where assessment_id = 'DEMO7031'
update c_Assessment_Definition set last_updated=getdate(), description ='Bilateral recurrent incarcerated obstructed inguinal hernia (disorder)', long_description='Bilateral recurrent incarcerated obstructed inguinal hernia (disorder)' where assessment_id = 'DEMO7855'
update c_Assessment_Definition set last_updated=getdate(), description ='Bupthalmos', long_description='Bupthalmos' where assessment_id = 'DEMO5726'
update c_Assessment_Definition set last_updated=getdate(), description ='Cachexia, renal', long_description='Cachexia, renal' where assessment_id = 'DEMO7000'
update c_Assessment_Definition set last_updated=getdate(), description ='Calcification bronchus', long_description='Calcification bronchus' where assessment_id = '0^519.19^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Calculus of bile duct with acute cholecystitis without obstruction', long_description='Calculus of bile duct with acute cholecystitis without obstruction' where assessment_id = 'DEMO8037a'
update c_Assessment_Definition set last_updated=getdate(), description ='Calculus of common bile duct with chronic cholecystitis', long_description='Calculus of common bile duct with chronic cholecystitis' where assessment_id = 'DEMO8038a'
update c_Assessment_Definition set last_updated=getdate(), description ='Cardiac arrhythmia in pregnancy', long_description='Cardiac arrhythmia in pregnancy' where assessment_id = 'DEMO10353'
update c_Assessment_Definition set last_updated=getdate(), description ='Catatonic stupor', long_description='Catatonic stupor' where assessment_id = '000174x'
update c_Assessment_Definition set last_updated=getdate(), description ='Cervical spasm', long_description='Cervical spasm' where assessment_id = 'DEMO1036'
update c_Assessment_Definition set last_updated=getdate(), description ='Clouded state', long_description='Clouded state' where assessment_id = 'DEMO2090'
update c_Assessment_Definition set last_updated=getdate(), description ='Codependency', long_description ='Codependency' where assessment_id = 'DEMO9013'
update c_Assessment_Definition set last_updated=getdate(), description ='Codependency', long_description ='Codependency' where assessment_id = 'DEMO9013A'
update c_Assessment_Definition set last_updated=getdate(), description ='Coloboma of the fundus', long_description='Coloboma of the fundus' where assessment_id = 'DEMO5747'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication occurring during labor and delivery', long_description ='Complication occurring during labor and delivery' where assessment_id = 'DEMO11015'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication of labor and delivery, delivered', long_description='Complication of labor and delivery, delivered' where assessment_id = 'DEMO11014'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication of labor and/or delivery', long_description ='Complication of labor and/or delivery' where assessment_id = 'DEMO11016'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication(s) (from) (of) cesarean delivery wound NEC ', long_description='Complication(s) (from) (of) cesarean delivery wound NEC ' where assessment_id = 'DEMO11273'
update c_Assessment_Definition set last_updated=getdate(), description ='Complication(s) (from) (of) perineal repair (obstetrical)', long_description='Complication(s) (from) (of) perineal repair (obstetrical)' where assessment_id = 'DEMO11275'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital cardiovascular disorder during pregnancy - baby delivered', long_description='Congenital cardiovascular disorder during pregnancy - baby delivered' where assessment_id = 'DEMO924'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital heart disease in mother complicating pregnancy', long_description='Congenital heart disease in mother complicating pregnancy' where assessment_id = 'DEMO10740'
update c_Assessment_Definition set last_updated=getdate(), description ='Contraction ring dystocia', long_description='Contraction ring dystocia' where assessment_id = 'DEMO11051'
update c_Assessment_Definition set last_updated=getdate(), description ='Deficient perineum', long_description='Deficient perineum' where assessment_id = '0^11705'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery cesarean for intertia, uterus secondary', long_description='Delivery cesarean for intertia, uterus secondary' where assessment_id = 'DEMO11044'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery complicated by dilatation bladder', long_description='Delivery complicated by dilatation bladder' where assessment_id = 'DEMO11037'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery complicated by fever during labor', long_description='Delivery complicated by fever during labor' where assessment_id = 'DEMO1011'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery, complicated by abnormal uterine contractions NOS', long_description='Delivery, complicated by abnormal uterine contractions NOS' where assessment_id = 'DEMO11058'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery, complicated by precipitate labor', long_description='Delivery, complicated by precipitate labor' where assessment_id = 'DEMO11049'
update c_Assessment_Definition set last_updated=getdate(), description ='Depletion, salt or sodium, nephropathy', long_description='Depletion, salt or sodium, nephropathy' where assessment_id = 'DEMO6999'
update c_Assessment_Definition set last_updated=getdate(), description ='Dermatitis of external auditory canal', long_description='Dermatitis of external auditory canal' where assessment_id = 'DEMO6766'
update c_Assessment_Definition set last_updated=getdate(), description ='Dermatitis, contact due to plants, non-food', long_description='Dermatitis, contact due to plants, non-food' where assessment_id = 'DEMO5081'
update c_Assessment_Definition set last_updated=getdate(), description ='Dyscoordinate labor', long_description ='Dyscoordinate labor' where assessment_id = 'DEMO11052'
update c_Assessment_Definition set last_updated=getdate(), description ='Dysfunction uterus, complicating delivery', long_description='Dysfunction uterus, complicating delivery' where assessment_id = 'DEMO11057'
update c_Assessment_Definition set last_updated=getdate(), description ='Edema cervix puerperal', long_description='Edema cervix puerperal' where assessment_id = 'DEMO10724'
update c_Assessment_Definition set last_updated=getdate(), description ='Enamel hypoplasia (neonatal) (postnatal) (prenatal)', long_description='Enamel hypoplasia (neonatal) (postnatal) (prenatal)' where assessment_id = 'ENAM'
update c_Assessment_Definition set last_updated=getdate(), description ='Encephalomyelitis in diseases classified elsewhere', long_description='Encephalomyelitis in diseases classified elsewhere' where assessment_id = 'DEMO7175'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for cosmetic breast implant', long_description='Encounter for cosmetic breast implant' where assessment_id = 'DEMO9210'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for peritoneal equilibration test', long_description='Encounter for peritoneal equilibration test' where assessment_id = 'DEMO10232'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for screening colonoscopy NOS', long_description ='Encounter for screening colonoscopy NOS' where assessment_id = 'DEMO10238a'
update c_Assessment_Definition set last_updated=getdate(), description ='Endometrial hyperplasia (complex) (simple) without atypia', long_description='Endometrial hyperplasia (complex) (simple) without atypia' where assessment_id = '0^11711'
update c_Assessment_Definition set last_updated=getdate(), description ='Epileptic psychosis NOS', long_description='Epileptic psychosis NOS' where assessment_id = 'DEMO9613'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination following fracture', long_description='Examination following fracture' where assessment_id = 'DEMO9613'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination following treatment (for) combined NEC fracture', long_description='Examination following treatment (for) combined NEC fracture' where assessment_id = 'DEMO9548'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination following treatment (for) mental disorder ', long_description='Examination following treatment (for) mental disorder ' where assessment_id = 'DEMO4866'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination follow-up chemotherapy NEC', long_description='Examination follow-up chemotherapy NEC' where assessment_id = 'DEMO9545'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination follow-up psychotherapy', long_description='Examination follow-up psychotherapy' where assessment_id = 'DEMO9546'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination follow-up radiotherapy NEC ', long_description='Examination follow-up radiotherapy NEC ' where assessment_id = 'DEMO9546'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination follow-up surgery NEC ', long_description='Examination follow-up surgery NEC ' where assessment_id = 'DEMO4865'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination psychiatric NEC follow-up not needing further care', long_description='Examination psychiatric NEC follow-up not needing further care' where assessment_id = 'DEMO9547'
update c_Assessment_Definition set last_updated=getdate(), description ='Excessive vomiting starting after 20 completed weeks of gestation', long_description='Excessive vomiting starting after 20 completed weeks of gestation' where assessment_id = 'DEMO10700'
update c_Assessment_Definition set last_updated=getdate(), description ='Exposure smallpox (laboratory)', long_description='Exposure smallpox (laboratory)' where assessment_id = 'DEMO9375'
update c_Assessment_Definition set last_updated=getdate(), description ='Failure of cervical dilatation', long_description='Failure of cervical dilatation' where assessment_id = 'DEMO1032'
update c_Assessment_Definition set last_updated=getdate(), description ='Failure, respiratory, acute and (on)', long_description='Failure, respiratory, acute and (on)' where assessment_id = 'DEMO5017'
update c_Assessment_Definition set last_updated=getdate(), description ='Focal oral mucinosis', long_description='Focal oral mucinosis' where assessment_id = 'DEMO7699'
update c_Assessment_Definition set last_updated=getdate(), description ='Gonococcal synovitis', long_description='Gonococcal synovitis' where assessment_id = 'DEMO4409'
update c_Assessment_Definition set last_updated=getdate(), description ='Heart murmur in pregnancy', long_description='Heart murmur in pregnancy' where assessment_id = 'DEMO939a'
update c_Assessment_Definition set last_updated=getdate(), description ='Hepatitis c, chronic, with hepatic coma', long_description='Hepatitis c, chronic, with hepatic coma' where assessment_id = 'DEMO4246'
update c_Assessment_Definition set last_updated=getdate(), description ='History of anal cancer', long_description ='History of anal cancer' where assessment_id = 'DEMO9000'
update c_Assessment_Definition set last_updated=getdate(), description ='History of anal cancer', long_description ='History of anal cancer' where assessment_id = 'DEMO9000A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of atrial fibrillation', long_description='History of atrial fibrillation' where assessment_id = 'DEMO1438'
update c_Assessment_Definition set last_updated=getdate(), description ='History of atrial fibrillation', long_description='History of atrial fibrillation' where assessment_id = 'DEMO1438A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of hypertension', long_description='History of hypertension' where assessment_id = '0^11762A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of malignant neoplasm of anus', long_description ='History of malignant neoplasm of anus' where assessment_id = 'DEMO1410'
update c_Assessment_Definition set last_updated=getdate(), description ='History of malignant neoplasm of anus', long_description ='History of malignant neoplasm of anus' where assessment_id = 'DEMO1410A'
update c_Assessment_Definition set last_updated=getdate(), description ='Hour-glass contraction of uterus', long_description='Hour-glass contraction of uterus' where assessment_id = 'DEMO11053'
update c_Assessment_Definition set last_updated=getdate(), description ='Hydrophthalmos', long_description='Hydrophthalmos' where assessment_id = 'DEMO5725'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypertonic uterine dysfunction', long_description='Hypertonic uterine dysfunction' where assessment_id = 'DEMO11054'
update c_Assessment_Definition set last_updated=getdate(), description ='Idiopathic (torsion) dystonia NOS', long_description='Idiopathic (torsion) dystonia NOS' where assessment_id = 'DEMO7215'
update c_Assessment_Definition set last_updated=getdate(), description ='Incoordinate uterine action', long_description='Incoordinate uterine action' where assessment_id = 'DEMO1035'
update c_Assessment_Definition set last_updated=getdate(), description ='Inflammation of spinal cord due to toxin', long_description='Inflammation of spinal cord due to toxin' where assessment_id = '981^323.71^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Inlet contraction pelvis affecting management pregnancy', long_description='Inlet contraction pelvis affecting management pregnancy' where assessment_id = 'DEMO10874'
update c_Assessment_Definition set last_updated=getdate(), description ='Insomnia disorder, episodic', long_description='Insomnia disorder, episodic' where assessment_id = 'DEMO2093'
update c_Assessment_Definition set last_updated=getdate(), description ='Interrogation cardiac (event) (loop)', long_description='Interrogation cardiac (event) (loop)' where assessment_id = 'DEMO9231'
update c_Assessment_Definition set last_updated=getdate(), description ='Irregular labor', long_description='Irregular labor' where assessment_id = 'DEMO11047'
update c_Assessment_Definition set last_updated=getdate(), description ='Keratoglobus, congenital, with glaucoma', long_description='Keratoglobus, congenital, with glaucoma' where assessment_id = 'DEMO5741'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of bowel following (induced)…', long_description='Laceration, perforation, tear or chemical damage of bowel following (induced) termination of pregnancy' where assessment_id = 'DEMO877z3r'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of cervix following (induced…', long_description='Laceration, perforation, tear or chemical damage of cervix following (induced) termination of pregnancy' where assessment_id = 'DEMO877w3q'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of periurethral tissue follo…', long_description='Laceration, perforation, tear or chemical damage of periurethral tissue following (induced) termination of pregnancy' where assessment_id = 'DEMO877z3q'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of uterus following (induced…', long_description='Laceration, perforation, tear or chemical damage of uterus following (induced) termination of pregnancy' where assessment_id = 'DEMO443x3q'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of vagina following (induced…', long_description='Laceration, perforation, tear or chemical damage of vagina following (induced) termination of pregnancy' where assessment_id = 'DEMO877w3r'
update c_Assessment_Definition set last_updated=getdate(), description ='Late effect of chemotherapy, pain', long_description ='Late effect of chemotherapy, pain' where assessment_id = 'DEMO2991'
update c_Assessment_Definition set last_updated=getdate(), description ='Low back pain in pregnancy', long_description='Low back pain in pregnancy' where assessment_id = 'DEMO925'
update c_Assessment_Definition set last_updated=getdate(), description ='Ludwig''s angina or disease ', long_description='Ludwig''s angina or disease ' where assessment_id = 'DEMO7684'
update c_Assessment_Definition set last_updated=getdate(), description ='Macrocornea with glaucoma', long_description='Macrocornea with glaucoma' where assessment_id = 'DEMO5501'
update c_Assessment_Definition set last_updated=getdate(), description ='Maternal aortic valve disease in pregnancy', long_description='Maternal aortic valve disease in pregnancy' where assessment_id = 'DEMO939'
update c_Assessment_Definition set last_updated=getdate(), description ='Medical surveillance following completed treatment', long_description='Medical surveillance following completed treatment' where assessment_id = 'DEMO9549'
update c_Assessment_Definition set last_updated=getdate(), description ='Medullated fibers optic (nerve)', long_description='Medullated fibers optic (nerve)' where assessment_id = 'DEMO5752'
update c_Assessment_Definition set last_updated=getdate(), description ='Meningoencephalitis in diseases classified elsewhere', long_description='Meningoencephalitis in diseases classified elsewhere' where assessment_id = 'DEMO7176'
update c_Assessment_Definition set last_updated=getdate(), description ='Mitral valve disorder in pregnancy', long_description='Mitral valve disorder in pregnancy' where assessment_id = 'DEMO1100'
update c_Assessment_Definition set last_updated=getdate(), description ='Musculoskeletal problems in pregnancy', long_description='Musculoskeletal problems in pregnancy' where assessment_id = 'DEMO10745'
update c_Assessment_Definition set last_updated=getdate(), description ='Neonatal thyrotoxicosis', long_description='Neonatal thyrotoxicosis' where assessment_id = 'DEMO6724'
update c_Assessment_Definition set last_updated=getdate(), description ='Nephropathy NOS', long_description='Nephropathy NOS' where assessment_id = '0^11628'
update c_Assessment_Definition set last_updated=getdate(), description ='Nongonococcal urethritis', long_description='Nongonococcal urethritis' where assessment_id = 'DEMO607'
update c_Assessment_Definition set last_updated=getdate(), description ='Odynophagia (painful swallowing)', long_description='Odynophagia (painful swallowing)' where assessment_id = 'DEMO9072'
update c_Assessment_Definition set last_updated=getdate(), description ='Old laceration of muscles of pelvic floor', long_description='Old laceration of muscles of pelvic floor' where assessment_id = 'DEMO790'
update c_Assessment_Definition set last_updated=getdate(), description ='Oral mucositis', long_description='Oral mucositis' where assessment_id = '981^528.00^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Osteoarthritis of bilat hips', long_description ='Osteoarthritis of bilat hips' where assessment_id = '0^12151'
update c_Assessment_Definition set last_updated=getdate(), description ='Pain after cesarean section, postpartum (after childbirth)', long_description='Pain after cesarean section, postpartum (after childbirth)' where assessment_id = 'DEMO10746'
update c_Assessment_Definition set last_updated=getdate(), description ='Painful symphysis pubis', long_description='Painful symphysis pubis' where assessment_id = 'DEMO923'
update c_Assessment_Definition set last_updated=getdate(), description ='Peer problems', long_description ='Peer problems' where assessment_id = 'DEMO9012A'
update c_Assessment_Definition set last_updated=getdate(), description ='Pericystitis with hematuria', long_description='Pericystitis with hematuria' where assessment_id = 'DEMO7015'
update c_Assessment_Definition set last_updated=getdate(), description ='Postchemotherapy pain', long_description ='Postchemotherapy pain' where assessment_id = 'DEMO2981'
update c_Assessment_Definition set last_updated=getdate(), description ='Postpartum episiotomy pain', long_description='Postpartum episiotomy pain' where assessment_id = 'DEMO11272'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy complicated by vomiting due to diseases classified elsewhere', long_description='Pregnancy complicated by vomiting due to diseases classified elsewhere' where assessment_id = 'DEMO10703'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy complicated by vomiting', long_description='Pregnancy complicated by vomiting' where assessment_id = 'DEMO10705'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary hypotonic uterine dysfunction', long_description='Primary hypotonic uterine dysfunction' where assessment_id = 'DEMO11042'
update c_Assessment_Definition set last_updated=getdate(), description ='Proctalgia', long_description='Proctalgia' where assessment_id = 'DEMO7958'
update c_Assessment_Definition set last_updated=getdate(), description ='Psychosis due to ischemia, cerebrovascular (generalized)', long_description='Psychosis due to ischemia, cerebrovascular (generalized)' where assessment_id = 'DEMO9679'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal infection NOS following delivery', long_description='Puerperal infection NOS following delivery' where assessment_id = 'DEMO11236'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal lymphangitis of breast', long_description='Puerperal lymphangitis of breast' where assessment_id = 'DEMO11289'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal neuritis', long_description='Puerperal neuritis' where assessment_id = 'DEMO10743'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal pelvic cellulitis', long_description='Puerperal pelvic cellulitis' where assessment_id = 'DEMO11201'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal pyrexia NOS following delivery', long_description='Puerperal pyrexia NOS following delivery' where assessment_id = 'DEMO11237'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperium complicated by paralysis bladder ', long_description='Puerperium complicated by paralysis bladder ' where assessment_id = 'DEMO10734'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Polyp, placental' where assessment_id = 'DEMO1105'
update c_Assessment_Definition set last_updated=getdate(), description ='Renal disease NEC', long_description='Renal disease NEC' where assessment_id = 'DEMO1106'
update c_Assessment_Definition set last_updated=getdate(), description ='Renal insufficiency (acute)', long_description='Renal insufficiency (acute)' where assessment_id = 'DEMO8963'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening, dengue fever', long_description='Screening, dengue fever' where assessment_id = 'DEMO9311'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening, encephalitis, viral (mosquito- or tick-borne)', long_description='Screening, encephalitis, viral (mosquito- or tick-borne)' where assessment_id = 'DEMO4878'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening, hemorrhagic fever', long_description='Screening, hemorrhagic fever' where assessment_id = 'DEMO9314'
update c_Assessment_Definition set last_updated=getdate(), description ='Secondary hypotonic uterine dysfunction', long_description='Secondary hypotonic uterine dysfunction' where assessment_id = 'DEMO11045'
update c_Assessment_Definition set last_updated=getdate(), description ='Semicoma', long_description='Semicoma' where assessment_id = 'DEMO126'
update c_Assessment_Definition set last_updated=getdate(), description ='Sepsis (generalized) (unspecified organism) with organ dysfunction (acute) (m…', long_description='Sepsis (generalized) (unspecified organism) with organ dysfunction (acute) (multiple)' where assessment_id = 'DEMO11426b'
update c_Assessment_Definition set last_updated=getdate(), description ='Seroma as complication of procedure', long_description ='Seroma as complication of procedure' where assessment_id = 'DEMO3389'
update c_Assessment_Definition set last_updated=getdate(), description ='Sickle cell, Hb-SE  disease with crisis', long_description='Sickle cell, Hb-SE  disease with crisis' where assessment_id = 'DEMO7445'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Axenfeld''s anomaly' where assessment_id = 'DEMO5502'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Glaucoma, childhood' where assessment_id = 'DEMO5490'
update c_Assessment_Definition set last_updated=getdate(), description ='Sickle cell-hemoglobin d disease with crisis', long_description ='Sickle cell-hemoglobin d disease with crisis' where assessment_id = 'DEMO7444'
update c_Assessment_Definition set last_updated=getdate(), description ='Simple schizophrenia', long_description='Simple schizophrenia' where assessment_id = 'DEMO9617'
update c_Assessment_Definition set last_updated=getdate(), description ='Spiritual problem', long_description ='Spiritual problem' where assessment_id = 'DEMO9012'
update c_Assessment_Definition set last_updated=getdate(), description ='Staphylococcal toxic shock syndrome', long_description='Staphylococcal toxic shock syndrome' where assessment_id = 'DEMO11401'
update c_Assessment_Definition set last_updated=getdate(), description ='Stricture, artery, pulmonary, acquired', long_description='Stricture, artery, pulmonary, acquired' where assessment_id = 'DEMO10419a'
update c_Assessment_Definition set last_updated=getdate(), description ='Subinvolution uterus puerperal ', long_description='Subinvolution uterus puerperal ' where assessment_id = 'DEMO11275a'
update c_Assessment_Definition set last_updated=getdate(), description ='Systemic inflammatory response syndrome without organ dysfunction', long_description='Systemic inflammatory response syndrome without organ dysfunction' where assessment_id = '981^995.93^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Tetanic contractions', long_description='Tetanic contractions' where assessment_id = 'DEMO11055'
update c_Assessment_Definition set last_updated=getdate(), description ='Thermography (abnormal) breast', long_description='Thermography (abnormal) breast' where assessment_id = 'DEMO10590'
update c_Assessment_Definition set last_updated=getdate(), description ='Toxic encephalitis', long_description='Toxic encephalitis' where assessment_id = 'DEMO7349'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Screening, measles' where assessment_id = 'DEMO4879'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Screening, poliomyelitis' where assessment_id = 'DEMO9306'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Screening, rubella' where assessment_id = 'DEMO9308'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Screening, yellow fever' where assessment_id = 'DEMO9309'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Screening, arthropod-borne disease NOS' where assessment_id = 'DEMO9310'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Exposure, poliomyelitis' where assessment_id = 'DEMO9374'
update c_Assessment_Definition set last_updated=getdate(), description ='Ulcer of bronchus', long_description='Ulcer of bronchus' where assessment_id = '0^519.19^2'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Fitting/adjustment, wheelchair' where assessment_id = 'DEMO9235'
update c_Assessment_Definition set last_updated=getdate(), description ='Urticaria due to drugs', long_description='Urticaria due to drugs' where assessment_id = 'DEMO11349'
update c_Assessment_Definition set last_updated=getdate(), description ='Uterine spasm', long_description='Uterine spasm' where assessment_id = 'DEMO11056'
update c_Assessment_Definition set last_updated=getdate(), description ='Victim of teen dating psychosocial violence', long_description ='Victim of teen dating psychosocial violence' where assessment_id = 'DEMO9510'
update c_Assessment_Definition set last_updated=getdate(), description ='Victim of teen violence, psychosocial', long_description ='Victim of teen violence, psychosocial' where assessment_id = 'DEMO9011'
update c_Assessment_Definition set last_updated=getdate(), long_description ='History of depression' where assessment_id = 'DEMO1425'
update c_Assessment_Definition set last_updated=getdate(), long_description ='History of depression' where assessment_id = 'DEMO1425A'
update c_Assessment_Definition set last_updated=getdate(), long_description ='History of mental disorder' where assessment_id = 'DEMO9014'
update c_Assessment_Definition set last_updated=getdate(), long_description ='History of mental disorder' where assessment_id = 'DEMO9014A'
update c_Assessment_Definition set last_updated=getdate(), description ='Victim of teen violence, psychosocial', long_description ='Victim of teen violence, psychosocial' where assessment_id = 'DEMO9011A'



-- Assign updates

update c_Assessment_Definition set last_updated=getdate(), description ='Abdominal pain, periumbilical', long_description='Abdominal pain, periumbilical' where assessment_id = '0^11560'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal non-fasting glucose tolerance', long_description='Abnormal non-fasting glucose tolerance' where assessment_id = 'DEMO11517'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal Papanicolaou smear of vagina NOS', long_description='Abnormal Papanicolaou smear of vagina NOS' where assessment_id = '79510'
update c_Assessment_Definition set last_updated=getdate(), description ='Abnormal spacing of fully erupted tooth or teeth NOS', long_description='Abnormal spacing of fully erupted tooth or teeth NOS' where assessment_id = 'DEMO7632'
update c_Assessment_Definition set last_updated=getdate(), description ='Abrasion, teeth (dentifrice) (habitual) (hard tissues) (occupational) (ritual…', long_description='Abrasion, teeth (dentifrice) (habitual) (hard tissues) (occupational) (ritual) (traditional)' where assessment_id = 'DEMO7592'
update c_Assessment_Definition set last_updated=getdate(), description ='Acetaminophen overdose', long_description='Acetaminophen overdose' where assessment_id = 'DEMO9863'
update c_Assessment_Definition set last_updated=getdate(), description ='Acidosis renal (hyperchloremic) (tubular)', long_description='Acidosis renal (hyperchloremic) (tubular)' where assessment_id = 'DEMO306'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute chemical conjunctivitis', long_description='Acute chemical conjunctivitis' where assessment_id = '981^372.60^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Acute deep venous thrombosis (dvt)', long_description='Acute deep venous thrombosis (dvt)' where assessment_id = 'DEMO1942'
update c_Assessment_Definition set last_updated=getdate(), description ='Aftercare following surgery (for) removal of internal fixation device', long_description='Aftercare following surgery (for) removal of internal fixation device' where assessment_id = 'DEMO11537'
update c_Assessment_Definition set last_updated=getdate(), description ='Agenesis of pulmonary artery', long_description='Agenesis of pulmonary artery' where assessment_id = 'DEMO2059'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Abscess of nose (septum)' where assessment_id = '0^478.19^0'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Necrosis of nose (septum)' where assessment_id = '0^478.19^1'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Ulcer of nose (septum)' where assessment_id = '0^478.19^2'
update c_Assessment_Definition set last_updated=getdate(), description ='Aldosteronism, secondary', long_description='Aldosteronism, secondary' where assessment_id = 'DEMO11463'
update c_Assessment_Definition set last_updated=getdate(), description ='Anaplasia of cervix', long_description='Anaplasia of cervix' where assessment_id = 'DEMO47'
update c_Assessment_Definition set last_updated=getdate(), description ='Anemia, aplastic due to radiation', long_description='Anemia, aplastic due to radiation' where assessment_id = 'DEMO7467'
update c_Assessment_Definition set last_updated=getdate(), description ='Anomaly capillary', long_description='Anomaly capillary' where assessment_id = 'DEMO10653'
update c_Assessment_Definition set last_updated=getdate(), description ='Anomaly of pulmonary artery', long_description='Anomaly of pulmonary artery' where assessment_id = 'DEMO2060'
update c_Assessment_Definition set last_updated=getdate(), description ='Anterior segment anomaly, eye', long_description='Anterior segment anomaly, eye' where assessment_id = 'DEMO11444'
update c_Assessment_Definition set last_updated=getdate(), description ='Antritis, stomach with bleeding', long_description='Antritis, stomach with bleeding' where assessment_id = 'DUITb'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Granuloma, eosinophilic, oral mucosa' where assessment_id = 'DEMO7702'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Granuloma, pyogenic, oral mucosa' where assessment_id = 'DEMO7701'
update c_Assessment_Definition set last_updated=getdate(), description ='Aplasia round ligament', long_description='Aplasia round ligament' where assessment_id = 'DEMO5942'
update c_Assessment_Definition set last_updated=getdate(), description ='Aplasia testicle', long_description='Aplasia testicle' where assessment_id = 'DEMO5943'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Rectocele, male' where assessment_id = 'DEMO10434'
update c_Assessment_Definition set last_updated=getdate(), description ='Aplasia, prostate', long_description='Aplasia, prostate' where assessment_id = 'DEMO5941'
update c_Assessment_Definition set last_updated=getdate(), description ='Aplasia, uterus', long_description='Aplasia, uterus' where assessment_id = 'DEMO6013'
update c_Assessment_Definition set last_updated=getdate(), description ='Arteriosclerosis, coronary transplanted heart, bypass graft', long_description='Arteriosclerosis, coronary transplanted heart, bypass graft' where assessment_id = 'DEMO11481'
update c_Assessment_Definition set last_updated=getdate(), description ='Asphyxia, pathological', long_description='Asphyxia, pathological' where assessment_id = 'DEMO1323'
update c_Assessment_Definition set last_updated=getdate(), description ='Atresia, ejaculatory duct', long_description='Atresia, ejaculatory duct' where assessment_id = 'DEMO6020'
update c_Assessment_Definition set last_updated=getdate(), description ='Atrophy of the mandible NOS', long_description='Atrophy of the mandible NOS' where assessment_id = 'DEMO7652'
update c_Assessment_Definition set last_updated=getdate(), description ='Autoimmune disease (systemic) NOS', long_description='Autoimmune disease (systemic) NOS' where assessment_id = 'DEMO4829'
update c_Assessment_Definition set last_updated=getdate(), long_description ='Pyocystis' where assessment_id = 'DEMO8964'
update c_Assessment_Definition set last_updated=getdate(), description ='Barbiturate overdose', long_description='Barbiturate overdose' where assessment_id = 'DEMO9860'
update c_Assessment_Definition set last_updated=getdate(), description ='Borderline diabetes mellitus ', long_description='Borderline diabetes mellitus ' where assessment_id = 'ANDROG2'
update c_Assessment_Definition set last_updated=getdate(), description ='Bradycardia (sinoatrial) (sinus) (vagal) reflex', long_description='Bradycardia (sinoatrial) (sinus) (vagal) reflex' where assessment_id = 'DEMO7259A'
update c_Assessment_Definition set last_updated=getdate(), description ='Broncholithiasis', long_description='Broncholithiasis' where assessment_id = 'BRONCHODYS'
update c_Assessment_Definition set last_updated=getdate(), description ='Calcification cerebral (cortex)', long_description='Calcification cerebral (cortex)' where assessment_id = 'DEMO7340'
update c_Assessment_Definition set last_updated=getdate(), description ='Cardiomyopathy postpartum', long_description='Cardiomyopathy postpartum' where assessment_id = 'DEMO11500'
update c_Assessment_Definition set last_updated=getdate(), description ='Carnitine deficiency due to hemodialysis', long_description='Carnitine deficiency due to hemodialysis' where assessment_id = 'DEMO11466'
update c_Assessment_Definition set last_updated=getdate(), description ='Carrier of unspecified viral hepatitis', long_description='Carrier of unspecified viral hepatitis' where assessment_id = 'DEMO9387'
update c_Assessment_Definition set last_updated=getdate(), description ='Carrier of viral hepatitis B', long_description='Carrier of viral hepatitis B' where assessment_id = 'DEMO625'
update c_Assessment_Definition set last_updated=getdate(), description ='Carrier of viral hepatitis C', long_description='Carrier of viral hepatitis C' where assessment_id = 'DEMO626'
update c_Assessment_Definition set last_updated=getdate(), description ='Cenesthopathic schizophrenia', long_description='Cenesthopathic schizophrenia' where assessment_id = 'DEMO9620'
update c_Assessment_Definition set last_updated=getdate(), description ='Cephalgia, histamine not intractable', long_description='Cephalgia, histamine not intractable' where assessment_id = 'DEMO11400'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic (viral) hepatitis B', long_description='Chronic (viral) hepatitis B' where assessment_id = '0^11589'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic proliferative peritonitis', long_description='Chronic proliferative peritonitis' where assessment_id = 'DEMO7931'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic renal disease', long_description='Chronic renal disease' where assessment_id = 'DEMO6959'
update c_Assessment_Definition set last_updated=getdate(), description ='Circulating anticoagulants ', long_description='Circulating anticoagulants ' where assessment_id = 'DEMO7483'
update c_Assessment_Definition set last_updated=getdate(), description ='Common wart', long_description='Common wart' where assessment_id = 'WARTF'
update c_Assessment_Definition set last_updated=getdate(), description ='Communicable disease specified NEC', long_description='Communicable disease specified NEC' where assessment_id = 'DEMO9378'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital atresia of pulmonary artery', long_description='Congenital atresia of pulmonary artery' where assessment_id = 'DEMO6025'
update c_Assessment_Definition set last_updated=getdate(), description ='Congenital retinal aneurysm', long_description='Congenital retinal aneurysm' where assessment_id = 'DEMO11446'
update c_Assessment_Definition set last_updated=getdate(), description ='Contraception, initial prescription, postcoital (emergency)', long_description='Contraception, initial prescription, postcoital (emergency)' where assessment_id = 'DEMO11531'
update c_Assessment_Definition set last_updated=getdate(), description ='Chronic organic brain syndrome', long_description='Chronic organic brain syndrome' where assessment_id = 'DEMO9615'
update c_Assessment_Definition set last_updated=getdate(), description ='Counseling for non-attending third party', long_description='Counseling for non-attending third party' where assessment_id = 'DEMO11547'
update c_Assessment_Definition set last_updated=getdate(), description ='Counseling, infertility', long_description='Counseling, infertility' where assessment_id = '000194x'
update c_Assessment_Definition set last_updated=getdate(), description ='Crossbite (anterior) (posterior)', long_description='Crossbite (anterior) (posterior)' where assessment_id = 'DEMO7627'
update c_Assessment_Definition set last_updated=getdate(), description ='Cyclic hematopoiesis', long_description='Cyclic hematopoiesis' where assessment_id = 'DEMO7511'
update c_Assessment_Definition set last_updated=getdate(), description ='Decreased sexual desire', long_description='Decreased sexual desire' where assessment_id = 'DEMO11518'
update c_Assessment_Definition set last_updated=getdate(), description ='Deletion 22q11.2', long_description='Deletion 22q11.2' where assessment_id = 'DEMO6077'
update c_Assessment_Definition set last_updated=getdate(), description ='Delivery (childbirth) (labor) complicated by disease NEC', long_description='Delivery (childbirth) (labor) complicated by disease NEC' where assessment_id = 'TUB'
update c_Assessment_Definition set last_updated=getdate(), description ='Dementia with Parkinsonism', long_description='Dementia with Parkinsonism' where assessment_id = 'DEMO11476'
update c_Assessment_Definition set last_updated=getdate(), description ='Difficulty in feeding newborn', long_description='Difficulty in feeding newborn' where assessment_id = 'DEMO6754'
update c_Assessment_Definition set last_updated=getdate(), description ='Difficulty in swallowing NOS', long_description='Difficulty in swallowing NOS' where assessment_id = 'DEMO682'
update c_Assessment_Definition set last_updated=getdate(), description ='Dilated cardiomyopathy secondary to peripartum heart disease', long_description='Dilated cardiomyopathy secondary to peripartum heart disease' where assessment_id = 'DEMO11501'
update c_Assessment_Definition set last_updated=getdate(), description ='Disorder (of) cannabis use, moderate or severe', long_description='Disorder (of) cannabis use, moderate or severe' where assessment_id = 'DEMO9723'
update c_Assessment_Definition set last_updated=getdate(), description ='Displacement of fully erupted tooth or teeth NOS', long_description='Displacement of fully erupted tooth or teeth NOS' where assessment_id = 'DEMO7633'
update c_Assessment_Definition set last_updated=getdate(), description ='Dyschezia ', long_description='Dyschezia ' where assessment_id = 'DEMO11551'
update c_Assessment_Definition set last_updated=getdate(), description ='Effusion, peritoneal (chronic)', long_description='Effusion, peritoneal (chronic)' where assessment_id = 'DEMO70'
update c_Assessment_Definition set last_updated=getdate(), description ='Elevated fasting glucose', long_description='Elevated fasting glucose' where assessment_id = 'DEMO11515'
update c_Assessment_Definition set last_updated=getdate(), description ='Elevated glucose tolerance', long_description='Elevated glucose tolerance' where assessment_id = 'DEMO11516'
update c_Assessment_Definition set last_updated=getdate(), description ='Denture stomatitis', long_description='Denture stomatitis' where assessment_id = 'DEMO7703'
update c_Assessment_Definition set last_updated=getdate(), description ='Encephalopathy specified NEC', long_description='Encephalopathy specified NEC' where assessment_id = 'DEMO11478'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for insulin pump instruction and training', long_description='Encounter for insulin pump instruction and training' where assessment_id = 'DEMO11536'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter for insulin pump instruction and training', long_description='Encounter for insulin pump instruction and training' where assessment_id = 'DEMO11548'
update c_Assessment_Definition set last_updated=getdate(), description ='Encounter removal (of) insulin pump', long_description='Encounter removal (of) insulin pump' where assessment_id = 'DEMO11535'
update c_Assessment_Definition set last_updated=getdate(), description ='Enlarged prostate with lower urinary tract symtpoms', long_description='Enlarged prostate with lower urinary tract symtpoms' where assessment_id = 'DEMO11498'
update c_Assessment_Definition set last_updated=getdate(), description ='Enlarged prostate without lower urinary tract symtpoms', long_description='Enlarged prostate without lower urinary tract symtpoms' where assessment_id = 'DEMO11497'
update c_Assessment_Definition set last_updated=getdate(), description ='Erythema nodosum, tuberculous', long_description='Erythema nodosum, tuberculous' where assessment_id = 'DEMO10146'
update c_Assessment_Definition set last_updated=getdate(), description ='Erythroplakia of mouth or tongue', long_description='Erythroplakia of mouth or tongue' where assessment_id = 'DEMO7696'
update c_Assessment_Definition set last_updated=getdate(), description ='Examination annual gynecological ', long_description='Examination annual gynecological ' where assessment_id = 'DEMO1198'
update c_Assessment_Definition set last_updated=getdate(), description ='Exposure to viral disease', long_description='Exposure to viral disease' where assessment_id = 'DEMO9377'
update c_Assessment_Definition set last_updated=getdate(), description ='Exposure to human T-lymphotropic virus type-1 (HTLV-1)', long_description='Exposure to human T-lymphotropic virus type-1 (HTLV-1)' where assessment_id = 'DEMO11529'
update c_Assessment_Definition set last_updated=getdate(), description ='Facial droop', long_description='Facial droop' where assessment_id = 'DEMO11512'
update c_Assessment_Definition set last_updated=getdate(), description ='Failure, gain weight, newborn', long_description='Failure, gain weight, newborn' where assessment_id = 'FAILTOTHRIVE'
update c_Assessment_Definition set last_updated=getdate(), description ='False-positive serological test for syphilis', long_description='False-positive serological test for syphilis' where assessment_id = 'DEMO11118'
update c_Assessment_Definition set last_updated=getdate(), description ='Familial aldosteronism type I', long_description='Familial aldosteronism type I' where assessment_id = 'DEMO11460'
update c_Assessment_Definition set last_updated=getdate(), description ='Familial Creutzfeldt-Jakob disease', long_description='Familial Creutzfeldt-Jakob disease' where assessment_id = 'DEMO11458'
update c_Assessment_Definition set last_updated=getdate(), description ='Family history of digestive disease or disorder', long_description='Family history of digestive disease or disorder' where assessment_id = 'DEMO9056'
update c_Assessment_Definition set last_updated=getdate(), description ='Family history of hypercholesterolemia', long_description='Family history of hypercholesterolemia' where assessment_id = '0^11775'
update c_Assessment_Definition set last_updated=getdate(), description ='Family history of hypercholesterolemia', long_description='Family history of hypercholesterolemia' where assessment_id = 'DEMO1125'
update c_Assessment_Definition set last_updated=getdate(), description ='Fanconi''s anemia', long_description='Fanconi''s anemia' where assessment_id = 'DEMO7464'
update c_Assessment_Definition set last_updated=getdate(), description ='Fat necrosis of peritoneum', long_description='Fat necrosis of peritoneum' where assessment_id = 'DEMO7934'
update c_Assessment_Definition set last_updated=getdate(), description ='Fever neutropenic', long_description='Fever neutropenic' where assessment_id = 'DEMO680'
update c_Assessment_Definition set last_updated=getdate(), description ='Fever of unknown origin [FUO]', long_description='Fever of unknown origin [FUO]' where assessment_id = 'DEMO647'
update c_Assessment_Definition set last_updated=getdate(), description ='Fitting (and adjustment) (of) colostomy belt', long_description='Fitting (and adjustment) (of) colostomy belt' where assessment_id = 'DEMO9233'
update c_Assessment_Definition set last_updated=getdate(), description ='Fitting (and adjustment) (of) orthopedic device (brace) (cast) (corset) (shoes)', long_description='Fitting (and adjustment) (of) orthopedic device (brace) (cast) (corset) (shoes)' where assessment_id = 'DEMO9236'
update c_Assessment_Definition set last_updated=getdate(), description ='Fluid overload due to transfusion (blood) (blood components)', long_description='Fluid overload due to transfusion (blood) (blood components)' where assessment_id = 'DEMO4595'
update c_Assessment_Definition set last_updated=getdate(), description ='Foul breath', long_description='Foul breath' where assessment_id = 'ASSESSMENT20'
update c_Assessment_Definition set last_updated=getdate(), description ='Frontal dementia', long_description='Frontal dementia' where assessment_id = 'DEMO11475'
update c_Assessment_Definition set last_updated=getdate(), description ='Gait disorder, postural instability', long_description='Gait disorder, postural instability' where assessment_id = 'DEMO3682'
update c_Assessment_Definition set last_updated=getdate(), description ='Galactocele', long_description='Galactocele' where assessment_id = 'DEMO748'
update c_Assessment_Definition set last_updated=getdate(), description ='Gastritis allergic', long_description='Gastritis allergic' where assessment_id = '0^11587'
update c_Assessment_Definition set last_updated=getdate(), description ='Gélineau''s syndrome with cataplexy', long_description='Gélineau''s syndrome with cataplexy' where assessment_id = 'DEMO7332'
update c_Assessment_Definition set last_updated=getdate(), description ='Gingivostomatitis ', long_description='Gingivostomatitis ' where assessment_id = 'GINGIVO'
update c_Assessment_Definition set last_updated=getdate(), description ='Glaucoma of newborn', long_description='Glaucoma of newborn' where assessment_id = 'DEMO11445'
update c_Assessment_Definition set last_updated=getdate(), description ='Gouty arthropathy', long_description='Gouty arthropathy' where assessment_id = 'ARTGOU'
update c_Assessment_Definition set last_updated=getdate(), description ='Granuloma, eosinophilic, lung', long_description='Granuloma, eosinophilic, lung' where assessment_id = 'DEMO11342'
update c_Assessment_Definition set last_updated=getdate(), description ='Healing pressure ulcer of unspecified site NOS', long_description='Healing pressure ulcer of unspecified site NOS' where assessment_id = 'ULCDEC'
update c_Assessment_Definition set last_updated=getdate(), description ='Hemorrhagic disorder due to increase in anti-IIa', long_description='Hemorrhagic disorder due to increase in anti-IIa' where assessment_id = 'DEMO7485'
update c_Assessment_Definition set last_updated=getdate(), description ='Hemorrhagic disorder due to increase in anti-Xa', long_description='Hemorrhagic disorder due to increase in anti-Xa' where assessment_id = 'DEMO7504'
update c_Assessment_Definition set last_updated=getdate(), description ='Hernia due to adhesions (with obstruction)', long_description='Hernia due to adhesions (with obstruction)' where assessment_id = '0^11598'
update c_Assessment_Definition set last_updated=getdate(), description ='Heroin overdose', long_description='Heroin overdose' where assessment_id = 'DEMO9850'
update c_Assessment_Definition set last_updated=getdate(), description ='History of cancer of the prostate', long_description='History of cancer of the prostate' where assessment_id = 'DEMO11436'
update c_Assessment_Definition set last_updated=getdate(), description ='History of diabetes mellitus resolved post bariatric surgery', long_description='History of diabetes mellitus resolved post bariatric surgery' where assessment_id = '0^11761A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of eye injury', long_description='History of eye injury' where assessment_id = 'DEMO9035A'
update c_Assessment_Definition set last_updated=getdate(), description ='History of immune disorder', long_description='History of immune disorder' where assessment_id = 'DEMO4835'
update c_Assessment_Definition set last_updated=getdate(), description ='History of spinal cord injury', long_description='History of spinal cord injury' where assessment_id = 'DEMO9035'
update c_Assessment_Definition set last_updated=getdate(), description ='History of syncope', long_description='History of syncope' where assessment_id = 'DEMO11457'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoplasia of pulmonary artery', long_description='Hypoplasia of pulmonary artery' where assessment_id = 'DEMO2066'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypoplastic anemia NOS', long_description='Hypoplastic anemia NOS' where assessment_id = 'DEMO7465'
update c_Assessment_Definition set last_updated=getdate(), description ='Hypopyrexia', long_description='Hypopyrexia' where assessment_id = '78065'
update c_Assessment_Definition set last_updated=getdate(), description ='Iatrogenic Creutzfeldt-Jakob disease', long_description='Iatrogenic Creutzfeldt-Jakob disease' where assessment_id = 'DEMO4178'
update c_Assessment_Definition set last_updated=getdate(), description ='Iatrogenic hypotension', long_description='Iatrogenic hypotension' where assessment_id = 'DEMO11483'
update c_Assessment_Definition set last_updated=getdate(), description ='Idiopathic fibrosing alveolitis', long_description='Idiopathic fibrosing alveolitis' where assessment_id = 'DEMO5007'
update c_Assessment_Definition set last_updated=getdate(), description ='Idiopathic hemorrhagic thrombocythemia', long_description='Idiopathic hemorrhagic thrombocythemia' where assessment_id = 'DEMO9208'
update c_Assessment_Definition set last_updated=getdate(), description ='Idiopathic thrombocytopenia purpura (itp)', long_description='Idiopathic thrombocytopenia purpura (itp)' where assessment_id = 'ITP'
update c_Assessment_Definition set last_updated=getdate(), description ='Inadequate or distorted communication within family', long_description='Inadequate or distorted communication within family' where assessment_id = 'DEMO9488'
update c_Assessment_Definition set last_updated=getdate(), description ='Influenza, novel influenza A/H1N1', long_description='Influenza, novel influenza A/H1N1' where assessment_id = '981^488.1^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Internal granuloma of pulp', long_description='Internal granuloma of pulp' where assessment_id = 'DEMO7594'
update c_Assessment_Definition set last_updated=getdate(), description ='Intra-dialytic hypotension', long_description='Intra-dialytic hypotension' where assessment_id = 'DEMO11482'
update c_Assessment_Definition set last_updated=getdate(), description ='Laboratory exam', long_description='Laboratory exam' where assessment_id = 'DEMO1479'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of bladder following (induce…', long_description='Laceration, perforation, tear or chemical damage of bladder following (induced) termination of pregnancy' where assessment_id = 'DEMO6757'
update c_Assessment_Definition set last_updated=getdate(), description ='Laceration, perforation, tear or chemical damage of broad ligament following …', long_description='Laceration, perforation, tear or chemical damage of broad ligament following (induced) termination of pregnancy' where assessment_id = 'DEMO443x4c'
update c_Assessment_Definition set last_updated=getdate(), description ='Latent diabetes', long_description='Latent diabetes' where assessment_id = '0^11955'
update c_Assessment_Definition set last_updated=getdate(), description ='Latent schizophrenia', long_description='Latent schizophrenia' where assessment_id = 'DEMO9622'
update c_Assessment_Definition set last_updated=getdate(), description ='Launois-Bensaude adenolipomatosis', long_description='Launois-Bensaude adenolipomatosis' where assessment_id = 'DEMO10482'
update c_Assessment_Definition set last_updated=getdate(), description ='Leriche''s syndrome', long_description='Leriche''s syndrome' where assessment_id = '0001122x'
update c_Assessment_Definition set last_updated=getdate(), description ='Lesion(s) (nontraumatic) basal ganglion', long_description='Lesion(s) (nontraumatic) basal ganglion' where assessment_id = '0^333.99^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Leukoedema of mouth or tongue', long_description='Leukoedema of mouth or tongue' where assessment_id = 'DEMO7697'
update c_Assessment_Definition set last_updated=getdate(), description ='Lightwood-Albright syndrome', long_description='Lightwood-Albright syndrome' where assessment_id = 'DEMO6969'
update c_Assessment_Definition set last_updated=getdate(), description ='Liveborn single born outside hospital prior to admission', long_description='Liveborn single born outside hospital prior to admission' where assessment_id = 'DEMO1190b'
update c_Assessment_Definition set last_updated=getdate(), description ='Lymphangitis, puerperal, postpartum, childbirth', long_description='Lymphangitis, puerperal, postpartum, childbirth' where assessment_id = 'DEMO1084'
update c_Assessment_Definition set last_updated=getdate(), description ='Malocclusion due to abnormal swallowing', long_description='Malocclusion due to abnormal swallowing' where assessment_id = 'DEMO7636'
update c_Assessment_Definition set last_updated=getdate(), description ='Malocclusion due to mouth breathing', long_description='Malocclusion due to mouth breathing' where assessment_id = 'DEMO7635'
update c_Assessment_Definition set last_updated=getdate(), description ='Manic depression', long_description='Manic depression' where assessment_id = 'DEMO77'
update c_Assessment_Definition set last_updated=getdate(), description ='Marital estrangement', long_description='Marital estrangement' where assessment_id = 'DEMO9148'
update c_Assessment_Definition set last_updated=getdate(), description ='Meconium aspiration pneumonia', long_description='Meconium aspiration pneumonia' where assessment_id = 'MECA'
update c_Assessment_Definition set last_updated=getdate(), description ='Mediterranean anemia (with other hemoglobinopathy)', long_description='Mediterranean anemia (with other hemoglobinopathy)' where assessment_id = 'DEMO7438'
update c_Assessment_Definition set last_updated=getdate(), description ='Memory loss NOS', long_description='Memory loss NOS' where assessment_id = 'DEMO11510'
update c_Assessment_Definition set last_updated=getdate(), description ='Mesenteric saponification', long_description='Mesenteric saponification' where assessment_id = 'DEMO7935'
update c_Assessment_Definition set last_updated=getdate(), description ='Micromastia', long_description='Micromastia' where assessment_id = 'DEMO746'
update c_Assessment_Definition set last_updated=getdate(), description ='Micturition urgency', long_description='Micturition urgency' where assessment_id = 'DEMO11514'
update c_Assessment_Definition set last_updated=getdate(), description ='Midline deviation of dental arch', long_description='Midline deviation of dental arch' where assessment_id = 'DEMO7634'
update c_Assessment_Definition set last_updated=getdate(), description ='Myasthenia gravis in crisis', long_description='Myasthenia gravis in crisis' where assessment_id = 'DEMO11480'
update c_Assessment_Definition set last_updated=getdate(), description ='Myeloproliferative disease, not classified', long_description='Myeloproliferative disease, not classified' where assessment_id = 'DEMO9207'
update c_Assessment_Definition set last_updated=getdate(), description ='Necrotizing enterocolitis with perforation', long_description='Necrotizing enterocolitis with perforation' where assessment_id = 'DEMO6741C'
update c_Assessment_Definition set last_updated=getdate(), description ='Necrotizing enterocolitis with pneumatosis and perforation', long_description='Necrotizing enterocolitis with pneumatosis and perforation' where assessment_id = 'DEMO6741'
update c_Assessment_Definition set last_updated=getdate(), description ='Necrotizing enterocolitis with pneumatosis, without perforation', long_description='Necrotizing enterocolitis with pneumatosis, without perforation' where assessment_id = 'DEMO6741B'
update c_Assessment_Definition set last_updated=getdate(), description ='Hyperplasia, papillary, palate (irritative)', long_description='Hyperplasia, papillary, palate (irritative)' where assessment_id = 'DEMO7700'
update c_Assessment_Definition set last_updated=getdate(), description ='Necrotizing enterocolitis without pneumatosis, without perforation', long_description='Necrotizing enterocolitis without pneumatosis, without perforation' where assessment_id = 'DEMO6741A'
update c_Assessment_Definition set last_updated=getdate(), description ='Nephrosis, osmotic', long_description='Nephrosis, osmotic' where assessment_id = 'DEMO6968'
update c_Assessment_Definition set last_updated=getdate(), description ='Nervous tension', long_description='Nervous tension' where assessment_id = 'DEMO1325'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by amniocentesis', long_description='Newborn affected by amniocentesis' where assessment_id = 'DEMO6504A'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn affected by hypoxic ischemic encephalopathy [HIE] ', long_description='Newborn affected by hypoxic ischemic encephalopathy [HIE] ' where assessment_id = '0^768.7^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Newborn with gestation period over 40 completed weeks to 42 completed weeks', long_description='Newborn with gestation period over 40 completed weeks to 42 completed weeks' where assessment_id = 'DEMO6668'
update c_Assessment_Definition set last_updated=getdate(), description ='Non-Shiga toxin-producing E. coli', long_description='Non-Shiga toxin-producing E. coli' where assessment_id = 'DEMO4157'
update c_Assessment_Definition set last_updated=getdate(), description ='Nontraumatic seroma of muscle and soft tissue', long_description='Nontraumatic seroma of muscle and soft tissue' where assessment_id = 'DEMO3828B'
update c_Assessment_Definition set last_updated=getdate(), description ='Non-visualized anatomy on a previous scan', long_description='Non-visualized anatomy on a previous scan' where assessment_id = 'DEMO9477'
update c_Assessment_Definition set last_updated=getdate(), description ='Obstruction, cystic duct with calculus', long_description='Obstruction, cystic duct with calculus' where assessment_id = '0^11583'
update c_Assessment_Definition set last_updated=getdate(), description ='Occlusal wear of teeth', long_description='Occlusal wear of teeth' where assessment_id = 'DEMO7591'
update c_Assessment_Definition set last_updated=getdate(), description ='Occupational problems NOS', long_description='Occupational problems NOS' where assessment_id = 'DEMO9150'
update c_Assessment_Definition set last_updated=getdate(), description ='Occupational therapy visit', long_description='Occupational therapy visit' where assessment_id = 'DEMO9271'
update c_Assessment_Definition set last_updated=getdate(), description ='Opioid overdose', long_description='Opioid overdose' where assessment_id = 'DEMO9852'
update c_Assessment_Definition set last_updated=getdate(), description ='Otto''s disease or pelvis', long_description='Otto''s disease or pelvis' where assessment_id = 'DEMO3650'
update c_Assessment_Definition set last_updated=getdate(), description ='Overbite (excessive) deep', long_description='Overbite (excessive) deep' where assessment_id = 'DEMO7628'
update c_Assessment_Definition set last_updated=getdate(), description ='Overjet (excessive horizontal)', long_description='Overjet (excessive horizontal)' where assessment_id = 'DEMO7629'
update c_Assessment_Definition set last_updated=getdate(), description ='Paget-Schroetter syndrome', long_description='Paget-Schroetter syndrome' where assessment_id = 'DEMO520'
update c_Assessment_Definition set last_updated=getdate(), description ='Papanicolaou smear, cervix as part of routine gynecological examination', long_description='Papanicolaou smear, cervix as part of routine gynecological examination' where assessment_id = '0001112x'
update c_Assessment_Definition set last_updated=getdate(), description ='Papanicolaou smear, cervix', long_description='Papanicolaou smear, cervix' where assessment_id = 'DEMO6668Q'
update c_Assessment_Definition set last_updated=getdate(), description ='Paralysis, asthenic bulbar', long_description='Paralysis, asthenic bulbar' where assessment_id = 'DEMO11479'
update c_Assessment_Definition set last_updated=getdate(), description ='Paralysis, cervical, sympathetic', long_description='Paralysis, cervical, sympathetic' where assessment_id = 'DEMO7259'
update c_Assessment_Definition set last_updated=getdate(), description ='Paraproteinemia, benign (familial)', long_description='Paraproteinemia, benign (familial)' where assessment_id = 'DEMO7562'
update c_Assessment_Definition set last_updated=getdate(), description ='Pelvic peritonitis (acute), male', long_description='Pelvic peritonitis (acute), male' where assessment_id = 'DEMO7928'
update c_Assessment_Definition set last_updated=getdate(), description ='Perforation of nasal septum NOS', long_description='Perforation of nasal septum NOS' where assessment_id = '0^478.19^4'
update c_Assessment_Definition set last_updated=getdate(), description ='Peritonitis due to bile', long_description='Peritonitis due to bile' where assessment_id = 'DEMO7932'
update c_Assessment_Definition set last_updated=getdate(), description ='Peritonitis due to urine', long_description='Peritonitis due to urine' where assessment_id = 'DEMO7933'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of endocrine disorder', long_description='Personal history of endocrine disorder' where assessment_id = 'DEMO4833'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of endocrine disorder', long_description='Personal history of endocrine disorder' where assessment_id = 'DEMO4833A'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of metabolic disorder', long_description='Personal history of metabolic disorder' where assessment_id = 'DEMO4834'
update c_Assessment_Definition set last_updated=getdate(), description ='Personal history of metabolic disorder', long_description='Personal history of metabolic disorder' where assessment_id = 'DEMO4834A'
update c_Assessment_Definition set last_updated=getdate(), description ='Plaque induced gingival disease', long_description='Plaque induced gingival disease' where assessment_id = 'GING'
update c_Assessment_Definition set last_updated=getdate(), description ='Pleurisy with effusion (exudative) (serous)', long_description='Pleurisy with effusion (exudative) (serous)' where assessment_id = '981^511.81^1'
update c_Assessment_Definition set last_updated=getdate(), description ='Pneumaturia', long_description='Pneumaturia' where assessment_id = 'DEMO1258B'
update c_Assessment_Definition set last_updated=getdate(), description ='Polyalgia', long_description='Polyalgia' where assessment_id = 'DEMO3828C'
update c_Assessment_Definition set last_updated=getdate(), description ='Positive culture finding', long_description='Positive culture finding' where assessment_id = 'DEMO1310'
update c_Assessment_Definition set last_updated=getdate(), description ='Postimmunization fever', long_description='Postimmunization fever' where assessment_id = 'DEMO647B'
update c_Assessment_Definition set last_updated=getdate(), description ='Post-infectious encephalitis', long_description='Post-infectious encephalitis' where assessment_id = 'DEMO7178'
update c_Assessment_Definition set last_updated=getdate(), description ='Postradiation encephalopathy', long_description='Postradiation encephalopathy' where assessment_id = 'DEMO7341'
update c_Assessment_Definition set last_updated=getdate(), description ='Pre-adoption pediatrician visit for adoptive parent(s)', long_description='Pre-adoption pediatrician visit for adoptive parent(s)' where assessment_id = 'DEMO11546'
update c_Assessment_Definition set last_updated=getdate(), description ='Prediabetes complicating puerperium ', long_description='Prediabetes complicating puerperium ' where assessment_id = 'DEMO10592'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy examination or test, pregnancy unconfirmed', long_description='Pregnancy examination or test, pregnancy unconfirmed' where assessment_id = 'DEMO2499'
update c_Assessment_Definition set last_updated=getdate(), description ='Pregnancy intraperitoneal ', long_description='Pregnancy intraperitoneal ' where assessment_id = 'DEMO871'
update c_Assessment_Definition set last_updated=getdate(), description ='Presence of systemic lupus erythematosus [SLE] inhibitor', long_description='Presence of systemic lupus erythematosus [SLE] inhibitor' where assessment_id = 'DEMO7486'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary hypercoagulable state', long_description='Primary hypercoagulable state' where assessment_id = 'DEMO11473'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary malignant neoplasm of skin of lip', long_description='Primary malignant neoplasm of skin of lip' where assessment_id = 'DEMO399'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary malignant neoplasm of skin of neck', long_description='Primary malignant neoplasm of skin of neck' where assessment_id = 'DEMO405'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary malignant neoplasm of skin of trunk', long_description='Primary malignant neoplasm of skin of trunk' where assessment_id = 'DEMO331'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary progressive aphasia', long_description='Primary progressive aphasia' where assessment_id = 'DEMO7198'
update c_Assessment_Definition set last_updated=getdate(), description ='Proctitis ', long_description='Proctitis ' where assessment_id = '0^11594'
update c_Assessment_Definition set last_updated=getdate(), description ='Prolapse, pelvic floor, female', long_description='Prolapse, pelvic floor, female' where assessment_id = 'DEMO121'
update c_Assessment_Definition set last_updated=getdate(), description ='Prolapse, perineum, female', long_description='Prolapse, perineum, female' where assessment_id = 'DEMO776'
update c_Assessment_Definition set last_updated=getdate(), description ='Puerperal interstitial mastitis', long_description='Puerperal interstitial mastitis' where assessment_id = 'DEMO11288'
update c_Assessment_Definition set last_updated=getdate(), description ='Pyrexia NOS', long_description='Pyrexia NOS' where assessment_id = 'DEMO2102'
update c_Assessment_Definition set last_updated=getdate(), description ='Refractory anemia without sideroblasts, without excess of blasts', long_description='Refractory anemia without sideroblasts, without excess of blasts' where assessment_id = 'DEMO9209'
update c_Assessment_Definition set last_updated=getdate(), description ='Relaxation of vaginal outlet and/or pelvis', long_description='Relaxation of vaginal outlet and/or pelvis' where assessment_id = 'DEMO789'
update c_Assessment_Definition set last_updated=getdate(), description ='Removal of staples', long_description='Removal of staples' where assessment_id = 'DEMO1459'
update c_Assessment_Definition set last_updated=getdate(), description ='Renal dialysis status NOS', long_description='Renal dialysis status NOS' where assessment_id = 'DEMO1453'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening for a suspected anomaly', long_description='Screening for a suspected anomaly' where assessment_id = '0^V28.0^0'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening for hepatitis b', long_description='Screening for hepatitis b' where assessment_id = '0^12307'
update c_Assessment_Definition set last_updated=getdate(), description ='Screening for neurological condition', long_description='Screening for neurological condition' where assessment_id = 'DEMO9353'
update c_Assessment_Definition set last_updated=getdate(), description ='Secondary hypercoagulable state', long_description='Secondary hypercoagulable state' where assessment_id = 'DEMO11474'
update c_Assessment_Definition set last_updated=getdate(), description ='Secondary myelofibrosis NOS', long_description='Secondary myelofibrosis NOS' where assessment_id = 'DEMO7563'
update c_Assessment_Definition set last_updated=getdate(), description ='Septic encephalopathy', long_description='Septic encephalopathy' where assessment_id = 'DEMO11477'
update c_Assessment_Definition set last_updated=getdate(), description ='Shock endotoxic', long_description='Shock endotoxic' where assessment_id = 'DEMO11513'
update c_Assessment_Definition set last_updated=getdate(), description ='Shock gram-negative', long_description='Shock gram-negative' where assessment_id = 'DEMO647A'
update c_Assessment_Definition set last_updated=getdate(), description ='Snuffles (non-syphilitic)', long_description='Snuffles (non-syphilitic)' where assessment_id = 'HALITOS'
update c_Assessment_Definition set last_updated=getdate(), description ='Sporadic Creutzfeldt-Jakob disease', long_description='Sporadic Creutzfeldt-Jakob disease' where assessment_id = 'DEMO4164'
update c_Assessment_Definition set last_updated=getdate(), description ='Stenosis of bronchus', long_description='Stenosis of bronchus' where assessment_id = 'BROS'
update c_Assessment_Definition set last_updated=getdate(), description ='Stomatitis NOS', long_description='Stomatitis NOS' where assessment_id = 'STOMA'
update c_Assessment_Definition set last_updated=getdate(), description ='Subgaleal hemorrhage', long_description='Subgaleal hemorrhage' where assessment_id = 'DEMOCAP1'
update c_Assessment_Definition set last_updated=getdate(), description ='Subgaleal hemorrhage', long_description='Subgaleal hemorrhage' where assessment_id = 'DEMOCAP2'
update c_Assessment_Definition set last_updated=getdate(), description ='Subphrenic peritonitis (acute)', long_description='Subphrenic peritonitis (acute)' where assessment_id = 'DEMO7929'
update c_Assessment_Definition set last_updated=getdate(), description ='Suppurative peritonitis (acute)', long_description='Suppurative peritonitis (acute)' where assessment_id = 'DEMO7930'
update c_Assessment_Definition set last_updated=getdate(), description ='Supravalvular pulmonary stenosis', long_description='Supravalvular pulmonary stenosis' where assessment_id = 'DEMO6041'
update c_Assessment_Definition set last_updated=getdate(), description ='Thrombosis, aorta, abdominal', long_description='Thrombosis, aorta, abdominal' where assessment_id = 'DEMO1898'
update c_Assessment_Definition set last_updated=getdate(), description ='Toxic encephalitis', long_description='Toxic encephalitis' where assessment_id = 'DEMO7179'
update c_Assessment_Definition set last_updated=getdate(), description ='Tracheobronchial collapse', long_description='Tracheobronchial collapse' where assessment_id = 'DEMO11485'
update c_Assessment_Definition set last_updated=getdate(), description ='Tracheobronchial dyskinesia', long_description='Tracheobronchial dyskinesia' where assessment_id = 'DEMO11486'
update c_Assessment_Definition set last_updated=getdate(), description ='Transposition of fully erupted tooth or teeth NOS', long_description='Transposition of fully erupted tooth or teeth NOS' where assessment_id = 'DEMO7631'
update c_Assessment_Definition set last_updated=getdate(), description ='Tuberculosis of hilar lymph nodes', long_description='Tuberculosis of hilar lymph nodes' where assessment_id = 'DEMO4042'
update c_Assessment_Definition set last_updated=getdate(), description ='Tuberculosis of pleura Tuberculous empyema', long_description='Tuberculosis of pleura Tuberculous empyema' where assessment_id = 'DEMO4041'
update c_Assessment_Definition set last_updated=getdate(), description ='Tuberculous orchitis', long_description='Tuberculous orchitis' where assessment_id = 'DEMO8929'
update c_Assessment_Definition set last_updated=getdate(), description ='Twin liveborn born outside hospital prior to admission', long_description='Twin liveborn born outside hospital prior to admission' where assessment_id = 'EXAMBIRTH3'
update c_Assessment_Definition set last_updated=getdate(), description ='Ulcer of anus and rectum', long_description='Ulcer of anus and rectum' where assessment_id = '0^11612'
update c_Assessment_Definition set last_updated=getdate(), description ='Ulcer, Barrett''s (esophagus)', long_description='Ulcer, Barrett''s (esophagus)' where assessment_id = 'DEMO11488'
update c_Assessment_Definition set last_updated=getdate(), description ='Ulcer, Barrett''s (esophagus) with bleeding', long_description='Ulcer, Barrett''s (esophagus) with bleeding' where assessment_id = 'DEMO11489'
update c_Assessment_Definition set last_updated=getdate(), description ='Unicornate uterus with or without a separate uterine horn', long_description='Unicornate uterus with or without a separate uterine horn' where assessment_id = 'DEMO5913'
update c_Assessment_Definition set last_updated=getdate(), description ='Unknown and unspecified cases of morbidity', long_description='Unknown and unspecified cases of morbidity' where assessment_id = 'DEMO11519'
update c_Assessment_Definition set last_updated=getdate(), description ='Urinary incontinence due to cognitive impairment, or severe physical disabili…', long_description='Urinary incontinence due to cognitive impairment, or severe physical disability or immobility' where assessment_id = 'DEMO1258A'
update c_Assessment_Definition set last_updated=getdate(), description ='Urinary tract obstruction', long_description='Urinary tract obstruction' where assessment_id = 'DEMO7052'
update c_Assessment_Definition set last_updated=getdate(), description ='Vaccination for influenza', long_description='Vaccination for influenza' where assessment_id = 'DEMO716'
update c_Assessment_Definition set last_updated=getdate(), description ='West Nile fever without complications', long_description='West Nile fever without complications' where assessment_id = 'DEMO10011'
update c_Assessment_Definition set last_updated=getdate(), description ='Whole blood donor', long_description='Whole blood donor' where assessment_id = 'DEMO9248'
update c_Assessment_Definition set last_updated=getdate(), description ='Transient organic mental disorder', long_description='Transient organic mental disorder' where assessment_id = 'DEMO9607'
update c_Assessment_Definition set last_updated=getdate(), description ='Ulcer, oral mucosa (traumatic)', long_description='Ulcer, oral mucosa (traumatic)' where assessment_id = 'ULCM'
update c_Assessment_Definition set last_updated=getdate(), description ='Peritonitis due to peritoneal dialysis', long_description='Peritonitis due to peritoneal dialysis' where assessment_id = 'DEMO11337'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary aldosteronism due to adrenal hyperplasia (bilateral)', long_description='Primary aldosteronism due to adrenal hyperplasia (bilateral)' where assessment_id = 'DEMO11462'
update c_Assessment_Definition set last_updated=getdate(), description ='Primary malignant neoplasm of skin of face', long_description='Primary malignant neoplasm of skin of face' where assessment_id = 'DEMO8286'

-- Assign re-assignments

update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R1033' where assessment_id = '0^11560'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7309' where assessment_id = 'DEMO11517'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R87629' where assessment_id = '79510'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2630' where assessment_id = 'DEMO7632'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K031' where assessment_id = 'DEMO7592'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T391X1A' where assessment_id = 'DEMO9863'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N2589' where assessment_id = 'DEMO306'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='H10219' where assessment_id = '981^372.60^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I82409' where assessment_id = 'DEMO1942'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z472' where assessment_id = 'DEMO11537'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q2579' where assessment_id = 'DEMO2059'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J340' where assessment_id = '0^478.19^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J340' where assessment_id = '0^478.19^1'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J340' where assessment_id = '0^478.19^2'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E261' where assessment_id = 'DEMO11463'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N879' where assessment_id = 'DEMO47'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D612' where assessment_id = 'DEMO7467'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q279' where assessment_id = 'DEMO10653'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q2579' where assessment_id = 'DEMO2060'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q139' where assessment_id = 'DEMO11444'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K2961' where assessment_id = 'DUITb'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K134' where assessment_id = 'DEMO7702'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K134' where assessment_id = 'DEMO7701'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q528' where assessment_id = 'DEMO5942'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q550' where assessment_id = 'DEMO5943'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K623' where assessment_id = 'DEMO10434'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q554' where assessment_id = 'DEMO5941'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q510' where assessment_id = 'DEMO6013'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I25812' where assessment_id = 'DEMO11481'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R0901' where assessment_id = 'DEMO1323'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q554' where assessment_id = 'DEMO6020'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K0820' where assessment_id = 'DEMO7652'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M359' where assessment_id = 'DEMO4829'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N3080' where assessment_id = 'DEMO8964'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T423X1A' where assessment_id = 'DEMO9860'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7303 ' where assessment_id = 'ANDROG2'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9009' where assessment_id = 'DEMO7259A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J9809 ' where assessment_id = 'BRONCHODYS'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9389' where assessment_id = 'DEMO7340'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O903' where assessment_id = 'DEMO11500'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E7143' where assessment_id = 'DEMO11466'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B189' where assessment_id = 'DEMO9387'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B181' where assessment_id = 'DEMO625'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B182 ' where assessment_id = 'DEMO626'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F2089 ' where assessment_id = 'DEMO9620'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G44009' where assessment_id = 'DEMO11400'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B181' where assessment_id = '0^11589'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K658' where assessment_id = 'DEMO7931'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N189' where assessment_id = 'DEMO6959'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D68318' where assessment_id = 'DEMO7483'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B078' where assessment_id = 'WARTF'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z2089' where assessment_id = 'DEMO9378'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q255' where assessment_id = 'DEMO6025'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q141' where assessment_id = 'DEMO11446'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z30012' where assessment_id = 'DEMO11531'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F09' where assessment_id = 'DEMO9615'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z710' where assessment_id = 'DEMO11547'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z3169' where assessment_id = '000194x'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2624' where assessment_id = 'DEMO7627'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D704' where assessment_id = 'DEMO7511'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R6882 ' where assessment_id = 'DEMO11518'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q9381' where assessment_id = 'DEMO6077'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O9989' where assessment_id = 'TUB'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G3183' where assessment_id = 'DEMO11476'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P929' where assessment_id = 'DEMO6754'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R1310 ' where assessment_id = 'DEMO682'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O903' where assessment_id = 'DEMO11501'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F1220 ' where assessment_id = 'DEMO9723'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2630' where assessment_id = 'DEMO7633'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K5900' where assessment_id = 'DEMO11551'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R188' where assessment_id = 'DEMO70'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7301' where assessment_id = 'DEMO11515'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7302' where assessment_id = 'DEMO11516'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K121' where assessment_id = 'DEMO7703'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9349' where assessment_id = 'DEMO11478'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4681' where assessment_id = 'DEMO11536'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4681' where assessment_id = 'DEMO11548'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4681' where assessment_id = 'DEMO11535'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N401' where assessment_id = 'DEMO11498'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N400' where assessment_id = 'DEMO11497'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A184' where assessment_id = 'DEMO10146'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K1329' where assessment_id = 'DEMO7696'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z01419' where assessment_id = 'DEMO1198'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z20828' where assessment_id = 'DEMO9377'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z2089' where assessment_id = 'DEMO11529'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R29810' where assessment_id = 'DEMO11512'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P926' where assessment_id = 'FAILTOTHRIVE'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R768' where assessment_id = 'DEMO11118'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E2602' where assessment_id = 'DEMO11460'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A8109' where assessment_id = 'DEMO11458'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8379' where assessment_id = 'DEMO9056'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8349' where assessment_id = '0^11775'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8349' where assessment_id = 'DEMO1125'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6109' where assessment_id = 'DEMO7464'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K654' where assessment_id = 'DEMO7934'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D709' where assessment_id = 'DEMO680'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R509' where assessment_id = 'DEMO647'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4689' where assessment_id = 'DEMO9233'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4689' where assessment_id = 'DEMO9236'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E8771' where assessment_id = 'DEMO4595'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R196' where assessment_id = 'ASSESSMENT20'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G3109' where assessment_id = 'DEMO11475'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R2689' where assessment_id = 'DEMO3682'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N6489' where assessment_id = 'DEMO748'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K2960' where assessment_id = '0^11587'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G47419' where assessment_id = 'DEMO7332'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K0510' where assessment_id = 'GINGIVO'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q150' where assessment_id = 'DEMO11445'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M1000' where assessment_id = 'ARTGOU'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C966' where assessment_id = 'DEMO11342'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='L8990' where assessment_id = 'ULCDEC'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6832' where assessment_id = 'DEMO7485'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6832' where assessment_id = 'DEMO7504'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K5650' where assessment_id = '0^11598'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T401X1A' where assessment_id = 'DEMO9850'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8546' where assessment_id = 'DEMO11436'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8639' where assessment_id = '0^11761A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z87828 ' where assessment_id = 'DEMO9035A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z862' where assessment_id = 'DEMO4835'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z87828' where assessment_id = 'DEMO9035'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8679' where assessment_id = 'DEMO11457'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q2579' where assessment_id = 'DEMO2066'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D619 ' where assessment_id = 'DEMO7465'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R680' where assessment_id = '78065'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A8109' where assessment_id = 'DEMO4178'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I9589' where assessment_id = 'DEMO11483'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J84112' where assessment_id = 'DEMO5007'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D473' where assessment_id = 'DEMO9208'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D693' where assessment_id = 'ITP'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z638' where assessment_id = 'DEMO9488'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J101' where assessment_id = '981^488.1^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K033' where assessment_id = 'DEMO7594'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I953' where assessment_id = 'DEMO11482'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z0000' where assessment_id = 'DEMO1479'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O0484' where assessment_id = 'DEMO6757'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O0484' where assessment_id = 'DEMO443x4c'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7303 ' where assessment_id = '0^11955'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F21' where assessment_id = 'DEMO9622'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E8889' where assessment_id = 'DEMO10482'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I7409' where assessment_id = '0001122x'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G259' where assessment_id = '0^333.99^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K1329' where assessment_id = 'DEMO7697'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N2589' where assessment_id = 'DEMO6969'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z381' where assessment_id = 'DEMO1190b'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O8689' where assessment_id = 'DEMO1084'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2659' where assessment_id = 'DEMO7636'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2659' where assessment_id = 'DEMO7635'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F319 ' where assessment_id = 'DEMO77'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z635' where assessment_id = 'DEMO9148'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P2401' where assessment_id = 'MECA'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D569' where assessment_id = 'DEMO7438'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R413' where assessment_id = 'DEMO11510'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K658' where assessment_id = 'DEMO7935'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N6482' where assessment_id = 'DEMO746'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R3915' where assessment_id = 'DEMO11514'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2629' where assessment_id = 'DEMO7634'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G7001' where assessment_id = 'DEMO11480'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C946' where assessment_id = 'DEMO9207'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P773' where assessment_id = 'DEMO6741C'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P773' where assessment_id = 'DEMO6741'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P772' where assessment_id = 'DEMO6741B'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K136' where assessment_id = 'DEMO7700'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P771' where assessment_id = 'DEMO6741A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N2589' where assessment_id = 'DEMO6968'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R450' where assessment_id = 'DEMO1325'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P006' where assessment_id = 'DEMO6504A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P9160' where assessment_id = '0^768.7^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P0821' where assessment_id = 'DEMO6668'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='B9629' where assessment_id = 'DEMO4157'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M7981' where assessment_id = 'DEMO3828B'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z362' where assessment_id = 'DEMO9477'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K8021' where assessment_id = '0^11583'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K030' where assessment_id = 'DEMO7591'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z569' where assessment_id = 'DEMO9150'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z5189' where assessment_id = 'DEMO9271'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T402X1A' where assessment_id = 'DEMO9852'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M247' where assessment_id = 'DEMO3650'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2629' where assessment_id = 'DEMO7628'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2623' where assessment_id = 'DEMO7629'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I82890' where assessment_id = 'DEMO520'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z01419' where assessment_id = '0001112x'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z124' where assessment_id = 'DEMO6668Q'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G7000 ' where assessment_id = 'DEMO11479'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9009' where assessment_id = 'DEMO7259'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D892' where assessment_id = 'DEMO7562'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K650' where assessment_id = 'DEMO7928'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J3489' where assessment_id = '0^478.19^4'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K653' where assessment_id = 'DEMO7932'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K658' where assessment_id = 'DEMO7933'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8639' where assessment_id = 'DEMO4833'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8639' where assessment_id = 'DEMO4833A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8639' where assessment_id = 'DEMO4834'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8639' where assessment_id = 'DEMO4834A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K0500' where assessment_id = 'GING'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J90' where assessment_id = '981^511.81^1'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R3989' where assessment_id = 'DEMO1258B'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M7989' where assessment_id = 'DEMO3828C'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R899' where assessment_id = 'DEMO1310'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R5083' where assessment_id = 'DEMO647B'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G0401' where assessment_id = 'DEMO7178'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9389 ' where assessment_id = 'DEMO7341'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z7681' where assessment_id = 'DEMO11546'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O9989' where assessment_id = 'DEMO10592'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z3200' where assessment_id = 'DEMO2499'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O0000' where assessment_id = 'DEMO871'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6862' where assessment_id = 'DEMO7486'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6859' where assessment_id = 'DEMO11473'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C4400' where assessment_id = 'DEMO399'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C4440' where assessment_id = 'DEMO405'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C44509' where assessment_id = 'DEMO331'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G3101' where assessment_id = 'DEMO7198'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K6289' where assessment_id = '0^11594'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N8189' where assessment_id = 'DEMO121'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N8189' where assessment_id = 'DEMO776'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O9122' where assessment_id = 'DEMO11288'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R509' where assessment_id = 'DEMO2102'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D460' where assessment_id = 'DEMO9209'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N8189' where assessment_id = 'DEMO789'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z4802' where assessment_id = 'DEMO1459'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z992' where assessment_id = 'DEMO1453'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z363 ' where assessment_id = '0^V28.0^0'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z1159' where assessment_id = '0^12307'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z1389' where assessment_id = 'DEMO9353'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6869' where assessment_id = 'DEMO11474'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D7581' where assessment_id = 'DEMO7563'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9341 ' where assessment_id = 'DEMO11477'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R6521' where assessment_id = 'DEMO11513'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R6521' where assessment_id = 'DEMO647A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R065' where assessment_id = 'HALITOS'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A8109' where assessment_id = 'DEMO4164'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J9809 ' where assessment_id = 'BROS'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K121' where assessment_id = 'STOMA'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P122' where assessment_id = 'DEMOCAP1'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='P122' where assessment_id = 'DEMOCAP2'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K650' where assessment_id = 'DEMO7929'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K650' where assessment_id = 'DEMO7930'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q256' where assessment_id = 'DEMO6041'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I7409' where assessment_id = 'DEMO1898'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G92' where assessment_id = 'DEMO7179'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J9809 ' where assessment_id = 'DEMO11485'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J9809 ' where assessment_id = 'DEMO11486'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M2630' where assessment_id = 'DEMO7631'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A154' where assessment_id = 'DEMO4042'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A156' where assessment_id = 'DEMO4041'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A1815' where assessment_id = 'DEMO8929'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z384' where assessment_id = 'EXAMBIRTH3'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K626' where assessment_id = '0^11612'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K2210' where assessment_id = 'DEMO11488'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K2211' where assessment_id = 'DEMO11489'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q514' where assessment_id = 'DEMO5913'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R69' where assessment_id = 'DEMO11519'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R3981' where assessment_id = 'DEMO1258A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N139' where assessment_id = 'DEMO7052'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z23' where assessment_id = 'DEMO716'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A9230' where assessment_id = 'DEMO10011'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z52000' where assessment_id = 'DEMO9248'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z9849' where assessment_id = '0^12289'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z029' where assessment_id = 'DEMO11396'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E83119' where assessment_id = 'DEMO185'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='I87009' where assessment_id = 'DEMO1972'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N3289' where assessment_id = 'DEMO338'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J3489' where assessment_id = 'DEMO4916'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N3289' where assessment_id = 'DEMO9980'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N8110' where assessment_id = 'DEMO9981'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='J9383' where assessment_id = 'PNEUM'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K6289' where assessment_id = '0^11596'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='M5126' where assessment_id = '000125x'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G9001' where assessment_id = 'CAROTID'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='A5449' where assessment_id = 'DEMO8017'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z8349' where assessment_id = 'DEMO1121'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E2609' where assessment_id = 'DEMO11459'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z9641' where assessment_id = 'DEMO11534'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R918' where assessment_id = 'DEMO1295'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R7611' where assessment_id = 'DEMO1311'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='R0989' where assessment_id = 'DEMO2116'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T7402XA' where assessment_id = 'DEMO3340'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T792XXA ' where assessment_id = 'DEMO3828A'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q398' where assessment_id = 'DEMO5843'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q510' where assessment_id = 'DEMO5911'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q551' where assessment_id = 'DEMO5933'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q554' where assessment_id = 'DEMO5934'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q554' where assessment_id = 'DEMO5936'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q554' where assessment_id = 'DEMO5937'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q550' where assessment_id = 'DEMO5938'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q550' where assessment_id = 'DEMO5939'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q934' where assessment_id = 'DEMO6078'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Q7649' where assessment_id = 'DEMO6261'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N2589' where assessment_id = 'DEMO6967'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N3289' where assessment_id = 'DEMO7032'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G0402' where assessment_id = 'DEMO7177'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='G242' where assessment_id = 'DEMO7219'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D561' where assessment_id = 'DEMO7435'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D569' where assessment_id = 'DEMO7436'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D5740' where assessment_id = 'DEMO7439'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='F09' where assessment_id = 'DEMO9607'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D68318' where assessment_id = 'DEMO7484'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D6832' where assessment_id = 'DEMO7487'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D709' where assessment_id = 'DEMO7508'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D702' where assessment_id = 'DEMO7509'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D704' where assessment_id = 'DEMO7510'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E8809' where assessment_id = 'DEMO7564'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K0389' where assessment_id = 'DEMO7598'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K121' where assessment_id = 'ULCM'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='K0389' where assessment_id = 'DEMO7599'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='N8500' where assessment_id = 'DEMO817'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O020' where assessment_id = 'DEMO869'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='O0080' where assessment_id = 'DEMO873'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='D479' where assessment_id = 'DEMO9206'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z5111' where assessment_id = 'DEMO9267'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='Z6332' where assessment_id = 'DEMO9489'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='T8029XA' where assessment_id = 'DEMO11337'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='E2609' where assessment_id = 'DEMO11462'
update c_Assessment_Definition set last_updated=getdate(), icd10_code ='C44300' where assessment_id = 'DEMO8286'

