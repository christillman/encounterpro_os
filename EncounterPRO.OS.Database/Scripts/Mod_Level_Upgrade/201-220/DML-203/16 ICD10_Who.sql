DELETE FROM [icd10_rwanda]
GO

BULK INSERT [icd10_rwanda]
FROM '\\localhost\attachments\Rwanda_icd10.txt'
WITH (FORMATFILE = '\\localhost\attachments\Rwanda_icd10.fmt')

GO

DELETE FROM [icd10_who]
GO

BULK INSERT [icd10_who]
FROM '\\localhost\attachments\icd10_who.txt'
WITH (FORMATFILE = '\\localhost\attachments\icd10_who.fmt')

GO