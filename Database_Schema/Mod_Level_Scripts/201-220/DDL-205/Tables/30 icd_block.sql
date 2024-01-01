
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[icd_block]') AND type in (N'U'))
DROP TABLE [icd_block]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[icd_block]') AND type in (N'U'))
BEGIN
CREATE TABLE [icd_block](
	[block_id] [int] IDENTITY(1,1) NOT NULL,
	[chapter] [varchar](50) NULL,
	[range] [varchar](20) NULL,
	[descr] [varchar](100) NULL,
 CONSTRAINT [PK_icd_block] PRIMARY KEY CLUSTERED 
(
	[block_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

GRANT DELETE ON [icd_block] TO [cprsystem] AS [dbo]
GO

GRANT INSERT ON [icd_block] TO [cprsystem] AS [dbo]
GO

GRANT SELECT ON [icd_block] TO [cprsystem] AS [dbo]
GO

GRANT UPDATE ON [icd_block] TO [cprsystem] AS [dbo]
GO
