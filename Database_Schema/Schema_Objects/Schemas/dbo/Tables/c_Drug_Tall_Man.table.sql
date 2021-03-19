

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'c_Drug_Tall_Man') AND type in (N'U'))
	DROP TABLE c_Drug_Tall_Man
GO
CREATE TABLE c_Drug_Tall_Man (spelling COLLATE SQL_Latin1_General_CP1_CS_AS varchar(50) NOT NULL)

ALTER TABLE [c_Drug_Tall_Man]
ADD CONSTRAINT PK_TallMan PRIMARY KEY (spelling)

GRANT DELETE, INSERT, SELECT, UPDATE ON c_Drug_Tall_Man TO [cprsystem] AS [dbo]
GO

