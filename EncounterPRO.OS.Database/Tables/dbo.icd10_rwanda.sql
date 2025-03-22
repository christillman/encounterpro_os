SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[icd10_rwanda]') AND type in (N'U'))
BEGIN
CREATE TABLE [icd10_rwanda](
	[code] [varchar](10) NOT NULL,
	[descr] [varchar](255) NOT NULL
) ON [PRIMARY]
END
GRANT SELECT ON [icd10_rwanda] TO [cprsystem] AS [dbo]
