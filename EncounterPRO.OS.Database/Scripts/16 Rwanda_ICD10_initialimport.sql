DELETE FROM [icd10_rwanda]
GO

BULK INSERT [icd10_rwanda]
FROM '\\localhost\attachments\Rwanda_icd10_list.txt'
WITH (FORMATFILE = '\\localhost\attachments\Rwanda_icd10.fmt')
GO

-- eliminate the decimal points
UPDATE icd10_rwanda
SET code = replace(code,'.','')
WHERE code LIKE '%.%'

-- clean up
UPDATE icd10_rwanda
SET descr = replace(RTRIM(descr),'_',',')
WHERE CHARINDEX('_', descr) > 0

UPDATE icd10_rwanda
SET descr = replace(RTRIM(descr),'   ',' ')
WHERE descr LIKE '%   %'

UPDATE icd10_rwanda
SET descr = replace(RTRIM(descr),'  ',' ')
WHERE descr LIKE '%  %'

UPDATE icd10_rwanda
SET code = RTRIM(code)
WHERE code != RTRIM(code)

UPDATE icd10_rwanda
SET descr = RTRIM(descr)
WHERE descr != RTRIM(descr)

-- Titlecase and update terminology
-- (Retrieved ICD10-Who descriptions from GNU-Health open source project)
UPDATE r
SET descr = i.descr
FROM icd10_rwanda r
JOIN icd10_who i ON i.code = r.code

-- 2 records in Rwanda not same code in Who
--F798	UNSPECIFIED MENTAL RETARDATION, OTHER IMPAIRMENTS OF BEHAVIOUR
--Z321	PREGNANCY CONFIRMED
UPDATE icd10_rwanda 
SET descr = 'Unspecified mental retardation, other impairments of behaviour'
WHERE code = 'F798'
UPDATE icd10_rwanda 
SET descr = 'Pregnancy confirmed'
WHERE code = 'Z321'

GO