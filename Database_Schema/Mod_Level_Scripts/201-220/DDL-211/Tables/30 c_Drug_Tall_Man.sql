
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[PK_TallMan]') AND type = 'K')
	ALTER TABLE [c_Drug_Tall_Man]
	DROP CONSTRAINT PK_TallMan 

ALTER TABLE c_Drug_Tall_Man 
ALTER COLUMN spelling varchar(50) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL
GO

ALTER TABLE [c_Drug_Tall_Man]
ADD CONSTRAINT PK_TallMan PRIMARY KEY (spelling)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Tall_Man TO [cprsystem] AS [dbo]
GO

