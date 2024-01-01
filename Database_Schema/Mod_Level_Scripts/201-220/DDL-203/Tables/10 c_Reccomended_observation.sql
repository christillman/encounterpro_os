

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- Drop unused (and misspelt) table
Print 'Drop Table [dbo].[c_Reccomended_Observation]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Reccomended_Observation]') AND [type]='U'))
	DROP TABLE [dbo].[c_Reccomended_Observation]
GO

-- Missing permission from previous release
GRANT SELECT ON [dbo].[icd10cm_codes_2018] TO CPRSYSTEM

GO
