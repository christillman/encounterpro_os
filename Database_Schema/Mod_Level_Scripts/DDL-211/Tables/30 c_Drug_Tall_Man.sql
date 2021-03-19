
ALTER TABLE [c_Drug_Tall_Man]
ALTER COLUMN spelling varchar(50) NOT NULL
GO
ALTER TABLE [c_Drug_Tall_Man]
ADD CONSTRAINT PK_TallMan PRIMARY KEY (spelling)
