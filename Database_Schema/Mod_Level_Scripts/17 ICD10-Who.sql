

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

select * from icd10_who