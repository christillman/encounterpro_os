IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[c_Query_Term]') AND type in (N'U'))
DROP TABLE [c_Query_Term]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [c_Query_Term](
	[query_target] [varchar](24) NOT NULL,
	[user_query_term] [varchar](24) NOT NULL,
	[query_term] [varchar](250) NOT NULL,
	[sort_sequence] [int] NULL,
	[status] [varchar](10) NULL
) ON [PRIMARY]
GO
