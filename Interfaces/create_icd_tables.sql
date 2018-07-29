
USE interfaces
GO

IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10cm_codes_2018')
	BEGIN DROP TABLE icd10cm_codes_2018 END
IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10pcs_codes_2019')
	BEGIN DROP TABLE icd10pcs_codes_2019 END
GO
IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd10_gem')
	BEGIN DROP TABLE icd10_gem END
IF EXISTS (SELECT 1 FROM sys.tables WHERE type = 'U' AND name = 'icd9_gem')
	BEGIN DROP TABLE icd9_gem END
GO

CREATE TABLE icd10cm_codes_2018 (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)

CREATE TABLE icd10pcs_codes_2019 (
	code varchar(10) NOT NULL,
	descr varchar(255) NOT NULL
)
GO

CREATE TABLE icd10_gem (
	icd10_code varchar(10) NOT NULL,
	icd9_code varchar(10) NOT NULL,
	flags varchar(5)
)

CREATE TABLE icd9_gem (
	icd9_code varchar(10) NOT NULL,
	icd10_code varchar(10) NOT NULL,
	flags varchar(5)
)
GO