IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[p_Observation_Comment_Save]') AND type in (N'U'))
DROP TABLE [p_Observation_Comment_Save]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [p_Observation_Comment_Save](
	[cpr_id] [varchar](12) NOT NULL,
	[observation_sequence] [int] NOT NULL,
	[Observation_comment_id] [int] IDENTITY(1,1) NOT NULL,
	[observation_id] [varchar](24) NOT NULL,
	[comment_date_time] [datetime] NOT NULL,
	[comment_type] [varchar](24) NOT NULL,
	[comment_title] [varchar](48) NULL,
	[short_comment] [varchar](40) NULL,
	[comment] [nvarchar](max) NULL,
	[abnormal_flag] [char](1) NULL,
	[severity] [smallint] NULL,
	[treatment_id] [int] NULL,
	[encounter_id] [int] NULL,
	[attachment_id] [int] NULL,
	[user_id] [varchar](24) NOT NULL,
	[current_flag] [char](1) NOT NULL,
	[root_observation_sequence] [int] NULL,
	[created_by] [varchar](24) NOT NULL,
	[created] [datetime] NULL,
	[id] [uniqueidentifier] NOT NULL
) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Observation_Comment_Save] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Observation_Comment_Save] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Observation_Comment_Save] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Observation_Comment_Save] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Observation_Comment_Save] TO [cprsystem]
GO
