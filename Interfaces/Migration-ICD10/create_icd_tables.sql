

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10cm_codes_2019')
	BEGIN DROP TABLE icd10cm_codes_2019 END

CREATE TABLE icd10cm_codes_2019 (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO