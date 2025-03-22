IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Synonym]') AND type in (N'U'))
DROP TABLE [c_Synonym]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Synonym](
	[term] [varchar](250) NOT NULL,
	[term_type] [varchar](30) NOT NULL,
	[alternate] [varchar](250) NOT NULL,
	[preferred_term] [varchar](250) NULL,
 CONSTRAINT [PK_Synonym] PRIMARY KEY CLUSTERED 
(
	[term_type] ASC,
	[term] ASC,
	[alternate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Synonym] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Synonym] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Synonym] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Synonym] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Synonym] TO [cprsystem]
GO
