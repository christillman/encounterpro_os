IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Drug_Tall_Man]') AND type in (N'U'))
DROP TABLE [c_Drug_Tall_Man]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Drug_Tall_Man](
	[spelling] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TallMan] PRIMARY KEY CLUSTERED 
(
	[spelling] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Drug_Tall_Man] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Drug_Tall_Man] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Drug_Tall_Man] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Drug_Tall_Man] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Drug_Tall_Man] TO [cprsystem]
GO
