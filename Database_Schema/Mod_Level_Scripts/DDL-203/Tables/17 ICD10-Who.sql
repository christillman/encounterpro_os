

CREATE TABLE icd10_who_xml
(
Id INT IDENTITY PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)

CREATE TABLE icd10_who
(
code varchar(10),
descr varchar(500),
active varchar(1)
)

INSERT INTO icd10_who_xml(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK 'C:\Users\tofft\EncounterPro\ICD\health_icd10\data\diseases.xml', SINGLE_BLOB) AS x;


DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)
SELECT @XML = XMLData FROM icd10_who_xml

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

INSERT INTO icd10_who (code, descr, active)
SELECT ID, Descr, CASE WHEN Active = 'True' THEN 'Y' ELSE 'N' END
FROM OPENXML(@hDoc, 'tryton/data/record')
WITH 
(
ID [varchar](50) '@id',
Descr [varchar](100) 'field[1]',
Active [varchar](5) 'field[4]'
)


EXEC sp_xml_removedocument @hDoc
GO

select count(*) from  icd10_who r 
where not exists (select 1 from
 icd10cm_codes w where w.code = r.code)

select count(*) from icd10cm_codes where code != rtrim(code)
 where code like 'F79%' or code like 'Z32%'

SELECT d.icd10_who_code
FROM c_Assessment_Definition d
JOIN icd10_who w ON w.code = d.icd10_who_code
JOIN icd10_rwanda r on r.code = d.icd10_who_code
WHERE w.active = 'N'

select * from icd10_who
where len(descr) = 100
order by code