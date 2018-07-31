

BULK INSERT [icd10cm_codes_2018]
FROM '\\localhost\attachments\icd10cm_codes_2018.txt'
WITH (FORMATFILE = '\\localhost\attachments\icd10cm_codes_2018.fmt')

UPDATE [icd10cm_codes_2018]
SET code = RTRIM(code), descr = RTRIM(descr)
WHERE 1 = 1
GO


BULK INSERT [icd9_gem]
FROM '\\localhost\attachments\2018_I9gem.txt'
WITH (FORMATFILE = '\\localhost\attachments\2018_I9gem.fmt')


UPDATE [icd9_gem]
SET icd10_code = RTRIM(icd10_code), icd9_code = RTRIM(icd9_code)
WHERE 1 = 1
GO
