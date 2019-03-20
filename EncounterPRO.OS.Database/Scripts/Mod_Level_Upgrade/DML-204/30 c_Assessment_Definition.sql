
UPDATE c_Assessment_Definition SET long_description = NULL
WHERE long_description = description
-- 36660

-- Update description per ICD10 terminology, wherever only one assessment is affected
-- ProposedDescriptionFix-NonDuplicate.xlsx
SELECT icd10_code
into #uniq4
FROM c_Assessment_Definition
WHERE long_description IS NOT NULL
AND description NOT LIKE '%...'
AND description NOT LIKE '%…'
AND icd10_code IS NOT NULL
AND icd10_code NOT IN  (
-- avoid these, there are other records outside this set
'A5274',
'A799',
'B399',
'B9789',
'E8809',
'F09',
'F23',
'F340',
'F6381',
'G834',
'I018',
'I252',
'I509',
'I82409',
'J9620',
'K031',
'K043',
'K0520',
'K141',
'K5900',
'K623',
'K650',
'L305',
'L501',
'L503',
'L504',
'L505',
'L575',
'M2630',
'M790',
'N186',
'N481',
'O0000',
'O9989',
'P011',
'P017',
'P020',
'P023',
'P030',
'P032',
'P033',
'P034',
'P035',
'P0481',
'P0722',
'P0723',
'P0725',
'P0731',
'P0733',
'P0735',
'P0737',
'P0739',
'R3981',
'R453',
'R6520',
'R7881',
'R824',
'R930',
'T792XXA',
'T888XXA',
'Z01419',
'Z1401',
'Z302',
'Z464',
'Z569',
'Z6824',
'Z8639')
group by icd10_code
having count(*) = 1
-- 4940

-- 26 records had existing long_description which should be replaced by ICD10
UPDATE d
SET long_description = i.descr
-- SELECT d.icd10_code, d.long_description, i.descr
FROM c_Assessment_Definition d
JOIN icd10cm_codes i ON i.code = d.icd10_code
WHERE icd10_code IN (SELECT icd10_code FROM #uniq4)
AND d.long_description != i.descr

UPDATE c_Assessment_Definition
SET description = long_description, long_description = NULL
WHERE icd10_code IN (SELECT icd10_code FROM #uniq4)
AND len(long_description) <= 80
-- 4429

UPDATE c_Assessment_Definition
SET description = SUBSTRING(long_description,1,77) + '...'
WHERE icd10_code IN (SELECT icd10_code FROM #uniq4)
AND len(long_description) > 80
-- 522

