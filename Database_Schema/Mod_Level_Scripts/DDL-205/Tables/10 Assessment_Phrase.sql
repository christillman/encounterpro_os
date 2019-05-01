IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Assessment_Parsed]') AND type in (N'U'))
DROP TABLE [c_Assessment_Parsed]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Assessment_Parsed]') AND type in (N'U'))
BEGIN
CREATE TABLE [c_Assessment_Parsed](
	[icd10_code] [varchar](10) NOT NULL,
	[phrase_id] [int] NOT NULL,
	[position] [smallint] NULL,
 CONSTRAINT [PK_c_Assessment_Parsed] PRIMARY KEY CLUSTERED 
(
	[icd10_code] ASC,
	[phrase_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Assessment_Phrase]') AND type in (N'U'))
DROP TABLE [c_Assessment_Phrase]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Assessment_Phrase]') AND type in (N'U'))
BEGIN
CREATE TABLE [c_Assessment_Phrase](
	[phrase_id] [int] IDENTITY(1,1) NOT NULL,
	[phrase] [varchar](500) NULL,
	[phrase_type] [varchar](3) NULL,
	[phrase_group] [varchar](30) NULL,
 CONSTRAINT [PK_c_Assessment_Phrase] PRIMARY KEY CLUSTERED 
(
	[phrase_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

GRANT DELETE ON [c_Assessment_Phrase] TO [cprsystem] AS [dbo]
GO

GRANT INSERT ON [c_Assessment_Phrase] TO [cprsystem] AS [dbo]
GO

GRANT SELECT ON [c_Assessment_Phrase] TO [cprsystem] AS [dbo]
GO

GRANT UPDATE ON [c_Assessment_Phrase] TO [cprsystem] AS [dbo]
GO


SET ANSI_PADDING OFF
GO

GRANT DELETE ON [c_Assessment_Parsed] TO [cprsystem] AS [dbo]
GO

GRANT INSERT ON [c_Assessment_Parsed] TO [cprsystem] AS [dbo]
GO

GRANT SELECT ON [c_Assessment_Parsed] TO [cprsystem] AS [dbo]
GO

GRANT UPDATE ON [c_Assessment_Parsed] TO [cprsystem] AS [dbo]
GO



create index PK_phrase on c_Assessment_Phrase (phrase)