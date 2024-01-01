DELETE FROM [icd10cm_codes_2019]
GO

BULK INSERT [icd10cm_codes_2019]
FROM '\\localhost\attachments\icd10cm_codes_2019.txt'
WITH (FORMATFILE = '\\localhost\attachments\icd10cm_codes.fmt')
GO


-- clean up
UPDATE icd10cm_codes_2019
SET descr = replace(RTRIM(descr),'   ',' ')
WHERE descr LIKE '%   %'

UPDATE icd10cm_codes_2019
SET descr = replace(RTRIM(descr),'  ',' ')
WHERE descr LIKE '%  %'

UPDATE icd10cm_codes_2019
SET code = RTRIM(code)
WHERE code != RTRIM(code)

UPDATE icd10cm_codes_2019
SET descr = RTRIM(descr)
WHERE descr != RTRIM(descr)

DELETE FROM [icd10cm_codes]
GO

INSERT INTO [icd10cm_codes]
SELECT * FROM icd10cm_codes_2019

GO
