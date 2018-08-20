

BULK INSERT [icd10cm_codes_2019]
FROM '\\localhost\attachments\icd10cm_codes_2019.txt'
WITH (FORMATFILE = '\\localhost\attachments\icd10cm_codes.fmt')

UPDATE [icd10cm_codes_2019]
SET code = RTRIM(code), descr = RTRIM(descr)
WHERE 1 = 1
GO

