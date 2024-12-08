SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GRANT DELETE ON [icd_block] TO [cprsystem] AS [dbo]
GRANT INSERT ON [icd_block] TO [cprsystem] AS [dbo]
GRANT SELECT ON [icd_block] TO [cprsystem] AS [dbo]
GRANT UPDATE ON [icd_block] TO [cprsystem] AS [dbo]
