
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vw_Loinc_Active')
	BEGIN DROP VIEW vw_Loinc_Active END

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vw_RXNCONSO_Active')
	BEGIN DROP VIEW vw_RXNCONSO_Active END
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vw_RXNCONSO_Prescribable')
	BEGIN DROP VIEW vw_RXNCONSO_Prescribable END

IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vw_RXNSAT_Active')
	BEGIN DROP VIEW vw_RXNSAT_Active END
IF EXISTS (SELECT 1 FROM sys.views WHERE name = 'vw_RXNSAT_Prescribable')
	BEGIN DROP VIEW vw_RXNSAT_Prescribable END

GO
CREATE VIEW vw_Loinc_Active AS
SELECT * FROM [interfaces].[dbo].Loinc WHERE status in ('TRIAL','ACTIVE');
GO

CREATE VIEW vw_RXNCONSO_Active AS
SELECT [RXCUI]
      ,[LAT]
      ,[RXAUI]
      ,[SAB]
      ,[TTY]
      ,[CODE]
      ,[STR]
FROM [interfaces].[dbo].RXNCONSO 
WHERE suppress = 'N';
GO

CREATE VIEW vw_RXNCONSO_Prescribable AS
SELECT [RXCUI]
      ,[LAT]
      ,[RXAUI]
      ,[SAB]
      ,[TTY]
      ,[CODE]
      ,[STR]
FROM [interfaces].[dbo].RXNCONSO 
WHERE CVF = '4096	';

GO

CREATE VIEW vw_RXNSAT_Active AS
SELECT [RXCUI]
      ,[RXAUI]
      ,[STYPE]
      ,[CODE]
      ,[ATUI]
      ,[ATN]
      ,[SAB]
      ,[ATV]
FROM [interfaces].[dbo].[RXNSAT]
WHERE suppress = 'N';
GO


CREATE VIEW vw_RXNSAT_Prescribable AS
SELECT [RXCUI]
      ,[RXAUI]
      ,[STYPE]
      ,[CODE]
      ,[ATUI]
      ,[ATN]
      ,[SAB]
      ,[ATV]
FROM [interfaces].[dbo].[RXNSAT]
WHERE CVF = '4096	';
GO

