SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[icd10_who]') AND type in (N'U'))
BEGIN
CREATE TABLE [icd10_who](
	[code] [varchar](10) NOT NULL,
	[descr] [varchar](500) NOT NULL,
	[active] [varchar](1) NULL
) ON [PRIMARY]
END
GRANT SELECT ON [icd10_who] TO [cprsystem] AS [dbo]
