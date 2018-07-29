

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

ALTER TABLE c_Assessment_Category 
	ADD icd10_start varchar(3), icd10_end  varchar(3)
GO
